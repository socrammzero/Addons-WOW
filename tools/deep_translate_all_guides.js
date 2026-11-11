const fs = require('fs');

// Comprehensive dictionary for WoW narrative translations
const DICT = {
    // Fragmentos comunes de multitext
    "Done around southern ": "Se realiza al sur de ",
    "Done around northern ": "Se realiza al norte de ",
    "Done around eastern ": "Se realiza al este de ",
    "Done around western ": "Se realiza al oeste de ",
    "Done north of ": "Se realiza al norte de ",
    "Done south of ": "Se realiza al sur de ",
    "Done east of ": "Se realiza al este de ",
    "Done west of ": "Se realiza al oeste de ",
    "Done west and NW in ": "Se realiza al oeste y noroeste en ",
    "Then head ": "Luego dirígete ",
    "Then head": "Luego dirígete",
    "Head ": "Dirígete ",
    "Just outside of ": "Justo a las afueras de ",
    "Just outside of the ": "Justo a las afueras de la ",
    "Just inside of ": "Justo dentro de ",
    "Just inside of Northshire Abbey": "Justo dentro de la Abadía de Villanorte",
    "Outside on the NW side yard of ": "Afuera en el patio noroeste de ",
    "Go to the east outside graveyard of ": "Ve al cementerio exterior al este de ",
    " Go inside ": " Entra a ",
    "Go inside ": "Entra a ",
    " and at the end of it loot ": " y al final de este despoja ",
    " are just north of ": " están justo al norte de ",
    " are just south of ": " están justo al sur de ",
    " are just east of ": " están justo al este de ",
    " are just west of ": " están justo al oeste de ",
    "Stay at the bottom floor to get to the ": "Quédate en la planta baja para llegar a ",
    " and learn new spells/abilities.": " y aprende nuevos hechizos/facultades.",
    " learn new spells/abilities.": " aprende nuevos hechizos/facultades.",
    "Go up stairs": "Sube las escaleras",
    "Go up steps": "Sube los escalones",
    "Go up the steps inside ": "Sube los escalones dentro de ",
    "Go down stairs": "Baja las escaleras",
    "Go down steps": "Baja los escalones",
    ", to learn ": ", para aprender ",
    " wolves.  They are scattered all around the starting area (but west of the river).": " lobos. Están repartidos por toda la zona inicial (al oeste del río).",
    " wolves. They are scattered all around the starting area (but west of the river).": " lobos. Están repartidos por toda la zona inicial (al oeste del río).",
    "Keep the meat you loot from beasts. Don't sell it; you will cook it in Goldshire to get your Cooking to 20.": "Guarda la carne que despojes de las bestias. No la vendas; la cocinarás en Villadorada para subir Cocina a 20.",
    "First make sure you have 1 silver and 10 copper.  Keep grinding and selling junk items until you achieve that.": "Primero asegúrate de tener 1 plata y 10 cobres. Sigue matando y vendiendo chatarra hasta conseguirlo.",
    "First make sure you have 1 silver and 10 copper. Keep grinding and selling junk items until you achieve that.": "Primero asegúrate de tener 1 plata y 10 cobres. Sigue matando y vendiendo chatarra hasta conseguirlo.",
    ".  There are multiple camps up north and there is a larger concentration before the cave entrance around the waypoint.": ". Hay múltiples campamentos al norte y mayor concentración antes de la entrada de la cueva junto al punto de ruta.",
    "Continue killing any Kobolds around here until the quest is complete": "Sigue derrotando a los kóbold de por aquí hasta completar la misión.",
    "As you work your way back to the vendors, grind until you reach the desired XP amount.": "Mientras regresas a los vendedores, mata enemigos hasta alcanzar la experiencia indicada.",
    "While you can choose your permanent professions later, picking up Skinning early in your leveling journey will help you as you start out.": "Aunque podrás elegir tus profesiones definitivas más adelante, aprender Desuello temprano te ayudará mucho en el inicio.",
    "While you can choose your permanent professions later, picking up Mining early in your leveling journey will help you as you start out.": "Aunque podrás elegir tus profesiones definitivas más adelante, aprender Minería temprano te ayudará mucho en el inicio.",
    "While you can choose your permanent professions later, picking up Mining early in your leveling journey will help you as we will use items to help get your casting Wand early. This greatly helps your leveling experience.": "Aprender Minería temprano te ayudará a fabricar tu varita rápidamente, lo que mejorará mucho tu velocidad de leveo.",
    "Acepta this quest from your bags. The book drops from the Kobolds around here": "Acepta esta misión desde tus mochilas. El libro lo sueltan los kóbold de por aquí.",
    "Acepta this quest from your bags.": "Acepta esta misión desde tus mochilas.",
    
    // Misiones y avisos
    "Kill the required amount of Troggs.": "Derrota la cantidad requerida de troggs.",
    "Loot the 3 objects at the troll camps.": "Despoja los 3 objetos en los campamentos trol.",
    "First loot ": "Primero despoja ",
    " (next to the ": " (junto a ",
    "Loot ": "Despoja ",
    " and kill/loot this troll.": " y mata y despoja a este trol.",
    "Frostmane Novices": "Novicios Melenafroste",
    " scattered around in the back of the cave.": " repartidos al fondo de la cueva.",
    "The Troggs are scattered all around ": "Los troggs están repartidos por todo ",
    "Rockjaw Troggs": "Troggs Quijadadura",
    " are mostly east.": " están principalmente al este.",
    "Burly Rockjaw Troggs": "Troggs Quijadadura fornidos",
    " are scattered everywhere.": " están repartidos por todas partes.",
    "  You lost your ": "  ¡Has perdido tu ",
    ", as the time limit was up for it!  You should go get a new one at the dwarf camp, and hurry back here before the 5 min time limit is up.": ", ¡porque se agotó el tiempo! Ve a buscar otra al campamento enano y regresa rápido antes de que pasen los 5 min.",
    " has a 5 min time limit.  As long as you do not go AFK or something you should have plenty of time to get this in.": " tiene un límite de tiempo de 5 min. Mientras no te quedes ausente, tendrás tiempo de sobra para entregarla.",
    "Collect 60 Leather Scraps": "Consigue 60 trozos de cuero",
    "Aim to collect 20 Copper Ore from the Poor Copper Veins around Coldridge Valley. They are around the hills on the edges of the valley.": "Intenta conseguir 20 menas de cobre de los filones pobres de cobre por Crestanevada. Están por las colinas en los bordes del valle.",
    "Under the red canopy, at Adlin Pridedrift: buy a Skinning Knife and an Apprentice's Skinning Satchel.": "Bajo el dosel rojo, con Adlin Derivorgullo: compra un Cuchillo para desollar y una faltriquera de desollador aprendiz.",
    "Under the red canopy, at Adlin Pridedrift: buy a Mining Pick and an Apprentice's Mining Pack.": "Bajo el dosel rojo, con Adlin Derivorgullo: compra un Pico de minero y una faltriquera de minero aprendiz.",
    "Mine the Poor Copper Veins in and around the Caves, you are aiming to get 20 Copper Ore. Keep this for an upcoming plan to craft your first wand.": "Pica los filones pobres de cobre dentro y alrededor de las cuevas para conseguir 20 menas de cobre. Guárdalas para fabricar tu primera varita.",
    "Before you leave Coldridge Valley, mine the Poor Copper Veins until you have 20 Copper Ore. Veins: the hills north-west of Anvilmar on the way to Grund and Gozwin (25-28, 62-68), south around the Frostmane cave (19-24, 69-80), and the south-east hills (26-31, 78-83).": "Antes de salir de Crestanevada, pica filones de cobre hasta tener 20 menas. Filones: colinas al noroeste de Yunquemar hacia Grund y Gozwin (25-28, 62-68), al sur junto a la cueva Melenafroste (19-24, 69-80), y colinas del sudeste (26-31, 78-83).",
    "Turn on Find Herbs from your minimap tracking, then pick every Peacebloom and Silverleaf you pass for the rest of the zone.": "Activa Buscar hierbas en el minimapa y recoge cada Flor de paz y Hojaplata que encuentres.",
    "Choose Mining for Dummies as your reward from Coldridge Valley Mail Delivery. Click the item in your bag to learn Mining. Open your Profession tab (K) and put 'Find Minerals' on your bars. Activate this skill to display nearby mining nodes on your minimap. Keep the stone and ore, you will need them later.": "Elige Minería para novatos como recompensa. Haz clic en el objeto para aprender Minería. Abre tu panel de profesiones (K) y pon Buscar minerales en tu barra para ver filones en el minimapa. Guarda la piedra y menas.",
    "Choose Pelt Collecting for Beginners as your reward from Coldridge Valley Mail Delivery. Click the item in your bag to learn Skinning. From now on, skin beasts to collect their leather scraps. Keep them; you will need them later.": "Elige Recolección de pieles para principiantes como recompensa del correo de Crestanevada. Haz clic en el objeto en tu mochila para aprender Desuello. A partir de ahora, desuella bestias para recoger trozos de cuero. Guárdalos; los necesitarás más tarde.",
    "GROUP (or soloable):": "GRUPO (o en solitario):",
    "TOUGH QUEST (can be soloable):": "MISIÓN DIFÍCIL (posible en solitario):",
    "Imp Minion": "Esbirro diablillo",
    "  It's wise to do your class's quest ASAP so you can get your ": "  Es muy recomendable hacer la misión de clase cuanto antes para conseguir tu ",
    ".  This quest is done south in the cave (entrance).  You would need to kill/loot the ": ". Esta misión se hace al sur en la cueva (entrada). Necesitarás derrotar y despojar a los ",
    " which are sporadically spaced out around in the back of the cave.": " que están repartidos al fondo de la cueva.",
    "  Try to group up with others in the cave if you can.": "  Intenta formar grupo con otros jugadores en la cueva si es posible.",
    "  This is possible to solo, but it's rough at lvl 2/3.  If you cannot do this now, you will be reminded later to try again.": "  Es posible en solitario, pero difícil a nivel 2/3. Si no puedes ahora, más adelante se te recordará volver a intentarlo.",
    "Head to the bottom of the hill, there is a path up the hill to Grund and Gozwin's camp .": "Ve al pie de la colina, hay un sendero que sube hacia el campamento de Grund y Gozwin.",
    "Look left of the camp, and head to the nearby stone. Drink the Sapta.": "Mira a la izquierda del campamento y acércate a la piedra cercana. Bebe la Sapta.",
    "To Grund Drokda. The bag you receive as a reward should automatically equip, giving you more bag space.": "Con Grund Drokda. La bolsa que recibes se equipará automáticamente para darte más espacio.",
    " east on the main path to the entrance of ": " al este por el camino principal hacia la entrada de ",
    " is complete!": " ¡ha sido completada!",
    "Go to 6-12 Dun Morogh": "Ve a 6-12 Dun Morogh",
    "Go to 6-13 Elwynn Forest": "Ve a 6-13 Bosque de Elwynn",
    "Go to 6-12 Durotar": "Ve a 6-12 Durotar",
    "Go to 6-12 Mulgore": "Ve a 6-12 Mulgore",
    "Go to 6-12 Tirisfal Glades": "Ve a 6-12 Claros de Tirisfal",
    "Go to 6-12 Teldrassil": "Ve a 6-12 Teldrassil",
    "Go to 1-6 Dun Morogh": "Ve a 1-6 Dun Morogh",
    "Go to 1-6 Elwynn Forest": "Ve a 1-6 Bosque de Elwynn",
    "Go to 1-6 Durotar": "Ve a 1-6 Durotar",
    "Go to 1-6 Mulgore": "Ve a 1-6 Mulgore",
    "Go to 1-6 Tirisfal Glades": "Ve a 1-6 Claros de Tirisfal",
    "Go to 1-6 Teldrassil": "Ve a 1-6 Teldrassil"
};

