const fs = require('fs');

function extractNarratives(decoded) {
    const lines = decoded.split('\n');
    const strings = new Set();
    
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
                // Must have English letters and not be already mostly Spanish
                const engWords = s.match(/\b(the|and|to|of|in|for|from|with|at|your|kill|loot|speak|turn|accept|level|abilities|get|buy|cave|camp|hearth|run|go|head|die|res|equip|repair|first|next|around|here|take|make|sure|follow|hand|talk|into|back|outside|inside|done|keep|reach|required|reward|learn|quest|until|again|sell|purchase|use|click|then|when|skip|note|tough|group|soloing|grind|mobs|patrol|watch|wait|right|left|north|south|east|west|up|down|upstairs|downstairs|ramp|room|house|inn|tent|path|road|lake|water|river|hill|mountain|bridge|tower|gate|spot|cave|spider|wolf|boar|trogg|troll|harpy|furbolg|defias|kobold)\b/gi) || [];
                if (engWords.length > 0) {
                    strings.add(s);
                }
            }
        }
    }
    return [...strings];
}

const allByFile = {};
let total = 0;
for (let i = 1; i <= 21; i++) {
    const pad = String(i).padStart(4, '0');
    const fPath = `src/Journey/BundledContent/Guides/${pad}.html`;
    if (!fs.existsSync(fPath)) continue;
    const raw = fs.readFileSync(fPath, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
    const dec = Buffer.from(raw, 'base64').toString('utf8');
    const list = extractNarratives(dec);
    allByFile[pad] = list;
    total += list.length;
}

console.log(`Found ${total} total English narrative entries across guides 0001-0021.`);
fs.writeFileSync('tools/narratives_by_guide_0001_0021.json', JSON.stringify(allByFile, null, 2));

for (let i = 1; i <= 21; i++) {
    const pad = String(i).padStart(4, '0');
    console.log(`Guide ${pad}: ${allByFile[pad] ? allByFile[pad].length : 0} phrases`);
}
