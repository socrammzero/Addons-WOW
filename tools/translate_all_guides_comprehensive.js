const fs = require('fs');

// Extensive phrase mappings and pattern transformers for WoW Classic & Forever guides
const EXACT_DICT = {
    // Starting & Leveling Actions
    "next": "siguiente",
    "Done crafting": "Fabricación lista",
    "Click When Done": "Haz clic al terminar",
    "Click for Next Step": "Haz clic para el siguiente paso",
    " (for now).": " (por ahora).",
    " (for now)": " (por ahora)",
    "Go up ramp in building": "Sube la rampa dentro del edificio",
    "Go down spiral ramp": "Baja la rampa en espiral",
    "At the bottom of the watchtower:": "Al pie de la torre de vigía:",
    "At the top of the watchtower:": "En la cima de la torre de vigía:",
    "You do not have enough silver to purchase ": "No tienes suficiente plata para comprar ",
    ", kill/loot ": ", mata y despoja ",
    "Kill: %s": "Derrota: %s",
    "Loot: %s": "Despoja: %s",
    "Kill/loot: %s": "Mata y despoja: %s",
    "Kill and loot ": "Mata y despoja ",
    "Kill/loot ": "Mata y despoja ",
    "Loot ": "Despoja ",
    "Kill ": "Mata ",
    "Back in ": "De vuelta en ",
    "In ": "En ",
    "At ": "En ",
    "From the ": "De ",
    " from the ": " con el ",
    ", at the ": ", con el ",
    " and then ": " y luego ",
    "The ": "El ",
    ", go to the ": ", ve a ",
    ", learn ": ", aprende ",
    "Use your ": "Usa tu ",
    "Go back to ": "Regresa a ",
    "Head to ": "Dirígete a ",
    "Run to ": "Corre a ",
    "First Aid Trainer": "Instructor de primeros auxilios",
    "First Aid": "Primeros auxilios",
    "Weapon Master": "Maestro de armas",
    "Innkeeper": "Tabernero",
    "Stable Master": "Maestro de establos",
    "Spirit Healer": "Ángel de la Resurrección",
    "Hearth to ": "Usa la piedra de hogar hacia ",
    "Accept your class quest:": "Acepta la misión de tu clase:",
    "Turn in your class quest:": "Entrega la misión de tu clase:",
    "Complete your class quest:": "Completa la misión de tu clase:",
    "Get repaired / resupplied": "Reparar y reabastecerse",
    "Repair and resupply": "Reparar y reabastecerse",
    "Sell junk and Resupply": "Vender chatarra y reabastecerse",
    "Sell junk, Repair, and Resupply": "Vender chatarra, reparar y reabastecerse",
    "Cave entrance": "Entrada a la cueva",
    "Cave Entrance": "Entrada a la cueva",
    "Exit cave": "Sal de la cueva",
    "Exit the cave...": "Sal de la cueva...",
    "Enter cave": "Entra a la cueva",
    "Go through cave": "Atraviesa la cueva",
    "Go through tunnel": "Atraviesa el túnel",
    "Go across bridge": "Cruza el puente",
    "Bottom of the hill": "Al pie de la colina",
    "Go up the hill": "Sube la colina",
    "Enter back room": "Entra a la sala del fondo",
    "Inside the tent:": "Dentro de la tienda:",
    "Inside the building:": "Dentro del edificio:",
    "Outside the building:": "Fuera del edificio:",
    "Inside the cave:": "Dentro de la cueva:",
    "Outside the cave:": "Fuera de la cueva:",
    "On the road:": "En el camino:",
    "Next to the road:": "Junto al camino:",
    "Across the road:": "Al otro lado del camino:",
    "In front of you:": "Frente a ti:",
    "Next to you:": "Junto a ti:",
    "Right behind you:": "Justo detrás de ti:",
    "Across from you:": "Frente a ti al otro lado:",
    "Upstairs:": "Arriba:",
    "Downstairs:": "Abajo:",
    "On the platform:": "En la plataforma:",
    "Under the red canopy:": "Bajo el dosel rojo:",
    "Under the red canopy, purchase a stack or two of:": "Bajo el dosel rojo, compra una o dos pilas de:",
    "At the starting spot:": "En el punto de inicio:",
    "Back at the starting spot:": "De vuelta al punto de inicio:",
    "Head to the starting spot:": "Dirígete al punto de inicio:",
    "At the entrance of ": "En la entrada de ",
    "Now die on purpose and res at spirit.": "Ahora muere a propósito y revive en el ángel.",
    "Die on purpose and res at spirit.": "Muere a propósito y revive en el ángel.",
    "Hearth, or die on purpose and res at spirit.": "Usa piedra de hogar, o muere a propósito y revive en el ángel.",
    "Hearth to the starting spot.": "Usa la piedra de hogar hacia el punto de inicio.",
    "Loot the 3 objects at the troll camps.": "Despoja los 3 objetos en los campamentos trol.",
    "Collect 2 Frostmane Bear Pendants from the Trolls": "Consigue 2 colgantes de oso Melenafroste de los trols",
    "First abandon ": "Primero abandona ",
    ", so you can get it again.": ", para poder aceptarla de nuevo.",
    "First go get a new mug at Dwarf camp!": "¡Primero ve a por otra jarra al campamento enano!",
    "Pick every Peacebloom you pass. Keep them for Alchemy.": "Recoge cada Flor de paz que veas. Guárdalas para Alquimia.",
    "Pick every Silverleaf you pass. Keep them for Alchemy.": "Recoge cada Hojaplata que veas. Guárdalas para Alquimia.",
    "Keep the meat you loot from beasts. Don't sell it; you will cook it in Kharanos to get your Cooking to 20.": "Guarda la carne que despojes de bestias. No la vendas; la cocinarás en Kharanos para subir Cocina a 20.",
    "Level Herbalism to 20": "Sube Herboristería a 20",
    "Level Skinning to 20": "Sube Desuello a 20",
    "Level Mining to 20": "Sube Minería a 20",
    "Level First Aid to 20": "Sube Primeros auxilios a 20",
    "Level Cooking to 20": "Sube Cocina a 20",
    "Behind the big fire pit, at the ": "Detrás de la gran hoguera, junto a ",
    "Go up to enter ": "Sube para entrar a ",
    "All the way back in ": "Al fondo del todo en ",
    "And learn ": "Y aprende ",
    "Learn ": "Aprende ",
    " R1.": " R1.",
    " R2.": " R2.",
    " R3.": " R3.",
    "Turning this in will give you ": "Al entregar esto recibirás ",
    "  Turning this in will give you ": "  Al entregar esto recibirás ",
    "  Make sure you use ": "  Asegúrate de usar ",
    " at the big fire pit.": " junto a la gran hoguera.",
    " next to the big fire pit.": " al lado de la gran hoguera.",
    " in the room with the big fire pit.": " en la sala de la gran hoguera.",
    " next to you.": " junto a ti.",
    " up in the back of ": " arriba al fondo de ",
    ".  Make sure you get ": ". Asegúrate de conseguir ",
    " first, followed by ": " primero, seguido de ",
    "Exit ": "Sal de ",
    "Enter ": "Entra a ",
    "Buy %s?": "¿Comprar %s?",
    "%s mostly around here": "%s principalmente por aquí",
    "Kill %s": "Mata a %s",
    "Kill/loot %s": "Mata y despoja %s",
    "Loot %s": "Despoja %s",
    "Lets start off by obtaining your ": "Comencemos por conseguir tu ",
    "Go to the side yard of the Abbey:": "Ve al patio lateral de la Abadía:",
    "Go in Tent (follow directions on image)": "Entra en la tienda (sigue las indicaciones de la imagen)",
    "Thankfully as human Warlocks there is a very easy trick you can do to obtain your Imp quickly:": "Por suerte, como brujos humanos hay un truco muy fácil para conseguir tu Diablillo rápido:",
    "Go east across the river to the Defias camp (and while on your way there kill/loot a few wolves to obtain sellable items worth a total of at least 10 copper) and then loot the ": "Cruza el río hacia el este hasta el campamento Defias (y de camino mata y despoja lobos para conseguir chatarra por valor de al menos 10 cobres) y luego despoja el ",
    " on the ground in front of the tent.": " en el suelo frente a la tienda.",
    " At level 1 this is extremely difficult to do without using ": " A nivel 1 esto es extremadamente difícil sin usar ",
    ".  Please follow the instructions on that image.": ". Sigue las instrucciones de esa imagen.",
    "Head back to the graveyard next to ": "Regresa al cementerio junto a ",
    "Sell junk to the ": "Vende chatarra con el ",
    "Make sure you obtain 10 copper before continuing!": "¡Asegúrate de conseguir 10 cobres antes de continuar!",
    " next to you, purchase ": " junto a ti, compra ",
    " from her.": " de ella.",
    " Go to the Difas camp and loot the ": " Ve al campamento Defias y despoja el ",
    " Watch out for the higher level mobs!  You may need to kill a few level 4 ": " ¡Cuidado con los enemigos de nivel superior! Quizás debas derrotar algunos nivel 4 ",
    ".  It's definitely doable.  Then use the looted item.": ". Es completamente viable. Luego usa el objeto despojado.",
    " Now use the looted item.": " Ahora usa el objeto despojado.",
    "Make sure you use ": "Asegúrate de usar ",
    " to get your Imp minion out!": " para invocar a tu esbirro diablillo.",
    "First thing to do is grind on a few wolves around ": "Lo primero es matar algunos lobos alrededor de ",
    " to obtain 10 copper worth of junk to sell.  This is so you can learn ": " para conseguir 10 cobres en chatarra. Así podrás aprender ",
    "Then sell junk to the Vendors around ": "Luego vende la chatarra a los vendedores cerca de ",
    "Go in ": "Entra a ",
    "Just in the other room in the Abby, from the ": "Justo en la otra sala de la Abadía, con el ",
    "Around the area": "Alrededor de la zona",
    "Get resupplied": "Reabastecerse",
    "Follow Waypoint": "Sigue el punto de ruta",
    "Follow waypoint": "Sigue el punto de ruta",
    "Next Destination": "Siguiente destino",
    "Show a Hint": "Mostrar una pista",
    "Show Spoiler": "Mostrar solución",
    "Skip This?": "¿Omitir esto?",
    "Consider skipping this if you are not confident about it.": "Considera omitir esto si no te sientes seguro.",
    "Hardcore players should consider skipping this if you are not confident about it.": "Los jugadores Hardcore deberían omitir esto si no se sienten seguros.",
    "Hardcore players may want to skip this if you are not confident about it.": "Los jugadores Hardcore pueden omitir esto si no se sienten seguros.",
    "If it's too hard for you, skip it.": "Si te resulta muy difícil, omítelo.",
    "If you cannot do it, then skip it.": "Si no puedes hacerlo, omítelo.",
    "Take the boat to Stormwind Harbor from the end of the boardwalk (not the Menethil boat).": "Toma el barco al Puerto de Ventormenta desde el final del muelle (no el barco de Menethil).",
    "Next to the fireplace, from the ": "Junto a la chimenea, con el ",
    " downstairs from the ": " abajo con el ",
    "If you need 6 slot bags, you can purchase them from the ": "Si necesitas bolsas de 6 casillas, puedes comprarlas con el "
};

