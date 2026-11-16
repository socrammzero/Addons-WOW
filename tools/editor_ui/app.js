'use strict';

const state = {
  addons: [],
  wowAddonsPath: '',
  files: [],
  gitModified: [],
  scope: 'all',
  addon: 'ALL',
  mode: 'search',
  activeFile: null,
  originalContent: '',
  dirty: false,
  localMatches: [],
  localMatchIdx: -1,
};

const els = {
  wowPathLabel: document.getElementById('wowPathLabel'),
  btnGitStatus: document.getElementById('btnGitStatus'),
  gitCountBadge: document.getElementById('gitCountBadge'),
  btnValidate: document.getElementById('btnValidate'),
  syncTargetSelect: document.getElementById('syncTargetSelect'),
  btnSync: document.getElementById('btnSync'),
  addonFilter: document.getElementById('addonFilter'),
  scopeButtons: Array.from(document.querySelectorAll('.seg-btn')),
  tabSearchMode: document.getElementById('tabSearchMode'),
  tabFilesMode: document.getElementById('tabFilesMode'),
  panelSearch: document.getElementById('panelSearch'),
  panelFiles: document.getElementById('panelFiles'),
  searchForm: document.getElementById('searchForm'),
  globalSearchInput: document.getElementById('globalSearchInput'),
  globalReplaceInput: document.getElementById('globalReplaceInput'),
  optMatchCase: document.getElementById('optMatchCase'),
  optWholeWord: document.getElementById('optWholeWord'),
  optUseRegex: document.getElementById('optUseRegex'),
  btnGlobalSearch: document.getElementById('btnGlobalSearch'),
  btnPreviewReplace: document.getElementById('btnPreviewReplace'),
  searchSummary: document.getElementById('searchSummary'),
  searchResults: document.getElementById('searchResults'),
  fileFilterInput: document.getElementById('fileFilterInput'),
  filesSummary: document.getElementById('filesSummary'),
  filesList: document.getElementById('filesList'),
  activeFilePath: document.getElementById('activeFilePath'),
  fileTypeBadge: document.getElementById('fileTypeBadge'),
  dirtyBadge: document.getElementById('dirtyBadge'),
  guideSubtitle: document.getElementById('guideSubtitle'),
  localFindInput: document.getElementById('localFindInput'),
  btnLocalPrev: document.getElementById('btnLocalPrev'),
  btnLocalNext: document.getElementById('btnLocalNext'),
  localFindCount: document.getElementById('localFindCount'),
  btnRevertFile: document.getElementById('btnRevertFile'),
  btnSaveFile: document.getElementById('btnSaveFile'),
  emptyState: document.getElementById('emptyState'),
  editorContainer: document.getElementById('editorContainer'),
  lineGutter: document.getElementById('lineGutter'),
  codeEditor: document.getElementById('codeEditor'),
  statusCursor: document.getElementById('statusCursor'),
  statusLines: document.getElementById('statusLines'),
  statusValidation: document.getElementById('statusValidation'),
  modalBackdrop: document.getElementById('modalBackdrop'),
  modalTitle: document.getElementById('modalTitle'),
  modalBody: document.getElementById('modalBody'),
  modalFooter: document.getElementById('modalFooter'),
  btnCloseModal: document.getElementById('btnCloseModal'),
  toastArea: document.getElementById('toastArea'),
};

async function api(url, options = {}) {
  const res = await fetch(url, {
    headers: { 'Content-Type': 'application/json' },
    ...options,
  });
  const data = await res.json();
  if (!res.ok) {
    const errMsg = data.errors ? data.errors.join(' ') : (data.error || 'Error en la petición.');
    const err = new Error(errMsg);
    err.data = data;
    throw err;
  }
  return data;
}

function showToast(message, type = 'info') {
  const div = document.createElement('div');
  div.className = `toast ${type === 'ok' ? 'ok' : type === 'err' ? 'err' : ''}`;
  div.textContent = message;
  els.toastArea.appendChild(div);
  setTimeout(() => {
    div.remove();
  }, 4500);
}

function openModal(title, bodyBuilder, footerButtons = []) {
  els.modalTitle.textContent = title;
  els.modalBody.innerHTML = '';
  els.modalFooter.innerHTML = '';
  bodyBuilder(els.modalBody);
  for (const cfg of footerButtons) {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = cfg.className || 'btn btn-secondary';
    btn.textContent = cfg.label;
    btn.addEventListener('click', () => cfg.onClick(btn));
    els.modalFooter.appendChild(btn);
  }
  els.modalBackdrop.classList.remove('hidden');
}

