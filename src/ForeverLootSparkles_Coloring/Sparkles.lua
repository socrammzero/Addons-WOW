-- Sparkles on ore veins, herbs, quest objects and corpses that still hold
-- loot, as you approach them.
-- Blizzard's soft targeting always picks one interaction target (the
-- "softinteract" unit) and can give it a nameplate. A small cluster of glints,
-- modelled on the quest loot sparkle, is hung on that nameplate. The object
-- type comes from its cursor icon, its state from the interact range check.
-- Adapted from the Lueur addon by the same author.
--
-- Taken over from Forever Loot Sparkles 1.3.1 (SoftTarget.lua, GPL-3.0-or-later),
-- which removed this feature in 2.0.0. Changes in this addon:
--  * glints take the color chosen per category (Coloring options);
--  * soft targeting is paused in combat and while it has picked a living
--    unit, so spells cast without a target don't land on that unit
--    (Forever Loot Sparkles issue #10, option "safeSelfCast");
--  * the nameplate the sparkle hangs on can be made invisible, so corpses
--    don't show an empty health bar (#12, option "hidePlate");
--  * cvars are only touched once Forever Loot Sparkles 2.x has finished
--    putting its own old values back after login.

local ADDON_NAME, ns = ...;

local SOFT = "softinteract";
local TEXTURE = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Textures\\flare";
local FALLBACK_TEXTURE = "Interface\\Cooldown\\star4";

-- Option key per object category; ore and herbs get no sparkle from the game,
-- quest objects already do while the loot sparkle is on, so they default off.
local CATEGORY_OPTIONS = {
	ore = "sparkleOre",
	herb = "sparkleHerbs",
	quest = "sparkleQuest",
	corpseLoot = "sparkleCorpseLoot",
	footlocker = "sparkleFootlocker",
};
local DEFAULTS = {
	sparkleOre = true,
	sparkleHerbs = true,
	sparkleQuest = false,
	sparkleCorpseLoot = true,
	sparkleFootlocker = true,
};

-- Footlockers rogues can pick open, by game object ID (from the GUID). The
-- English name is a fallback for IDs not listed here.
local FOOTLOCKER_IDS = {
	[179486] = true, [179487] = true, [179488] = true, [179490] = true, -- Waterlogged, Battered
	[179496] = true, -- Dented
	[179498] = true, -- Scarlet
	[405633] = true, -- Rockjaw
	[656157] = true, -- Syndicate
};

local RANGE = 60;          -- soft target range in yards, asked as high as Lueur tried; Forever still drops the target past ~15
local ARC = 2;             -- 0 = straight ahead, 1 = in front, 2 = all around
local OFFSET_Y = -45;      -- from the nameplate down to the object (pixels)
local SPREAD = 46;         -- radius the glints appear in (pixels)
local GLINT_SIZE = 34;
local GLINT_COUNT = 7;
local GOLD = { 1, 0.88, 0.52 };
local GREY = { 0.62, 0.62, 0.62 };

local POLL_INTERVAL = 0.12; -- re-check of target and state (seconds)
local FADE_IN = 0.35;
local BLEND_TIME = 0.30;    -- fade between states
local STATE_DELAY = 0.15;   -- a state must hold this long before it shows (no flicker at the range edge)
local LOCK_DELAY = 0.60;    -- same for "locked", confirmed more carefully

-- Cvars this module changes; their original values are saved and put back
-- once every category is switched off.
local MANAGED_CVARS = {
	"SoftTargetInteract", "SoftTargetNameplateInteract", "SoftTargetInteractRange",
	"SoftTargetInteractArc", "SoftTargetInteractOnlyInRange", "SoftTargetIconGameObject",
};


-- Cursor files (Interface\Cursor\*.blp) -> category
local CURSOR_CATEGORY = {
	Mine = "ore",
	GatherHerbs = "herb",
	Quest = "quest", QuestRepeatable = "quest", QuestTurnIn = "quest",
	Interact = "other", PickLock = "other", LootAll = "other", Pickup = "other",
};

-- The client returns a fileID, a path (Interface\Cursor\Mine) or an atlas name
-- (Cursor_Crosshair_UnableMine_64), so keywords are searched in the string.
local CURSOR_KEYWORDS = {
	{ "gather", "herb" },
	{ "mine", "ore" },
	{ "quest", "quest" },
	{ "lootall", "other" },
	{ "pickup", "other" },
	{ "picklock", "other" },
	{ "interact", "other" },
};

local db;
local ready = false;         -- cvars are left alone until Forever Loot Sparkles has restored its own
local gateOpen;             -- is the game's own target nameplate on? nil = apply again
local pendingCVars = false; -- "apply" or "restore" once combat ends
local pendingForce = false; -- the pending "apply" also switches the interact key on
local directWorks = false;  -- GetNamePlateForUnit("softinteract") has worked for an object
local activeUnits = {};     -- nameplateN token -> true
local cursorLookup = {};    -- fileID -> { category, greyed out }
local questTexts = {};      -- unfinished objectives, lower case without counters
local questsDirty = true;

local sparkle = {};         -- the one sparkle frame and its animation state

local sin, cos, sqrt, random, min, max, pi = math.sin, math.cos, math.sqrt, math.random, math.min, math.max, math.pi;

local function IsSecret(value)
	return issecretvalue ~= nil and issecretvalue(value);
end

-- Calls that touch other units can error or return secret values; both count as "unknown"
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

local function Lerp(a, b, t)
	return a + (b - a) * t;
end

local function Approach(value, target, step)
	if value < target then
		return min(value + step, target);
	end
	return max(value - step, target);
end

local function IsActive()
	if not db then
		return false;
	end
	for _, key in pairs(CATEGORY_OPTIONS) do
		if db[key] then
			return true;
		end
	end
	return false;
end

---------------------------------------------------------------------------
-- Cvars
---------------------------------------------------------------------------

local function GetCVarValue(name)
	local ok, value = pcall(C_CVar.GetCVar, name);
	if ok then
		return value;
	end
end

-- Only touches cvars this client knows, and only when the value changes:
-- CVAR_UPDATE is synchronous, so every write runs Blizzard's handlers tainted
-- by this addon (seen as a GetAuraDataByIndex taint error from Edit Mode)
local function SetCVarValue(name, value)
	local current = GetCVarValue(name);
	value = tostring(value);
	if current == nil or current == value then
		return;
	end
	pcall(C_CVar.SetCVar, name, value);
end

-- The game's nameplate on the interaction target, which the sparkle hangs on.
-- It is only switched on for objects that get a sparkle, so NPCs, mailboxes
-- and the like still work with the interact key without a nameplate popping up.
local function SetGate(open)
	if open == gateOpen or InCombatLockdown() then
		return;
	end
	gateOpen = open;
	SetCVarValue("SoftTargetNameplateInteract", open and 1 or 0);
end

local Evaluate;

-- SoftTargetInteract ("Enable Interact Key") and SoftTargetIconGameObject (part
-- of "Interact Key Icons") are the player's settings too. They are switched on
-- when the sparkles start and whenever a sparkle option is switched on (force);
-- at login a player who switched them off afterwards keeps them off.
local function ApplyCVars(force)
	if InCombatLockdown() then
		pendingCVars = "apply";
		pendingForce = pendingForce or force == true;
		return;
	end
	db.savedCVars = db.savedCVars or {};
	if db.savedCVars.SoftTargetInteract == nil or db.savedCVars.SoftTargetIconGameObject == nil then
		force = true;
	end
	for _, name in ipairs(MANAGED_CVARS) do
		if db.savedCVars[name] == nil then
			db.savedCVars[name] = GetCVarValue(name) or false;
		end
	end
	if force then
		paused, db.pausedInteract = nil, nil;
		SetCVarValue("SoftTargetInteract", 3);      -- interaction soft target always on
		SetCVarValue("SoftTargetIconGameObject", 1); -- world objects get a nameplate
	end
	SetCVarValue("SoftTargetInteractRange", RANGE);
	SetCVarValue("SoftTargetInteractArc", ARC);
	SetCVarValue("SoftTargetInteractOnlyInRange", 0); -- also find objects outside interact range
	gateOpen = nil;
	Evaluate();
end

local function RestoreCVars()
	if InCombatLockdown() then
		pendingCVars = "restore";
		return;
	end
	paused = nil;
	db.pausedInteract = nil;
	if not db.savedCVars then
		return;
	end
	for name, value in pairs(db.savedCVars) do
		if value ~= false then
			SetCVarValue(name, value);
		end
	end
	db.savedCVars = nil;
	gateOpen = nil;
end

---------------------------------------------------------------------------
-- Pausing soft targeting (safe self-cast)
---------------------------------------------------------------------------

-- Spells cast without a target can land on the soft interact target when it
-- is a living unit (a player or NPC next to you). Only objects and corpses
-- need it for the sparkle, so soft targeting is switched off in combat and as
-- soon as it picks a living unit, and back on once you have moved a few yards
-- (or after a few seconds where the game won't give your position). The value
-- it had is kept in db.pausedInteract, so a logout during a pause can't leave
-- it off.
local RESUME_DISTANCE = 5; -- yards
local RESUME_TIME = 3;     -- seconds, without a position
local paused;              -- nil, "unit" or "combat"
local pausedAt, pausedY, pausedX;

local function PlayerPosition()
	if not UnitPosition then
		return nil;
	end
	local ok, y, x = pcall(UnitPosition, "player");
	if ok and type(y) == "number" and type(x) == "number" and not IsSecret(y) and not IsSecret(x) then
		return y, x;
	end
end

local function Pause(reason)
	if paused then
		if reason == "combat" then
			paused = "combat";
		end
		return;
	end
	if InCombatLockdown() then
		return;
	end
	local current = GetCVarValue("SoftTargetInteract");
	if current == nil or current == "0" then
		return;
	end
	db.pausedInteract = current;
	paused = reason;
	pausedAt = GetTime();
	pausedY, pausedX = PlayerPosition();
	SetCVarValue("SoftTargetInteract", 0);
end

local function Resume()
	if InCombatLockdown() then
		return;
	end
	paused = nil;
	if db.pausedInteract ~= nil then
		if GetCVarValue("SoftTargetInteract") == "0" then
			SetCVarValue("SoftTargetInteract", db.pausedInteract);
		end
		db.pausedInteract = nil;
	end
	gateOpen = nil;
end

local function ReadyToResume()
	local y, x = PlayerPosition();
	if y and pausedY then
		local dy, dx = y - pausedY, x - pausedX;
		return dy * dy + dx * dx >= RESUME_DISTANCE * RESUME_DISTANCE;
	end
	return GetTime() - pausedAt >= RESUME_TIME;
end

local function IsLivingUnit(unit)
	return SafeCall(UnitIsDead, unit) == false and SafeCall(UnitExists, unit) == true;
end

---------------------------------------------------------------------------
-- Classification
---------------------------------------------------------------------------

local probe = UIParent:CreateTexture(nil, "BACKGROUND"); -- hidden, reads the cursor icon
probe:Hide();

if GetFileIDFromPath then
	for name, category in pairs(CURSOR_CATEGORY) do
		for _, prefix in ipairs({ "", "Unable" }) do
			local path = "Interface\\Cursor\\" .. prefix .. name;
			local id = SafeCall(GetFileIDFromPath, path) or SafeCall(GetFileIDFromPath, path .. ".blp");
			if id then
				cursorLookup[id] = { category, prefix ~= "" };
			end
		end
	end
end

local function NormalizeText(text)
	text = text:lower():gsub("\194\160", " "); -- non-breaking space
	text = text:gsub("\226\128\153", "'");     -- typographic apostrophe
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

-- Is the object's name part of an unfinished objective ("Soaked Saw: 0/1"), or
-- the objective part of its name ("Supplies" in "Crate of Supplies")?
local function MatchesObjective(name)
	if type(name) ~= "string" or #name < 4 then
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

local function IsQuestRelated(unit, name)
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
	return MatchesObjective(name);
end

-- Category and "greyed out" flag (Unable variant: can't interact right now) of a cursor name
local function ReadCursorName(name)
	if type(name) ~= "string" then
		return nil;
	end
	name = name:lower();
	local blocked = name:find("unable", 1, true) ~= nil;
	for _, entry in ipairs(CURSOR_KEYWORDS) do
		if name:find(entry[1], 1, true) then
			return entry[2], blocked;
		end
	end
	return nil, blocked;
end

-- Returns the object's category and whether its cursor is greyed out
local function Classify(unit, name)
	local category, blocked;
	if SafeCall(SetUnitCursorTexture, probe, unit, nil, true) then
		local texture = probe:GetTexture();
		local atlas = probe.GetAtlas and probe:GetAtlas();
		if IsSecret(texture) then
			texture = nil;
		end
		if IsSecret(atlas) then
			atlas = nil;
		end
		local known = type(texture) == "number" and cursorLookup[texture];
		if known then
			category, blocked = known[1], known[2];
		else
			category, blocked = ReadCursorName(texture);
			if not category then
				local fromAtlas, atlasBlocked = ReadCursorName(atlas);
				category, blocked = fromAtlas, blocked or atlasBlocked;
			end
		end
	end
	if category ~= "ore" and category ~= "herb" and IsQuestRelated(unit, name) then
		category = "quest";
	end
	return category, blocked or false;
end

-- Does the corpse still hold loot this character may take? pcall instead of
-- SafeCall: both return values are needed.
local function HasLootLeft(unit)
	local guid = SafeCall(UnitGUID, unit);
	if not (guid and CanLootUnit) then
		return false;
	end
	local ok, hasLoot, canLoot = pcall(CanLootUnit, guid);
	if not ok or IsSecret(hasLoot) or IsSecret(canLoot) then
		return false;
	end
	return hasLoot == true and canLoot ~= false;
end

-- UnitIsCorpse is false for dead mobs (checked in the client), UnitIsDead isn't
local function IsCorpseWithLoot(unit)
	return SafeCall(UnitIsDead, unit) == true and HasLootLeft(unit);
end

-- "ready": can interact; "far": too far; "locked": in range but the game
-- refuses (skill too low, object locked …)
local function ReadState(unit, blocked)
	local inRange = UnitIsInInteractRange and SafeCall(UnitIsInInteractRange, unit);
	if inRange == false then
		return "far";
	end
	if blocked then
		return inRange == true and "locked" or "far";
	end
	return "ready";
end

-- Game object ID from a GUID like "GameObject-0-1-2-3-179488-0000"
local function ObjectID(unit)
	local guid = SafeCall(UnitGUID, unit);
	if type(guid) ~= "string" then
		return nil;
	end
	local kind, _, _, _, _, id = strsplit("-", guid);
	if kind == "GameObject" then
		return tonumber(id);
	end
end

local function IsFootlocker(unit, name)
	local id = ObjectID(unit);
	if id and FOOTLOCKER_IDS[id] then
		return true;
	end
	return type(name) == "string" and not IsSecret(name) and name:lower():find("footlocker", 1, true) ~= nil;
end

---------------------------------------------------------------------------
-- Target
---------------------------------------------------------------------------

local function GetNamePlate(unit)
	return C_NamePlate and SafeCall(C_NamePlate.GetNamePlateForUnit, unit);
end

-- true, false, or nil when the client won't say (secret values). A world
-- object does not "exist" as far as UnitExists is concerned.
local function SoftTargetExists()
	local isUnit, isObject = SafeCall(UnitExists, SOFT), SafeCall(UnitIsGameObject, SOFT);
	if isUnit == true or isObject == true then
		return true;
	end
	if isUnit == false and isObject == false then
		return false;
	end
	return nil;
end

-- Returns the unit token to query, its nameplate (nil if the game doesn't show
-- it, or not yet) and, without a readable target, whether that is for lack of
-- knowing. Until "softinteract" has given the nameplate of a world object on
-- this client, the visible nameplates are searched as well.
local function ResolveTarget()
	local exists = SoftTargetExists();
	if exists == false then
		return nil;
	end
	local plate = GetNamePlate(SOFT);
	if plate then
		if not directWorks and SafeCall(UnitIsGameObject, SOFT) == true then
			directWorks = true;
		end
		return SOFT, plate;
	end
	if not directWorks then
		for unit in pairs(activeUnits) do
			if SafeCall(UnitIsGameObject, unit) == true or SafeCall(UnitIsUnit, unit, SOFT) == true then
				plate = GetNamePlate(unit);
				if plate then
					return unit, plate;
				end
			end
		end
	end
	if exists then
		return SOFT, nil;
	end
	return nil, nil, true;
end

---------------------------------------------------------------------------
-- Sparkle
---------------------------------------------------------------------------

-- Places a glint somewhere new in a flattened disc, after a short dark pause
local function Respawn(glint, now)
	local angle, reach = random() * 2 * pi, sqrt(random());
	glint.x, glint.y = cos(angle) * reach * SPREAD, sin(angle) * reach * SPREAD * 0.75;
	glint.life = 0.6 + 0.8 * random();
	glint.scale = 0.5 + 0.7 * random();
	glint.angle = random() * 2 * pi;
	glint.turn = (random() - 0.5) * 2;
	glint.age = now and 0 or -0.6 * random();
end

local function Animate(self, elapsed)
	if elapsed > 0.1 then
		elapsed = 0.1; -- no jump after a frame freeze
	end
	sparkle.appear = Approach(sparkle.appear, 1, elapsed / FADE_IN);
	sparkle.ready = Approach(sparkle.ready, sparkle.state == "ready" and 1 or 0, elapsed / BLEND_TIME);
	sparkle.locked = Approach(sparkle.locked, sparkle.state == "locked" and 1 or 0, elapsed / BLEND_TIME);

	local ready, locked = sparkle.ready, sparkle.locked;
	-- dimmer and calmer out of range, grey and slow on a locked object
	local alpha = sparkle.appear * Lerp(0.55, 1, ready) * (1 - 0.55 * locked);
	local speed = Lerp(0.8, 1.2, ready) * (1 - 0.5 * locked);
	local base = GOLD;
	if db.enabled and sparkle.category and db.colors and db.colors[sparkle.category] then
		base = db.colors[sparkle.category];
	end
	local r = Lerp(base[1], GREY[1], locked);
	local g = Lerp(base[2], GREY[2], locked);
	local b = Lerp(base[3], GREY[3], locked);

	for _, glint in ipairs(sparkle.glints) do
		glint.age = glint.age + elapsed * speed;
		if glint.age >= glint.life then
			Respawn(glint);
		end
		local shine = glint.age > 0 and sin(pi * glint.age / glint.life) or 0;
		local texture = glint.texture;
		texture:SetPoint("CENTER", self, "CENTER", glint.x, glint.y + 10 * max(glint.age, 0));
		local size = max(GLINT_SIZE * glint.scale * (0.35 + 0.65 * shine), 0.01);
		texture:SetSize(size, size);
		texture:SetRotation(glint.angle + glint.turn * max(glint.age, 0));
		texture:SetVertexColor(r, g, b, min(alpha * shine, 1));
	end
end

local function CreateSparkle()
	local frame = CreateFrame("Frame");
	frame:SetSize(1, 1);
	frame:Hide();
	sparkle.glints = {};
	for i = 1, GLINT_COUNT do
		local texture = frame:CreateTexture(nil, "OVERLAY");
		if texture:SetTexture(TEXTURE) == false then
			texture:SetTexture(FALLBACK_TEXTURE);
		end
		texture:SetBlendMode("ADD");
		texture:SetVertexColor(1, 1, 1, 0);
		if texture.SetSnapToPixelGrid then
			texture:SetSnapToPixelGrid(false);
			texture:SetTexelSnappingBias(0);
		end
		sparkle.glints[i] = { texture = texture };
	end
	frame:SetScript("OnUpdate", Animate);
	sparkle.frame = frame;
	return frame;
end

-- The nameplate's own content (health bar, name, icon) under the sparkle.
-- The sparkle frame ignores its parent's alpha, so it stays visible.
local veiled;          -- the UnitFrame made invisible, if any
local reveiling = false;
local veilHooked = {};
local function KeepVeiled(frame, alpha)
	if frame == veiled and alpha ~= 0 and not reveiling then
		reveiling = true;
		pcall(frame.SetAlpha, frame, 0);
		reveiling = false;
	end
end

local function Unveil()
	if veiled then
		local frame = veiled;
		veiled = nil;
		pcall(frame.SetAlpha, frame, 1);
	end
end

local function Veil(plate)
	Unveil();
	local frame = db.hidePlate and plate and plate.UnitFrame;
	if type(frame) ~= "table" or not frame.SetAlpha then
		return;
	end
	if not veilHooked[frame] and hooksecurefunc then
		veilHooked[frame] = true;
		pcall(hooksecurefunc, frame, "SetAlpha", KeepVeiled);
	end
	veiled = frame;
	pcall(frame.SetAlpha, frame, 0);
end

local function Release()
	Unveil();
	if not sparkle.anchor then
		return;
	end
	sparkle.frame:Hide();
	sparkle.frame:ClearAllPoints();
	sparkle.frame:SetParent(nil);
	sparkle.anchor, sparkle.retarget = nil, nil;
end

local function Attach(plate, state, category)
	local frame = sparkle.frame or CreateSparkle();
	sparkle.category = category;
	Veil(plate);
	frame:SetParent(plate);
	-- below the nameplate content, so its text stays readable
	local ok, level = pcall(plate.GetFrameLevel, plate);
	if ok and level and not IsSecret(level) then
		frame:SetFrameLevel(max(level - 1, 0));
	end
	frame:ClearAllPoints();
	frame:SetPoint("CENTER", plate, "CENTER", 0, OFFSET_Y);
	frame:SetIgnoreParentAlpha(true);

	sparkle.anchor = plate;
	sparkle.state, sparkle.pending = state, nil;
	sparkle.ready = state == "ready" and 1 or 0;
	sparkle.locked = state == "locked" and 1 or 0;
	sparkle.appear = 0;
	for _, glint in ipairs(sparkle.glints) do
		Respawn(glint);
	end
	frame:Show();
end

-- A new state only shows once it is stable
local function ProposeState(state)
	if state == sparkle.state then
		sparkle.pending = nil;
		return;
	end
	local now = GetTime();
	if sparkle.pending ~= state then
		sparkle.pending, sparkle.pendingSince = state, now;
	elseif now - sparkle.pendingSince >= (state == "locked" and LOCK_DELAY or STATE_DELAY) then
		sparkle.pending = nil;
		sparkle.state = state;
		if state == "ready" then
			-- every glint starts over at once: the "in range" burst
			for _, glint in ipairs(sparkle.glints) do
				Respawn(glint, true);
			end
		end
	end
end

-- Finds the current interaction target, then brings the game's nameplate (on
-- only for objects that get a sparkle) and the sparkle itself in line with it
function Evaluate()
	if not ready then
		return;
	end
	if not IsActive() then
		Release();
		return;
	end
	local unit, plate, unknown = ResolveTarget();
	if not unit then
		SetGate(unknown == true); -- when in doubt, let the game show its target
		Release();
		return;
	end

	-- world objects sparkle, and of the units only corpses with loot left
	local category, blocked;
	if SafeCall(UnitIsGameObject, unit) == true then
		local name = SafeCall(UnitName, unit);
		category, blocked = Classify(unit, name);
		if IsFootlocker(unit, name) then
			category = "footlocker"; -- "blocked" from the lockpicking cursor: grey when the skill is too low
		end
	elseif db.sparkleCorpseLoot and IsCorpseWithLoot(unit) then
		category, blocked = "corpseLoot", false;
	else
		SetGate(false);
		Release();
		if db.safeSelfCast and IsLivingUnit(unit) then
			Pause("unit");
		end
		return;
	end
	local option = CATEGORY_OPTIONS[category];
	local wanted = option ~= nil and db[option] == true;
	SetGate(wanted);
	if not wanted or not plate then
		-- without a plate it has just been asked for; the sparkle follows when it arrives
		Release();
		return;
	end

	local state = ReadState(unit, blocked);
	if sparkle.anchor ~= plate or sparkle.retarget then
		Release();
		Attach(plate, state, category);
	else
		sparkle.category = category;
		ProposeState(state);
	end
end

---------------------------------------------------------------------------
-- Events and options
---------------------------------------------------------------------------

local function Refresh(force)
	if IsActive() then
		ApplyCVars(force);
	else
		Release();
		RestoreCVars();
	end
end

local poller = CreateFrame("Frame");
poller:Hide();
local sinceCheck = 0;
poller:SetScript("OnUpdate", function(_, elapsed)
	sinceCheck = sinceCheck + elapsed;
	if sinceCheck >= POLL_INTERVAL then
		sinceCheck = 0;
		if paused == "unit" and ReadyToResume() then
			Resume();
		end
		Evaluate();
	end
end);

local function UpdatePoller()
	poller:SetShown(ready and IsActive());
end

local handlers = {};

-- Forever Loot Sparkles 2.x puts its old soft targeting values back at login
-- and once more 5 seconds later. This module starts after that.
local START_DELAY = 6;
local startTimer = CreateFrame("Frame");
startTimer:Hide();
local startAt;
startTimer:SetScript("OnUpdate", function(self)
	if GetTime() < startAt then
		return;
	end
	if ForeverLootSparklesDB and ForeverLootSparklesDB.savedCVars and GetTime() < startAt + 30 then
		return; -- its restore hasn't run yet (combat): wait for it
	end
	self:Hide();
	ready = true;
	-- a pause left over from the last session (logout while paused)
	if db.pausedInteract ~= nil and not InCombatLockdown() then
		Resume();
	end
	if IsActive() then
		ApplyCVars();
	end
	UpdatePoller();
end);

function handlers.PLAYER_LOGIN()
	startAt = GetTime() + START_DELAY;
	startTimer:Show();
end

-- Account-synced settings can arrive after PLAYER_LOGIN and overwrite ours
function handlers.VARIABLES_LOADED()
	if ready and IsActive() then
		ApplyCVars();
	end
end
handlers.PLAYER_ENTERING_WORLD = handlers.VARIABLES_LOADED;

-- Cvars can't change in combat: close the nameplate just before. Left open, every
-- lootable corpse would keep a 0% health nameplate until the fight ends; the
-- price is that nodes don't sparkle during combat.
function handlers.PLAYER_REGEN_DISABLED()
	if ready and IsActive() then
		SetGate(false);
		Release();
		if db.safeSelfCast then
			Pause("combat");
		end
	end
end

function handlers.PLAYER_REGEN_ENABLED()
	if pendingCVars == "apply" then
		ApplyCVars(pendingForce);
	elseif pendingCVars == "restore" then
		RestoreCVars();
	end
	pendingCVars, pendingForce = false, false;
	if paused == "combat" then
		Resume();
	end
	Evaluate();
end

function handlers.NAME_PLATE_UNIT_ADDED(unit)
	activeUnits[unit] = true;
	Evaluate();
end

function handlers.NAME_PLATE_UNIT_REMOVED(unit)
	activeUnits[unit] = nil;
	local plate = GetNamePlate(unit);
	if plate and plate == sparkle.anchor then
		Release();
	end
end

function handlers.PLAYER_SOFT_INTERACT_CHANGED(oldTarget, newTarget)
	-- a nameplate recycled from one target to the next doesn't show the change by itself
	if not IsSecret(oldTarget) and not IsSecret(newTarget) and oldTarget and newTarget and oldTarget ~= newTarget then
		sparkle.retarget = sparkle.anchor ~= nil;
	end
	Evaluate();
end

function handlers.QUEST_LOG_UPDATE()
	questsDirty = true;
end

local events = CreateFrame("Frame");
events:SetScript("OnEvent", function(_, event, ...)
	if db then
		handlers[event](...);
	end
end);
for event in pairs(handlers) do
	pcall(events.RegisterEvent, events, event);
end

---------------------------------------------------------------------------
-- /flscolor target: what the addon sees on the current interaction target
---------------------------------------------------------------------------

function ns.DebugTarget()
	local function out(...)
		local parts = {};
		for i = 1, select("#", ...) do
			parts[#parts + 1] = tostring((select(i, ...)));
		end
		print("  " .. table.concat(parts, " "));
	end
	print("|cffffd200Forever Loot Sparkles - Herbs & Ores:|r interaction target");
	out("ready=", ready, "active=", db and IsActive(), "paused=", paused, "gate=", gateOpen);
	out("cvars: Interact=", GetCVarValue("SoftTargetInteract"), "IconGameObject=", GetCVarValue("SoftTargetIconGameObject"),
		"NameplateInteract=", GetCVarValue("SoftTargetNameplateInteract"), "Range=", GetCVarValue("SoftTargetInteractRange"));
	local unit, plate, unknown = ResolveTarget();
	out("unit=", unit, "plate=", plate ~= nil, "unknown=", unknown);
	local u = unit or SOFT;
	local name = SafeCall(UnitName, u);
	local guid = SafeCall(UnitGUID, u);
	out("name=", name, "guid=", guid, "objectID=", ObjectID(u));
	out("gameObject=", SafeCall(UnitIsGameObject, u), "exists=", SafeCall(UnitExists, u), "dead=", SafeCall(UnitIsDead, u));
	local texture, atlas;
	if SafeCall(SetUnitCursorTexture, probe, u, nil, true) then
		texture = probe:GetTexture();
		atlas = probe.GetAtlas and probe:GetAtlas();
	end
	out("cursor texture=", texture, "atlas=", atlas);
	local category, blocked = Classify(u, name);
	out("classified=", category, "blocked=", blocked, "footlocker=", IsFootlocker(u, name),
		"option=", db and db.sparkleFootlocker);
	out("sparkle shown=", sparkle.frame and sparkle.frame:IsShown(), "category=", sparkle.category);
end

---------------------------------------------------------------------------
-- Interface for Options.lua
---------------------------------------------------------------------------

ns.SPARKLE_DEFAULTS = DEFAULTS;

-- Called at ADDON_LOADED with this addon's saved variables
function ns.SparkleInit(savedVariables)
	db = savedVariables;
	for key, value in pairs(DEFAULTS) do
		if db[key] == nil then
			db[key] = value;
		end
	end
	if db.safeSelfCast == nil then
		db.safeSelfCast = true;
	end
	if db.hidePlate == nil then
		db.hidePlate = true;
	end
	UpdatePoller();
end

-- A sparkle checkbox changed (value: its new state)
function ns.SparkleOptionChanged(value)
	if not ready then
		return;
	end
	Refresh(value == true);
	UpdatePoller();
end

function ns.SafeSelfCastChanged()
	if not db.safeSelfCast and paused then
		Resume();
	end
end

function ns.HidePlateChanged()
	if db.hidePlate and sparkle.anchor then
		Veil(sparkle.anchor);
	else
		Unveil();
	end
end
