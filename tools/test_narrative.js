const fs = require('fs');

function extractNarrative(decoded) {
    const lines = decoded.split('\n');
    const narrativeStrings = new Set();
    
    for (const line of lines) {
        const trimmed = line.trim();
        // Ignore lines that are conditions or internal properties
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

        // Match string literals
        const matches = line.match(/"([^"\\]*(?:\\.[^"\\]*)*)"/g) || [];
        for (const m of matches) {
            const s = m.slice(1, -1);
            // Skip coordinates
            if (s.includes('|') || s.startsWith('BW|') || s.startsWith('CV|')) continue;
            // Skip pure condition expressions that might be inline: condition = "..."
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

const raw0001 = fs.readFileSync('src/Journey/BundledContent/Guides/0001.html', 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
const dec0001 = Buffer.from(raw0001, 'base64').toString('utf8');
const nar0001 = extractNarrative(dec0001);

console.log(`Extracted ${nar0001.length} narrative strings from 0001.html`);
const english0001 = nar0001.filter(s => /\b(the|and|to|of|in|for|from|with|at|your|kill|loot|speak|turn|accept|level|abilities|get|buy|cave)\b/i.test(s));
console.log(`English narrative strings in 0001.html: ${english0001.length}`);
console.log('Sample English in 0001.html:', english0001.slice(0, 20));