function closeModal() {
  els.modalBackdrop.classList.add('hidden');
}

function updateGitBadge(git) {
  state.gitModified = git && Array.isArray(git.modified) ? git.modified : [];
  els.gitCountBadge.textContent = String(state.gitModified.length);
  els.gitCountBadge.classList.toggle('dirty', state.gitModified.length > 0);
  refreshRevertButton();
}

function refreshRevertButton() {
  if (!state.activeFile) {
    els.btnRevertFile.disabled = true;
    return;
  }
  const isDirtyInGit = state.gitModified.some((m) => m.path === state.activeFile.relPath);
  els.btnRevertFile.disabled = !isDirtyInGit && !state.dirty;
}

function formatGuideCaption(file) {
  if (!file.guideMeta) return '';
  const parts = [];
  if (file.guideMeta.description) parts.push(file.guideMeta.description);
  if (file.guideMeta.faction) parts.push(file.guideMeta.faction === 'Alliance' ? 'Alianza' : file.guideMeta.faction === 'Horde' ? 'Horda' : file.guideMeta.faction);
  if (file.guideMeta.group) parts.push(file.guideMeta.group);
  return parts.join(' · ');
}

function updateGutter() {
  const lines = els.codeEditor.value.split('\n').length;
  const arr = [];
  for (let i = 1; i <= lines; i++) arr.push(i);
  els.lineGutter.textContent = arr.join('\n');
  els.statusLines.textContent = `${lines} líneas`;
}

function updateCursorStatus() {
  const pos = els.codeEditor.selectionStart || 0;
  const before = els.codeEditor.value.slice(0, pos);
  const split = before.split('\n');
  const line = split.length;
  const col = split[split.length - 1].length + 1;
  els.statusCursor.textContent = `Línea ${line}, Col ${col}`;
}

function setDirty(isDirty) {
  state.dirty = isDirty;
  els.dirtyBadge.classList.toggle('hidden', !isDirty);
  els.btnSaveFile.disabled = !state.activeFile || !isDirty;
  refreshRevertButton();
}

function jumpToLine(lineNumber, highlightQuery = '') {
  const text = els.codeEditor.value;
  const lines = text.split('\n');
  const targetIdx = Math.max(0, Math.min(lines.length - 1, lineNumber - 1));
  let startOffset = 0;
  for (let i = 0; i < targetIdx; i++) {
    startOffset += lines[i].length + 1;
  }
  let endOffset = startOffset + lines[targetIdx].length;

  if (highlightQuery && !els.optUseRegex.checked) {
    const lineStr = lines[targetIdx];
    const flags = els.optMatchCase.checked ? '' : 'i';
    const match = lineStr.match(new RegExp(highlightQuery.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), flags));
    if (match && match.index !== undefined) {
      startOffset += match.index;
      endOffset = startOffset + match[0].length;
    }
  }

  els.codeEditor.focus();
  els.codeEditor.setSelectionRange(startOffset, endOffset);
  const lineHeight = 21;
  els.codeEditor.scrollTop = Math.max(0, (targetIdx - 6) * lineHeight);
  els.lineGutter.scrollTop = els.codeEditor.scrollTop;
  updateCursorStatus();
}

async function openFile(relPath, targetLine = null, searchQuery = '') {
  if (state.dirty && state.activeFile && state.activeFile.relPath !== relPath) {
    const ok = window.confirm(`Hay cambios sin guardar en ${state.activeFile.relPath}. ¿Desea descartarlos y abrir otro archivo?`);
    if (!ok) return;
  }

  try {
    const data = await api(`/api/file?path=${encodeURIComponent(relPath)}`);
    state.activeFile = data;
    state.originalContent = data.content;

    els.emptyState.classList.add('hidden');
    els.editorContainer.classList.remove('hidden');
    els.codeEditor.value = data.content;
    els.activeFilePath.textContent = data.relPath;
    els.fileTypeBadge.classList.remove('hidden');
    els.fileTypeBadge.textContent = data.isJourneyGuide ? 'Guía Journey (Base64)' : `Archivo ${data.ext}`;
    els.guideSubtitle.textContent = formatGuideCaption(data);

    els.localFindInput.disabled = false;
    els.btnLocalPrev.disabled = false;
    els.btnLocalNext.disabled = false;

    setDirty(false);
    updateGutter();
    updateValidationIndicator(data.validation);
    renderFilesList();

    if (targetLine) {
      jumpToLine(targetLine, searchQuery);
    } else {
      els.codeEditor.scrollTop = 0;
      els.lineGutter.scrollTop = 0;
      els.codeEditor.setSelectionRange(0, 0);
      updateCursorStatus();
    }

    if (els.localFindInput.value.trim()) {
      computeLocalMatches();
    }
  } catch (err) {
    showToast(err.message, 'err');
  }
}

