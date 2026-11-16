'use strict';

const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const { URL } = require('node:url');
const { spawn } = require('node:child_process');

const lib = require('./editor_lib');

const MAX_BODY_BYTES = 16 * 1024 * 1024;
const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.svg': 'image/svg+xml',
};

function sendJson(res, statusCode, payload) {
  const body = Buffer.from(JSON.stringify(payload), 'utf8');
  res.writeHead(statusCode, {
    'Content-Type': 'application/json; charset=utf-8',
    'Content-Length': body.length,
    'X-Content-Type-Options': 'nosniff',
    'Cache-Control': 'no-store',
  });
  res.end(body);
}

function readJsonBody(req) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    let total = 0;
    req.on('data', (chunk) => {
      total += chunk.length;
      if (total > MAX_BODY_BYTES) {
        reject(new Error('Petición demasiado grande.'));
        req.destroy();
        return;
      }
      chunks.push(chunk);
    });
    req.on('end', () => {
      try {
        const raw = Buffer.concat(chunks).toString('utf8');
        resolve(raw ? JSON.parse(raw) : {});
      } catch {
        reject(new Error('JSON inválido en el cuerpo de la petición.'));
      }
    });
    req.on('error', reject);
  });
}

function serveStaticUi(uiDir, reqPath, res) {
  const normalized = reqPath === '/' ? 'index.html' : reqPath.replace(/^\/+/, '');
  if (normalized.includes('..') || normalized.includes('\0')) {
    sendJson(res, 400, { ok: false, error: 'Ruta inválida.' });
    return;
  }
  const resolvedUi = path.resolve(uiDir);
  const target = path.resolve(resolvedUi, normalized);
  if (target !== resolvedUi && !target.startsWith(resolvedUi + path.sep)) {
    sendJson(res, 403, { ok: false, error: 'Acceso denegado.' });
    return;
  }
  if (!fs.existsSync(target) || fs.statSync(target).isDirectory()) {
    sendJson(res, 404, { ok: false, error: 'Recurso no encontrado.' });
    return;
  }
  const ext = path.extname(target).toLowerCase();
  const data = fs.readFileSync(target);
  res.writeHead(200, {
    'Content-Type': MIME_TYPES[ext] || 'application/octet-stream',
    'Content-Length': data.length,
    'X-Content-Type-Options': 'nosniff',
    'Cache-Control': 'no-store',
  });
  res.end(data);
}

/**
 * Crea el servidor HTTP local del editor de traducciones.
 * @param {{ projectRoot?: string, uiDir?: string, syncRunner?: Function }} [options]
 */
