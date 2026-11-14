-- Strings of this addon (L) and translations (English, German, French here;
-- the other client languages in LocalesMore.lua) of Forever Loot Sparkles' own
-- options strings (ns.FLS). FLS keys are the exact English texts used in
-- ForeverLootSparkles.lua / SoftTarget.lua (v1.3.1); if a future version
-- rewords one, that line simply stays English.

local _, ns = ...;
local locale = GetLocale();

---------------------------------------------------------------------------
-- This addon's own panel
---------------------------------------------------------------------------

local L = {
	PANEL_NAME = "Colors",
	TITLE = "Forever Loot Sparkles - Colors",
	DESCRIPTION = "Pick a color for the glints of each category. Out of reach the glints stay dimmer, and they still fade to grey when an object can't be used.",
	ENABLE = "Color the sparkles",
	ENABLE_TOOLTIP = "Off: the sparkles keep Forever Loot Sparkles' golden color.",
	herb = "Herbs",
	ore = "Ore veins",
	quest = "Quest objects",
	corpseLoot = "Corpses with loot",
	footlocker = 'Footlockers (lockpicking)',
	FOOTLOCKER_TOOLTIP = 'Sparkles on footlockers that rogues can pick open, e.g. Battered, Dented or Waterlogged Footlockers. They turn grey when your lockpicking skill is too low.',
	SWATCH_TOOLTIP = "Click to choose a color.",
	RESET = "Reset colors",
	SAFE_CAST = "Safe self-cast",
	SAFE_CAST_TOOLTIP = "Spells cast without a target could land on the player or NPC that soft targeting has picked next to you. With this on, soft targeting is switched off in combat and whenever it picks a living unit, and back on once you have moved a few yards. Nodes and corpses keep sparkling. While it is off, the interact key doesn't work on NPCs.",
	HIDE_PLATE = "Hide the nameplate under the sparkle",
	HIDE_PLATE_TOOLTIP = "The sparkle hangs on the game's nameplate of the object or corpse. With this on, that nameplate (name, empty health bar, icon) is invisible and only the sparkle shows.",
	OPEN_HINT = "The options are under Esc > Options > AddOns > Forever Loot Sparkles.",
	other = "Other objects",
	npc = "NPCs",
	ICONS_NPC_TOOLTIP = "Hides the game's interaction icon over NPCs such as vendors, trainers and quest givers. Over NPCs without a nameplate the game draws it itself, so this also switches off the game setting for NPC interact icons (put back when unticked).",
	ICONS_HEADER = "Hide interaction icons",
	ICONS_ALL = "Hide all",
	ICONS_ALL_TOOLTIP = "Hides the game's interaction icon (gear, pickaxe, leaf, hand ...) over every object, corpse and NPC. The sparkles stay.",
	ICONS_TOOLTIP = "Hides the game's interaction icon over this kind of object. Forever Loot Sparkles switches these icons on because its sparkle needs them, so they are only made invisible. The sparkle stays.",
	ICONS_OTHER_TOOLTIP = "Hides the game's interaction icon over all other objects, e.g. fishing bobbers, chests, mailboxes and doors. The sparkle stays.",
	NOTE = "Only the glints that Forever Loot Sparkles draws itself can be colored. The game's own loot sparkle on quest items is drawn by the game engine and keeps its color.",
};

