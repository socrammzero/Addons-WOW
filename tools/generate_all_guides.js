const fs = require('fs');
const path = require('path');

// 1. Zone ID dictionary for Classic WoW & WoW Forever
const ZONE_MAP_IDS = {
    'durotar': 1411,
    'mulgore': 1412,
    'the-barrens': 1413,
    'barrens': 1413,
    'alterac-mountains': 1416,
    'arathi-highlands': 1417,
    'badlands': 1418,
    'blasted-lands': 1419,
    'tirisfal-glades': 1420,
    'silverpine-forest': 1421,
    'western-plaguelands': 1422,
    'eastern-plaguelands': 1423,
    'hillsbrad-foothills': 1424,
    'the-hinterlands': 1425,
    'hinterlands': 1425,
    'dun-morogh': 1426,
    'searing-gorge': 1427,
    'burning-steppes': 1428,
    'elwynn-forest': 1429,
    'duskwood': 1431,
    'loch-modan': 1432,
    'redridge-mountains': 1433,
    'stranglethorn-vale': 1434,
    'swamp-of-sorrows': 1435,
    'wetlands': 1437,
    'teldrassil': 1438,
    'darkshore': 1439,
    'ashenvale': 1440,
    'thousand-needles': 1441,
    'shimmering-flats': 1441,
    'stonetalon-mountains': 1442,
    'stonetalon': 1442,
    'desolace': 1443,
    'feralas': 1444,
    'dustwallow-marsh': 1445,
    'tanaris': 1446,
    'azshara': 1447,
    'felwood': 1448,
    'un\'goro-crater': 1449,
    'ungoro-crater': 1449,
    'moonglade': 1450,
    'silithus': 1451,
    'winterspring': 1452,
    'stormwind-city': 1453,
    'orgrimmar': 1454,
    'ironforge': 1455,
    'thunder-bluff': 1456,
    'darnassus': 1457,
    'undercity': 1458
};

function normZone(str) {
    if (!str) return 'thebarrens';
    return str.toLowerCase().replace(/[^a-z]/g, '');
}

