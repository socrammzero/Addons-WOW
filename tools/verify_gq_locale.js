const fs = require('fs');
const path = require('path');

const gqDir = 'src/GearQuestForever';
const gqFiles = fs.readdirSync(gqDir).filter(f => f.endsWith('.lua') && f !== 'GearQuestForever.toc');

const requestedKeys = new Set();
gqFiles.forEach(f => {
  const code = fs.readFileSync(path.join(gqDir, f), 'utf8');
  const matches = [...code.matchAll(/L\["([^"]+)"\]/g)].map(m => m[1]);
  matches.forEach(k => requestedKeys.add(k));
});

console.log('Total UI keys requested in GearQuestForever code:', requestedKeys.size);

const esContent = fs.readFileSync('src/GearQuestForever_Languages/esES.lua', 'utf8');
const esKeys = new Set([...esContent.matchAll(/L\["([^"]+)"\]/g)].map(m => m[1]));

console.log('Total UI keys provided in GearQuestForever_Languages esES.lua:', esKeys.size);

const missingInEs = [...requestedKeys].filter(k => !esKeys.has(k));
console.log('Missing UI keys in esES:', missingInEs.length);
if (missingInEs.length > 0) {
  console.log('Keys:', missingInEs);
}
