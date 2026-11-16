const fs = require('fs');
const path = require('path');

const GAME_GUIDES_DIR = 'D:/World of Warcraft/_forever_/Interface/AddOns/Journey/BundledContent/Guides';
const SRC_GUIDES_DIR = 'src/Journey/BundledContent/Guides';
const DICT_PATH = 'tools/resources/early_guides_es_dict.json';

// Non-translatable control keys confirmed across 0001..0021.html
const NON_TRANSLATABLE_KEYS = new Set([
  'id', 'condition', 'completed', 'color', 'location', 'oncomplete',
  'bordercolor', 'icon', 'goto', 'guide', 'illustration', 'around', 'at',
  'onenter', 'repeatuntil', 'onactivate', 'defaultguide', 'setvar', 'onleave',
  'quest', 'flags', 'productID', 'contentHash', 'group', 'guideID',
  'guideVersion', 'minAddonVersion', 'levels', 'faction', 'races', 'classes',
  'gender', 'action', 'value', 'name', 'type', 'step', 'zone', 'slot',
  'template', 'recommended'
]);

const DIRECTIVE_STRINGS = new Set(['multitext', 'GUIDE', 'prereqs']);
const COORD_RX = /^(?:[A-Z]+\|)?(?:\|\d+|\d+(?:\.\d+)?\|)/;

const EN_STOP = new Set([
  'a','an','and','are','as','at','be','but','by','can','do','for','from','get','go',
  'has','have','he','her','him','his','how','if','in','into','is','it','its','may',
  'me','my','no','not','of','off','on','or','our','out','put','run','see','set','she',
  'so','than','that','the','them','then','there','these','they','this','those','to',
  'too','up','us','use','was','way','we','were','what','when','where','which','who',
  'why','will','with','you','your','all','one','two','now','here','back','down','next',
  'only','just','well','very','even','much','more','most','some','any','each','other'
]);

const EN_TO_ES = {};
const MULTIWORD_ENTITIES = new Map();

function registerEntity(en, es, force = false) {
  if (!en || !es) return;
  en = en.trim();
  es = es.trim();
  if (!en || !es || en.length < 3 || EN_STOP.has(en.toLowerCase())) return;
  if (force || !EN_TO_ES[en]) EN_TO_ES[en] = es;
  const low = en.toLowerCase();
  if ((en.includes(' ') || en.length >= 4) && (force || !EN_TO_ES[low])) {
    EN_TO_ES[low] = es;
  }
  if (en.includes(' ') && en.length >= 5 && !MULTIWORD_ENTITIES.has(low)) {
    MULTIWORD_ENTITIES.set(low, es);
  }
}

// 1. Load GearQuestForever official enUS -> esES tables
for (const f of [
  'src/GearQuestForever_Languages/esES.names.lua',
  'src/GearQuestForever_Languages/esES.db2.lua',
  'src/GearQuestForever_Languages/esES.quests.lua',
  'src/GearQuestForever_Languages/esES.sentences.lua'
]) {
  if (!fs.existsSync(f)) continue;
  const txt = fs.readFileSync(f, 'utf8');
  for (const m of txt.matchAll(/\["((?:[^"\\]|\\.)+)"\]\s*=\s*"((?:[^"\\]|\\.)+)"/g)) {
    registerEntity(m[1].replace(/\\"/g, '"'), m[2].replace(/\\"/g, '"'));
  }
}

// 2. Load GameObjectNames and TaxiNodes ([id] = "Name")
for (const [fEn, fEs] of [
  ['src/Journey/data/GameObjectNames/GameObjectNames-enUS.lua', 'src/Journey/data/GameObjectNames/GameObjectNames-esES.lua'],
  ['src/Journey/data/TaxiNodes/TaxiNodes-enUS.lua', 'src/Journey/data/TaxiNodes/TaxiNodes-esES.lua'],
]) {
  if (!fs.existsSync(fEn) || !fs.existsSync(fEs)) continue;
  const tEn = fs.readFileSync(fEn, 'utf8');
  const tEs = fs.readFileSync(fEs, 'utf8');
  const byId = {};
  for (const m of tEn.matchAll(/\[(\d+)\]\s*=\s*"((?:[^"\\]|\\.)+)"/g)) byId[m[1]] = m[2];
  for (const m of tEs.matchAll(/\[(\d+)\]\s*=\s*"((?:[^"\\]|\\.)+)"/g)) {
    if (byId[m[1]]) {
      registerEntity(byId[m[1]], m[2]);
      if (byId[m[1]].includes(',')) registerEntity(byId[m[1]].split(',')[0], m[2].split(',')[0]);
    }
  }
}

