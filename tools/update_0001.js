const fs = require('fs');

const fPath = 'src/Journey/BundledContent/Guides/0001.html';
const raw = fs.readFileSync(fPath, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
let decoded = Buffer.from(raw, 'base64').toString('utf8');

const TRANSLATIONS_0001 = {
    ', get your level 4 abilities from the ': ', aprende tus facultades de nivel 4 con el ',
    'Get your level 4 abilities from the ': 'Aprende tus facultades de nivel 4 con el ',
    ', get your level 6 abilities from the ': ', aprende tus facultades de nivel 6 con el ',
    'Since you are level 6 now, get new spells/abilities.': 'Como ya eres nivel 6, aprende nuevos hechizos/facultades.',
    'The main goal now is to hit level 4 while starting the quest below.': 'El objetivo principal ahora es alcanzar nivel 4 mientras inicias la siguiente misión.',
    "Find Grund and Gozwin's camp in the hills to the northwest. Kill the Snow Leopard Prowler (easy to kill at level 4) and loot Gozwin's Mechanic's Log. It's a small book in the snow, in front of the Mechanostrider.": "Encuentra el campamento de Grund y Gozwin en las colinas al noroeste. Derrota al Acechador leopardo de las nieves (fácil de derrotar a nivel 4) y despoja el Diario de mecánico de Gozwin. Es un pequeño libro en la nieve, frente al Mecanotrote.",
    'In the troll cave, keep hugging the left side of the cave until you get to ': 'En la cueva trol, ve pegado a la izquierda hasta llegar a ',
    '  There is a lot in the cave (waypoint).': '  Hay muchos en la cueva (punto de ruta).',
    ' Do NOT buy any water, save your money for your Imp minion!': ' ¡NO compres agua, ahorra tu dinero para tu esbirro diablillo!',
    'Back in ': 'De vuelta en ',
    'In ': 'En ',
    ' and then ': ' y luego ',
    ', at the ': ', con el ',
    'Kill: %s': 'Derrota: %s',
    "Choose Mining for Dummies as your reward from Coldridge Valley Mail Delivery. Click the item in your bag to learn Mining. Open your Profession tab (K) and put 'Find Minerals' on your bars. Activate this skill to display nearby mining nodes on your minimap. Keep the stone and ore, you will need them later. We will not keep Mining permanently, this is to assist you with creating your casting wand, which will greatly help your early leveling damage.": "Elige Minería para novatos como recompensa de Entrega de correo de Crestanevada. Haz clic en el objeto en tu mochila para aprender Minería. Abre tu panel de profesiones (K) y pon Buscar minerales en tu barra de acción. Activa esta facultad para mostrar filones cercanos en tu minimapa. Guarda la piedra y las menas, las necesitarás más adelante. No mantendremos Minería permanentemente, esto es solo para ayudarte a fabricar tu varita, lo que aumentará mucho tu daño al inicio."
};

let count = 0;
for (const [en, es] of Object.entries(TRANSLATIONS_0001)) {
    const target = `"${en}"`;
    const replacement = `"${es}"`;
    if (decoded.includes(target)) {
        decoded = decoded.split(target).join(replacement);
        count++;
    }
}

console.log(`Replaced ${count} phrases in 0001.html`);

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
console.log('0001.html successfully written.');
