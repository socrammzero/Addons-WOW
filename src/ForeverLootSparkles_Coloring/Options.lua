-- Options. Normally everything goes onto Forever Loot Sparkles' own page:
-- a color swatch to the right of each sparkle checkbox (Herbs, Ore veins,
-- Quest objects, Corpses with loot) and, below them, a "Colors" section with
-- an on/off checkbox and a reset button. If that page or the needed Settings
-- API can't be found, a separate page is used instead.
-- Slash command: /flscolor (prints where the options are; /flscolor icons for debugging)

local ADDON_NAME, ns = ...;
local L = ns.L;

local panel = CreateFrame("Frame");
panel:Hide();
local swatches = {}; -- swatch -> true
local enableBox;
local iconBoxes = {};
local settingsCategory;

local function UpdateSwatches()
	for swatch in pairs(swatches) do
		local c = swatch.key and ns.db.colors[swatch.key];
		if c then
			swatch.color:SetColorTexture(c[1], c[2], c[3]);
		end
	end
	if enableBox then
		enableBox:SetChecked(ns.db.enabled);
	end
	for _, box in ipairs(iconBoxes) do
		box.refresh();
	end
end

local function OpenColorPicker(key)
	local color = ns.db.colors[key];
	local previous = { color[1], color[2], color[3] };
	local function Apply(r, g, b)
		color[1], color[2], color[3] = r, g, b;
		ns.ColorsChanged();
		UpdateSwatches();
	end
	local function OnPick()
		Apply(ColorPickerFrame:GetColorRGB());
	end
	local function OnCancel()
		Apply(previous[1], previous[2], previous[3]);
	end

	if ColorPickerFrame.SetupColorPickerAndShow then
		ColorPickerFrame:SetupColorPickerAndShow({
			r = color[1], g = color[2], b = color[3],
			hasOpacity = false,
			swatchFunc = OnPick,
			cancelFunc = OnCancel,
		});
	else
		ColorPickerFrame:Hide();
		ColorPickerFrame.hasOpacity = false;
		ColorPickerFrame.opacityFunc = nil;
		ColorPickerFrame.previousValues = previous;
		ColorPickerFrame.func = OnPick;
		ColorPickerFrame.cancelFunc = OnCancel;
		ColorPickerFrame:SetColorRGB(color[1], color[2], color[3]);
		ShowUIPanel(ColorPickerFrame);
	end
end

-- A color button; swatch.key says which category it shows
local function NewSwatch(parent)
	local swatch = CreateFrame("Button", nil, parent);
	swatch:SetSize(26, 26);

	local border = swatch:CreateTexture(nil, "BACKGROUND");
	border:SetAllPoints();
	border:SetColorTexture(0.85, 0.85, 0.85);

	local inner = swatch:CreateTexture(nil, "BORDER");
	inner:SetPoint("TOPLEFT", 2, -2);
	inner:SetPoint("BOTTOMRIGHT", -2, 2);
	inner:SetColorTexture(0, 0, 0);

	local color = swatch:CreateTexture(nil, "ARTWORK");
	color:SetPoint("TOPLEFT", 3, -3);
	color:SetPoint("BOTTOMRIGHT", -3, 3);
	swatch.color = color;
	swatch.border, swatch.inner = border, inner;

	local highlight = swatch:CreateTexture(nil, "HIGHLIGHT");
	highlight:SetAllPoints();
	highlight:SetColorTexture(1, 1, 1, 0.25);
	swatch.highlight = highlight;

	swatch:SetScript("OnClick", function(self)
		if self.key then
			OpenColorPicker(self.key);
		end
	end);
	swatch:SetScript("OnEnter", function(self)
		if not self.key then
			return;
		end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetText(L[self.key], 1, 1, 1);
		GameTooltip:AddLine(L.SWATCH_TOOLTIP, nil, nil, nil, true);
		GameTooltip:Show();
	end);
	swatch:SetScript("OnLeave", GameTooltip_Hide);
	return swatch;
end