const PATTERNS = [
    // Nivel y facultades
    [ /,\s*get your level (\d+) abilities from the\s*/gi, ', aprende tus facultades de nivel $1 con el ' ],
    [ /^Get your level (\d+) abilities from the\s*/gi, 'Aprende tus facultades de nivel $1 con el ' ],
    [ /,\s*get your level (\d+) spells\/abilities from the\s*/gi, ', aprende tus hechizos y facultades de nivel $1 con el ' ],
    [ /^Get your level (\d+) spells\/abilities from the\s*/gi, 'Aprende tus hechizos y facultades de nivel $1 con el ' ],
    [ /^Get level (\d+) spells\/abilities from the\s*/gi, 'Aprende hechizos y facultades de nivel $1 con el ' ],
    [ /^Since you are level (\d+) now, get new spells\/abilities\.?/gi, 'Como ya eres nivel $1, aprende nuevos hechizos/facultades.' ],
    [ /,\s*learn new abilities from the\s*/gi, ', aprende nuevas facultades con el ' ],
    [ /^Learn new weapon possibilities from the\s*/gi, 'Aprende nuevas habilidades de armas con el ' ],
    [ /^Get new spells\/abilities from the\s*/gi, 'Aprende nuevos hechizos y facultades con el ' ],
    [ /,\s*learn new spells\/abilities from the\s*/gi, ', aprende nuevos hechizos y facultades con el ' ],
    [ /^Learn new spells\/abilities from the\s*/gi, 'Aprende nuevos hechizos y facultades con el ' ],

    // Ubicaciones y navegación
    [ /^Hearth to\s+(.+)$/i, 'Usa la piedra de hogar hacia $1' ],
    [ /^Go back to\s+(.+)$/i, 'Regresa a $1' ],
    [ /^Head to\s+(.+)$/i, 'Dirígete a $1' ],
    [ /^Run to\s+(.+)$/i, 'Corre a $1' ],
    [ /^Swim to\s+(.+)$/i, 'Nada hacia $1' ],
    [ /^Fly to\s+(.+)$/i, 'Vuela hacia $1' ],
    [ /^Talk to\s+(.+)$/i, 'Habla con $1' ],
    [ /^Speak with\s+(.+)$/i, 'Habla con $1' ],
    [ /^Speak to\s+(.+)$/i, 'Habla con $1' ],
    [ /^Turn in at\s+(.+)$/i, 'Entrega en $1' ],
    [ /^Turn in\s+(.+)$/i, 'Entrega $1' ],
    [ /^Accept\s+(.+)$/i, 'Acepta $1' ],
    [ /^Kill\/loot\s+(.+)$/i, 'Mata y despoja $1' ],
    [ /^Kill and loot\s+(.+)$/i, 'Mata y despoja $1' ],
    [ /^Kill\s+(.+)$/i, 'Mata a $1' ],
    [ /^Loot\s+(.+)$/i, 'Despoja $1' ],
    [ /^Buy\s+(.+)\?$/i, '¿Comprar $1?' ],
    [ /^Buy\s+(.+)$/i, 'Compra $1' ],
    [ /^Follow waypoint to\s+(.+)$/i, 'Sigue el punto de ruta hacia $1' ],
    [ /^Follow waypoint\s+(.+)$/i, 'Sigue el punto de ruta $1' ],
    [ /^At the\s+(.+)$/i, 'En el $1' ],
    [ /^Inside the\s+(.+)$/i, 'Dentro de la $1' ],
    [ /^Outside the\s+(.+)$/i, 'Fuera de la $1' ],
    [ /^Behind the\s+(.+)$/i, 'Detrás de la $1' ],
    [ /^In front of\s+(.+)$/i, 'Frente a $1' ],
    [ /^Around\s+(.+)$/i, 'Alrededor de $1' ],
    [ /^Level\s+(\w+)\s+to\s+(\d+)$/i, 'Sube $1 a $2' ],
    [ /^Reach level\s+(\d+)\s+before continuing$/i, 'Alcanza el nivel $1 antes de continuar' ],
    [ /^Reach level\s+(\d+)$/i, 'Alcanza el nivel $1' ],
    [ /^Go to\s+(.+)$/i, 'Ve a $1' ],
    [ /^Enter\s+(.+)$/i, 'Entra a $1' ],
    [ /^Exit\s+(.+)$/i, 'Sal de $1' ]
];