const PATTERN_RULES = [
    // Level abilities
    [ /,\s*get your level (\d+) abilities from the\s*/gi, ', aprende tus facultades de nivel $1 con el ' ],
    [ /^Get your level (\d+) abilities from the\s*/gi, 'Aprende tus facultades de nivel $1 con el ' ],
    [ /,\s*get your level (\d+) spells\/abilities from the\s*/gi, ', aprende tus hechizos y facultades de nivel $1 con el ' ],
    [ /^Get your level (\d+) spells\/abilities from the\s*/gi, 'Aprende tus hechizos y facultades de nivel $1 con el ' ],
    [ /^Get level (\d+) spells\/abilities from the\s*/gi, 'Aprende hechizos y facultades de nivel $1 con el ' ],
    [ /^Since you are level (\d+) now, get new spells\/abilities\.?/gi, 'Como ya eres nivel $1, aprende nuevos hechizos/facultades.' ],
    [ /,\s*learn new abilities from the\s*/gi, ', aprende nuevas facultades con el ' ],
    [ /^Learn new weapon possibilities from the\s*/gi, 'Aprende nuevas habilidades de armas con el ' ],
    [ /^Get new spells\/abilities from the\s*/gi, 'Aprende nuevos hechizos y facultades con el ' ],
    
    // Core actions
    [ /^Hearth to\s+(.+)$/i, 'Usa tu piedra de hogar hacia $1' ],
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
    [ /^Level\s+(\w+)\s+to\s+(\d+)$/i, 'Sube $1 a $2' ]
];

