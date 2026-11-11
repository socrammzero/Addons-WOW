-- Puts the German or French texts into Forever Loot Sparkles' options panel
-- without touching its files. Three layers, because clients differ in where
-- the Settings panel reads a checkbox label from:
--   1. the setting object (name field and GetName),
--   2. the layout's initializers (data.name/data.tooltip and GetName/GetTooltip),
--   3. the drawn rows: every row the options list draws is checked once more
--      and an English label still left is replaced.

local _, ns = ...;

local CATEGORY_NAME = "Forever Loot Sparkles";

function ns.FindFLSCategory()
	if not (SettingsPanel and SettingsPanel.GetAllCategories) then
		return nil;
	end
	local ok, categories = pcall(SettingsPanel.GetAllCategories, SettingsPanel);
	if not ok or type(categories) ~= "table" then
		return nil;
	end
	for _, category in ipairs(categories) do
		local okName, name = pcall(category.GetName, category);
		if okName and name == CATEGORY_NAME then
			return category;
		end
	end
end

local function Translate(map, text)
	if type(text) == "string" then
		return map[text];
	end
end

function ns.GetVariable(setting)
	if type(setting) ~= "table" then
		return nil;
	end
	if setting.GetVariable then
		local ok, variable = pcall(setting.GetVariable, setting);
		if ok and type(variable) == "string" then
			return variable;
		end
	end
	return setting.variable;
end

-- Instance fields shadow the mixin methods of this one object only
local function TranslateSetting(setting, entry)
	if type(setting) ~= "table" or not entry or not entry.name then
		return;
	end
	local name = entry.name;
	setting.name = name;
	setting.GetName = function()
		return name;
	end;
end

local function TranslateInitializer(initializer, map)
	local data = initializer.data;
	if type(data) ~= "table" and initializer.GetData then
		local ok, value = pcall(initializer.GetData, initializer);
		data = ok and value or nil;
	end

	local setting = type(data) == "table" and data.setting;
	if not setting and initializer.GetSetting then
		local ok, value = pcall(initializer.GetSetting, initializer);
		setting = ok and value or nil;
	end
	local entry = ns.FLS_BY_VAR and ns.FLS_BY_VAR[ns.GetVariable(setting)];
	TranslateSetting(setting, entry);

	local name = entry and entry.name or (type(data) == "table" and Translate(map, data.name));
	local tooltip = entry and entry.tooltip or (type(data) == "table" and Translate(map, data.tooltip));
	if name then
		if type(data) == "table" then
			data.name = name;
		end
		initializer.GetName = function()
			return name;
		end;
		if initializer.AddSearchTags then
			pcall(initializer.AddSearchTags, initializer, name);
		end
	end
	if tooltip then
		if type(data) == "table" then
			data.tooltip = tooltip;
		end
		initializer.GetTooltip = function()
			return tooltip;
		end;
	end
end

-- Layer 3: labels of rows as they are drawn
local function FixRow(frame, map)
	for _, key in ipairs({ "Text", "Title", "Label" }) do
		local fontString = frame[key];
		if type(fontString) == "table" and fontString.GetText then
			local ok, text = pcall(fontString.GetText, fontString);
			local translated = ok and Translate(map, text);
			if translated then
				fontString:SetText(translated);
			end
		end
	end
end

-- One callback on the options list for every row it draws; used for the
-- translation (layer 3) and for the color swatches (Options.lua).
ns.rowListeners = {};
local rowHookDone = false;
function ns.HookRows()
	if rowHookDone then
		return true;
	end
	local list = SettingsPanel and (SettingsPanel.GetSettingsList and SettingsPanel:GetSettingsList()
		or (SettingsPanel.Container and SettingsPanel.Container.SettingsList));
	local scrollBox = list and list.ScrollBox;
	if not (scrollBox and scrollBox.RegisterCallback and ScrollBoxListMixin and ScrollBoxListMixin.Event) then
		return false;
	end
	local event = ScrollBoxListMixin.Event.OnInitializedFrame;
	if not event then
		return false;
	end
	rowHookDone = true;
	ns.rowScrollBox = scrollBox;
	scrollBox:RegisterCallback(event, function(_, frame, elementData)
		for _, listener in ipairs(ns.rowListeners) do
			pcall(listener, frame, elementData);
		end
	end, ns);
	return true;
end

-- Runs the row listeners again on the rows shown right now
function ns.RefreshRows()
	local scrollBox = ns.rowScrollBox;
	if not (scrollBox and scrollBox.ForEachFrame) then
		return;
	end
	pcall(scrollBox.ForEachFrame, scrollBox, function(frame, elementData)
		for _, listener in ipairs(ns.rowListeners) do
			pcall(listener, frame, elementData);
		end
	end);
end

function ns.TranslateFLS()
	local map = ns.FLS;
	if not map then
		return; -- English or an unsupported client language
	end

	if Settings and Settings.GetSetting and ns.FLS_BY_VAR then
		for variable, entry in pairs(ns.FLS_BY_VAR) do
			local ok, setting = pcall(Settings.GetSetting, variable);
			if ok then
				TranslateSetting(setting, entry);
			end
		end
	end

	local category = ns.FindFLSCategory();
	if category and SettingsPanel.GetLayout then
		local ok, layout = pcall(SettingsPanel.GetLayout, SettingsPanel, category);
		local initializers;
		if ok and type(layout) == "table" and layout.GetInitializers then
			local okList, list = pcall(layout.GetInitializers, layout);
			initializers = okList and list;
		end
		if type(initializers) == "table" then
			for _, initializer in ipairs(initializers) do
				pcall(TranslateInitializer, initializer, map);
			end
		end
	end

	table.insert(ns.rowListeners, function(frame)
		FixRow(frame, map);
	end);
end
