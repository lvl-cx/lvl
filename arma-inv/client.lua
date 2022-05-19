-- A JamesUK Production. Licensed users only. Use without authorisation is illegal, and a criminal offence under UK Law.
ARMA = Proxy.getInterface("ARMA")

local inventoryOpen = false; 
local debug = false;
local BootCar = nil;
local VehTypeC = nil;
local VehTypeA = nil;
local IsLootBagOpening = false;
local inventoryType = nil;
local NearLootBag = false; 
local LootBagID = nil;
local LootBagIDNew = nil;
local LootBagCoords = nil;
local PlayerInComa = false;
local model = GetHashKey('prop_big_bag_01')
tARMA = Proxy.getInterface("ARMA")

local LootBagCrouchLoop = false;
RegisterCommand('inventory', function()
    if not tARMA.isInComa({}) then
        if not inventoryOpen then
            TriggerServerEvent('ARMA:FetchPersonalInventory')
            inventoryOpen = true; 
            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(true)
            SendNUIMessage({action = 'InventoryDisplay', showInv = true})
            local VehInRadius, VehType, NVeh = tARMA.getNearestOwnedVehicle({3.5})
            if VehInRadius and IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then 
                BootCar = GetEntityCoords(PlayerPedId())
                VehTypeC = VehType
                VehTypeA = NVeh


                tARMA.vc_openDoor({VehTypeC, 5})
                inventoryType = 'CarBoot'
                
                TriggerServerEvent('ARMA:FetchTrunkInventory', NVeh)
            end

        else
            inventoryOpen = false;
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
            SendNUIMessage({action = 'InventoryDisplay', showInv = false})
            inventoryType = nil;
            if BootCar then
                tARMA.vc_closeDoor({VehTypeC, 5})
                BootCar = nil;
                VehTypeC = nil;
                VehTypeA = nil;
            end
            if IsLootBagOpening then
                if debug then 
                    print('Requested lootbag to close.')
                end
                TriggerServerEvent('ARMA:CloseLootbag')
                IsLootBagOpening = false;
                ResetPedMovementClipset(PlayerPedId(), 0.30 )
                LootBagCrouchLoop = false;
                FreezeEntityPosition(PlayerPedId(), false)
            end
        end
    else 
        tARMA.notify({'~r~You cannot open your inventory while dead.'})
    end
end)

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
      RequestAnimDict(dict)
      Citizen.Wait(5)
    end
end

RegisterNetEvent("Jud:OpenHomeStorage")
AddEventHandler("Jud:OpenHomeStorage", function(toggle)
    if toggle == true then
        TriggerServerEvent('ARMA:FetchPersonalInventory')
        inventoryOpen = true; 
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
        SendNUIMessage({action = 'InventoryDisplay', showInv = true})
        inventoryType = 'Housing'
        TriggerServerEvent('Jud:FetchHouseInventory')
    else
        inventoryOpen = false;
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        SendNUIMessage({action = 'InventoryDisplay', showInv = false})
        inventoryType = nil;
    end
end)

RegisterNetEvent('ARMA:InventoryOpen')
AddEventHandler('ARMA:InventoryOpen', function(toggle, lootbag)
    IsLootBagOpening = lootbag
    if IsLootBagOpening then
        TriggerEvent("ARMA:PlaySound", "zipper")
        LoadAnimDict('amb@medic@standing@kneel@base')
        LoadAnimDict('anim@gangops@facility@servers@bodysearch@')
        TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
        TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
        FreezeEntityPosition(PlayerPedId(), true)
        LootBagCrouchLoop = true;
    end
    if toggle then
        inventoryOpen = true; 
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
        SendNUIMessage({action = 'InventoryDisplay', showInv = true})
    else 
        inventoryOpen = false;
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        SendNUIMessage({action = 'InventoryDisplay', showInv = false})
    end
end)


RegisterNetEvent('ARMA:ToggleNUIFocus')
AddEventHandler('ARMA:ToggleNUIFocus', function(value)
    --print('focus', value)
    SetNuiFocus(value, value)
    SetNuiFocusKeepInput(value)
end)

RegisterNetEvent('ARMA:SendSecondaryInventoryData')
AddEventHandler('ARMA:SendSecondaryInventoryData', function(InventoryData, CurrentKG, MaxKg)
    SendNUIMessage({action = 'loadSecondaryItems', items = InventoryData, CurrentKG = CurrentKG, MaxKG = MaxKg, invType = inventoryType})
    if debug then
        print('Sent secondary inventory data to client.')
    end
end)

