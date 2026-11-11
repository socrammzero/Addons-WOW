const fs = require('fs');

const phrases = new Set();
for (let i = 1; i <= 21; i++) {
    const pad = String(i).padStart(4, '0');
    const fPath = `src/Journey/BundledContent/Guides/${pad}.html`;
    if (!fs.existsSync(fPath)) continue;
    const raw = fs.readFileSync(fPath, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
    const decoded = Buffer.from(raw, 'base64').toString('utf8');

    // Find quoted strings
    const matches = decoded.match(/"([^"\\]*(?:\\.[^"\\]*)*)"/g) || [];
    for (const m of matches) {
        const str = m.slice(1, -1);
        if (str.length > 5 && str.includes(' ') && !str.startsWith('|') && !str.startsWith('BW|') && !str.includes('CV|') && !str.includes('QUEST[')) {
            phrases.add(str);
        }
    }
}

console.log(`Found ${phrases.size} descriptive phrases in 0001-0021.html:`);
const arr = [...phrases].sort();
fs.writeFileSync('tools/phrases_0001_0021.json', JSON.stringify(arr, null, 2));
console.log(arr.slice(0, 30));
