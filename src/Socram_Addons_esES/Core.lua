local ADDON_NAME = ...
local PREFIX = "SOCRAM_ADDONS_ES"
local THROTTLE_SECONDS = 20

local myBuild = tonumber(SocramAddonsEsES_Build) or 1
local lastBroadcast = { GUILD = 0, PARTY = 0, RAID = 0, INSTANCE_CHAT = 0 }
local notifiedThisSession = false
local popupFrame
local quickButton

local function getShortName(fullName)
    if type(fullName) ~= "string" then return nil end
    return (fullName:gsub("%-[^%-]*$", ""))
end

local function playerFullName()
    if not UnitName then return nil end
    local name, surname = UnitName("player")
    if name and surname and surname ~= "" then
        return name .. " " .. surname
    end
    return name
end

local function isSelf(sender)
    local me = playerFullName()
    if not me or not sender then return false end
    return getShortName(sender) == me
end

local function printMsg(text)
    if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
        DEFAULT_CHAT_FRAME:AddMessage("|cffE5A93C[Socram Addons esES]|r " .. tostring(text))
    end
end

local function sendVersionToChannel(channel)
    if not (C_ChatInfo and C_ChatInfo.SendAddonMessage) then return end
    local now = GetTime and GetTime() or 0
    if (now - (lastBroadcast[channel] or 0)) < THROTTLE_SECONDS then return end
    lastBroadcast[channel] = now
    pcall(C_ChatInfo.SendAddonMessage, PREFIX, "V:" .. tostring(myBuild), channel)
end

local function broadcastAvailableChannels()
    if IsInGroup and IsInRaid then
        if LE_PARTY_CATEGORY_INSTANCE and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
            sendVersionToChannel("INSTANCE_CHAT")
        elseif IsInRaid() then
            sendVersionToChannel("RAID")
        elseif IsInGroup() then
            sendVersionToChannel("PARTY")
        end
    end
    if IsInGuild and IsInGuild() then
        sendVersionToChannel("GUILD")
    end
end

local function ensurePopupFrame()
    if popupFrame then return popupFrame end

    local tpl = BackdropTemplateMixin and "BackdropTemplate" or nil
    local f = CreateFrame("Frame", "SocramAddonsUpdatePopup", UIParent, tpl)
    f:SetSize(390, 165)
    f:SetPoint("TOP", UIParent, "TOP", 0, -110)
    f:SetFrameStrata("DIALOG")
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    if f.SetBackdrop then
        f:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = 5, right = 5, top = 5, bottom = 5 },
        })
        f:SetBackdropColor(0.06, 0.08, 0.11, 0.95)
        f:SetBackdropBorderColor(0.90, 0.66, 0.24, 1)
    end

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", f, "TOP", 0, -16)
    title:SetText("|cffE5A93CSocram Addons esES|r")

    local body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -46)
    body:SetPoint("TOPRIGHT", f, "TOPRIGHT", -20, -46)
    body:SetJustifyH("CENTER")
    body:SetSpacing(3)
    f.bodyText = body

    local reloadBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    reloadBtn:SetSize(190, 28)
    reloadBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 22, 18)
    reloadBtn:SetText("Recargar (/reload)")
    reloadBtn:SetScript("OnClick", function()
        ReloadUI()
    end)

    local hideBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    hideBtn:SetSize(130, 28)
    hideBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -22, 18)
    hideBtn:SetText("Ocultar")
    hideBtn:SetScript("OnClick", function()
        f:Hide()
    end)

    f:Hide()
    popupFrame = f
    return f
end

local function showUpdatePopup(remoteBuild, senderName, isTest)
    local f = ensurePopupFrame()
    local line1 = isTest
        and "Vista previa del aviso de actualización."
        or ("¡Hay nuevas traducciones disponibles! (v" .. tostring(remoteBuild) .. ")")
    local line2 = isTest
        and ("Versión local actual: v" .. tostring(myBuild))
        or ("Detectado vía " .. tostring(getShortName(senderName) or "grupo/hermandad") .. ". Tu versión: v" .. tostring(myBuild))
    local line3 = "1. Abre Actualizar-Traducciones.bat (o espera al modo vigilar).\n2. Pulsa este botón cuando termine:"
    f.bodyText:SetText(line1 .. "\n|cff9FB0C4" .. line2 .. "|r\n\n" .. line3)
    f:Show()
end

local function saveButtonPos(btn)
    if not SocramAddonsEsES_DB then return end
    local point, _, relPoint, x, y = btn:GetPoint(1)
    if point then
        SocramAddonsEsES_DB.btnPoint = { point, relPoint or point, x or 0, y or 0 }
    end
end

