-- A JamesUK Production. Licensed users only. Use without authorisation is illegal, and a criminal offence under UK Law.
local Tunnel = module("lvl", "lib/Tunnel")
local Proxy = module("lvl", "lib/Proxy")
local LVL = Proxy.getInterface("LVL")
local LVLclient = Tunnel.getInterface("LVL","LVL") -- server -> client tunnel
local Inventory = module("lvl", "cfg/inventory")
local InventorySpamTrack = {} -- Stops inventory being spammed by users.
local LootBagEntities = {}
local InventoryCoolDown = {}


RegisterNetEvent('LVL:FetchPersonalInventory')
AddEventHandler('LVL:FetchPersonalInventory', function()
    local source = source
    if not InventorySpamTrack[source] then
        InventorySpamTrack[source] = true;
        local UserId = LVL.getUserId({source}) 
        local data = LVL.getUserDataTable({UserId})
        if data and data.inventory then
            local FormattedInventoryData = {}
            --print(json.encode(data.inventory))
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
            end
            TriggerClientEvent('LVL:FetchPersonalInventory', source, FormattedInventoryData, LVL.computeItemsWeight({data.inventory}), LVL.getInventoryMaxWeight({UserId}))
            InventorySpamTrack[source] = false;
        else 
            print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
        end
    end
end)


AddEventHandler('LVL:RefreshInventory', function(source)
    local UserId = LVL.getUserId({source}) 
    local data = LVL.getUserDataTable({UserId})
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
        end
        TriggerClientEvent('LVL:FetchPersonalInventory', source, FormattedInventoryData, LVL.computeItemsWeight({data.inventory}), LVL.getInventoryMaxWeight({UserId}))
    else 
        print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)

RegisterNetEvent('LVL:GiveItem')
AddEventHandler('LVL:GiveItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  LVLclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        LVL.RunGiveTask({source, itemId})
    else
        LVLclient.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)

RegisterNetEvent('LVL:TrashItem')
AddEventHandler('LVL:TrashItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  LVLclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        LVL.RunTrashTask({source, itemId})
    else
        LVLclient.notify(source, {'~r~You need to have this item on you to drop it.'})
    end
end)

RegisterServerEvent("ORP:flashLights")
AddEventHandler("ORP:flashLights", function(nearestVeh)
    local nearestVeh = nearestVeh
    TriggerClientEvent("ORP:flashCarLightsAlarm", -1, nearestVeh)

end) 

RegisterNetEvent('LVL:FetchTrunkInventory')
AddEventHandler('LVL:FetchTrunkInventory', function(spawnCode)
    local source = source
    local user_id = LVL.getUserId({source})
    if InventoryCoolDown[source] then LVLclient.notify(source, {'~r~The server is still processing your request.'}) return end
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    LVL.getSData({carformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
        end
        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({cdata}), maxVehKg)
    end})
end)

RegisterNetEvent('Jud:FetchHouseInventory')
AddEventHandler('Jud:FetchHouseInventory', function()
    local source = source
    local user_id = LVL.getUserId({source})
    local homeformat = "chest:u" .. user_id .. "home"
    LVL.getSData({homeformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
        end
        local maxVehKg = 500
        TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({cdata}), maxVehKg)
    end})
end)

RegisterNetEvent('LVL:UseItem')
AddEventHandler('LVL:UseItem', function(itemId, itemLoc)
    local source = source
    if not itemId then    LVLclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        LVL.RunInventoryTask({source, itemId})
        
    else
        LVLclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)