local function SetSwatchKey(swatch, key)
	swatch.key = key;
	swatches[swatch] = true;
	local c = ns.db.colors[key];
	swatch.color:SetColorTexture(c[1], c[2], c[3]);
end

local function CreateSwatch(key, anchor, offsetX, offsetY)
	local label = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
	label:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", offsetX, offsetY);
	label:SetWidth(200);
	label:SetJustifyH("LEFT");
	label:SetText(L[key]);

	local swatch = NewSwatch(panel);
	swatch:SetPoint("LEFT", label, "RIGHT", 10, 0);
	SetSwatchKey(swatch, key);
	return label;
end

local function BuildPanel()
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
	title:SetPoint("TOPLEFT", 16, -16);
	title:SetText(L.TITLE);

	local description = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
	description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8);
	description:SetPoint("RIGHT", panel, "RIGHT", -24, 0);
	description:SetJustifyH("LEFT");
	description:SetText(L.DESCRIPTION);

	enableBox = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate");
	enableBox:SetPoint("TOPLEFT", description, "BOTTOMLEFT", -4, -12);
	local boxLabel = enableBox.Text or enableBox.text;
	if not boxLabel then
		boxLabel = enableBox:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
		boxLabel:SetPoint("LEFT", enableBox, "RIGHT", 2, 0);
	end
	boxLabel:SetFontObject("GameFontHighlight");
	boxLabel:SetText(L.ENABLE);
	enableBox:SetScript("OnClick", function(self)
		ns.db.enabled = self:GetChecked() and true or false;
		ns.ColorsChanged();
	end);
	enableBox:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetText(L.ENABLE, 1, 1, 1);
		GameTooltip:AddLine(L.ENABLE_TOOLTIP, nil, nil, nil, true);
		GameTooltip:Show();
	end);
	enableBox:SetScript("OnLeave", GameTooltip_Hide);

	-- Rows in the order the user asked for
	local anchor = CreateSwatch("herb", enableBox, 4, -14);
	anchor = CreateSwatch("ore", anchor, 0, -16);
	anchor = CreateSwatch("quest", anchor, 0, -16);
	anchor = CreateSwatch("corpseLoot", anchor, 0, -16);

	local reset = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate");
	reset:SetSize(180, 24);
	reset:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", -2, -22);
	reset:SetText(L.RESET);
	reset:SetScript("OnClick", function()
		ns.ResetColors();
		ns.ColorsChanged();
		UpdateSwatches();
	end);

	local note = panel:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall");
	note:SetPoint("TOPLEFT", reset, "BOTTOMLEFT", 2, -18);
	note:SetPoint("RIGHT", panel, "RIGHT", -24, 0);
	note:SetJustifyH("LEFT");
	note:SetText(L.NOTE);

	local iconTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal");
	iconTitle:SetPoint("TOPLEFT", note, "BOTTOMLEFT", 0, -20);
	iconTitle:SetText(L.ICONS_HEADER);
	local previous = iconTitle;
	local function AddBox(label, tooltip, get, set)
		local box = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate");
		box:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", previous == iconTitle and -4 or 0, -4);
		local text = box.Text or box.text;
		if not text then
			text = box:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
			text:SetPoint("LEFT", box, "RIGHT", 2, 0);
		end
		text:SetFontObject("GameFontHighlight");
		text:SetText(label);
		box:SetScript("OnClick", function(self)
			set(self:GetChecked() and true or false);
			ns.IconOptionsChanged();
			UpdateSwatches();
		end);
		box:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			GameTooltip:SetText(label, 1, 1, 1);
			GameTooltip:AddLine(tooltip, nil, nil, nil, true);
			GameTooltip:Show();
		end);
		box:SetScript("OnLeave", GameTooltip_Hide);
		box.refresh = function()
			local dim = box.iconKind and ns.db.hideAllIcons;
			box:SetChecked(dim or get());
			box:SetAlpha(dim and 0.4 or 1);
			if dim then
				box:Disable();
			else
				box:Enable();
			end
		end;
		iconBoxes[#iconBoxes + 1] = box;
		previous = box;
		return box;
	end
	if ns.modern then
		local T = ns.SPARKLE_TEXT;
		local function Bool(key, after)
			return function() return ns.db[key]; end,
				function(value)
					ns.db[key] = value;
					after(value);
				end;
		end
		local function Sparkle(value)
			ns.SparkleOptionChanged(value);
		end
		AddBox(T.herb, T.herbTip, Bool("sparkleHerbs", Sparkle));
		AddBox(T.ore, T.oreTip, Bool("sparkleOre", Sparkle));
		AddBox(T.quest, T.questTip, Bool("sparkleQuest", Sparkle));
		AddBox(T.corpse, T.corpseTip, Bool("sparkleCorpseLoot", Sparkle));
		AddBox(L.SAFE_CAST, L.SAFE_CAST_TOOLTIP, Bool("safeSelfCast", function() ns.SafeSelfCastChanged(); end));
		AddBox(L.HIDE_PLATE, L.HIDE_PLATE_TOOLTIP, Bool("hidePlate", function() ns.HidePlateChanged(); end));
	end
	AddBox(L.ICONS_ALL, L.ICONS_ALL_TOOLTIP,
		function() return ns.db.hideAllIcons; end,
		function(value) ns.db.hideAllIcons = value; end);
	for _, kind in ipairs(ns.ICON_KINDS) do
		local box = AddBox(L[kind], (kind == "other" and L.ICONS_OTHER_TOOLTIP) or (kind == "npc" and L.ICONS_NPC_TOOLTIP) or L.ICONS_TOOLTIP,
			function() return ns.db.hideIcons[kind]; end,
			function(value) ns.db.hideIcons[kind] = value; end);
		box.iconKind = true;
	end

	panel:SetScript("OnShow", UpdateSwatches);
end

-- Methods the Settings panel may call on a canvas frame
function panel:OnCommit() end
function panel:OnRefresh()
	UpdateSwatches();
end
function panel:OnDefault()
	ns.ResetColors();
	ns.db.enabled = true;
	ns.ColorsChanged();
	UpdateSwatches();
end

local function RegisterSeparatePanel()
	BuildPanel();
	local parent = ns.FindFLSCategory();
	if parent and Settings.RegisterCanvasLayoutSubcategory then
		local ok, sub = pcall(Settings.RegisterCanvasLayoutSubcategory, parent, panel, L.PANEL_NAME);
		if ok and sub then
			settingsCategory = sub;
			return;
		end
	end
	settingsCategory = Settings.RegisterCanvasLayoutCategory(panel, L.TITLE);
	Settings.RegisterAddOnCategory(settingsCategory);
end

---------------------------------------------------------------------------
-- On Forever Loot Sparkles' own page
---------------------------------------------------------------------------

local SWATCH_FOR_VARIABLE = {
	FOREVER_LOOT_SPARKLES_COLORING_HERBS = "herb",
	FOREVER_LOOT_SPARKLES_COLORING_ORE = "ore",
	FOREVER_LOOT_SPARKLES_COLORING_QUEST = "quest",
	FOREVER_LOOT_SPARKLES_COLORING_CORPSE_LOOT = "corpseLoot",
	FOREVER_LOOT_SPARKLES_HERBS = "herb",
	FOREVER_LOOT_SPARKLES_ORE = "ore",
	FOREVER_LOOT_SPARKLES_QUEST = "quest",
	FOREVER_LOOT_SPARKLES_CORPSE_LOOT = "corpseLoot",
};

local function RowVariable(frame, elementData)
	local initializer = elementData;
	if type(initializer) ~= "table" and frame.GetElementData then
		local ok, value = pcall(frame.GetElementData, frame);
		initializer = ok and value or nil;
	end
	local setting;
	if type(initializer) == "table" then
		if initializer.GetSetting then
			local ok, value = pcall(initializer.GetSetting, initializer);
			setting = ok and value or nil;
		end
		if not setting and type(initializer.data) == "table" then
			setting = initializer.data.setting;
		end
	end
	return ns.GetVariable(setting);
end

-- Rows are recycled across all option pages: show the swatch only on ours
-- Gives a texture the same art as another (atlas or file with its coordinates)
local function CopyLook(target, source)
	if type(source) ~= "table" then
		return false;
	end
	local okAtlas, atlas = pcall(source.GetAtlas, source);
	if okAtlas and type(atlas) == "string" and atlas ~= "" then
		target:SetAtlas(atlas);
		return true;
	end
	local okFile, file = pcall(source.GetTexture, source);
	if okFile and file then
		target:SetTexture(file);
		pcall(function() target:SetTexCoord(source:GetTexCoord()); end);
		return true;
	end
	return false;
end

-- Same size and frame as the checkbox next to it; the color fills the inside
local function StyleLikeCheckbox(swatch, checkbox)
	if swatch.styled or not checkbox then
		return;
	end
	swatch.styled = true;
	local width, height = checkbox:GetSize();
	if not (width and width > 0) then
		return;
	end
	swatch:SetSize(width, height);
	local normal = checkbox.GetNormalTexture and checkbox:GetNormalTexture();
	if not CopyLook(swatch.border, normal) then
		return;
	end
	swatch.border:SetVertexColor(1, 1, 1, 1);
	swatch.inner:Hide();
	local inset = math.floor(width * 0.22 + 0.5);
	swatch.color:ClearAllPoints();
	swatch.color:SetPoint("TOPLEFT", inset, -inset);
	swatch.color:SetPoint("BOTTOMRIGHT", -inset, inset);
	local highlight = checkbox.GetHighlightTexture and checkbox:GetHighlightTexture();
	if CopyLook(swatch.highlight, highlight) then
		swatch.highlight:SetVertexColor(1, 1, 1, 1);
		swatch.highlight:SetBlendMode("ADD");
	end
end

local function DecorateRow(frame, elementData)
	local key = SWATCH_FOR_VARIABLE[RowVariable(frame, elementData) or ""];
	local swatch = frame.FLSColoringSwatch;
	if not key then
		if swatch then
			swatch:Hide();
		end
		return;
	end
	if not swatch then
		swatch = NewSwatch(frame);
		frame.FLSColoringSwatch = swatch;
	end
	swatch:ClearAllPoints();
	local checkbox = frame.Checkbox or frame.CheckBox;
	if checkbox then
		StyleLikeCheckbox(swatch, checkbox);
		swatch:SetPoint("LEFT", checkbox, "RIGHT", 14, 0);
	else
		swatch:SetPoint("RIGHT", frame, "RIGHT", -20, 0);
	end
	SetSwatchKey(swatch, key);
	swatch:Show();
end

-- While "Hide all" is ticked the single icon checkboxes have no effect:
-- they are shown greyed out and can't be clicked.
local ICON_VARIABLE_PREFIX = "FOREVER_LOOT_SPARKLES_COLORING_HIDE_ICON_";
local function KindOfIconVariable(variable)
	if type(variable) ~= "string" or variable:sub(1, #ICON_VARIABLE_PREFIX) ~= ICON_VARIABLE_PREFIX then
		return nil;
	end
	local suffix = variable:sub(#ICON_VARIABLE_PREFIX + 1);
	for _, kind in ipairs(ns.ICON_KINDS) do
		if kind:upper() == suffix then
			return kind;
		end
	end
end

-- Greyed out rows show a tick, since "Hide all" covers them; the saved
-- single choices are kept and come back when "Hide all" is unticked.
local function DimIconRow(frame, elementData)
	local kind = KindOfIconVariable(RowVariable(frame, elementData));
	local checkbox = frame.Checkbox or frame.CheckBox;
	if kind and ns.db.hideAllIcons then
		frame.FLSColoringDimmed = true;
		frame:SetAlpha(0.4);
		if checkbox then
			if checkbox.SetChecked then
				checkbox:SetChecked(true);
			end
			if checkbox.Disable then
				checkbox:Disable();
			end
		end
	elseif frame.FLSColoringDimmed then
		frame.FLSColoringDimmed = nil;
		frame:SetAlpha(1);
		if checkbox then
			if checkbox.Enable then
				checkbox:Enable();
			end
			if kind and checkbox.SetChecked then
				checkbox:SetChecked(ns.db.hideIcons[kind] == true);
			end
		end
	end
end

local function RegisterInline()
	local category = ns.FindFLSCategory();
	if not (category and ns.HookRows and ns.HookRows()
		and Settings.RegisterInitializer and Settings.RegisterAddOnSetting and Settings.CreateCheckbox
		and CreateSettingsListSectionHeaderInitializer and CreateSettingsButtonInitializer) then
		return false;
	end

	table.insert(ns.rowListeners, DecorateRow);
	table.insert(ns.rowListeners, DimIconRow);

	-- Forever Loot Sparkles 2.x: the sparkles now come from this addon
	if ns.modern then
		local T = ns.SPARKLE_TEXT;
		Settings.RegisterInitializer(category, CreateSettingsListSectionHeaderInitializer(T.header));
		local function AddSparkleBox(variable, key, label, tooltip, onChanged, default)
			local sparkleSetting = Settings.RegisterAddOnSetting(category, variable, key, ns.db,
				Settings.VarType.Boolean, label, default);
			sparkleSetting:SetValueChangedCallback(onChanged);
			Settings.CreateCheckbox(category, sparkleSetting, tooltip);
		end
		local function OnSparkleChanged(_, value)
			ns.SparkleOptionChanged(value);
		end
		local D = ns.SPARKLE_DEFAULTS;
		AddSparkleBox("FOREVER_LOOT_SPARKLES_COLORING_HERBS", "sparkleHerbs", T.herb, T.herbTip, OnSparkleChanged, D.sparkleHerbs);
		AddSparkleBox("FOREVER_LOOT_SPARKLES_COLORING_ORE", "sparkleOre", T.ore, T.oreTip, OnSparkleChanged, D.sparkleOre);
		AddSparkleBox("FOREVER_LOOT_SPARKLES_COLORING_QUEST", "sparkleQuest", T.quest, T.questTip, OnSparkleChanged, D.sparkleQuest);
		AddSparkleBox("FOREVER_LOOT_SPARKLES_COLORING_CORPSE_LOOT", "sparkleCorpseLoot", T.corpse, T.corpseTip, OnSparkleChanged, D.sparkleCorpseLoot);
		AddSparkleBox("FOREVER_LOOT_SPARKLES_COLORING_SAFE_CAST", "safeSelfCast", L.SAFE_CAST, L.SAFE_CAST_TOOLTIP,
			function() ns.SafeSelfCastChanged(); end, true);
		AddSparkleBox("FOREVER_LOOT_SPARKLES_COLORING_HIDE_PLATE", "hidePlate", L.HIDE_PLATE, L.HIDE_PLATE_TOOLTIP,
			function() ns.HidePlateChanged(); end, true);
	end

	Settings.RegisterInitializer(category, CreateSettingsListSectionHeaderInitializer(L.PANEL_NAME));

	local setting = Settings.RegisterAddOnSetting(category, "FOREVER_LOOT_SPARKLES_COLORING_ENABLED", "enabled",
		ns.db, Settings.VarType.Boolean, L.ENABLE, true);
	setting:SetValueChangedCallback(function()
		ns.ColorsChanged();
	end);
	Settings.CreateCheckbox(category, setting, L.ENABLE_TOOLTIP .. "\n\n" .. L.NOTE);

	local reset = CreateSettingsButtonInitializer("", L.RESET, function()
		ns.ResetColors();
		ns.ColorsChanged();
		UpdateSwatches();
	end, nil, false);
	Settings.RegisterInitializer(category, reset);

	-- Interaction icons
	Settings.RegisterInitializer(category, CreateSettingsListSectionHeaderInitializer(L.ICONS_HEADER));
	local function AddIconBox(variable, key, tbl, label, tooltip)
		local iconSetting = Settings.RegisterAddOnSetting(category, variable, key, tbl,
			Settings.VarType.Boolean, label, false);
		iconSetting:SetValueChangedCallback(function()
			ns.IconOptionsChanged();
			if ns.RefreshRows then
				ns.RefreshRows();
			end
		end);
		Settings.CreateCheckbox(category, iconSetting, tooltip);
	end
	AddIconBox("FOREVER_LOOT_SPARKLES_COLORING_HIDE_ALL_ICONS", "hideAllIcons", ns.db, L.ICONS_ALL, L.ICONS_ALL_TOOLTIP);
	for _, kind in ipairs(ns.ICON_KINDS) do
		AddIconBox("FOREVER_LOOT_SPARKLES_COLORING_HIDE_ICON_" .. kind:upper(), kind, ns.db.hideIcons, L[kind],
			(kind == "other" and L.ICONS_OTHER_TOOLTIP) or (kind == "npc" and L.ICONS_NPC_TOOLTIP) or L.ICONS_TOOLTIP);
	end

	settingsCategory = category;
	return true;
end

local function RegisterPanel()
	local ok, done = pcall(RegisterInline);
	if not (ok and done) then
		RegisterSeparatePanel();
	end
end

SLASH_FLSCOLOR1 = "/flscolor";
SlashCmdList.FLSCOLOR = function(message)
	if type(message) == "string" and message:lower():find("icon", 1, true) then
		ns.DebugIcons();
		return;
	end
	-- Settings.OpenToCategory is blocked for addons in this client
	-- (ADDON_ACTION_BLOCKED on OpenSettingsPanel). Showing the panel
	-- directly and picking the page avoids that function; if the panel
	-- doesn't open, only say where the options are.
	if not InCombatLockdown() and SettingsPanel and settingsCategory then
		pcall(ShowUIPanel, SettingsPanel);
		if SettingsPanel:IsShown() then
			if SettingsPanel.SelectCategory then
				pcall(SettingsPanel.SelectCategory, SettingsPanel, settingsCategory);
			end
			return;
		end
	end
	print("|cffffd200Forever Loot Sparkles - Hierbas y minerales:|r " .. L.OPEN_HINT);
end

-- Forever Loot Sparkles 2.x dropped the herb/ore/corpse/quest sparkles;
-- with it this addon draws them itself. With 1.x only its glints are colored.
local function IsFLSModern()
	local getMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata;
	if getMetadata then
		local ok, version = pcall(getMetadata, "ForeverLootSparkles", "Version");
		local major = ok and type(version) == "string" and tonumber(version:match("(%d+)"));
		if major then
			return major >= 2;
		end
	end
	-- 1.x fills in its sparkle options when it loads, 2.x deletes them
	local flsDB = ForeverLootSparklesDB;
	return not (type(flsDB) == "table" and flsDB.sparkleOre ~= nil);
end

local loader = CreateFrame("Frame");
loader:RegisterEvent("ADDON_LOADED");
loader:RegisterEvent("PLAYER_LOGIN");
loader:SetScript("OnEvent", function(self, event, name)
	if event == "ADDON_LOADED" then
		if name == ADDON_NAME then
			self:UnregisterEvent("ADDON_LOADED");
			ns.InitDB();
			ns.modern = IsFLSModern();
			if ns.modern then
				ns.SparkleInit(ns.db);
			end
		end
		return;
	end
	-- PLAYER_LOGIN: every addon has loaded, so Forever Loot Sparkles has
	-- registered its options panel by now.
	self:UnregisterEvent("PLAYER_LOGIN");
	if not ns.db then
		ns.InitDB();
	end
	ns.HookRows();
	ns.TranslateFLS();
	RegisterPanel();
	if not ns.modern then
		ns.StartColoring();
	end
	ns.IconOptionsChanged();
end);
