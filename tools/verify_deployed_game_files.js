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

const fls = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/ForeverLootSparkles/ForeverLootSparkles.lua', 'utf8');
console.log('ForeverLootSparkles in game has esES:', fls.includes('locale == "esES"'));

const flsc = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/ForeverLootSparkles_Coloring/LocalesMore.lua', 'utf8');
console.log('ForeverLootSparkles_Coloring in game has esES:', flsc.includes('L.esES = {') && flsc.includes('FLS.esES = Sparkles('));

const auc = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/Auctionator/Locales/esES.lua', 'utf8');
console.log('Auctionator in game has SUPPORT_HEADER:', auc.includes('L["SUPPORT_HEADER"]'));

const bag = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/Baganator/Locales.lua', 'utf8');
console.log('Baganator in game has 0 missing esES translations:', !bag.split('local L = Locales.esES')[1].split('local L = Locales.esMX')[0].includes('Translation missing'));

const syn = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/Syndicator/Locales.lua', 'utf8');
console.log('Syndicator in game has 0 missing esES translations:', !syn.split('local L = Locales.esES')[1].split('local L = Locales.esMX')[0].includes('Translation missing'));

const lm = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/Leatrix_Maps/Leatrix_Maps_Locale.lua', 'utf8');
console.log('Leatrix_Maps in game has The Drowned City in esES:', lm.split('if GameLocale == "esES" then')[1].split(/\r?\nend\r?\n/)[0].includes('L["The Drowned City"]'));

const lp = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/Leatrix_Plus/Leatrix_Plus_Locale.lua', 'utf8');
console.log('Leatrix_Plus in game has Mount ID in esES:', lp.split('if GameLocale == "esES" then')[1].split(/\r?\nend\r?\n/)[0].includes('L["Mount ID"]'));

const jGo = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/Journey/data/GameObjectNames/GameObjectNames-esES.lua', 'utf8');
console.log('Journey GameObjectNames-esES in game has 0 bracketed objects:', !jGo.includes('"['));

const hbe = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/HealBot_ExtraSkins/HealBot_ExtraSkins.lua', 'utf8');
console.log('HealBot_ExtraSkins in game has HealBot_ExtraSkins_Lang_es:', hbe.includes('function HealBot_ExtraSkins_Lang_es()'));

const hbt = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/HealBot_Tips/Locale/HealBot_Localization.es.lua', 'utf8');
console.log('HealBot_Tips in game has HealBot_Lang_Options_esALL:', hbt.includes('function HealBot_Lang_Options_esALL()') && hbt.includes('HEALBOT_OPTIONS_HELP_TEXT='));

const hba = fs.readFileSync('D:/World of Warcraft/_forever_/Interface/AddOns/HealBot/Healbot_Aura.lua', 'utf8');
console.log('HealBot Aura in game has Spanish combat messages:', hba.includes('necesita') && hba.includes('sufre de'));