RegisterNetEvent('LVL:MoveItem')
AddEventHandler('LVL:MoveItem', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local UserId = LVL.getUserId({source}) 
    local data = LVL.getUserDataTable({UserId})
    if InventoryCoolDown[source] then LVLclient.notify(source, {'~r~The server is still processing your request.'}) return end
    if not itemId then  LVLclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local Quantity = parseInt(1)
            if Quantity then
                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                LVL.getSData({carformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and cdata[itemId].amount >= 1 then
                        local weightCalculation = LVL.getInventoryWeight({UserId})+LVL.getItemWeight({itemId})
                        if weightCalculation <= LVL.getInventoryMaxWeight({UserId}) then
                            if cdata[itemId].amount > 1 then
                                cdata[itemId].amount = cdata[itemId].amount - 1; 
                                LVL.giveInventoryItem({UserId, itemId, 1, true})
                            else 
                                cdata[itemId] = nil;
                                LVL.giveInventoryItem({UserId, itemId, 1, true})
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                            end
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({cdata}), maxVehKg)
                            TriggerEvent('LVL:RefreshInventory', source)
                            InventoryCoolDown[source] = false;
                            LVL.setSData({carformat, json.encode(cdata)})
                        else 
                            InventoryCoolDown[source] = false;
                            LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        InventoryCoolDown[source] = false;
                        print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                    end
                end})
            end
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                local weightCalculation = LVL.getInventoryWeight({UserId})+LVL.getItemWeight({itemId})
                if weightCalculation <= LVL.getInventoryMaxWeight({UserId}) then
                    if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > 1 then
                        LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - 1 
                        LVL.giveInventoryItem({UserId, itemId, 1, true})
                    else 
                        LootBagEntities[inventoryInfo].Items[itemId] = nil;
                        LVL.giveInventoryItem({UserId, itemId, 1, true})
                    end
                    local FormattedInventoryData = {}
                    for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                        FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                    end
                    local maxVehKg = 200
                    TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                    TriggerEvent('LVL:RefreshInventory', source)
                else 
                    LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                end
            end
        elseif inventoryType == "Housing" then
            local Quantity = parseInt(1)
            if Quantity then
                local homeformat = "chest:u" .. UserId .. "home"
                LVL.getSData({homeformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and cdata[itemId].amount >= 1 then
                        local weightCalculation = LVL.getInventoryWeight({UserId})+LVL.getItemWeight({itemId})
                        if weightCalculation <= LVL.getInventoryMaxWeight({UserId}) then
                            if cdata[itemId].amount > 1 then
                                cdata[itemId].amount = cdata[itemId].amount - 1; 
                                LVL.giveInventoryItem({UserId, itemId, 1, true})
                            else 
                                cdata[itemId] = nil;
                                LVL.giveInventoryItem({UserId, itemId, 1, true})
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                            end
                            local maxVehKg = 500
                            TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({cdata}), maxVehKg)
                            TriggerEvent('LVL:RefreshInventory', source)
                            LVL.setSData({"chest:u" .. UserId .. "home", json.encode(cdata)})
                        else 
                            LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the home.')
                    end
                end})
            end
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitem)
                        local homeFormat = "chest:u" .. UserId .. "home"
                        LVL.getSData({homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = LVL.computeItemsWeight({cdata})+LVL.getItemWeight({itemId})
                                local maxVehKg = 500
                                if weightCalculation <= maxVehKg then
                                    if LVL.tryGetInventoryItem({UserId, itemId, 1, true}) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                                    end
                                    local maxVehKg = 500
                                    TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('LVL:RefreshInventory', source)
                                    LVL.setSData({"chest:u" .. UserId .. "home", json.encode(cdata)})
                                else 
                                    LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the home.')
                            end
                        end}) --end of housing intergration (moveitem)
                    else
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                        LVL.getSData({carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = LVL.computeItemsWeight({cdata})+LVL.getItemWeight({itemId})
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if LVL.tryGetInventoryItem({UserId, itemId, 1, true}) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('LVL:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    LVL.setSData({carformat, json.encode(cdata)})
                                else 
                                    InventoryCoolDown[source] = nil;
                                    LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                            end
                        end})
                    end
                else
                    InventoryCoolDown[source] = nil;
                    print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        InventoryCoolDown[source] = nil;
        print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)



