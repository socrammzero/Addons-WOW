'use strict';

const fs = require('node:fs');
const path = require('node:path');
const { spawn, execFileSync } = require('node:child_process');

const EDITABLE_EXTENSIONS = new Set(['.lua', '.html', '.toc', '.xml', '.json', '.txt', '.md']);
const JOURNEY_GUIDES_PREFIX = 'Journey/BundledContent/Guides/';
const MAX_SEARCH_MATCHES = 600;
const MAX_PREVIEW_FILES = 120;

/**
 * Normaliza separadores de ruta a '/' para presentar rutas relativas de forma uniforme.
 * @param {string} relPath
 * @returns {string}
 */
function toPosix(relPath) {
  return relPath.replace(/\\/g, '/');
}

/**
 * Lee y valida config.json del proyecto.
 * @param {string} projectRoot
 * @returns {{ wowAddonsPath: string, addons: Array<object> }}
 */
function readProjectConfig(projectRoot) {
  const cfgPath = path.join(projectRoot, 'config.json');
  if (!fs.existsSync(cfgPath)) {
    throw new Error('No se encontró config.json en la raíz del proyecto.');
  }
  const parsed = JSON.parse(fs.readFileSync(cfgPath, 'utf8').replace(/^\uFEFF/, ''));
  return {
    wowAddonsPath: typeof parsed.wowAddonsPath === 'string' ? parsed.wowAddonsPath : '',
    addons: Array.isArray(parsed.addons) ? parsed.addons : [],
  };
}

/**
 * Indica si una ruta relativa dentro de src/ corresponde a una guía Base64 de Journey.
 * @param {string} relPosixPath
 * @returns {boolean}
 */
function isJourneyGuidePath(relPosixPath) {
  return relPosixPath.startsWith(JOURNEY_GUIDES_PREFIX) && relPosixPath.toLowerCase().endsWith('.html');
}

/**
 * Verifica que una ruta relativa pertenezca estrictamente al directorio base indicado.
 * @param {string} baseDir
 * @param {string} relPathInput
 * @param {string} boundaryLabel
 * @returns {{ absPath: string, relPath: string }}
 */
function assertInsideDir(baseDir, relPathInput, boundaryLabel) {
  if (typeof relPathInput !== 'string' || !relPathInput.trim()) {
    throw new Error('Ruta de archivo vacía.');
  }
  if (relPathInput.includes('\0') || path.isAbsolute(relPathInput)) {
    throw new Error(`Ruta no permitida: debe ser una ruta relativa dentro de ${boundaryLabel}.`);
  }
  const resolvedRoot = path.resolve(baseDir);
  const resolvedTarget = path.resolve(resolvedRoot, relPathInput);
  if (
    resolvedTarget !== resolvedRoot &&
    !resolvedTarget.startsWith(resolvedRoot + path.sep)
  ) {
    throw new Error(`Ruta no permitida: acceso fuera del directorio ${boundaryLabel}.`);
  }
  return {
    absPath: resolvedTarget,
    relPath: toPosix(path.relative(resolvedRoot, resolvedTarget)),
  };
}

/**
 * Resuelve y valida que una ruta relativa pertenezca estrictamente a src/ y tenga extensión editable.
 * @param {string} srcRoot
 * @param {string} relPathInput
 * @returns {{ absPath: string, relPath: string, ext: string }}
 */
function resolveSrcFile(srcRoot, relPathInput) {
  const { absPath, relPath } = assertInsideDir(srcRoot, relPathInput, 'src/');
  const ext = path.extname(absPath).toLowerCase();
  if (!EDITABLE_EXTENSIONS.has(ext)) {
    throw new Error(`Extensión de archivo no editable: ${ext || '(sin extensión)'}`);
  }
  return { absPath, relPath, ext };
}

/**
 * Resuelve y valida una ruta dentro de la raíz del repositorio (prohibiendo .git/).
 * @param {string} projectRoot
 * @param {string} relPathInput
 * @returns {{ absPath: string, relPath: string }}
 */