RegisterNetEvent('ARMA:FetchPersonalInventory')
AddEventHandler('ARMA:FetchPersonalInventory', function(table, CurrentKG, MaxKG)
    SendNUIMessage({action = 'loadItems', items = table, CurrentKG = CurrentKG, MaxKG = MaxKG})
    if debug then
        print('Sent inventory data to client.')
    end
end)

RegisterNUICallback('UseBtn', function(data, cb)
    TriggerServerEvent('ARMA:UseItem', data.itemId, data.invType)
    cb(true);
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)

  

end)

RegisterNUICallback('TrashBtn', function(data, cb)
    TriggerServerEvent('ARMA:TrashItem', data.itemId, data.invType)
    cb(true);
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end)

RegisterNUICallback('GiveBtn', function(data, cb)
    TriggerServerEvent('ARMA:GiveItem', data.itemId, data.invType)
    cb(true)
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end)

RegisterNUICallback('MoveBtn', function(data, cb)
    if not IsLootBagOpening then
        if inventoryType == 'CarBoot' then
            TriggerServerEvent('ARMA:MoveItem', data.invType, data.itemId, VehTypeA)
        elseif inventoryType == "Housing" then
            TriggerServerEvent('ARMA:MoveItem', data.invType, data.itemId, "home")
        end
    else 
        TriggerServerEvent('ARMA:MoveItem', 'LootBag', data.itemId, LootBagIDNew)
    end
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    cb(true)
end)

RegisterNUICallback('MoveXBtn', function(data, cb)
    if not IsLootBagOpening then
        if inventoryType == 'CarBoot' then
            TriggerServerEvent('ARMA:MoveItemX', data.invType, data.itemId, VehTypeA)
        elseif inventoryType == "Housing" then
            TriggerServerEvent('ARMA:MoveItemX', data.invType, data.itemId, "home")
        end
    else 
        TriggerServerEvent('ARMA:MoveItemX', 'LootBag', data.itemId, LootBagIDNew)
    end
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    cb(true)
end)


RegisterNUICallback('MoveAllBtn', function(data, cb)
    if not IsLootBagOpening then
        if inventoryType == 'CarBoot' then
            local nearestVeh2 = ARMA.getNearestVehicle({3})
            TriggerServerEvent('ARMA:MoveItemAll', data.invType, data.itemId, VehTypeA, NetworkGetNetworkIdFromEntity(nearestVeh2))
        elseif inventoryType == "Housing" then
            TriggerServerEvent('ARMA:MoveItemAll', data.invType, data.itemId, "home")
        end
    else 
        TriggerServerEvent('ARMA:MoveItemAll', 'LootBag', data.itemId, LootBagIDNew)
    end
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    cb(true)
end)


Citizen.CreateThread(function()
    while true do
        Wait(0)
        if inventoryOpen then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 4, true)
            DisableControlAction(0, 3, true)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 7, true)
            DisableControlAction(0, 212, true)
            DisableControlAction(0, 80, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 58, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 311, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 170, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 75, true)
            DisableControlAction(27, 75, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 140, true)
            DisablePlayerFiring(PlayerPedId(), true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Wait(250)
        if BootCar then
            if #(BootCar - GetEntityCoords(PlayerPedId())) > 8.0 then 
                inventoryOpen = false;
                SetNuiFocus(false, false)
                SetNuiFocusKeepInput(false)
                SendNUIMessage({action = 'InventoryDisplay', showInv = false})
                tARMA.vc_closeDoor({VehTypeC, 5})
                BootCar = nil;
                VehTypeC = nil;
                VehTypeA = nil;
                inventoryType = nil;
            end
        end
        if inventoryOpen then
            if tARMA.isInComa({}) then
                inventoryOpen = false;
                SetNuiFocus(false, false)
                SetNuiFocusKeepInput(false)
                SendNUIMessage({action = 'InventoryDisplay', showInv = false})
                inventoryType = nil;
                if BootCar then
                    tARMA.vc_closeDoor({VehTypeC, 5})
                    BootCar = nil;
                    VehTypeC = nil;
                    VehTypeA = nil;
                end
            end
        end
    end
end)

RegisterKeyMapping('inventory', 'Opens / Closes your inventory', 'keyboard', 'L')



-- LOOT BAG CODE BELOW 


AddEventHandler('ARMA:IsInComa', function(coma)
    PlayerInComa = coma;
    if coma then 
        LootBagCoords = false;
        NearLootBag = false; 
        LootBagID = nil;
    end
end)

