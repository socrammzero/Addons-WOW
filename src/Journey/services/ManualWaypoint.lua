--[[ Copyright (C) 2018-2026 TomCat's Gaming, LLC. All Rights Reserved.
     Unauthorized use, reproduction, or distribution is prohibited.
     See license.txt included with this distribution for full terms. ]]
select(2, ...).SetupGlobalFacade()

ManualWaypointService = { }

local ARRIVAL_RADIUS = 10

local waypoint -- { map, x, y, worldX, worldY, continentID, label }

local function CreateWaypoint(mapID, mapX, mapY, label)
    local continentID, worldCoordinate = C_Map.GetWorldPosFromMapPos(mapID, { x = mapX / 100, y = mapY / 100 })
    if (not continentID or not worldCoordinate) then
        DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: Coordenadas de punto de ruta no válidas", addonTitle))
        return
    end
    local waypointLabel = label or string.format("Punto de ruta (%.1f, %.1f)", mapX, mapY)
    waypoint = Mixin({
        flags = "",
        originalFlags = "",
        map = mapID,
        x = mapX,
        y = mapY,
        worldX = worldCoordinate.x,
        worldY = worldCoordinate.y,
        within = false,
        radius = ARRIVAL_RADIUS,
        continentID = continentID,
        conditionPassed = true,
        label = waypointLabel,
    }, LocationMixin)
    LocationsService.SetStep({ locations = { waypoint } })
    LocationsService.SetActiveLocation(waypoint)
    DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: Punto de ruta establecido en %.1f, %.1f en el mapa %d", addonTitle, mapX, mapY, mapID))
end

local function CreateWaypointFromWorld(worldX, worldY, label)
    local playerMapID = C_Map.GetBestMapForUnit("player")
    if (not playerMapID) then
        DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: No se puede determinar la zona actual", addonTitle))
        return
    end
    local continentID = C_Map.GetWorldPosFromMapPos(playerMapID, { x = 0.5, y = 0.5 })
    if (not continentID) then
        DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: No se puede determinar el continente", addonTitle))
        return
    end
    local _, mapPos = C_Map.GetMapPosFromWorldPos(continentID, { x = worldX, y = worldY }, playerMapID)
    if (not mapPos) then
        DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: No se pueden convertir las coordenadas del mundo a posición del mapa", addonTitle))
        return
    end
    CreateWaypoint(playerMapID, mapPos.x * 100, mapPos.y * 100, label or string.format("Punto de ruta (mundo %.0f, %.0f)", worldX, worldY))
end

function ManualWaypointService.GetWaypoint()
    return waypoint
end

function ManualWaypointService.Clear(silent)
    if (waypoint) then
        waypoint = nil
        LocationsService.SetStep({ locations = { } })
        MarkAllDirty()
        if (not silent) then
            DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: Punto de ruta borrado", addonTitle))
        end
    end
end

function ManualWaypointService.CheckArrival()
    if (not waypoint) then return end
    local x, y, _, continentID = UnitPosition("player")
    if (not x or continentID ~= waypoint.continentID) then return end
    local distance = addon.GetDistanceInYards(x, y, waypoint.worldX, waypoint.worldY)
    if (distance <= ARRIVAL_RADIUS) then
        DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: Has llegado al punto de ruta", addonTitle))
        waypoint = nil
        MarkAllDirty()
    end
end

function ManualWaypointService.HandleCommand(args)
    if (GuideNavigationService.IsGuideSet()) then
        DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: No se puede usar un punto de ruta manual mientras hay una guía activa", addonTitle))
        return
    end
    if (args == "clear") then
        ManualWaypointService.Clear()
        return
    end

    local parts = {}
    for part in args:gmatch("%S+") do
        parts[#parts + 1] = part
    end

    if (#parts < 2) then
        local cmd = "/" .. Brand.slashCommand
        DEFAULT_CHAT_FRAME:AddMessage(string.format("Punto de ruta en la zona actual: %s way <x> <y>", cmd))
        DEFAULT_CHAT_FRAME:AddMessage(string.format("Punto de ruta en una zona específica: %s way <zoneid> <x> <y>", cmd))
        DEFAULT_CHAT_FRAME:AddMessage(string.format("Punto de ruta en coordenadas del mundo: %s way world <x> <y>", cmd))
        DEFAULT_CHAT_FRAME:AddMessage(string.format("Borrar punto de ruta: %s way clear", cmd))
        return
    end

    if (parts[1] == "world") then
        local wx = tonumber(parts[2])
        local wy = tonumber(parts[3])
        if (not wx or not wy) then
            DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: Coordenadas del mundo no válidas", addonTitle))
            return
        end
        CreateWaypointFromWorld(wx, wy)
    elseif (#parts == 2) then
        local mapX = tonumber(parts[1])
        local mapY = tonumber(parts[2])
        if (not mapX or not mapY) then
            DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: Coordenadas no válidas", addonTitle))
            return
        end
        local mapID = C_Map.GetBestMapForUnit("player")
        if (not mapID) then
            DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: No se puede determinar la zona actual", addonTitle))
            return
        end
        CreateWaypoint(mapID, mapX, mapY)
    elseif (#parts == 3) then
        local mapID = tonumber(parts[1])
        local mapX = tonumber(parts[2])
        local mapY = tonumber(parts[3])
        if (not mapID or not mapX or not mapY) then
            DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: ID de zona o coordenadas no válidos", addonTitle))
            return
        end
        CreateWaypoint(mapID, mapX, mapY)
    else
        DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: Comando de punto de ruta no válido", addonTitle))
    end
end