function updateValidationIndicator(validation) {
  if (!validation) {
    els.statusValidation.textContent = 'Listo';
    els.statusValidation.className = 'status-ok';
    return;
  }
  if (validation.valid) {
    els.statusValidation.textContent = `Lua válido ({ ${validation.openBraces} / } ${validation.closeBraces})`;
    els.statusValidation.className = 'status-ok';
  } else {
    els.statusValidation.textContent = validation.errors[0] || 'Error de sintaxis Lua';
    els.statusValidation.className = 'status-bad';
  }
}

async function saveCurrentFile() {
  if (!state.activeFile) return;
  const content = els.codeEditor.value;
  try {
    els.btnSaveFile.disabled = true;
    const res = await api('/api/file/save', {
      method: 'POST',
      body: JSON.stringify({ path: state.activeFile.relPath, content }),
    });
    state.originalContent = content;
    setDirty(false);
    updateGitBadge(res.git);
    els.statusValidation.textContent = 'Guardado y validado correctamente';
    els.statusValidation.className = 'status-ok';
    showToast(`Guardado: ${state.activeFile.relPath}`, 'ok');
  } catch (err) {
    setDirty(true);
    if (err.data && err.data.validation) {
      updateValidationIndicator(err.data.validation);
    }
    showToast(`No se pudo guardar: ${err.message}`, 'err');
  }
}

async function revertCurrentFile() {
  if (!state.activeFile) return;
  if (state.dirty) {
    if (!window.confirm('¿Descartar los cambios sin guardar y volver al contenido en disco/Git?')) return;
  }
  const isDirtyInGit = state.gitModified.some((m) => m.path === state.activeFile.relPath);
  if (!isDirtyInGit) {
    els.codeEditor.value = state.originalContent;
    setDirty(false);
    updateGutter();
    showToast('Cambios sin guardar descartados.', 'ok');
    return;
  }
  if (!window.confirm(`¿Restaurar ${state.activeFile.relPath} al último commit de Git? Se perderán las modificaciones locales de este archivo.`)) {
    return;
  }
  try {
    const res = await api('/api/file/revert', {
      method: 'POST',
      body: JSON.stringify({ path: state.activeFile.relPath }),
    });
    state.originalContent = res.content;
    els.codeEditor.value = res.content;
    setDirty(false);
    updateGutter();
    updateGitBadge(res.git);
    showToast(`Archivo restaurado desde Git: ${res.relPath}`, 'ok');
  } catch (err) {
    showToast(err.message, 'err');
  }
}

function renderFilesList() {
  const filter = els.fileFilterInput.value.trim().toLowerCase();
  const filtered = state.files.filter((f) => {
    if (!filter) return true;
    const desc = f.guideMeta && f.guideMeta.description ? f.guideMeta.description.toLowerCase() : '';
    const grp = f.guideMeta && f.guideMeta.group ? f.guideMeta.group.toLowerCase() : '';
    return f.relPath.toLowerCase().includes(filter) || desc.includes(filter) || grp.includes(filter);
  });

  els.filesSummary.textContent = `${filtered.length} archivo${filtered.length === 1 ? '' : 's'} disponibles`;
  els.filesList.innerHTML = '';

  const maxRender = 250;
  for (const file of filtered.slice(0, maxRender)) {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'file-item' + (state.activeFile && state.activeFile.relPath === file.relPath ? ' active' : '');

    const title = document.createElement('div');
    title.className = 'file-item-title';
    title.textContent = file.relPath.split('/').slice(1).join('/') || file.relPath;

    const sub = document.createElement('div');
    sub.className = 'file-item-sub';
    const left = document.createElement('span');
    left.textContent = file.guideMeta && file.guideMeta.description
      ? `${file.guideMeta.description}${file.guideMeta.faction ? ' (' + (file.guideMeta.faction === 'Alliance' ? 'Alianza' : 'Horda') + ')' : ''}`
      : file.addon;
    const right = document.createElement('span');
    right.textContent = file.isJourneyGuide ? 'Guía' : file.ext;
    sub.append(left, right);

    btn.append(title, sub);
    btn.addEventListener('click', () => openFile(file.relPath));
    els.filesList.appendChild(btn);
  }

  if (filtered.length > maxRender) {
    const note = document.createElement('div');
    note.className = 'panel-meta';
    note.textContent = `Mostrando los primeros ${maxRender} resultados. Use el filtro superior para acotar.`;
    els.filesList.appendChild(note);
  }
}

