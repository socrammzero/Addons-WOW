--[[ Copyright (C) 2018-2026 TomCat's Gaming, LLC. All Rights Reserved.
     Unauthorized use, reproduction, or distribution is prohibited.
     See license.txt included with this distribution for full terms. ]]
select(2, ...).SetupGlobalFacade()

--[[
	Reaction values:
	1 = unknown
	2 = hostile
	3 = friendly
	4 = neutral
]]

function GetNPCReaction(npcID)
    local npcInfo = NPCs[npcID]
    local react = 1
    if (npcInfo) then
        react = PLAYER_FACTION == "ALLIANCE" and npcInfo.reactA or npcInfo.reactH
    end
    return react
end

NPCRaces = {
    [1] = "Human",
    [2] = "Orc",
    [3] = "Dwarf",
    [4] = "Night Elf",
    [5] = "Undead",
    [6] = "Tauren",
    [7] = "Gnome",
    [8] = "Troll",
    [9] = "Goblin",
    [10] = "Blood Elf",
    [11] = "Draenei",
    [12] = "Fel Orc",
    [13] = "Naga",
    [14] = "Broken Draenei",
    [15] = "Skeleton",
    [16] = "Vrykul",
    [17] = "Tuskarr",
    [18] = "Forest Troll",
    [19] = "Taunka",
    [20] = "Northrend Skeleton",
    [21] = "Ice Troll",
    [22] = "Worgen",
    [23] = "Gilnean",
    [24] = "Pandaren",
    [25] = "Alliance Pandaren",
    [26] = "Horde Pandaren",
    [27] = "Nightborne",
    [28] = "Highmountain Tauren",
    [29] = "Void Elf",
    [30] = "Lightforged Draenei",
    [31] = "Zandalari Troll",
    [32] = "Kul'Tiran",
    [33] = "Thin Human",
    [34] = "Dark Iron Dwarf",
    [35] = "Vulpera",
    [36] = "Mag'har Orc",
    [37] = "Mechagnome"
}

NPCGenders = {
    [0] = "male",
    [1] = "female"
}

if (GetLocale() == "esES" or GetLocale() == "esMX") then
    NPCRaces = {
        [1] = "Humano",
        [2] = "Orco",
        [3] = "Enano",
        [4] = "Elfo de la noche",
        [5] = "No-muerto",
        [6] = "Tauren",
        [7] = "Gnomo",
        [8] = "Trol",
        [9] = "Goblin",
        [10] = "Elfo de sangre",
        [11] = "Draenei",
        [12] = "Orco vil",
        [13] = "Naga",
        [14] = "Tábido",
        [15] = "Esqueleto",
        [16] = "Vrykul",
        [17] = "Colmillar",
        [18] = "Trol del bosque",
        [19] = "Taunka",
        [20] = "Esqueleto de Rasganorte",
        [21] = "Trol de hielo",
        [22] = "Huargen",
        [23] = "Gilneano",
        [24] = "Pandaren",
        [25] = "Pandaren de la Alianza",
        [26] = "Pandaren de la Horda",
        [27] = "Nocheterna",
        [28] = "Tauren Monte Alto",
        [29] = "Elfo del Vacío",
        [30] = "Draenei forjado por la Luz",
        [31] = "Trol Zandalari",
        [32] = "Kul'tirano",
        [33] = "Humano delgado",
        [34] = "Enano Hierro Negro",
        [35] = "Vulpera",
        [36] = "Orco Mag'har",
        [37] = "Mecagnomo"
    }

    NPCGenders = {
        [0] = "varón",
        [1] = "mujer"
    }
end

NPCTypes = {
    [0] = "Humanoid",
    [1] = "Undead",
    [2] = "Elemental",
    [3] = "Beast",
    [4] = "Dragonkin",
    [5] = "Giant",
    [6] = "Demon",
    [7] = "Mechanical",
    [8] = "Critter",
}

if (GetLocale() == "esES" or GetLocale() == "esMX") then
    NPCTypes = {
        [0] = "Humanoide",
        [1] = "No-muerto",
        [2] = "Elemental",
        [3] = "Bestia",
        [4] = "Dragonante",
        [5] = "Gigante",
        [6] = "Demonio",
        [7] = "Mecánico",
        [8] = "Sabandija",
    }
end

NPCClassifications = {
    [1] = ELITE, -- Elite
    [2] = ITEM_QUALITY3_DESC, -- Rare,
    [3] = BOSS, -- Boss
    [4] = ITEM_QUALITY3_DESC .. " " .. ELITE, -- Rare Elite
}