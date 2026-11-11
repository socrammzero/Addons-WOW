const fs = require('fs');

function extractNarrative(decoded) {
    const lines = decoded.split('\n');
    const narrativeStrings = new Set();
    
    for (const line of lines) {
        const trimmed = line.trim();
        if (trimmed.startsWith('condition =') || 
            trimmed.startsWith('id =') || 
            trimmed.startsWith('flags =') || 
            trimmed.startsWith('productID =') || 
            trimmed.startsWith('contentHash =') ||
            trimmed.startsWith('group =') ||
            trimmed.startsWith('--') ||
            trimmed.startsWith('guideID =')) {
            continue;
        }

        const matches = line.match(/"([^"\\]*(?:\\.[^"\\]*)*)"/g) || [];
        for (const m of matches) {
            const s = m.slice(1, -1);
            if (s.includes('|') || s.startsWith('BW|') || s.startsWith('CV|')) continue;
            if (line.includes(`condition = "${s}"`)) continue;
            if (line.includes(`id = "${s}"`)) continue;
            if (line.includes(`flags = "${s}"`)) continue;
            if (line.includes(`productID = "${s}"`)) continue;

            if (s.length > 2 && /[a-zA-Z]/.test(s)) {
                narrativeStrings.add(s);
            }
        }
    }
    return [...narrativeStrings];
}

const allNarratives = new Map();

for (let i = 1; i <= 121; i++) {
    const pad = String(i).padStart(4, '0');
    const fPath = `src/Journey/BundledContent/Guides/${pad}.html`;
    if (!fs.existsSync(fPath)) continue;
    const raw = fs.readFileSync(fPath, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
    const dec = Buffer.from(raw, 'base64').toString('utf8');
    const nar = extractNarrative(dec);
    for (const s of nar) {
        if (!allNarratives.has(s)) allNarratives.set(s, []);
        allNarratives.get(s).push(pad);
    }
}

console.log(`Total unique narrative strings across all 121 guides: ${allNarratives.size}`);

const englishWords = /\b(the|and|to|of|in|for|from|with|at|your|kill|loot|speak|turn|accept|level|abilities|get|buy|cave|camp|hearth|run|go|head|die|res|equip|repair|first|next|around|here|take|make|sure|follow|hand|talk|into|back|outside|inside|done|keep|reach|required|reward|learn|quest|npc|until|again)\b/i;

const englishNarratives = [];
for (const [s, files] of allNarratives.entries()) {
    if (englishWords.test(s)) {
        // filter out pure Spanish strings that coincidentally contain a short word like 'in' in 'información'
        const spanishWords = /\b(de|el|la|los|las|en|con|para|por|al|del|que|una|uno|habla|mata|despoja|ve|campamento|cueva|punto|inicio|entrega|acepta|nivel|misión)\b/i;
        // Count distinct English words
        const engMatches = s.match(/\b(the|and|to|of|in|for|from|with|at|your|kill|loot|speak|turn|accept|level|abilities|get|buy|cave|camp|hearth|run|go|head|die|res|equip|repair|first|next|around|here|take|make|sure|follow|hand|talk|into|back|outside|inside|done|keep|reach|required|reward|learn|quest|until|again)\b/gi) || [];
        const spanMatches = s.match(/\b(de|el|la|los|las|en|con|para|por|al|del|que|una|uno|habla|mata|despoja|ve|campamento|cueva|punto|inicio|entrega|acepta|nivel|misión)\b/gi) || [];
        
        if (engMatches.length > spanMatches.length || engMatches.length >= 2) {
            englishNarratives.push({ text: s, occurrences: files.length, sampleFile: files[0] });
        }
    }
}

console.log(`Identified ${englishNarratives.length} English narrative strings across all guides.`);
fs.writeFileSync('tools/all_english_narratives.json', JSON.stringify(englishNarratives, null, 2));

console.log('Sample top 30 by occurrences:');
englishNarratives.sort((a,b) => b.occurrences - a.occurrences);
console.log(englishNarratives.slice(0, 30));