async function refreshFilesList() {
  try {
    const res = await api(`/api/files?addon=${encodeURIComponent(state.addon)}&scope=${encodeURIComponent(state.scope)}`);
    state.files = res.files;
    renderFilesList();
  } catch (err) {
    showToast(err.message, 'err');
  }
}

function buildHighlightedSnippet(text, query) {
  const frag = document.createDocumentFragment();
  if (!query || els.optUseRegex.checked) {
    frag.appendChild(document.createTextNode(text));
    return frag;
  }
  const rx = new RegExp(query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), els.optMatchCase.checked ? 'g' : 'gi');
  let last = 0;
  for (const m of text.matchAll(rx)) {
    if (m.index > last) {
      frag.appendChild(document.createTextNode(text.slice(last, m.index)));
    }
    const span = document.createElement('span');
    span.className = 'hl';
    span.textContent = m[0];
    frag.appendChild(span);
    last = m.index + m[0].length;
  }
  if (last < text.length) {
    frag.appendChild(document.createTextNode(text.slice(last)));
  }
  return frag;
}

async function runGlobalSearch(e) {
  if (e) e.preventDefault();
  const query = els.globalSearchInput.value;
  if (!query.trim()) {
    showToast('Escriba el texto que desea buscar.', 'err');
    return;
  }

  els.searchSummary.textContent = 'Buscando en archivos (incluyendo guías Base64)...';
  els.searchResults.innerHTML = '';

  try {
    const res = await api('/api/search', {
      method: 'POST',
      body: JSON.stringify({
        query,
        addon: state.addon,
        scope: state.scope,
        matchCase: els.optMatchCase.checked,
        wholeWord: els.optWholeWord.checked,
        useRegex: els.optUseRegex.checked,
      }),
    });

    els.searchSummary.textContent = `${res.totalMatches} coincidencia${res.totalMatches === 1 ? '' : 's'} en ${res.files.length} archivo${res.files.length === 1 ? '' : 's'}${res.truncated ? ' (mostrando primeras 600 líneas)' : ''}`;

    if (res.files.length === 0) {
      const empty = document.createElement('div');
      empty.className = 'panel-meta';
      empty.textContent = 'No se encontraron coincidencias con los filtros actuales.';
      els.searchResults.appendChild(empty);
      return;
    }

    for (const file of res.files) {
      const group = document.createElement('div');
      group.className = 'result-group';

      const head = document.createElement('div');
      head.className = 'result-group-header';
      const title = document.createElement('span');
      title.textContent = file.relPath.split('/').slice(1).join('/') || file.relPath;
      const sub = document.createElement('span');
      sub.className = 'result-group-sub';
      sub.textContent = file.guideMeta && file.guideMeta.description ? file.guideMeta.description : file.addon;
      head.append(title, sub);
      group.appendChild(head);

      for (const m of file.matches) {
        const row = document.createElement('button');
        row.type = 'button';
        row.className = 'match-row';
        const ln = document.createElement('span');
        ln.className = 'match-line';
        ln.textContent = `L${m.line}`;
        const snip = document.createElement('span');
        snip.className = 'match-snippet';
        snip.appendChild(buildHighlightedSnippet(m.text, query));
        row.append(ln, snip);
        row.addEventListener('click', () => openFile(file.relPath, m.line, query));
        group.appendChild(row);
      }

      els.searchResults.appendChild(group);
    }
  } catch (err) {
    els.searchSummary.textContent = 'Error en la búsqueda.';
    showToast(err.message, 'err');
  }
}

