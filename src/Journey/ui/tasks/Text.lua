--[[ Copyright (C) 2018-2026 TomCat's Gaming, LLC. All Rights Reserved.
     Unauthorized use, reproduction, or distribution is prohibited.
     See license.txt included with this distribution for full terms. ]]
select(2, ...).SetupGlobalFacade()

local collectWidgets, widgetHandlers

local colorFormat = "|c%s%s|r"

local TaskType = Mixin({
	type = "text",
	disableCompleteIcon = true,
}, TaskTypeMixin)

function TaskType:RenderFunc(task, container)
	container.text:SetIndentedWordWrap(false)
	if (task.icon) then
		task.iconOverride = IconService.GetIconInfo(task.icon)
	end
	local output = { { } }
	local colorTracker = { }
	local overrideColor = task.color or task.parent.color or task.root.color
	if (overrideColor) then
		table.insert(output[1], "|c")
		table.insert(output[1], Color[overrideColor])
		colorTracker[#colorTracker + 1] = "|c" .. Color[overrideColor]
	end
	if (task.text == "multitext") then
		for _, widget in ipairs(task) do
			collectWidgets(widget, output, colorTracker)
		end
		for idx = 2, #output do
			--todo: Reset icon and bounds before use
			local detail = container.taskDetailContainers[idx-1]
			detail:SetAlpha(1.0)
			detail.text:SetText(table.concat(output[idx]))
			detail.hasIcon = false
			detail:SetShown(true)
		end
	else
		table.insert(output[1], L[task.text] or task.text)
	end
	container.text:SetText(table.concat(output[1]))
	container.text:SetShown(true)
end

local function ColorName(idAttribute, color, lookupFunction, hyperlinkFunction)
	return function(widget, output)
		local name
		if (type(widget[idAttribute]) == "number") then
			name = hyperlinkFunction and hyperlinkFunction(widget)
					or (widget.label and (L[widget.label] or widget.label)) or Names.GetName(lookupFunction, widget[idAttribute])
		else
			name = L[widget[idAttribute]] or widget[idAttribute]
		end
		local c = color
		if (type(c) == "function") then
			c = c(widget)
		end
		table.insert(output[#output], colorFormat:format(c, name))
	end
end

local ColorItemName = ColorName("item", Color.ITEM, nil, Hyperlinks.GetItemHyperlink)
local ColorSpellName = ColorName("spell", Color.SPELL, GetSpellInfo, Hyperlinks.GetSpellHyperlink)

local function ColorValue(color, valueAttribute)
	return function(widget, output)
		local val = widget[valueAttribute]
		table.insert(output[#output], colorFormat:format(color, (val and L[val]) or val))
	end
end

local function NewParagraph(output, val)
	if (#output[#output] > 0) then
		output[#output + 1] = { }
	end
	if (val) then
		table.insert(output[#output], L[val] or val)
	end
end

widgetHandlers = {
	area = {
		renderFunc = ColorName("area", Color.AREA, nil, Hyperlinks.GetAreaHyperlink)
	},
	bold = { renderFunc = function(widget, output)
		local val = L[widget.bold] or widget.bold
		table.insert(output[#output], colorFormat:format(Color.BOLD, val))
	end },
	gameobject = { renderFunc = ColorName("gameobject", Color.GAME_OBJECT, nil, Hyperlinks.GetGameObjectHyperlink) },
	getout = { renderFunc = function(widget, output, default)
		local val = L[widget.getout] or widget.getout
		NewParagraph(output, colorFormat:format(Color.GET_OUT, val))
	end},
	icon = { renderFunc = function(widget, output, default)
		table.insert(output[#output], IconService.GetIconText(widget.icon, 10, widget.scale, widget.offsetx, widget.offsety)) --todo: Dynamically scale this with the text resize feature
	end},
	illustration = {
		renderFunc = function(widget, output, default)
			local lbl = (widget.label and L[widget.label]) or widget.label
			table.insert(output[#output], string.format("|cFF00FF00|Himage:%s|h[%s]|h|r", widget.illustration, lbl))
		end
	},
	italic = { renderFunc = function(widget, output)
		local val = L[widget.italic] or widget.italic
		table.insert(output[#output], colorFormat:format(Color.ITALIC, val))
	end },
	item = { renderFunc = function(widget, output, default)
		if (widget.showicon ~= false) then
			local _, _, _, _, icon = GetItemInfoInstant(widget.item)
			if (not icon) then
				icon = 134400
			end
			table.insert(output[#output], string.format("|T%s:14:14:0:0|t ", icon))
		end
		ColorItemName(widget, output, default)
		if (widget.showquantity) then
			local itemCount = GetItemCount(widget.item, false)
			local bankItemCount = GetItemCount(widget.item, true) - itemCount
			if (bankItemCount > 0) then
				local bagFmt = L[" (%s in bags; %s in bank)"] or " (%s en mochilas; %s en banco)"
				table.insert(output[#output], string.format(bagFmt, itemCount, bankItemCount))
			else
				local bagFmt = L[" (%s in bags)"] or " (%s en mochilas)"
				table.insert(output[#output], string.format(bagFmt, itemCount))
			end
		end
	end},
	location = {
		renderFunc = function(widget, output, default)
			local location = LocationsService.GetLocationByIdx(widget.location)
			if (CheckCondition(location)) then
				local template = (widget.template and L[widget.template]) or location:IsActive() and (L["Active"] or "Activo") or "%s"
				table.insert(output[#output], string.format(
						"|c%s|Hlocation:%s|h[%s]|h|r",
						Color.LOCATION,
						widget.location,
						string.format(template, string.format("%.0f.%.0f", location.x, location.y))
				))
			end
		end
	},
	newline = {
		renderFunc = function(widget, output)
			table.insert(output[#output], "\n")
			table.insert(output[#output], (widget.newline and L[widget.newline]) or widget.newline)
		end
	},
	npc = {
		renderFunc = function(widget, output)
			table.insert(output[#output], Hyperlinks.GetNPCHyperlink(widget))
		end
	},
	paragraph = {
		renderFunc = function(widget, output)
			NewParagraph(output, widget.paragraph)
		end
	},
	quest = {
		renderFunc = function(widget, output)
			if (widget.label) then
				local link = Hyperlinks.GetQuestHyperlink(widget, "quest")
				table.insert(output[#output], colorFormat:format(Color.QUEST, link))
			else
				local link = Hyperlinks.GetQuestHyperlink(widget, "quest")
				table.insert(output[#output], "\"")
				table.insert(output[#output], colorFormat:format(Color.QUEST, link))
				table.insert(output[#output], "\"")
			end
		end
	},
	red = { renderFunc = function(widget, output)
		local val = L[widget.red] or (widget.red == "NOTE:" and "NOTA:") or widget.red
		table.insert(output[#output], colorFormat:format(Color.RED_TEXT, val))
	end },
	search = { renderFunc = ColorValue(Color.SEARCH_TERM, "label") },
	skill = { renderFunc = ColorValue(Color.SKILL, "label") },
	skipped = {
		renderFunc = function(widget, output)
			local link = Hyperlinks.GetQuestHyperlink(widget, "skipped")
			table.insert(output[#output], "\"")
			table.insert(output[#output], colorFormat:format(Color.QUEST_SKIPPED, link))
			table.insert(output[#output], "\"")
		end
	},
	spell = { renderFunc = function(widget, output, default)
		if (widget.showicon ~= false) then
			local _, _, icon = GetSpellInfo(widget.spell)
			if (icon) then
				table.insert(output[#output], string.format("|T%s:14:14:0:0|t ", icon))
			end
		end
		ColorSpellName(widget, output, default)
	end},
	spelldesc = { renderFunc = function(widget, output)
		local spell = Spell:CreateFromSpellID(widget.spelldesc)
		local desc = spell:GetSpellDescription()
		if (not desc or desc == "") then
			table.insert(output[#output], "...")
			spell:ContinueOnSpellLoad(function()
				UI.MarkDirty()
			end)
		else
			table.insert(output[#output], desc)
		end
	end},
	target = { renderFunc = nop },
	taxi = {
		renderFunc = ColorName("taxi", Color.TAXI, TaxiService.GetTaxiName)
	},
	tip = {
		renderFunc = function(widget, output)
			local val = L[widget.tip] or (widget.tip == "NOTE:" and "NOTA:") or widget.tip
			NewParagraph(output, colorFormat:format(Color.TIP, val))
		end
	},
	underscore = { renderFunc = ColorValue(Color.UNDERSCORE, "underscore") },
	video = { renderFunc = nop },
	wmoarea = {
		renderFunc = ColorName("wmoarea", Color.WMOAREA, PlacesService.GetWMOAreaName)
	},
	zone = { renderFunc = ColorName("zone", Color.ZONE, nil, Hyperlinks.GetZoneHyperlink) },
}

function collectWidgets(widget, output, colorTracker)
	local outputSize = #output
	if (widget.color) then
		table.insert(output[outputSize], "|c")
		table.insert(output[outputSize], Color[widget.color])
		colorTracker[#colorTracker + 1] = "|c" .. Color[widget.color]
	end
	if (type(widget) == "string") then
		table.insert(output[outputSize], L[widget] or widget)
	else
		-- if it is a known widget, render it
		local widgetFound = false
		for key, widgetHandler in pairs(widgetHandlers) do
			if (widget[key] ~= nil) then
				if (CheckCondition(widget)) then
					widgetHandler.renderFunc(widget, output)
					if (#colorTracker > 0 and outputSize ~= #output) then
						table.insert(output[#output], 1, table.concat(colorTracker))
					end
				end
				widgetFound = true
				break
			end
		end
		-- otherwise traverse the tree
		if (not widgetFound) then
			for k in pairs(widget) do
				if (not (MULTITEXT_IGNORED_KEYS[k] or type(k) == "number")) then
					print("No widget handler found for:" , k)
				end
			end
			if (CheckCondition(widget)) then
				for _, widget_ in ipairs(widget) do
					collectWidgets(widget_, output, colorTracker)
				end
			end
		end
	end
	if (widget.color) then
		table.insert(output[#output], "|r")
		colorTracker[#colorTracker] = nil
	end
end

RegisterTaskType(TaskType)
