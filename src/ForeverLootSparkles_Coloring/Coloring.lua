-- Recolors the glints of Forever Loot Sparkles per object category.
--
-- Forever Loot Sparkles keeps everything local: one unnamed frame with seven
-- additive textures, hung on the soft target's nameplate, recolored every
-- frame in its OnUpdate (gold, blending to grey on a locked object). This
-- addon finds that frame once among the nameplates' children, adds a post
-- hook to its OnUpdate and repaints the textures right after the original,
-- keeping its alpha and its grey blend. The category of the object is worked
-- out again here, the same way the original does it (cursor icon, quest
-- objectives, corpse). Classification code adapted from Forever Loot
-- Sparkles' SoftTarget.lua (GPL-3.0-or-later).

local _, ns = ...;

local SOFT = "softinteract";
local GOLD = { 1, 0.88, 0.52 }; -- the original's colors, used to read back its grey blend
local GREY = { 0.62, 0.62, 0.62 };
local RECLASSIFY_INTERVAL = 0.5;
local SEARCH_INTERVAL = 0.25;

ns.CATEGORIES = { "herb", "ore", "quest", "corpseLoot" };
ns.DEFAULT_COLORS = {
	herb = { 0.35, 1.00, 0.35 },
	ore = { 1.00, 0.55, 0.20 },
	quest = { 1.00, 0.88, 0.52 },
	corpseLoot = { 0.75, 0.50, 1.00 },
};

local db;
local sparkleFrame;
local glints;
local current = { plate = nil, category = nil, at = 0, dirty = true };

local min, max = math.min, math.max;

---------------------------------------------------------------------------
-- Saved variables
---------------------------------------------------------------------------

function ns.InitDB()
	ForeverLootSparklesColoringDB = ForeverLootSparklesColoringDB or {};
	db = ForeverLootSparklesColoringDB;
	if db.enabled == nil then
		db.enabled = true;
	end
	db.colors = db.colors or {};
	for key, color in pairs(ns.DEFAULT_COLORS) do
		local saved = db.colors[key];
		if type(saved) ~= "table" or type(saved[1]) ~= "number" then
			db.colors[key] = { color[1], color[2], color[3] };
		end
	end
	db.hideIcons = type(db.hideIcons) == "table" and db.hideIcons or {};
	for _, key in ipairs({ "herb", "ore", "quest", "corpseLoot", "other", "npc" }) do
		if db.hideIcons[key] == nil then
			db.hideIcons[key] = false;
		end
	end
	if db.hideAllIcons == nil then
		db.hideAllIcons = false;
	end
	ns.db = db;
	return db;
end

function ns.ResetColors()
	for key, color in pairs(ns.DEFAULT_COLORS) do
		db.colors[key] = { color[1], color[2], color[3] };
	end
end

---------------------------------------------------------------------------
-- Classification (same rules as Forever Loot Sparkles)
---------------------------------------------------------------------------

local function IsSecret(value)
	return issecretvalue ~= nil and issecretvalue(value);
end

local function SafeCall(func, ...)
	if not func then
		return nil;
	end
	local ok, result = pcall(func, ...);
	if not ok or IsSecret(result) then
		return nil;
	end
	return result;
end

local CURSOR_CATEGORY = {
	Mine = "ore",
	GatherHerbs = "herb",
	Quest = "quest", QuestRepeatable = "quest", QuestTurnIn = "quest",
	Interact = "other", PickLock = "other", LootAll = "other", Pickup = "other",
};

local CURSOR_KEYWORDS = {
	{ "gather", "herb" },
	{ "mine", "ore" },
	{ "quest", "quest" },
	{ "lootall", "other" },
	{ "pickup", "other" },
	{ "picklock", "other" },
	{ "interact", "other" },
};

local cursorLookup = {};
ns.cursorLookup = cursorLookup;
if GetFileIDFromPath then
	for name, category in pairs(CURSOR_CATEGORY) do
		for _, prefix in ipairs({ "", "Unable" }) do
			local path = "Interface\\Cursor\\" .. prefix .. name;
			local id = SafeCall(GetFileIDFromPath, path) or SafeCall(GetFileIDFromPath, path .. ".blp");
			if id then
				cursorLookup[id] = category;
			end
		end
	end
end

local probe = UIParent:CreateTexture(nil, "BACKGROUND");
probe:Hide();

local questTexts = {};
local questsDirty = true;

local function NormalizeText(text)
	text = text:lower():gsub("\194\160", " ");
	text = text:gsub("\226\128\153", "'");
	text = text:gsub("%d+%s*/%s*%d+", "");
	text = text:gsub("^[%s:%-]+", ""):gsub("[%s:%-]+$", "");
	return text;
