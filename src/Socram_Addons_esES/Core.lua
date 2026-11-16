local ADDON_NAME = ...
local PREFIX = "SOCRAM_ADDONS_ES"
local THROTTLE_SECONDS = 20

local myBuild = tonumber(SocramAddonsEsES_Build) or 1
local lastBroadcast = { GUILD = 0, PARTY = 0, RAID = 0, INSTANCE_CHAT = 0 }
local notifiedThisSession = false
local pendingRemoteBuild = nil
local pendingSender = nil
local reloadButton

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
        DEFAULT_CHAT_FRAME:AddMessage("|cffE5A93C[Socram esES]|r " .. tostring(text))
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

local function saveButtonPos(btn)
    if not SocramAddonsEsES_DB then return end
    local point, _, relPoint, x, y = btn:GetPoint(1)
    if point then
        SocramAddonsEsES_DB.btnPoint = { point, relPoint or point, x or 0, y or 0 }
    end
end

local function applyButtonVisuals(btn)
    if not btn then return end
    if pendingRemoteBuild then
        btn.label:SetText("|cffFFD100Recargar (!)|r")
        if btn.SetBackdropBorderColor then
            btn:SetBackdropBorderColor(1, 0.82, 0.10, 1)
        end
        if btn.SetBackdropColor then
            btn:SetBackdropColor(0.22, 0.14, 0.04, 0.94)
        end
    else
        btn.label:SetText("|cffE5A93CRecargar|r")
        if btn.SetBackdropBorderColor then
            btn:SetBackdropBorderColor(0.75, 0.56, 0.22, 0.85)
        end
        if btn.SetBackdropColor then
            btn:SetBackdropColor(0.06, 0.08, 0.11, 0.82)
        end
    end
end

local function ensureReloadButton()
    if reloadButton then return reloadButton end

    local tpl = BackdropTemplateMixin and "BackdropTemplate" or nil
    local b = CreateFrame("Button", "SocramAddonsQuickReloadBtn", UIParent, tpl)
    b:SetSize(96, 24)
    b:SetFrameStrata("MEDIUM")
    b:SetClampedToScreen(true)
    b:SetMovable(true)
    b:EnableMouse(true)
    b:RegisterForDrag("RightButton")
    b:RegisterForClicks("LeftButtonUp")

    b:SetScript("OnDragStart", function(self)
        self:StartMoving()
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
            if pendingRemoteBuild then
                GameTooltip:AddLine("¡Nueva versión disponible: v" .. tostring(pendingRemoteBuild) .. "!", 0.25, 0.95, 0.40)
                if pendingSender then
                    GameTooltip:AddLine("Detectado vía: " .. tostring(pendingSender), 0.75, 0.82, 0.90)
                end
                GameTooltip:AddLine("Actualiza con el .bat y haz clic aquí.", 1, 1, 1)
            else
                GameTooltip:AddLine("Clic izquierdo: recargar UI (/reload)", 1, 1, 1)
            end
            GameTooltip:AddLine("Clic derecho + arrastrar: mover botón", 0.70, 0.75, 0.82)
            GameTooltip:AddLine("/socram fijo: fijar u ocultar botón", 0.70, 0.75, 0.82)
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
    end

    local txt = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    txt:SetPoint("CENTER")
    b.label = txt

    local pos = SocramAddonsEsES_DB and SocramAddonsEsES_DB.btnPoint
    if pos and type(pos) == "table" and pos[1] then
        b:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
    else
        b:SetPoint("TOP", UIParent, "TOP", 0, -6)
    end

    applyButtonVisuals(b)
    if (SocramAddonsEsES_DB and SocramAddonsEsES_DB.pinned) or pendingRemoteBuild then
        b:Show()
    else
        b:Hide()
    end

    reloadButton = b
    return b
end

local function notifyNewVersion(remoteBuild, senderName, isTest)
    pendingRemoteBuild = remoteBuild
    pendingSender = getShortName(senderName) or "grupo/hermandad"
    local b = ensureReloadButton()
    applyButtonVisuals(b)
    b:Show()
    if isTest then
        printMsg("Vista previa activada en el botón 'Recargar (!)' (v" .. tostring(myBuild) .. ").")
    else
        printMsg("Hay nuevas traducciones disponibles (v" .. tostring(remoteBuild) .. ", tienes v" .. tostring(myBuild) .. "). Actualiza con el .bat y pulsa 'Recargar (!)'.")
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("GUILD_ROSTER_UPDATE")
frame:RegisterEvent("CHAT_MSG_ADDON")

frame:SetScript("OnEvent", function(_, event, arg1, arg2, arg3, arg4)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        if type(SocramAddonsEsES_DB) ~= "table" then
            SocramAddonsEsES_DB = { pinned = false }
        else
            SocramAddonsEsES_DB.showButton = nil
            if SocramAddonsEsES_DB.pinned == nil then
                SocramAddonsEsES_DB.pinned = false
            end
        end
        if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
            C_ChatInfo.RegisterAddonMessagePrefix(PREFIX)
        end
        ensureReloadButton()
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
            notifyNewVersion(remoteBuild, sender, false)
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
        notifyNewVersion(myBuild + 1, playerFullName() or "Socram", true)
        return
    end
    if cmd == "reset" then
        SocramAddonsEsES_DB = SocramAddonsEsES_DB or {}
        SocramAddonsEsES_DB.btnPoint = nil
        local b = ensureReloadButton()
        b:ClearAllPoints()
        b:SetPoint("TOP", UIParent, "TOP", 0, -6)
        if SocramAddonsEsES_DB.pinned or pendingRemoteBuild then
            b:Show()
        end
        printMsg("Posición del botón restablecida arriba en el centro.")
        return
    end
    if cmd == "fijo" or cmd == "boton" or cmd == "button" or cmd == "ocultar" or cmd == "mostrar" then
        SocramAddonsEsES_DB = SocramAddonsEsES_DB or {}
        local b = ensureReloadButton()
        local pin = not (SocramAddonsEsES_DB.pinned == true)
        if cmd == "ocultar" then pin = false elseif cmd == "mostrar" then pin = true end
        SocramAddonsEsES_DB.pinned = pin
        if pin then
            b:Show()
            printMsg("Botón 'Recargar' fijado en pantalla (clic derecho + arrastrar para moverlo).")
        else
            pendingRemoteBuild = nil
            applyButtonVisuals(b)
            b:Hide()
            printMsg("Botón fijo desactivado. Solo saldrá si se detecta una actualización (usa /socram fijo para fijarlo).")
        end
        return
    end
    printMsg("Versión v" .. tostring(myBuild) .. " | Prefijo: " .. PREFIX .. " | Botón fijo: " .. ((SocramAddonsEsES_DB and SocramAddonsEsES_DB.pinned) and "SÍ" or "NO"))
    printMsg("Comandos: /socram fijo (fijar u ocultar botón) · /socram test (probar aviso) · /socram reset · /esreload")
end
