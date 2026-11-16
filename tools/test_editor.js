const { describe, it, before, after } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const os = require('node:os');
const http = require('node:http');

const {
  decodeJourneyHtml,
  encodeJourneyHtml,
  validateLuaText,
  resolveSrcFile,
  isJourneyGuidePath,
  parseGuidesCatalogLua,
  listEditableFiles,
  searchInRoot,
  previewReplaceInRoot,
  applyReplaceInRoot,
} = require('./editor_lib');

const { createEditorServer } = require('./editor_server');

function makeTempProject() {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'addons-wow-editor-'));
  const srcDir = path.join(dir, 'src');
  const guidesDir = path.join(srcDir, 'Journey', 'BundledContent', 'Guides');
  const otherAddonDir = path.join(srcDir, 'MoveAny', 'locale');
  fs.mkdirSync(guidesDir, { recursive: true });
  fs.mkdirSync(otherAddonDir, { recursive: true });

  fs.writeFileSync(
    path.join(dir, 'config.json'),
    JSON.stringify(
      {
        wowAddonsPath: path.join(dir, 'FakeWoW', 'AddOns'),
        addons: [
          { name: 'Journey Guides', folderName: 'Journey', sync: true },
          { name: 'MoveAny', folderName: 'MoveAny', sync: true },
        ],
      },
      null,
      2
    ),
    'utf8'
  );

  const catalogLua = `{\n\tguideVersion = "4.00.11",\n{\n\tguideID = "A12D_FVR",\n\tdescription = "12-17 Costa Oscura",\n\tfaction = "Alliance",\n\tlevels = "12-17",\n\tgroup = "Forever (12-20)",\n\tslot = 4,\n},\n}\n`;
  const guide0004Lua = `{\n\t{\n\t\t{ target = 2185, label = "Trillador de Costa Oscura" },\n\t\t"Mata a los Trilladores de Costa Oscura.",\n\t},\n}\n`;

  const wrapHtml = (lua, hash) => {
    const b64 = Buffer.from(lua, 'utf8').toString('base64');
    const wrapped = b64.match(/.{1,76}/g).join('\n');
    return `<!-- hash:${hash} -->\n<html>\n\t<body>\n\t\t<p>\n${wrapped}\n\t\t</p>\n\t</body>\n</html>\n`;
  };

  fs.writeFileSync(path.join(guidesDir, 'guides.html'), wrapHtml(catalogLua, 'cat123'), 'utf8');
  fs.writeFileSync(path.join(guidesDir, '0004.html'), wrapHtml(guide0004Lua, 'g0004'), 'utf8');
  fs.writeFileSync(path.join(guidesDir, 'icon.blp'), Buffer.from([0x42, 0x4c, 0x50, 0x32]));

  fs.writeFileSync(
    path.join(otherAddonDir, 'esES.lua'),
    'local L = {}\nL["Hello"] = "Hola {Mundo}"\nreturn L\n',
    'utf8'
  );

  return dir;
}

