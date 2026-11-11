const fs = require('fs');
const path = require('path');

function walk(dir) {
    let results = [];
    const list = fs.readdirSync(dir);
    list.forEach(file => {
        const fullPath = path.join(dir, file);
        const stat = fs.statSync(fullPath);
        if (stat && stat.isDirectory()) {
            if (file !== 'BundledContent' && file !== 'data') {
                results = results.concat(walk(fullPath));
            }
        } else if (file.endsWith('.lua')) {
            results.push(fullPath);
        }
    });
    return results;
}

const luaFiles = walk('src/Journey');
console.log('Total UI/Core Lua files scanned:', luaFiles.length);

const hardcodedEnglish = [];

const englishWords = [
    'the ', 'The ', 'Click ', 'click ', 'When ', 'when ', 'Guide', 'guide', 'Level', 'level',
    'Accept', 'accept', 'Turn in', 'turn in', 'Speak', 'speak', 'Complete', 'complete',
    'Follow', 'follow', 'Next', 'next', 'Show', 'show', 'Hide', 'hide', 'Option', 'option',
    'Setting', 'setting', 'Enable', 'enable', 'Disable', 'disable', 'Automatically', 'automatically',
    'Sound', 'sound', 'Window', 'window', 'Arrow', 'arrow', 'Raid', 'raid', 'Target', 'target',
    'Quest', 'quest', 'Item', 'item', 'Spell', 'spell', 'Ability', 'ability', 'Trainer', 'trainer'
];

luaFiles.forEach(f => {
    const content = fs.readFileSync(f, 'utf8');
    // find all literal strings "..." or '...'
    const matches = content.match(/"([^"\\]*(?:\\.[^"\\]*)*)"/g) || [];
    matches.forEach(m => {
        const s = m.slice(1, -1);
        if (s.length > 5 && !s.includes('|') && !s.startsWith('%') && !s.includes('/') && !s.startsWith('UI_')) {
            if (englishWords.some(w => s.includes(w))) {
                // Ignore if it's already in esES/esMX or if it's in a localization file
                if (!f.includes('lang') && !f.includes('QuestInfo') && !f.includes('WMOAreas')) {
                    hardcodedEnglish.push({ file: f.replace(/\\/g, '/'), string: s });
                }
            }
        }
    });
});

console.log('Hardcoded English occurrences in UI/Core:', hardcodedEnglish.length);
fs.writeFileSync('tools/hardcoded_ui_english.json', JSON.stringify(hardcodedEnglish, null, 2));

const byFile = {};
hardcodedEnglish.forEach(item => {
    byFile[item.file] = (byFile[item.file] || 0) + 1;
});
console.log('Occurrences by file:', byFile);