// 2b. Extract QuestInfo objective items & quest requirements
if (fs.existsSync('src/Journey/data/QuestInfo/QuestInfo-enUS.lua') && fs.existsSync('src/Journey/data/QuestInfo/QuestInfo-esES.lua')) {
  const qEn = fs.readFileSync('src/Journey/data/QuestInfo/QuestInfo-enUS.lua', 'utf8');
  const qEs = fs.readFileSync('src/Journey/data/QuestInfo/QuestInfo-esES.lua', 'utf8');
  const qEnById = {};
  for (const m of qEn.matchAll(/\[(\d+)\]\s*=\s*"((?:[^"\\]|\\.)+)"/g)) qEnById[m[1]] = m[2];
  for (const m of qEs.matchAll(/\[(\d+)\]\s*=\s*"((?:[^"\\]|\\.)+)"/g)) {
    const enTxt = qEnById[m[1]];
    if (!enTxt) continue;
    const enReqs = [...enTxt.matchAll(/\\n - (?:\d+ x )?([^\\"\n]+?)(?: x \d+)?(?=(?:\\n|$))/g)].map(x => x[1].replace(/\s*\([^)]*\)\s*$/, '').trim());
    const esReqs = [...m[2].matchAll(/\\n - (?:\d+ x )?([^\\"\n]+?)(?: x \d+)?(?=(?:\\n|$))/g)].map(x => x[1].replace(/\s*\([^)]*\)\s*$/, '').trim());
    if (enReqs.length === esReqs.length) {
      for (let i = 0; i < enReqs.length; i++) {
        if (enReqs[i] && esReqs[i] && enReqs[i].toLowerCase() !== esReqs[i].toLowerCase()) {
          registerEntity(enReqs[i], esReqs[i]);
        }
      }
    }
  }
}

// 2c. Load EXTRA_ENTITIES from generate_all_guides.js
if (fs.existsSync('tools/generate_all_guides.js')) {
  const genSrc = fs.readFileSync('tools/generate_all_guides.js', 'utf8');
  const mExtra = genSrc.match(/const EXTRA_ENTITIES = \{([\s\S]*?)\n\};/);
  if (mExtra) {
    const vm = require('vm');
    const extraObj = vm.runInNewContext('({' + mExtra[1] + '})');
    for (const [k, v] of Object.entries(extraObj)) {
      registerEntity(k, v, true);
    }
  }
}

// 3. Load WMOAreas (INVERTED FORMAT: ["Name"] = id)
{
  const fEn = 'src/Journey/data/WMOAreas/WMOAreas-enUS.lua';
  const fEs = 'src/Journey/data/WMOAreas/WMOAreas-esES.lua';
  if (fs.existsSync(fEn) && fs.existsSync(fEs)) {
    const wEn = fs.readFileSync(fEn, 'utf8');
    const wEs = fs.readFileSync(fEs, 'utf8');
    const byId = {};
    for (const m of wEn.matchAll(/\["((?:[^"\\]|\\.)+)"\]\s*=\s*(\d+)/g)) {
      const name = m[1].replace(/\\"/g, '"').trim();
      if (name) byId[m[2]] = name;
    }
    for (const m of wEs.matchAll(/\["((?:[^"\\]|\\.)+)"\]\s*=\s*(\d+)/g)) {
      const esName = m[1].replace(/\\"/g, '"').trim();
      if (byId[m[2]] && esName) registerEntity(byId[m[2]], esName);
    }
  }
}

// 4. Load Leatrix_Maps & Leatrix_Plus full esES blocks
for (const f of ['src/Leatrix_Maps/Leatrix_Maps_Locale.lua', 'src/Leatrix_Plus/Leatrix_Plus_Locale.lua']) {
  if (!fs.existsSync(f)) continue;
  const txt = fs.readFileSync(f, 'utf8');
  const m = txt.match(/if GameLocale == "esES" then([\s\S]*?)\nif GameLocale == "/);
  if (m) {
    for (const entry of m[1].matchAll(/L\["([^"]+)"\]\s*=\s*"([^"]+)"/g)) {
      registerEntity(entry[1], entry[2]);
    }
  }
}

// 5. Load Journey/lang/esES.lua (excluding 'next')
if (fs.existsSync('src/Journey/lang/esES.lua')) {
  const jEs = fs.readFileSync('src/Journey/lang/esES.lua', 'utf8');
  for (const m of jEs.matchAll(/L\["([^"]+)"\]\s*=\s*"((?:[^"\\]|\\.)+)"/g)) {
    if (m[1] !== 'next') registerEntity(m[1], m[2]);
  }
}

// 6. Custom WoW Forever, classic zones/cities, plural beasts, trainers & abbreviations
const GLOSSARY = {
  // Abbreviations & Cities
  'XRs': 'El Cruce',
  'The Crossroads': 'El Cruce',
  'Crossroads': 'El Cruce',
  'TB': 'Cima del Trueno',
  'Thunder Bluff': 'Cima del Trueno',
  'UC': 'Entrañas',
  'Undercity': 'Entrañas',
  'Stormwind': 'Ventormenta',
  'Stormwind City': 'Ciudad de Ventormenta',
  'Stormwind Harbor': 'Puerto de Ventormenta',
  'Ironforge': 'Forjaz',
  'Darnassus': 'Darnassus',
  'Orgrimmar': 'Orgrimmar',
  'The Exodar': 'El Exodar',
  'Silvermoon': 'Lunargenta',
  'Goldshire': 'Villadorada',
  'Northshire': 'Villanorte',
  'Northshire Abbey': 'Abadía de Villanorte',
  'Northshire Valley': 'Valle de Villanorte',
  'Anvilmar': 'Yunquemar',
  'Coldridge Valley': 'Valle de Crestanevada',
  'Kharanos': 'Kharanos',
  'Dolanaar': 'Dolanaar',
  'Shadowglen': 'Cañada Umbría',
  'Auberdine': 'Auberdine',
  "Rut'theran Village": "Aldea Rut'theran",
  'Menethil Harbor': 'Puerto de Menethil',
  'Thelsamar': 'Thelsamar',
  'Lakeshire': 'Villa del Lago',
  'Sentinel Hill': 'Colina del Centinela',
  'Brill': 'Rémol',
  'Deathknell': 'Camposanto',
  "Sen'jin Village": "Poblado Sen'jin",
  'Razor Hill': 'Cerrotajo',
  'Valley of Trials': 'Valle de los Retos',
  'Bloodhoof Village': 'Poblado Pezuña de Sangre',
  'Camp Narache': 'Campamento Narache',
  'The Sepulcher': 'El Sepulcro',
  'Astranaar': 'Astranaar',
  'Splintertree Post': 'Puesto del Hachazo',
  "Zoram'gar Outpost": "Avanzada de Zoram'gar",
  'Southshore': 'Costasur',
  'Tarren Mill': 'Molino Tarren',
  'Ratchet': 'Trinquete',
  'Booty Bay': 'Bahía del Botín',
  'Gadgetzan': 'Gadgetzan',
  'Sun Rock Retreat': 'Refugio Roca del Sol',
  'Dalaran': 'Dalaran',
  'Alterac Mountains': 'Montañas de Alterac',
  'Elwynn Forest': 'Bosque de Elwynn',
  'Dun Morogh': 'Dun Morogh',
  'Teldrassil': 'Teldrassil',
  'Darkshore': 'Costa Oscura',
  'Loch Modan': 'Loch Modan',
  'Westfall': 'Páramos de Poniente',
  'Redridge Mountains': 'Montañas de Crestagrana',
  'Durotar': 'Durotar',
  'Mulgore': 'Mulgore',
  'Tirisfal Glades': 'Claros de Tirisfal',
  'The Barrens': 'Los Baldíos',
  'Barrens': 'Los Baldíos',
  'Silverpine Forest': 'Bosque de Argénteos',
  'Stonetalon Mountains': 'Sierra Espolón',
  'Stonetalon': 'Sierra Espolón',
  'Ashenvale': 'Vallefresno',

  // WoW Forever Skyborne & New 4.00.07 Content
  "Zephra's Isle": 'Isla de Zephras',
  'Zephras Isle': 'Isla de Zephras',
  'Thendal Village': 'Aldea Thendal',
  "Shen'dar Village": "Aldea Shen'dar",
  'Valanaar': 'Valanaar',
  'Skyborne': 'Celestres',
  'Sky Elves': 'Elfos celestes',
  'Sky Elf': 'Elfo celeste',
  'Walk on Air': 'Caminar en el aire',
  'Skysight': 'Vista celeste',
  'Read Ley Line': 'Leer línea Ley',
  'Reagent Bag slot': 'ranura de bolsa de componentes',
  'Ruined Leather Scraps': 'Retales de cuero arruinados',
  'Apprentice\'s Skinning Satchel': 'Cartera de desollador de aprendiz',
  "Apprentice's Mining Pack": 'Mochila de minero de aprendiz',
  "Apprentice's Herb Pouch": 'Faltriquera de herborista de aprendiz',
  'Herb Baked Eggs': 'Huevos a las finas hierbas',
  'Stringy Wolf Meat': 'Carne de lobo correosa',
  'Rough Sharpening Stones': 'Piedras de afilar bastas',
  'Rough Weightstones': 'Contrapesos bastos',
  'Rough Copper Vest': 'Jubón de cobre basto',
  'Copper Chain Pants': 'Pantalones de anillas de cobre',
  'Handstitched Leather Pants': 'Pantalones de cuero cosidos a mano',
  'Copper Ore': 'Mena de cobre',
  'Copper Bars': 'Barras de cobre',
  'Copper Bar': 'Barra de cobre',
  'Light Leather': 'Cuero ligero',
  'Leather Scraps': 'Retales de cuero',
  'Lesser Magic Essence': 'Esencia mágica inferior',
  'Mote of Magic': 'Mota de magia',
  'Lesser Magic Wand': 'Varita mágica inferior',
  'Bracers - Inferior Stamina': 'Brazales - Aguante inferior',
  'Pelt Collecting for Beginners': 'Recolección de pieles para principiantes',
  'Mining for Dummies': 'Minería para novatos',
  'Find Minerals': 'Buscar minerales',
  'Mining Pick': 'Pico de minero',
  'Skinning Knife': 'Cuchillo para desollar',
  'Shadowsong Family Signet': 'Sello de la familia Cantosombrío',
  "Raani's Favourite Feather": 'Pluma favorita de Raani',
  "Chen's Empty Keg": 'Barril vacío de Chen',
  "Brill's Inn": 'Posada de Rémol',
  'Hall of Arms': 'Sala de Armas',
  'Timberline Arms': 'Armería Monte Alto',
  'Auction Hall': 'Casa de Subastas',
  'Town Hall': 'Ayuntamiento',
  'Spirit Healer': 'Ángel de la Resurrección',
  'Lunar Pendant': 'Colgante lunar',

  // Professions & Skills
  'First Aid': 'Primeros auxilios',
  'Cooking': 'Cocina',
  'Fishing': 'Pesca',
  'Herbalism': 'Herboristería',
  'Mining': 'Minería',
  'Skinning': 'Desuello',
  'Alchemy': 'Alquimia',
  'Blacksmithing': 'Herrería',
  'Enchanting': 'Encantamiento',
  'Engineering': 'Ingeniería',
  'Leatherworking': 'Peletería',
  'Tailoring': 'Sastrería',
  'Weapon Skills': 'Habilidades con armas',
  'General Supplies': 'Pertrechos generales',
  'General Supplies Vendor': 'Vendedor de pertrechos generales',
  'Trade Supplies': 'Pertrechos de comercio',
  'Summon Felsteed': 'Invocar corcel vil',
  'Wool Cloth': 'Paño de lana',
  'Linen Cloth': 'Paño de lino',
  "Weller's Arsenal": 'Armería de Weller',
  "Longberry's Reagents": 'Componentes Longberry',
  'Auction Hall': 'Casa de Subastas',
  'Mage Quarter': 'Barrio de los Magos',
  'Zeppelin tower': 'torre de zepelín',
  'zepplin tower': 'torre de zepelín',
  'Den': 'Túmulo',
  'Red Portal': 'Portal rojo',
  'crabs': 'cangrejos',
  'Webwood Spiders': 'Arañas Tejeseda',
  'Darkshore Thresher': 'Azotador de Costa Oscura',
  'Darkshore Threshers': 'Trilladores de Costa Oscura',
  'Prairie Stalkers': 'Acechadores de la pradera',
  'Sickly Gazelles': 'Gacelas enfermizas',
  'Tunnel Rat': 'Rata de túnel',
  'Durotar Tigers': 'Tigres de Durotar',
  'Kobold Vermins': 'Alimañas kóbold',
  'Poachers': 'Cazadores furtivos',
  'Geomancers': 'Geománticos',
  'Thornweavers': 'Tejedores de espinas',
  'Felstalkers': 'Acechadores viles',
  'Black Dragon Whelps': 'Crías de dragón negro',
  'Lost Barrens Kodos': 'Kodos perdidos de Los Baldíos',
  'Venomtail Scorpid': 'Escórpido Venocola',
  'Imp minion': 'Esbirro diablillo',
  'Bonfire': 'Hoguera',
  'Tribal Fire': 'Fuego tribal',
  'Shaman Shrine': 'Santuario del chamán',
  "Prospector's Picks": 'Picos de prospector',
  'Ironforge Physician': 'Médico de Forjaz',
  'Crystallized Lightning': 'Relámpago cristalizado',
  'Enchanted Gyrozephyr': 'Girocéfiro encantado',
  'Air Construct Core': 'Núcleo de ensamblaje aéreo',
  'Essential Components': 'Componentes esenciales',
  'Bloodfeather': 'Pluma Sangrienta',
  'Wailing Caverns': 'Cuevas de los Lamentos',
  'Razorfen Kraul': 'Horado Rajacieno',
  'The Deadmines': 'Las Minas de la Muerte',
  'Shadowfang Keep': 'Castillo de Colmillo Oscuro',
  'Stormwind Stockade': 'Las Mazmorras de Ventormenta',
  'Gnomeregan': 'Gnomeregan',
  'Silverpine': 'Bosque de Argénteos',
  'Quilboar': 'Jabaespines',
  'Innkeeper': 'Tabernero',
  'innkeeper': 'tabernero',

  // Roles & Masters
  'Weapon Master': 'Maestro de armas',
  'Weapons Master': 'Maestro de armas',
  'Flight Master': 'Maestro de vuelo',
  'Gryphon Master': 'Maestro de grifos',
  'Wind Rider Master': 'Maestro de jinetes del viento',
  'Hippogryph Master': 'Maestro de hipogrifos',
  'Stable Master': 'Maestro de establos',
  'Guild Master': 'Maestro de hermandad',
  'Pet Trainer': 'Instructor de mascotas',
  'Demon Trainer': 'Instructor de demonios',
  'Riding Trainer': 'Instructor de equitación',
  'First Aid Trainer': 'Instructor de primeros auxilios',
  'Cooking Trainer': 'Instructor de cocina',
  'Fishing Trainer': 'Instructor de pesca',
  'Herbalism Trainer': 'Instructor de herboristería',
  'Mining Trainer': 'Instructor de minería',
  'Skinning Trainer': 'Instructor de desuello',
  'Alchemy Trainer': 'Instructor de alquimia',
  'Blacksmithing Trainer': 'Instructor de herrería',
  'Enchanting Trainer': 'Instructor de encantamiento',
  'Engineering Trainer': 'Instructor de ingeniería',
  'Leatherworking Trainer': 'Instructor de peletería',
  'Tailoring Trainer': 'Instructor de sastrería',
  'Warrior Trainer': 'Instructor de guerreros',
  'Warrior Trainers': 'Instructores de guerreros',
  'Hunter Trainer': 'Instructor de cazadores',
  'Hunter Trainers': 'Instructores de cazadores',
  'Rogue Trainer': 'Instructor de pícaros',
  'Rogue Trainers': 'Instructores de pícaros',
  'Priest Trainer': 'Instructor de sacerdotes',
  'Priest Trainers': 'Instructores de sacerdotes',
  'Mage Trainer': 'Instructor de magos',
  'Mage Trainers': 'Instructores de magos',
  'Warlock Trainer': 'Instructor de brujos',
  'Warlock Trainers': 'Instructores de brujos',
  'Paladin Trainer': 'Instructor de paladines',
  'Paladin Trainers': 'Instructores de paladines',
  'Druid Trainer': 'Instructor de druidas',
  'Druid Trainers': 'Instructores de druidas',
  'Shaman Trainer': 'Instructor de chamanes',
  'Shaman Trainers': 'Instructores de chamanes',

  // Creatures / Objects (singular & plural)
  'raptors': 'raptores',
  'Raptors': 'Raptores',
  'plainstriders': 'zancudos de llanura',
  'Plainstriders': 'Zancudos de llanura',
  'Moonstalkers': 'Acechadores lunares',
  'moonstalkers': 'acechadores lunares',
  'cats': 'felinos',
  'Swoops': 'Aguilones',
  'swoops': 'aguilones',
  'bears': 'osos',
  'Bears': 'Osos',
  'boars': 'jabalíes',
  'Boars': 'Jabalíes',
  'spiders': 'arañas',
  'Spiders': 'Arañas',
  'wolves': 'lobos',
  'Wolves': 'Lobos',
  'bats': 'murciélagos',
  'Bats': 'Murciélagos',
  'zombies': 'zombis',
  'Zombies': 'Zombis',
  'spirits': 'espíritus',
  'Spirits': 'Espíritus',
  'darkhounds': 'canes oscuros',
  'Darkhounds': 'Canes oscuros',
  'snouts': 'hocicos',
  'seeds': 'semillas',
  'shrooms': 'champiñones',
  'pendants': 'colgantes',
  'rings': 'anillos',
  'ribs': 'costillas',
  'skulls': 'calaveras',
  'lizards': 'lagartos',
  'rats': 'ratas',
  'Deeprun Rats': 'Ratas del Tranvía Subterráneo',
  'Murloc Fins': 'Aletas de múrloc',
  'Earthroots': 'Raíces de tierra',
  'Blood Shards': 'Fragmentos de sangre',
  'Discolored Worg Hearts': 'Corazones de huargo descoloridos',
  'Laden Mushrooms': 'Champiñones cargados',
  "Miner's League Crates": 'Cajas de la Liga de Mineros',
  'Great Goretusks': 'Grandes dentosangre',
  'Tarantulas': 'Tarántulas',
  'Bristlebacks': 'Jabaespines',
  'Razormane': 'Crinafilada',
  'quilboars': 'jabaespines',
  'humans': 'humanos',
  'mobs': 'enemigos',
  'Cougars': 'Pumas',
  'Thunderlizards': 'tronadores',
  'thunderlizards': 'tronadores',
  'Crocolisks': 'crocoliscos',
  'crocolisks': 'crocoliscos',
  'Grellkins': 'grellkins',
  'Timberlings': 'arbóreos',
  'Wendigos': 'wendigos',
  'Troggs': 'troggs',
  'Murlocs': 'múrlocs',
  'murlocs': 'múrlocs',
  'Gnolls': 'gnolls',
  'gnolls': 'gnolls',
  'Kobolds': 'kóbolds',
  'kobolds': 'kóbolds',
  'harpy': 'arpía',
  'harpies': 'arpías',
  'Harpies': 'Arpías',
  'scorpids': 'escórpidos',
  'Scorpids': 'Escórpidos',
  'crawlers': 'reptadores',
  'tallstriders': 'zancudos',
  'kodos': 'kodos',
  'Kodos': 'Kodos',

  // UI/Labels/Single words
  'NOTE:': 'NOTA:',
  'NOTES:': 'NOTAS:',
  'TIP:': 'CONSEJO:',
  'TIPS:': 'CONSEJOS:',
  'WARNING:': 'ADVERTENCIA:',
  'Warning:': 'Advertencia:',
  'IMPORTANT:': 'IMPORTANTE:',
  'OPTIONAL:': 'OPCIONAL:',
  'REMINDER:': 'RECORDATORIO:',
  'SoD Rune Quest:': 'Misión de runa (SoD):',
  'NEW SoD RUNE:': 'NUEVA RUNA (SoD):',
  'Elite': 'Élite',
  'Rare Elite': 'Élite raro',
  'Got it': 'Entendido',
  'Skip This?': '¿Omitir esto?',
  'Skip This': 'Omitir esto',
  'Not at 20 yet? Skip This': '¿Aún no llegas a 20? Omite esto',
  'Not at 10 yet? Skip This': '¿Aún no llegas a 10? Omite esto',
  'Training complete': 'Entrenamiento completado',
  'Done crafting': 'Fabricación completada',
  'discovered': 'descubierto',
  'explored': 'explorado',
  'scouted': 'reconocido',
  'item': 'objeto',
  'quest': 'misión',
  'reward': 'recompensa',
  'abilities': 'facultades',
  'buff': 'beneficio',
  'key': 'llave',
  'meat': 'carne',
  'river': 'río',
  'water': 'agua',
  'yell': 'grito',
  'waypoint': 'punto de ruta',
  'vendor': 'vendedor',
  'kitchen': 'cocina',
  'rune': 'runa',
  'that': 'eso',
  'these': 'estos',
  'and': 'y',
  'from': 'de',
  'south': 'sur',
  'Moonwell': 'Poza de la Luna',
  'Clothier': 'Sastre',
  'Physician': 'Médico',
  'Bowyer': 'Arquero',
  'Cauldron': 'Caldero',
  'Highborne': 'Altonato',
  'Scarlet': 'Escarlata',
  'inn': 'posada',
  'Inn': 'Posada',
  'AH': 'Casa de Subastas',
  'Bank': 'Banco',
  'bank': 'banco',
  'Forge': 'Forja',
  'forge': 'forja',
  'Anvil': 'Yunque',
  'anvil': 'yunque',
  'Mailbox': 'Buzón',
  'mailbox': 'buzón',
  'Campfire': 'Hoguera',
  'Watchtower': 'Torre de vigía',
  'Tower': 'Torre',
  'Barracks': 'Cuartel',
  'Crypt': 'Cripta',
  'Tunnel': 'Túnel',
  'Cave': 'Cueva',
  'Mine': 'Mina',
  'Keep': 'Castillo',
  'Bunker': 'Búnker',
  'Dock': 'Muelle',
  'Harbor': 'Puerto',
  'Barrow Den': 'Túmulo',
  'Tram': 'Tranvía Subterráneo'
};

for (const [k, v] of Object.entries(GLOSSARY)) {
  registerEntity(k, v, true);
}

// Curated full-string exact dictionary if present
let CURATED_DICT = {};
if (fs.existsSync(DICT_PATH)) {
  CURATED_DICT = JSON.parse(fs.readFileSync(DICT_PATH, 'utf8'));
}

const VALID_PROPER_SAME = new Set([
  'Marion Call',
  'Orgrimmar',
  'Darnassus',
  'Dolanaar',
  'Kharanos',
  'Mulgore',
  'Durotar',
  'Teldrassil',
  'Loch Modan',
  'Arra\'chea'
]);

const EARLY_BAD_ES_RX = /(?:todoí|ello's|al así que|\bpuedes [A-ZÁÉÍÓÚ]|\btú [A-ZÁÉÍÓÚ]|\bde el\b|\ba el\b|\bJunto a tú\b|\bdebajo de tú\b|\b(?:para|a) (?:Comprueba|Espera|Ver|Consigue|Encuentra|Evita|Omitir|Hacer|Salir|Entrar|Subir|Bajar|Usa|Fabrica|Despoja|Mata|Habla|Acepta|Entrega|Toma|Sigue|Visita|Pide|Gasta|Lleva|Recoge|Abre|Cierra|Aprende|Viaja|Compra|Vende)\b|\bEn (?:Peletería|Minería|Herboristería|Herrería|Sastrería|Alquimia|Cocina|Pesca) (?:cabaña|instructor|tienda|edificio)\b|\b(?:él|ella) está En\b|\ben En\b|\bEn (?!(?:mitad|medio|busca|honor|nombre|frente)\b)[a-záéíóú]+ del\b|\bEn cima\b|\bEn pie\b|\bEn medio\b|\bUpgrade\b|\bGood\b|\bsu (?:important|posible|necesario|mejor|recomendado|fácil|difícil|seguro|peligroso|no)\b|\buna? (?!(?:Zancavientos|saltamontes|paraguas)\b)[a-záéíóúñ]+(?:as|os|es)\b|\b(?:tu|mi|su) [^\s]+(?:as|os|es)(?=\s|$|[.,!?])|\btú (?:hacer|tienes|puedes|necesitas|quieres|estás|eres|vas|ves|sabes|sal|ve|corre|nada|camina|sube|baja|entra|haz|usa|guarda|compra|vende|mata|despoja|habla|acepta|entrega|aprende|fabrica|olvides|consigue)\b|\b(?:De|En|Por|Al|Del|Con|Para|Hacia|Hasta) [A-ZÁÉÍÓÚ][a-z]+ del\b|\bsobre (?:puente|rampa|colina|lago|río)\b|\bdetrás de (?:cuartel|posada|torre|casa|cabaña|edificio|iglesia|mina)\b|\bAlrededor de (?:el|tu|su|pueblo|aldea|zona|lago|cueva|edificio|campamento|árbol)\b|\bdel (?:cueva|posada|torre|casa|cabaña|tienda|iglesia|mina|ciudad|aldea|isla|rampa|colina|montaña|zona|habitación|puerta|mesa|hoguera|forja)\b|\bla (?:cuartel|túnel|camino|sendero|puente|edificio|pueblo|campamento|lago|río|muelle|barco|tranvía|banco|árbol|piso)\b|\bel (?:cueva|posada|torre|casa|cabaña|tienda|iglesia|mina|ciudad|aldea|isla|rampa|colina|montaña|zona|habitación|puerta|mesa|hoguera|forja|hierba|mena|bolsa|piedra|madera|vara|varita)\b)/;

// Strict English word detector tuned for Spanish (declared early so HARVESTED_KV/EXACT_MAP can be filtered!)
const CHECK_EN = /(?<![\p{L}\p{N}])(the|an|and|to|of|in|for|from|with|at|by|into|onto|through|across|behind|around|above|below|under|over|between|among|until|before|after|during|while|where|when|which|who|whom|whose|what|why|how|this|that|these|those|there|here|then|than|your|you|yours|they|them|their|his|her|him|she|he|its|it|is|are|was|were|be|been|being|have|has|had|do|does|did|can|cannot|could|would|should|will|shall|may|might|must|need|want|like|know|see|look|find|give|tell|work|call|try|ask|feel|leave|put|mean|let|begin|seem|help|show|hear|play|move|live|hold|bring|sit|stand|lose|pay|meet|include|continue|set|change|lead|stop|create|allow|add|spend|grow|open|walk|win|offer|remember|appear|serve|send|expect|build|stay|fall|cut|pass|raise|report|decide|pull|return|explain|carry|break|receive|agree|support|hit|eat|cover|catch|choose|fight|throw|fill|drop|push|save|pick|wear|teach|shoot|forget|examine|worth|kill|loot|speak|talk|turn|accept|complete|get|buy|sell|purchase|use|click|head|run|go|die|res|hearth|equip|repair|resupply|resupplied|learn|skip|wait|watch|follow|enter|exit|take|make|sure|check|visit|craft|tame|taming|tamed|grind|patrol|patrols|spawn|spawns|respawn|cave|camp|village|town|inn|innkeeper|tower|gate|bridge|ramp|stairs|staircase|upstairs|downstairs|steps|path|trail|road|river|lake|water|hill|hills|mountain|mountains|cliff|ledge|house|hut|building|room|floor|wall|door|tent|spot|area|field|fields|forest|woods|island|isle|shore|beach|dock|boat|ship|zeppelin|skyship|flying|tram|flight|master|trainer|vendor|merchant|guard|guards|mobs|mob|enemy|enemies|elite|elites|quest|quests|questline|item|items|bag|bags|reagent|pouch|satchel|pack|knife|pick|weapon|weapons|armor|leather|scraps|ore|stone|stones|copper|bars|herb|herbs|herbalism|mining|skinning|cooking|fishing|alchemy|blacksmithing|enchanting|leatherworking|tailoring|first|aid|wand|bracers|essence|magic|lesser|rough|sharpening|weightstones|vest|pants|eggs|egg|meat|wolf|wolves|boar|boars|bear|bears|spider|spiders|bat|bats|raptor|raptors|plainstriders|plainstrider|swoops|cats|cat|owl|moonstalkers|zombies|zombie|spirits|darkhounds|ribs|skulls|snouts|seeds|shrooms|pendants|rings|reward|yell|yells|waypoint|waypoints|abilities|ability|spell|spells|spellbook|button|level|levels|silver|gold|money|afford|time|minutes|minute|seconds|second|timer|timed|limit|enough|plenty|almost|already|yet|soon|later|now|today|always|never|often|sometimes|usually|only|just|also|very|even|still|away|near|far|left|right|north|south|east|west|up|down|outside|inside|out|off|back|next|other|another|same|own|such|both|each|every|some|any|many|much|more|most|few|little|small|big|large|long|short|high|higher|low|lower|upper|top|bottom|side|front|middle|end|ends|done|finished|ready|available|possible|major|city|cities|important|note|notes|warning|tip|tips|reminder|tough|group|players|player|afk|dps|buff|speed|movement|regeneration|bonus|damage|additional|strong|better|best|basic|upgrade|upgrades|depending|whether|using|edged|blunt|sword|mace|staves|bows|guns|daggers|axes|polearms|crossbows|thrown|skill|skills|profession|professions|complements|collecting|collect|collected|dummies|beginners|minimap|nodes|nearby|activate|display|discovered|explored|scouted|body|cupboard|hide|float|toward|towards|mid-air|jump|keep|kept|smelt|forge|bake|baked|cook|destroy|abandon|preference|follow-ups|step|steps|skipped|unable|careful|danger|dangerous|avoid|patrolling|patroller|patrollers|leaves|stays|several|roughly|stack|stacks|helps|greatly|likely|instead|either|because|since|therefore|however|maybe|simply|immediately|safely|directly|along|past|beyond|within|without|regarding|xrs|tb|got|learned|getting|going|coming|running|walking|swimming|flying|riding|ride|killing|looting|talking|turning|accepting|completing|buying|selling|learning|training|crafting|questing|leveling|grinding|bit|but|one|two|three|four|five|desired|guide|amount|reaches|obtain|ground|following|burrow|gain|hands|refinery|food|saved|church|difficult|come|ones|harpies|harpy|escort|experience|red|junk|point|able|locations|location|circle|arrows|arrow|hard|part|future|fortress|moonwell|wise|purple|green|blue|yellow|black|white|gray|brown|route|easier|easy|basement|track|tracks|attempt|sharp|found|cooldown|haven|faster|platform|chance|summon|shortcut|recommended|lot|goal|soloable|rug|needed|mostly|chain|troggs|trogg|barn|home|worry|eventually|waterfall|won|aiming|hugging|pond|trees|satyr|bigger|extra|fence|fences|book|immediate|order|heading|smithy|window|goblin|scattered|pieces|used|anything|else|everything|something|nothing|number|perimeter|lift|tab|applied|yourself|priest|priests|mage|mages|paladin|paladins|warlock|warlocks|warrior|warriors|rogue|rogues|druid|druids|hunter|hunters|shaman|shamans|revisit|maintain|remaining|teleport|yeti|succubus|voidwalker|teleporter|glowing|zhevra|moonkin|costs|cost|ammo|darkshore|shadowglen|anvilmar|westfall|brill|crossroads)(?![\p{L}\p{N}])/giu;

function findEnglishHits(str) {
  const clean = str
    .replace(/\|c[0-9a-fA-F]{8}/g, ' ')
    .replace(/\|r/g, ' ')
    .replace(/\|T[^|]+\|t/g, ' ')
    .replace(/\|H[^|]+\|h/g, ' ')
    .replace(/\/sit\b/gi, ' ')
    .replace(/%s/g, ' ');
  const m = clean.match(CHECK_EN);
  if (!m) return [];
  const hasEsCtx = /[áéíóúñ¡¿]|\b(el|la|los|las|un|una|de|del|en|por|para|con|que|se|su|al|este|esta|estos|estas|mata|despoja|entra|sal|cabaña|campamento|zona|mascota|daño|nivel|cueva|élite|cantidad|necesaria|entrena|experiencia|beneficio|platos|comida|carne|patrulla|quijarroca)\b/i.test(clean);
  return m.filter(tok => {
    const low = tok.toLowerCase();
    // Valid Spanish words identical in spelling to English words only allowed when surrounded by Spanish context
    if (low === 'has' && /\b(has aprendido|has conseguido|has alcanzado|no has|has completado|has terminado|ya has|si has|cuando has|has perdido|has obtenido|has recogido|has recibido|has ido|has estado|has picado|has extraído|has guardado|has elegido|lo has|las has|los has|la has)\b/i.test(clean)) return false;
    if (low === 'he' && /\b(ya he|he hecho|he aprendido)\b/i.test(clean)) return false;
    if (low === 'red' && /\b(la red|una red|en red)\b/i.test(clean)) return false;
    if (low === 'bar' && /\b(el bar|del bar|al bar|en el bar)\b/i.test(clean)) return false;
    if (low === 'cat' && /\bCAT\b/.test(clean) && !/\bcat\b/.test(clean)) return false;
    if (low === 'come' && /\b(y come|come el|come la|come un|come una)\b/i.test(clean)) return false;
    if (hasEsCtx && (low === 'yeti' || low === 'raptor' || low === 'goblin' || low === 'trogg' || low === 'troggs' || low === 'extra' || low === 'decide')) return false;
    return true;
  });
}

const STRICT_BAD_RX = new RegExp([
  "puedes't",
  "'[ts](?![\\p{L}])",
  "(?<![\\p{L}])(?:Mata a a|a a|de de|en en|la la|el el|un un|una una|del del|al al)(?![\\p{L}])",
  "(?<![\\p{L}])(?:Detrás de|detrás de|Frente a|frente a|de|a|con|por|para|hacia|sobre|bajo|entre|Toma|toma|Permite|permite|Permitirá|permitirá|Enseña|enseña|Alimenta a|alimenta a|Entrena|entrena|ayudará|matará|llevará) tú(?![\\p{L}])",
  "(?<![\\p{L}])(?:A|a)lrededor de (?:En|en|pozo|granja|centro|torre|montañas|pueblo|punto|lado|el|Fuera|fuera)(?![\\p{L}])",
  "(?<![\\p{L}])(?:D|d)errota enemigos (?:cualquier|tu camino|Alrededor|alrededor|en cualquier|en bestias|más tarde)",
  "(?<![\\p{L}])(?:A|a)segúrate de (?:están|Consigue|consigue|Despoja|despoja|Mata|mata|Habla|habla|Compra|compra|Usa|usa|Visita|visita|Recoge|recoge|Toma|toma|Acepta|acepta|Entrega|entrega)(?![\\p{L}])",
  "(?<![\\p{L}])(?:I|i)ntenta (?:para|a )(?![\\p{L}])",
  "(?<![\\p{L}])(?<!Por )todo (?:A|a)lrededor(?![\\p{L}])",
  "(?<![\\p{L}])nuevo hechizos|nivel \\d+ hechizos",
  "(?<![\\p{L}])justo (?:norte|sur|este|oeste|Fuera de|fuera de:|fuera de (?:posada|casa|cripta)|Sobre|sobre|desde|Usa|usa)(?![\\p{L}])",
  "(?<![\\p{L}])(?:este|oeste|norte|sur) costa(?![\\p{L}])",
  "(?<![\\p{L}])(?:E|e)n (?:E|e)n(?![\\p{L}])",
  "esto está (?:S|s)e realiza",
  "(?<![\\p{L}])(?:C|c)entaur(?![\\p{L}])",
  "(?<![\\p{L}])en sala(?![\\p{L}])",
  "(?<![\\p{L}])para nuevo(?![\\p{L}])",
  "tu camino (?:norte|sur|este|oeste|hacia|abajo|arriba|de vuelta)",
  "a través de túnel|por rampa|árbol túnel",
  "(?<![\\p{L}])(?:No vendas|no vendas|Vende|vende|Usa|usa|Consigue|consigue|permitírtelo) los(?![\\p{L}])|de los para\\b",
  "objeto de misións",
  "más al (?:este|oeste|norte|sur) (?:cabaña|casa|torre|edificio|cueva|muelles)",
  "(?<![\\p{L}])(?:pequeño|largo|primero) (?:casa|cabaña|cueva|torre|muelles|sala)",
  "(?<![\\p{L}])él (?:patrulla|quizá|está|no está)",
  "(?<![\\p{L}])(?:M|m)ata y despoja a (?:él|ella|ello)(?![\\p{L}])",
  "[\\p{Ll},]\\s+(?:Mata|Encuentra|Compra|Vende|Toma|Habla|Usa|Espera|Evita|Omitir|Derrota|Detrás|Alrededor|En|Cuidado|Recoge|Despoja|Fabrica|Aprende|Guarda|Haz|Intenta|Asegúrate|Muere|Vuelve|Camina|Corre|Nada|Sube|Baja|Entra|Sal|Fuera|Sobre|Bajo|Recuerda|Atraviesa|Examina|Sigue|Termina|Visita|Acepta|Pide|Cruza|Junto|Dentro|Ver|Aprender|Incluyen)(?![\\p{L}])",
  "(?<![\\p{L}])arriba escaleras|arriba en montaña|si así que|tiene no |a (?:A|a)yuda el|aldea zona|árbol rama|vigía fuera para|no para vender|difícil élite|Una vez que (?:C|c)onsigue",
  "(?<![\\p{L}])nosotros (?![\\p{L}])|(?<![\\p{L}])ello (?![\\p{L}])|(?<![\\p{L}])(?<![Pp]ara )ello[.,!:]",
  "en allí|estás en,|en de\\b|muy pie de|cementerio entrada|puerta entrada|derecha lado|izquierda lado|volando Barco",
  "permitírtelo a\\b|siguiente escalones|algunos escalones|arriba el escalones|el (?:muelles|escalones|Instructores|instructores)|al (?:planta|cabaña|casa|torre|cripta|entrada|colina|sala|posada)|eso objeto|esto campamento|esto cadena|esto deberías|junto a ir|Consigue de vuelta|tiene a \\d|con a muelle|bajo a dosel|listo (?:todo|en|por)|En (?:cabaña|posada|cuartel|edificio|torre|colina|entrada|final|largo|sala)|Entra (?:a|en) (?:cuartel|posada|cabaña|edificio|sala)|arriba (?:oeste|este|norte|sur)|Sube (?:oeste|este|norte|sur)|Ábrete paso (?:norte|sur|este|oeste)"
].join('|'), 'u');

function isDirtyTranslation(v) {
  return !v || v.length < 2 || findEnglishHits(v).length > 0 || EARLY_BAD_ES_RX.test(v) || STRICT_BAD_RX.test(v);
}

const HARVESTED_KV = {};
for (const f of [
  'tools/deep_translate_all_guides.js',
  'tools/translate_0001_complete.js',
  'tools/translate_all_early_guides_deep.js',
  'tools/translate_all_guides_comprehensive.js',
  'tools/translate_gameobjects_es.js'
]) {
  if (!fs.existsSync(f)) continue;
  const txt = fs.readFileSync(f, 'utf8');
  for (const m of txt.matchAll(/(['"])((?:\\.|(?!\1).)+)\1\s*:\s*(['"])((?:\\.|(?!\3).)+)\3/g)) {
    const k = m[2].replace(/\\'/g, "'").replace(/\\"/g, '"');
    const v = m[4].replace(/\\'/g, "'").replace(/\\"/g, '"');
    if (k.length >= 2 && k !== v && !isDirtyTranslation(v)) {
      if (!HARVESTED_KV[k]) HARVESTED_KV[k] = v;
    }
  }
}

// Legacy EXACT_MAP & Unicode-safe PHRASE_RULES + CLAUSE_AND_WORD_RULES loader
const EXACT_MAP = Object.assign({}, HARVESTED_KV);
const CLEAN_PHRASE_RULES = [];
const UNICODE_PHRASE_RULES = [];
const UNICODE_CLAUSE_RULES = [];
{
  const vm = require('vm');
  const legacy = fs.readFileSync('tools/translate_early_guides_complete.js', 'utf8');
  const exStart = legacy.indexOf('const EXACT_MAP = {');
  const fnStart = legacy.indexOf('function translateText(raw)');
  const sb = { EN_TO_ES };
  vm.runInNewContext(legacy.slice(exStart, fnStart) + '\n;this._E = EXACT_MAP; this._P = PHRASE_RULES; this._C = CLAUSE_AND_WORD_RULES;', sb);
  for (const [k, v] of Object.entries(sb._E)) {
    if (!isDirtyTranslation(v)) EXACT_MAP[k] = v;
  }
  Object.assign(EXACT_MAP, CURATED_DICT);
  const fixRx = (rx) => {
    const src = rx.source
      .replace(/\\b(?=[A-Za-z(\[])/g, '(?<![\\p{L}\\p{N}])')
      .replace(/\\b/g, '(?![\\p{L}\\p{N}])');
    const flags = rx.flags.includes('u') ? rx.flags : rx.flags + 'u';
    return new RegExp(src, flags);
  };
  for (const [rx, rep] of sb._P) {
    const fixed = fixRx(rx);
    UNICODE_PHRASE_RULES.push([fixed, rep]);
    if (typeof rep === 'string' && !/\$\d/.test(rep)) {
      CLEAN_PHRASE_RULES.push([fixed, rep]);
    }
  }
  for (const [rx, rep] of sb._C) {
    UNICODE_CLAUSE_RULES.push([fixRx(rx), rep]);
  }
}

const INNER_PARENS_MAP = {
  'inn': 'Posada',
  'up path': 'subiendo por el sendero',
  'north on main path': 'al norte por el camino principal',
  'south on main path': 'al sur por el camino principal',
  'east on main path': 'al este por el camino principal',
  'west on main path': 'al oeste por el camino principal',
  'patrols': 'patrulla',
  'patrols around': 'patrulla por la zona',
  'patrols from here': 'patrulla desde aquí',
  'patrols along main path': 'patrulla por el camino principal',
  'upstairs': 'en el piso superior',
  'downstairs': 'en la planta baja',
  'up steps': 'subiendo los escalones',
  'down in cave': 'abajo en la cueva',
  'in small cave': 'en una cueva pequeña',
  'in tent': 'en la tienda',
  'top of tower': 'en lo alto de la torre',
  'sell junk': 'vende la chatarra',
  'abandon the quest': 'abandona la misión',
  'east': 'este',
  'west': 'oeste',
  'north': 'norte',
  'south': 'sur',
  'around the area here': 'por esta zona',
  'middle of furbolg camp': 'en medio del campamento fúrbolg',
  'closer to the mountains': 'más cerca de las montañas',
  'up the spiral ramp and then through the portal': 'subiendo por la rampa en espiral y luego cruzando el portal',
  'tunnel': 'túnel',
  'watchtower': 'torre de vigía',
  'up watchtower': 'subiendo a la torre de vigía',
  'in watchtower': 'en la torre de vigía',
  'in tower': 'en la torre',
  'up in tower': 'arriba en la torre',
  'for now': 'por ahora',
  'recommended': 'recomendado',
  'optional': 'opcional',
  'if you can': 'si puedes',
  'few spawns here': 'pocos enemigos aquí',
  'cats': 'felinos',
  'quilboar': 'jabaespines',
  'thunderlizards': 'tronadores',
  'kobolds': 'kóbolds',
  'chest': 'cofre',
  'barrel': 'barril',
  'apparitions': 'apariciones',
  'on ground': 'en el suelo',
  'low drop rate': 'baja probabilidad de botín',
  'red birds': 'aves rojas',
  'entrance': 'entrada',
  'dungeon': 'Mazmorra',
  'free lvl 20 warlock mount': 'montura gratuita de brujo de nivel 20',
  'purple outfit': 'atuendo morado',
  'outside': 'fuera',
  'inside': 'dentro',
  'behind': 'detrás',
  'underneath': 'debajo',
  'below': 'abajo',
  'above': 'arriba'
};

function translateInnerParens(innerRaw) {
  const inner = innerRaw.trim();
  const low = inner.toLowerCase();
  if (INNER_PARENS_MAP[low]) {
    // preserve uppercase Inn/Watchtower/Dungeon if capitalized
    if (inner === 'Inn') return 'Posada';
    if (inner === 'Watchtower') return 'Torre de vigía';
    if (inner === 'Dungeon') return 'Mazmorra';
    if (inner === 'Quilboar') return 'Jabaespines';
    return INNER_PARENS_MAP[low];
  }
  let m;
  if ((m = inner.match(/^%s\s+%s,\s*(.+)$/))) {
    const rest = translateInnerParens(m[1]);
    return rest !== m[1] ? `%s %s, ${rest}` : innerRaw;
  }
  if ((m = inner.match(/^saving\s+(\d+)\s+sec$/i))) {
    return `ahorra ${m[1]} s`;
  }
  if ((m = inner.match(/^Female,\s*dryad$/i))) {
    return 'Mujer, dríade';
  }
  const sub = translateSub(inner);
  return sub !== inner ? sub : innerRaw;
}

// Clean full-string / prefix templates (translate sub-entities recursively!)
function translateSub(s) {
  if (!s) return s;
  let t = s.trim();
  if (!t) return s;
  if (EXACT_MAP[t]) return EXACT_MAP[t];
  if (GLOSSARY[t]) return GLOSSARY[t];
  if (EN_TO_ES[t]) return EN_TO_ES[t];
  if (EN_TO_ES[t.toLowerCase()]) return EN_TO_ES[t.toLowerCase()];

  let m;
  // Possessive X's Inn / Y
  if ((m = t.match(/^(.+?)'s Inn$/i))) {
    return `Posada de ${translateSub(m[1])}`;
  }
  if ((m = t.match(/^(.+?)'s$/))) {
    const inner = translateSub(m[1]);
    return inner !== m[1] ? `de ${inner}` : t;
  }
  // N-M Zone
  if ((m = t.match(/^(\d+-\d+)\s+(.+)$/))) {
    return `${m[1]} ${translateSub(m[2])}`;
  }
  // Parenthesized suffix X (...) or X (...).
  if ((m = t.match(/^(.*?)\s*\(([^()]+)\)([.,!?]*)$/))) {
    const pre = m[1].trim();
    const inRaw = m[2].trim();
    const punct = m[3];
    const inTr = translateInnerParens(inRaw);
    const preTr = pre ? translateSub(pre) : '';
    if (inTr !== inRaw || (pre && preTr !== pre)) {
      return pre ? `${preTr} (${inTr})${punct}` : `(${inTr})${punct}`;
    }
  }
  // X and Y (only when BOTH sides translate cleanly!)
  if ((m = t.match(/^([A-Za-z][A-Za-z' -]{1,35})\s+and\s+([A-Za-z][A-Za-z' -]{1,35})([.,!?]*)$/))) {
    const a = translateSub(m[1]);
    const b = translateSub(m[2]);
    if (a !== m[1] && b !== m[2]) return `${a} y ${b}${m[3]}`;
  }
  if (t === '%s') return '%s';
  // Plural s fallback into EN_TO_ES
  if (t.length > 4 && t.endsWith('s') && EN_TO_ES[t.slice(0, -1).toLowerCase()]) {
    return EN_TO_ES[t.slice(0, -1).toLowerCase()];
  }
  return t;
}

const BUILDING_MAP = {
  'room': 'la habitación',
  'inn': 'la posada',
  'ah': 'la Casa de Subastas',
  'bank': 'el banco',
  'house': 'la casa',
  'tunnel': 'el túnel',
  'door': 'la puerta',
  'crypt': 'la cripta',
  'tower': 'la torre',
  'mine': 'la mina',
  'hut': 'la cabaña',
  'church': 'la iglesia',
  'cave': 'la cueva',
  'the cave...': 'la cueva...',
  'building': 'el edificio',
  'town hall': 'el Ayuntamiento',
  'watchtower': 'la torre de vigía',
  'tree tower': 'la torre del árbol',
  'den': 'el túmulo',
  'mage quarter': 'el Barrio de los Magos',
  'merchant building': 'el edificio de mercaderes',
  'barracks': 'el cuartel',
  'barracks...': 'el cuartel...',
  'hall of arms': 'la Sala de Armas',
  'zeppelin tower': 'la torre de zepelín',
  'red portal': 'el Portal rojo',
  'mountain ramp': 'la rampa de montaña'
};

function translatePlace(p) {
  const clean = p.trim();
  const low = clean.toLowerCase();
  if (BUILDING_MAP[low]) return BUILDING_MAP[low];
  const sub = translateSub(clean);
  if (sub !== clean) return sub;
  return clean;
}

function stripArtEs(x) {
  return x.replace(/^(el |la |los |las )/i, '');
}

const TEMPLATE_RULES = [
  [/^Exit:\s*(.+)$/i, (_, a) => `Salir: ${translateSub(a)}`],
  [/^Enter:\s*(.+)$/i, (_, a) => `Entrar: ${translateSub(a)}`],
  [/^Go through:\s*(.+)$/i, (_, a) => `Cruzar: ${translateSub(a)}`],
  [/^Around:\s*(.+)$/i, (_, a) => `Alrededor de: ${translateSub(a)}`],
  [/^Go back to:\s*(.+)$/i, (_, a) => `Regresar a: ${translateSub(a)}`],
  [/^Head to:\s*(.+)$/i, (_, a) => `Dirigirse a: ${translateSub(a)}`],
  [/^Kill\/loot:\s*(.+)$/i, (_, a) => `Matar y despojar: ${translateSub(a)}`],
  [/^Loot:\s*(.+)$/i, (_, a) => `Despojar: ${translateSub(a)}`],
  [/^Click:\s*(.+)$/i, (_, a) => `Haz clic en: ${translateSub(a)}`],
  [/^Take [Bb]oat to:\s*(.+)$/, (_, a) => `Toma el barco hacia: ${translateSub(a)}`],
  [/^Follow waypoint to exit\s+(.+)$/i, (_, a) => `Sigue el punto de ruta para salir de ${stripArtEs(translatePlace(a))}`],
  [/^Follow waypoint through:\s*(.+)$/i, (_, a) => `Sigue el punto de ruta por: ${translateSub(a)}`],
  [/^Follow main path through\s+(.+)$/i, (_, a) => `Sigue el camino principal por ${translateSub(a)}`],
  [/^Go up into:\s*(.+)$/i, (_, a) => `Sube hacia: ${translateSub(a)}`],
  [/^Go down to:\s*(.+)$/i, (_, a) => `Baja hacia: ${translateSub(a)}`],
  [/^Exit\s+([^:]+)$/i, (all, a) => {
    if (/\b(?:and|or|then|to|through)\b/i.test(a)) return null;
    const p = translatePlace(a);
    return p !== a.trim() ? `Sal de ${p}`.replace(/^Sal de el /, 'Sal del ') : null;
  }],
  [/^Leave\s+([^:]+)$/i, (_, a) => {
    if (/\b(?:and|or|then|to|through)\b/i.test(a)) return null;
    const p = translatePlace(a);
    return p !== a.trim() ? `Sal de ${p}`.replace(/^Sal de el /, 'Sal del ') : null;
  }],
  [/^Enter\s+([^:]+)$/i, (_, a) => {
    if (/\b(?:and|or|then|to|through)\b/i.test(a)) return null;
    const p = translatePlace(a);
    return p !== a.trim() ? `Entra en ${p}` : null;
  }],
  [/^Go through\s+(.+?)\s*\(tunnel\)$/i, (_, a) => `Cruza ${translateSub(a)} (túnel)`],
  [/^Go through\s+(.+)$/i, (_, a) => {
    if (/\b(?:and|or|then|over|into)\b/i.test(a)) return null;
    const p = translatePlace(a);
    return p !== a.trim() ? `Atraviesa ${p}` : null;
  }],
  [/^Go up in\s+(.+)$/i, (_, a) => {
    const p = translatePlace(a);
    return p !== a.trim() ? `Sube en ${p}` : null;
  }],
  [/^Go down in\s+(.+)$/i, (_, a) => {
    const p = translatePlace(a);
    return p !== a.trim() ? `Baja en ${p}` : null;
  }],
  [/^Go up\s+(.+)$/i, (_, a) => {
    const p = translatePlace(a);
    return p !== a.trim() ? `Sube a ${p}`.replace(/^Sube a el /, 'Sube al ') : null;
  }],
  [/^Go to\s+(\d+-\d+\s+.+)$/i, (_, a) => `Ir a ${translateSub(a)}`],
  [/^(?:Go|Head|Run)\s+(N|NE|NW|S|SE|SW|E|W|north|south|east|west|northeast|northwest|southeast|southwest)\s+(to|in|into|through)\s*(.*)$/i, (all, d, prep, rest) => {
    const dirMap = {
      n: 'al norte', s: 'al sur', e: 'al este', w: 'al oeste',
      north: 'al norte', south: 'al sur', east: 'al este', west: 'al oeste',
      ne: 'al NE', nw: 'al NO', se: 'al SE', sw: 'al SO',
      northeast: 'al noreste', northwest: 'al noroeste', southeast: 'al sureste', southwest: 'al suroeste'
    };
    const verb = /^head/i.test(all) ? 'Dirígete' : /^run/i.test(all) ? 'Corre' : 'Ve';
    const esDir = dirMap[d.toLowerCase()];
    const pLow = prep.toLowerCase();
    const esPrep = pLow === 'in' ? 'en' : pLow === 'through' ? 'por' : pLow === 'into' ? 'hacia el interior de' : 'hacia';
    const r = rest.trim();
    if (!r) return `${verb} ${esDir} ${esPrep}`;
    const tr = translatePlace(r);
    if (tr !== r || r === '%s') return `${verb} ${esDir} ${esPrep} ${tr}`.replace(/\bhacia el\b/, 'al').replace(/\ben el\b/, 'en el');
    return null;
  }],
  [/^(Inside|Just inside|Outside|Just outside|Upstairs in|Down in|East in|West in|North in|South in)\s*(.*?)$/i, (_, k, rest) => {
    const kMap = {
      'inside': 'Dentro de', 'just inside': 'Justo dentro de',
      'outside': 'Fuera de', 'just outside': 'Justo fuera de',
      'upstairs in': 'En el piso superior de', 'down in': 'Abajo en',
      'east in': 'Al este en', 'west in': 'Al oeste en',
      'north in': 'Al norte en', 'south in': 'Al sur en'
    };
    const prefix = kMap[k.toLowerCase()];
    const r = rest.trim();
    if (!r) return prefix;
    const tr = translatePlace(r);
    return tr !== r ? `${prefix} ${tr}` : null;
  }],
  [/^Kill\/loot\s+([^%].+?)\.?$/i, (all, a) => {
    const t = translateSub(a);
    return (t !== a || a === '%s') ? `Mata y despoja ${t}${all.endsWith('.') ? '.' : ''}` : null;
  }],
  [/^(Kill|Destroy|Loot|Click|Use)(?:\s+the)?\s*$/i, (all, v) => {
    const vm = { kill: 'Mata a', destroy: 'Destruye', loot: 'Despoja', click: 'Haz clic en', use: 'Usa' };
    return vm[v.toLowerCase()];
  }],
  [/^Escort\s*$/i, () => 'Escolta a'],
  [/^(.+)\s+entrance:?$/i, (all, a) => {
    const clean = a.trim();
    const p = translatePlace(clean);
    return (p !== clean || clean === '%s') ? `Entrada de ${p}`.replace(/^Entrada de el /, 'Entrada del ') + (all.endsWith(':') ? ':' : '') : null;
  }],
  [/^(.+)\s+exit$/i, (_, a) => {
    const clean = a.trim();
    const p = translatePlace(clean);
    return (p !== clean || clean === '%s') ? `Salida de ${p}`.replace(/^Salida de el /, 'Salida del ') : null;
  }],
  [/^Train\s+(.+?)\.?$/i, (all, a) => {
    const t = translateSub(a);
    return t !== a ? `Aprende ${t}${all.endsWith('.') ? '.' : ''}` : null;
  }],
  [/^Collect\s+(\d+)\s+(.+?)\.?$/i, (all, n, a) => {
    const t = translateSub(a);
    return t !== a ? `Reúne ${n} de ${t}${all.endsWith('.') ? '.' : ''}` : null;
  }],
  [/^Level\s+([A-Za-z]+)\s+to\s+(\d+)$/i, (_, p, n) => `Sube ${translateSub(p)} a ${n}`],
  [/^Reach\s+([A-Za-z]+)\s+skill\s+(\d+)$/i, (_, p, n) => `Alcanza nivel ${n} en ${translateSub(p)}`],
  [/^skill\s+(\d+)\s+for\s*$/i, (_, n) => `nivel ${n} para`],
  [/^Visit the Innkeeper at\s+(.+)$/i, (_, a) => `Visita al tabernero en ${translateSub(a)}`],
  [/^Take the zeppelin to\s+(.+?)\.?$/i, (all, a) => `Toma el zepelín hacia ${translateSub(a)}${all.endsWith('.') ? '.' : ''}`],
  [/^Zeppelin to\s+(.+)$/i, (_, a) => `Zepelín hacia ${translateSub(a)}`],
  [/^Flying boat to\s+(.+)$/i, (_, a) => `Barco volador hacia ${translateSub(a)}`],
  [/^Exit UC through the\s+(.+)$/i, (_, a) => `Sal de Entrañas por: ${translateSub(a)}`],
  [/^Take any of the lifts up and out of the\s+(.+)$/i, (_, a) => `Toma cualquiera de los elevadores para subir y salir de ${translateSub(a)}`],
  [/^Use\s+(.+)$/, (all, a) => {
    const t = translateSub(a);
    return t !== a ? `Usa ${t}` : null;
  }],
];

// Clean structural exact fragments (preserving leading/trailing spaces!)
const EXACT_FRAGMENTS = Object.assign({}, GLOSSARY, {
  'Follow waypoint': 'Sigue el punto de ruta',
  'Around the area': 'Por la zona',
  'Go across bridge': 'Cruza el puente',
  'Go over bridge': 'Cruza el puente',
  'Get on bridge': 'Sube al puente',
  'Go up ramp': 'Sube por la rampa',
  'Go up the ramp': 'Sube por la rampa',
  'Go upstairs': 'Sube al piso superior',
  'Go upstairs in Inn': 'Sube al piso superior de la posada',
  'upstairs in the Inn.': 'arriba en la posada.',
  'Go up spiral ramp': 'Sube por la rampa en espiral',
  'Go up spiral ramp (in hut)': 'Sube por la rampa en espiral (en la cabaña)',
  'Go up spiral ramp in tower': 'Sube por la rampa en espiral de la torre',
  'Go up steps': 'Sube las escaleras',
  'Up steps': 'Subiendo las escaleras',
  'Go up mountain ramp': 'Sube por la rampa de la montaña',
  'Go up ramp in tower': 'Sube por la rampa de la torre',
  'Go through portal (UP ramp)': 'Cruza el portal (subiendo la rampa)',
  'Through small alley': 'Por el callejón pequeño',
  'Go up hill (hidden path)': 'Sube la colina (sendero oculto)',
  'Down in building': 'Abajo en el edificio',
  'In the merchant building:': 'En el edificio de mercaderes:',
  'Go down further': 'Baja un poco más',
  'Go back up': 'Vuelve a subir',
  'Drop down': 'Déjate caer abajo',
  'Drop down here': 'Déjate caer aquí',
  'Follow waypoint upwards': 'Sigue el punto de ruta hacia arriba',
  'Follow upper path': 'Sigue el sendero superior',
  'Take upper path': 'Toma el sendero superior',
  'Around the farm': 'Alrededor de la granja',
  'Get on northern boat': 'Sube al barco del norte',
  'Get resupplied': 'Reabastécete',
  'Get repaired / resupplied': 'Repara y reabastécete',
  'Get repaired/resupplied': 'Repara y reabastécete',
  'Get repaired?': '¿Reparar armadura?',
  'Next to you:': 'Junto a ti:',
  'Next to the': 'Junto a',
  'In front of the': 'Frente a',
  'Under the red canopy:': 'Bajo el toldo rojo:',
  'Up the watchtower:': 'Subiendo la torre de vigía:',
  'Go up the watchtower next to you:': 'Sube a la torre de vigía junto a ti:',
  'Around the open fields:': 'Por los campos abiertos:',
  'around the open fields:': 'por los campos abiertos:',
  'SKIP': 'OMITIR',
  'At': 'En',
  'At the': 'En',
  'In': 'En',
  'in': 'en',
  'in the': 'en',
  'from the': 'de',
  'From the': 'De',
  'From': 'De',
  'from': 'de',
  ', from': ', de',
  ', from the': ', de',
  'From the other': 'Del otro',
  'for the': 'para',
  'and': 'y',
  'and kill': 'y mata a',
  'and from the': 'y de',
  'and you will see two': 'y verás dos',
  'to': 'a',
  'to get to': 'para llegar a',
  'to enter': 'para entrar en',
  'to obtain': 'para obtener',
  'to a vendor!': '¡a un vendedor!',
  'the': 'el',
  'The': 'El',
  'around': 'alrededor de',
  'Around': 'Alrededor de',
  'Up in': 'Arriba en',
  'East in': 'Al este en',
  'South in': 'Al sur en',
  'Back at': 'De vuelta en',
  'Back at the': 'De vuelta en',
  'Once at': 'Una vez en',
  'As you enter': 'Al entrar en',
  'Just outside of': 'Justo fuera de',
  'Just outside of the Inn at the': 'Justo fuera de la posada, junto a',
  'Just inside of': 'Justo dentro de',
  'Before leaving': 'Antes de salir de',
  'Enter': 'Entra en',
  'Exit': 'Sal de',
  'Go to': 'Ve a',
  'Go to the': 'Ve a',
  'Go north to enter': 'Ve al norte para entrar en',
  'Follow the path north to enter': 'Sigue el sendero al norte para entrar en',
  'Go up to enter': 'Sube para entrar en',
  'Head to': 'Dirígete a',
  'Head back to': 'Regresa a',
  'Go back to': 'Regresa a',
  'Hearth to': 'Usa piedra de hogar hacia',
  'Hearth back to': 'Usa piedra de hogar de vuelta a',
  'Hearth (if you can) to': 'Usa piedra de hogar (si puedes) hacia',
  'Hearth to the starting spot.': 'Usa piedra de hogar al punto inicial.',
  'Die on purpose around here': 'Muere a propósito por aquí',
  'Die on purpose and res at spirit.': 'Muere a propósito y revive en el ángel.',
  'Die on purpose and res at spirit to get to': 'Muere a propósito y revive en el ángel para llegar a',
  'Res at': 'Revive en',
  'Kill/loot': 'Mata y despoja',
  'Kill/loot the': 'Mata y despoja a',
  'Finish kill/looting': 'Termina de matar y despojar',
  'Kill the required amount of': 'Mata la cantidad necesaria de',
  ', kill the required amount of': ', mata la cantidad necesaria de',
  ', kill the': ', mata a',
  'Loot': 'Despoja',
  'Learn': 'Aprende',
  'Use your': 'Usa tu',
  'Make sure you learn': 'Asegúrate de aprender',
  'Accept your class quest:': 'Acepta tu misión de clase:',
  'received, accept:': 'recibida, acepta:',
  'Purchase a stack or two of:': 'Compra un montón o dos de:',
  'Purchase at least 4 stacks of:': 'Compra al menos 4 montones de:',
  'You would need': 'Necesitarías',
  'Also in this room, from the other': 'También en esta sala, con el otro',
  'Next to you, from the': 'Junto a ti, con',
  'From any vendor in the town:': 'Con cualquier vendedor del pueblo:',
  'side of the': 'lado de',
  'is upstairs.': 'está en el piso superior.',
  'is at': 'está en',
  'is back there too.': 'también está allí detrás.',
  'inside the mine.': 'dentro de la mina.',
  'right now.': 'ahora mismo.',
  'quicker.': 'más rápido.',
  'faster.': 'más rápido.',
  'sooner.': 'antes.',
  'found:': 'encontrado:',
  ', upgrade': ', mejora',
  'to find the': 'para encontrar',
  'is complete!': '¡está completada!',
  'I already did these!': '¡Ya hice esto!',
  'Skip This For Now?': '¿Omitir esto por ahora?',
  'Toolbox here': 'Caja de herramientas aquí',
  'Elites patrols around!': '¡Hay élites patrullando por la zona!',
  'No waypoints available in this area!': '¡No hay puntos de ruta disponibles en esta zona!',
  'You have learned everything possible from this NPC.  Other major cities could offer other weapon possibilities to learn.': 'Ya has aprendido todo lo posible de este instructor. En otras ciudades principales podrás aprender otras habilidades de armas.',
  'that you can learn new weapon possibilities if you can afford to.': 'con quien puedes aprender nuevas habilidades de armas si te lo puedes permitir.',
  'Costs roughly 10 silver each.': 'Cuesta aproximadamente 10 de plata cada uno.',
  'you can learn the following:': 'puedes aprender lo siguiente:',
  'You now have a new Rune spell': 'Ahora tienes un nuevo hechizo de runa',
  'You have successfully learned': 'Has aprendido correctamente',
  'You can get repaired in the big hut': 'Puedes reparar en la gran cabaña',
  ', along with other profession trainers there.': ', junto con otros instructores de profesión allí.',
  ', learn': ', aprende',
  ', go to': ', ve a',
  ', get your new spells/abilities.': ', aprende tus nuevos hechizos y facultades.',
  'him:': 'él:',
  '(for now)': '(por ahora)',
  '(for now).': '(por ahora).',
  '(he patrols around': '(patrulla alrededor de',
  '(he patrols around town from': '(patrulla por el pueblo desde',
  ', see patrol path)': ', mira la ruta de patrulla)',
  '(He patrols around the city, see map)': '(Patrulla por la ciudad, mira el mapa)',
  'to continue questing.  Follow directions to get there.': 'para seguir haciendo misiones. Sigue las indicaciones para llegar allí.',
  'It is now time to travel to': 'Es hora de viajar hacia',
  'At the bottom part of the Inn, go to the': 'En la planta baja de la posada, ve con',
  ', loot it and from the': ', despójalo y de',
  'In the Inn:': 'En la posada:',
  'in the open fields of': 'en los campos abiertos de',
  'Grind on any mobs around': 'Mata enemigos alrededor de',
  'Stop at the vendor to get repaired / resupplied.': 'Pasa por el vendedor para reparar y reabastecerte.',
  'Keep going to top of tower': 'Sigue subiendo hasta la cima de la torre',
  'Wait for the tram ride to show up and take it to': 'Espera a que llegue el tranvía y tómalo hacia',
  'Turning this in will give you': 'Al entregar esto recibirás',
  'Keep right in the cave...': 'Mantente a la derecha en la cueva...',
  'spell to take you to': 'hechizo para llevarte a',
  'quest item on a': 'objeto de misión en un',
  'quest item.': 'objeto de misión.',
  'Now use the': 'Ahora usa',
  'find': 'encuentra',
  'if you see': 'si ves a',
  'since you are close.': 'ya que estás cerca.',
  'Might as well just go back to': 'Aprovecha para volver a',
  'Back in the Razormane camp is a barrel called': 'De vuelta en el campamento Crinafilada hay un barril llamado',
  '(this is accepted between the two Tram tracks).': '(se acepta entre las dos vías del tranvía).',
  'Just around the immediate area use the quest item on the': 'Por la zona inmediata usa el objeto de misión en',
  'Go back between the two tracks at the': 'Regresa entre las dos vías con',
  'Done around the western open fields of': 'Se realiza por los campos abiertos del oeste de',
  'Next to you in the Barracks:': 'Junto a ti en el cuartel:',
  'Exit Barracks...': 'Sal del cuartel...',
  'You can find another': 'Puedes encontrar otro',
  'NE by the tower at': 'al NE junto a la torre en',
  ', go in the house in front of you to the second floor:': ', entra en la casa frente a ti y sube a la segunda planta:',
  'If you need to, you can get repaired outside of the Barracks, at': 'Si lo necesitas, puedes reparar tu equipo fuera del cuartel, en',
  "has a 5 min time limit.  As long as you do not go AFK or something you should have plenty of time to get this in.": "tiene un límite de 5 minutos. Mientras no te quedes ausente ni te entretengas, tendrás tiempo de sobra para entregarla."
});

function translateString(raw) {
  if (!raw || !raw.trim()) return raw;
  const lead = raw.match(/^\s*/)[0];
  const trail = raw.match(/\s*$/)[0];
  let core = raw.trim();

  if (EXACT_MAP[raw] !== undefined) return EXACT_MAP[raw];
  if (EXACT_MAP[core] !== undefined) return lead + EXACT_MAP[core] + trail;
  // Note: for HARVESTED_KV trailing/leading space accuracy, check lowercase raw only if exact match fails
  if (EXACT_FRAGMENTS[core] !== undefined) return lead + EXACT_FRAGMENTS[core] + trail;
  if (EN_TO_ES[core]) return lead + EN_TO_ES[core] + trail;
  if (EN_TO_ES[core.toLowerCase()]) return lead + EN_TO_ES[core.toLowerCase()] + trail;

  for (const [k, v] of Object.entries(EXACT_FRAGMENTS)) {
    if (core.toLowerCase() === k.toLowerCase()) return lead + v + trail;
  }

  // Handle ", get/learn your level N spells/abilities..."
  let m;
  if ((m = core.match(/^,\s*(?:get|learn)\s+(?:your\s+)?level\s+(\d+)\s+spells\/abilities\.(\s+The)?$/i))) {
    return lead + `, aprende tus hechizos y facultades de nivel ${m[1]}.${m[2] ? ' En' : ''}` + trail;
  }
  if ((m = core.match(/^Get your level\s+(\d+)\s+spells\/abilities at$/i))) {
    return lead + `Aprende tus hechizos y facultades de nivel ${m[1]} con` + trail;
  }
  if ((m = core.match(/^,\s*get new spells\/abilities at$/i))) {
    return lead + `, aprende nuevos hechizos y facultades con` + trail;
  }

  // Handle trailing punctuation exact DB hit e.g. "Stormwind." -> "Ventormenta."
  const pm = core.match(/^(.+?)([.:!?]+)$/);
  if (pm) {
    const base = pm[1].trim();
    const punct = pm[2];
    if (EXACT_MAP[base]) return lead + EXACT_MAP[base] + punct + trail;
    if (EXACT_FRAGMENTS[base]) return lead + EXACT_FRAGMENTS[base] + punct + trail;
    if (EN_TO_ES[base]) return lead + EN_TO_ES[base] + punct + trail;
    if (EN_TO_ES[base.toLowerCase()]) return lead + EN_TO_ES[base.toLowerCase()] + punct + trail;
  }

  // Try structural templates
  for (const [rx, fn] of TEMPLATE_RULES) {
    const m2 = core.match(rx);
    if (m2) {
      const res = fn(...m2);
      if (res) return lead + res + trail;
    }
  }

  // Try clean non-leaking PHRASE_RULES if exact/anchored full match changes string cleanly
  let phTmp = core;
  for (const [rx, rep] of CLEAN_PHRASE_RULES) {
    phTmp = phTmp.replace(rx, rep);
  }
  phTmp = postProcessSpanishGrammar(phTmp);
  if (phTmp !== core && !isDirtyTranslation(phTmp)) {
    return lead + phTmp + trail;
  }

  // Try translateSub (for "(up path)", "X's Inn", plural entities, "X and Y")
  const sub = translateSub(core);
  if (sub !== core && !isDirtyTranslation(sub)) return lead + sub + trail;

  // Layer 4: Token-sealed multi-word entity translation + Unicode PHRASE_RULES & CLAUSE_AND_WORD_RULES + Spanish post-processing
  const layer4 = sealAndTranslate(sub !== core ? sub : core);
  if (layer4 && layer4 !== core) return lead + layer4 + trail;

  return raw;
}

function lookupSealEntity(phrase) {
  const low = phrase.toLowerCase();
  if (EN_TO_ES[phrase] && EN_TO_ES[phrase].toLowerCase() !== low) return EN_TO_ES[phrase];
  if (EN_TO_ES[low] && EN_TO_ES[low].toLowerCase() !== low) return EN_TO_ES[low];
  if (low.endsWith('s') && low.length > 4) {
    const sing = low.slice(0, -1);
    if (EN_TO_ES[sing] && EN_TO_ES[sing].toLowerCase() !== sing) return EN_TO_ES[sing];
    if (low.endsWith('es') && low.length > 5) {
      const singEs = low.slice(0, -2);
      if (EN_TO_ES[singEs] && EN_TO_ES[singEs].toLowerCase() !== singEs) return EN_TO_ES[singEs];
    }
  }
  return null;
}

const EXTRA_CLEAN_WORD_RULES = [
  [/\bFirst Aid\b/gi, 'Primeros auxilios'],
  [/\bFlight Master\b/gi, 'Maestro de vuelo'],
  [/\bWind Rider Master\b/gi, 'Maestro de jinetes del viento'],
  [/\bBat Handler\b/gi, 'Cuidador de murciélagos'],
  [/\bWands Merchant\b/gi, 'Mercader de varitas'],
  [/\bMeat Vendor\b/gi, 'Vendedor de carne'],
  [/\bMote of Magic\b/gi, 'Mota de magia'],
  [/\bLesser Magic Essence\b/gi, 'Esencia de magia inferior'],
  [/\bRough Sharpening Stones?\b/gi, 'Piedras de afilar bastas'],
  [/\bRough Weightstones?\b/gi, 'Contrapesos bastos'],
  [/\bSharpening Wheels?\b/gi, 'Ruedas de afilar'],
  [/\bDarnassus\b/gi, 'Darnassus'],
  [/\bOrgrimmar entrance\b/gi, 'Entrada de Orgrimmar'],
  [/\bdeep water\b/gi, 'aguas profundas'],
  [/\bsell junk\b/gi, 'vende la chatarra'],
  [/\babandon the quest\b/gi, 'abandona la misión'],
  [/\bup steps\b/gi, 'subiendo los escalones'],
  [/\bdown in cave\b/gi, 'abajo en la cueva'],
  [/\bin small cave\b/gi, 'en una cueva pequeña'],
  [/\bin tent\b/gi, 'en la tienda'],
  [/\btop of tower\b/gi, 'en lo alto de la torre'],
  [/\bclose to\b/gi, 'cerca de'],
  [/\bcloser to\b/gi, 'más cerca de'],
  [/\bright side\b/gi, 'lado derecho'],
  [/\bleft side\b/gi, 'lado izquierdo'],
  [/\bwest side\b/gi, 'lado oeste'],
  [/\beast side\b/gi, 'lado este'],
  [/\bnorth side\b/gi, 'lado norte'],
  [/\bsouth side\b/gi, 'lado sur'],
  [/\bin the middle of\b/gi, 'en medio de'],
  [/\bat the middle of\b/gi, 'en medio de'],
  [/\bin middle of\b/gi, 'en medio de'],
  [/\bmiddle of\b/gi, 'centro de'],
  [/\bjust past\b/gi, 'justo después de'],
  [/\bwalk off\b/gi, 'salta desde'],
  [/\bdrop down off\b/gi, 'déjate caer desde'],
  [/\bmove(?:s)? out of the way\b/gi, 'se aparte del camino'],
  [/\bspeed up\b/gi, 'acelerar'],
  [/\bseveral minutes at a time\b/gi, 'varios minutos seguidos'],
  [/\bseveral minutes\b/gi, 'varios minutos'],
  [/\ba stack\b/gi, 'una acumulación'],
  [/\bmining nodes\b/gi, 'filones de minería'],
  [/\bdisplay nearby\b/gi, 'mostrar cercanos'],
  [/\bnearby\b/gi, 'cercanos'],
  [/\bpurple eggs\b/gi, 'huevos morados'],
  [/\bhigh level\b/gi, 'nivel alto'],
  [/\bthe Tram\b/gi, 'el Tranvía Subterráneo'],
  [/\bTram\b/gi, 'tranvía'],
  [/\bZeppelin\b/gi, 'zepelín'],
  [/\braptors\b/gi, 'raptores'],
  [/\braptor\b/gi, 'raptor'],
  [/\bboars\b/gi, 'jabalíes'],
  [/\bboar\b/gi, 'jabalí'],
  [/\bbears\b/gi, 'osos'],
  [/\bbear\b/gi, 'oso'],
  [/\bspiders\b/gi, 'arañas'],
  [/\bspider\b/gi, 'araña'],
  [/\beggs\b/gi, 'huevos'],
  [/\begg\b/gi, 'huevo'],
  [/\bmeat\b/gi, 'carne'],
  [/\bpants\b/gi, 'pantalones'],
  [/\bpouch\b/gi, 'faltriquera'],
  [/\bpack\b/gi, 'mochila'],
  [/\bmerchant\b/gi, 'mercader'],
  [/\bplayers\b/gi, 'jugadores'],
  [/\bplayer\b/gi, 'jugador'],
  [/\benemies\b/gi, 'enemigos'],
  [/\benemy\b/gi, 'enemigo'],
  [/\belites\b/gi, 'élites'],
  [/\belite\b/gi, 'élite'],
  [/\bpatrolling\b/gi, 'patrullando'],
  [/\bspawns\b/gi, 'apariciones'],
  [/\bspawn\b/gi, 'aparición'],
  [/\bgrinding\b/gi, 'farmear'],
  [/\bleveling\b/gi, 'subir de nivel'],
  [/\btraining\b/gi, 'entrenamiento'],
  [/\bskipped\b/gi, 'omitido'],
  [/\bcomplete\b/gi, 'completar'],
  [/\bsmelt\b/gi, 'funde'],
  [/\busing\b/gi, 'usando'],
  [/\bminutes\b/gi, 'minutos'],
  [/\bminute\b/gi, 'minuto'],
  [/\bflight\b/gi, 'vuelo'],
  [/\bflying\b/gi, 'volando'],
  [/\bshore\b/gi, 'costa'],
  [/\bisle\b/gi, 'isla'],
  [/\bside\b/gi, 'lado'],
  [/\bbuff\b/gi, 'beneficio'],
  [/\bcook\b/gi, 'cocina'],
  [/\bhide\b/gi, 'pellejo'],
  [/\bnodes\b/gi, 'nodos'],
  [/\bdamage\b/gi, 'daño'],
  [/\bhigh\b/gi, 'alto'],
  [/\bspeed\b/gi, 'velocidad'],
  [/\blong\b/gi, 'largo'],
  [/\bpossible\b/gi, 'posible'],
  [/\btop\b/gi, 'cima'],
  [/\bgot\b/gi, 'obtuviste'],
  [/\bdirectly\b/gi, 'directamente'],
  [/\bsimply\b/gi, 'simplemente'],
  [/\btoward(?:s)?\b/gi, 'hacia'],
  [/\bpast\b/gi, 'pasando'],
  [/\boff\b/gi, 'desde'],
  [/\bout\b/gi, 'fuera'],
  [/\bby\b/gi, 'junto a']
].map(([rx, rep]) => {
  const src = rx.source.replace(/\\b(?=[A-Za-z(\[])/g, '(?<![\\p{L}\\p{N}])').replace(/\\b/g, '(?![\\p{L}\\p{N}])');
  return [new RegExp(src, 'giu'), rep];
});

function postProcessSpanishGrammar(s) {
  return s
    .replace(/\bde el\b/gi, 'del')
    .replace(/\ba el\b/gi, 'al')
    .replace(/\bJunto a tú\b/gi, 'Junto a ti')
    .replace(/\bdebajo de tú\b/gi, 'debajo de ti')
    .replace(/\bNo Vende\b/gi, 'No vendas')
    .replace(/\ba aprende\b/gi, 'para aprender')
    .replace(/\bhasta estás\b/gi, 'hasta estarlo')
    .replace(/\bhasta tú lograr\b/gi, 'hasta lograr')
    .replace(/\ben todoí\b/gi, 'allí')
    .replace(/\btodoí\b/gi, 'allí')
    .replace(/\bello's\b/gi, 'su')
    .replace(/\bal así que\b/gi, 'por lo que')
    .replace(/\ba través de el\b/gi, 'a través del')
    .replace(/\bsi él no está\b/gi, 'si no está')
    .replace(/\bpuedes Compra\b/g, 'puedes comprar')
    .replace(/\bpuedes Habla\b/g, 'puedes hablar')
    .replace(/\bpuedes Espera\b/g, 'puedes esperar')
    .replace(/\bpuedes Fabrica\b/g, 'puedes fabricar')
    .replace(/\bpuedes Despoja\b/g, 'puedes despojar')
    .replace(/\bpuedes Mata\b/g, 'puedes matar')
    .replace(/\bpuedes Usar\b/g, 'puedes usar')
    .replace(/\bpuedes Acepta\b/g, 'puedes aceptar')
    .replace(/\bpuedes Entrega\b/g, 'puedes entregar')
    .replace(/\bpara ([A-ZÁÉÍÓÚÑ])/g, (_, c) => 'para ' + c.toLowerCase())
    .replace(/([\p{Ll},:;]\s+)(Mata|Encuentra|Compra|Vende|Toma|Habla|Usa|Espera|Evita|Omitir|Derrota|Detrás|Alrededor|En|Cuidado|Recoge|Despoja|Fabrica|Aprende|Guarda|Haz|Intenta|Asegúrate|Muere|Vuelve|Camina|Corre|Nada|Sube|Baja|Entra|Sal|Fuera|Sobre|Bajo|Recuerda|Atraviesa|Examina|Sigue|Termina|Visita|Acepta|Entrega|Pide|Cruza|Junto|Dentro|Por|De|Ver|Aprender|Incluyen)(?![\p{L}])/gu, (_, a, b) => a + b.toLowerCase())
    .replace(/\s{2,}/g, ' ');
}

const PRE_RULES = [
  [/\bTOUGH ELITE QUEST:/gi, 'MISIÓN DE ÉLITE DIFÍCIL:'],
  [/\bELITE QUEST:/gi, 'MISIÓN DE ÉLITE:'],
  [/\bGROUP QUEST\b/gi, 'MISIÓN DE GRUPO'],
  [/\bOnce you get to\b/gi, 'Una vez que llegues a'],
  [/\bMake sure you get\b/gi, 'Asegúrate de conseguir'],
  [/\bMake sure you are level (\d+)\b/gi, 'Asegúrate de ser nivel $1'],
  [/\bMake sure you are\b/gi, 'Asegúrate de estar'],
  [/\bMake sure you have\b/gi, 'Asegúrate de tener'],
  [/\bMake sure you learn\b/gi, 'Asegúrate de aprender'],
  [/\bMake sure you do\b/gi, 'Asegúrate de hacer'],
  [/\bquest items\b/gi, 'objetos de misión'],
  [/\bto a vendor\b/gi, 'a un vendedor'],
  [/\bat any vendor in\b/gi, 'en cualquier vendedor de'],
  [/\bdon't sell or use them\b/gi, 'no los vendas ni los uses'],
  [/\band remember to not sell them to a vendor!/gi, '¡y recuerda no vendérselos a un vendedor!'],
  [/\bRemember not to sell them to a vendor\b/gi, 'recuerda no vendérselos a un vendedor'],
  [/\bremember to not sell them to a vendor\b/gi, 'recuerda no vendérselos a un vendedor'],
  [/\bRemember not to sell this\b/gi, 'Recuerda no vender esto'],
  [/\bremember not to sell your\b/gi, 'recuerda no vender tu'],
  [/\bdo not sell them to a vendor\b/gi, 'no se los vendas a un vendedor'],
  [/\bdon't sell them to a vendor\b/gi, 'no se los vendas a un vendedor'],
  [/\bdo not sell it to a vendor\b/gi, 'no se lo vendas a un vendedor'],
  [/\bBe careful not to sell your\b/gi, 'Ten cuidado de no vender tu'],
  [/\bIf you can't use Hearthstone\b/gi, 'Si no puedes usar la piedra de hogar'],
  [/\bif you can't hearth\b/gi, 'si no puedes usar la piedra de hogar'],
  [/\bIf you can't\b/gi, 'Si no puedes'],
  [/\byou can't\b/gi, 'no puedes'],
  [/\bcan't\b/gi, 'no puedes'],
  [/\bdon't\b/gi, 'no'],
  [/\bdoesn't\b/gi, 'no'],
  [/\bGrind your way (north|south|east|west) to around(?: the)? waypoint\b/gi, (_, d) => `Ábrete paso hacia el ${{north:'norte',south:'sur',east:'este',west:'oeste'}[d.toLowerCase()]} hasta cerca del punto de ruta`],
  [/\bgrind your way (down )?(north|south|east|west)\b/gi, (_, _d, d) => `ábrete paso hacia el ${{north:'norte',south:'sur',east:'este',west:'oeste'}[d.toLowerCase()]}`],
  [/\bGrind your way back (?:to|towards)\b/gi, 'Ábrete paso de vuelta hacia'],
  [/\bGrind your way to\b/gi, 'Ábrete paso hacia'],
  [/\bgrind your way to\b/gi, 'ábrete paso hacia'],
  [/\bWork your way (north|south|east|west) along\b/gi, (_, d) => `Avanza hacia el ${{north:'norte',south:'sur',east:'este',west:'oeste'}[d.toLowerCase()]} a lo largo de`],
  [/\bwork your way to\b/gi, 'ábrete paso hacia'],
  [/\bMake your way to\b/gi, 'Dirígete a'],
  [/\bGrind on any mobs close around\b/gi, 'Mata enemigos cerca de'],
  [/\bGrind on any mobs around\b/gi, 'Mata enemigos alrededor de'],
  [/\bGrind on any mobs in the area\b/gi, 'Mata enemigos por la zona'],
  [/\bGrind on any mobs in the open fields of\b/gi, 'Mata enemigos en los campos abiertos de'],
  [/\bGrind on any mobs until you are level (\d+)\b/gi, 'Mata enemigos hasta llegar al nivel $1'],
  [/\bgrind on any mobs until you are\b/gi, 'mata enemigos hasta serlo'],
  [/\bGrind on any mobs until you achieve this\b/gi, 'Mata enemigos hasta lograrlo'],
  [/\bGrind any mobs you see along the way\b/gi, 'Mata a los enemigos que veas por el camino'],
  [/\bgrind on beasts around where\b/gi, 'matar bestias por donde'],
  [/\bGrind around the area\b/gi, 'Mata enemigos por la zona'],
  [/\bGrind around the farm\b/gi, 'Mata enemigos alrededor de la granja'],
  [/\bto help the grind\b/gi, 'para ayudar a subir de nivel'],
  [/\bflying boat\b/gi, 'barco volador'],
  [/\bget new spells\/abilities\b/gi, 'aprende nuevos hechizos y facultades'],
  [/\bget new spells from\b/gi, 'aprende nuevos hechizos con'],
  [/\bnew spells\/abilities\b/gi, 'nuevos hechizos y facultades'],
  [/\byour level (\d+) spells\/abilities\b/gi, 'tus hechizos y facultades de nivel $1'],
  [/\byour level (\d+) spells\b/gi, 'tus hechizos de nivel $1'],
  [/\byour level (\d+) abilities\b/gi, 'tus facultades de nivel $1'],
  [/\blevel (\d+) spells\/abilities\b/gi, 'hechizos y facultades de nivel $1'],
  [/\blevel (\d+) spells\b/gi, 'hechizos de nivel $1'],
  [/\ball around the outside of the village area\b/gi, 'por todos los alrededores de la aldea'],
  [/\ball around the (north|south|east|west) side of\b/gi, (_, d) => `por todo el lado ${{north:'norte',south:'sur',east:'este',west:'oeste'}[d.toLowerCase()]} de`],
  [/\ball around the area\b/gi, 'por toda la zona'],
  [/\ball around (western|eastern|northern|southern)\b/gi, (_, d) => `por todo el ${{western:'oeste',eastern:'este',northern:'norte',southern:'sur'}[d.toLowerCase()]} de`],
  [/\bAll around\b/gi, 'Por todo alrededor de'],
  [/\bThis is done around\b/gi, 'Esto se realiza alrededor de'],
  [/\bOnce in the\b/gi, 'Una vez en'],
  [/\bOnce on the other side of the\b/gi, 'Una vez al otro lado de'],
  [/\bOnce at the other side of the\b/gi, 'Una vez al otro lado de'],
  [/\bOnce again, watch out for\b/gi, 'Una vez más, cuidado con'],
  [/\bJump down to die here\b/gi, 'Salta hacia abajo para morir aquí'],
  [/\bDrop down off tree limb to Die on Purpose\b/gi, 'Déjate caer de la rama del árbol para morir a propósito'],
  [/\bDrop down here at waypoint to die on purpose!/gi, '¡Déjate caer aquí en el punto de ruta para morir a propósito!'],
  [/\bdie on purpose to get to\b/gi, 'muere a propósito para llegar a'],
  [/\bthen die on purpose and res at spirit\b/gi, 'y luego muere a propósito y revive en el ángel'],
  [/\bFollow waypoint through tunnel\b/gi, 'Sigue el punto de ruta a través del túnel'],
  [/\bFollow waypoint in mine\b/gi, 'Sigue el punto de ruta dentro de la mina'],
  [/\bGo in room at top of tower\b/gi, 'Entra en la sala en lo alto de la torre'],
  [/\bGo in room\b/gi, 'Entra en la sala'],
  [/\bAlso in the room:/gi, 'También en la sala:'],
  [/\bGo to bridge\b/gi, 'Ve al puente'],
  [/\bGo to the northern most docks to get on the boat to take you to\b/gi, 'Ve al muelle más al norte para subir al barco que te lleva a'],
  [/\bat the end of the long docks\b/gi, 'al final del muelle largo'],
  [/\bOut on the long docks, take the boat to\b/gi, 'En el muelle largo, toma el barco hacia'],
  [/\bJust on the long docks:/gi, 'En el muelle largo:'],
  [/\bOn the long docks:/gi, 'En el muelle largo:'],
  [/\bfollow the docks, and on your right:/gi, 'sigue por el muelle y a tu derecha:'],
  [/\bIn the small house:/gi, 'En la casa pequeña:'],
  [/\bInside the small house:/gi, 'Dentro de la casa pequeña:'],
  [/\bin front of the small house:/gi, 'frente a la casa pequeña:'],
  [/\bNext to the small house:/gi, 'Junto a la casa pequeña:'],
  [/\bat the small house:/gi, 'en la casa pequeña:'],
  [/\bAt the small house at\b/gi, 'En la casa pequeña en'],
  [/\bin the small house\b/gi, 'en la casa pequeña'],
  [/\bin small house\b/gi, 'en la casa pequeña'],
  [/\bEnter small house\b/gi, 'Entra en la casa pequeña'],
  [/\bBack in front of the big house:/gi, 'De vuelta frente a la casa grande:'],
  [/\bsmall tower\b/gi, 'torre pequeña'],
  [/\bin the small hut\b/gi, 'en la cabaña pequeña'],
  [/\bin the big hut\b/gi, 'en la cabaña grande'],
  [/\bdown in the hut:/gi, 'abajo en la cabaña:'],
  [/\bthen downstairs in the hut and loot\b/gi, 'luego baja en la cabaña y despoja'],
  [/\bGo up west and in the hut:/gi, 'Sube hacia el oeste y en la cabaña:'],
  [/\bgo down in the eastern most hut:/gi, 'baja a la cabaña más al este:'],
  [/\bUpstairs in the building in front of you:/gi, 'Arriba en el edificio frente a ti:'],
  [/\bup in the building in front of you:/gi, 'arriba en el edificio frente a ti:'],
  [/\bup in the building:/gi, 'arriba en el edificio:'],
  [/\baround the watchtower area\b/gi, 'por la zona de la torre de vigía'],
  [/\band in front of the watchtower:/gi, 'y frente a la torre de vigía:'],
  [/\bin the watchtower\b/gi, 'en la torre de vigía'],
  [/\band just off to your right next to the wagon:/gi, 'y justo a tu derecha junto al carro:'],
  [/\bnext to the wagon:/gi, 'junto al carro:'],
  [/\bBack up the mountain:/gi, 'De vuelta arriba en la montaña:'],
  [/\bGo back up on the hill at\b/gi, 'Vuelve a subir a la colina en'],
  [/\bBack at the small camp:/gi, 'De vuelta en el campamento pequeño:'],
  [/\bRight outside the Inn on your right:/gi, 'Justo fuera de la posada a tu derecha:'],
  [/\bRight in front of you:/gi, 'Justo frente a ti:'],
  [/\bJust outside the Inn:/gi, 'Justo fuera de la posada:'],
  [/\bJust outside the house:/gi, 'Justo fuera de la casa:'],
  [/\bJust outside:/gi, 'Justo fuera:'],
  [/\bjust outside:/gi, 'justo fuera:'],
  [/\bJust to your right off the main path at\b/gi, 'Justo a tu derecha fuera del camino principal en'],
  [/\bJust over the bridge, into\b/gi, 'Justo cruzando el puente, hacia'],
  [/\bJust over the bridge, next to the path:/gi, 'Justo al cruzar el puente, junto al camino:'],
  [/\bJust (north|south|east|west) on the shore:/gi, (_, d) => `Justo al ${{north:'norte',south:'sur',east:'este',west:'oeste'}[d.toLowerCase()]} en la orilla:`],
  [/\bJust (north|south|east|west) above\b/gi, (_, d) => `Justo al ${{north:'norte',south:'sur',east:'este',west:'oeste'}[d.toLowerCase()]} por encima de`],
  [/\bJust (north|south|east|west) of you at\b/gi, (_, d) => `Justo al ${{north:'norte',south:'sur',east:'este',west:'oeste'}[d.toLowerCase()]} de ti en`],
  [/\bJust (north|south|east|west) of\b/gi, (_, d) => `Justo al ${{north:'norte',south:'sur',east:'este',west:'oeste'}[d.toLowerCase()]} de`],
  [/\band just (north|south|east|west):/gi, (_, d) => `y justo al ${{north:'norte',south:'sur',east:'este',west:'oeste'}[d.toLowerCase()]}:`],
  [/\bpatrols in the lake\b/gi, 'patrulla en el lago'],
  [/\bpatrols around the red canopy\b/gi, 'patrulla alrededor del dosel rojo'],
  [/\bvendor under the red canopy, and purchase a:/gi, 'vendedor bajo el dosel rojo y compra:'],
  [/\bpurchase up to\b/gi, 'compra hasta'],
  [/\baround the middle of the farm\b/gi, 'por el centro de la granja'],
  [/\baround the middle of\b/gi, 'por el centro de'],
  [/\baround the farm\b/gi, 'alrededor de la granja'],
  [/\baround the well\b/gi, 'alrededor del pozo'],
  [/\baround the mountains\b/gi, 'alrededor de las montañas'],
  [/\bAround in the sea\b/gi, 'Por el mar'],
  [/\bAround in the mine\b/gi, 'Por el interior de la mina'],
  [/\bAround the outside of the cave\b/gi, 'Por el exterior de la cueva'],
  [/\bAround outside of mine\b/gi, 'Por el exterior de la mina'],
  [/\bDone at the outside of the cave\b/gi, 'Se realiza en el exterior de la cueva'],
  [/\balong the (eastern|western|northern|southern) shore of\b/gi, (_, d) => `a lo largo de la costa ${{eastern:'este',western:'oeste',northern:'norte',southern:'sur'}[d.toLowerCase()]} de`],
  [/\(he patrols around town from\b/gi, '(patrulla por el pueblo desde'],
  [/\bHe patrols clockwise\b/gi, 'Patrulla en sentido horario'],
  [/\bhe patrols around\b/gi, 'patrulla alrededor de'],
  [/\bUp stairs\b/gi, 'Sube las escaleras'],
  [/\bAcross the room and up the steps:/gi, 'Al otro lado de la sala y subiendo los escalones:'],
  [/\bLoot chest\b/gi, 'Despoja el cofre'],
  [/\bGo up on the platform:/gi, 'Sube a la plataforma:'],
  [/\bGo up the spiral ramp to the top of\b/gi, 'Sube por la rampa en espiral hasta lo alto de'],
  [/\bGo up the spiral ramp in(?: the)? building:/gi, 'Sube por la rampa en espiral del edificio:'],
  [/\bgo up the spiral ramp and inside the portal at\b/gi, 'sube por la rampa en espiral y entra en el portal en'],
  [/\bgo up in the tower\b/gi, 'sube a la torre'],
  [/\bgo up the ramp\b/gi, 'sube por la rampa'],
  [/\bGo down the ramp, then go left\b/gi, 'Baja por la rampa y gira a la izquierda'],
  [/\bDrop down to the bottom floor in\b/gi, 'Baja a la planta inferior en'],
  [/\bTake the SE bridge to the other building and at the entrance:/gi, 'Cruza el puente SE hacia el otro edificio y en la entrada:'],
  [/\bthrough the tree tunnel at\b/gi, 'a través del túnel del árbol en'],
  [/\bby going back through the red portal\b/gi, 'volviendo a cruzar el portal rojo'],
  [/\bget back on the boat to\b/gi, 'vuelve a subir al barco hacia'],
  [/\bOr just Hearth \(if you can\)\./gi, 'O simplemente usa la piedra de hogar (si puedes).'],
  [/\btry to find and kill\/loot\b/gi, 'intenta encontrar, matar y despojar a'],
  [/\btry to find help if you can as\b/gi, 'intenta buscar ayuda si puedes, ya que'],
  [/\btry to loot\b/gi, 'intenta despojar'],
  [/\btry to kill\b/gi, 'intenta matar a'],
  [/\bif so, just wait\b/gi, 'si es así, simplemente espera'],
  [/\bas it now has no use\b/gi, 'ya que ya no tiene utilidad'],
  [/\bKill\/loot Centaur\b/gi, 'Mata y despoja centauros'],
  [/\bKill a\b/gi, 'Mata a un'],
  [/\band kill\/loot him\b/gi, 'y mátalo y despójalo'],
  [/\band kill\/loot it\b/gi, 'y mátalo y despójalo'],
  [/\bkill\/loot it\b/gi, 'mátalo y despójalo'],
  [/\bkill\/loot him\b/gi, 'mátalo y despójalo'],
  [/\bThen Behind you, purchase a stack of\b/gi, 'Luego, detrás de ti, compra un montón de'],
  [/\bWe will kill the\b/gi, 'Mataremos a'],
  [/\bAccept the quest from it\.\s*Then turn it in from\b/gi, 'Acepta la misión que inicia y luego entrégala con'],
  [/\bWatch out for\b/gi, 'Cuidado con'],
  [/\bin front of the graveyard entrance:/gi, 'frente a la entrada del cementerio:'],
  [/\bAt the graveyard entrance:/gi, 'En la entrada del cementerio:'],
  [/\bAt the north graveyard gate entrance use\b/gi, 'En la entrada de la puerta norte del cementerio usa'],
  [/\bInside the first house on your right:/gi, 'Dentro de la primera casa a tu derecha:'],
  [/\bAt the very bottom of the crypt kill\/loot\b/gi, 'En el fondo de la cripta mata y despoja a'],
  [/\bGo to the very bottom of the crypt, and on your left loot the\b/gi, 'Baja hasta el fondo de la cripta y a tu izquierda despoja'],
  [/\bOn the first room on the right, loot the\b/gi, 'En la primera sala a la derecha, despoja'],
  [/\bat the Inn's entrance\b/gi, 'en la entrada de la posada'],
  [/\bComplete getting your Skinning to 20\b/gi, 'Termina de subir Desuello a 20'],
  [/\bRaise your skinning skill to 20\b/gi, 'Sube tu habilidad de Desuello a 20'],
  [/\bTake the Skinning reward and use it\b/gi, 'Elige la recompensa de Desuello y úsala'],
  [/\bWe are now done with\b/gi, 'Ya hemos terminado con'],
  [/\bWe will turn in\b/gi, 'Entregaremos'],
  [/\bWe will complete\b/gi, 'Completaremos'],
  [/\bWe will continue this questline later once we get to\b/gi, 'Continuaremos esta cadena de misiones más adelante cuando lleguemos a'],
  [/\bclick on it to loot the\b/gi, 'haz clic en él para despojar'],
  [/\bclick on it to:/gi, 'haz clic en él para:'],
  [/\bAvoid going in the small house!\s*Tough mob in there\./gi, '¡Evita entrar en la casa pequeña! Hay un enemigo difícil dentro.'],
  [/\bYou can do it now, or carry on to the Barrens\./gi, 'Puedes hacerla ahora o continuar hacia Los Baldíos.'],
  [/\bOnce at the UC, exit it and head north to the Zeppelin to go to\b/gi, 'Una vez en Entrañas, sal y dirígete al norte hacia el zepelín para ir a'],
  [/\bas it may not be worth the time\/xp, or the\b/gi, 'ya que quizá no valga la pena por el tiempo o la experiencia, ni'],
  [/\bthis\.\s*Farm it and get this now!/gi, 'esto. ¡Consíguelo ahora!'],
  [/\bIf you can't get to 20 yet, click Got it and turn it in when you are at 20\./gi, 'Si aún no llegas a 20, haz clic en Entendido y entrégala cuando llegues a 20.'],
  [/\bIf you can't find him in time, then it can be skipped\./gi, 'Si no lo encuentras a tiempo, puedes omitirla.'],
  [/\bfirst as it will allow you to not need to do the 19-20 grind later on\./gi, 'primero, ya que te evitará tener que matar enemigos entre los niveles 19 y 20 más adelante.'],
  [/\bare inside the mine \(which we will focus on next\)\./gi, 'están dentro de la mina (en la que nos centraremos a continuación).'],
  [/\bare not at this camp, we will get them along with more\b/gi, 'no están en este campamento; los conseguiremos junto con más'],
  [/\bGo west across the main path into the furbolg camp to simply get it\b/gi, 'Cruza el camino principal hacia el oeste hasta el campamento fúrbolg para conseguirlo'],
  [/\bGo SE to the small house with a dock next to it and first use your\b/gi, 'Ve al SE hasta la casa pequeña con un muelle al lado y usa primero tu'],
  [/\bUp in the room you are at, take the east bridge and then loot the\b/gi, 'Arriba, en la sala donde estás, cruza el puente este y despoja'],
  [/\bHe might also be on the left side of the main path around\b/gi, 'También podría estar al lado izquierdo del camino principal cerca de'],
  [/\bpatrolling around the middle of the farm yet, we\b/gi, 'patrullando por el centro de la granja todavía,'],
  [/\blearn new weapon possibilities if you can afford to\b/gi, 'aprende nuevas habilidades de armas si te lo puedes permitir'],
  [/\bif you can afford to\b/gi, 'si te lo puedes permitir'],
  [/\bif you can afford them\b/gi, 'si te los puedes permitir'],
  [/\bWork somewhat quickly to do the next steps as\b/gi, 'Avanza con cierta rapidez en los siguientes pasos, ya que'],
  [/\bso work somewhat quickly with the next few steps\b/gi, 'así que avanza con cierta rapidez en los próximos pasos'],
  [/\bhas a 100% drop rate for that item, so keep an eye out for him\b/gi, 'tiene un 100% de probabilidad de soltar ese objeto, así que estate atento a él'],
  [/\bvendor, see if you can purchase any\b/gi, 'vendedor, mira si puedes comprar'],
  [/\bEnter the Barracks across the path, and from the\b/gi, 'Entra en el cuartel al otro lado del camino y, con'],
  [/\bGo in the Barracks and from the\b/gi, 'Entra en el cuartel y, con'],
  [/\bGo into the Inn and from the\b/gi, 'Entra en la posada y, con'],
  [/\bvendor in the Inn\b/gi, 'vendedor de la posada'],
  [/\bThis should take you to the graveyard at\b/gi, 'Esto te llevará al cementerio de'],
  [/\bGo west to and talk to the\b/gi, 'Ve al oeste y habla con'],
  [/\bas you will need (\d+) of them for\b/gi, 'ya que necesitarás $1 para'],
  [/\bThe Warlock Trainers are at\b/gi, 'Los instructores de brujos están en'],
  [/\bRogue Trainers are at\b/gi, 'Los instructores de pícaros están en'],
  [/\bHead south on the main path to\b/gi, 'Dirígete al sur por el camino principal hacia'],
  [/\bhead south on the main path\b/gi, 'dirígete al sur por el camino principal'],
];

function sealAndTranslate(s) {
  const slots = [];
  const seal = (txt) => {
    const id = slots.length;
    slots.push(txt);
    return '\uE000' + id + '\uE001';
  };
  let tmp = s;
  for (const [rx, rep] of PRE_RULES) {
    tmp = tmp.replace(rx, rep);
  }
  for (const [rx, rep] of UNICODE_PHRASE_RULES) {
    tmp = tmp.replace(rx, rep);
  }
  // Sliding window 6..2 words to seal known EN_TO_ES entities
  tmp = tmp.replace(/[A-Za-z'-]+(?:\s+[A-Za-z'-]+)+/g, (run) => {
    const words = run.split(/\s+/);
    const out = [];
    let i = 0;
    while (i < words.length) {
      let matched = false;
      for (let len = Math.min(6, words.length - i); len >= 2; len--) {
        const cand = words.slice(i, i + len).join(' ');
        const tr = lookupSealEntity(cand);
        if (tr) {
          out.push(seal(tr));
          i += len;
          matched = true;
          break;
        }
      }
      if (!matched) {
        out.push(words[i]);
        i++;
      }
    }
    return out.join(' ');
  });
  for (const [rx, rep] of EXTRA_CLEAN_WORD_RULES) {
    tmp = tmp.replace(rx, rep);
  }
  for (const [rx, rep] of UNICODE_CLAUSE_RULES) {
    tmp = tmp.replace(rx, rep);
  }
  tmp = tmp.replace(/\uE000(\d+)\uE001/g, (_, id) => slots[Number(id)]);
  return postProcessSpanishGrammar(tmp);
}

if (process.argv.includes('--analyze')) {
  const strings = JSON.parse(fs.readFileSync(
    'C:/Users/marco/.gemini/antigravity/brain/3b20a39a-67fa-437f-9c6e-a70d116af4b8/scratch/real_strings_0001_0021.json',
    'utf8'
  ));
  let exactOrTpl = 0;
  const needDict = [];
  for (const [s, count] of strings) {
    const tr = translateString(s);
    const hits = findEnglishHits(tr);
    const badEs = EARLY_BAD_ES_RX.test(tr) || STRICT_BAD_RX.test(tr);
    const curatedOk = CURATED_DICT[s] !== undefined || CURATED_DICT[s.trim()] !== undefined;
    if (curatedOk && !badEs && (!hits.length || VALID_PROPER_SAME.has(s.trim()))) {
      exactOrTpl++;
    } else if (tr === s && (hits.length > 0 || badEs || /[A-Za-z]{4,}/.test(s))) {
      if (hits.length > 0 || badEs || (EN_TO_ES[s.trim()] === undefined && !curatedOk)) {
        needDict.push([count, s, tr, hits, badEs]);
      } else {
        exactOrTpl++;
      }
    } else if (hits.length > 0 || badEs) {
      needDict.push([count, s, tr, hits, badEs]);
    } else {
      exactOrTpl++;
    }
  }
  console.log('Total:', strings.length, 'Cleanly handled:', exactOrTpl, 'Still needing translation/fix:', needDict.length);
  fs.writeFileSync(
    'C:/Users/marco/.gemini/antigravity/brain/3b20a39a-67fa-437f-9c6e-a70d116af4b8/scratch/need_curated_es.json',
    JSON.stringify(needDict, null, 2),
    'utf8'
  );
  console.log('Top 50 needing translation:');
  for (const x of needDict.slice(0, 50)) {
    console.log(`${String(x[0]).padStart(3)} | ${JSON.stringify(x[1])} -> ${JSON.stringify(x[2])} [${x[3].join(',')}${x[4] ? ' +BAD_ES' : ''}]`);
  }
}

function writeRetry(filePath, content) {
  for (let attempt = 0; attempt < 5; attempt++) {
    try {
      fs.writeFileSync(filePath, content, { encoding: 'utf8' });
      return;
    } catch (err) {
      if (attempt === 4) throw err;
      const waitUntil = Date.now() + 80 * (attempt + 1);
      while (Date.now() < waitUntil) {}
    }
  }
}

function countBracesOutsideStrings(lua) {
  let open = 0, close = 0;
  let i = 0;
  while (i < lua.length) {
    const ch = lua[i];
    if (ch === '-' && lua[i + 1] === '-') {
      if (lua.slice(i + 2, i + 4) === '[[') {
        const end = lua.indexOf(']]', i + 4);
        i = end === -1 ? lua.length : end + 2;
      } else {
        while (i < lua.length && lua[i] !== '\n') i++;
      }
      continue;
    }
    if (ch === '[' && (lua[i + 1] === '[' || (lua[i + 1] === '=' && lua[i + 2] === '['))) {
      const m = lua.slice(i).match(/^\[(=*)\[/);
      const eq = m[1];
      const end = lua.indexOf(`]${eq}]`, i + m[0].length);
      i = end === -1 ? lua.length : end + eq.length + 2;
      continue;
    }
    if (ch === '"' || ch === "'") {
      const q = ch;
      i++;
      while (i < lua.length) {
        if (lua[i] === '\\') { i += 2; continue; }
        if (lua[i] === q) { i++; break; }
        i++;
      }
      continue;
    }
    if (ch === '{') open++;
    else if (ch === '}') close++;
    i++;
  }
  return { open, close };
}

function unescapeLuaString(rawVal, quoteChar) {
  let out = '';
  for (let i = 0; i < rawVal.length; i++) {
    if (rawVal[i] === '\\' && i + 1 < rawVal.length) {
      const nxt = rawVal[i + 1];
      if (nxt === 'n') { out += '\n'; i++; continue; }
      if (nxt === 'r') { out += '\r'; i++; continue; }
      if (nxt === 't') { out += '\t'; i++; continue; }
      if (nxt === '\\') { out += '\\'; i++; continue; }
      if (nxt === '"' || nxt === "'") { out += nxt; i++; continue; }
    }
    out += rawVal[i];
  }
  return out;
}

function escapeLuaString(val, quoteChar) {
  let out = val
    .replace(/\\/g, '\\\\')
    .replace(/\r/g, '\\r')
    .replace(/\n/g, '\\n')
    .replace(/\t/g, '\\t');
  if (quoteChar === '"') {
    out = out.replace(/"/g, '\\"');
  } else {
    out = out.replace(/'/g, "\\'");
  }
  return out;
}

function rewriteLuaStrings(lua) {
  let out = '';
  let lastOut = 0;
  let i = 0;
  let lastIdent = null;
  let sawEq = false;
  let replaced = 0;
  let totalVisible = 0;

  while (i < lua.length) {
    const ch = lua[i];
    if (/\s/.test(ch)) { i++; continue; }
    if (ch === '-' && lua[i + 1] === '-') {
      if (lua.slice(i + 2, i + 4) === '[[') {
        const end = lua.indexOf(']]', i + 4);
        i = end === -1 ? lua.length : end + 2;
      } else {
        while (i < lua.length && lua[i] !== '\n') i++;
      }
      continue;
    }
    if (ch === '[' && (lua[i + 1] === '[' || (lua[i + 1] === '=' && lua[i + 2] === '['))) {
      const m = lua.slice(i).match(/^\[(=*)\[/);
      const eq = m[1];
      const end = lua.indexOf(`]${eq}]`, i + m[0].length);
      i = end === -1 ? lua.length : end + eq.length + 2;
      lastIdent = null;
      sawEq = false;
      continue;
    }
    if (/[A-Za-z_]/.test(ch)) {
      const s = i;
      while (i < lua.length && /[A-Za-z0-9_]/.test(lua[i])) i++;
      lastIdent = lua.slice(s, i);
      sawEq = false;
      continue;
    }
    if (ch === '=') {
      if (lua[i + 1] === '=') {
        i += 2;
        lastIdent = null;
        sawEq = false;
        continue;
      }
      sawEq = true;
      i++;
      continue;
    }
    if (ch === '"' || ch === "'") {
      const q = ch;
      const strStart = i;
      let j = i + 1;
      while (j < lua.length) {
        if (lua[j] === '\\') { j += 2; continue; }
        if (lua[j] === q) break;
        j++;
      }
      const rawInner = lua.slice(i + 1, j);
      const unesc = unescapeLuaString(rawInner, q);
      const key = sawEq ? lastIdent : null;
      const isTranslatable = !(key ? NON_TRANSLATABLE_KEYS.has(key) : (DIRECTIVE_STRINGS.has(unesc) || COORD_RX.test(unesc)));
      if (isTranslatable && unesc.trim()) {
        totalVisible++;
        const tr = translateString(unesc);
        if (tr !== unesc) {
          out += lua.slice(lastOut, strStart + 1) + escapeLuaString(tr, q);
          lastOut = j;
          replaced++;
        }
      }
      i = j + 1;
      lastIdent = null;
      sawEq = false;
      continue;
    }
    lastIdent = null;
    sawEq = false;
    i++;
  }
  out += lua.slice(lastOut);
  return { lua: out, replaced, totalVisible };
}

if (process.argv.includes('--build')) {
  let filesWritten = 0;
  let totalReplaced = 0;
  let totalVisibleAll = 0;

  for (let n = 1; n <= 21; n++) {
    const id = String(n).padStart(4, '0');
    const srcGameFile = path.join(GAME_GUIDES_DIR, `${id}.html`);
    const dstSrcFile = path.join(SRC_GUIDES_DIR, `${id}.html`);
    if (!fs.existsSync(srcGameFile)) {
      throw new Error(`Missing clean 4.00.07 source guide: ${srcGameFile}`);
    }
    const html = fs.readFileSync(srcGameFile, 'utf8').replace(/^\uFEFF/, '');
    const m = html.match(/^([\s\S]*?<p>\r?\n)([\s\S]*?)(\r?\n\s*<\/p>[\s\S]*)$/);
    if (!m) {
      throw new Error(`Unexpected HTML wrapper in ${srcGameFile}`);
    }
    const header = m[1];
    const b64 = m[2].replace(/\s+/g, '');
    const footer = m[3];
    const origLua = Buffer.from(b64, 'base64').toString('utf8');
    const beforeBraces = countBracesOutsideStrings(origLua);
    const { lua: updatedLua, replaced, totalVisible } = rewriteLuaStrings(origLua);
    const afterBraces = countBracesOutsideStrings(updatedLua);

    if (beforeBraces.open !== afterBraces.open || beforeBraces.close !== afterBraces.close || afterBraces.open !== afterBraces.close) {
      throw new Error(`Lua brace balance mismatch in ${id}.html: before=${JSON.stringify(beforeBraces)} after=${JSON.stringify(afterBraces)}`);
    }

    const newB64Raw = Buffer.from(updatedLua, 'utf8').toString('base64');
    const lines = [];
    for (let pos = 0; pos < newB64Raw.length; pos += 76) {
      lines.push(newB64Raw.slice(pos, pos + 76));
    }
    const eol = html.includes('\r\n') ? '\r\n' : '\n';
    const newHtml = (header + lines.join(eol) + footer).replace(/^\uFEFF/, '');
    writeRetry(dstSrcFile, newHtml);
    filesWritten++;
    totalReplaced += replaced;
    totalVisibleAll += totalVisible;
    console.log(`${id}.html: translated ${replaced}/${totalVisible} strings (braces ${afterBraces.open}/${afterBraces.close})`);
  }
  console.log(`Built ${filesWritten} early guide files (${totalReplaced}/${totalVisibleAll} string occurrences updated).`);
}
