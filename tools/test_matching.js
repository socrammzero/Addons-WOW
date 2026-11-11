const fs = require('fs');

const aData = JSON.parse(fs.readFileSync('tools/resources/alliance.json'));
const list = JSON.parse(fs.readFileSync('tools/guide_entries_summary.json'));
const missingA = list.filter(e => !e.slot && e.faction === 'Alliance');

// Normalize zone names
function normZone(z) {
    if (!z) return '';
    return z.toLowerCase().replace(/[^a-z]/g, '');
}

// Convert guide description to zone key
missingA.forEach(g => {
    const parts = g.description.split(' ');
    g.zoneName = parts.slice(1).join(' ');
    g.normZone = normZone(g.zoneName);
    const lvls = g.levels.split('-');
    g.minLvl = parseInt(lvls[0]);
    g.maxLvl = parseInt(lvls[1]);
});

// Flatten steps
const steps = [];
for (const s of Object.keys(aData)) {
    for (const st of Object.keys(aData[s])) {
        const items = aData[s][st];
        // find step level and zone
        let stepZone = '';
        let stepLvl = null;
        for (const item of items) {
            if (item[13] && !stepZone) stepZone = item[13];
            const m = (item[15] || '').match(/L(\d+)/);
            if (m && !stepLvl) stepLvl = parseInt(m[1]);
        }
        steps.push({
            section: parseInt(s),
            step: parseInt(st),
            zone: stepZone,
            normZone: normZone(stepZone),
            lvl: stepLvl,
            items: items
        });
    }
}

console.log('Total steps:', steps.length);

// We want to assign each step to one of the 50 guides.
// Filter out steps that are strictly level < 19 (which belong to 1-20 guides)
const validSteps = steps.filter(s => s.section >= 7); // sections 1-6 are 1-20
console.log('Steps for 20-60 (section >= 7):', validSteps.length);

let currentGuideIdx = 0;
const guideBuckets = missingA.map(g => ({ guide: g, steps: [] }));

for (const step of validSteps) {
    // Check if step zone matches current guide or nearby future guide
    let matched = false;
    // Look ahead up to 3 guides
    for (let offset = 0; offset <= 3 && (currentGuideIdx + offset) < missingA.length; offset++) {
        const candidate = missingA[currentGuideIdx + offset];
        if (candidate.normZone.includes(step.normZone) || step.normZone.includes(candidate.normZone) ||
            (step.normZone === 'shimmeringflats' && candidate.normZone.includes('thousandneedles')) ||
            (step.normZone === 'thousandneedles' && candidate.normZone.includes('shimmeringflats'))) {
            currentGuideIdx += offset;
            guideBuckets[currentGuideIdx].steps.push(step);
            matched = true;
            break;
        }
    }
    if (!matched) {
        // Fallback to current guide
        guideBuckets[currentGuideIdx].steps.push(step);
    }
}

guideBuckets.forEach((b, idx) => {
    console.log(`[${idx+1}] ${b.guide.guideID.padEnd(10)} ${b.guide.description.padEnd(28)} -> Steps: ${b.steps.length}`);
});
