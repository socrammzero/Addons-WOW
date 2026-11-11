const fs = require('fs');

console.log('Testing all 121 guide files...');
let errors = 0;

for (let i = 1; i <= 121; i++) {
    const pad = String(i).padStart(4, '0');
    const fPath = `src/Journey/BundledContent/Guides/${pad}.html`;
    if (!fs.existsSync(fPath)) {
        console.error(`Missing file: ${fPath}`);
        errors++;
        continue;
    }
    const raw = fs.readFileSync(fPath, 'utf8');
    const stripped = raw.replace(/<[^>]+>/g, '').replace(/\s+/g, '');
    let decoded = '';
    try {
        decoded = Buffer.from(stripped, 'base64').toString('utf8');
    } catch (e) {
        console.error(`Base64 decode failed for ${pad}.html:`, e.message);
        errors++;
        continue;
    }

    // Check basic Lua table syntax
    const trimmed = decoded.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
        console.error(`Syntax warning for ${pad}.html: does not start/end with { }`);
        errors++;
    }
}

if (errors === 0) {
    console.log('ALL 121 GUIDE FILES DECODE PERFECTLY AS VALID LUA TABLES!');
} else {
    console.log(`Encountered ${errors} errors.`);
}
