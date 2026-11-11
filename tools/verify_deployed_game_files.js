const fs = require('fs');

const wt = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/WhatsTraining/Localization.lua', 'utf8');
console.log('WhatsTraining in game has esES AVAILABLE_HEADER:', wt.includes('AVAILABLE_HEADER = "Disponible ahora"'));
console.log('WhatsTraining in game has esMX COST_FORMAT:', wt.includes('COST_FORMAT = "Costo: %s"'));

const bom = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/Books_on_map_Forever/Locales/esES.lua', 'utf8');
console.log('Books_on_map_Forever in game has Library books:', bom.includes('Libros de la biblioteca de WoW Forever'));
console.log('Books_on_map_Forever in game has Drag: move button:', bom.includes('L["Drag: move button"] = "Arrastrar: mover botón"'));

const ma = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/MoveAny/locale/esES.lua', 'utf8');
console.log('MoveAny in game has esES:', ma.includes('MoveAny:AddTrans("esES"'));

const gq = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/GearQuestForever_Languages/esES.lua', 'utf8');
console.log('GearQuestForever in game has esES:', gq.includes('GQ.ActiveLocale ~= "esES"'));