Citizen.CreateThread(function()
    while true do 
        Wait(250)
        if not PlayerInComa then
            local coords = GetEntityCoords(PlayerPedId())
            if DoesObjectOfTypeExistAtCoords(coords, 10.5, model, true) then
                if not NearLootBag then
                    NearLootBag = true;
                    LootBagID = GetClosestObjectOfType(coords, 10.5, model, false, false, false)
                    LootBagIDNew = ObjToNet(LootBagID)
                    LootBagCoords = GetEntityCoords(LootBagID)
                end
            else 
                LootBagCoords = false;
                NearLootBag = false; 
                LootBagID = nil;
            end
        end
    end
end)

-- Citizen.CreateThread(function()
--     while true do 
--         Wait(0)
--         if NearLootBag then 
--             Draw3DText(LootBagCoords, "~g~~w~[~r~E~w~] to loot")
--             if IsControlJustPressed(0, 38) then
--                 TriggerServerEvent('ARMA:LootBag', LootBagIDNew)
--             end
--         end
--     end
-- end)

-- [Lootbags]

local LootBagIDNew2 = nil;
local MoneydropIDNew2 = nil;
local Entity2, farCoordsX2, farCoordsY2, farCoordsZ2 = nil,nil,nil,nil
local EntityType2 = nil
local model2 = GetHashKey('prop_big_bag_01')


Citizen.CreateThread(function()
    while true do
        hit2, coords2, Entity2 = RayCastGamePlayCamera(6.0)
        EntityType2 = GetEntityType(Entity2)

        if EntityType2 then
            local playerPed2 = PlayerPedId()
            local playerVehicle2 = GetVehiclePedIsIn(playerPed2,false)

            if playerIsAlive() and playerVehicle2 == 0 then
                if EntityType2 == 3 then
                    local entityModel2 = GetEntityModel(Entity2)
                    local coords2 = GetEntityCoords(PlayerPedId())
               
                    if `prop_big_bag_01` == entityModel2 then
                        TriggerEvent('Crosshair', true)
                        if IsControlJustReleased(1, 38) then
                      
                            local MoneydropID2 = GetClosestObjectOfType(coords2, 5.0, GetHashKey('prop_big_bag_01'), false, false, false)
                            local MoneydropIDNew2 = ObjToNet(MoneydropID2)
                            TriggerServerEvent('ARMA:LootBag', LootBagIDNew)
                            Wait(1000)
                        end
                    end
                    
                else
                    TriggerEvent('Crosshair', false)
                end
            else
                TriggerEvent('Crosshair', false)
            end
        end
        Citizen.Wait(0)
	end
end)

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function RayCastGamePlayCamera(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, -1, 1))
	return b, c, e
end

function playerIsAlive()
    return GetEntityHealth(PlayerPedId()) > 102
end





function GetCoordsFromCam(distance)
    local rot = GetGameplayCamRot(2)
    local coord = GetGameplayCamCoord()

    local tZ = rot.z * 0.0174532924
    local tX = rot.x * 0.0174532924
    local num = math.abs(math.cos(tX))

    newCoordX = coord.x + (-math.sin(tZ)) * (num + distance)
    newCoordY = coord.y + (math.cos(tZ)) * (num + distance)
    newCoordZ = coord.z + (math.sin(tX) * 8.0)
    return newCoordX, newCoordY, newCoordZ
end

function Target(Distance, Ped)
    local Entity = nil
    local camCoords = GetGameplayCamCoord()
    local farCoordsX, farCoordsY, farCoordsZ = GetCoordsFromCam(Distance)
    local RayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, farCoordsX, farCoordsY, farCoordsZ, -1, Ped, 0)
    local A,B,C,D,Entity = GetRaycastResult(RayHandle)
    return Entity, farCoordsX, farCoordsY, farCoordsZ
end

--- [Lootbags]

RegisterNetEvent("anim")
AddEventHandler("anim", function()
    LoadAnimDict('amb@medic@standing@kneel@base')
    LoadAnimDict('anim@gangops@facility@servers@bodysearch@')
    TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
    TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
end)

function Draw3DText(coords, text)
    local x,y,z = table.unpack(coords)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

function getNearestVehicle(radius)
    local x,y,z = ARMA.getPosition()
    local ped =PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then
      return GetVehiclePedIsIn(ped, true)
    else
      -- flags used:
      --- 8192: boat
      --- 4096: helicos
      --- 4,2,1: cars (with police)
  
      local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 8192+4096+4+2+1)  -- boats, helicos
      if not IsEntityAVehicle(veh) then veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 4+2+1) end -- cars
      return veh
    end
end

