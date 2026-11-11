const fs = require('fs');

const TRANSLATIONS = [
    { en: '"In front of you:"', es: '"Frente a ti:"' },
    { en: '"Next to you:"', es: '"Junto a ti:"' },
    { en: '"Right behind you:"', es: '"Justo detrás de ti:"' },
    { en: '"Across from you:"', es: '"Frente a ti al otro lado:"' },
    { en: '"In the distance:"', es: '"A lo lejos:"' },
    { en: '"Back at the starting spot:"', es: '"De vuelta al punto de inicio:"' },
    { en: '"Head to the starting spot:"', es: '"Dirígete al punto de inicio:"' },
    { en: '"Around the area"', es: '"Alrededor de la zona"' },
    { en: '"Around: %s"', es: '"Alrededor de: %s"' },
    { en: '"Follow waypoint"', es: '"Sigue el punto de ruta"' },
    { en: '"Follow waypoint out of noob area"', es: '"Sigue el punto de ruta fuera de la zona inicial"' },
    { en: '"Follow waypoint to exit %s"', es: '"Sigue el punto de ruta para salir de %s"' },
    { en: '"Exit: %s"', es: '"Salir de: %s"' },
    { en: '"Enter: %s"', es: '"Entrar a: %s"' },
    { en: '"Go through: %s"', es: '"Atraviesa: %s"' },
    { en: '"Exit room"', es: '"Sal de la habitación"' },
    { en: '"Exit Inn"', es: '"Sal de la posada"' },
    { en: '"Enter Inn"', es: '"Entra a la posada"' },
    { en: '"Exit AH"', es: '"Sal de la subasta"' },
    { en: '"Exit Bank"', es: '"Sal del banco"' },
    { en: '"Exit: Hall of Arms"', es: '"Salir de: Sala de las Armas"' },
    { en: '"Go through tunnel"', es: '"Atraviesa el túnel"' },
    { en: '"Go across bridge"', es: '"Cruza el puente"' },
    { en: '"Go up ramp"', es: '"Sube por la rampa"' },
    { en: '"Go up steps"', es: '"Sube por las escaleras"' },
    { en: '"Go upstairs"', es: '"Sube al piso de arriba"' },
    { en: '"Go up spiral ramp"', es: '"Sube por la rampa de caracol"' },
    { en: '"At the top"', es: '"En la cima"' },
    { en: '"At the bottom"', es: '"En el fondo"' },
    { en: '"Skip This?"', es: '"¿Omitir esto?"' },
    { en: '"SKIP "', es: '"OMITIR "' },
    { en: '" (for now)"', es: '" (por ahora)"' },
    { en: '"Back at the starting spot sell junk to gain money."', es: '"De vuelta al punto de inicio, vende chatarra para conseguir dinero."' },
    { en: '"Purchase a stack or two of:"', es: '"Compra una o dos pilas de:"' },
    { en: '"Purchase at least 4 stacks of:"', es: '"Compra al menos 4 pilas de:"' },
    { en: '"Do NOT buy any water, save your money for your Imp minion!"', es: '"¡NO compres agua, ahorra tu dinero para tu esbirro diablillo!"' },
    { en: '"Do NOT buy any food, save your money!"', es: '"¡NO compres comida, ahorra tu dinero!"' },
    { en: '"Save your money for abilities!"', es: '"¡Ahorra tu dinero para habilidades!"' },
    { en: '"Warrior Trainer"', es: '"Instructor de guerreros"' },
    { en: '"Hunter Trainer"', es: '"Instructor de cazadores"' },
    { en: '"Rogue Trainer"', es: '"Instructor de pícaros"' },
    { en: '"Priest Trainer"', es: '"Instructor de sacerdotes"' },
    { en: '"Mage Trainer"', es: '"Instructor de magos"' },
    { en: '"Warlock Trainer"', es: '"Instructor de brujos"' },
    { en: '"Paladin Trainer"', es: '"Instructor de paladines"' },
    { en: '"Shaman Trainer"', es: '"Instructor de chamanes"' },
    { en: '"Druid Trainer"', es: '"Instructor de druidas"' },
    { en: '"Weapon Master"', es: '"Maestro de armas"' },
    { en: '"Spirit Healer"', es: '"Ángel de la Resurrección"' },
    { en: '"Next Destination"', es: '"Siguiente destino"' },
    { en: '"Get resupplied"', es: '"Reabastecerse"' },
    { en: '"Get supplies"', es: '"Conseguir suministros"' },
    { en: '"Sell junk and Resupply"', es: '"Vender chatarra y reabastecerse"' },
    { en: '"Sell junk, Repair, and Resupply"', es: '"Vender chatarra, reparar y reabastecerse"' },
    { en: '"Kill/loot wolves."', es: '"Mata y despoja lobos."' },
    { en: '"Kill/loot troggs."', es: '"Mata y despoja troggs."' },
    { en: '"Kill/loot boars."', es: '"Mata y despoja jabalíes."' },
    { en: '"Kill/loot "', es: '"Mata y despoja "' },
    { en: '"Kill and loot "', es: '"Mata y despoja "' },
    { en: '"Res at "', es: '"Revive en "' },
    { en: '"At the "', es: '"En "' },
    { en: '"SoD Rune Quest:"', es: '"Misión de runa de SoD:"' }
];