function translateText(str) {
    if (EXACT_DICT[str]) return EXACT_DICT[str];
    for (const [pat, rep] of PATTERN_RULES) {
        if (pat.test(str)) {
            return str.replace(pat, rep);
        }
    }
    return str;
}

// Process guide files
let totalModifiedFiles = 0;
let totalReplacedPhrases = 0;

for (let i = 1; i <= 121; i++) {
    const pad = String(i).padStart(4, '0');
    const fPath = `src/Journey/BundledContent/Guides/${pad}.html`;
    if (!fs.existsSync(fPath)) continue;

    const raw = fs.readFileSync(fPath, 'utf8').replace(/<[^>]+>/g, '').replace(/\s+/g, '');
    let decoded = Buffer.from(raw, 'base64').toString('utf8');

    let fileReplaced = 0;
    // Replace exact matches
    for (const [en, es] of Object.entries(EXACT_DICT)) {
        const target = `"${en}"`;
        const replacement = `"${es}"`;
        if (decoded.includes(target)) {
            decoded = decoded.split(target).join(replacement);
            fileReplaced++;
        }
    }

    // Pattern matches on lines that do NOT contain control logic
    const lines = decoded.split('\n');
    let lineModified = false;
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
            trimmed.startsWith('guideID =')) {
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

            const trans = translateText(s);
            if (trans !== s) {
                lines[j] = lines[j].split(`"${s}"`).join(`"${trans}"`);
                fileReplaced++;
                lineModified = true;
            }
        }
    }

    if (lineModified) {
        decoded = lines.join('\n');
    }

    if (fileReplaced > 0) {
        totalModifiedFiles++;
        totalReplacedPhrases += fileReplaced;
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
        console.log(`Guide ${pad}: translated ${fileReplaced} phrases.`);
    }
}

console.log(`\n======================================================`);
console.log(`Successfully updated ${totalModifiedFiles} guide files with ${totalReplacedPhrases} translations.`);
console.log(`======================================================\n`);