function getZoneMapId(zoneKey, defaultId) {
    const k = zoneKey.toLowerCase().replace(/['\.]/g, '').trim().replace(/\s+/g, '-');
    if (ZONE_MAP_IDS[k]) return ZONE_MAP_IDS[k];
    const n = normZone(k);
    for (const [zk, id] of Object.entries(ZONE_MAP_IDS)) {
        if (normZone(zk) === n) return id;
    }
    return defaultId || 1413;
}

// 2. Read datasets
const aData = JSON.parse(fs.readFileSync('tools/resources/alliance.json'));
const hData = JSON.parse(fs.readFileSync('tools/resources/horde.json'));
const list = JSON.parse(fs.readFileSync('tools/guide_entries_summary.json'));

const missingGuides = list.filter(e => parseInt(e.slot) >= 22);
const missingA = missingGuides.filter(e => e.faction === 'Alliance');
const missingH = missingGuides.filter(e => e.faction === 'Horde');

console.log(`Missing Alliance: ${missingA.length}, Missing Horde: ${missingH.length}`);

const TRAVEL_MAP = {
    'deeprun tram': 'el Tranvía Subterráneo',
    'ironforge station': 'la estación de Forjaz',
    'ironforge': 'Forjaz',
    'stormwind': 'Ventormenta',
    'stormwind city': 'Ciudad de Ventormenta',
    'darnassus': 'Darnassus',
    'menethil harbor': 'el Puerto de Menethil',
    'auberdine': 'Auberdine',
    'theramore': 'Theramore',
    'ratchet': 'Trinquete',
    'booty bay': 'Bahía del Botín',
    'orgrimmar': 'Orgrimmar',
    'thunder bluff': 'Cima del Trueno',
    'undercity': 'Entrañas',
    "grom'gol": "Grom'gol",
    'stonard': 'Rocal',
    'kargath': 'Kargath',
    'brackenwall': 'Murohelecho',
    'shadowprey': 'Presa de las Sombras',
    'camp mojache': 'Campamento Mojache',
    'sun rock retreat': 'Refugio Roca del Sol',
    'crossroads': 'El Cruce',
    'gadgetzan': 'Gadgetzan',
    'everlook': 'Vista Eterna',
    'cenarion hold': 'Fuerte Cenarion',
    'southshore': 'Costasur',
    'tarren mill': 'Molino Tarren',
    'refuge pointe': 'Refugio de la Algaba',
    'hammerfall': 'Sentencia',
    'aerie peak': 'Pico Nidal',
    'nethergarde keep': 'Castillo de Nethergarde',
    "morgan's vigil": "la Vigilia de Morgan",
    'flame crest': 'Cresta de Llamas',
    "light's hope chapel": "la Capilla de la Esperanza de la Luz",
    'chillwind camp': 'Campamento del Orvallo',
    'talonbranch glade': 'Claro Ramaespolón',
    'bloodvenom post': 'Puesto Sangraveneno',
    "rut'theran village": "la Aldea Rut'theran",
    'feathermoon': 'Bastión Plumaluna',
    'thalanaar': 'Thalanaar',
    "nijel's point": "Cima de Nijel",
    'astranaar': 'Astranaar',
    'splintertree post': 'Puesto del Hacha Quemada',
    "zoram'gar outpost": "Avanzada Zoram'gar",
    'freewind post': 'Poblado Viento Libre',
    'lakeshire': 'Villa del Lago',
    'darkshire': 'Villa Oscura',
    'sentinel hill': 'Colina del Centinela',
    'thelsamar': 'Thelsamar'
};

function translateTravel(text) {
    if (!text) return text;
    let t = text.trim();
    const m = t.match(/^to\s+(.+)$/i);
    if (m) {
        const dest = m[1].toLowerCase().trim().replace(/[><]/g, '');
        if (TRAVEL_MAP[dest]) {
            return `Hacia ${TRAVEL_MAP[dest]}`;
        }
        return `Hacia ${m[1]}`;
    }
    const clean = t.toLowerCase().replace(/[><]/g, '').trim();
    if (TRAVEL_MAP[clean]) {
        return `Hacia ${TRAVEL_MAP[clean]}`;
    }
    return t;
}

// Flatten raw steps with metadata
function flattenDataset(data) {
    const steps = [];
    for (const s of Object.keys(data)) {
        for (const st of Object.keys(data[s])) {
            const items = data[s][st];
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
    return steps;
}

const aSteps = flattenDataset(aData).filter(s => s.section >= 7);
const hSteps = flattenDataset(hData).filter(s => s.section >= 6);

// Helper to escape Lua strings
function escapeLua(str) {
    if (!str) return '';
    return str.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n/g, ' ');
}

// Translate step items to Lua
function convertStepToLua(stepObj, stepIdx, defaultMapId, guideInfo) {
    const stepId = `${String(Math.floor(stepIdx / 10) + 1).padStart(2, '0')}-${String((stepIdx % 10) + 1).padStart(2, '0')}`;
    const items = stepObj.items;

    const locations = [];
    const taskGroups = [];

    for (const item of items) {
        const action = item[1];
        const questId = item[6] ? parseInt(item[6]) : null;
        const questName = item[8] || '';
        const npcName = item[9] || '';
        const npcId = item[10] ? parseInt(item[10]) : null;
        const coords = item[12] || '';
        const zoneRaw = item[13] || '';
        const mapId = zoneRaw ? getZoneMapId(zoneRaw, defaultMapId) : defaultMapId;

        if (coords && coords.includes(',')) {
            const parts = coords.split(',');
            const x = parseFloat(parts[0]).toFixed(2);
            const y = parseFloat(parts[1]).toFixed(2);
            if (!isNaN(x) && !isNaN(y)) {
                let locLabel = npcName || questName;
                if (locLabel) {
                    locLabel = translateTravel(locLabel);
                }
                locations.push(`{ "|${mapId}|${x}|${y}", npc = ${npcId || 'nil'}, label = "${escapeLua(locLabel)}" }`);
            }
        }

        const tasksLua = [];
        let desc = '';

        if (action === 'Pick Up' || action === 'Pick Up*') {
            desc = npcName ? `Habla con ${npcName} y acepta: ${questName}` : `Acepta la misión: ${questName}`;
            if (npcId) tasksLua.push(`{ npc = ${npcId} }`);
            if (questId) tasksLua.push(`{ accept = ${questId} }`);
        } else if (action === 'Hand In' || action === 'Hand In*') {
            desc = npcName ? `Habla con ${npcName} y entrega: ${questName}` : `Entrega la misión: ${questName}`;
            if (npcId) tasksLua.push(`{ npc = ${npcId} }`);
            if (questId) tasksLua.push(`{ turnin = ${questId} }`);
        } else if (action === 'Kill') {
            desc = `Derrota a los objetivos requeridos para la misión: ${questName || npcName}`;
            if (questId) tasksLua.push(`{ complete = ${questId} }`);
            else if (npcId) tasksLua.push(`{ npc = ${npcId} }`);
        } else if (action === 'Collect') {
            desc = `Consigue los objetos necesarios para: ${questName}`;
            if (questId) tasksLua.push(`{ complete = ${questId} }`);
        } else if (action === 'Complete Quest') {
            desc = `Cumple los objetivos indicados de: ${questName}`;
            if (questId) tasksLua.push(`{ complete = ${questId} }`);
        } else if (action === 'Set Hearth') {
            desc = `Fija tu Piedra de hogar ${npcName ? 'con ' + npcName : 'en la posada local'}.`;
            if (npcId) tasksLua.push(`{ npc = ${npcId} }`);
            tasksLua.push(`{ sethearthstone = true }`);
        } else if (action === 'Get Flight Path') {
            desc = `Descubre la nueva ruta de vuelo hablando con ${npcName || 'el maestro de vuelo'}.`;
            if (npcId) tasksLua.push(`{ npc = ${npcId} }`);
            tasksLua.push(`{ learntaxi = true }`);
        } else if (action === 'Fly') {
            let dest = questName || 'tu próximo destino';
            if (dest.toLowerCase().startsWith('to ')) {
                dest = dest.slice(3).trim();
            }
            const cleanDest = dest.toLowerCase().trim().replace(/[><]/g, '');
            if (TRAVEL_MAP[cleanDest]) {
                dest = TRAVEL_MAP[cleanDest];
            }
            desc = `Utiliza el maestro de vuelo para volar hacia ${dest}.`;
            if (npcId) tasksLua.push(`{ npc = ${npcId} }`);
            tasksLua.push(`{ taketaxi = true }`);
        } else if (action === 'Train') {
            desc = `Visita a tu instructor de clase para aprender nuevos rangos de hechizos y habilidades.`;
            tasksLua.push(`{ merchant = SUPPLIES, optional = true }`);
        } else if (action === 'Vendor' || action === 'Buy') {
            desc = `Visita al comerciante para reparar armadura, vaciar inventario y reponer provisiones.`;
            tasksLua.push(`{ merchant = SUPPLIES, optional = true }`);
        } else {
            let cleanDesc = questName || npcName;
            if (cleanDesc) {
                cleanDesc = translateTravel(cleanDesc);
            } else {
                cleanDesc = 'Prosigue por la ruta de viaje recomendada.';
            }
            desc = cleanDesc;
            if (questId) tasksLua.push(`{ complete = ${questId} }`);
        }

        taskGroups.push(`\t\t{\n\t\t\t"${escapeLua(desc)}",\n` + (tasksLua.length ? `\t\t\t` + tasksLua.join(',\n\t\t\t') + `,\n` : '') + `\t\t}`);
    }

    let lua = `\t{\n\t\tid = "${stepId}",\n`;
    if (locations.length > 0) {
        lua += `\t\tlocations = {\n\t\t\t` + locations.slice(0, 4).join(',\n\t\t\t') + `,\n\t\t},\n`;
    }
    lua += taskGroups.join(',\n') + `,\n\t},\n`;
    return lua;
}

// Generate milestone step for Forever features
function generateMilestoneStep(guideInfo, defaultMapId) {
    const lvls = guideInfo.levels.split('-');
    const minLvl = parseInt(lvls[0]);
    const maxLvl = parseInt(lvls[1]);

    if (minLvl <= 30 && maxLvl >= 30) {
        return `\t{\n\t\tid = "M-30",\n\t\tcondition = "WARRIOR and LEVEL >= 30 and QUEST[1719] == NONE",\n\t\t{\n\t\t\t"|cFFFFFF00[Hito Nivel 30]|r Guerreros: Recordad viajar a la Isla del Combate (Trinquete/Los Baldíos) para completar la misión de clase 'La Isla del Combate' (1719) y aprender Actitud rabiosa e Interceptar.",\n\t\t\t{ accept = 1719, optional = true },\n\t\t},\n\t},\n`;
    }
    if (minLvl <= 40 && maxLvl >= 40) {
        return `\t{\n\t\tid = "M-40",\n\t\tcondition = "LEVEL >= 40",\n\t\t{\n\t\t\t"|cFFFFFF00[Hito Nivel 40 - ¡Montura!]|r ¡Has alcanzado el nivel 40! Acude de inmediato al instructor de monturas de tu raza o capital para aprender equitación y adquirir tu primera montura (+60% de velocidad). (Paladines: misión 'Caballo de guerra'; Brujos: misión 'Corcel vil').",\n\t\t\t{ button = "¡Entendido!", optional = true },\n\t\t},\n\t},\n`;
    }
    if (minLvl <= 50 && maxLvl >= 50) {
        return `\t{\n\t\tid = "M-50",\n\t\tcondition = "LEVEL >= 50",\n\t\t{\n\t\t\t"|cFFFFFF00[Hito Nivel 50]|r Visita a tu instructor de clase en la capital para iniciar la cadena de misiones de clase de nivel 50 hacia el Templo Sumergido.",\n\t\t\t{ button = "Anotado", optional = true },\n\t\t},\n\t},\n`;
    }
    if (minLvl >= 58) {
        return `\t{\n\t\tid = "M-60",\n\t\tcondition = "LEVEL >= 58",\n\t\t{\n\t\t\t"|cFFFFFF00[Hito Nivel Máximo]|r Tramo final hacia el nivel 60 en WoW Forever. Prepara las sintonizaciones de bandas (Núcleo de Magma, Guarida de Onyxia) y la misión de montura épica al 60.",\n\t\t\t{ button = "¡A por el 60!", optional = true },\n\t\t},\n\t},\n`;
    }
    return '';
}

// Generate full guide content Lua table
function buildGuideLua(guideInfo, stepsList) {
    const defaultMapId = parseInt(guideInfo.zone) || 1413;
    let lua = `{\n`;

    const milestone = generateMilestoneStep(guideInfo, defaultMapId);
    if (milestone) lua += milestone;

    if (stepsList.length === 0) {
        // Fallback hub step if no dataset steps matched
        lua += `\t{\n\t\tid = "01-01",\n\t\tlocations = {\n\t\t\t{ "|${defaultMapId}|50.0|50.0", label = "${escapeLua(guideInfo.description)}" },\n\t\t},\n\t\t{\n\t\t\t"Bienvenido a la guía de ${escapeLua(guideInfo.description)} en WoW Forever. Explora el puesto avanzado principal, habla con el maestro de vuelo y acepta las misiones disponibles del sagrario local.",\n\t\t\t{ button = "Continuar", optional = true },\n\t\t},\n\t},\n`;
    } else {
        stepsList.forEach((s, idx) => {
            lua += convertStepToLua(s, idx, defaultMapId, guideInfo);
        });
    }

    lua += `}\n`;
    return lua;
}

// Partition dataset steps across guides
function partitionSteps(guidesList, datasetSteps) {
    const guideParts = guidesList.map(g => ({
        guide: g,
        zoneNorm: normZone(g.description.split(' ').slice(1).join(' ')),
        minLvl: parseInt(g.levels.split('-')[0]),
        maxLvl: parseInt(g.levels.split('-')[1]),
        steps: []
    }));

    let currentIdx = 0;
    for (const step of datasetSteps) {
        let matched = false;
        // Search forward up to 4 guides
        for (let offset = 0; offset <= 4 && (currentIdx + offset) < guideParts.length; offset++) {
            const cand = guideParts[currentIdx + offset];
            if (cand.zoneNorm.includes(step.normZone) || step.normZone.includes(cand.zoneNorm) ||
                (step.normZone.includes('shimmering') && cand.zoneNorm.includes('thousandneedles')) ||
                (step.normZone.includes('thousandneedles') && cand.zoneNorm.includes('shimmering'))) {
                currentIdx += offset;
                guideParts[currentIdx].steps.push(step);
                matched = true;
                break;
            }
        }
        if (!matched) {
            guideParts[currentIdx].steps.push(step);
        }
    }

    // Ensure no empty guides: borrow from neighboring guide if needed
    for (let i = 0; i < guideParts.length; i++) {
        if (guideParts[i].steps.length === 0) {
            if (i > 0 && guideParts[i-1].steps.length > 6) {
                const half = Math.floor(guideParts[i-1].steps.length / 2);
                guideParts[i].steps = guideParts[i-1].steps.splice(half);
            } else if (i < guideParts.length - 1 && guideParts[i+1].steps.length > 6) {
                const half = Math.floor(guideParts[i+1].steps.length / 2);
                guideParts[i].steps = guideParts[i+1].steps.splice(0, half);
            }
        }
    }

    return guideParts;
}

const allianceParts = partitionSteps(missingA, aSteps);
const hordeParts = partitionSteps(missingH, hSteps);

console.log('Alliance partition summary:');
allianceParts.forEach((p, idx) => console.log(`[A ${idx+1}] ${p.guide.guideID} (${p.guide.description}) -> ${p.steps.length} steps`));

console.log('Horde partition summary:');
hordeParts.forEach((p, idx) => console.log(`[H ${idx+1}] ${p.guide.guideID} (${p.guide.description}) -> ${p.steps.length} steps`));

// 3. Write guide files (0022.html to 0121.html)
let currentSlot = 22;
const guideDir = 'src/Journey/BundledContent/Guides';

const slotMap = {};

function writeGuideFile(part) {
    const slotStr = String(currentSlot).padStart(4, '0');
    const fileName = `${slotStr}.html`;
    const fullPath = path.join(guideDir, fileName);

    slotMap[part.guide.guideID] = currentSlot;

    const luaContent = buildGuideLua(part.guide, part.steps);
    const b64 = Buffer.from(luaContent, 'utf8').toString('base64');

    // Split b64 into lines of 76 chars
    const b64Lines = b64.match(/.{1,76}/g).join('\r\n');

    const htmlContent = `<!-- Copyright (c) 2006-2026 TomCat's Gaming, LLC. All Rights Reserved.
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

    fs.writeFileSync(fullPath, htmlContent, 'utf8');
    currentSlot++;
}

// Write in interleaved or sequential order matching guides.html
// Let's iterate through missingGuides in the EXACT order they appear in guides.html
for (const guide of missingGuides) {
    let part = null;
    if (guide.faction === 'Alliance') {
        part = allianceParts.find(p => p.guide.guideID === guide.guideID);
    } else {
        part = hordeParts.find(p => p.guide.guideID === guide.guideID);
    }
    writeGuideFile(part);
}

console.log(`Generated guides up to slot ${currentSlot - 1}.`);

// 4. Update guides.html
const rawGuides = fs.readFileSync('src/Journey/BundledContent/Guides/guides.html', 'utf8');
const stripped = rawGuides.replace(/<[^>]+>/g, '').replace(/\s+/g, '');
let updatedGuidesDecoded = Buffer.from(stripped, 'base64').toString('utf8');

for (const [guideId, slotNum] of Object.entries(slotMap)) {
    const targetStr = `guideID = "${guideId}",`;
    if (updatedGuidesDecoded.includes(targetStr)) {
        updatedGuidesDecoded = updatedGuidesDecoded.replace(targetStr, `guideID = "${guideId}",\n\tslot = ${slotNum},`);
    } else {
        console.warn(`Warning: Could not match guideID ${guideId} in guides.html`);
    }
}

// Remove old signature at the end if present
const sigMatch = updatedGuidesDecoded.match(/^(.*),\s*"[^"]+"\s*$/s);
if (sigMatch) {
    updatedGuidesDecoded = sigMatch[1] + '\n';
}

const newGuidesB64 = Buffer.from(updatedGuidesDecoded, 'utf8').toString('base64');
const newGuidesLines = newGuidesB64.match(/.{1,76}/g).join('\r\n');

const guidesHtmlContent = `<!-- Copyright (c) 2006-2026 TomCat's Gaming, LLC. All Rights Reserved.
     Unauthorized use, reproduction, or distribution is prohibited.
     See license.txt included with this distribution for full terms. -->
<html>
\t<head></head>
\t<body>
\t\t<p>
${newGuidesLines}
\t\t</p>
\t</body>
</html>\r\n`;

fs.writeFileSync('src/Journey/BundledContent/Guides/guides.html', guidesHtmlContent, 'utf8');
console.log('Successfully updated src/Journey/BundledContent/Guides/guides.html with slots 22 to 121!');
