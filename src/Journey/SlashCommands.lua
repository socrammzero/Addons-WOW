--[[ Copyright (C) 2018-2026 TomCat's Gaming, LLC. All Rights Reserved.
     Unauthorized use, reproduction, or distribution is prohibited.
     See license.txt included with this distribution for full terms. ]]
select(2, ...).SetupGlobalFacade()

local slashslug = string.upper(Brand.slashCommand)
local slashCommand = "/" .. Brand.slashCommand

local handlers = {
	show = function()
		State.SetGuideShown(true)
	end,
	hide = function()
		State.SetGuideShown(false)
	end,
	enable = function()
		UI.SetMinimapButtonEnabled(true)
	end,
	disable = function()
		UI.SetMinimapButtonEnabled(false)
	end,
	next = function()
		GuideNavigationService.SetManualOverrideEnabled(true)
		GuideNavigationService.SetStepToNext()
	end,
	back = function()
		GuideNavigationService.SetManualOverrideEnabled(true)
		GuideNavigationService.SetStepToPrevious()
	end,
	["debug on"] = function()
		State.SetDebugEnabled(true)
		DEFAULT_CHAT_FRAME:AddMessage("Joana's Guide: debug on")
		DEFAULT_CHAT_FRAME:AddMessage("Current Step: " .. GuideNavigationService.GetStep().id)
	end,
	["debug off"] = function()
		State.SetDebugEnabled(false)
		DEFAULT_CHAT_FRAME:AddMessage("Joana's Guide: debug off")
	end,
	["validate guides"] = function()
		ValidateAllGuides()
	end,
	goto = function(msg)
		if (msg ~= nil) then
			GuideNavigationService.SetAutoAdvanceEnabled(false)
			GuideNavigationService.SetStep(msg)
		end
	end,
	dev = function()
		if (not DEV_BUILD) then return end
		local enabled = not State.IsDevEnabled()
		State.SetDevEnabled(enabled)
		DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: Dev reload %s", addonTitle, enabled and "|cFF00FF00ON|r" or "|cFFFF0000OFF|r"))
	end,
	blob = function()
		if (not DEV_BUILD) then return end
		if (State.IsDevEnabled()) then ToggleBlobOverlay() end
	end,
	["blob next"] = function()
		if (not DEV_BUILD) then return end
		if (State.IsDevEnabled()) then CycleBlobOverlay() end
	end,
	["way clear"] = function()
		ManualWaypointService.Clear()
	end,
}

local function displayHelp()
	DEFAULT_CHAT_FRAME:AddMessage(string.format("Mostrar la interfaz de la guía: %s show", slashCommand))
	DEFAULT_CHAT_FRAME:AddMessage(string.format("Ocultar la interfaz de la guía: %s hide", slashCommand))
	DEFAULT_CHAT_FRAME:AddMessage(string.format("Activar el botón del minimapa: %s enable", slashCommand))
	DEFAULT_CHAT_FRAME:AddMessage(string.format("Desactivar el botón del minimapa: %s disable", slashCommand))
	DEFAULT_CHAT_FRAME:AddMessage(string.format("Paso siguiente: %s next", slashCommand))
	DEFAULT_CHAT_FRAME:AddMessage(string.format("Paso anterior: %s back", slashCommand))
	if (Brand.hasWebGuides) then
	else
		DEFAULT_CHAT_FRAME:AddMessage(string.format("Ir a un paso en la guía actual: %s goto ##-##", slashCommand))
	end
	DEFAULT_CHAT_FRAME:AddMessage(string.format("Establecer un punto de ruta: %s way <x> <y>", slashCommand))
end

local function handleSlashCommand(msg)
	msg = string.lower(msg)
	if (not handlers[msg]) then
		if (string.sub(msg,1,5)=="goto ") then
			handlers.goto(string.sub(msg, 6))
		elseif (string.sub(msg,1,4)=="way ") then
			ManualWaypointService.HandleCommand(string.sub(msg, 5))
		elseif (msg == "way") then
			ManualWaypointService.HandleCommand("")
		else
			displayHelp()
		end
	else
		handlers[msg]()
	end
end

_G["SLASH_" .. slashslug .. "1"] = slashCommand

SlashCmdList[slashslug] = handleSlashCommand