async function runPreviewReplace() {
  const find = els.globalSearchInput.value;
  const replace = els.globalReplaceInput.value;
  if (!find.trim()) {
    showToast('Indique primero el texto a buscar.', 'err');
    return;
  }
  if (state.dirty) {
    showToast('Guarde o descarte primero los cambios pendientes en el editor abierto.', 'err');
    return;
  }

  try {
    const res = await api('/api/replace/preview', {
      method: 'POST',
      body: JSON.stringify({
        find,
        replace,
        addon: state.addon,
        scope: state.scope,
        matchCase: els.optMatchCase.checked,
        wholeWord: els.optWholeWord.checked,
        useRegex: els.optUseRegex.checked,
      }),
    });

    if (res.totalReplacements === 0) {
      showToast('No hay coincidencias para reemplazar con los filtros actuales.', 'info');
      return;
    }

    const canApply = res.validationErrors.length === 0;
    const footerButtons = [
      { label: 'Cancelar', className: 'btn btn-secondary', onClick: closeModal },
    ];

    if (canApply) {
      footerButtons.push({
        label: `Aplicar ${res.totalReplacements} reemplazo(s)`,
        className: 'btn btn-primary',
        onClick: async () => {
          await executeApplyReplace(find, replace, false);
        },
      });
      footerButtons.push({
        label: 'Aplicar y Sincronizar con WoW',
        className: 'btn btn-accent',
        onClick: async () => {
          await executeApplyReplace(find, replace, true);
        },
      });
    }

    openModal(
      `Vista previa de reemplazo (${res.totalReplacements} cambios en ${res.filesCount} archivos)`,
      (body) => {
        if (!canApply) {
          const warn = document.createElement('p');
          warn.className = 'status-bad';
          warn.textContent = 'No se puede aplicar este reemplazo porque rompería la sintaxis Lua en los siguientes archivos:';
          body.appendChild(warn);
          for (const ve of res.validationErrors) {
            const p = document.createElement('p');
            p.textContent = `${ve.relPath}: ${ve.errors.join(' ')}`;
            body.appendChild(p);
          }
          return;
        }

        for (const f of res.files) {
          const card = document.createElement('div');
          card.className = 'diff-card';
          const head = document.createElement('div');
          head.className = 'diff-card-head';
          head.textContent = f.guideMeta && f.guideMeta.description
            ? `${f.relPath} — ${f.guideMeta.description}`
            : f.relPath;
          card.appendChild(head);

          for (const ch of f.changes) {
            const row = document.createElement('div');
            row.className = 'diff-line';
            const ln = document.createElement('div');
            ln.textContent = `Línea ${ch.line}`;
            const b = document.createElement('div');
            b.className = 'diff-before';
            b.textContent = `- ${ch.before}`;
            const a = document.createElement('div');
            a.className = 'diff-after';
            a.textContent = `+ ${ch.after}`;
            row.append(ln, b, a);
            card.appendChild(row);
          }
          body.appendChild(card);
        }
      },
      footerButtons
    );
  } catch (err) {
    showToast(err.message, 'err');
  }
}

async function executeApplyReplace(find, replace, syncAfter) {
  try {
    const res = await api('/api/replace/apply', {
      method: 'POST',
      body: JSON.stringify({
        find,
        replace,
        addon: state.addon,
        scope: state.scope,
        matchCase: els.optMatchCase.checked,
        wholeWord: els.optWholeWord.checked,
        useRegex: els.optUseRegex.checked,
      }),
    });
    updateGitBadge(res.git);
    closeModal();
    showToast(`Aplicados ${res.totalReplacements} reemplazos en ${res.updatedFiles.length} archivo(s).`, 'ok');

    if (state.activeFile && res.updatedFiles.includes(state.activeFile.relPath)) {
      await openFile(state.activeFile.relPath);
    }
    if (els.globalSearchInput.value.trim()) {
      await runGlobalSearch();
    }
    if (syncAfter) {
      await runSyncWithWoW();
    }
  } catch (err) {
    showToast(err.message, 'err');
  }
}

