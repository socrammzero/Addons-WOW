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
    'theramore isle': 'la Isla Theramore',
    'ratchet': 'Trinquete',
    'ratchet inn': 'la Posada de Trinquete',
    'booty bay': 'Bahía del Botín',
    'orgrimmar': 'Orgrimmar',
    'orgrimmar gates': 'las puertas de Orgrimmar',
    'thunder bluff': 'Cima del Trueno',
    'undercity': 'Entrañas',
    "grom'gol": "Grom'gol",
    "grom'gol base camp": "el Campamento Base Grom'gol",
    'stonard': 'Rocal',
    'kargath': 'Kargath',
    'brackenwall': 'Murohelecho',
    'brackenwall village': 'el Poblado Murohelecho',
    'shadowprey': 'Presa de las Sombras',
    'shadowprey village': 'la Aldea Cazasombras',
    'camp mojache': 'el Campamento Mojache',
    'sun rock retreat': 'el Refugio Roca del Sol',
    'sunrock retreat': 'el Refugio Roca del Sol',
    'crossroads': 'El Cruce',
    'the crossroads': 'El Cruce',
    'gadgetzan': 'Gadgetzan',
    'everlook': 'Vista Eterna',
    'cenarion hold': 'el Fuerte Cenarion',
    'southshore': 'Costasur',
    'tarren mill': 'Molino Tarren',
    'refuge pointe': 'el Refugio de la Algaba',
    'hammerfall': 'Sentencia',
    'aerie peak': 'Pico Nidal',
    'nethergarde keep': 'el Castillo de Nethergarde',
    "morgan's vigil": "la Vigilia de Morgan",
    'flame crest': 'Cresta de Llamas',
    "light's hope chapel": "la Capilla de la Esperanza de la Luz",
    'chillwind camp': 'el Campamento del Orvallo',
    'chillwind point': 'la Punta del Orvallo',
    'talonbranch glade': 'el Claro Ramaespolón',
    'talonbranch glade, felwood': 'el Claro Ramaespolón, Frondavil',
    'bloodvenom post': 'el Puesto del Veneno',
    "rut'theran village": "la Aldea Rut'theran",
    'feathermoon': 'el Bastión Plumaluna',
    'feathermoon stronghold': 'el Bastión Plumaluna',
    'thalanaar': 'Thalanaar',
    "nijel's point": "la Punta de Nijel",
    'astranaar': 'Astranaar',
    'splintertree post': 'el Puesto del Hachazo',
    "zoram'gar outpost": "la Avanzada de Zoram'gar",
    'freewind post': 'el Poblado Viento Libre',
    'lakeshire': 'Villa del Lago',
    'darkshire': 'Villa Oscura',
    'sentinel hill': 'la Colina del Centinela',
    'thelsamar': 'Thelsamar',
    'goldshire': 'Villadorada',
    'razor hill': 'Cerrotajo',
    'bloodhoof village': 'el Poblado Pezuña de Sangre',
    'camp taurajo': 'el Campamento Taurajo',
    'the sepulcher': 'El Sepulcro',
    'revantusk village': 'el Poblado Sañadiente',
    'valormok': 'Valormok',
    'talrendis point': 'la Punta Talrendis',
    'talrendis point, azshara': 'la Punta Talrendis, Azshara',
    'thorium point': 'el Puesto del Torio',
    "marshal's refuge": 'el Refugio de Marshal',
    'moonglade': 'Claro de la Luna',
    'ghost walker post': 'el Puesto Caminante Fantasma',
    'twilight vale': 'el Valle del Crepúsculo',
    'rebel camp': 'el Campamento Rebelde',
    'yorgen farmstead': 'la Granja de los Yorgen',
    'the yorgen farmstead': 'la Granja de los Yorgen',
    'eastern pylon': 'el Pilón Oriental',
    'southridge beach': 'la Playa de la Cresta Sur',
    'nightsong woods': 'el Bosque Arrullanoche',
    'ashenvale': 'Vallefresno',
    'the barrens': 'Los Baldíos',
    'southern barrens': 'el sur de Los Baldíos',
    'stranglethorn vale': 'Vega de Tuercespina',
    'duskwood': 'Bosque del Ocaso',
    'redridge mountains': 'Montañas de Crestagrana',
    'elwynn forest': 'Bosque de Elwynn',
    'westfall': 'Páramos de Poniente',
    'wetlands': 'Los Humedales',
    'arathi highlands': 'Tierras Altas de Arathi',
    'hillsbrad foothills': 'Laderas de Trabalomas',
    'thousand needles': 'Las Mil Agujas',
    'the shimmering flats': 'El Desierto de Sal',
    'tanaris': 'Tanaris',
    'desolace': 'Desolace',
    'alterac mountains': 'Montañas de Alterac',
    'tirisfal glades': 'Claros de Tirisfal',
    'deadwind pass': 'Paso de la Muerte',
    'swamp of sorrows': 'Pantano de las Penas',
    'blasted lands': 'Las Tierras Devastadas',
    'loch modan': 'Loch Modan',
    'badlands': 'Tierras Inhóspitas',
    'searing gorge': 'La Garganta de Fuego',
    'the hinterlands': 'Tierras del Interior',
    'felwood': 'Frondavil',
    "un'goro crater": "Cráter de Un'Goro",
    'burning steppes': 'Las Estepas Ardientes',
    'eastern plaguelands': 'Tierras de la Peste del Este',
    'western plaguelands': 'Tierras de la Peste del Oeste',
    'silithus': 'Silithus',
    'durotar': 'Durotar',
    'mulgore': 'Mulgore',
    'stonetalon mountains': 'Sierra Espolón',
    'silverpine forest': 'Bosque de Argénteos',
    'dustwallow marsh': 'Marjal Revolcafango',
    'feralas': 'Feralas',
    'azshara': 'Azshara',
    'teldrassil': 'Teldrassil',
    'dun morogh': 'Dun Morogh',
    'winterspring': 'Cuna del Invierno',
    'blackrock mountain': 'Montaña Roca Negra',
    'blackrock depths': 'Profundidades de Roca Negra',
    'the deadmines': 'Las Minas de la Muerte',
    'deadmines': 'Las Minas de la Muerte',
    'stormwind stockade': 'Las Mazmorras de Ventormenta',
    'stockades': 'Las Mazmorras de Ventormenta',
    'gnomeregan': 'Gnomeregan',
    'gnomeregan entrance': 'la entrada de Gnomeregan',
    'scarlet monastery': 'el Monasterio Escarlata',
    'sm library': 'Monasterio Escarlata (Biblioteca)',
    'sm armory': 'Monasterio Escarlata (Armería)',
    'sm cathedral': 'Monasterio Escarlata (Catedral)',
    "zul'farrak": "Zul'Farrak",
    'sunken temple': 'el Templo Sumergido',
    'ragefire chasm': 'Sima Ígnea',
    'wailing caverns': 'Cuevas de los Lamentos',
    'blackfathom deeps': 'Cavernas de Brazanegra',
    'dire maul': 'La Masacre',
    'molten core': 'Núcleo de Magma',
    'northwatch hold': 'el Fuerte del Norte',
    'durnholde keep': 'el Castillo de Durnholde',
    'stromgarde keep': 'el Castillo de Stromgarde',
    'dun garok': 'Dun Garok',
    'dun algaz': 'Dun Algaz',
    'dalaran': 'Dalaran',
    'darrowshire': 'Villa Darrow',
    'andorhal': 'Andorhal',
    'timbermaw hold': 'el Bastión Fauces de Madera',
    'shadow hold': 'el Bastión de las Sombras',
    'terrorweb tunnel': 'el Túnel Terroarácnido',
    'the slag pit': 'La Hoya de la Escoria',
    'firewatch ridge': 'la Cresta Vigía de Fuego',
    'the charred vale': 'el Valle Carbonizado',
    'thunder axe fortress': 'la Fortaleza Hacha de Trueno',
    'steamwheedle port': 'el Puerto Bonvapor',
    "shindigger's camp": 'el Campamento de Shindigger',
    'falthrien academy': 'la Academia Falthrien',
    'excavation site': 'el Sitio de Excavación',
    "vul'gol ogre mound": "el Túmulo Ogro Vul'Gol",
    'dreadmurk shore': 'la Costa Tenebrosa',
    'the talondeep path': 'el Paso del Espolón',
    'drywhisker gorge': 'el Cajón Barbaseca',
    'witherbark village': 'el Poblado Secacorteza',
    "faldir's cove": 'la Cala de Faldir',
    "faldir's cove path": 'el sendero a la Cala de Faldir',
    'wild shore': 'la Costa Salvaje',
    'lost rigger cove': 'la Cala del Aparejo Perdido',
    'the writhing deep': 'Las Profundidades Tortuosas',
    'the high wilderness': 'Las Tierras Altas Salvajes',
    'the gaping chasm': 'La Sima Abierta',
    "jintha'alor": "Jintha'Alor",
    'ravenholdt manor': 'la Mansión Ravenholdt',
    'lake mennar': 'el Lago Mennar',
    'forlorn ridge': 'la Cresta Desolada',
    'the slithering scar': 'La Cicatriz Serpenteante',
    'fire plume ridge': 'la Cresta del Penacho en Llamas',
    'jadefire run': 'el Paso del Fuego de Jade',
    "lake kel'theril": "el Lago Kel'Theril",
    'irontree woods ruins': 'las ruinas del Bosque Árbol de Hierro',
    'frostwhisper gorge': 'el Cañón del Susurro Gélido',
    'mazthoril': 'Mazthoril',
    'dreadmist peak': 'la Cima Calígine',
    'far watch post': 'el Puesto de Vigilancia Lejana',
    'thorn hill': 'la Colina Espinosa',
    'boulderslide ravine': 'el Barranco del Alud',
    'thistlefur village': 'el Poblado Puercoespín',
    'darkcloud pinnacle': 'el Pináculo Nube Oscura',
    'highperch': 'Nido Alto',
    "camp e'thok": "el Campamento E'thok",
    'growless cave': 'la Cueva Gruñido',
    'circle of outer binding': 'el Círculo de Vínculo Exterior',
    'fungal rock': 'la Roca Fúngica',
    'bronzebeard encampment': 'el Campamento Barbabronce',
    'darrowmere lake': 'el Lago Darrowmere',
    'angerfang encampment': 'el Campamento Colmillo Iracundo'
};

