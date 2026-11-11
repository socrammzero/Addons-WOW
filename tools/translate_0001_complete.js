const fs = require('fs');

const MAP_0001 = {
    // Frases del paso actual (Dun Morogh nivel 4)
    'At the dwarf camp on the main path:': 'En el campamento enano en el camino principal:',
    ' has a 5 min time limit.  As long as you do not go AFK or something you should have plenty of time to get this in.': ' tiene un límite de tiempo de 5 min. Mientras no te quedes ausente, tendrás tiempo de sobra para entregarla.',
    'Hearth to the starting spot.': 'Usa la piedra de hogar hacia el punto de inicio.',
    'Accept your class quest:': 'Acepta la misión de tu clase:',
    'Get repaired / resupplied': 'Reparar armadura y reabastecerse',
    
    // Almacén y campamentos
    'At the small camp/tent:': 'En el pequeño campamento / tienda:',
    'Kill the required amount of Troggs.': 'Derrota la cantidad requerida de troggs.',
    'Done west and NW in ': 'Se realiza al oeste y noroeste en ',
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
    
    // Misiones y objetos
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
    
    // Reintentos y tiempo
    '  You lost your ': '  ¡Has perdido tu ',
    ', as the time limit was up for it!  You should go get a new one at the dwarf camp, and hurry back here before the 5 min time limit is up.': ', ¡porque se agotó el tiempo! Ve a buscar otra al campamento enano y regresa rápido antes de que pasen los 5 min.',
    'First abandon ': 'Primero abandona ',
    ', so you can get it again.': ', para poder aceptarla de nuevo.',
    'First go get a new mug at Dwarf camp!': '¡Primero ve a por otra jarra al campamento enano!',
    
    // Profesiones
    'Pick every Peacebloom you pass. Keep them for Alchemy.': 'Recoge cada Flor de paz que veas. Guárdalas para Alquimia.',
    'Pick every Silverleaf you pass. Keep them for Alchemy.': 'Recoge cada Hojaplata que veas. Guárdalas para Alquimia.',
    'Keep the meat you loot from beasts. Don\'t sell it; you will cook it in Kharanos to get your Cooking to 20.': 'Guarda la carne que despojes de las bestias. No la vendas; la cocinarás en Kharanos para subir Cocina a 20.',
    'Choose Pelt Collecting for Beginners as your reward from Coldridge Valley Mail Delivery. Click the item in your bag to learn Skinning. From now on, skin beasts to collect their leather scraps. Keep them; you will need them later.': 'Elige Recolección de pieles para principiantes como recompensa del correo de Crestanevada. Haz clic en el objeto en tu mochila para aprender Desuello. A partir de ahora, desuella bestias para recoger trozos de cuero. Guárdalos; los necesitarás más tarde.',
    'Collect 60 Leather Scraps': 'Consigue 60 trozos de cuero',
    'Aim to collect 20 Copper Ore from the Poor Copper Veins around Coldridge Valley. They are around the hills on the edges of the valley.': 'Intenta conseguir 20 menas de cobre de los filones pobres de cobre por Crestanevada. Están por las colinas en los bordes del valle.',
    'Under the red canopy, at Adlin Pridedrift: buy a Skinning Knife and an Apprentice\'s Skinning Satchel.': 'Bajo el dosel rojo, con Adlin Derivorgullo: compra un Cuchillo para desollar y una faltriquera de desollador aprendiz.',
    'Under the red canopy, at Adlin Pridedrift: buy a Mining Pick and an Apprentice\'s Mining Pack.': 'Bajo el dosel rojo, con Adlin Derivorgullo: compra un Pico de minero y una faltriquera de minero aprendiz.',
    'Mine the Poor Copper Veins in and around the Caves, you are aiming to get 20 Copper Ore. Keep this for an upcoming plan to craft your first wand.': 'Pica los filones pobres de cobre dentro y alrededor de las cuevas, el objetivo es conseguir 20 menas de cobre. Guárdalas para fabricar tu primera varita.',
    'Before you leave Coldridge Valley, mine the Poor Copper Veins until you have 20 Copper Ore. Veins: the hills north-west of Anvilmar on the way to Grund and Gozwin (25-28, 62-68), south around the Frostmane cave (19-24, 69-80), and the south-east hills (26-31, 78-83).': 'Antes de salir de Crestanevada, pica filones de cobre hasta tener 20 menas de cobre. Filones: colinas al noroeste de Yunquemar camino a Grund y Gozwin (25-28, 62-68), al sur alrededor de la cueva Melenafroste (19-24, 69-80), y colinas del sudeste (26-31, 78-83).',
    'Turn on Find Herbs from your minimap tracking, then pick every Peacebloom and Silverleaf you pass for the rest of the zone.': 'Activa Buscar hierbas en el minimapa y recoge cada Flor de paz y Hojaplata que encuentres.',
    'Level Herbalism to 20': 'Sube Herboristería a 20',
    'Level Skinning to 20': 'Sube Desuello a 20',
    'Level Mining to 20': 'Sube Minería a 20',
    'Choose Mining for Dummies as your reward from Coldridge Valley Mail Delivery. Click the item in your bag to learn Mining. Open your Profession tab (K) and put \'Find Minerals\' on your bars. Activate this skill to display nearby mining nodes on your minimap. Keep the stone and ore, you will need them later.': 'Elige Minería para novatos como recompensa. Haz clic en el objeto para aprender Minería. Abre tu panel de profesiones (K) y pon Buscar minerales en tu barra para ver filones en el minimapa. Guarda la piedra y menas.',

    // Brujos y misiones de clase
    'GROUP (or soloable):': 'GRUPO (o en solitario):',
    'TOUGH QUEST (can be soloable):': 'MISIÓN DIFÍCIL (posible en solitario):',
    'Imp Minion': 'Esbirro diablillo',
    '  It\'s wise to do your class\'s quest ASAP so you can get your ': '  Es muy recomendable hacer la misión de clase cuanto antes para conseguir tu ',
    '.  This quest is done south in the cave (entrance).  You would need to kill/loot the ': '. Esta misión se hace al sur en la cueva (entrada). Necesitarás derrotar y despojar a los ',
    ' which are sporadically spaced out around in the back of the cave.': ' que están repartidos al fondo de la cueva.',
    '  Try to group up with others in the cave if you can.': '  Intenta formar grupo con otros jugadores en la cueva si es posible.',
    '  This is possible to solo, but it\'s rough at lvl 2/3.  If you cannot do this now, you will be reminded later to try again.': '  Es posible en solitario, pero difícil a nivel 2/3. Si no puedes ahora, más adelante se te recordará volver a intentarlo.',
    'Behind the big fire pit, at the ': 'Detrás de la gran hoguera, junto a ',
    'Go up to enter ': 'Sube para entrar a ',
    'All the way back in ': 'Al fondo del todo en ',
    ', from the ': ', con el ',
    'And learn ': 'Y aprende ',
    'Learn ': 'Aprende ',
    ' R1.': ' R1.',
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
    'Head to the bottom of the hill, there is a path up the hill to Grund and Gozwin\'s camp .': 'Ve al pie de la colina, hay un sendero que sube hacia el campamento de Grund y Gozwin.',
    'Look left of the camp, and head to the nearby stone. Drink the Sapta.': 'Mira a la izquierda del campamento y acércate a la piedra cercana. Bebe la Sapta.',
    'To Grund Drokda. The bag you receive as a reward should automatically equip, giving you more bag space.': 'Con Grund Drokda. La bolsa que recibes se equipará automáticamente para darte más espacio.',
    ' east on the main path to the entrance of ': ' al este por el camino principal hacia la entrada de ',
    ' is complete!': ' ¡ha sido completada!',
    'Go to 6-12 Dun Morogh': 'Ve a 6-12 Dun Morogh'
};

const fPath = 'src/Journey/BundledContent/Guides/0001.html';
const raw = fs.readFileSync(fPath, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
let decoded = Buffer.from(raw, 'base64').toString('utf8');

let count = 0;
for (const [en, es] of Object.entries(MAP_0001)) {
    const target = `"${en}"`;
    const replacement = `"${es}"`;
    if (decoded.includes(target)) {
        decoded = decoded.split(target).join(replacement);
        count++;
    }
}

console.log(`Applied ${count} translation replacements to 0001.html`);

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
console.log('0001.html saved successfully.');
