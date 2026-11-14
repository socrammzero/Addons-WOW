--[[ Copyright (C) 2018-2026 TomCat's Gaming, LLC. All Rights Reserved.
     Unauthorized use, reproduction, or distribution is prohibited.
     See license.txt included with this distribution for full terms. ]]
select(2, ...).SetupGlobalFacade()

CatalogService = { }

local guideInfos
local guideInfoByID
local slotLookup
local minAddonVersionValue
local guideVersionValue
local catalogSourceLabel
local minGuideVersion = C_AddOns.GetAddOnMetadata(addonName, "X-Min-Guide-Version")
local catalogDecryptKey
local previousBattleTag
local previousBattleTagCaptured
local needsInstallerRun

local function initBattleTag()
    if (not previousBattleTagCaptured) then
        previousBattleTagCaptured = true
        previousBattleTag = SavedVariables.battleTag and UTF8.Lower(SavedVariables.battleTag) or nil
        needsInstallerRun = SavedVariables.needsInstallerRun
    end
    local _, liveTag = BNGetInfo()
    if (liveTag) then
        SavedVariables.battleTag = liveTag
    end
end

local function applySupersedes()
    -- Find productIDs superseded by condition-met entries
    local supersededProducts = { }
    for _, entry in ipairs(guideInfos) do
        if (entry.supersedes and not entry.stub and CheckCondition(entry)) then
            for _, supID in ipairs(entry.supersedes) do
                supersededProducts[supID] = true
            end
        end
    end
    if (not next(supersededProducts)) then return end

    -- Rebuild guideInfos without superseded entries
    local filtered = { }
    for _, entry in ipairs(guideInfos) do
        if (entry.productID and supersededProducts[entry.productID]) then
            if (entry.guideID) then
                guideInfoByID[entry.guideID] = nil
                slotLookup[entry.guideID] = nil
            end
        else
            table.insert(filtered, entry)
        end
    end
    guideInfos = filtered
end

local function processGuidesFile(data, prefix)
    if (not data) then return false end
    guideInfos = { }
    guideInfoByID = { }
    slotLookup = { }
    if (data.minAddonVersion) then
        minAddonVersionValue = data.minAddonVersion
    end
    if (data.guideVersion) then
        guideVersionValue = data.guideVersion
    end
    for _, entry in ipairs(data) do
        table.insert(guideInfos, entry)
        if (entry.guideID) then
            guideInfoByID[entry.guideID] = entry
        end
        if (entry.slot and entry.guideID) then
            slotLookup[entry.guideID] = { prefix = prefix, slot = string.format("%04d", entry.slot) }
        end
    end
    applySupersedes()
    return true
end

local function loadCatalogData(suffix)
    local decoded = ReadHTMLTemplate(addonName .. "-" .. suffix)
    if (not decoded) then return nil, nil, nil, "not_found" end

    local signedContent, signature = decoded:match("^(.*), \"(.+)\"%s*$")
    if (not signedContent or not signature) then
        signedContent = decoded
        signature = nil
    end

    local f = loadstring("return " .. signedContent)
    if (not f) then return nil, nil, nil, "parse_failed" end
    setfenv(f, {})
    local ok, result = pcall(f)
    if (not ok) then return nil, nil, nil, "parse_failed" end

    if (result.flavorCondition and not CheckCondition({ condition = result.flavorCondition })) then
        return
    end

    return result, signedContent, signature
end

local function getBattleTag()
    local tag = SavedVariables.battleTag
    return tag and UTF8.Lower(tag) or nil
end

local function deriveDecryptKey(battleTags)
    local sorted = {}
    for _, tag in ipairs(battleTags) do
        table.insert(sorted, UTF8.Lower(tag))
    end
    table.sort(sorted)
    return table.concat(sorted, "")
end

local function isRetryableFailure(reason)
    return reason == "signature_failed" or reason == "parse_failed"
end