RegisterNetEvent('LVL:MoveItemX')
AddEventHandler('LVL:MoveItemX', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local UserId = LVL.getUserId({source}) 
    local data = LVL.getUserDataTable({UserId})
    if InventoryCoolDown[source] then LVLclient.notify(source, {'~r~The server is still processing your request.'}) return end
    if not itemId then  LVLclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            TriggerClientEvent('LVL:ToggleNUIFocus', source, false)
            LVL.prompt({source, 'How many ' .. LVL.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                Quantity = parseInt(Quantity)
        
                
                    TriggerClientEvent('LVL:ToggleNUIFocus', source, true)
                    if Quantity >= 1 then
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                        LVL.getSData({carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                                local weightCalculation = LVL.getInventoryWeight({UserId})+(LVL.getItemWeight({itemId}) * Quantity)
                                if weightCalculation <= LVL.getInventoryMaxWeight({UserId}) then
                                    if cdata[itemId].amount > Quantity then
                                        cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                        LVL.giveInventoryItem({UserId, itemId, Quantity, true})
                                    else 
                                        cdata[itemId] = nil;
                                        LVL.giveInventoryItem({UserId, itemId, Quantity, true})
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('LVL:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    LVL.setSData({carformat, json.encode(cdata)})
                                else 
                                    InventoryCoolDown[source] = nil;
                                    LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                LVLclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end})
                    else
                        InventoryCoolDown[source] = nil;
                        LVLclient.notify(source, {'~r~Invalid Amount!'})
                    end
  
             
    
            end})
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                TriggerClientEvent('LVL:ToggleNUIFocus', source, false)
                LVL.prompt({source, 'How many ' .. LVL.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                    Quantity = parseInt(Quantity)
                    TriggerClientEvent('LVL:ToggleNUIFocus', source, true)
                    if Quantity then
                        local weightCalculation = LVL.getInventoryWeight({UserId})+(LVL.getItemWeight({itemId}) * Quantity)
                        if weightCalculation <= LVL.getInventoryMaxWeight({UserId}) then
                            if Quantity <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                                if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > Quantity then
                                    LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - Quantity
                                    LVL.giveInventoryItem({UserId, itemId, Quantity, true})
                                else 
                                    LootBagEntities[inventoryInfo].Items[itemId] = nil;
                                    LVL.giveInventoryItem({UserId, itemId, Quantity, true})
                                end
                                local FormattedInventoryData = {}
                                for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                                end
                                local maxVehKg = 200
                                TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                                TriggerEvent('LVL:RefreshInventory', source)
                            else 
                                LVLclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end 
                        else 
                            LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        LVLclient.notify(source, {'~r~Invalid input!'})
                    end
                end})
            end
        elseif inventoryType == "Housing" then
            TriggerClientEvent('LVL:ToggleNUIFocus', source, false)
            LVL.prompt({source, 'How many ' .. LVL.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                Quantity = parseInt(Quantity)
                TriggerClientEvent('LVL:ToggleNUIFocus', source, true)
                if Quantity then
                    local homeformat = "chest:u" .. UserId .. "home"
                    LVL.getSData({homeformat, function(cdata)
                        cdata = json.decode(cdata) or {}
                        if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                            local weightCalculation = LVL.getInventoryWeight({UserId})+(LVL.getItemWeight({itemId}) * Quantity)
                            if weightCalculation <= LVL.getInventoryMaxWeight({UserId}) then
                                if cdata[itemId].amount > Quantity then
                                    cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                    LVL.giveInventoryItem({UserId, itemId, Quantity, true})
                                else 
                                    cdata[itemId] = nil;
                                    LVL.giveInventoryItem({UserId, itemId, Quantity, true})
                                end 
                                local FormattedInventoryData = {}
                                for i, v in pairs(cdata) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                                end
                                local maxVehKg = 500
                                TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({cdata}), maxVehKg)
                                TriggerEvent('LVL:RefreshInventory', source)
                                LVL.setSData({"chest:u" .. UserId .. "home", json.encode(cdata)})
                            else 
                                LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                            end
                        else 
                            LVLclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end
                    end})
                else 
                    LVLclient.notify(source, {'~r~Invalid input!'})
                end
            end})
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitemx)
                        TriggerClientEvent('LVL:ToggleNUIFocus', source, false)
                        LVL.prompt({source, 'How many ' .. LVL.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                            Quantity = parseInt(Quantity)
                            TriggerClientEvent('LVL:ToggleNUIFocus', source, true)
                            if Quantity then
                                local homeFormat = "chest:u" .. UserId .. "home"
                                LVL.getSData({homeFormat, function(cdata)
                                    cdata = json.decode(cdata) or {}
                                    if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                        local weightCalculation = LVL.computeItemsWeight({cdata})+(LVL.getItemWeight({itemId}) * Quantity)
                                        local maxVehKg = 500
                                        if weightCalculation <= maxVehKg then
                                            if LVL.tryGetInventoryItem({UserId, itemId, Quantity, true}) then
                                                if cdata[itemId] then
                                                    cdata[itemId].amount = cdata[itemId].amount + Quantity
                                                else 
                                                    cdata[itemId] = {}
                                                    cdata[itemId].amount = Quantity
                                                end
                                            end 
                                            local FormattedInventoryData = {}
                                            for i, v in pairs(cdata) do
                                                FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                                            end
                                            local maxVehKg = 500
                                            TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({cdata}), maxVehKg)
                                            TriggerEvent('LVL:RefreshInventory', source)
                                            LVL.setSData({"chest:u" .. UserId .. "home", json.encode(cdata)})
                                        else 
                                            LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                                        end
                                    else 
                                        LVLclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                    end
                                end})
                            else 
                                LVLclient.notify(source, {'~r~Invalid input!'})
                            end
                        end}) --end of housing intergration (moveitemx)
                    else
                        InventoryCoolDown[source] = true;
                        TriggerClientEvent('LVL:ToggleNUIFocus', source, false)
                        LVL.prompt({source, 'How many ' .. LVL.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                            Quantity = parseInt(Quantity)
                            TriggerClientEvent('LVL:ToggleNUIFocus', source, true)
                            if Quantity then
                                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                                LVL.getSData({carformat, function(cdata)
                                    cdata = json.decode(cdata) or {}
                                    if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                        local weightCalculation = LVL.computeItemsWeight({cdata})+(LVL.getItemWeight({itemId}) * Quantity)
                                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                        if weightCalculation <= maxVehKg then
                                            if LVL.tryGetInventoryItem({UserId, itemId, Quantity, true}) then
                                                if cdata[itemId] then
                                                    cdata[itemId].amount = cdata[itemId].amount + Quantity
                                                else 
                                                    cdata[itemId] = {}
                                                    cdata[itemId].amount = Quantity
                                                end
                                            end 
                                            local FormattedInventoryData = {}
                                            for i, v in pairs(cdata) do
                                                FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                                            end
                                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                            TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({cdata}), maxVehKg)
                                            TriggerEvent('LVL:RefreshInventory', source)
                                            InventoryCoolDown[source] = nil;
                                            LVL.setSData({carformat, json.encode(cdata)})
                                        else 
                                            InventoryCoolDown[source] = nil;
                                            LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                                        end
                                    else 
                                        InventoryCoolDown[source] = nil;
                                        LVLclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                    end
                                end})
                            else 
                                LVLclient.notify(source, {'~r~Invalid input!'})
                            end
                        end})
                    end
                else
                    print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