end

local function RebuildQuestTexts()
	questsDirty = false;
	wipe(questTexts);
	if not (C_QuestLog and C_QuestLog.GetQuestObjectives) then
		return;
	end
	local modern = C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetQuestIDForLogIndex;
	for index = 1, SafeCall(modern and C_QuestLog.GetNumQuestLogEntries or GetNumQuestLogEntries) or 0 do
		local questID;
		if modern then
			questID = SafeCall(C_QuestLog.GetQuestIDForLogIndex, index);
		elseif GetQuestLogTitle then
			local ok, _, _, _, isHeader, _, _, _, id = pcall(GetQuestLogTitle, index);
			if ok and not isHeader then
				questID = id;
			end
		end
		local objectives = type(questID) == "number" and SafeCall(C_QuestLog.GetQuestObjectives, questID);
		if type(objectives) == "table" then
			for _, objective in ipairs(objectives) do
				local text = objective.text;
				if not objective.finished and type(text) == "string" and not IsSecret(text) then
					text = NormalizeText(text);
					if #text >= 4 then
						questTexts[#questTexts + 1] = text;
					end
				end
			end
		end
	end
end

local function MatchesObjective(name)
	if type(name) ~= "string" or IsSecret(name) or #name < 4 then
		return false;
	end
	if questsDirty then
		RebuildQuestTexts();
	end
	name = NormalizeText(name);
	for _, text in ipairs(questTexts) do
		if text:find(name, 1, true) or (#text >= 5 and name:find(text, 1, true)) then
			return true;
		end
	end
	return false;
end

local QUEST_LINE_TYPE = Enum and Enum.TooltipDataLineType and Enum.TooltipDataLineType.QuestObjective;

local function IsQuestRelated(unit)
	if C_QuestLog and C_QuestLog.UnitIsRelatedToActiveQuest
		and SafeCall(C_QuestLog.UnitIsRelatedToActiveQuest, unit) == true then
		return true;
	end
	if QUEST_LINE_TYPE and C_TooltipInfo and C_TooltipInfo.GetUnit then
		local data = SafeCall(C_TooltipInfo.GetUnit, unit);
		if data and data.lines then
			for _, line in ipairs(data.lines) do
				if line.type == QUEST_LINE_TYPE then
					return true;
				end
			end
		end
	end
	return MatchesObjective(SafeCall(UnitName, unit));
end

local function ReadCursorName(name)
	if type(name) ~= "string" then
		return nil;
	end
	name = name:lower();
	for _, entry in ipairs(CURSOR_KEYWORDS) do
		if name:find(entry[1], 1, true) then
			return entry[2];
		end
	end
end

local function ClassifyObject(unit)
	local category;
	if SafeCall(SetUnitCursorTexture, probe, unit, nil, true) then
		local texture = probe:GetTexture();
		local atlas = probe.GetAtlas and probe:GetAtlas();
		if IsSecret(texture) then
			texture = nil;
		end
		if IsSecret(atlas) then
			atlas = nil;
		end
		category = (type(texture) == "number" and cursorLookup[texture])
			or ReadCursorName(texture) or ReadCursorName(atlas);
	end
	if category ~= "ore" and category ~= "herb" and IsQuestRelated(unit) then
		category = "quest";
	end
	return category;
end

-- The unit whose nameplate carries the sparkle
local function UnitForPlate(plate)
	if C_NamePlate and SafeCall(C_NamePlate.GetNamePlateForUnit, SOFT) == plate then
		return SOFT;
	end
	local token = plate and plate.namePlateUnitToken;
	if type(token) == "string" and not IsSecret(token) then
		return token;
	end
	return SOFT;
end

-- Forever Loot Sparkles only puts glints on world objects and on corpses
-- with loot, so a unit that isn't a world object is a corpse.
local function Classify(plate)
	local unit = UnitForPlate(plate);
	if SafeCall(UnitIsGameObject, unit) == true then
		return ClassifyObject(unit);
	end
	if SafeCall(UnitIsDead, unit) == true then
		return "corpseLoot";
	end
	return nil;
end

-- Kind of any unit for the icon options: herb, ore, quest, corpseLoot,
-- other (any other world object), npc (a living unit: vendor, trainer ...)
function ns.KindOfUnit(unit)
	if SafeCall(UnitIsGameObject, unit) == true then
		local kind = ClassifyObject(unit);
		if kind == "herb" or kind == "ore" or kind == "quest" then
			return kind;
		end
		return "other";
	end
	if SafeCall(UnitIsDead, unit) == true then
		return "corpseLoot";
	end
	if SafeCall(UnitExists, unit) == true then
		return "npc";
	end
	return nil;
end

ns.SafeCall = SafeCall;
ns.IsSecret = IsSecret;

---------------------------------------------------------------------------
-- Painting
---------------------------------------------------------------------------

local function PostAnimate(self)
	if not db or not db.enabled then
		return;
	end
	local plate = self:GetParent();
	if not plate then
		return;
	end
	local now = GetTime();
	if plate ~= current.plate or current.dirty or now - current.at >= RECLASSIFY_INTERVAL then
		current.plate, current.dirty, current.at = plate, false, now;
		current.category = Classify(plate);
	end
	local color = current.category and db.colors[current.category];
	if not color then
		return; -- unknown category: leave the original gold
	end

	-- How far the original has blended toward grey ("locked" state), read from
	-- its red channel: gold 1.0 -> grey 0.62.
	local r0 = glints[1]:GetVertexColor();
	local locked = 0;
	if type(r0) == "number" and not IsSecret(r0) then
		locked = min(max((GOLD[1] - r0) / (GOLD[1] - GREY[1]), 0), 1);
	end
	local r = color[1] + (GREY[1] - color[1]) * locked;
	local g = color[2] + (GREY[2] - color[2]) * locked;
	local b = color[3] + (GREY[3] - color[3]) * locked;

	for i = 1, #glints do
		local texture = glints[i];
		local _, _, _, a = texture:GetVertexColor();
		texture:SetVertexColor(r, g, b, a or 1);
	end
end

---------------------------------------------------------------------------
-- Finding Forever Loot Sparkles' frame
---------------------------------------------------------------------------

local function IsSparkleFrame(frame)
	if frame.IsForbidden and frame:IsForbidden() then
		return false;
	end
	if frame:GetObjectType() ~= "Frame" or frame:GetNumRegions() ~= 7 or not frame:GetScript("OnUpdate") then
		return false;
	end
	local regions = { frame:GetRegions() };
	local named = false;
	for _, region in ipairs(regions) do
		if region:GetObjectType() ~= "Texture" or region:GetBlendMode() ~= "ADD" then
			return false;
		end
		local texture = region:GetTexture();
		if type(texture) == "string" and not IsSecret(texture) then
			local lower = texture:lower();
			if lower:find("foreverlootsparkles", 1, true) or lower:find("star4", 1, true) then
				named = true;
			end
		end
	end
	if named then
		return true, regions;
	end
	-- Texture path not readable: the frame is 1x1 and anchored 45 px below the plate
	local width, height = frame:GetSize();
	if width and width <= 1.01 and height and height <= 1.01 then
		return true, regions;
	end
	return false;
end

local function Adopt(frame, regions)
	sparkleFrame, glints = frame, regions;
	frame:HookScript("OnUpdate", PostAnimate);
	current.dirty = true;
	ns.searcher:Hide();
end

local function Search()
	if sparkleFrame or not (C_NamePlate and C_NamePlate.GetNamePlates) then
		return;
	end
	local ok, plates = pcall(C_NamePlate.GetNamePlates);
	if not ok or type(plates) ~= "table" then
		return;
	end
	for _, plate in ipairs(plates) do
		local okChildren, children = pcall(function() return { plate:GetChildren() }; end);
		if okChildren then
			for _, child in ipairs(children) do
				local okCheck, isSparkle, regions = pcall(IsSparkleFrame, child);
				if okCheck and isSparkle then
					Adopt(child, regions);
					return;
				end
			end
		end
	end
end

-- Runs until the frame is found once; Forever Loot Sparkles reuses it for good
local searcher = CreateFrame("Frame");
searcher:Hide();
ns.searcher = searcher;
local sinceSearch = 0;
searcher:SetScript("OnUpdate", function(self, elapsed)
	sinceSearch = sinceSearch + elapsed;
	if sinceSearch >= SEARCH_INTERVAL then
		sinceSearch = 0;
		Search();
	end
end);

function ns.StartColoring()
	if not sparkleFrame then
		searcher:Show();
	end
end

function ns.ColorsChanged()
	current.dirty = true;
end

local events = CreateFrame("Frame");
events:SetScript("OnEvent", function(_, event)
	if event == "QUEST_LOG_UPDATE" then
		questsDirty = true;
	end
	current.dirty = true;
end);
for _, event in ipairs({ "QUEST_LOG_UPDATE", "PLAYER_SOFT_INTERACT_CHANGED", "NAME_PLATE_UNIT_ADDED" }) do
	pcall(events.RegisterEvent, events, event);
end
