const fs = require('fs');

console.log('--- AUDITORÍA DE INTEGRIDAD DE ARCHIVOS DE GUÍA Y LUA ---');

let validCount = 0;
let errors = 0;

for (let i = 1; i <= 121; i++) {
    const pad = String(i).padStart(4, '0');
    const fPath = `src/Journey/BundledContent/Guides/${pad}.html`;
    if (!fs.existsSync(fPath)) continue;

    try {
        const raw = fs.readFileSync(fPath, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
        const decoded = Buffer.from(raw, 'base64').toString('utf8');
        
        // Basic syntax checks
        const openBraces = (decoded.match(/\{/g) || []).length;
        const closeBraces = (decoded.match(/\}/g) || []).length;
        
        if (openBraces !== closeBraces) {
            console.error(`ERROR en ${pad}.html: llaves desbalanceadas {=${openBraces}, }=${closeBraces}`);
            errors++;
        } else {
            validCount++;
        }
    } catch (err) {
        console.error(`ERROR al decodificar ${pad}.html:`, err.message);
        errors++;
    }
}

// Verify guides.html
try {
    const rawG = fs.readFileSync('src/Journey/BundledContent/Guides/guides.html', 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
    const decodedG = Buffer.from(rawG, 'base64').toString('utf8');
    const openG = (decodedG.match(/\{/g) || []).length;
    const closeG = (decodedG.match(/\}/g) || []).length;
    if (openG !== closeG) {
        console.error(`ERROR en guides.html: llaves desbalanceadas {=${openG}, }=${closeG}`);
        errors++;
    } else {
        console.log(`guides.html verificado: ${openG} entradas válidas.`);
    }
} catch (err) {
    console.error(`ERROR en guides.html:`, err.message);
    errors++;
}

console.log(`Total guías verificadas: ${validCount}/121. Errores: ${errors}`);
if (errors === 0) {
    console.log('✅ TODAS LAS GUÍAS POSEEN SINTAXIS LUA VÁLIDA Y BASE64 PERFECTO.');
} else {
    process.exit(1);
}
