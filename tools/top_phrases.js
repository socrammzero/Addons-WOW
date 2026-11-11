const fs = require('fs');

const counts = {};
for (let i = 1; i <= 21; i++) {
    const pad = String(i).padStart(4, '0');
    const f = `src/Journey/BundledContent/Guides/${pad}.html`;
    if (!fs.existsSync(f)) continue;
    const raw = fs.readFileSync(f, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
    const decoded = Buffer.from(raw, 'base64').toString('utf8');
    const matches = decoded.match(/"([^"\\]*(?:\\.[^"\\]*)*)"/g) || [];
    for (const m of matches) {
        const s = m.slice(1, -1);
        if (s.length > 3 && s.includes(' ') && !s.startsWith('|') && !s.startsWith('BW|') && !s.includes('CV|') && !s.includes('QUEST[')) {
            counts[s] = (counts[s] || 0) + 1;
        }
    }
}

const sorted = Object.entries(counts).sort((a,b) => b[1] - a[1]);
console.log('Top 40 phrases:');
sorted.slice(0, 40).forEach(([k, v]) => console.log(`${v}: "${k}"`));
