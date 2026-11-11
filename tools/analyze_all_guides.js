const fs = require('fs');

console.log('--- Analyzing 0001 - 0121 ---');
let totalGuides = 0;
let totalChars = 0;
const phrasePatterns = new Map();

for (let i = 1; i <= 121; i++) {
    const pad = String(i).padStart(4, '0');
    const f = `src/Journey/BundledContent/Guides/${pad}.html`;
    if (!fs.existsSync(f)) continue;
    totalGuides++;
    const raw = fs.readFileSync(f, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
    const dec = Buffer.from(raw, 'base64').toString('utf8');
    totalChars += dec.length;

    // extract strings
    const matches = dec.match(/"([^"\\]*(?:\\.[^"\\]*)*)"/g) || [];
    for (const m of matches) {
        const s = m.slice(1, -1);
        if (s.length > 3 && !s.includes('|') && !s.includes('QUEST[') && !s.includes('LEVEL') && !s.includes('ITEM[')) {
            // Check for English patterns like "get your level", "In ", "At the ", etc.
            if (/get your level \d+ abilities/i.test(s) || /since you are level/i.test(s) || /^\s*In\s*$/.test(s) || /from the/i.test(s) || /speak with/i.test(s) || /turn in/i.test(s)) {
                phrasePatterns.set(s, (phrasePatterns.get(s) || 0) + 1);
            }
        }
    }
}

console.log(`Total guides: ${totalGuides}, Total decoded chars: ${totalChars}`);
console.log('Sample high-frequency English patterns found across guides:');
const sorted = [...phrasePatterns.entries()].sort((a,b) => b[1] - a[1]);
console.log(sorted.slice(0, 30));
