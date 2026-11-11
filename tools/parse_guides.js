const fs = require('fs');

const raw = fs.readFileSync('src/Journey/BundledContent/Guides/guides.html', 'utf8');
const stripped = raw.replace(/<[^>]+>/g, '').replace(/\s+/g, '');
const decoded = Buffer.from(stripped, 'base64').toString('utf8');

const blocks = decoded.split(/\{\s*guideID\s*=\s*"/);
const entries = [];
for (let i = 1; i < blocks.length; i++) {
    const block = blocks[i];
    const id = block.substring(0, block.indexOf('"'));
    const descMatch = block.match(/description\s*=\s*"([^"]+)"/);
    const groupMatch = block.match(/group\s*=\s*"([^"]+)"/);
    const levelsMatch = block.match(/levels\s*=\s*"([^"]+)"/);
    const factionMatch = block.match(/faction\s*=\s*"([^"]+)"/);
    const condMatch = block.match(/condition\s*=\s*"([^"]+)"/);
    const slotMatch = block.match(/slot\s*=\s*(\d+)/);
    const zoneMatch = block.match(/zone\s*=\s*(\d+)/);
    const productMatch = block.match(/productID\s*=\s*"([^"]+)"/);
    const flagsMatch = block.match(/flags\s*=\s*"([^"]+)"/);
    const recMatch = block.match(/recommended\s*=\s*"([^"]+)"/);

    entries.push({
        index: i,
        guideID: id,
        description: descMatch ? descMatch[1] : '',
        group: groupMatch ? groupMatch[1] : '',
        levels: levelsMatch ? levelsMatch[1] : '',
        faction: factionMatch ? factionMatch[1] : '',
        condition: condMatch ? condMatch[1] : '',
        slot: slotMatch ? slotMatch[1] : null,
        zone: zoneMatch ? zoneMatch[1] : null,
        productID: productMatch ? productMatch[1] : '',
        flags: flagsMatch ? flagsMatch[1] : '',
        recommended: recMatch ? recMatch[1] : ''
    });
}

console.log(`Total entries: ${entries.length}`);
const missingSlot = entries.filter(e => !e.slot);
console.log(`Entries without slot: ${missingSlot.length}`);

// Group by Group
const byGroup = {};
entries.forEach(e => {
    byGroup[e.group] = (byGroup[e.group] || 0) + 1;
});
console.log('Entries by group:', byGroup);

fs.writeFileSync('tools/guide_entries_summary.json', JSON.stringify(entries, null, 2));
console.log('Saved to tools/guide_entries_summary.json');
