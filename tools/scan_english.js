const fs = require('fs');

function getStrings(filePath) {
    if (!fs.existsSync(filePath)) return [];
    const raw = fs.readFileSync(filePath, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
    const decoded = Buffer.from(raw, 'base64').toString('utf8');
    const matches = decoded.match(/"([^"\\]*(?:\\.[^"\\]*)*)"/g) || [];
    return matches.map(m => m.slice(1, -1));
}

const allStrings = new Map(); // string -> array of files
for (let i = 1; i <= 121; i++) {
    const pad = String(i).padStart(4, '0');
    const fp = 'src/Journey/BundledContent/Guides/' + pad + '.html';
    const list = getStrings(fp);
    for (const s of list) {
        if (s.length > 3 && !s.includes('|') && !s.match(/^[0-9A-Z_ -]+$/) && !s.includes('QUEST[') && !s.includes('LEVEL') && !s.includes('ITEM[')) {
            if (!allStrings.has(s)) allStrings.set(s, []);
            allStrings.get(s).push(pad);
        }
    }
}

console.log('Total extracted unique candidate strings:', allStrings.size);

const englishKeywords = [
    ' the ', ' the', 'The ', ' to ', ' from ', ' with ', ' and ', ' at ', ' of ', ' on ', ' in ', ' for ', 
    ' get ', 'Get ', ' your ', ' level ', ' abilities ', ' kill ', 'Kill ', ' loot ', 'Loot ', ' speak ', 
    'Speak ', ' turn ', 'Turn ', ' accept ', 'Accept ', ' buy ', 'Buy ', ' quest', 'Quest', ' cave', 'Cave', 
    ' camp', 'Camp', ' you ', 'You ', ' will ', ' are ', ' have ', ' has ', ' this ', 'This ', ' that ',
    ' first', ' then ', ' now', 'Now', ' around ', ' here', ' make ', ' sure ', ' take ', 'Take ', ' go ', 'Go '
];

const results = [];
for (const [str, files] of allStrings.entries()) {
    if (englishKeywords.some(kw => str.includes(kw))) {
        // filter out already Spanish strings that might contain short substrings
        const spanishWords = [' de ', ' en ', ' el ', ' la ', ' los ', ' las ', ' para ', ' por ', ' con ', ' del ', ' al '];
        // If it contains distinctly English words
        const englishSpecific = [' the ', 'The ', ' from ', ' with ', ' and ', ' at ', ' of ', ' your ', ' abilities', ' kill ', 'Kill ', ' loot', 'Loot', ' speak ', 'Speak ', ' buy ', 'Buy ', ' around ', ' first', ' then ', ' here', ' sure'];
        if (englishSpecific.some(w => str.includes(w)) || !spanishWords.some(w => str.includes(w))) {
            results.push({ text: str, occurrences: files.length, sampleFile: files[0] });
        }
    }
}

console.log('Potential English strings found:', results.length);
fs.writeFileSync('tools/potential_english_strings.json', JSON.stringify(results, null, 2));

// Print top 30
console.log(results.slice(0, 30));