if locale == "deDE" then
	L.PANEL_NAME = "Farben";
	L.TITLE = "Forever Loot Sparkles - Farben";
	L.DESCRIPTION = "Wähle für jede Kategorie eine Farbe für das Funkeln. Außer Reichweite bleibt es dunkler, und es wird weiterhin grau, wenn ein Objekt nicht benutzt werden kann.";
	L.ENABLE = "Funkeln einfärben";
	L.ENABLE_TOOLTIP = "Aus: Das Funkeln behält die goldene Farbe von Forever Loot Sparkles.";
	L.herb = "Kräuter";
	L.ore = "Erzvorkommen";
	L.quest = "Questobjekte";
	L.corpseLoot = "Leichen mit Beute";
	L.footlocker = "Schließkisten (Schlossknacken)";
	L.FOOTLOCKER_TOOLTIP = "Lässt Schließkisten funkeln, die Schurken knacken können, z. B. ramponierte, verbeulte oder durchnässte Schließkisten. Grau, wenn dein Schlossknacken-Wert zu niedrig ist.";
	L.SWATCH_TOOLTIP = "Klicken, um eine Farbe zu wählen.";
	L.RESET = "Farben zurücksetzen";
	L.SAFE_CAST = "Sicheres Selbstzaubern";
	L.SAFE_CAST_TOOLTIP = "Zauber ohne Ziel könnten auf dem Spieler oder NPC landen, den das Soft-Targeting neben dir ausgewählt hat. Ist das an, wird das Soft-Targeting im Kampf ausgeschaltet und immer dann, wenn es eine lebende Einheit auswählt, und wieder eingeschaltet, sobald du ein paar Meter weitergegangen bist. Vorkommen und Leichen funkeln weiter. Solange es aus ist, funktioniert die Interaktionstaste bei NPCs nicht.";
	L.HIDE_PLATE = "Namensplakette unter dem Funkeln ausblenden";
	L.HIDE_PLATE_TOOLTIP = "Das Funkeln hängt an der Namensplakette des Objekts oder der Leiche. Ist das an, ist diese Plakette (Name, leerer Lebensbalken, Symbol) unsichtbar, und nur das Funkeln ist zu sehen.";
	L.OPEN_HINT = "Die Optionen findest du unter Esc > Optionen > AddOns > Forever Loot Sparkles.";
	L.other = "Andere Objekte";
	L.npc = "NPCs";
	L.ICONS_NPC_TOOLTIP = "Blendet das Interaktionssymbol über NPCs aus, z. B. Händlern, Lehrern und Questgebern. Über NPCs ohne Namensplakette zeichnet das Spiel es selbst, deshalb wird dafür auch die Spieleinstellung für NPC-Interaktionssymbole ausgeschaltet (beim Abwählen wiederhergestellt).";
	L.ICONS_HEADER = "Interaktionssymbole ausblenden";
	L.ICONS_ALL = "Alle ausblenden";
	L.ICONS_ALL_TOOLTIP = "Blendet das Interaktionssymbol des Spiels (Zahnrad, Spitzhacke, Blatt, Hand ...) über allen Objekten, Leichen und NPCs aus. Das Funkeln bleibt.";
	L.ICONS_TOOLTIP = "Blendet das Interaktionssymbol des Spiels über dieser Art von Objekt aus. Forever Loot Sparkles schaltet die Symbole ein, weil das Funkeln sie braucht, deshalb werden sie nur unsichtbar gemacht. Das Funkeln bleibt.";
	L.ICONS_OTHER_TOOLTIP = "Blendet das Interaktionssymbol über allen anderen Objekten aus, z. B. Angelposen, Truhen, Briefkästen und Türen. Das Funkeln bleibt.";
	L.NOTE = "Eingefärbt werden kann nur das Funkeln, das Forever Loot Sparkles selbst zeichnet. Das spieleigene Beutefunkeln an Questgegenständen zeichnet die Spiel-Engine, es behält seine Farbe.";