function translateString(s) {
    if (DICT[s]) return DICT[s];
    for (const [pat, rep] of PATTERNS) {
        if (pat.test(s)) {
            return s.replace(pat, rep);
        }
    }
    return s;
}

let modifiedFiles = 0;
let replacedCount = 0;

for (let i = 1; i <= 121; i++) {
    const pad = String(i).padStart(4, '0');
    const fPath = `src/Journey/BundledContent/Guides/${pad}.html`;
    if (!fs.existsSync(fPath)) continue;

    const raw = fs.readFileSync(fPath, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
    let decoded = Buffer.from(raw, 'base64').toString('utf8');

    let count = 0;
    // 1. Direct dict replacement
    for (const [en, es] of Object.entries(DICT)) {
        const target = `"${en}"`;
        const replacement = `"${es}"`;
        if (decoded.includes(target)) {
            decoded = decoded.split(target).join(replacement);
            count++;
        }
    }

    // 2. Pattern replacements on lines that are NOT control directives
    const lines = decoded.split('\n');
    let lineChanged = false;
    for (let j = 0; j < lines.length; j++) {
        const line = lines[j];
        const trimmed = line.trim();
        if (trimmed.startsWith('condition =') || 
            trimmed.startsWith('id =') || 
            trimmed.startsWith('flags =') || 
            trimmed.startsWith('productID =') || 
            trimmed.startsWith('contentHash =') ||
            trimmed.startsWith('group =') ||
            trimmed.startsWith('--') ||
            trimmed.startsWith('guideID =') ||
            trimmed.startsWith('completed =')) {
            continue;
        }

        const matches = line.match(/"([^"\\]*(?:\\.[^"\\]*)*)"/g) || [];
        for (const m of matches) {
            const s = m.slice(1, -1);
            if (s.includes('|') || s.startsWith('BW|') || s.startsWith('CV|')) continue;
            if (line.includes(`condition = "${s}"`)) continue;
            if (line.includes(`id = "${s}"`)) continue;
            if (line.includes(`flags = "${s}"`)) continue;
            if (line.includes(`productID = "${s}"`)) continue;
            if (line.includes(`completed = "${s}"`)) continue;

            const translated = translateString(s);
            if (translated !== s) {
                lines[j] = lines[j].split(`"${s}"`).join(`"${translated}"`);
                count++;
                lineChanged = true;
            }
        }
    }

    if (lineChanged) {
        decoded = lines.join('\n');
    }

    if (count > 0) {
        modifiedFiles++;
        replacedCount += count;
        const newB64 = Buffer.from(decoded, 'utf8').toString('base64');
        const b64Lines = newB64.match(/.{1,76}/g).join('\r\n');
        const html = `<!-- Copyright (c) 2006-2026 TomCat's Gaming, LLC. All Rights Reserved.
     Unauthorized use, reproduction, or distribution is prohibited.
     See license.txt included with this distribution for full terms. -->
<html>
\t<head></head>
\t<body>
\t\t<p>
${b64Lines}
\t\t</p>
\t</body>
</html>\r\n`;
        fs.writeFileSync(fPath, html, 'utf8');
        console.log(`Guide ${pad}: translated ${count} phrases.`);
    }
}

console.log(`\nDeep translation completed: ${modifiedFiles} files modified, ${replacedCount} phrases replaced.`);