local function tryLoadExternalCatalog()
    local catalogData, signedContent, signature, reason = loadCatalogData("ExternalGuides")
    if (not catalogData) then return nil, nil, nil, reason end
    if (catalogData.battleTags) then
        local playerTag = getBattleTag()
        if (playerTag) then
            for _, tag in ipairs(catalogData.battleTags) do
                if (UTF8.Lower(tag) == playerTag) then
                    catalogDecryptKey = deriveDecryptKey(catalogData.battleTags)
                    break
                end
            end
        end
    end
    return catalogData, signedContent, signature
end

-- Background signature verification
local verifyFrame = CreateFrame("Frame")
local activeVerify

local function cancelBackgroundVerify()
    activeVerify = nil
    verifyFrame:SetScript("OnUpdate", nil)
end

local function onVerifyFailed(source)
    if (source == "Bundled") then return end
    guideInfos = { }
    guideInfoByID = { }
    slotLookup = { }
    catalogDecryptKey = nil
    if (source == "External") then
        print("|cFFFF4444[" .. addonTitle .. "]|r Falló la comprobación de integridad de los datos de la guía. Por favor, vuelve a descargar el contenido de las guías.")
    else
        print("|cFFFF4444[" .. addonTitle .. "]|r Falló la comprobación de integridad de los datos del addon. Por favor, reinstala el addon.")
    end
    if (GuideNavigationService and GuideNavigationService.SetGuide) then
        GuideNavigationService.SetGuide(nil)
    end
    MarkAllDirty()
end

local function startBackgroundVerify(signedContent, signature, source)
    if (source == "Bundled" or not signature or not CATALOG_PUBLIC_KEY) then
        return
    end
    cancelBackgroundVerify()
    local state = CryptoService.BeginVerify(signedContent, signature, CATALOG_PUBLIC_KEY)
    if (not state) then
        onVerifyFailed(source)
        return
    end
    activeVerify = { state = state, source = source }
    verifyFrame:SetScript("OnUpdate", function()
        if (not activeVerify) then
            verifyFrame:SetScript("OnUpdate", nil)
            return
        end
        if (CryptoService.ContinueVerify(activeVerify.state)) then
            local passed = CryptoService.GetResult(activeVerify.state)
            local src = activeVerify.source
            activeVerify = nil
            verifyFrame:SetScript("OnUpdate", nil)
            if (not passed) then
                onVerifyFailed(src)
            end
        end
    end)
end

local loadingCatalog
local function ensureLoaded()
    if (guideInfos or loadingCatalog) then return end
    loadingCatalog = true
    initBattleTag()

    -- Try external catalog with one retry for transient parse failures
    local catalogData, signedContent, signature, dReason = tryLoadExternalCatalog()
    if (not catalogData and isRetryableFailure(dReason)) then
        catalogData, signedContent, signature, dReason = tryLoadExternalCatalog()
    end

    local source = "External"
    if (not processGuidesFile(catalogData, "External")) then
        -- Try bundled catalog with one retry
        local gData, gSigned, gSig, gReason = loadCatalogData("BundledGuides")
        if (not gData and isRetryableFailure(gReason)) then
            gData, gSigned, gSig, gReason = loadCatalogData("BundledGuides")
        end
        processGuidesFile(gData, "Bundled")
        signedContent = gSigned
        signature = gSig
        source = "Bundled"
    end
    catalogSourceLabel = source == "External" and "Ext" or "Bundled"

    -- Verify signature in the background
    if (signedContent and signature) then
        startBackgroundVerify(signedContent, signature, source)
    end
    loadingCatalog = nil
end

function CatalogService.Reload()
    cancelBackgroundVerify()
    guideInfos = nil
    guideInfoByID = nil
    slotLookup = nil
    minAddonVersionValue = nil
    guideVersionValue = nil
    catalogSourceLabel = nil
    catalogDecryptKey = nil
    ensureLoaded()
