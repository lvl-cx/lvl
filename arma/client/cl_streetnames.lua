local function a(b, c, d, e, f, g, h, i, j, k)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(f, f)
    SetTextColour(h, i, j, k)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(g)
    EndTextCommandDisplayText(b - d / 2, c - e / 2 + 0.005)
end
local l = {
    ["AIRP"] = "Los Santos International Airport",
    ["ALAMO"] = "Alamo Sea",
    ["ALTA"] = "Alta",
    ["ARMYB"] = "Fort Zancudo",
    ["BANHAMC"] = "Banham Canyon Dr",
    ["BANNING"] = "Banning",
    ["BEACH"] = "Vespucci Beach",
    ["BHAMCA"] = "Banham Canyon",
    ["BRADP"] = "Braddock Pass",
    ["BRADT"] = "Braddock Tunnel",
    ["BURTON"] = "Burton",
    ["CALAFB"] = "Calafia Bridge",
    ["CANNY"] = "Raton Canyon",
    ["CCREAK"] = "Cassidy Creek",
    ["CHAMH"] = "Chamberlain Hills",
    ["CHIL"] = "Vinewood Hills",
    ["CHU"] = "Chumash",
    ["CMSW"] = "Chiliad Mountain State Wilderness",
    ["CYPRE"] = "Cypress Flats",
    ["DAVIS"] = "Davis",
    ["DELBE"] = "Del Perro Beach",
    ["DELPE"] = "Del Perro",
    ["DELSOL"] = "La Puerta",
    ["DESRT"] = "Grand Senora Desert",
    ["DOWNT"] = "Downtown",
    ["DTVINE"] = "Downtown Vinewood",
    ["EAST_V"] = "East Vinewood",
    ["EBURO"] = "El Burro Heights",
    ["ELGORL"] = "El Gordo Lighthouse",
    ["ELYSIAN"] = "Elysian Island",
    ["GALFISH"] = "Galilee",
    ["GOLF"] = "GWC and Golfing Society",
    ["GRAPES"] = "Grapeseed",
    ["GREATC"] = "Great Chaparral",
    ["HARMO"] = "Harmony",
    ["HAWICK"] = "Hawick",
    ["HORS"] = "Vinewood Racetrack",
    ["HUMLAB"] = "Humane Labs and Research",
    ["JAIL"] = "Bolingbroke Penitentiary",
    ["KOREAT"] = "Little Seoul",
    ["LACT"] = "Land Act Reservoir",
    ["LAGO"] = "Lago Zancudo",
    ["LDAM"] = "Land Act Dam",
    ["LEGSQU"] = "Legion Square",
    ["LMESA"] = "La Mesa",
    ["LOSPUER"] = "La Puerta",
    ["MIRR"] = "Mirror Park",
    ["MORN"] = "Morningwood",
    ["MOVIE"] = "Richards Majestic",
    ["MTCHIL"] = "Mount Chiliad",
    ["MTGORDO"] = "Mount Gordo",
    ["MTJOSE"] = "Mount Josiah",
    ["MURRI"] = "Murrieta Heights",
    ["NCHU"] = "North Chumash",
    ["NOOSE"] = "N.O.O.S.E",
    ["OCEANA"] = "Pacific Ocean",
    ["PALCOV"] = "Paleto Cove",
    ["PALETO"] = "Paleto Bay",
    ["PALFOR"] = "Paleto Forest",
    ["PALHIGH"] = "Palomino Highlands",
    ["PALMPOW"] = "Palmer-Taylor Power Station",
    ["PBLUFF"] = "Pacific Bluffs",
    ["PBOX"] = "Pillbox Hill",
    ["PROCOB"] = "Procopio Beach",
    ["RANCHO"] = "Rancho",
    ["RGLEN"] = "Richman Glen",
    ["RICHM"] = "Richman",
    ["ROCKF"] = "Rockford Hills",
    ["RTRAK"] = "Redwood Lights Track",
    ["SANAND"] = "San Andreas",
    ["SANCHIA"] = "San Chianski Mountain Range",
    ["SANDY"] = "Sandy Shores",
    ["SKID"] = "Mission Row",
    ["SLAB"] = "Stab City",
    ["STAD"] = "Maze Bank Arena",
    ["STRAW"] = "Strawberry",
    ["TATAMO"] = "Tataviam Mountains",
    ["TERMINA"] = "Terminal",
    ["TEXTI"] = "Textile City",
    ["TONGVAH"] = "Tongva Hills",
    ["TONGVAV"] = "Tongva Valley",
    ["VCANA"] = "Vespucci Canals",
    ["VESP"] = "Vespucci",
    ["VINE"] = "Vinewood",
    ["WINDF"] = "Ron Alternates Wind Farm",
    ["WVINE"] = "West Vinewood",
    ["ZANCUDO"] = "Zancudo River",
    ["ZP_ORT"] = "Port of South Los Santos",
    ["ZQ_UAR"] = "Davis Quartz"
}
local m = {
    [0] = "N",
    [45] = "NW",
    [90] = "W",
    [135] = "SW",
    [180] = "S",
    [225] = "SE",
    [270] = "E",
    [315] = "NE",
    [360] = "N"
}
local n = false
local o
local p
local q = ""
local r = ""
Citizen.CreateThread(function()
    while true do
        if n then
            local s = tARMA.getPlayerCoords()
            o, p = GetStreetNameAtCoord(s.x, s.y, s.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            q = l[GetNameOfZone(s.x, s.y, s.z)] or "N/A"
        end
        Wait(1000)
    end
end)
function func_drawStreetNamesGameUi(t)
    HideHudComponentThisFrame(3)
    HideHudComponentThisFrame(4)
    if n then
        a(0.515, 1.25, 1.0, 1.0, 0.4, tostring(GetStreetNameFromHashKey(o)) .. " ~w~| ~b~" .. q, 255, 255, 255, 255)
    end
end
tARMA.createThreadOnTick(func_drawStreetNamesGameUi)
RegisterCommand("streetnames",function()
    n = not n
end)
function tARMA.isStreetnamesEnabled()
    return n
end
function tARMA.setStreetnamesEnabled(u)
    n = u
    SetResourceKvp("arma_streetnames", tostring(u))
end
Citizen.CreateThread(function()
    local v = GetResourceKvpString("arma_streetnames") or "false"
    if v == "false" then
        n = false
    else
        n = true
    end
end)