RegisterNetEvent('LVL:MoveItemAll')
AddEventHandler('LVL:MoveItemAll', function(inventoryType, itemId, inventoryInfo, vehid)
    local source = source
    local UserId = LVL.getUserId({source}) 
    local data = LVL.getUserDataTable({UserId})
    if not itemId then  LVLclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if InventoryCoolDown[source] then LVLclient.notify(source, {'~r~The server is still processing your request.'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
                local idz = NetworkGetEntityFromNetworkId(vehid)
             local user_id = LVL.getUserId({NetworkGetEntityOwner(idz)})
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
            LVL.getSData({carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = LVL.getInventoryWeight({user_id})+(LVL.getItemWeight({itemId}) * cdata[itemId].amount)
                    if weightCalculation <= LVL.getInventoryMaxWeight({user_id}) then
                        LVL.giveInventoryItem({user_id, itemId, cdata[itemId].amount, true})
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({cdata}), maxVehKg)
                        TriggerEvent('LVL:RefreshInventory', source)
                        InventoryCoolDown[source] = nil;
                        LVL.setSData({carformat, json.encode(cdata)})
                    else 
                        InventoryCoolDown[source] = nil;
                        LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    InventoryCoolDown[source] = nil;
                    LVLclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end})
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                local weightCalculation = LVL.getInventoryWeight({UserId})+(LVL.getItemWeight({itemId}) *  LootBagEntities[inventoryInfo].Items[itemId].amount)
                if weightCalculation <= LVL.getInventoryMaxWeight({UserId}) then
                    if  LootBagEntities[inventoryInfo].Items[itemId].amount <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                        LVL.giveInventoryItem({UserId, itemId, LootBagEntities[inventoryInfo].Items[itemId].amount, true})
                        LootBagEntities[inventoryInfo].Items[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                        end
                        local maxVehKg = 200
                        TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                        TriggerEvent('LVL:RefreshInventory', source)
                    else 
                        LVLclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end 
                else 
                    LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                end
            end
        elseif inventoryType == "Housing" then
            local homeformat = "chest:u" .. UserId .. "home"
            LVL.getSData({homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = LVL.getInventoryWeight({UserId})+(LVL.getItemWeight({itemId}) * cdata[itemId].amount)
                    if weightCalculation <= LVL.getInventoryMaxWeight({UserId}) then
                        LVL.giveInventoryItem({UserId, itemId, cdata[itemId].amount, true})
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                        end
                        local maxVehKg = 500
                        TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({cdata}), maxVehKg)
                        TriggerEvent('LVL:RefreshInventory', source)
                        LVL.setSData({"chest:u" .. UserId .. "home", json.encode(cdata)})
                    else 
                        LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    LVLclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end})
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitemall)
                        local homeFormat = "chest:u" .. UserId .. "home"
                        LVL.getSData({homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local weightCalculation = LVL.computeItemsWeight({cdata})+(LVL.getItemWeight({itemId}) * data.inventory[itemId].amount)
                                local maxVehKg = 500
                                if weightCalculation <= maxVehKg then
                                    if LVL.tryGetInventoryItem({UserId, itemId, data.inventory[itemId].amount, true}) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + data.inventory[itemId].amount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = data.inventory[itemId].amount
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                                    end
                                    local maxVehKg = 500
                                    TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('LVL:RefreshInventory', source)
                                    LVL.setSData({"chest:u" .. UserId .. "home", json.encode(cdata)})
                                else 
                                    LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                LVLclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end}) --end of housing intergration (moveitemall)
                    else 
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                        LVL.getSData({carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local weightCalculation = LVL.computeItemsWeight({cdata})+(LVL.getItemWeight({itemId}) * data.inventory[itemId].amount)
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if LVL.tryGetInventoryItem({UserId, itemId, data.inventory[itemId].amount, true}) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + data.inventory[itemId].amount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = data.inventory[itemId].amount
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('LVL:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    LVL.setSData({carformat, json.encode(cdata)})
                                else 
                                    InventoryCoolDown[source] = nil;
                                    LVLclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                LVLclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end})
                    end
                else
                    InventoryCoolDown[source] = nil;
                    print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        InventoryCoolDown[source] = nil;
        print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


-- LOOTBAGS CODE BELOW HERE 

RegisterNetEvent('LVL:InComa')
AddEventHandler('LVL:InComa', function()
    local source = source
    LVLclient.isInComa(source, {}, function(in_coma) 
        if in_coma then
            Wait(1500)
            local user_id = LVL.getUserId({source})
            local model = GetHashKey('xm_prop_x17_bag_med_01a')
            local name1 = GetPlayerName(source)
            local lootbag = CreateObjectNoOffset(model, GetEntityCoords(GetPlayerPed(source)) + 0.4, true, true, false)
            local lootbagnetid = NetworkGetNetworkIdFromEntity(lootbag)
            LootBagEntities[lootbagnetid] = {lootbag, lootbag, false, source}
            LootBagEntities[lootbagnetid].Items = {}
            LootBagEntities[lootbagnetid].name = name1 
            local ndata = LVL.getUserDataTable({user_id})
            local stored_inventory = nil;
            if ndata ~= nil then
                if ndata.inventory ~= nil then
                    stored_inventory = ndata.inventory
                    LVL.clearInventory({user_id})
                    for k, v in pairs(stored_inventory) do
                        LootBagEntities[lootbagnetid].Items[k] = {}
                        LootBagEntities[lootbagnetid].Items[k].amount = v.amount
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('LVL:LootBag')
AddEventHandler('LVL:LootBag', function(netid)
    local source = source
    LVLclient.isInComa(source, {}, function(in_coma) 
        if not in_coma then
            if LootBagEntities[netid] and not LootBagEntities[netid][3] and #(GetEntityCoords(LootBagEntities[netid][1]) - GetEntityCoords(GetPlayerPed(source))) < 5.0 then
                LootBagEntities[netid][3] = true;
                local user_id = LVL.getUserId({source})
                if user_id ~= nil then
                    LootBagEntities[netid][5] = source
                    OpenInv(source, netid, LootBagEntities[netid].Items)
                    LVLclient.notify(source,{"~b~You have opened " .. LootBagEntities[netid].name .. "'s lootbag"})
                end
            else
                --LVLclient.notify(source, {'~r~This loot bag is already being looted.'})
            end
        else 
            LVLclient.notify(source, {'~r~You cannot open this while dead silly.'})
        end
    end)
end)

Citizen.CreateThread(function()
    while true do 
        Wait(250)
        for i,v in pairs(LootBagEntities) do 
            if v[5] then 
                local coords = GetEntityCoords(GetPlayerPed(v[5]))
                local objectcoords = GetEntityCoords(v[1])
                if #(objectcoords - coords) > 5.0 then
                    CloseInv(v[5])
                    Wait(3000)
                    v[3] = false; 
                    v[5] = nil;
                end
            end
        end
    end
end)

RegisterNetEvent('LVL:CloseLootbag')
AddEventHandler('LVL:CloseLootbag', function()
    local source = source
    for i,v in pairs(LootBagEntities) do 
        if v[5] and v[5] == source then 
            CloseInv(v[5])
            Wait(3000)
            v[3] = false; 
            v[5] = nil;
        end
    end
end)

function CloseInv(source)
    TriggerClientEvent('LVL:InventoryOpen', source, false, false)
end

function OpenInv(source, netid, LootBagItems)
    local UserId = LVL.getUserId({source})
    local data = LVL.getUserDataTable({UserId})
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
        end
        TriggerClientEvent('LVL:FetchPersonalInventory', source, FormattedInventoryData, LVL.computeItemsWeight({data.inventory}), LVL.getInventoryMaxWeight({UserId}))
        InventorySpamTrack[source] = false;
    else 
        print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
    TriggerClientEvent('LVL:InventoryOpen', source, true, true)
    local FormattedInventoryData = {}
    for i, v in pairs(LootBagItems) do
        FormattedInventoryData[i] = {amount = v.amount, ItemName = LVL.getItemName({i}), Weight = LVL.getItemWeight({i})}
    end
    local maxVehKg = 200
    TriggerClientEvent('LVL:SendSecondaryInventoryData', source, FormattedInventoryData, LVL.computeItemsWeight({LootBagItems}), maxVehKg)
    print(json.encode(FormattedInventoryData))
end


-- Garabge collector for empty lootbags.
Citizen.CreateThread(function()
    while true do 
        Wait(500)
        for i,v in pairs(LootBagEntities) do 
            local itemCount = 0;
            for i,v in pairs(v.Items) do
                itemCount = itemCount + 1
            end
            if itemCount == 0 then
                if DoesEntityExist(v[1]) then 
                    DeleteEntity(v[1])
                    --print('Deleted Lootbag')
                    LootBagEntities[i] = nil;
                end
            end
        end
        --print('All Lootbag garbage collected.')
    end
end)