async function runSyncWithWoW() {
  if (state.dirty) {
    const proceed = window.confirm('Tiene cambios sin guardar en el archivo abierto. ¿Desea sincronizar igualmente con WoW sin guardar ese archivo?');
    if (!proceed) return;
  }

  const addonName = els.syncTargetSelect.value;
  els.btnSync.disabled = true;
  els.btnSync.textContent = 'Sincronizando...';

  try {
    const res = await api('/api/sync', {
      method: 'POST',
      body: JSON.stringify({ addonName, dryRun: false }),
    });
    openModal(
      res.ok ? 'Sincronización con WoW completada' : 'Error en sincronización',
      (body) => {
        const tip = document.createElement('p');
        tip.textContent = res.ok
          ? 'Los archivos actualizados ya están en su carpeta de World of Warcraft. Escriba /reload en el chat del juego.'
          : 'El script devolvió un error. Revise el registro:';
        const pre = document.createElement('pre');
        pre.className = 'log-pre';
        pre.textContent = res.output || '(Sin salida)';
        body.append(tip, pre);
      },
      [{ label: 'Cerrar', className: 'btn btn-primary', onClick: closeModal }]
    );
  } catch (err) {
    showToast(err.message, 'err');
  } finally {
    els.btnSync.disabled = false;
    els.btnSync.textContent = 'Sincronizar con WoW';
  }
}

async function runGlobalValidation() {
  els.btnValidate.disabled = true;
  els.btnValidate.textContent = 'Validando...';
  try {
    const res = await api('/api/validate', { method: 'POST', body: '{}' });
    openModal(
      res.ok ? 'Integridad verificada sin errores' : 'Se encontraron incidencias',
      (body) => {
        const summary = document.createElement('p');
        summary.textContent = `Guías Base64 revisadas: ${res.checkedGuides} · Archivos Lua revisados: ${res.checkedLua} · Errores: ${res.errors.length}`;
        body.appendChild(summary);
        if (res.errors.length > 0) {
          const pre = document.createElement('pre');
          pre.className = 'log-pre';
          pre.textContent = res.errors.map((e) => `${e.relPath}: ${e.errors.join(' ')}`).join('\n');
          body.appendChild(pre);
        }
      },
      [{ label: 'Cerrar', className: 'btn btn-primary', onClick: closeModal }]
    );
  } catch (err) {
    showToast(err.message, 'err');
  } finally {
    els.btnValidate.disabled = false;
    els.btnValidate.textContent = 'Validar integridad';
  }
}

function showGitModal() {
  openModal(
    `Archivos modificados en src/ (${state.gitModified.length})`,
    (body) => {
      if (state.gitModified.length === 0) {
        const p = document.createElement('p');
        p.textContent = 'No hay cambios pendientes respecto al último commit de Git.';
        body.appendChild(p);
        return;
      }
      for (const item of state.gitModified) {
        const row = document.createElement('div');
        row.className = 'diff-line';
        row.style.display = 'flex';
        row.style.justifyContent = 'space-between';
        row.style.alignItems = 'center';
        const label = document.createElement('span');
        label.textContent = `[${item.status}] ${item.path}`;
        const openBtn = document.createElement('button');
        openBtn.type = 'button';
        openBtn.className = 'btn btn-secondary btn-xs';
        openBtn.textContent = 'Abrir';
        openBtn.addEventListener('click', () => {
          closeModal();
          openFile(item.path);
        });
        row.append(label, openBtn);
        body.appendChild(row);
      }
    },
    [{ label: 'Cerrar', className: 'btn btn-primary', onClick: closeModal }]
  );
}

function computeLocalMatches() {
  const q = els.localFindInput.value;
  state.localMatches = [];
  state.localMatchIdx = -1;
  if (!q) {
    els.localFindCount.textContent = '';
    return;
  }
  const text = els.codeEditor.value.toLowerCase();
  const needle = q.toLowerCase();
  let pos = 0;
  while (true) {
    const idx = text.indexOf(needle, pos);
    if (idx === -1) break;
    state.localMatches.push({ start: idx, end: idx + needle.length });
    pos = idx + needle.length;
    if (state.localMatches.length > 2000) break;
  }
  els.localFindCount.textContent = state.localMatches.length ? `0/${state.localMatches.length}` : '0/0';
}

function stepLocalMatch(dir) {
  if (state.localMatches.length === 0) return;
  if (state.localMatchIdx === -1) {
    state.localMatchIdx = dir > 0 ? 0 : state.localMatches.length - 1;
  } else {
    state.localMatchIdx = (state.localMatchIdx + dir + state.localMatches.length) % state.localMatches.length;
  }
  const m = state.localMatches[state.localMatchIdx];
  els.localFindCount.textContent = `${state.localMatchIdx + 1}/${state.localMatches.length}`;
  const lineIdx = els.codeEditor.value.slice(0, m.start).split('\n').length - 1;
  els.codeEditor.focus();
  els.codeEditor.setSelectionRange(m.start, m.end);
  els.codeEditor.scrollTop = Math.max(0, (lineIdx - 6) * 21);
  els.lineGutter.scrollTop = els.codeEditor.scrollTop;
  updateCursorStatus();
}