local function ensureQuickButton()
    if quickButton then return quickButton end

    local tpl = BackdropTemplateMixin and "BackdropTemplate" or nil
    local b = CreateFrame("Button", "SocramAddonsQuickReloadBtn", UIParent, tpl)
    b:SetSize(108, 26)
    b:SetFrameStrata("MEDIUM")
    b:SetClampedToScreen(true)
    b:SetMovable(true)
    b:EnableMouse(true)
    b:RegisterForDrag("LeftButton")
    b:RegisterForClicks("LeftButtonUp")
    b:SetScript("OnDragStart", function(self)
        if IsShiftKeyDown() then self:StartMoving() end
    end)
    b:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        saveButtonPos(self)
    end)
    b:SetScript("OnClick", function()
        ReloadUI()
    end)
    b:SetScript("OnEnter", function(self)
        if GameTooltip then
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
            GameTooltip:AddLine("Socram Addons esES (v" .. tostring(myBuild) .. ")", 0.90, 0.66, 0.24)
            GameTooltip:AddLine("Clic izquierdo: recargar interfaz (/reload)", 1, 1, 1)
            GameTooltip:AddLine("Shift + arrastrar: mover botón", 0.7, 0.75, 0.82)
            GameTooltip:Show()
        end
    end)
    b:SetScript("OnLeave", function()
        if GameTooltip then GameTooltip:Hide() end
    end)

    if b.SetBackdrop then
        b:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 },
        })
        b:SetBackdropColor(0.08, 0.10, 0.14, 0.90)
        b:SetBackdropBorderColor(0.90, 0.66, 0.24, 0.95)
    end

    local txt = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    txt:SetPoint("CENTER")
    txt:SetText("|cffE5A93CRecargar UI|r")

    local pos = SocramAddonsEsES_DB and SocramAddonsEsES_DB.btnPoint
    if pos and type(pos) == "table" and pos[1] then
        b:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
    else
        b:SetPoint("TOP", UIParent, "TOP", 0, -14)
    end

    if SocramAddonsEsES_DB and SocramAddonsEsES_DB.showButton then
        b:Show()
    else
        b:Hide()
    end

    quickButton = b
    return b
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("GUILD_ROSTER_UPDATE")
frame:RegisterEvent("CHAT_MSG_ADDON")

frame:SetScript("OnEvent", function(_, event, arg1, arg2, arg3, arg4)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        SocramAddonsEsES_DB = SocramAddonsEsES_DB or { showButton = false }
        if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
            C_ChatInfo.RegisterAddonMessagePrefix(PREFIX)
        end
        ensureQuickButton()
        return
    end

    if event == "PLAYER_ENTERING_WORLD" then
        if C_Timer and C_Timer.After then
            C_Timer.After(4, broadcastAvailableChannels)
        else
            broadcastAvailableChannels()
        end
        return
    end

    if event == "GROUP_ROSTER_UPDATE" or event == "GUILD_ROSTER_UPDATE" then
        broadcastAvailableChannels()
        return
    end

    if event == "CHAT_MSG_ADDON" then
        local prefix, message, _, sender = arg1, arg2, arg3, arg4
        if prefix ~= PREFIX or type(message) ~= "string" then return end
        if isSelf(sender) then return end

        local remoteBuild = tonumber(message:match("^V:(%d+)$"))
        if not remoteBuild then return end

        if remoteBuild > myBuild and not notifiedThisSession then
            notifiedThisSession = true
            printMsg("Hay nuevas traducciones disponibles (v" .. tostring(remoteBuild) .. ", tienes v" .. tostring(myBuild) .. "). Ejecuta Actualizar-Traducciones.bat y pulsa Recargar.")
            showUpdatePopup(remoteBuild, sender, false)
        end
    end
end)

SLASH_SOCRAMADDONS1 = "/socram"
SLASH_SOCRAMADDONS2 = "/esreload"
SlashCmdList["SOCRAMADDONS"] = function(msg)
    local cmd = (msg or ""):lower():match("^%s*(.-)%s*$")
    if cmd == "reload" or cmd == "r" then
        ReloadUI()
        return
    end
    if cmd == "test" then
        showUpdatePopup(myBuild + 1, UnitName and UnitName("player") or "Socram", true)
        return
    end
    if cmd == "boton" or cmd == "button" then
        SocramAddonsEsES_DB = SocramAddonsEsES_DB or {}
        SocramAddonsEsES_DB.showButton = not SocramAddonsEsES_DB.showButton
        local b = ensureQuickButton()
        if SocramAddonsEsES_DB.showButton then
            b:Show()
            printMsg("Botón rápido 'Recargar UI' activado (Shift + arrastrar para moverlo).")
        else
            b:Hide()
            printMsg("Botón rápido ocultado.")
        end
        return
    end
    printMsg("Versión instalada: v" .. tostring(myBuild) .. " | Prefijo: " .. PREFIX)
    printMsg("Comandos: /socram reload (o /esreload) · /socram boton (mostrar/ocultar botón fijo) · /socram test (probar aviso)")
end
