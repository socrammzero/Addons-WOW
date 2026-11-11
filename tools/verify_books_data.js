const fs = require('fs');

const esContent = fs.readFileSync('src/Books_on_map_Forever/Locales/esES.lua', 'utf8');
const esKeys = new Set([...esContent.matchAll(/L\["([^"]+)"\]/g)].map(m => m[1]));

const booksCode = fs.readFileSync('src/Books_on_map_Forever/Data/Books.lua', 'utf8');
const names = [...booksCode.matchAll(/name\s*=\s*"([^"]+)"/g)].map(m => m[1]);
const places = [...booksCode.matchAll(/\{\s*[A-Z]+,\s*[\d.]+,\s*[\d.]+,\s*"([^"]+)"\s*\}/g)].map(m => m[1]);

console.log('Total book names in Books.lua:', names.length);
console.log('Total book places in Books.lua:', places.length);

const missingNames = names.filter(n => !esKeys.has(n));
const missingPlaces = places.filter(p => !esKeys.has(p));

console.log('Missing names in esES:', missingNames);
console.log('Missing places in esES:', missingPlaces);
