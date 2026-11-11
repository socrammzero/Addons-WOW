const fs = require('fs');

const phrases = JSON.parse(fs.readFileSync('tools/phrases_0001_0021.json', 'utf8'));

// Filter out conditions, IDs, and pure Spanish
const spanishMarkers = [' de ', ' el ', ' la ', ' los ', ' las ', ' en ', ' con ', ' para ', ' por ', ' al ', ' del ', ' y ', ' que ', ' una ', ' uno '];

const trulyEnglish = phrases.filter(p => {
    // If it already has multiple Spanish markers and no distinct English words, it might be Spanish
    const isSpanish = spanishMarkers.filter(m => p.toLowerCase().includes(m)).length >= 2;
    const hasEnglish = /\b(the|and|to|of|in|for|from|with|at|your|kill|loot|speak|turn|accept|step|level|abilities|camp|cave|quest|get|have|this|that|hearth|run|go|head|die|res|buy|sell|equip|repair|first|next)\b/i.test(p);
    return hasEnglish || !isSpanish;
});

console.log(`Out of ${phrases.length} phrases, ${trulyEnglish.length} require English translation.`);

// Group by frequency across guides 0001-0021
const freq = new Map();
for (let i = 1; i <= 21; i++) {
    const pad = String(i).padStart(4, '0');
    const fPath = `src/Journey/BundledContent/Guides/${pad}.html`;
    if (!fs.existsSync(fPath)) continue;
    const raw = fs.readFileSync(fPath, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
    const decoded = Buffer.from(raw, 'base64').toString('utf8');
    for (const p of trulyEnglish) {
        if (decoded.includes(`"${p}"`)) {
            freq.set(p, (freq.get(p) || 0) + 1);
        }
    }
}

const sortedByFreq = [...freq.entries()].sort((a,b) => b[1] - a[1]);
console.log('Top 25 recurring English phrases across 0001-0021:');
console.log(sortedByFreq.slice(0, 25));

fs.writeFileSync('tools/truly_english_phrases.json', JSON.stringify(sortedByFreq.map(e => ({ phrase: e[0], count: e[1] })), null, 2));