// Load 26,000+ official enUS -> esES translations from local addon databases
const EN_TO_ES = {};
function registerTranslation(en, es) {
    if (!en || !es) return;
    en = en.trim();
    es = es.trim();
    if (!en || !es) return;
    EN_TO_ES[en] = es;
    EN_TO_ES[en.toLowerCase()] = es;
}

for (const [k, v] of Object.entries(TRAVEL_MAP)) {
    registerTranslation(k, v.replace(/^(el |la |los |las )/i, ''));
}

for (const f of ['src/GearQuestForever_Languages/esES.names.lua', 'src/GearQuestForever_Languages/esES.db2.lua']) {
    if (fs.existsSync(f)) {
        const txt = fs.readFileSync(f, 'utf8');
        for (const m of txt.matchAll(/\["((?:[^"\\]|\\.)+)"\]\s*=\s*"((?:[^"\\]|\\.)+)"/g)) {
            registerTranslation(m[1].replace(/\\"/g, '"'), m[2].replace(/\\"/g, '"'));
        }
    }
}

if (fs.existsSync('src/Journey/data/GameObjectNames/GameObjectNames-enUS.lua')) {
    const goEn = fs.readFileSync('src/Journey/data/GameObjectNames/GameObjectNames-enUS.lua', 'utf8');
    const goEs = fs.readFileSync('src/Journey/data/GameObjectNames/GameObjectNames-esES.lua', 'utf8');
    const goEnById = {};
    for (const m of goEn.matchAll(/\[(\d+)\]\s*=\s*"([^"]+)"/g)) goEnById[m[1]] = m[2];
    for (const m of goEs.matchAll(/\[(\d+)\]\s*=\s*"([^"]+)"/g)) {
        if (goEnById[m[1]]) registerTranslation(goEnById[m[1]], m[2]);
    }
}

for (const [fEn, fEs] of [
    ['src/Journey/data/TaxiNodes/TaxiNodes-enUS.lua', 'src/Journey/data/TaxiNodes/TaxiNodes-esES.lua'],
    ['src/Journey/data/WMOAreas/WMOAreas-enUS.lua', 'src/Journey/data/WMOAreas/WMOAreas-esES.lua']
]) {
    if (fs.existsSync(fEn) && fs.existsSync(fEs)) {
        const tEn = fs.readFileSync(fEn, 'utf8');
        const tEs = fs.readFileSync(fEs, 'utf8');
        const byId = {};
        const parseEntries = (src) => {
            const entries = [];
            for (const m of src.matchAll(/\[(\d+)\]\s*=\s*"([^"]+)"/g)) entries.push([m[1], m[2]]);
            for (const m of src.matchAll(/\["([^"]+)"\]\s*=\s*(\d+)/g)) entries.push([m[2], m[1]]);
            return entries;
        };
        for (const [id, nameEn] of parseEntries(tEn)) {
            if (!nameEn.trim()) continue;
            if (!byId[id]) byId[id] = [];
            byId[id].push(nameEn);
        }
        for (const [id, nameEs] of parseEntries(tEs)) {
            if (!nameEs.trim() || !byId[id]) continue;
            for (const nameEn of byId[id]) {
                registerTranslation(nameEn, nameEs);
                registerTranslation(nameEn.split(',')[0], nameEs.split(',')[0]);
            }
        }
    }
}

if (fs.existsSync('src/Journey/data/QuestInfo/QuestInfo-enUS.lua')) {
    const qEn = fs.readFileSync('src/Journey/data/QuestInfo/QuestInfo-enUS.lua', 'utf8');
    const qEs = fs.readFileSync('src/Journey/data/QuestInfo/QuestInfo-esES.lua', 'utf8');
    const qEnById = {};
    for (const m of qEn.matchAll(/\[(\d+)\]\s*=\s*"((?:[^"\\]|\\.)+)"/g)) qEnById[m[1]] = m[2];
    for (const m of qEs.matchAll(/\[(\d+)\]\s*=\s*"((?:[^"\\]|\\.)+)"/g)) {
        const enTxt = qEnById[m[1]];
        if (!enTxt) continue;
        const enReqs = [...enTxt.matchAll(/ - (?:\d+ x )?([^\\"\n]+)/g)].map(x => x[1].trim());
        const esReqs = [...m[2].matchAll(/ - (?:\d+ x )?([^\\"\n]+)/g)].map(x => x[1].trim());
        if (enReqs.length === esReqs.length) {
            for (let i = 0; i < enReqs.length; i++) registerTranslation(enReqs[i], esReqs[i]);
        }
    }
}

if (fs.existsSync('src/Leatrix_Maps/Leatrix_Maps_Locale.lua')) {
    const lm = fs.readFileSync('src/Leatrix_Maps/Leatrix_Maps_Locale.lua', 'utf8');
    const esBlock = lm.split('"esES"')[1].split(/\r?\nend\r?\n/)[0];
    for (const m of esBlock.matchAll(/L\["([^"]+)"\]\s*=\s*"([^"]+)"/g)) registerTranslation(m[1], m[2]);
}

const EXTRA_ENTITIES = {
    'ship': 'Barco',
    'zeppelin': 'Zepelín',
    'deeprun tram': 'Tranvía Subterráneo',
    'spirit healer': 'Ángel de la Resurrección',
    'cooking fire': 'Hoguera para cocinar',
    'mailbox': 'Buzón',
    'hearthstone': 'Piedra de hogar',
    'bows': 'Arcos',
    'guns': 'Armas de fuego',
    'staves': 'Bastones',
    'one-handed maces': 'Mazas de una mano',
    'two-handed maces': 'Mazas de dos manos',
    'two-handed axes': 'Hachas de dos manos',
    'one-handed axes': 'Hachas de una mano',
    'one-handed swords': 'Espadas de una mano',
    'two-handed swords': 'Espadas de dos manos',
    'daggers': 'Dagas',
    'polearms': 'Armas de asta',
    'crossbows': 'Ballestas',
    'thrown': 'Armas arrojadizas',
    'wands': 'Varitas',
    'weapon skills': 'Habilidades con armas',
    'first aid': 'Primeros auxilios',
    'cooking': 'Cocina',
    'cooking recipes': 'Recetas de cocina',
    'fishing': 'Pesca',
    'herbalism': 'Herboristería',
    'mining': 'Minería',
    'skinning': 'Desuello',
    'alchemy': 'Alquimia',
    'blacksmithing': 'Herrería',
    'enchanting': 'Encantamiento',
    'engineering': 'Ingeniería',
    'leatherworking': 'Peletería',
    'tailoring': 'Sastrería',
    'portals': 'Portales',
    'teleport': 'Teletransporte',
    'teleport: stormwind': 'Teletransporte a: Ventormenta',
    'teleport: ironforge': 'Teletransporte a: Forjaz',
    'teleport: darnassus': 'Teletransporte a: Darnassus',
    'teleport: orgrimmar': 'Teletransporte a: Orgrimmar',
    'teleport: undercity': 'Teletransporte a: Entrañas',
    'teleport: thunder bluff': 'Teletransporte a: Cima del Trueno',
    'portal: stormwind': 'Portal: Ventormenta',
    'portal: ironforge': 'Portal: Forjaz',
    'portal: darnassus': 'Portal: Darnassus',
    'portal: orgrimmar': 'Portal: Orgrimmar',
    'portal: undercity': 'Portal: Entrañas',
    'portal: thunder bluff': 'Portal: Cima del Trueno',
    'pet': 'Mascota',
    'spider sausage': 'Salchicha de araña',
    'moonkin stone': 'Piedra de lechúcico lunar',
    'shrine of remulos': 'Santuario de Remulos',
    'east garrison door': 'Puerta de la Guarnición Oriental',
    'shadowforge gate': 'Puerta de Forjatiniebla',
    'rune of mazthoril': 'Runa de Mazthoril',
    'mysterious red crystal': 'Cristal rojo misterioso',
    'auberdine moonwell': 'Poza de la Luna de Auberdine',
    "the lay of ameth'aran": "La canción de Ameth'Aran",
    "the fall of ameth'aran": "La caída de Ameth'Aran",
    'the dead tree': 'El Árbol Muerto',
    'the shadowforge lock': 'La Cerradura de Forjatiniebla',
    'aspect of the cheetah': 'Aspecto del guepardo',
    'cooking to 225': 'Cocina hasta 225',
    'the undercity': 'Entrañas',
    '7 of each color power crystal': '7 Cristales de poder de cada color',
    'felwood / azshara': 'Frondavil / Azshara',
    "tanaris / un'goro": "Tanaris / Cráter de Un'Goro",
    "gallywix's lockbox": "Arcón de Gallywix",
    'lion meat': 'Carne de león',
    'meat smoker': 'Ahumador de carne',
    'flayed demon skin': 'Piel de demonio desollada',
    'giant egg': 'Huevo gigante',
    'long elegant feather': 'Pluma elegante larga',
    'makeshift helipad': 'Helipuerto improvisado',
    "jintha'alor altar": "Altar de Jintha'Alor",
    'dash': 'Carrerilla',
    'riverglades': 'Claros del Río',
    'magram village': 'Aldea Magram',
    'the rustmaul dig site': 'La Excavación Oxidada',
    'the noxious lair': 'La Guarida Ponzoñosa',
    'broken pillar': 'Pilar Roto',
    'abyssal sands': 'Arenas Abisales',
    'eastmoon ruins': 'Ruinas de Luna del Este',
    'southmoon ruins': 'Ruinas de Luna del Sur',
    'the shimmering flats': 'El Desierto de Sal',
    'crushridge mage': 'Mago Aplastacresta',
    'find treasure': 'Buscar tesoros'
};

for (const [k, v] of Object.entries(EXTRA_ENTITIES)) {
    registerTranslation(k, v);
}

function translateEntity(str) {
    if (!str) return '';
    let s = str.trim();
    if (EN_TO_ES[s]) return EN_TO_ES[s];
    if (EN_TO_ES[s.toLowerCase()]) return EN_TO_ES[s.toLowerCase()];

    // Check pet skills like Bite (Rank 2), Claw (Rank 4), Screech (Rank 2), Dive (Rank 1)
    const petMatch = s.match(/^(Bite|Claw|Screech|Dive|Cower|Growl|Dash|Charge|Furious Howl|Lightning Breath|Scorpid Poison|Shell Shield|Prowl)\s*\(Rank\s*(\d+)\)$/i);
    if (petMatch) {
        const mapPet = {
            bite: 'Mordedura', claw: 'Zarpa', screech: 'Chirrido', dive: 'Picado',
            cower: 'Agazaparse', growl: 'Bramido', dash: 'Carrerilla', charge: 'Cargar',
            'furious howl': 'Aullido furioso', 'lightning breath': 'Aliento de relámpagos',
            'scorpid poison': 'Veneno de escórpido', 'shell shield': 'Escudo de caparazón', prowl: 'Acechar'
        };
        const pName = mapPet[petMatch[1].toLowerCase()] || petMatch[1];
        return `${pName} (Rango ${petMatch[2]})`;
    }

    // Check brackets/wrappers: [Item], <Object>, >Object<
    let prefix = '', suffix = '', core = s;
    const wrapMatch = s.match(/^([\[<>]+)(.+?)([\]<>]+)$/);
    if (wrapMatch) {
        prefix = wrapMatch[1] === '>' ? '<' : wrapMatch[1];
        core = wrapMatch[2].trim();
        suffix = wrapMatch[3] === '<' ? '>' : wrapMatch[3];
    }

    // Check trailing (N) or (Part N)
    let partSuffix = '';
    const partMatch = core.match(/^(.+?)\s*(\((?:Part\s*)?\d+\))$/i);
    if (partMatch) {
        core = partMatch[1].trim();
        partSuffix = ' ' + partMatch[2].replace(/Part/i, 'Parte');
    }

    // Check Recipe: / Manual: / Plans: / Pattern: / Formula: / Schematic:
    const recipeMatch = core.match(/^(Recipe|Manual|Plans|Pattern|Formula|Schematic):\s*(.+)$/i);
    if (recipeMatch) {
        const rMap = {
            recipe: 'Receta', manual: 'Manual', plans: 'Diseño',
            pattern: 'Patrón', formula: 'Fórmula', schematic: 'Esquema'
        };
        const rType = rMap[recipeMatch[1].toLowerCase()] || recipeMatch[1];
        const inner = translateEntity(recipeMatch[2]);
        return `${prefix}${rType}: ${inner}${partSuffix}${suffix}`;
    }

    // Check Innkeeper / Guard / Mountaineer / Sentinel / etc.
    const titleMatch = core.match(/^(Innkeeper|Barkeep|Dockmaster|Brother|Sister|Guard|Mountaineer|Sentinel|Archaeologist|Chief Archaeologist|Foreman|Captain|General|Marshal|Deputy|High Executor|Executor|Apothecary|Deathguard|Shadow Priest|Dark Cleric|Warmaster|Overlord|Grunt|Brave|Scout|Outrunner|Caretaker|Merchant|Trader|Smith|Weaponsmith|Armorsmith|Bowyer|Fletcher|Stable Master|Flight Master|Guild Master|Banker)\s+(.+)$/);
    if (titleMatch && !EN_TO_ES[core] && !EN_TO_ES[core.toLowerCase()]) {
        const tMap = {
            'Innkeeper': 'Tabernero', 'Barkeep': 'Posadero', 'Dockmaster': 'Maestro de muelles',
            'Brother': 'Hermano', 'Sister': 'Hermana', 'Guard': 'Guardia',
            'Mountaineer': 'Montaraz', 'Sentinel': 'Centinela', 'Archaeologist': 'Arqueólogo',
            'Chief Archaeologist': 'Arqueólogo jefe', 'Foreman': 'Supervisor', 'Captain': 'Capitán',
            'General': 'General', 'Marshal': 'Alguacil', 'Deputy': 'Ayudante',
            'High Executor': 'Alto ejecutor', 'Executor': 'Ejecutor', 'Apothecary': 'Boticario',
            'Deathguard': 'Guardia de la muerte', 'Shadow Priest': 'Sacerdote de las Sombras',
            'Dark Cleric': 'Clérigo oscuro', 'Warmaster': 'Maestro de guerra', 'Overlord': 'Señor supremo',
            'Grunt': 'Bruto', 'Brave': 'Valiente', 'Scout': 'Explorador', 'Outrunner': 'Batidor',
            'Caretaker': 'Cuidador', 'Merchant': 'Mercader', 'Trader': 'Comerciante',
            'Smith': 'Herrero', 'Weaponsmith': 'Forjador de armas', 'Armorsmith': 'Forjador de armaduras',
            'Bowyer': 'Arquero', 'Fletcher': 'Flechero', 'Stable Master': 'Maestro de establos',
            'Flight Master': 'Maestro de vuelo', 'Guild Master': 'Maestro de hermandad', 'Banker': 'Banquero'
        };
        const esTitle = tMap[titleMatch[1]] || titleMatch[1];
        const rest = EN_TO_ES[titleMatch[2]] || EN_TO_ES[titleMatch[2].toLowerCase()] || titleMatch[2];
        return `${prefix}${esTitle} ${rest}${partSuffix}${suffix}`;
    }

    const translatedCore = EN_TO_ES[core] || EN_TO_ES[core.toLowerCase()] || core;
    return `${prefix}${translatedCore}${partSuffix}${suffix}`;
}

const TRAVEL_EXACT = {
    'into floo network': 'hacia la red de portales',
    'back through floo network': 'de vuelta por la red de portales',
    'to end of dock': 'hacia el final del muelle',
    'into water': 'al agua',
    'down into water': 'hacia abajo al agua',
    'out auberdine side exit': 'por la salida lateral de Auberdine',
    'through unguarded border wall': 'a través del muro fronterizo sin vigilancia',
    'up mountain': 'subiendo por la montaña',
    'up mountain pass': 'subiendo por el paso de montaña',
    'up mountain path': 'subiendo por el sendero de la montaña',
    'through mountain pass': 'a través del paso de montaña',
    'to nowhere': 'hacia el vacío',
    'at nowhere': 'en el vacío',
    'around dangerous mobs': 'rodeando a los enemigos peligrosos',
    'up cliff': 'subiendo por el acantilado',
    'up cliff path': 'subiendo por el sendero del acantilado',
    'off cliff and die': 'saltando por el acantilado para morir y reaparecer',
    'down ledge': 'bajando por el saliente',
    'onto ledge': 'sobre el saliente',
    'onto other ledge': 'sobre el otro saliente',
    'around pillar': 'alrededor del pilar',
    'through crack in wall': 'a través de la grieta en el muro',
    'past elite mob': 'pasando de largo al enemigo élite',
    'to castle wall': 'hacia el muro del castillo',
    'to diving spot': 'hacia el punto de inmersión',
    'through raynewood retreat': 'a través del Retiro Árbol del Cielo',
    'up path': 'subiendo por el sendero',
    'up side path': 'subiendo por el sendero lateral',
    'up hidden path': 'subiendo por el sendero oculto',
    'up idyllic path': 'subiendo por el sendero de la colina',
    'along dirt path': 'por el camino de tierra',
    'to dirt path': 'hacia el camino de tierra',
    'to dustwallow road': 'hacia el camino de Marjal Revolcafango',
    'along dirt path to brackenwall village': 'por el camino de tierra hacia el Poblado Murohelecho',
    'through night run': 'a través de la Senda de la Noche',
    'to night run': 'hacia la Senda de la Noche',
    'around murlocs': 'rodeando a los múrlocs',
    'to safe parts': 'hacia la zona segura',
    'to safe crossing': 'hacia el cruce seguro',
    'down staircase': 'bajando las escaleras',
    'down again': 'bajando un nivel más',
    'down': 'hacia abajo',
    'down to lower level': 'hacia el nivel inferior',
    'across rope bridge': 'cruzando el puente colgante',
    'to broken bridge': 'hacia el puente roto',
    'across gap': 'al otro lado del hueco',
    'to ravenholdt path': 'hacia el sendero de Ravenholdt',
    'to ravenholdt tunnel': 'hacia el túnel de Ravenholdt',
    'up ramp to ravenholdt manor': 'subiendo la rampa hacia la Mansión Ravenholdt',
    'to kurzen cave': 'hacia la cueva de Kurzen',
    'up shortcut': 'subiendo por el atajo',
    'through shortcut': 'a través del atajo',
    'behind stromgarde': 'por detrás de Stromgarde',
    'past andorhal': 'pasando Andorhal',
    'across water': 'cruzando el agua',
    'around horde guards': 'rodeando a los guardias de la Horda',
    'across dustwallow bay': 'cruzando la Bahía Revolcafango',
    'north around camp mojache': 'hacia el norte rodeando el Campamento Mojache',
    "to hole in thoradin's wall": 'hacia la brecha en la Muralla de Thoradin',
    "through hole in thoradin's wall": 'a través de la brecha en la Muralla de Thoradin',
    'down to the shore': 'bajando hacia la costa',
    'to shore': 'hacia la costa',
    'to coast': 'hacia la costa',
    'along coast to theramore': 'bordeando la costa hacia Theramore',
    'around theramore': 'rodeando Theramore',
    'around darkshire': 'rodeando Villa Oscura',
    'around astranaar': 'rodeando Astranaar',
    "past maestra's post": 'pasando la Atalaya de Maestra',
    'around ruins of alterac': 'rodeando las Ruinas de Alterac',
    'around the cauldron': 'rodeando La Caldera',
    'around blazerunner': 'rodeando a Correllamas',
    'down into the slag pit': 'bajando hacia La Hoya de la Escoria',
    'safely down into the slag pit': 'bajando con cuidado hacia La Hoya de la Escoria',
    'out the slag pit lower exit': 'por la salida inferior de La Hoya de la Escoria',
    'up firewatch ridge': 'subiendo por la Cresta Vigía de Fuego',
    'up path to firewatch ridge': 'subiendo por el sendero hacia la Cresta Vigía de Fuego',
    'to the mainland': 'hacia tierra firme',
    'up ramp': 'subiendo por la rampa',
    'across two bridges': 'cruzando los dos puentes',
    'right, avoiding naga': 'hacia la derecha, evitando a los naga',
    'along cliff to fallen statue': 'bordeando el acantilado hacia la estatua caída',
    'up hills behind face of statue': 'subiendo las colinas detrás del rostro de la estatua',
    'up to peak overlooking helipad': 'subiendo hasta la cima sobre la plataforma de aterrizaje',
    'backpedal down slope': 'bajando con cuidado por la pendiente',
    'into ocean without dying': 'hacia el océano sin caer en tierra',
    'up helipad island': 'subiendo a la isla de la plataforma',
    'up shortcut to top of fire plume ridge': 'subiendo por el atajo hasta la cima de la Cresta del Penacho en Llamas',
    'due north': 'directamente hacia el norte',
    'onto esports monorail': 'sobre el raíl elevado',
    'across monorail': 'cruzando por el raíl elevado',
    'around pit of despair': 'rodeando el foso',
    'up spooky scorpid pathway': 'subiendo por el sendero de los escórpidos',
    'through door': 'a través de la puerta',
    'out window to incendius': 'por la ventana hacia Incendius',
    'back out portal to blackrock mountain': 'saliendo por el portal de vuelta a la Montaña Roca Negra',
    'to mountaintop': 'hacia la cima de la montaña',
    'up shaman switchback trail': 'subiendo por el sendero en zigzag del chamán',
    'up esports footpath': 'subiendo por el atajo de la colina',
    'up to raptor heaven': 'subiendo hacia los nidos de raptores',
    'to stonetalon border': 'hacia la frontera de Sierra Espolón',
    'out orgrimmar side entrance': 'por la salida lateral de Orgrimmar',
    'onto ship': 'subiendo al barco',
    'out northwatch hold back exit': 'por la salida trasera del Fuerte del Norte',
    'over hill to wc': 'cruzando la colina hacia Cuevas de los Lamentos',
    'up hill above wc': 'subiendo la colina sobre Cuevas de los Lamentos',
    'to sewers': 'hacia las cloacas',
    'to freewind post elevators': 'hacia los elevadores del Poblado Viento Libre',
    'up to highperch': 'subiendo hacia Nido Alto',
    'mlg mountaineering': 'subiendo por el atajo de montaña',
    'up mlg mound': 'subiendo por el montículo',
    'over mlg hazard': 'sobre el obstáculo',
    'to point of divergence': 'hacia el punto de bifurcación',
    'to thread the needle': 'entre los enemigos con cuidado',
    'to campsite': 'hacia el campamento',
    'back to jarl': 'de vuelta con Jarl',
    'to ogres': 'hacia los ogros',
    "to xylem's tower": 'hacia la torre de Xylem',
    'to cave entrance': 'hacia la entrada de la cueva',
    'back to fungal rock': 'de vuelta a la Roca Fúngica',
    'back to shadow hold': 'de vuelta al Bastión de las Sombras',
    'back to winterspring': 'de vuelta a Cuna del Invierno',
    'over hills': 'cruzando las colinas',
    'for elite dark iron quests': 'para las misiones élite de los Hierro Negro',
    'for firewatch ridge quests': 'para las misiones de la Cresta Vigía de Fuego',
    'for dun garok elite quests': 'para las misiones élite de Dun Garok',
    'for araj and hearthglen': 'para Araj y Vega del Amparo',
    'for dragonkin menace': 'para La amenaza de los dragonantes',
    'for kirith': 'para Kirith el Maldito',
    'until hearth is almost up': 'hasta que tu Piedra de hogar esté casi lista.',
    'to unfriendly with timbermaw hold': 'hasta alcanzar Mal visto con los Fauces de Madera.',
    'to 2125 / 3000 neutral reputation with argent dawn': 'hasta alcanzar 2125 / 3000 de reputación Neutral con el Alba Argenta.',
    "out the portal to rut'theran village": "saliendo por el portal hacia la Aldea Rut'theran",
    'to near 54': 'hasta casi el nivel 54.',
    'near 54': 'hasta casi el nivel 54.'
};

function translateTravel(text) {
    if (!text) return text;
    const normalizeSpanish = (s) => s
        .replace(/\bde el\b/g, 'del')
        .replace(/\ba el\b/g, 'al');
    let t = text.trim();
    const low = t.toLowerCase();
    if (TRAVEL_EXACT[low]) return normalizeSpanish(TRAVEL_EXACT[low]);

    const prefixes = [
        [/^to\s+(.+)$/i, 'hacia'],
        [/^into\s+(.+)$/i, 'hacia el interior de'],
        [/^at\s+(.+)$/i, 'en'],
        [/^in\s+(.+)$/i, 'en'],
        [/^near\s+(.+)$/i, 'cerca de'],
        [/^for\s+(.+)$/i, 'para'],
        [/^through\s+(.+)$/i, 'a través de'],
        [/^around\s+(.+)$/i, 'alrededor de'],
        [/^past\s+(.+)$/i, 'pasando'],
        [/^up\s+(.+)$/i, 'subiendo a'],
        [/^down into\s+(.+)$/i, 'bajando a'],
        [/^back to\s+(.+)$/i, 'de vuelta a']
    ];

    for (const [regex, prep] of prefixes) {
        const m = t.match(regex);
        if (m) {
            const rawDest = m[1].trim().replace(/[><]/g, '');
            const cleanDest = rawDest.toLowerCase();
            if (TRAVEL_MAP[cleanDest]) {
                return normalizeSpanish(`${prep} ${TRAVEL_MAP[cleanDest]}`);
            }
            const entityDest = translateEntity(rawDest);
            return normalizeSpanish(`${prep} ${entityDest}`);
        }
    }

    const clean = low.replace(/[><]/g, '').trim();
    if (TRAVEL_MAP[clean]) {
        return normalizeSpanish(TRAVEL_MAP[clean]);
    }
    return normalizeSpanish(translateEntity(t));
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

function translateGrind(q) {
    if (!q) return 'hasta alcanzar el nivel indicado.';
    const m1 = q.match(/^to\s+L(\d+)$/i);
    if (m1) return `hasta alcanzar el nivel ${m1[1]}.`;
    const m2 = q.match(/^to\s+(\d+\s*\/\s*\d+)\s+L(\d+)$/i);
    if (m2) return `hasta alcanzar ${m2[1]} de experiencia en el nivel ${m2[2]}.`;
    return translateTravel(q);
}

// Translate step items to Lua
function convertStepToLua(stepObj, stepIdx, defaultMapId, guideInfo) {
    const stepId = `${String(Math.floor(stepIdx / 10) + 1).padStart(2, '0')}-${String((stepIdx % 10) + 1).padStart(2, '0')}`;
    const items = stepObj.items;

    const locations = [];
    const taskGroups = [];

    for (const item of items) {
        const action = (item[1] || '').trim();
        const rawId = (item[6] || '').trim();
        const questId = /^\d+$/.test(rawId) ? parseInt(rawId) : null;
        const itemId = /^\[\d+\]$/.test(rawId) ? parseInt(rawId.slice(1, -1)) : null;
        const spellId = /^\{\d+\}$/.test(rawId) ? parseInt(rawId.slice(1, -1)) : null;
        const rawQuestName = (item[8] || '').trim();
        const rawNpcName = (item[9] || '').trim();
        const questName = translateEntity(rawQuestName);
        const npcName = translateEntity(rawNpcName);
        const npcId = item[10] && !isNaN(parseInt(item[10])) ? parseInt(item[10]) : null;
        const coords = item[12] || '';
        const zoneRaw = item[13] || '';
        const mapId = zoneRaw ? getZoneMapId(zoneRaw, defaultMapId) : defaultMapId;

        if (coords && coords.includes(',')) {
            const parts = coords.split(',');
            const x = parseFloat(parts[0]).toFixed(2);
            const y = parseFloat(parts[1]).toFixed(2);
            if (!isNaN(x) && !isNaN(y)) {
                if (npcId) {
                    locations.push(`{ "|${mapId}|${x}|${y}", npc = ${npcId} }`);
                } else if (questId) {
                    locations.push(`{ "|${mapId}|${x}|${y}", quest = ${questId} }`);
                } else if (itemId) {
                    locations.push(`{ "|${mapId}|${x}|${y}", item = ${itemId} }`);
                } else {
                    let locLabel = rawNpcName ? npcName : translateTravel(rawQuestName);
                    if (!locLabel) locLabel = 'Sigue el punto de ruta';
                    locations.push(`{ "|${mapId}|${x}|${y}", label = "${escapeLua(locLabel)}" }`);
                }
            }
        }

        const tasksLua = [];
        let desc = '';
        let multitextLua = null;

        if (action === 'Pick Up' || action === 'Pick Up*') {
            if (questId) {
                tasksLua.push(`{ accept = ${questId}${npcId ? `, fromnpc = ${npcId}` : ''} }`);
            } else {
                desc = npcName ? `Habla con ${npcName} y acepta: ${questName}` : `Acepta la misión: ${questName}`;
            }
        } else if (action === 'Hand In' || action === 'Hand In*' || action === 'Quick Hand In' || action === 'Hand') {
            if (questId) {
                tasksLua.push(`{ turnin = ${questId}${npcId ? `, fromnpc = ${npcId}` : ''} }`);
            } else if (npcId) {
                multitextLua = `{ "Habla con ", { npc = ${npcId} }${questName ? `, " y entrega: ${escapeLua(questName)}."` : ', "."'} }`;
            } else {
                desc = npcName ? `Habla con ${npcName} y entrega: ${questName}` : `Entrega la misión: ${questName}`;
            }
        } else if (action === 'Accept Item Quest' || action === 'Accept Item Quest*') {
            if (questId) {
                tasksLua.push(`{ accept = ${questId} }`);
            } else {
                desc = `Usa ${npcName || 'el objeto de misión en tu inventario'} y acepta la misión: ${questName}`;
            }
        } else if (action === 'Kill') {
            if (questId) {
                tasksLua.push(`{ complete = ${questId} }`);
            } else if (npcId) {
                multitextLua = `{ "Derrota a ", { npc = ${npcId} }, "." }`;
            } else {
                desc = `Derrota a los objetivos requeridos para la misión: ${questName || npcName}`;
            }
        } else if (action === 'Collect' || action === 'Loot' || action === 'Loot*' || action === 'Get') {
            if (itemId) {
                tasksLua.push(`{ getitem = ${itemId} }`);
            } else if (questId) {
                tasksLua.push(`{ complete = ${questId} }`);
            } else {
                desc = npcName ? `Consigue ${questName} de ${npcName}.` : `Consigue los objetos necesarios: ${questName}.`;
            }
        } else if (action === 'Complete Quest' || action === 'Complete Objective') {
            if (questId) {
                tasksLua.push(`{ complete = ${questId} }`);
            } else if (npcId) {
                multitextLua = `{ "Cumple los objetivos con ", { npc = ${npcId} }, "." }`;
            } else {
                desc = npcName ? `Cumple los objetivos de: ${questName} (${npcName}).` : `Cumple los objetivos indicados de: ${questName}.`;
            }
        } else if (action === 'Progress Quest' || action === 'Progress Objective') {
            if (questId) {
                tasksLua.push(`{ startwork = ${questId} }`);
            } else if (npcId) {
                multitextLua = `{ "Avanza en los objetivos con ", { npc = ${npcId} }, "." }`;
            } else {
                desc = npcName ? `Avanza en los objetivos de: ${questName} (${npcName}).` : `Avanza en los objetivos de: ${questName}.`;
            }
        } else if (action === 'Skip' || action === 'Skip*' || action === 'Skip for now') {
            if (questId) {
                multitextLua = `{ "Omite por ahora la misión: ", { skipped = ${questId} }, "." }`;
            } else {
                desc = `Omite por ahora la misión: ${questName}${npcName ? ' (' + npcName + ')' : ''}.`;
            }
        } else if (action === 'Set Hearth') {
            const locText = rawQuestName ? ' ' + translateTravel(rawQuestName) : '';
            if (npcId) {
                multitextLua = `{ "Fija tu Piedra de hogar${escapeLua(locText)} con ", { npc = ${npcId} }, "." }`;
            } else {
                desc = `Fija tu Piedra de hogar${locText}${npcName ? ' con ' + npcName : ' en la posada local'}.`;
            }
        } else if (action === 'Get Flight Path') {
            const locText = rawQuestName ? ' ' + translateTravel(rawQuestName) : '';
            if (npcId) {
                multitextLua = `{ "Descubre la ruta de vuelo${escapeLua(locText)} hablando con ", { npc = ${npcId} }, "." }`;
            } else {
                desc = `Descubre la nueva ruta de vuelo${locText} hablando con ${npcName || 'el maestro de vuelo'}.`;
            }
        } else if (action === 'Fly') {
            const dest = rawQuestName ? translateTravel(rawQuestName) : 'hacia tu próximo destino';
            if (npcId) {
                multitextLua = `{ "Habla con ", { npc = ${npcId} }, " para volar ${escapeLua(dest)}." }`;
            } else {
                desc = `Utiliza el maestro de vuelo${npcName ? ' (' + npcName + ')' : ''} para volar ${dest}.`;
            }
        } else if (action === 'Hearth') {
            const dest = rawQuestName ? translateTravel(rawQuestName) : 'hacia tu posada';
            desc = `Usa tu Piedra de hogar ${dest}.`;
        } else if (action === 'Teleport') {
            const dest = rawQuestName ? translateTravel(rawQuestName) : 'hacia tu destino';
            desc = `Teletranspórtate ${dest}.`;
        } else if (action === 'Go') {
            const dest = rawQuestName ? translateTravel(rawQuestName) : (npcName ? 'hacia ' + npcName : 'por la ruta indicada');
            desc = `Dirígete ${dest}${rawQuestName && npcName ? ' (' + npcName + ')' : ''}.`;
        } else if (action === 'Jump') {
            const dest = rawQuestName ? translateTravel(rawQuestName) : 'hacia abajo';
            desc = `Salta ${dest}.`;
        } else if (action === 'Blink') {
            const dest = rawQuestName ? translateTravel(rawQuestName) : 'hacia adelante';
            desc = `Usa Traslación ${dest}.`;
        } else if (action === 'Die') {
            const locText = rawQuestName ? ' ' + translateTravel(rawQuestName) : '';
            desc = `Muere a propósito${locText} para reaparecer en el cementerio cercano.`;
        } else if (action === 'Spirit Rez') {
            const locText = rawQuestName ? ' ' + translateTravel(rawQuestName) : '';
            desc = `Revive con el Ángel de la Resurrección${locText}.`;
        } else if (action === 'Grind') {
            desc = `Derrota enemigos por el camino ${translateGrind(rawQuestName)}`;
        } else if (action.startsWith('DING ')) {
            const lvl = action.replace('DING ', '').trim();
            desc = `¡Alcanza el nivel ${lvl} antes de continuar!`;
        } else if (action === 'Train') {
            if (rawQuestName && npcId) {
                multitextLua = `{ "Aprende ${escapeLua(questName)} con ", { npc = ${npcId} }, "." }`;
            } else if (rawQuestName) {
                desc = `Aprende ${questName}${npcName ? ' con ' + npcName : ' con tu instructor'}.`;
            } else if (npcId) {
                multitextLua = `{ "Visita a tu instructor ", { npc = ${npcId} }, " para aprender nuevos hechizos y facultades." }`;
            } else {
                desc = `Visita a tu instructor para aprender nuevos rangos de hechizos y facultades.`;
            }
            tasksLua.push(`{ merchant = TALENTS, optional = true }`);
        } else if (action === 'Learn') {
            if (spellId) {
                multitextLua = `{ "Aprende ", { spell = ${spellId} }, "." }`;
            } else if (itemId) {
                multitextLua = `{ "Usa ", { item = ${itemId} }, " para aprender la receta." }`;
            } else {
                desc = `Aprende ${questName}${npcName ? ' con ' + npcName : ''}.`;
            }
        } else if (action === 'Vendor' || action === 'Vendor + Repair' || action === 'Repair') {
            if (npcId) {
                multitextLua = `{ "Visita a ", { npc = ${npcId} }, " para vender chatarra, reparar armadura y reponer provisiones." }`;
            } else {
                desc = `Visita a un comerciante para vender chatarra, reparar armadura y reponer provisiones.`;
            }
            tasksLua.push(`{ merchant = SUPPLIES, optional = true }`);
        } else if (action === 'Buy') {
            if (itemId && npcId) {
                multitextLua = `{ "Compra ", { item = ${itemId} }, " a ", { npc = ${npcId} }, "." }`;
            } else if (itemId) {
                multitextLua = `{ "Compra ", { item = ${itemId} }, "." }`;
            } else {
                desc = `Compra ${questName || 'provisiones'}${npcName ? ' a ' + npcName : ' en el comerciante'}.`;
            }
            tasksLua.push(`{ merchant = SUPPLIES, optional = true }`);
        } else if (action === 'Save') {
            if (itemId) {
                multitextLua = `{ "Guarda ", { item = ${itemId} }, " en tu inventario o banco para más adelante." }`;
            } else {
                desc = `Guarda ${questName} en tu inventario o banco para más adelante.`;
            }
        } else if (action === 'Use') {
            if (itemId && npcId) {
                multitextLua = `{ "Usa ", { item = ${itemId} }, " en ", { npc = ${npcId} }, "." }`;
            } else if (itemId) {
                multitextLua = `{ "Usa ", { item = ${itemId} }${npcName ? `, " en ${escapeLua(npcName)}."` : ', "."'} }`;
            } else if (questName) {
                desc = `Usa ${questName}${npcName ? ' en ' + npcName : ''}.`;
            } else {
                desc = `Interactúa con ${npcName || 'el objeto indicado'}.`;
            }
        } else if (action === 'Destroy') {
            if (itemId) {
                multitextLua = `{ "Destruye ", { item = ${itemId} }, " de tu inventario si ya no lo necesitas." }`;
            } else {
                desc = `Destruye ${questName} de tu inventario si ya no lo necesitas.`;
            }
        } else if (action === 'Equip') {
            if (itemId) {
                multitextLua = `{ "Equípate ", { item = ${itemId} }, "." }`;
            } else {
                desc = `Equípate ${questName}.`;
            }
        } else if (action === 'Craft') {
            if (spellId) {
                multitextLua = `{ "Fabrica ", { spell = ${spellId} }, "." }`;
            } else if (itemId) {
                multitextLua = `{ "Fabrica ", { item = ${itemId} }, "." }`;
            } else {
                desc = `Fabrica ${questName}${npcName ? ' usando ' + npcName : ''}.`;
            }
        } else if (action === 'Bank Deposit') {
            if (itemId && npcId) {
                multitextLua = `{ "Deposita ", { item = ${itemId} }, " en el banco con ", { npc = ${npcId} }, "." }`;
            } else if (itemId) {
                multitextLua = `{ "Deposita ", { item = ${itemId} }, " en el banco." }`;
            } else {
                desc = `Deposita ${questName} en el banco${npcName ? ' con ' + npcName : ''}.`;
            }
        } else if (action === 'Bank Withdrawal') {
            if (itemId && npcId) {
                multitextLua = `{ "Retira ", { item = ${itemId} }, " del banco con ", { npc = ${npcId} }, "." }`;
            } else if (itemId) {
                multitextLua = `{ "Retira ", { item = ${itemId} }, " del banco." }`;
            } else {
                desc = `Retira ${questName} del banco${npcName ? ' con ' + npcName : ''}.`;
            }
        } else if (action === 'Start Finding Group' || action === 'Find Group') {
            desc = `Busca grupo ${translateTravel(rawQuestName)}.`;
        } else if (action === 'Dungeon' || action === 'Complete Dungeon') {
            desc = `Completa la mazmorra: ${translateTravel(rawQuestName)}.`;
        } else if (action === 'Discover') {
            desc = `Descubre la zona: ${translateTravel(rawQuestName)}.`;
        } else if (action === 'Pickpocket' || action === 'Pick Pocket') {
            if (itemId && npcId) {
                multitextLua = `{ "Usa Hurtar en ", { npc = ${npcId} }, " para obtener ", { item = ${itemId} }, "." }`;
            } else if (questId) {
                tasksLua.push(`{ complete = ${questId} }`);
            } else {
                desc = `Usa Hurtar en ${npcName || 'el objetivo'} para obtener ${questName}.`;
            }
        } else if (action === 'Pick Lock') {
            desc = `Usa Ganzúa para abrir ${npcName || questName}.`;
        } else if (action === 'Abandon Pet') {
            if (npcId) {
                multitextLua = `{ "Abandona tu mascota actual (", { npc = ${npcId} }, ")." }`;
            } else {
                desc = `Abandona tu mascota actual${npcName ? ' (' + npcName + ')' : ''}.`;
            }
        } else if (action === 'Tame') {
            if (npcId) {
                multitextLua = `{ "Domestica a ", { npc = ${npcId} }, "." }`;
            } else {
                desc = `Domestica a ${npcName || questName}.`;
            }
        } else if (action === 'Stable Pet') {
            if (npcId) {
                multitextLua = `{ "Guarda tu mascota en el establo con ", { npc = ${npcId} }, "." }`;
            } else {
                desc = `Guarda tu mascota en el establo con ${npcName || 'el maestro de establos'}.`;
            }
        } else if (action === 'Withdraw Pet') {
            if (npcId) {
                multitextLua = `{ "Saca tu mascota del establo con ", { npc = ${npcId} }, "." }`;
            } else {
                desc = `Saca tu mascota del establo con ${npcName || 'el maestro de establos'}.`;
            }
        } else {
            let cleanDesc = rawQuestName ? translateTravel(rawQuestName) : npcName;
            if (!cleanDesc) cleanDesc = 'Prosigue por la ruta de viaje recomendada.';
            desc = cleanDesc;
            if (questId) tasksLua.push(`{ complete = ${questId} }`);
        }

        const groupEntries = [];
        if (multitextLua) {
            groupEntries.push(`\t\t\t${multitextLua}`);
        } else if (desc) {
            groupEntries.push(`\t\t\t"${escapeLua(desc)}"`);
        }
        for (const t of tasksLua) {
            groupEntries.push(`\t\t\t${t}`);
        }
        if (groupEntries.length > 0) {
            taskGroups.push(`\t\t{\n` + groupEntries.join(',\n') + `,\n\t\t}`);
        }
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
        const descParts = guideInfo.description.split(' ');
        const lvlRange = descParts[0];
        const rawZone = descParts.slice(1).join(' ');
        const esZone = translateEntity(rawZone);
        const esDesc = `${lvlRange} ${esZone}`;
        lua += `\t{\n\t\tid = "01-01",\n\t\tlocations = {\n\t\t\t{ "|${defaultMapId}|50.0|50.0", label = "${escapeLua(esDesc)}" },\n\t\t},\n\t\t{\n\t\t\t"Bienvenido a la guía de ${escapeLua(esDesc)} en WoW Forever. Explora el puesto avanzado principal, habla con el maestro de vuelo y acepta las misiones disponibles del sagrario local.",\n\t\t\t{ button = "Continuar", optional = true },\n\t\t},\n\t},\n`;
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
        const escapedId = guideId.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        const hasSlotRx = new RegExp(`guideID = "${escapedId}",\\r?\\n\\tslot = \\d+,`);
        if (!hasSlotRx.test(updatedGuidesDecoded)) {
            updatedGuidesDecoded = updatedGuidesDecoded.replace(targetStr, `guideID = "${guideId}",\n\tslot = ${slotNum},`);
        }
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
