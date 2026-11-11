const fs = require('fs');

function getKeys(filePath, loc) {
  const content = fs.readFileSync(filePath, 'utf8');
  const lines = content.split('\n');
  const keys = new Set();
  for (const line of lines) {
    const m = line.match(/MoveAny:AddTrans\(\s*["']([^"']+)["']\s*,\s*["']([^"']+)["']/);
    if (m && m[1] === loc) {
      keys.add(m[2]);
    }
  }
  return keys;
}

const en = getKeys('src/MoveAny/locale/enUS.lua', 'enUS');
const es = getKeys('src/MoveAny/locale/esES.lua', 'esES');
const mx = getKeys('src/MoveAny/locale/esMX.lua', 'esMX');

console.log('MoveAny key counts:');
console.log('  enUS:', en.size);
console.log('  esES:', es.size);
console.log('  esMX:', mx.size);

const missingEs = [...en].filter(k => !es.has(k));
const missingMx = [...en].filter(k => !mx.has(k));

console.log('Missing in esES:', missingEs);
console.log('Missing in esMX:', missingMx);
