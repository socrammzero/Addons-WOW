const fs = require('fs');
const getKeys = p => {
  const content = fs.readFileSync(p, 'utf8');
  const matches = [...content.matchAll(/L\["([^"]+)"\]/g)].map(m => m[1]);
  return new Set(matches);
};

const es = getKeys('src/Books_on_map_Forever/Locales/esES.lua');
const fr = getKeys('src/Books_on_map_Forever/Locales/frFR.lua');
const de = getKeys('src/Books_on_map_Forever/Locales/deDE.lua');

console.log('Books_on_map_Forever Locale counts:');
console.log('  esES count:', es.size);
console.log('  frFR count:', fr.size);
console.log('  deDE count:', de.size);

const missingFromFr = [...fr].filter(k => !es.has(k));
const missingFromDe = [...de].filter(k => !es.has(k));

console.log('Missing from frFR in esES:', missingFromFr);
console.log('Missing from deDE in esES:', missingFromDe);
