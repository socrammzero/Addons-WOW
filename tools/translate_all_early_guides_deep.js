const fs = require('fs');

// Extensive phrase dictionary for WoW Classic early guides (1-20)
const DICT = {
    // Campamentos y lugares
    'At the dwarf camp on the main path:': 'En el campamento enano en el camino principal:',
    'At the small camp/tent:': 'En el pequeño campamento / tienda:',
    'Back at the small camp/tent:': 'De vuelta al pequeño campamento / tienda:',
    'At the small dwarf camp:': 'En el pequeño campamento enano:',
    'Back at the small dwarf camp:': 'De vuelta al pequeño campamento enano:',
    'Under the red canopy:': 'Bajo el dosel rojo:',
    'Under the red canopy, purchase a stack or two of:': 'Bajo el dosel rojo, compra una o dos pilas de:',
    'At the starting spot:': 'En el punto de inicio:',
    'At the entrance of ': 'En la entrada de ',
    'Bottom of the hill': 'Al pie de la colina',
    'Go up the hill': 'Sube la colina',
    'Enter back room': 'Entra a la sala del fondo',
    'Next to the road:': 'Junto al camino:',
    'Across the road:': 'Al otro lado del camino:',
    'Inside the building:': 'Dentro del edificio:',
    'Inside the tent:': 'Dentro de la tienda:',
    'Inside the tower:': 'Dentro de la torre:',
    'Inside the cave:': 'Dentro de la cueva:',
    'Outside the cave:': 'Fuera de la cueva:',
    'Outside the building:': 'Fuera del edificio:',
    'On the road:': 'En el camino:',
    'On the hill:': 'En la colina:',
    'On the platform:': 'En la plataforma:',
    'Upstairs:': 'Arriba:',
    'Downstairs:': 'Abajo:',

    // Cuevas y viajes
    'Cave entrance': 'Entrada a la cueva',
    'Cave Entrance': 'Entrada a la cueva',
    'Exit cave': 'Sal de la cueva',
    'Exit the cave...': 'Sal de la cueva...',
    'Enter cave': 'Entra a la cueva',
    'Go through cave': 'Atraviesa la cueva',
    'Now die on purpose and res at spirit.': 'Ahora muere a propósito y revive en el ángel.',
    'Die on purpose and res at spirit.': 'Muere a propósito y revive en el ángel.',
    'Hearth, or die on purpose and res at spirit.': 'Usa piedra de hogar, o muere a propósito y revive en el ángel.',
    'Hearth to the starting spot.': 'Usa la piedra de hogar hacia el punto de inicio.',
    'Accept your class quest:': 'Acepta la misión de tu clase:',
    'Get repaired / resupplied': 'Reparar armadura y reabastecerse',
    'Go up to enter ': 'Sube para entrar a ',
    'Behind the big fire pit, at the ': 'Detrás de la gran hoguera, junto a ',
    'All the way back in ': 'Al fondo del todo en ',
    ', from the ': ', con el ',
    'And learn ': 'Y aprende ',
    'Learn ': 'Aprende ',
    'Turning this in will give you ': 'Al entregar esto recibirás ',
    '  Turning this in will give you ': '  Al entregar esto recibirás ',
    '  Make sure you use ': '  Asegúrate de usar ',
    ' at the big fire pit.': ' junto a la gran hoguera.',
    ' next to the big fire pit.': ' al lado de la gran hoguera.',
    ' in the room with the big fire pit.': ' en la sala de la gran hoguera.',
    ' next to you.': ' junto a ti.',
    ' up in the back of ': ' arriba al fondo de ',
    '.  Make sure you get ': '. Asegúrate de conseguir ',
    ' first, followed by ': ' primero, seguido de ',
    'Buy %s?': '¿Comprar %s?',
    'Exit ': 'Sal de ',
    '%s mostly around here': '%s principalmente por aquí',
    'Kill %s': 'Mata a %s',
    'Loot: %s': 'Despoja: %s',
    'Kill/loot: %s': 'Mata y despoja: %s',

    // Límites de tiempo
    ' has a 5 min time limit.  As long as you do not go AFK or something you should have plenty of time to get this in.': ' tiene un límite de tiempo de 5 min. Mientras no te quedes ausente, tendrás tiempo de sobra para entregarla.',
    '  You lost your ': '  ¡Has perdido tu ',
    ', as the time limit was up for it!  You should go get a new one at the dwarf camp, and hurry back here before the 5 min time limit is up.': ', ¡porque se agotó el tiempo! Ve a buscar otra al campamento enano y regresa rápido antes de que pasen los 5 min.',
    'First abandon ': 'Primero abandona ',
    ', so you can get it again.': ', para poder aceptarla de nuevo.',
    'First go get a new mug at Dwarf camp!': '¡Primero ve a por otra jarra al campamento enano!',

    // Misiones y combate
    'Kill the required amount of Troggs.': 'Derrota la cantidad requerida de troggs.',
    'Done west and NW in ': 'Se realiza al oeste y noroeste en ',
    'Loot the 3 objects at the troll camps.': 'Despoja los 3 objetos en los campamentos trol.',
    'Collect 2 Frostmane Bear Pendants from the Trolls': 'Consigue 2 colgantes de oso Melenafroste de los trols',
    'First loot ': 'Primero despoja ',
    ' (next to the ': ' (junto a ',
    'Loot ': 'Despoja ',
    ' and kill/loot this troll.': ' y mata y despoja a este trol.',
    'Frostmane Novices': 'Novicios Melenafroste',
    ' scattered around in the back of the cave.': ' repartidos al fondo de la cueva.',
    'The Troggs are scattered all around ': 'Los troggs están repartidos por todo ',
    'Rockjaw Troggs': 'Troggs Quijadadura',
    ' are mostly east.': ' están principalmente al este.',
    'Burly Rockjaw Troggs': 'Troggs Quijadadura fornidos',
    ' are scattered everywhere.': ' están repartidos por todas partes.',
    'GROUP (or soloable):': 'GRUPO (o en solitario):',
    'TOUGH QUEST (can be soloable):': 'MISIÓN DIFÍCIL (posible en solitario):',
    'Imp Minion': 'Esbirro diablillo',
    '  It\'s wise to do your class\'s quest ASAP so you can get your ': '  Es muy recomendable hacer la misión de clase cuanto antes para conseguir tu ',
    '.  This quest is done south in the cave (entrance).  You would need to kill/loot the ': '. Esta misión se hace al sur en la cueva (entrada). Necesitarás derrotar y despojar a los ',
    ' which are sporadically spaced out around in the back of the cave.': ' que están repartidos al fondo de la cueva.',
    '  Try to group up with others in the cave if you can.': '  Intenta formar grupo con otros jugadores en la cueva si es posible.',
    '  This is possible to solo, but it\'s rough at lvl 2/3.  If you cannot do this now, you will be reminded later to try again.': '  Es posible en solitario, pero difícil a nivel 2/3. Si no puedes ahora, más adelante se te recordará volver a intentarlo.',

    // Profesiones
    'Pick every Peacebloom you pass. Keep them for Alchemy.': 'Recoge cada Flor de paz que veas. Guárdalas para Alquimia.',
    'Pick every Silverleaf you pass. Keep them for Alchemy.': 'Recoge cada Hojaplata que veas. Guárdalas para Alquimia.',
    'Keep the meat you loot from beasts. Don\'t sell it; you will cook it in Kharanos to get your Cooking to 20.': 'Guarda la carne que despojes de las bestias. No la vendas; la cocinarás en Kharanos para subir Cocina a 20.',
    'Collect 60 Leather Scraps': 'Consigue 60 trozos de cuero',
    'Level Herbalism to 20': 'Sube Herboristería a 20',
    'Level Skinning to 20': 'Sube Desuello a 20',
    'Level Mining to 20': 'Sube Minería a 20',
    'Level Cooking to 20': 'Sube Cocina a 20',
    'Level First Aid to 20': 'Sube Primeros auxilios a 20',

    // Finalización de zonas
    ' is complete!': ' ¡ha sido completada!',
    'Go to 6-12 Dun Morogh': 'Ve a 6-12 Dun Morogh',
    'Go to 6-10 Elwynn Forest': 'Ve a 6-10 Bosque de Elwynn',
    'Go to 6-12 Teldrassil': 'Ve a 6-12 Teldrassil',
    'Go to 6-10 Durotar': 'Ve a 6-10 Durotar',
    'Go to 6-10 Mulgore': 'Ve a 6-10 Mulgore',
    'Go to 6-10 Tirisfal Glades': 'Ve a 6-10 Claros de Tirisfal'
};

console.log('Applying comprehensive dictionary to 0001-0021.html...');

let totalReplacements = 0;
for (let i = 1; i <= 21; i++) {
    const pad = String(i).padStart(4, '0');
    const fPath = `src/Journey/BundledContent/Guides/${pad}.html`;
    if (!fs.existsSync(fPath)) continue;

    const raw = fs.readFileSync(fPath, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
    let decoded = Buffer.from(raw, 'base64').toString('utf8');

    let count = 0;
    for (const [en, es] of Object.entries(DICT)) {
        const target = `"${en}"`;
        const replacement = `"${es}"`;
        if (decoded.includes(target)) {
            decoded = decoded.split(target).join(replacement);
            count++;
        }
    }

    if (count > 0) {
        totalReplacements += count;
        console.log(`[${pad}.html] Replaced ${count} phrases.`);
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

console.log(`Deep translation completed. Total phrases replaced: ${totalReplacements}`);
