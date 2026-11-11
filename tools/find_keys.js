const fs = require('fs');
const path = require('path');

function walk(dir) {
    let results = [];
    const list = fs.readdirSync(dir);
    list.forEach(file => {
        const full = path.join(dir, file);
        const stat = fs.statSync(full);
        if (stat.isDirectory()) results = results.concat(walk(full));
        else if (file.endsWith('.lua')) results.push(full);
    });
    return results;
}

const files = walk('src/Journey');
const keys = new Set();
const regex = /L\["([^"\\]*(?:\\.[^"\\]*)*)"\]/g;

files.forEach(f => {
    const content = fs.readFileSync(f, 'utf8');
    let m;
    while ((m = regex.exec(content)) !== null) {
        keys.add(m[1]);
    }
});

console.log(`Found ${keys.size} keys:`);
[...keys].sort().forEach(k => console.log(`L["${k}"] = ""`));
