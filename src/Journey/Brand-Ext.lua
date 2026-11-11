--[[ Copyright (C) 2018-2026 TomCat's Gaming, LLC. All Rights Reserved.
     Unauthorized use, reproduction, or distribution is prohibited.
     See license.txt included with this distribution for full terms. ]]
select(2, ...).SetupGlobalFacade()

Brand.headerLogo = "JourneyLogoMed.png"
Brand.minimapIcon = "JourneyLogoMed.png"
Brand.headerLogoHC = "JourneyLogoMed.png"
Brand.headerIconBorderHidden = true
Brand.headerIconSize = 58
Brand.headerIconOffsetX = -2
Brand.hardcoreDisabled = true
Brand.slashCommand = "journey"
Brand.hasWebGuides = false
Brand.installerName = "Journey Guide Manager"


function Brand.configurationWindowSetupTitle(parent)
	local logo = parent:CreateTexture(nil, "ARTWORK")
	logo:SetTexture(I["JourneyFullLogoMed.png"])
	logo:SetSize(256, 64)
	logo:SetPoint("TOP", 0, -20)

	local title = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	title:SetPoint("TOP", 0, -80)
	title:SetText(string.format("Addon Version %s", GetDisplayVersion()))
	local contentVersion = CatalogService.GetContentVersion()
	if (contentVersion) then
		local cvLabel = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		cvLabel:SetPoint("TOP", title, "BOTTOM", 0, -2)
		cvLabel:SetText(string.format("Content Version %s", contentVersion))
		title = cvLabel
	end
	return title, 132
end

-- Deprecated: Remove this once Era guides are fully migrated to Forever context including guide ID conditions and
-- goto buttons have been resolved
function Brand.registerGuideAlias(guideID, context)
	local baseID = guideID:match("^(.+)_FVR$")
	if (baseID) then
		context[baseID] = true
	end
end

-- Deprecated: Remove this once Era guides are fully migrated to Forever context including guide ID conditions and
-- goto buttons have been resolved
function Brand.resolveGuideAlias(guideID)
	if (not CatalogService.IsInstalled(guideID)) then
		local fvrID = guideID .. "_FVR"
		if (CatalogService.IsInstalled(fvrID)) then
			return fvrID
		end
	end
	return guideID
end