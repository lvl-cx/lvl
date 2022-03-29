-- A JamesUK Production. Licensed users only. Use without authorisation is illegal, and a criminal offence under UK Law.


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
local model = GetHashKey('prop_cs_heist_bag_01')
tSentry = Proxy.getInterface("Sentry")


local LootBagCrouchLoop = false;
RegisterCommand('inventory', function()
    if not tSentry.isInComa({}) then
        if not inventoryOpen then
            TriggerServerEvent('Sentry:FetchPersonalInventory')
            inventoryOpen = true; 
            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(true)
            SendNUIMessage({action = 'InventoryDisplay', showInv = true})
            local VehInRadius, VehType, NVeh = tSentry.getNearestOwnedVehicle({3.5})
            if VehInRadius and IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then 
                BootCar = GetEntityCoords(PlayerPedId())
                VehTypeC = VehType
                VehTypeA = NVeh
                tSentry.vc_openDoor({VehTypeC, 5})
                inventoryType = 'CarBoot'
                TriggerServerEvent('Sentry:FetchTrunkInventory', NVeh)
            end
        else
            inventoryOpen = false;
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
            SendNUIMessage({action = 'InventoryDisplay', showInv = false})
            inventoryType = nil;
            if BootCar then
                tSentry.vc_closeDoor({VehTypeC, 5})
                BootCar = nil;
                VehTypeC = nil;
                VehTypeA = nil;
            end
            if IsLootBagOpening then
                if debug then 
                    print('Requested lootbag to close.')
                end
                TriggerServerEvent('Sentry:CloseLootbag')
                IsLootBagOpening = false;
                ResetPedMovementClipset(PlayerPedId(), 0.30 )
                LootBagCrouchLoop = false;
                FreezeEntityPosition(PlayerPedId(), false)
            end
        end
    else 
        tSentry.notify({'~r~You cannot open your inventory while dead.'})
    end
end)


RegisterNetEvent('Sentry:InventoryOpen')
AddEventHandler('Sentry:InventoryOpen', function(toggle, lootbag)
    IsLootBagOpening = lootbag
    if IsLootBagOpening then
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

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
      RequestAnimDict(dict)
      Citizen.Wait(5)
    end
end



RegisterNetEvent('Sentry:ToggleNUIFocus')
AddEventHandler('Sentry:ToggleNUIFocus', function(value)
    --print('focus', value)
    SetNuiFocus(value, value)
    SetNuiFocusKeepInput(value)
end)

RegisterNetEvent('Sentry:SendSecondaryInventoryData')
AddEventHandler('Sentry:SendSecondaryInventoryData', function(InventoryData, CurrentKG, MaxKg)
    SendNUIMessage({action = 'loadSecondaryItems', items = InventoryData, CurrentKG = CurrentKG, MaxKG = MaxKg, invType = inventoryType})
    if debug then
        print('Sent secondary inventory data to client.')
    end
end)

RegisterNetEvent('Sentry:FetchPersonalInventory')
AddEventHandler('Sentry:FetchPersonalInventory', function(table, CurrentKG, MaxKG)
    SendNUIMessage({action = 'loadItems', items = table, CurrentKG = CurrentKG, MaxKG = MaxKG})
    if debug then
        print('Sent inventory data to client.')
    end
end)

RegisterNUICallback('UseBtn', function(data, cb)
    TriggerServerEvent('Sentry:UseItem', data.itemId, data.invType)
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    cb(true);
end)

RegisterNUICallback('TrashBtn', function(data, cb)
    TriggerServerEvent('Sentry:TrashItem', data.itemId, data.invType)
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    cb(true);
end)

RegisterNUICallback('GiveBtn', function(data, cb)
    TriggerServerEvent('Sentry:GiveItem', data.itemId, data.invType)
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    cb(true)
end)


RegisterNUICallback('MoveBtn', function(data, cb)
    if not IsLootBagOpening then
        TriggerServerEvent('Sentry:MoveItem', data.invType, data.itemId, VehTypeA)
        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    else 
        TriggerServerEvent('Sentry:MoveItem', 'LootBag', data.itemId, LootBagIDNew)
        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    end
    cb(true)
end)

RegisterNUICallback('MoveXBtn', function(data, cb)
    if not IsLootBagOpening then
        TriggerServerEvent('Sentry:MoveItemX', data.invType, data.itemId, VehTypeA)
    else 
        TriggerServerEvent('Sentry:MoveItemX', 'LootBag', data.itemId, LootBagIDNew)
    end
    cb(true)
end)


RegisterNUICallback('MoveAllBtn', function(data, cb)
    if not IsLootBagOpening then
        TriggerServerEvent('Sentry:MoveItemAll', data.invType, data.itemId, VehTypeA)
    else 
        TriggerServerEvent('Sentry:MoveItemAll', 'LootBag', data.itemId, LootBagIDNew)
    end
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
            if #(BootCar - GetEntityCoords(PlayerPedId())) > 2.0 then 
                inventoryOpen = false;
                SetNuiFocus(false, false)
                SetNuiFocusKeepInput(false)
                SendNUIMessage({action = 'InventoryDisplay', showInv = false})
                tSentry.vc_closeDoor({VehTypeC, 5})
                BootCar = nil;
                VehTypeC = nil;
                VehTypeA = nil;
                inventoryType = nil;
            end
        end
        if inventoryOpen then
            if tSentry.isInComa({}) then
                inventoryOpen = false;
                SetNuiFocus(false, false)
                SetNuiFocusKeepInput(false)
                SendNUIMessage({action = 'InventoryDisplay', showInv = false})
                inventoryType = nil;
                if BootCar then
                    tSentry.vc_closeDoor({VehTypeC, 5})
                    BootCar = nil;
                    VehTypeC = nil;
                    VehTypeA = nil;
                end
            end
        end
    end
end)

RegisterKeyMapping('inventory', 'Opens / Closes your inventory', 'keyboard', 'L')


RegisterCommand('gun', function()
    GiveWeaponToPed(PlayerPedId(), GetHashKey('WEAPON_PISTOL'), 250, false, false)
end)


-- LOOT BAG CODE BELOW 


AddEventHandler('Sentry:IsInComa', function(coma)
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
            if DoesObjectOfTypeExistAtCoords(coords, 1.5, model, true) then
                if not NearLootBag then
                    NearLootBag = true;
                    LootBagID = GetClosestObjectOfType(coords, 1.5, model, false, false, false)
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

Citizen.CreateThread(function()
    while true do 
        Wait(0)
        if NearLootBag then 
            Draw3DText(LootBagCoords, "~g~~w~[~r~E~w~] to loot")
            if IsControlJustPressed(0, 38) then
                TriggerServerEvent('Sentry:LootBag', LootBagIDNew)
            end
        end
    end
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