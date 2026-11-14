const fs = require('fs');

const ZONE_TRANSLATIONS = {
    'The Hinterlands': 'Tierras del Interior',
    'Hinterlands': 'Tierras del Interior',
    'Blasted Lands': 'Las Tierras Devastadas',
    "Un'Goro Crater": "Cráter de Un'Goro",
    'Tanaris / Un\'Goro': 'Tanaris / Cráter de Un\'Goro',
    'Burning Steppes': 'Las Estepas Ardientes',
    'Western Plaguelands': 'Tierras de la Peste del Oeste',
    'Eastern Plaguelands': 'Tierras de la Peste del Este',
    'Winterspring': 'Cuna del Invierno',
    'Felwood': 'Frondavil',
    'Elwynn Forest': 'Bosque de Elwynn',
    'Westfall': 'Páramos de Poniente',
    'Redridge Mountains': 'Montañas de Crestagrana',
    'Duskwood': 'Bosque del Ocaso',
    'Wetlands': 'Los Humedales',
    'Hillsbrad Foothills': 'Laderas de Trabalomas',
    'Arathi Highlands': 'Tierras Altas de Arathi',
    'Alterac Mountains': 'Montañas de Alterac',
    'Stranglethorn Vale': 'Vega de Tuercespina',
    'Badlands': 'Tierras Inhóspitas',
    'Swamp of Sorrows': 'Pantano de las Penas',
    'Dustwallow Marsh': 'Marjal Revolcafango',
    'Southern Barrens': 'Los Baldíos del Sur',
    'The Barrens': 'Los Baldíos',
    'Barrens': 'Los Baldíos',
    'Tirisfal Glades': 'Claros de Tirisfal',
    'Silverpine Forest': 'Bosque de Argénteos',
    'Thousand Needles': 'Las Mil Agujas',
    'Shimmering Flats': 'El Desierto de Sal',
    'Stonetalon Mountains': 'Sierra Espolón',
    'Stonetalon': 'Sierra Espolón',
    'The Undercity': 'Entrañas',
    'Zephras Isle': 'Isla Zephras',
    'Thendal Village': 'Aldea Thendal',
    'Darkshore': 'Costa Oscura',
    'Ashenvale': 'Vallefresno',
    'Searing Gorge': 'La Garganta de Fuego',
    'Desolace': 'Desolace',
    'Feralas': 'Feralas',
    'Tanaris': 'Tanaris',
    'Silithus': 'Silithus',
    'Azshara': 'Azshara',
    'Dun Morogh': 'Dun Morogh',
    'Loch Modan': 'Loch Modan',
    'Teldrassil': 'Teldrassil',
    'Durotar': 'Durotar',
    'Mulgore': 'Mulgore',
    'Riverglades': 'Claros del Río',
    'Felwood / Azshara': 'Frondavil / Azshara'
};

const TOOLTIP_TRANSLATIONS = {
    'Recommended for Orcs and Trolls': 'Recomendado para orcos y trols',
    'Recommended for Tauren': 'Recomendado para tauren',
    'Recommended for Undead': 'Recomendado para no-muertos',
    'Recommended for Humans': 'Recomendado para humanos',
    'Recommended for Night Elves': 'Recomendado para elfos de la noche',
    'Recommended for Dwarves and Gnomes': 'Recomendado para enanos y gnomos',
    'Recommended for Skyborne': 'Recomendado para nacidos del cielo',
    'Recommended for all Horde': 'Recomendado para toda la Horda'
};

const content = fs.readFileSync('src/Journey/BundledContent/Guides/guides.html', 'utf8');
const match = content.match(/<p>([\s\S]*?)<\/p>/);
if (!match) {
    console.error('No <p> found in guides.html');
    process.exit(1);
}

const b64 = match[1].replace(/\s+/g, '');
let luaStr = Buffer.from(b64, 'base64').toString('utf8');

// Replace tooltips
for (const [en, es] of Object.entries(TOOLTIP_TRANSLATIONS)) {
    const regex = new RegExp(`tooltipTitle\\s*=\\s*"${en.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}"`, 'g');
    luaStr = luaStr.replace(regex, `tooltipTitle = "${es}"`);
}

// Replace descriptions
for (const [en, es] of Object.entries(ZONE_TRANSLATIONS)) {
    // Matches something like "50-50 The Hinterlands" or "1-6 Durotar" or "58-58 Felwood / Azshara"
    const regex = new RegExp(`(description\\s*=\\s*"[^"]*?)${en.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}([^"]*?")`, 'g');
    luaStr = luaStr.replace(regex, `$1${es}$2`);
}

const newB64 = Buffer.from(luaStr, 'utf8').toString('base64');
const formattedB64 = newB64.match(/.{1,76}/g).join('\r\n');
const newHtml = content.replace(/<p>[\s\S]*?<\/p>/, `<p>\r\n${formattedB64}\r\n\t\t</p>`);

fs.writeFileSync('src/Journey/BundledContent/Guides/guides.html', newHtml, 'utf8');
console.log('guides.html updated and localized successfully.');
