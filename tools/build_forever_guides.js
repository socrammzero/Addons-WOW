const fs = require('fs');
const path = require('path');

// 1. Load data
const rawGuides = fs.readFileSync('src/Journey/BundledContent/Guides/guides.html', 'utf8');
const stripped = rawGuides.replace(/<[^>]+>/g, '').replace(/\s+/g, '');
const decodedGuides = Buffer.from(stripped, 'base64').toString('utf8');

const aData = JSON.parse(fs.readFileSync('tools/resources/alliance.json'));
const hData = JSON.parse(fs.readFileSync('tools/resources/horde.json'));

// Zone ID dictionary
const ZONE_IDS = {
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

// Map zone name string from guide to normalized key
function getZoneKey(str) {
    if (!str) return 'the-barrens';
    const s = str.toLowerCase().replace(/['\.]/g, '').trim();
    if (s.includes('darkshore')) return 'darkshore';
    if (s.includes('ashenvale')) return 'ashenvale';
    if (s.includes('stonetalon')) return 'stonetalon-mountains';
    if (s.includes('wetlands')) return 'wetlands';
    if (s.includes('redridge')) return 'redridge-mountains';
    if (s.includes('duskwood')) return 'duskwood';
    if (s.includes('hillsbrad')) return 'hillsbrad-foothills';
    if (s.includes('arathi')) return 'arathi-highlands';
    if (s.includes('stranglethorn')) return 'stranglethorn-vale';
    if (s.includes('shimmering')) return 'thousand-needles';
    if (s.includes('thousand needles')) return 'thousand-needles';
    if (s.includes('desolace')) return 'desolace';
    if (s.includes('alterac')) return 'alterac-mountains';
    if (s.includes('dustwallow')) return 'dustwallow-marsh';
    if (s.includes('badlands')) return 'badlands';
    if (s.includes('swamp of sorrows')) return 'swamp-of-sorrows';
    if (s.includes('tanaris')) return 'tanaris';
    if (s.includes('feralas')) return 'feralas';
    if (s.includes('azshara')) return 'azshara';
    if (s.includes('hinterlands')) return 'the-hinterlands';
    if (s.includes('searing gorge')) return 'searing-gorge';
    if (s.includes('undercity')) return 'undercity';
    if (s.includes('blasted lands')) return 'blasted-lands';
    if (s.includes('un\'goro') || s.includes('ungoro')) return 'un\'goro-crater';
    if (s.includes('burning steppes')) return 'burning-steppes';
    if (s.includes('felwood')) return 'felwood';
    if (s.includes('winterspring')) return 'winterspring';
    if (s.includes('western plaguelands')) return 'western-plaguelands';
    if (s.includes('eastern plaguelands')) return 'eastern-plaguelands';
    if (s.includes('silithus')) return 'silithus';
    if (s.includes('barrens')) return 'the-barrens';
    if (s.includes('loch modan')) return 'loch-modan';
    return s.replace(/\s+/g, '-');
}

// Translate step actions to Spanish instructions
function translateStep(item, defaultZoneId) {
    const action = item[1];
    const questId = item[6] ? parseInt(item[6]) : null;
    const amount = item[7];
    const questName = item[8] || '';
    const npcName = item[9] || '';
    const npcId = item[10] ? parseInt(item[10]) : null;
    const coords = item[12] || '';
    const zoneKey = item[13] ? getZoneKey(item[13]) : '';
    const mapId = (zoneKey && ZONE_IDS[zoneKey]) ? ZONE_IDS[zoneKey] : defaultZoneId;

    let locStr = null;
    if (coords && coords.includes(',')) {
        const parts = coords.split(',');
        const x = parseFloat(parts[0]).toFixed(2);
        const y = parseFloat(parts[1]).toFixed(2);
        locStr = `|${mapId}|${x}|${y}`;
    }

    let taskGroup = null;
    let locations = locStr ? [{ loc: locStr, npc: npcId, label: npcName }] : [];

    switch (action) {
        case 'Pick Up':
        case 'Pick Up*':
            taskGroup = {
                text: npcName ? `Habla con ${npcName} y acepta: ${questName}` : `Acepta la misión: ${questName}`,
                tasks: []
            };
            if (npcId) taskGroup.tasks.push({ npc: npcId });
            if (questId) taskGroup.tasks.push({ accept: questId });
            break;

        case 'Hand In':
        case 'Hand In*':
            taskGroup = {
                text: npcName ? `Habla con ${npcName} y entrega: ${questName}` : `Entrega la misión: ${questName}`,
                tasks: []
            };
            if (npcId) taskGroup.tasks.push({ npc: npcId });
            if (questId) taskGroup.tasks.push({ turnin: questId });
            break;

        case 'Kill':
            taskGroup = {
                text: `Mata a los objetivos de ${questName || npcName}`,
                tasks: []
            };
            if (questId) taskGroup.tasks.push({ complete: questId });
            else if (npcId) taskGroup.tasks.push({ npc: npcId });
            break;

        case 'Collect':
            taskGroup = {
                text: `Recoge los objetos requeridos para: ${questName}`,
                tasks: []
            };
            if (questId) taskGroup.tasks.push({ complete: questId });
            break;

        case 'Complete Quest':
            taskGroup = {
                text: `Completa los objetivos de: ${questName}`,
                tasks: []
            };
            if (questId) taskGroup.tasks.push({ complete: questId });
            break;

        case 'Set Hearth':
            taskGroup = {
                text: `Fija tu Piedra de hogar ${npcName ? 'con ' + npcName : 'en la taberna local'}.`,
                tasks: [{ sethearthstone = true }]
            };
            if (npcId) taskGroup.tasks.push({ npc: npcId });
            break;

        case 'Get Flight Path':
            taskGroup = {
                text: `Habla con ${npcName || 'el maestro de vuelo'} y aprende la nueva ruta de vuelo.`,
                tasks: []
            };
            if (npcId) taskGroup.tasks.push({ npc: npcId });
            taskGroup.tasks.push({ learntaxi: true });
            break;

        case 'Fly':
            taskGroup = {
                text: `Toma un vuelo hacia ${questName || 'el siguiente destino'}.`,
                tasks: [{ taketaxi = true }]
            };
            if (npcId) taskGroup.tasks.push({ npc: npcId });
            break;

        case 'Go':
            taskGroup = {
                text: `Desplázate hacia ${questName || npcName || 'la zona indicada'}.`,
                tasks: []
            };
            break;

        case 'Train':
            taskGroup = {
                text: `Visita a tu instructor de clase para aprender nuevos hechizos y habilidades.`,
                tasks: [{ trainer: true }]
            };
            break;

        case 'Vendor':
        case 'Buy':
            taskGroup = {
                text: `Visita al comerciante para reparar equipo, vaciar bolsas y reabastecerte.`,
                tasks: [{ merchant: true }]
            };
            break;

        default:
            taskGroup = {
                text: `${questName || npcName || 'Avanza hacia el siguiente punto de ruta.'}`,
                tasks: []
            };
            if (questId) taskGroup.tasks.push({ complete: questId });
            break;
    }

    return { taskGroup, locations };
}

console.log('Loaded build script utilities.');
