RMenu.Add("armatruckmenu","buy-rent",RageUI.CreateMenu("ARMA Trucking", "~b~ARMA Trucking", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight()))
RMenu.Add("armatruckmenu","vehicle",RageUI.CreateSubMenu(RMenu:Get("armatruckmenu", "buy-rent"),"ARMA Trucking","~b~ARMA Trucking",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight()))
RMenu.Add("armatruckmenu","vehicles",RageUI.CreateMenu("Your Trucks", "~b~ARMA Trucking", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight()))
RMenu.Add("armatruckmenu","rented_trucks",RageUI.CreateSubMenu(RMenu:Get("armatruckmenu", "vehicles"),"Rented Vehicles","~b~ARMA Trucking",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight()))
RMenu.Add("armatruckmenu","owned_trucks",RageUI.CreateSubMenu(RMenu:Get("armatruckmenu", "vehicles"),"Owned Vehicles","~b~ARMA Trucking",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight()))
local a = module("cfg/cfg_trucking")
local b = a.trucks
local c = {}
local d = {}
local e
local f = ""
local g
local h
local i = false
local j = false
local k = 10.0
globalOnTruckJob = false
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('armatruckmenu', 'buy-rent')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for l, m in pairs(b) do
                if not m.custom then
                    local n
                    if table.has(d["rented"], GetHashKey(l)) then
                        n = {RightBadge = RageUI.BadgeStyle.Tick}
                    else
                        n = {RightLabel = "£" .. getMoneyStringFormatted(m.price)}
                    end
                    RageUI.ButtonWithStyle(m.name,"Press to spawn.",n,true,function(o, p, q)
                        if q then
                            if not table.has(d["rented"], GetHashKey(l)) then
                                tryRental(l, m.price)
                            else
                                trySpawnVehicle(l)
                            end
                        end
                    end)
                end
            end
        end)
    end
end)
RegisterNetEvent("ARMA:updateOwnedTrucks",function(b, r)
    d["owned"] = b
    d["rented"] = r
end)
RegisterNetEvent("ARMA:setTruckerOnDuty",function(s)
    globalOnTruckJob = s
end)
function tryRental(t, u)
    TriggerServerEvent("ARMA:rentTruck", t, u)
end
function getVehicleName(v)
    for l, m in pairs(b) do
        if GetHashKey(l) == v then
            return l
        end
    end
    return nil
end
Citizen.CreateThread(function()
    for w = 1, #a.buylocations do
        local x = a.buylocations[w]
        local y = x.main
        tARMA.add3DTextForCoord("Truck Rental", y.x, y.y, y.z, 8.0)
        tARMA.addMarker(y.x, y.y, y.z, 0.7, 0.7, 0.5, 0, 255, 125, 125, 50, 29, true, true)
        tARMA.addBlip(y.x, y.y, y.z, 67, 5, "Truck Rental")
    end
end)
AddEventHandler("ARMA:onClientSpawn",function(z, A)
    if A then
        local B = function(C)
            if not IsPedInAnyVehicle(ped, false) and GetVehiclePedIsIn(ped, false) ~= e then
                i = true
                RageUI.CloseAll()
                RageUI.Visible(RMenu:Get("armatruckmenu", "buy-rent"), true)
            end
        end
        local D = function()
            i = false
            RageUI.CloseAll()
        end
        local E = function()
        end
        for w = 1, #a.buylocations do
            local x = a.buylocations[w]
            local y = x.main
            tARMA.createArea("trucking_buy_" .. w, x.main, 1.15, 6, B, D, E, {})
        end
    end
end)
function trySpawnVehicle(F)
    TriggerServerEvent("ARMA:spawnTruck", F)
end
RegisterNetEvent("ARMA:spawnTruckCl",function(F)
    local ped = PlayerPedId()
    local y = GetEntityCoords(ped)
    local G = tARMA.spawnVehicle(F, y.x, y.y, y.z, GetEntityHeading(ped), true, true, true)
end)
function getAllTrucks()
    TriggerServerEvent("ARMA:truckerJobBuyAllTrucks")
end