elseif locale == "frFR" then
	L.PANEL_NAME = "Couleurs";
	L.TITLE = "Forever Loot Sparkles - Couleurs";
	L.DESCRIPTION = "Choisissez une couleur d'éclat pour chaque catégorie. Hors de portée, les éclats restent plus sombres, et ils virent toujours au gris quand un objet est inutilisable.";
	L.ENABLE = "Colorer les éclats";
	L.ENABLE_TOOLTIP = "Désactivé : les éclats gardent la couleur dorée de Forever Loot Sparkles.";
	L.herb = "Herbes";
	L.ore = "Filons de minerai";
	L.quest = "Objets de quête";
	L.corpseLoot = "Cadavres avec butin";
	L.footlocker = "Coffres (crochetage)";
	L.FOOTLOCKER_TOOLTIP = "Fait scintiller les coffres que les voleurs peuvent crocheter, par ex. coffres cabossés, bosselés ou détrempés. Gris si votre compétence en crochetage est trop basse.";
	L.SWATCH_TOOLTIP = "Cliquez pour choisir une couleur.";
	L.RESET = "Réinitialiser les couleurs";
	L.SAFE_CAST = "Auto-incantation sûre";
	L.SAFE_CAST_TOOLTIP = "Les sorts lancés sans cible pourraient atteindre le joueur ou le PNJ choisi à côté de vous par le ciblage souple. Avec cette option, le ciblage souple est coupé en combat et dès qu'il choisit une unité vivante, puis réactivé après quelques mètres. Les gisements et cadavres continuent de scintiller. Tant qu'il est coupé, la touche d'interaction ne fonctionne pas sur les PNJ.";
	L.HIDE_PLATE = "Masquer la plaque de nom sous l'éclat";
	L.HIDE_PLATE_TOOLTIP = "L'éclat est accroché à la plaque de nom de l'objet ou du cadavre. Avec cette option, cette plaque (nom, barre de vie vide, icône) est invisible et seul l'éclat apparaît.";
	L.OPEN_HINT = "Les options se trouvent sous Échap > Options > AddOns > Forever Loot Sparkles.";
	L.other = "Autres objets";
	L.npc = "PNJ";
	L.ICONS_NPC_TOOLTIP = "Masque l'icône d'interaction au-dessus des PNJ, par ex. marchands, maîtres et donneurs de quêtes. Au-dessus des PNJ sans plaque de nom, le jeu la dessine lui-même ; l'option du jeu pour les icônes d'interaction des PNJ est donc aussi désactivée (rétablie quand vous décochez)."
	L.ICONS_HEADER = "Masquer les icônes d'interaction";
	L.ICONS_ALL = "Tout masquer";
	L.ICONS_ALL_TOOLTIP = "Masque l'icône d'interaction du jeu (engrenage, pioche, feuille, main...) au-dessus de tous les objets, cadavres et PNJ. Les éclats restent.";
	L.ICONS_TOOLTIP = "Masque l'icône d'interaction du jeu au-dessus de ce type d'objet. Forever Loot Sparkles active ces icônes car ses éclats en ont besoin ; elles sont donc seulement rendues invisibles. Les éclats restent.";
	L.ICONS_OTHER_TOOLTIP = "Masque l'icône d'interaction au-dessus de tous les autres objets, par ex. flotteurs de pêche, coffres, boîtes aux lettres et portes. Les éclats restent.";
	L.NOTE = "Seuls les éclats dessinés par Forever Loot Sparkles peuvent être colorés. L'éclat de butin du jeu sur les objets de quête est dessiné par le moteur du jeu et garde sa couleur.";
end

-- Further languages from LocalesMore.lua
local extraL = ns.EXTRA_L and ns.EXTRA_L[locale];
if extraL then
	for key, text in pairs(extraL) do
		L[key] = text;
	end
end

ns.L = L;

---------------------------------------------------------------------------
-- Translations of Forever Loot Sparkles
---------------------------------------------------------------------------

-- Same text the original appends to each soft target tooltip
local HOW = " Uses Blizzard's soft targeting: the nearest object within about 15 yards sparkles, brighter once you can reach it. Needs the game's Enable Interact Key setting and its interact icons on objects; switching this on turns both on, and with them off nothing sparkles.";

local EN = {
	how = HOW,
	enabled = "Show quest item sparkles",
	enabledTip = "Keeps the game's loot sparkle on, even after a graphics preset turns it off. Your outline mode is left as you set it. Switching this off takes effect after restarting the game.",
	header = "Sparkles while approaching",
	ore = "Ore veins",
	oreTip = "Sparkles on mining nodes as you approach them." .. HOW,
	herb = "Herbs",
	herbTip = "Sparkles on herbs as you approach them." .. HOW,
	quest = "Quest objects",
	questTip = "Extra sparkles on quest objects as you approach them. Off by default: the game's loot sparkle already marks most of them." .. HOW,
	corpse = "Corpses with loot",
	corpseTip = "Sparkles on a corpse that still holds loot for you, bosses included. Only after the fight: the game doesn't let addons switch the nameplate it hangs on during combat." .. HOW,
};