describe('editor_lib core', () => {
  let tmpDir;

  before(() => {
    tmpDir = makeTempProject();
  });

  after(() => {
    fs.rmSync(tmpDir, { recursive: true, force: true });
  });

  it('rejects path traversal and non-editable binary paths', () => {
    const srcRoot = path.join(tmpDir, 'src');
    assert.throws(() => resolveSrcFile(srcRoot, '../config.json'), /no permitida|fuera/i);
    assert.throws(() => resolveSrcFile(srcRoot, '../../etc/passwd'), /no permitida|fuera/i);
    assert.throws(() => resolveSrcFile(srcRoot, 'Journey/BundledContent/Guides/icon.blp'), /extensión/i);

    const ok = resolveSrcFile(srcRoot, 'Journey/BundledContent/Guides/0004.html');
    assert.equal(ok.relPath, 'Journey/BundledContent/Guides/0004.html');
  });

  it('decodes and re-encodes Journey Base64 HTML preserving wrapper and 76-col wrapping', () => {
    const p = path.join(tmpDir, 'src', 'Journey', 'BundledContent', 'Guides', '0004.html');
    const rawHtml = fs.readFileSync(p, 'utf8');
    const decoded = decodeJourneyHtml(rawHtml);
    assert.ok(decoded.lua.includes('Trillador de Costa Oscura'));

    const modifiedLua = decoded.lua.replace('Trillador de Costa Oscura', 'Cangrejo de Costa Oscura');
    const reencoded = encodeJourneyHtml(decoded, modifiedLua);
    assert.ok(reencoded.startsWith('<!-- hash:g0004 -->'));
    assert.ok(reencoded.endsWith('</html>\n'));
    assert.equal(reencoded.charCodeAt(0) === 0xfeff, false);

    const decodedAgain = decodeJourneyHtml(reencoded);
    assert.equal(decodedAgain.lua, modifiedLua);
  });

  it('validates Lua brace balance ignoring strings and comments, and rejects unclosed strings', () => {
    assert.deepEqual(validateLuaText('local t = { a = "}{", b = 1 } -- }\n', { isLua: true }), {
      valid: true,
      openBraces: 1,
      closeBraces: 1,
      errors: [],
    });

    const unbalanced = validateLuaText('local t = { a = 1\n', { isLua: true });
    assert.equal(unbalanced.valid, false);
    assert.ok(unbalanced.errors.some((e) => /llaves/i.test(e)));

    const unclosedStr = validateLuaText('local t = { a = "hola }\n', { isLua: true });
    assert.equal(unclosedStr.valid, false);
    assert.ok(unclosedStr.errors.some((e) => /cadena|comilla/i.test(e)));

    const guideMissingOuter = validateLuaText('a = 1', { isLua: true, isJourneyGuide: true });
    assert.equal(guideMissingOuter.valid, false);
  });

  it('parses guides.html metadata and lists editable files with friendly titles', () => {
    const catalogRaw = fs.readFileSync(
      path.join(tmpDir, 'src', 'Journey', 'BundledContent', 'Guides', 'guides.html'),
      'utf8'
    );
    const meta = parseGuidesCatalogLua(decodeJourneyHtml(catalogRaw).lua);
    assert.equal(meta['0004.html'].description, '12-17 Costa Oscura');
    assert.equal(meta['0004.html'].faction, 'Alliance');

    const files = listEditableFiles(tmpDir);
    const guide0004 = files.find((f) => f.relPath === 'Journey/BundledContent/Guides/0004.html');
    assert.ok(guide0004);
    assert.equal(guide0004.isJourneyGuide, true);
    assert.equal(guide0004.guideMeta.description, '12-17 Costa Oscura');
    assert.equal(files.some((f) => f.relPath.endsWith('.blp')), false);
  });

  it('searches across decoded Journey guides and plain Lua files', () => {
    const res1 = searchInRoot(tmpDir, { query: 'Trillador', matchCase: false, wholeWord: false });
    assert.equal(res1.totalMatches, 2);
    assert.equal(res1.files[0].relPath, 'Journey/BundledContent/Guides/0004.html');

    const res2 = searchInRoot(tmpDir, { query: 'Hola', addon: 'MoveAny' });
    assert.equal(res2.totalMatches, 1);
    assert.equal(res2.files[0].relPath, 'MoveAny/locale/esES.lua');
  });

  it('previews and applies batch replace safely across Journey Base64 guides and Lua files', () => {
    const preview = previewReplaceInRoot(tmpDir, {
      find: 'Trillador',
      replace: 'Múrloc',
      matchCase: true,
      wholeWord: false,
    });
    assert.equal(preview.totalReplacements, 2);
    assert.equal(preview.files.length, 1);
    assert.ok(preview.files[0].changes[0].after.includes('Múrloc de Costa Oscura'));

    // Disk must NOT be modified by preview
    const beforeSave = decodeJourneyHtml(
      fs.readFileSync(path.join(tmpDir, 'src', 'Journey', 'BundledContent', 'Guides', '0004.html'), 'utf8')
    ).lua;
    assert.ok(beforeSave.includes('Trillador'));

    // Applying a replacement that breaks Lua quotes must be rejected before writing
    const badApply = applyReplaceInRoot(tmpDir, {
      find: 'Trillador',
      replace: '"roto',
      matchCase: true,
      wholeWord: false,
    });
    assert.equal(badApply.ok, false);
    assert.ok(badApply.errors.length > 0);

    // Valid apply updates disk cleanly
    const goodApply = applyReplaceInRoot(tmpDir, {
      find: 'Trillador',
      replace: 'Múrloc',
      matchCase: true,
      wholeWord: false,
    });
    assert.equal(goodApply.ok, true);
    assert.equal(goodApply.updatedFiles.length, 1);

    const afterRaw = fs.readFileSync(
      path.join(tmpDir, 'src', 'Journey', 'BundledContent', 'Guides', '0004.html'),
      'utf8'
    );
    assert.equal(afterRaw.charCodeAt(0) === 0xfeff, false);
    const afterLua = decodeJourneyHtml(afterRaw).lua;
    assert.ok(afterLua.includes('Múrloc de Costa Oscura'));
    assert.ok(afterLua.includes('Múrloces de Costa Oscura'));
  });
});

