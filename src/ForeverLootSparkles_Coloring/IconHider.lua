-- Hides the game's interaction icon (gear, pickaxe, herb leaf, hand ...)
-- that appears over objects and NPCs once Forever Loot Sparkles has switched on the
-- interact key icons for world objects. Forever Loot Sparkles needs that
-- setting, since without it objects get no nameplate to hang the sparkle on,
-- so the setting stays on and only the icon is made invisible (alpha 0) on
-- the nameplates of the chosen kinds. The sparkle itself is not affected.

local _, ns = ...;

ns.ICON_KINDS = { "herb", "ore", "quest", "corpseLoot", "other", "npc" };

local POLL_INTERVAL = 0.2;

local plateUnits = {}; -- nameplate frame -> unit token
local hidden = {};     -- icon frame/texture -> true while we hide it

local function IsIconTexture(texture)
	local ok, file = pcall(texture.GetTexture, texture);
	if ok and file ~= nil and not ns.IsSecret(file) then
		if type(file) == "number" and ns.cursorLookup[file] then
			return true;
		end
		if type(file) == "string" and file:lower():find("cursor", 1, true) then
			return true;
		end
	end
	if texture.GetAtlas then
		local okAtlas, atlas = pcall(texture.GetAtlas, texture);
		if okAtlas and type(atlas) == "string" and not ns.IsSecret(atlas) and atlas:lower():find("cursor", 1, true) then
			return true;
		end
	end
	return false;
end