end

function CatalogService.GetGuideInfos()
    ensureLoaded()
    return guideInfos
end

function CatalogService.GetGuideTemplate(guideID)
    ensureLoaded()
    local slot = slotLookup[guideID]
    if (not slot) then return nil end
    return ("%s-%s%s"):format(addonName, slot.prefix, slot.slot)
end

function CatalogService.GetDecryptKey(guideID)
    if (not catalogDecryptKey) then return nil end
    local info = guideInfoByID and guideInfoByID[guideID]
    if (not info or not info.encrypted) then return nil end
    if (info.expires and GetServerTime() > info.expires) then return nil end
    return catalogDecryptKey
end

function CatalogService.IsExpired(guideID)
    local info = guideInfoByID and guideInfoByID[guideID]
    if (not info or not info.expires) then return false end
    return GetServerTime() > info.expires
end

function CatalogService.GetContentHash(guideID)
    local slot = slotLookup and slotLookup[guideID]
    if (slot and slot.prefix == "Bundled") then return nil end
    local info = guideInfoByID and guideInfoByID[guideID]
    if (not info) then return nil end
    return info.contentHash
end

function CatalogService.GetSlotInfo(guideID)
    return slotLookup[guideID]
end

function CatalogService.IsConditionMet(guideID)
    ensureLoaded()
    local info = guideInfoByID and guideInfoByID[guideID]
    return CheckCondition(info)
end

function CatalogService.IsInstalled(guideID)
    ensureLoaded()
    return slotLookup[guideID] ~= nil
end

function CatalogService.GetContentVersion()
    ensureLoaded()
    if (not guideVersionValue) then return nil end
    return guideVersionValue .. "-" .. (catalogSourceLabel or "")
end

function CatalogService.CheckCompatibility()
    ensureLoaded()
    if (minAddonVersionValue and addonVersion < minAddonVersionValue) then
        return "addon"
    end
    if (minGuideVersion and guideVersionValue and guideVersionValue < minGuideVersion) then
        return "guide"
    end
    return nil
end

local function isStub(guideID)
    local info = guideInfoByID and guideInfoByID[guideID]
    return info and info.stub == true
end

local function showSetupPopup(header, message, useReload, buttonText)
    TogglePopup(
        nil, nil, nil, nil, nil,
        "|cFFFFAA00" .. header .. ":|r\n\n|cFFFFD100" .. addonTitle .. "|r\n\n" .. message,
        useReload,
        buttonText
    )
end

function CatalogService.HandleStubGuide(guideID)
    if (not isStub(guideID)) then
        return false
    end

    CatalogService.Reload()

    if (not isStub(guideID)) then
        return false
    end

    local name = Brand.installerName

    if (previousBattleTag) then
        showSetupPopup("CONFIGURACIÓN ADICIONAL NECESARIA", "Por favor, vuelve a ejecutar " .. name .. " para\nterminar de configurar tus guías.")
        return true
    end

    local _, liveTag = BNGetInfo()
    if (liveTag) then
        SavedVariables.battleTag = liveTag
        SavedVariables.needsInstallerRun = true
        showSetupPopup("CONFIGURACIÓN ADICIONAL NECESARIA", "Haz clic en Recargar y, cuando se te solicite,\nvuelve a ejecutar " .. name .. ".", true)
        return true
    end

    showSetupPopup("CONFIGURACIÓN PENDIENTE", "Podrás completar la instalación de tus guías\ncuando Battle.net vuelva a estar en línea.")
    return true
end

function CatalogService.CheckStartupPrompt()
    if (not needsInstallerRun) then return end
    needsInstallerRun = nil
    SavedVariables.needsInstallerRun = nil
    showSetupPopup("CONFIGURACIÓN ADICIONAL NECESARIA", "Por favor, vuelve a ejecutar " .. Brand.installerName .. " para\nterminar de configurar tus guías.", false, "¡Listo!")
end