// Dynamic replacements for Kill/loot and Res at
function dynamicReplacements(text) {
    let res = text;
    // Replace "Kill/loot ..." with "Mata y despoja ..."
    res = res.replace(/"Kill\/loot ([^"]+)"/g, (match, p1) => `"Mata y despoja ${p1}"`);
    // Replace "Kill and loot ..." with "Mata y despoja ..."
    res = res.replace(/"Kill and loot ([^"]+)"/g, (match, p1) => `"Mata y despoja ${p1}"`);
    // Replace "Res at ..." with "Revive en ..."
    res = res.replace(/"Res at ([^"]+)"/g, (match, p1) => `"Revive en ${p1}"`);
    // Replace "Enter ..." with "Entra a ..."
    res = res.replace(/"Enter ([A-Z][^"]+)"/g, (match, p1) => `"Entra a ${p1}"`);
    // Replace "Exit ..." with "Sal de ..."
    res = res.replace(/"Exit ([A-Z][^"]+)"/g, (match, p1) => `"Sal de ${p1}"`);
    return res;
}

console.log('Translating labels and narrative phrases in 0001-0021.html...');

for (let i = 1; i <= 21; i++) {
    const pad = String(i).padStart(4, '0');
    const fPath = `src/Journey/BundledContent/Guides/${pad}.html`;
    if (!fs.existsSync(fPath)) continue;

    const raw = fs.readFileSync(fPath, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
    let decoded = Buffer.from(raw, 'base64').toString('utf8');

    let count = 0;
    for (const t of TRANSLATIONS) {
        if (decoded.includes(t.en)) {
            decoded = decoded.split(t.en).join(t.es);
            count++;
        }
    }

    const beforeDyn = decoded;
    decoded = dynamicReplacements(decoded);
    if (beforeDyn !== decoded) {
        count++;
    }

    if (count > 0) {
        console.log(`[${pad}.html] Applied ${count} translation replacements.`);
        const newB64 = Buffer.from(decoded, 'utf8').toString('base64');
        const lines = newB64.match(/.{1,76}/g).join('\r\n');
        const html = `<!-- Copyright (c) 2006-2026 TomCat's Gaming, LLC. All Rights Reserved.
     Unauthorized use, reproduction, or distribution is prohibited.
     See license.txt included with this distribution for full terms. -->
<html>
\t<head></head>
\t<body>
\t\t<p>
${lines}
\t\t</p>
\t</body>
</html>\r\n`;
        fs.writeFileSync(fPath, html, 'utf8');
    }
}

console.log('Finished translating early guides.');