function setSidebarMode(mode) {
  state.mode = mode;
  els.tabSearchMode.classList.toggle('active', mode === 'search');
  els.tabFilesMode.classList.toggle('active', mode === 'files');
  els.panelSearch.classList.toggle('hidden', mode !== 'search');
  els.panelFiles.classList.toggle('hidden', mode !== 'files');
}

function bindEvents() {
  els.addonFilter.addEventListener('change', () => {
    state.addon = els.addonFilter.value;
    refreshFilesList();
  });

  for (const btn of els.scopeButtons) {
    btn.addEventListener('click', () => {
      state.scope = btn.dataset.scope;
      for (const b of els.scopeButtons) b.classList.toggle('active', b === btn);
      refreshFilesList();
    });
  }

  els.tabSearchMode.addEventListener('click', () => setSidebarMode('search'));
  els.tabFilesMode.addEventListener('click', () => setSidebarMode('files'));
  els.fileFilterInput.addEventListener('input', renderFilesList);
  els.searchForm.addEventListener('submit', runGlobalSearch);
  els.btnPreviewReplace.addEventListener('click', runPreviewReplace);
  els.btnSaveFile.addEventListener('click', saveCurrentFile);
  els.btnRevertFile.addEventListener('click', revertCurrentFile);
  els.btnSync.addEventListener('click', runSyncWithWoW);
  els.btnValidate.addEventListener('click', runGlobalValidation);
  els.btnGitStatus.addEventListener('click', showGitModal);
  els.btnCloseModal.addEventListener('click', closeModal);
  els.modalBackdrop.addEventListener('click', (e) => {
    if (e.target === els.modalBackdrop) closeModal();
  });

  els.codeEditor.addEventListener('input', () => {
    updateGutter();
    setDirty(els.codeEditor.value !== state.originalContent);
    if (els.localFindInput.value.trim()) computeLocalMatches();
  });
  els.codeEditor.addEventListener('scroll', () => {
    els.lineGutter.scrollTop = els.codeEditor.scrollTop;
  });
  els.codeEditor.addEventListener('keyup', updateCursorStatus);
  els.codeEditor.addEventListener('click', updateCursorStatus);

  els.localFindInput.addEventListener('input', computeLocalMatches);
  els.localFindInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      e.preventDefault();
      stepLocalMatch(e.shiftKey ? -1 : 1);
    }
  });
  els.btnLocalNext.addEventListener('click', () => stepLocalMatch(1));
  els.btnLocalPrev.addEventListener('click', () => stepLocalMatch(-1));

  window.addEventListener('keydown', (e) => {
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 's') {
      e.preventDefault();
      if (!els.btnSaveFile.disabled) saveCurrentFile();
    } else if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'f') {
      if (state.activeFile) {
        e.preventDefault();
        els.localFindInput.focus();
        els.localFindInput.select();
      }
    } else if (e.key === 'Escape' && !els.modalBackdrop.classList.contains('hidden')) {
      closeModal();
    }
  });

  window.addEventListener('beforeunload', (e) => {
    if (state.dirty) {
      e.preventDefault();
      e.returnValue = '';
    }
  });
}

async function init() {
  bindEvents();
  try {
    const info = await api('/api/info');
    state.addons = info.addons || [];
    state.wowAddonsPath = info.wowAddonsPath || '';
    els.wowPathLabel.textContent = `Destino WoW: ${state.wowAddonsPath || '(No configurado)'}`;
    updateGitBadge(info.git);

    for (const addon of state.addons) {
      const opt1 = document.createElement('option');
      opt1.value = addon.folderName;
      opt1.textContent = `${addon.name} (${addon.folderName})`;
      els.addonFilter.appendChild(opt1);

      if (addon.sync) {
        const opt2 = document.createElement('option');
        opt2.value = addon.folderName;
        opt2.textContent = addon.name;
        els.syncTargetSelect.appendChild(opt2);
      }
    }

    await refreshFilesList();
  } catch (err) {
    showToast(`Error inicializando editor: ${err.message}`, 'err');
  }
}

init();