local TRANSLATIONS = {
	deDE = (function()
		local how = " Nutzt Blizzards Soft-Targeting: Das nächste Objekt im Umkreis von etwa 15 Metern funkelt, heller, sobald du es erreichen kannst. Benötigt die Spieleinstellung „Interaktionstaste aktivieren“ und deren Interaktionssymbole an Objekten; das Einschalten aktiviert beides, sind sie aus, funkelt nichts.";
		return {
			how = how,
			enabled = "Beutefunkeln an Questgegenständen anzeigen",
			enabledTip = "Hält das Beutefunkeln des Spiels eingeschaltet, auch wenn eine Grafikvoreinstellung es abschaltet. Dein Umrissmodus bleibt, wie du ihn eingestellt hast. Das Ausschalten wirkt erst nach einem Neustart des Spiels.",
			header = "Funkeln beim Annähern",
			ore = "Erzvorkommen",
			oreTip = "Lässt Erzvorkommen funkeln, wenn du dich ihnen näherst." .. how,
			herb = "Kräuter",
			herbTip = "Lässt Kräuter funkeln, wenn du dich ihnen näherst." .. how,
			quest = "Questobjekte",
			questTip = "Zusätzliches Funkeln an Questobjekten, wenn du dich ihnen näherst. Standardmäßig aus: Das Beutefunkeln des Spiels markiert die meisten bereits." .. how,
			corpse = "Leichen mit Beute",
			corpseTip = "Lässt eine Leiche funkeln, die noch Beute für dich enthält, auch bei Bossen. Erst nach dem Kampf: Im Kampf lässt das Spiel Addons die Namensplakette, an der das Funkeln hängt, nicht umschalten." .. how,
		};
	end)(),
	frFR = (function()
		local how = " Utilise le ciblage souple de Blizzard : l'objet le plus proche dans un rayon d'environ 15 mètres scintille, plus vivement dès que vous pouvez l'atteindre. Nécessite l'option « Activer la touche d'interaction » du jeu et ses icônes d'interaction sur les objets ; activer cette option active les deux, et sans elles rien ne scintille.";
		return {
			how = how,
			enabled = "Afficher l'éclat sur les objets de quête",
			enabledTip = "Garde l'éclat de butin du jeu actif, même quand un préréglage graphique le désactive. Votre mode de contour reste tel que vous l'avez réglé. La désactivation ne prend effet qu'après un redémarrage du jeu.",
			header = "Éclats à l'approche",
			ore = "Filons de minerai",
			oreTip = "Fait scintiller les filons de minerai à votre approche." .. how,
			herb = "Herbes",
			herbTip = "Fait scintiller les herbes à votre approche." .. how,
			quest = "Objets de quête",
			questTip = "Éclats supplémentaires sur les objets de quête à votre approche. Désactivé par défaut : l'éclat de butin du jeu en signale déjà la plupart." .. how,
			corpse = "Cadavres avec butin",
			corpseTip = "Fait scintiller un cadavre qui contient encore du butin pour vous, boss compris. Seulement après le combat : le jeu ne permet pas aux addons de changer en combat la plaque de nom à laquelle l'éclat est accroché." .. how,
		};
	end)(),
};

for language, texts in pairs(ns.EXTRA_FLS or {}) do
	TRANSLATIONS[language] = texts;
end

-- English text -> translated text, only for a supported client language
local chosen = TRANSLATIONS[locale];
if chosen then
	local map = {};
	for key, english in pairs(EN) do
		if chosen[key] then
			map[english] = chosen[key];
		end
	end
	ns.FLS = map;
end

-- Setting variable -> translated label and tooltip, so the checkboxes can be
-- found by their setting even where the client keeps no plain name field.
if chosen then
	local VARS = {
		FOREVER_LOOT_SPARKLES_ENABLED = { "enabled", "enabledTip" },
		FOREVER_LOOT_SPARKLES_ORE = { "ore", "oreTip" },
		FOREVER_LOOT_SPARKLES_HERBS = { "herb", "herbTip" },
		FOREVER_LOOT_SPARKLES_QUEST = { "quest", "questTip" },
		FOREVER_LOOT_SPARKLES_CORPSE_LOOT = { "corpse", "corpseTip" },
	};
	local byVar = {};
	for variable, keys in pairs(VARS) do
		byVar[variable] = { name = chosen[keys[1]], tooltip = chosen[keys[2]] };
	end
	ns.FLS_BY_VAR = byVar;
end

-- Texts for this addon's own sparkle checkboxes (Forever Loot Sparkles 2.x
-- no longer has them): the same wording, in the client language.
ns.SPARKLE_TEXT = setmetatable({}, { __index = function(_, key)
	return (chosen and chosen[key]) or EN[key];
end });