local function FindIconInRegions(frame, found)
	local ok, regions = pcall(function() return { frame:GetRegions() }; end);
	if not ok then
		return;
	end
	for _, region in ipairs(regions) do
		if region.GetObjectType and region:GetObjectType() == "Texture" and IsIconTexture(region) then
			found[#found + 1] = region;
		end
	end
end

-- The icon objects on one nameplate. Blizzard's nameplates keep it in a
-- SoftTargetFrame; otherwise the textures showing a cursor icon are used.
local function FindIcons(plate)
	local found = {};
	local unitFrame = plate.UnitFrame;
	local holder = (unitFrame and unitFrame.SoftTargetFrame) or plate.SoftTargetFrame;
	if type(holder) == "table" and holder.SetAlpha then
		found[1] = holder;
		local icon = holder.Icon or holder.icon;
		if type(icon) == "table" and icon.SetAlpha then
			found[2] = icon;
		end
		return found;
	end
	for _, frame in ipairs({ plate, unitFrame }) do
		if type(frame) == "table" and frame.GetRegions then
			FindIconInRegions(frame, found);
			local ok, children = pcall(function() return { frame:GetChildren() }; end);
			if ok then
				for _, child in ipairs(children) do
					if child ~= unitFrame then
						FindIconInRegions(child, found);
					end
				end
			end
		end
	end
	return found;
end

local function ShouldHide(kind)
	local db = ns.db;
	if not db then
		return false;
	end
	if db.hideAllIcons then
		return true; -- also when the game won't tell what the unit is
	end
	return kind ~= nil and db.hideIcons[kind] == true;
end

local function AnyHidden()
	local db = ns.db;
	if not db then
		return false;
	end
	if db.hideAllIcons then
		return true;
	end
	for _, kind in ipairs(ns.ICON_KINDS) do
		if db.hideIcons[kind] then
			return true;
		end
	end
	return false;
end

-- Blizzard may set the alpha again (fading, range); put it back to 0 at once
local hooked = {};
local reapplying = false;
local function KeepHidden(icon, alpha)
	if hidden[icon] and alpha ~= 0 and not reapplying then
		reapplying = true;
		pcall(icon.SetAlpha, icon, 0);
		reapplying = false;
	end
end

local function SetIconVisible(icon, visible)
	if not visible and not hooked[icon] and hooksecurefunc then
		hooked[icon] = true;
		pcall(hooksecurefunc, icon, "SetAlpha", KeepHidden);
	end
	if visible then
		if hidden[icon] then
			hidden[icon] = nil;
			pcall(icon.SetAlpha, icon, 1);
		end
	elseif not hidden[icon] or icon:GetAlpha() ~= 0 then
		hidden[icon] = true;
		pcall(icon.SetAlpha, icon, 0);
	end
end

local function UpdatePlate(plate, unit)
	if plate.IsForbidden and plate:IsForbidden() then
		return;
	end
	local hide = ShouldHide(unit and ns.KindOfUnit(unit));
	for _, icon in ipairs(FindIcons(plate)) do
		SetIconVisible(icon, not hide);
	end
end

-- Every visible nameplate, with its unit token where known
local function EachPlate(func)
	local seen = {};
	for plate, unit in pairs(plateUnits) do
		seen[plate] = true;
		func(plate, unit);
	end
	local ok, plates = pcall(C_NamePlate.GetNamePlates);
	if ok and type(plates) == "table" then
		for _, plate in ipairs(plates) do
			if not seen[plate] then
				local token = plate.namePlateUnitToken;
				if type(token) ~= "string" or ns.IsSecret(token) then
					token = nil;
				end
				func(plate, token);
			end
		end
	end
end

local function UpdateAll()
	EachPlate(function(plate, unit)
		pcall(UpdatePlate, plate, unit);
	end);
end

-- /flscolor icons: what the addon sees on each nameplate
function ns.DebugIcons()
	print("|cffffd200Forever Loot Sparkles - Herbs & Ores:|r nameplates");
	local count = 0;
	EachPlate(function(plate, unit)
		count = count + 1;
		local forbidden = plate.IsForbidden and plate:IsForbidden();
		local kind = (not forbidden and unit) and ns.KindOfUnit(unit) or nil;
		local name = unit and ns.SafeCall(UnitName, unit);
		local icons = forbidden and {} or FindIcons(plate);
		local holder = plate.UnitFrame and plate.UnitFrame.SoftTargetFrame;
		print(("  %s  %s  kind=%s  icons=%d  softTargetFrame=%s  forbidden=%s  hide=%s"):format(
			tostring(unit), tostring(name), tostring(kind), #icons, tostring(holder ~= nil),
			tostring(forbidden), tostring(ShouldHide(kind))));
		if not forbidden then
			local keys = {};
			for _, frame in ipairs({ plate, plate.UnitFrame }) do
				if type(frame) == "table" then
					for key, value in pairs(frame) do
						if type(key) == "string" and type(value) == "table" and value.SetAlpha
							and (key:lower():find("soft", 1, true) or key:lower():find("icon", 1, true)) then
							local okShown, shown = pcall(value.IsShown, value);
							local okAlpha, alpha = pcall(value.GetAlpha, value);
							keys[#keys + 1] = ("%s(shown=%s,alpha=%s)"):format(key,
								tostring(okShown and shown), tostring(okAlpha and alpha));
						end
					end
				end
			end
			print("    " .. (#keys > 0 and table.concat(keys, ", ") or "no icon frames"));
		end
	end);
	if count == 0 then
		print("  none");
	end
end

local poller = CreateFrame("Frame");
poller:Hide();
local sinceUpdate = 0;
poller:SetScript("OnUpdate", function(_, elapsed)
	sinceUpdate = sinceUpdate + elapsed;
	if sinceUpdate >= POLL_INTERVAL then
		sinceUpdate = 0;
		UpdateAll();
	end
end);

---------------------------------------------------------------------------
-- NPCs without a nameplate
---------------------------------------------------------------------------

-- Over an NPC that has no nameplate the game draws the icon itself, next to
-- the name in the world, out of reach of addons. Those icons come from the
-- game setting SoftTargetIconInteract, which Forever Loot Sparkles doesn't
-- need, so for NPCs that setting is switched off and the player's value is
-- put back once the option is unticked. Not in combat: cvars can't change then.
local NPC_ICON_CVAR = "SoftTargetIconInteract";
local pendingCVar = false;

local function GetCVarValue(name)
	local ok, value = pcall(C_CVar.GetCVar, name);
	if ok then
		return value;
	end
end

local function SetCVarValue(name, value)
	local current = GetCVarValue(name);
	value = tostring(value);
	if current == nil or current == value then
		return;
	end
	pcall(C_CVar.SetCVar, name, value);
end

local function ApplyNpcCVar()
	local db = ns.db;
	if not (db and C_CVar) then
		return;
	end
	if InCombatLockdown() then
		pendingCVar = true;
		return;
	end
	pendingCVar = false;
	if db.hideAllIcons or db.hideIcons.npc then
		if db.savedNpcIconCVar == nil then
			db.savedNpcIconCVar = GetCVarValue(NPC_ICON_CVAR) or false;
		end
		SetCVarValue(NPC_ICON_CVAR, 0);
	elseif db.savedNpcIconCVar ~= nil then
		if db.savedNpcIconCVar ~= false then
			SetCVarValue(NPC_ICON_CVAR, db.savedNpcIconCVar);
		end
		db.savedNpcIconCVar = nil;
	end
end

-- Called whenever an icon option changes
function ns.IconOptionsChanged()
	ApplyNpcCVar();
	poller:SetShown(AnyHidden());
	UpdateAll();
	if not AnyHidden() then
		for icon in pairs(hidden) do
			SetIconVisible(icon, true);
		end
	end
end

local function GetPlate(unit)
	return C_NamePlate and ns.SafeCall(C_NamePlate.GetNamePlateForUnit, unit);
end

local events = CreateFrame("Frame");
events:SetScript("OnEvent", function(_, event, unit)
	if event == "NAME_PLATE_UNIT_ADDED" then
		local plate = GetPlate(unit);
		if plate then
			plateUnits[plate] = unit;
			if AnyHidden() then
				pcall(UpdatePlate, plate, unit);
			end
		end
	elseif event == "NAME_PLATE_UNIT_REMOVED" then
		local plate = GetPlate(unit);
		if plate then
			plateUnits[plate] = nil;
			for _, icon in ipairs(FindIcons(plate)) do
				SetIconVisible(icon, true); -- the plate goes back to the pool clean
			end
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if pendingCVar then
			ApplyNpcCVar();
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		-- account settings and Forever Loot Sparkles' own restore can arrive late
		ApplyNpcCVar();
	elseif AnyHidden() then
		UpdateAll();
	end
end);
for _, event in ipairs({ "NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED", "PLAYER_SOFT_INTERACT_CHANGED",
	"PLAYER_REGEN_ENABLED", "PLAYER_ENTERING_WORLD" }) do
	pcall(events.RegisterEvent, events, event);
end
