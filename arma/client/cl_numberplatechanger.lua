local currentPlate = nil
local carstable = {}
local location = vector3(-532.84381103516,-192.99229431152,38.222408294678)
local m = module("arma-vehicles", "garages")
m=m.garages

RMenu.Add('plateshop', 'main', RageUI.CreateMenu("Number Plate", "~b~Number Plate", 1350, 50))
RMenu.Add("plateshop", "sub", RageUI.CreateSubMenu(RMenu:Get("plateshop", "main"), "Number Plate", "~b~Number Plate", 1350, 50))
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('plateshop', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if next(carstable) == nil then
                RageUI.Separator('~r~You do not own any vehicles.')
            else
                for i,j in pairs(carstable) do
                    for k,v in pairs(m) do
                        for a,l in pairs(v) do
                            if a ~= "_config" then
                                if a == j[1] then
                                    RageUI.Button("~b~"..l[1], '~g~Spawncode: ~w~'..j[1]..' - ~g~Current Plate ~w~'..j[2], "", true,function(Hovered, Active, Selected)
                                        if Selected then
                                            selectedCar = j[1]
                                            selectedCarName = l[1]
                                        end
                                    end, RMenu:Get("plateshop", "sub"))
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('plateshop', 'sub')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Button("Change Number Plate", "~g~Changing plate of "..selectedCarName, {RightLabel = "~g~£50,000"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("ARMA:ChangeNumberPlate", selectedCar)
                end
            end)
        end)
    end
end)

AddEventHandler("ARMA:onClientSpawn",function(D, E)
    if E then
		local H = function(I)
            TriggerServerEvent('ARMA:getCars')
            RageUI.Visible(RMenu:Get("plateshop", "main"), true)
        end
        local J = function(I)
            RageUI.Visible(RMenu:Get("plateshop", "main"), false)
            RageUI.Visible(RMenu:Get("plateshop", "sub"), false)
        end
        local K = function(I)
        end
        local L = function(I)
        end
        tARMA.addBlip(location.x, location.y, location.z, 521, 2, "Plate Shop", 0.7, true)
        tARMA.createArea("platechanger", location, 1.5, 6, H, J, K, {})
        tARMA.addMarker(location.x, location.y, location.z-0.98,1.0,1.0,1.0,138,43,226,70,50,27)
	end
end)


RegisterNetEvent("ARMA:RecieveNumberPlate")
AddEventHandler("ARMA:RecieveNumberPlate", function(numplate)
    currentPlate = numplate
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("plateshop", "main"), true)
    TriggerServerEvent('ARMA:getCars')
end)

function isInArea(v, dis) 
    if #(GetEntityCoords(PlayerPedId()) - v) <= dis then  
        return true
    else 
        return false
    end
end

RegisterNetEvent("ARMA:carsTable")
AddEventHandler("ARMA:carsTable",function(cars)
    carstable = cars
end)

function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end