function createEditorServer(options = {}) {
  const projectRoot = options.projectRoot || path.resolve(__dirname, '..');
  const uiDir = options.uiDir || path.join(__dirname, 'editor_ui');
  const syncRunner = options.syncRunner || ((opts) => lib.runSyncToGame(projectRoot, opts));

  return http.createServer(async (req, res) => {
    try {
      const url = new URL(req.url || '/', 'http://127.0.0.1');
      const pathname = url.pathname;

      if (req.method === 'GET' && !pathname.startsWith('/api/')) {
        serveStaticUi(uiDir, pathname, res);
        return;
      }

      if (req.method === 'GET' && pathname === '/api/info') {
        const cfg = lib.readProjectConfig(projectRoot);
        const git = lib.getGitRepoStatus(projectRoot);
        sendJson(res, 200, {
          ok: true,
          wowAddonsPath: cfg.wowAddonsPath,
          addons: cfg.addons,
          git,
        });
        return;
      }

      if (req.method === 'GET' && pathname === '/api/files') {
        const addonFilter = url.searchParams.get('addon') || 'ALL';
        const scope = url.searchParams.get('scope') || 'all';
        let files = lib.listEditableFiles(projectRoot);
        if (addonFilter && addonFilter !== 'ALL') {
          files = files.filter((f) => f.addon === addonFilter);
        }
        if (scope === 'guides') {
          files = files.filter((f) => f.isJourneyGuide);
        } else if (scope === 'lua') {
          files = files.filter((f) => f.ext === '.lua');
        }
        sendJson(res, 200, { ok: true, files });
        return;
      }

      if (req.method === 'GET' && pathname === '/api/file') {
        const relPath = url.searchParams.get('path') || '';
        const fileData = lib.readEditableFile(projectRoot, relPath);
        const validation =
          fileData.ext === '.lua' || fileData.isJourneyGuide
            ? lib.validateLuaText(fileData.content, { isLua: true, isJourneyGuide: fileData.isJourneyGuide })
            : { valid: true, openBraces: 0, closeBraces: 0, errors: [] };
        sendJson(res, 200, {
          ok: true,
          relPath: fileData.relPath,
          addon: fileData.addon,
          ext: fileData.ext,
          isJourneyGuide: fileData.isJourneyGuide,
          guideMeta: fileData.guideMeta,
          content: fileData.content,
          validation,
        });
        return;
      }

      if (req.method === 'POST' && pathname === '/api/file/save') {
        const body = await readJsonBody(req);
        if (typeof body.content !== 'string') {
          sendJson(res, 400, { ok: false, error: 'Falta el contenido del archivo.' });
          return;
        }
        const result = lib.saveEditableFile(projectRoot, body.path, body.content);
        if (!result.ok) {
          sendJson(res, 400, result);
          return;
        }
        sendJson(res, 200, { ok: true, relPath: result.relPath, git: lib.getGitRepoStatus(projectRoot) });
        return;
      }

      if (req.method === 'POST' && pathname === '/api/file/revert') {
        const body = await readJsonBody(req);
        const result = lib.revertSrcFileFromGit(projectRoot, body.path);
        const fileData = lib.readEditableFile(projectRoot, result.relPath);
        sendJson(res, 200, {
          ok: true,
          relPath: result.relPath,
          content: fileData.content,
          git: lib.getGitRepoStatus(projectRoot),
        });
        return;
      }

      if (req.method === 'POST' && pathname === '/api/search') {
        const body = await readJsonBody(req);
        const result = lib.searchInRoot(projectRoot, body);
        sendJson(res, 200, { ok: true, ...result });
        return;
      }

      if (req.method === 'POST' && pathname === '/api/replace/preview') {
        const body = await readJsonBody(req);
        const preview = lib.previewReplaceInRoot(projectRoot, body);
        const { _pendingWrites, ...safePreview } = preview;
        sendJson(res, 200, { ok: true, ...safePreview });
        return;
      }

      if (req.method === 'POST' && pathname === '/api/replace/apply') {
        const body = await readJsonBody(req);
        const result = lib.applyReplaceInRoot(projectRoot, body);
        if (!result.ok) {
          sendJson(res, 400, result);
          return;
        }
        sendJson(res, 200, { ...result, git: lib.getGitRepoStatus(projectRoot) });
        return;
      }

      if (req.method === 'GET' && pathname === '/api/git/status') {
        sendJson(res, 200, { ok: true, git: lib.getGitRepoStatus(projectRoot) });
        return;
      }

      if (req.method === 'POST' && pathname === '/api/git/commit') {
        const body = await readJsonBody(req);
        const commitRes = lib.gitCommitChanges(projectRoot, body);
        if (body.push) {
          const pushRes = await lib.gitPushChanges(projectRoot);
          sendJson(res, pushRes.ok ? 200 : 500, {
            ok: pushRes.ok,
            commitOutput: commitRes.output,
            output: `${commitRes.output}\n\n${pushRes.output}`.trim(),
            git: pushRes.git,
          });
          return;
        }
        sendJson(res, 200, commitRes);
        return;
      }

      if (req.method === 'POST' && pathname === '/api/git/push') {
        const pushRes = await lib.gitPushChanges(projectRoot);
        sendJson(res, pushRes.ok ? 200 : 500, pushRes);
        return;
      }

      if (req.method === 'POST' && pathname === '/api/validate') {
        const result = lib.validateProjectIntegrity(projectRoot);
        sendJson(res, 200, result);
        return;
      }

      if (req.method === 'POST' && pathname === '/api/sync') {
        const body = await readJsonBody(req);
        const cfg = lib.readProjectConfig(projectRoot);
        const addonName = typeof body.addonName === 'string' ? body.addonName.trim() : '';
        if (addonName && !cfg.addons.some((a) => a.folderName === addonName)) {
          sendJson(res, 400, { ok: false, error: 'Addon no válido en config.json.' });
          return;
        }
        const syncRes = await syncRunner({ addonName, dryRun: Boolean(body.dryRun) });
        sendJson(res, syncRes.ok ? 200 : 500, syncRes);
        return;
      }

      sendJson(res, 404, { ok: false, error: 'Endpoint no encontrado.' });
    } catch (err) {
      const status = /no permitida|inválido|vací|extensión|no válido|no existe|seleccione|demasiado largo/i.test(err.message) ? 400 : 500;
      sendJson(res, status, { ok: false, error: err.message || 'Error interno del servidor.' });
    }
  });
}

function openBrowserUrl(url) {
  if (process.platform === 'win32') {
    spawn('cmd', ['/c', 'start', '', url], { detached: true, stdio: 'ignore', windowsHide: true }).unref();
  }
}

if (require.main === module) {
  const args = process.argv.slice(2);
  const noOpen = args.includes('--no-open');
  const portArg = args.find((a) => a.startsWith('--port='));
  const desiredPort = portArg ? Number(portArg.split('=')[1]) : 4821;
  const server = createEditorServer();

  server.on('error', (err) => {
    if (err.code === 'EADDRINUSE' && desiredPort !== 0) {
      server.listen(0, '127.0.0.1');
    } else {
      console.error('Error al iniciar el editor:', err.message);
      process.exit(1);
    }
  });

  server.listen(desiredPort, '127.0.0.1', () => {
    const addr = server.address();
    const url = `http://127.0.0.1:${addr.port}`;
    console.log('==========================================================');
    console.log('  Addons-WOW: Editor Visual de Traducciones esES');
    console.log('==========================================================');
    console.log(`  URL local: ${url}`);
    console.log('  Mantenga esta ventana abierta mientras edita.');
    console.log('  Pulse Ctrl+C para cerrar el servidor.');
    console.log('==========================================================');
    if (!noOpen) openBrowserUrl(url);
  });
}

module.exports = { createEditorServer };