function resolveRepoPath(projectRoot, relPathInput) {
  const { absPath, relPath } = assertInsideDir(projectRoot, relPathInput, 'el repositorio');
  if (!relPath || relPath === '.git' || relPath.startsWith('.git/')) {
    throw new Error('Ruta no permitida dentro del repositorio.');
  }
  return { absPath, relPath };
}

/**
 * Extrae y decodifica a UTF-8 el payload Lua en Base64 de un HTML de guía de Journey.
 * @param {string} rawHtml
 * @returns {{ header: string, footer: string, eol: string, lua: string }}
 */
function decodeJourneyHtml(rawHtml) {
  const cleanHtml = rawHtml.replace(/^\uFEFF/, '');
  const match = cleanHtml.match(/^([\s\S]*?<p>\r?\n)([\s\S]*?)(\r?\n\s*<\/p>[\s\S]*)$/);
  if (!match) {
    throw new Error('Formato HTML de guía de Journey no reconocido (falta bloque <p>...</p>).');
  }
  const b64 = match[2].replace(/\s+/g, '');
  const lua = Buffer.from(b64, 'base64').toString('utf8');
  return {
    header: match[1],
    footer: match[3],
    eol: cleanHtml.includes('\r\n') ? '\r\n' : '\n',
    lua,
  };
}

/**
 * Reempaqueta un texto Lua UTF-8 al formato HTML Base64 (76 columnas, sin BOM) de Journey.
 * @param {{ header: string, footer: string, eol: string }} templateParts
 * @param {string} luaText
 * @returns {string}
 */
function encodeJourneyHtml(templateParts, luaText) {
  const cleanLua = luaText.replace(/^\uFEFF/, '');
  const b64 = Buffer.from(cleanLua, 'utf8').toString('base64');
  const lines = [];
  for (let i = 0; i < b64.length; i += 76) {
    lines.push(b64.slice(i, i + 76));
  }
  return (templateParts.header + lines.join(templateParts.eol) + templateParts.footer).replace(/^\uFEFF/, '');
}

/**
 * Valida equilibrio de llaves, cadenas cerradas y reglas básicas de Lua.
 * @param {string} text
 * @param {{ isLua?: boolean, isJourneyGuide?: boolean }} [options]
 * @returns {{ valid: boolean, openBraces: number, closeBraces: number, errors: string[] }}
 */