describe('editor_server HTTP API', () => {
  let tmpDir;
  let server;
  let baseUrl;

  before(async () => {
    tmpDir = makeTempProject();
    server = createEditorServer({ projectRoot: tmpDir, syncRunner: async () => ({ ok: true, code: 0, output: 'Mock sync OK' }) });
    await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
    const addr = server.address();
    baseUrl = `http://127.0.0.1:${addr.port}`;
  });

  after(async () => {
    await new Promise((resolve) => server.close(resolve));
    fs.rmSync(tmpDir, { recursive: true, force: true });
  });

  function requestJson(method, urlPath, body) {
    return new Promise((resolve, reject) => {
      const req = http.request(`${baseUrl}${urlPath}`, { method, headers: { 'Content-Type': 'application/json' } }, (res) => {
        let data = '';
        res.on('data', (c) => (data += c));
        res.on('end', () => resolve({ status: res.statusCode, body: JSON.parse(data) }));
      });
      req.on('error', reject);
      if (body !== undefined) req.write(JSON.stringify(body));
      req.end();
    });
  }

  it('serves /api/info, /api/files, /api/file, /api/search, and rejects invalid save', async () => {
    const info = await requestJson('GET', '/api/info');
    assert.equal(info.status, 200);
    assert.equal(info.body.addons.length, 2);

    const files = await requestJson('GET', '/api/files');
    assert.equal(files.status, 200);
    assert.ok(files.body.files.some((f) => f.relPath === 'Journey/BundledContent/Guides/0004.html'));

    const fileRes = await requestJson('GET', '/api/file?path=Journey/BundledContent/Guides/0004.html');
    assert.equal(fileRes.status, 200);
    assert.equal(fileRes.body.isJourneyGuide, true);
    assert.ok(fileRes.body.content.includes('Trillador de Costa Oscura'));

    const travRes = await requestJson('GET', '/api/file?path=../config.json');
    assert.equal(travRes.status, 400);

    const badSave = await requestJson('POST', '/api/file/save', {
      path: 'Journey/BundledContent/Guides/0004.html',
      content: '{ broken = "unclosed',
    });
    assert.equal(badSave.status, 400);
    assert.equal(badSave.body.ok, false);

    const goodSave = await requestJson('POST', '/api/file/save', {
      path: 'Journey/BundledContent/Guides/0004.html',
      content: fileRes.body.content.replace('Trillador', 'Cazador'),
    });
    assert.equal(goodSave.status, 200);
    assert.equal(goodSave.body.ok, true);

    const syncRes = await requestJson('POST', '/api/sync', { addonName: 'Journey', dryRun: true });
    assert.equal(syncRes.status, 200);
    assert.equal(syncRes.body.ok, true);

    const badSync = await requestJson('POST', '/api/sync', { addonName: 'NotAnAddon; rm -rf' });
    assert.equal(badSync.status, 400);

    // Static UI assets & traversal protection
    const htmlRes = await new Promise((resolve, reject) => {
      http.get(`${baseUrl}/`, (res) => {
        let data = '';
        res.on('data', (c) => (data += c));
        res.on('end', () => resolve({ status: res.statusCode, text: data }));
      }).on('error', reject);
    });
    assert.equal(htmlRes.status, 200);
    assert.ok(htmlRes.text.includes('Editor de Traducciones'));

    const staticTrav = await requestJson('GET', '/..%2feditor_lib.js');
    assert.equal(staticTrav.status, 400);
  });
});