function validateLuaText(text, options = {}) {
  const errors = [];
  if (typeof text !== 'string') {
    return { valid: false, openBraces: 0, closeBraces: 0, errors: ['Contenido inválido.'] };
  }
  if (text.charCodeAt(0) === 0xfeff) {
    errors.push('El archivo contiene BOM UTF-8.');
  }

  let openBraces = 0;
  let closeBraces = 0;
  let i = 0;

  while (i < text.length) {
    const ch = text[i];

    // Comentario Lua (-- o --[=[...]=])
    if (ch === '-' && text[i + 1] === '-') {
      const longMatch = text.slice(i + 2).match(/^\[(=*)\[/);
      if (longMatch) {
        const eq = longMatch[1];
        const endIdx = text.indexOf(`]${eq}]`, i + 2 + longMatch[0].length);
        if (endIdx === -1) {
          errors.push('Comentario multilínea --[[ sin cerrar.');
          break;
        }
        i = endIdx + eq.length + 2;
      } else {
        while (i < text.length && text[i] !== '\n') i++;
      }
      continue;
    }

    // Long string literal [=[...]=]
    if (ch === '[' && (text[i + 1] === '[' || text[i + 1] === '=')) {
      const longMatch = text.slice(i).match(/^\[(=*)\[/);
      if (longMatch) {
        const eq = longMatch[1];
        const endIdx = text.indexOf(`]${eq}]`, i + longMatch[0].length);
        if (endIdx === -1) {
          errors.push(`Cadena multilínea [${eq}[ sin cerrar.`);
          break;
        }
        i = endIdx + eq.length + 2;
        continue;
      }
    }

    // String entre comillas simples o dobles
    if (ch === '"' || ch === "'") {
      const quote = ch;
      i++;
      let closed = false;
      while (i < text.length) {
        if (text[i] === '\\') {
          if (text[i + 1] === '\r' && text[i + 2] === '\n') {
            i += 3;
          } else {
            i += 2;
          }
          continue;
        }
        if (text[i] === '\n' || text[i] === '\r') {
          break;
        }
        if (text[i] === quote) {
          closed = true;
          i++;
          break;
        }
        i++;
      }
      if (!closed) {
        errors.push(`Cadena entre comillas (${quote}) sin cerrar.`);
      }
      continue;
    }

    if (ch === '{') openBraces++;
    else if (ch === '}') closeBraces++;
    i++;
  }

  if (openBraces !== closeBraces) {
    errors.push(`Desequilibrio de llaves Lua: { = ${openBraces}, } = ${closeBraces}.`);
  }

  if (options.isJourneyGuide) {
    const trimmed = text.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      errors.push('Una guía de Journey debe empezar por "{" y terminar por "}".');
    }
  }

  return {
    valid: errors.length === 0,
    openBraces,
    closeBraces,
    errors,
  };
}

/**
 * Extrae metadatos (descripción, facción, nivel, grupo) de cada slot desde el Lua de guides.html.
 * @param {string} catalogLua
 * @returns {Record<string, { guideID: string, description: string, faction: string, levels: string, group: string }>}
 */
function parseGuidesCatalogLua(catalogLua) {
  const byFile = {};
  const blocks = catalogLua.split(/\r?\n\{\r?\n/);
  for (const block of blocks) {
    const slotMatch = block.match(/\bslot\s*=\s*(\d+)/);
    if (!slotMatch) continue;
    const fileName = `${String(slotMatch[1]).padStart(4, '0')}.html`;
    const extractField = (name) => {
      const m = block.match(new RegExp(`\\b${name}\\s*=\\s*"((?:[^"\\\\]|\\\\.)*)"`));
      return m ? m[1].replace(/\\"/g, '"') : '';
    };
    byFile[fileName] = {
      guideID: extractField('guideID'),
      description: extractField('description'),
      faction: extractField('faction'),
      levels: extractField('levels'),
      group: extractField('group'),
    };
  }
  return byFile;
}

/**
 * Carga el mapa de metadatos de guías desde src/Journey/BundledContent/Guides/guides.html si existe.
 * @param {string} projectRoot
 * @returns {Record<string, object>}
 */
function loadJourneyGuidesMeta(projectRoot) {
  const catalogPath = path.join(projectRoot, 'src', 'Journey', 'BundledContent', 'Guides', 'guides.html');
  if (!fs.existsSync(catalogPath)) return {};
  try {
    const decoded = decodeJourneyHtml(fs.readFileSync(catalogPath, 'utf8'));
    return parseGuidesCatalogLua(decoded.lua);
  } catch {
    return {};
  }
}

/**
 * Lista todos los archivos editables dentro de src/ con información del addon y metadatos de guía.
 * @param {string} projectRoot
 * @returns {Array<{ relPath: string, addon: string, ext: string, isJourneyGuide: boolean, guideMeta: object|null }>}
 */
function listEditableFiles(projectRoot) {
  const srcRoot = path.join(projectRoot, 'src');
  if (!fs.existsSync(srcRoot)) return [];
  const guidesMeta = loadJourneyGuidesMeta(projectRoot);
  const results = [];

  function walk(dir) {
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        walk(fullPath);
        continue;
      }
      const ext = path.extname(entry.name).toLowerCase();
      if (!EDITABLE_EXTENSIONS.has(ext)) continue;

      const relPath = toPosix(path.relative(srcRoot, fullPath));
      const addon = relPath.split('/')[0] || '';
      const isGuide = isJourneyGuidePath(relPath);
      const baseName = path.basename(relPath);
      let guideMeta = null;
      if (isGuide) {
        guideMeta = baseName === 'guides.html'
          ? { guideID: 'CATALOG', description: 'Catálogo maestro de guías', faction: '', levels: '', group: 'Índice' }
          : (guidesMeta[baseName] || null);
      }

      results.push({ relPath, addon, ext, isJourneyGuide: isGuide, guideMeta });
    }
  }

  walk(srcRoot);
  results.sort((a, b) => a.relPath.localeCompare(b.relPath));
  return results;
}

/**
 * Lee el contenido editable (decodificado en caso de guía Journey) de un archivo en src/.
 * @param {string} projectRoot
 * @param {string} relPathInput
 * @returns {{ relPath: string, addon: string, ext: string, isJourneyGuide: boolean, guideMeta: object|null, content: string, templateParts?: object }}
 */
function readEditableFile(projectRoot, relPathInput) {
  const srcRoot = path.join(projectRoot, 'src');
  const { absPath, relPath, ext } = resolveSrcFile(srcRoot, relPathInput);
  if (!fs.existsSync(absPath)) {
    throw new Error(`El archivo no existe: ${relPath}`);
  }
  const raw = fs.readFileSync(absPath, 'utf8').replace(/^\uFEFF/, '');
  const isGuide = isJourneyGuidePath(relPath);
  const addon = relPath.split('/')[0] || '';
  const guidesMeta = isGuide ? loadJourneyGuidesMeta(projectRoot) : {};
  const baseName = path.basename(relPath);
  const guideMeta = isGuide
    ? (baseName === 'guides.html'
        ? { guideID: 'CATALOG', description: 'Catálogo maestro de guías', faction: '', levels: '', group: 'Índice' }
        : (guidesMeta[baseName] || null))
    : null;

  if (isGuide) {
    const decoded = decodeJourneyHtml(raw);
    return {
      relPath,
      addon,
      ext,
      isJourneyGuide: true,
      guideMeta,
      content: decoded.lua,
      templateParts: { header: decoded.header, footer: decoded.footer, eol: decoded.eol },
    };
  }

  return {
    relPath,
    addon,
    ext,
    isJourneyGuide: false,
    guideMeta: null,
    content: raw,
  };
}

/**
 * Escribe de forma atómica y en UTF-8 sin BOM un texto sobre absPath.
 * @param {string} absPath
 * @param {string} content
 */
function writeUtf8NoBom(absPath, content) {
  const clean = content.replace(/^\uFEFF/, '');
  const tmpPath = `${absPath}.tmp-${process.pid}-${Date.now()}`;
  fs.writeFileSync(tmpPath, clean, { encoding: 'utf8' });
  fs.renameSync(tmpPath, absPath);
}

/**
 * Valida y guarda un archivo editado dentro de src/.
 * @param {string} projectRoot
 * @param {string} relPathInput
 * @param {string} newContent
 * @returns {{ ok: boolean, relPath?: string, validation?: object, errors?: string[] }}
 */
function saveEditableFile(projectRoot, relPathInput, newContent) {
  const fileData = readEditableFile(projectRoot, relPathInput);
  const srcRoot = path.join(projectRoot, 'src');
  const { absPath } = resolveSrcFile(srcRoot, fileData.relPath);

  if (fileData.ext === '.lua' || fileData.isJourneyGuide) {
    const validation = validateLuaText(newContent, {
      isLua: true,
      isJourneyGuide: fileData.isJourneyGuide,
    });
    if (!validation.valid) {
      return { ok: false, relPath: fileData.relPath, validation, errors: validation.errors };
    }
  }

  const diskContent = fileData.isJourneyGuide
    ? encodeJourneyHtml(fileData.templateParts, newContent)
    : newContent;

  writeUtf8NoBom(absPath, diskContent);
  return { ok: true, relPath: fileData.relPath };
}

/**
 * Construye una expresión regular segura para buscar texto literal o regex.
 * @param {string} query
 * @param {{ matchCase?: boolean, wholeWord?: boolean, useRegex?: boolean }} [opts]
 * @returns {RegExp}
 */
function buildSearchRegex(query, opts = {}) {
  if (typeof query !== 'string' || !query.length) {
    throw new Error('El texto de búsqueda no puede estar vacío.');
  }
  let source = opts.useRegex ? query : query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  if (opts.wholeWord) {
    source = `(?<![\\p{L}\\p{N}_])${source}(?![\\p{L}\\p{N}_])`;
  }
  const flags = opts.matchCase ? 'gu' : 'giu';
  return new RegExp(source, flags);
}

/**
 * Filtra archivos según addon y ámbito (todos, solo guías de Journey, o solo .lua).
 * @param {string} projectRoot
 * @param {{ addon?: string, scope?: string, paths?: string[] }} [filters]
 */
function filterTargetFiles(projectRoot, filters = {}) {
  let files = listEditableFiles(projectRoot);
  if (Array.isArray(filters.paths) && filters.paths.length > 0) {
    const allowedSet = new Set(filters.paths.map((p) => toPosix(p)));
    files = files.filter((f) => allowedSet.has(f.relPath));
  }
  if (filters.addon && filters.addon !== 'ALL') {
    files = files.filter((f) => f.addon === filters.addon);
  }
  if (filters.scope === 'guides') {
    files = files.filter((f) => f.isJourneyGuide);
  } else if (filters.scope === 'lua') {
    files = files.filter((f) => f.ext === '.lua');
  }
  return files;
}

/**
 * Busca coincidencias en los archivos filtrados de src/ (decodificando las guías de Journey).
 * @param {string} projectRoot
 * @param {object} params
 */
function searchInRoot(projectRoot, params) {
  const rx = buildSearchRegex(params.query, params);
  const files = filterTargetFiles(projectRoot, params);
  const matchedFiles = [];
  let totalMatches = 0;
  let truncated = false;

  for (const fileInfo of files) {
    let data;
    try {
      data = readEditableFile(projectRoot, fileInfo.relPath);
    } catch {
      continue;
    }

    const lines = data.content.split(/\r?\n/);
    const fileMatches = [];
    for (let idx = 0; idx < lines.length; idx++) {
      const lineText = lines[idx];
      rx.lastIndex = 0;
      const lineHits = [...lineText.matchAll(rx)];
      if (lineHits.length === 0) continue;
      totalMatches += lineHits.length;
      if (matchedFiles.reduce((acc, f) => acc + f.matches.length, 0) + fileMatches.length < MAX_SEARCH_MATCHES) {
        fileMatches.push({
          line: idx + 1,
          text: lineText.trim().slice(0, 260),
          count: lineHits.length,
        });
      } else {
        truncated = true;
      }
    }

    if (fileMatches.length > 0) {
      matchedFiles.push({
        relPath: fileInfo.relPath,
        addon: fileInfo.addon,
        isJourneyGuide: fileInfo.isJourneyGuide,
        guideMeta: fileInfo.guideMeta,
        matches: fileMatches,
      });
    }
  }

  return { totalMatches, truncated, files: matchedFiles };
}

/**
 * Calcula una vista previa sin modificar disco ni comprometer la sintaxis Lua.
 * @param {string} projectRoot
 * @param {object} params
 */
function previewReplaceInRoot(projectRoot, params) {
  if (typeof params.replace !== 'string') {
    throw new Error('El texto de reemplazo es obligatorio.');
  }
  const rx = buildSearchRegex(params.find, params);
  const files = filterTargetFiles(projectRoot, params);
  const previews = [];
  let totalReplacements = 0;
  const validationErrors = [];

  for (const fileInfo of files) {
    let data;
    try {
      data = readEditableFile(projectRoot, fileInfo.relPath);
    } catch {
      continue;
    }

    rx.lastIndex = 0;
    if (!rx.test(data.content)) continue;

    const lines = data.content.split(/\r?\n/);
    const changes = [];
    const eol = data.content.includes('\r\n') ? '\r\n' : '\n';
    const updatedLines = [];

    for (let idx = 0; idx < lines.length; idx++) {
      const line = lines[idx];
      rx.lastIndex = 0;
      const hits = [...line.matchAll(rx)];
      if (hits.length > 0) {
        rx.lastIndex = 0;
        const nextLine = line.replace(rx, () => params.replace);
        if (nextLine !== line) {
          totalReplacements += hits.length;
          changes.push({
            line: idx + 1,
            before: line.trim().slice(0, 260),
            after: nextLine.trim().slice(0, 260),
          });
        }
        updatedLines.push(nextLine);
      } else {
        updatedLines.push(line);
      }
    }

    if (changes.length === 0) continue;
    const updatedContent = updatedLines.join(eol);

    if (fileInfo.ext === '.lua' || fileInfo.isJourneyGuide) {
      const check = validateLuaText(updatedContent, {
        isLua: true,
        isJourneyGuide: fileInfo.isJourneyGuide,
      });
      if (!check.valid) {
        validationErrors.push({ relPath: fileInfo.relPath, errors: check.errors });
      }
    }

    if (previews.length < MAX_PREVIEW_FILES) {
      previews.push({
        relPath: fileInfo.relPath,
        isJourneyGuide: fileInfo.isJourneyGuide,
        guideMeta: fileInfo.guideMeta,
        changes,
        _nextContent: updatedContent,
        _fileData: data,
      });
    }
  }

  return {
    totalReplacements,
    filesCount: previews.length,
    validationErrors,
    files: previews.map(({ _nextContent, _fileData, ...rest }) => rest),
    _pendingWrites: previews,
  };
}

/**
 * Ejecuta el reemplazo masivo solo si TODOS los archivos afectados superan la validación Lua.
 * @param {string} projectRoot
 * @param {object} params
 */
function applyReplaceInRoot(projectRoot, params) {
  const preview = previewReplaceInRoot(projectRoot, params);
  if (preview.validationErrors.length > 0) {
    return {
      ok: false,
      errors: preview.validationErrors,
      updatedFiles: [],
      totalReplacements: 0,
    };
  }

  const srcRoot = path.join(projectRoot, 'src');
  const updatedFiles = [];
  for (const item of preview._pendingWrites) {
    const { absPath } = resolveSrcFile(srcRoot, item.relPath);
    const diskContent = item._fileData.isJourneyGuide
      ? encodeJourneyHtml(item._fileData.templateParts, item._nextContent)
      : item._nextContent;
    writeUtf8NoBom(absPath, diskContent);
    updatedFiles.push(item.relPath);
  }

  return {
    ok: true,
    errors: [],
    updatedFiles,
    totalReplacements: preview.totalReplacements,
  };
}

/**
 * Ejecuta la validación global de guías Base64 de Journey y archivos Lua sin BOM en src/.
 * @param {string} projectRoot
 */
function validateProjectIntegrity(projectRoot) {
  const files = listEditableFiles(projectRoot);
  let checkedGuides = 0;
  let checkedLua = 0;
  const errors = [];

  for (const f of files) {
    const absPath = path.join(projectRoot, 'src', f.relPath);
    const buf = fs.readFileSync(absPath);
    const hasBom = buf.length >= 3 && buf[0] === 0xef && buf[1] === 0xbb && buf[2] === 0xbf;
    if (hasBom && (f.ext === '.lua' || f.isJourneyGuide)) {
      errors.push({ relPath: f.relPath, errors: ['Contiene BOM UTF-8.'] });
    }

    if (f.isJourneyGuide) {
      checkedGuides++;
      try {
        const data = readEditableFile(projectRoot, f.relPath);
        const check = validateLuaText(data.content, { isLua: true, isJourneyGuide: true });
        if (!check.valid) errors.push({ relPath: f.relPath, errors: check.errors });
      } catch (err) {
        errors.push({ relPath: f.relPath, errors: [err.message] });
      }
    } else if (f.ext === '.lua') {
      checkedLua++;
      try {
        new TextDecoder('utf-8', { fatal: true }).decode(buf);
      } catch {
        errors.push({ relPath: f.relPath, errors: ['Codificación UTF-8 inválida.'] });
      }
    }
  }

  return {
    ok: errors.length === 0,
    checkedGuides,
    checkedLua,
    errors,
  };
}

/**
 * Obtiene el estado completo de Git en el repositorio (rama, commits pendientes de push y archivos modificados).
 * @param {string} projectRoot
 */
function getGitRepoStatus(projectRoot) {
  try {
    const out = execFileSync('git', ['status', '--porcelain=v1', '-b', '-z', '-u'], {
      cwd: projectRoot,
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'pipe'],
    });
    const tokens = out.split('\0').filter((t) => t.length > 0);
    let branch = '';
    let upstream = '';
    let ahead = 0;
    let behind = 0;
    const modified = [];

    for (let i = 0; i < tokens.length; i++) {
      const tok = tokens[i];
      if (tok.startsWith('## ')) {
        const header = tok.slice(3);
        const [branchPart, aheadBehindPart] = header.split(' [');
        const [localBr, remoteBr] = branchPart.split('...');
        branch = (localBr || '').trim();
        upstream = (remoteBr || '').trim();
        if (aheadBehindPart) {
          const mAhead = aheadBehindPart.match(/ahead (\d+)/);
          const mBehind = aheadBehindPart.match(/behind (\d+)/);
          if (mAhead) ahead = Number(mAhead[1]);
          if (mBehind) behind = Number(mBehind[1]);
        }
        continue;
      }

      const xy = tok.slice(0, 2);
      const rawPath = toPosix(tok.slice(3));
      if (xy.includes('R') || xy.includes('C')) {
        i++; // saltar ruta origen en renombrado/copia con -z
      }
      const inSrc = rawPath.startsWith('src/');
      modified.push({
        status: xy.trim() || 'M',
        path: rawPath,
        inSrc,
        srcPath: inSrc ? rawPath.slice(4) : null,
      });
    }

    return { available: true, branch, upstream, ahead, behind, modified };
  } catch {
    return { available: false, branch: '', upstream: '', ahead: 0, behind: 0, modified: [] };
  }
}

/**
 * Obtiene el estado resumido de Git limitado a src/ (compatibilidad).
 * @param {string} projectRoot
 */
function getGitSrcStatus(projectRoot) {
  const full = getGitRepoStatus(projectRoot);
  return {
    ...full,
    modified: full.modified
      .filter((m) => m.inSrc)
      .map((m) => ({ ...m, path: m.srcPath })),
  };
}

/**
 * Hace stage y commit únicamente sobre los archivos validados del repositorio.
 * @param {string} projectRoot
 * @param {{ message: string, files: string[] }} params
 */
function gitCommitChanges(projectRoot, params) {
  const message = typeof params.message === 'string' ? params.message.trim() : '';
  if (!message || message.includes('\0')) {
    throw new Error('El mensaje de commit no puede estar vacío.');
  }
  if (message.length > 500) {
    throw new Error('El mensaje de commit es demasiado largo (máx. 500 caracteres).');
  }
  if (!Array.isArray(params.files) || params.files.length === 0) {
    throw new Error('Seleccione al menos un archivo para incluir en el commit.');
  }

  const safePaths = [];
  for (const rawFile of params.files) {
    const { relPath } = resolveRepoPath(projectRoot, rawFile);
    safePaths.push(relPath);
  }

  const cachedOut = execFileSync('git', ['diff', '--cached', '--name-status', '-z'], {
    cwd: projectRoot,
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe'],
  });
  const cachedTokens = cachedOut.split('\0').filter((t) => t.length > 0);
  const stagedDeleted = new Set();
  for (let i = 0; i < cachedTokens.length; i += 2) {
    const st = cachedTokens[i];
    const p = cachedTokens[i + 1];
    if (st === 'D' && p) stagedDeleted.add(toPosix(p));
  }

  const pathsToAdd = safePaths.filter((p) => !stagedDeleted.has(p));
  if (pathsToAdd.length > 0) {
    execFileSync('git', ['add', '-A', '--', ...pathsToAdd], {
      cwd: projectRoot,
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'pipe'],
    });
  }

  const commitOut = execFileSync('git', ['commit', '-m', message, '--', ...safePaths], {
    cwd: projectRoot,
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe'],
  });

  return {
    ok: true,
    output: commitOut.trim(),
    git: getGitRepoStatus(projectRoot),
  };
}

/**
 * Ejecuta git push hacia el remoto configurado sin bloqueo interactivo de terminal.
 * @param {string} projectRoot
 * @returns {Promise<{ ok: boolean, code: number, output: string, git: object }>}
 */
function gitPushChanges(projectRoot) {
  return new Promise((resolve) => {
    const child = spawn('git', ['push'], {
      cwd: projectRoot,
      windowsHide: true,
      env: { ...process.env, GIT_TERMINAL_PROMPT: '0' },
    });
    let out = '';
    const timer = setTimeout(() => {
      child.kill();
      resolve({
        ok: false,
        code: 1,
        output: out + '\nTiempo de espera agotado al ejecutar git push.',
        git: getGitRepoStatus(projectRoot),
      });
    }, 30000);

    child.stdout.on('data', (d) => (out += d.toString('utf8')));
    child.stderr.on('data', (d) => (out += d.toString('utf8')));
    child.on('close', (code) => {
      clearTimeout(timer);
      resolve({
        ok: code === 0,
        code: code ?? 1,
        output: out.trim() || (code === 0 ? 'Push completado correctamente.' : 'Error al ejecutar git push.'),
        git: getGitRepoStatus(projectRoot),
      });
    });
    child.on('error', (err) => {
      clearTimeout(timer);
      resolve({
        ok: false,
        code: 1,
        output: err.message,
        git: getGitRepoStatus(projectRoot),
      });
    });
  });
}

/**
 * Restaura un archivo dentro de src/ al último estado guardado en Git.
 * @param {string} projectRoot
 * @param {string} relPathInput
 */
function revertSrcFileFromGit(projectRoot, relPathInput) {
  const srcRoot = path.join(projectRoot, 'src');
  const { relPath } = resolveSrcFile(srcRoot, relPathInput);
  execFileSync('git', ['checkout', '--', `src/${relPath}`], {
    cwd: projectRoot,
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe'],
  });
  return { ok: true, relPath };
}

/**
 * Ejecuta tools/Sync-ToGame.ps1 validando addonName contra la lista blanca de config.json.
 * @param {string} projectRoot
 * @param {{ addonName?: string, dryRun?: boolean }} [options]
 * @returns {Promise<{ ok: boolean, code: number, output: string }>}
 */
function runSyncToGame(projectRoot, options = {}) {
  const cfg = readProjectConfig(projectRoot);
  const addonName = typeof options.addonName === 'string' ? options.addonName.trim() : '';
  if (addonName) {
    const allowed = new Set(cfg.addons.map((a) => a.folderName));
    if (!allowed.has(addonName)) {
      return Promise.reject(new Error(`Addon no reconocido en config.json: ${addonName}`));
    }
  }

  const scriptPath = path.join(projectRoot, 'tools', 'Sync-ToGame.ps1');
  if (!fs.existsSync(scriptPath)) {
    return Promise.reject(new Error('No se encontró tools/Sync-ToGame.ps1.'));
  }

  const args = ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', scriptPath];
  if (addonName) args.push('-AddonName', addonName);
  if (options.dryRun) args.push('-DryRun');

  const psExe = fs.existsSync('C:\\Program Files\\PowerShell\\7\\pwsh.exe')
    ? 'C:\\Program Files\\PowerShell\\7\\pwsh.exe'
    : 'powershell.exe';

  return new Promise((resolve) => {
    const child = spawn(psExe, args, { cwd: projectRoot, windowsHide: true });
    let out = '';
    child.stdout.on('data', (d) => (out += d.toString('utf8')));
    child.stderr.on('data', (d) => (out += d.toString('utf8')));
    child.on('close', (code) => {
      resolve({ ok: code === 0, code: code ?? 1, output: out });
    });
    child.on('error', (err) => {
      resolve({ ok: false, code: 1, output: err.message });
    });
  });
}

module.exports = {
  EDITABLE_EXTENSIONS,
  readProjectConfig,
  isJourneyGuidePath,
  resolveSrcFile,
  decodeJourneyHtml,
  encodeJourneyHtml,
  validateLuaText,
  parseGuidesCatalogLua,
  listEditableFiles,
  readEditableFile,
  saveEditableFile,
  searchInRoot,
  previewReplaceInRoot,
  applyReplaceInRoot,
  validateProjectIntegrity,
  getGitRepoStatus,
  getGitSrcStatus,
  gitCommitChanges,
  gitPushChanges,
  revertSrcFileFromGit,
  runSyncToGame,
};
