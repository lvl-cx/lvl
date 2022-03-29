-- A JamesUK Production. Licensed users only. Use without authorisation is illegal, and a criminal offence under UK Law.
local Tunnel = module("sentry", "lib/Tunnel")
local Proxy = module("sentry", "lib/Proxy")
local Sentry = Proxy.getInterface("Sentry")
local Sentryclient = Tunnel.getInterface("Sentry","Sentry") -- server -> client tunnel
local Inventory = module("sentry", "cfg/inventory")
local InventorySpamTrack = {} -- Stops inventory being spammed by users.
local LootBagEntities = {}
local InventoryCoolDown = {}


RegisterNetEvent('Sentry:FetchPersonalInventory')
AddEventHandler('Sentry:FetchPersonalInventory', function()
    local source = source
    if not InventorySpamTrack[source] then
        InventorySpamTrack[source] = true;
        local UserId = Sentry.getUserId({source}) 
        local data = Sentry.getUserDataTable({UserId})
        if data and data.inventory then
            local FormattedInventoryData = {}
            --print(json.encode(data.inventory))
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = Sentry.getItemName({i}), Weight = Sentry.getItemWeight({i})}
            end
            TriggerClientEvent('Sentry:FetchPersonalInventory', source, FormattedInventoryData, Sentry.computeItemsWeight({data.inventory}), Sentry.getInventoryMaxWeight({UserId}))
            InventorySpamTrack[source] = false;
        else 
            print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
        end
    end
end)


AddEventHandler('Sentry:RefreshInventory', function(source)
    local UserId = Sentry.getUserId({source}) 
    local data = Sentry.getUserDataTable({UserId})
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = Sentry.getItemName({i}), Weight = Sentry.getItemWeight({i})}
        end
        TriggerClientEvent('Sentry:FetchPersonalInventory', source, FormattedInventoryData, Sentry.computeItemsWeight({data.inventory}), Sentry.getInventoryMaxWeight({UserId}))
    else 
        print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)

RegisterNetEvent('Sentry:GiveItem')
AddEventHandler('Sentry:GiveItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  Sentryclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        Sentry.RunGiveTask({source, itemId})
    else
        Sentryclient.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)

RegisterNetEvent('Sentry:TrashItem')
AddEventHandler('Sentry:TrashItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  Sentryclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        Sentry.RunTrashTask({source, itemId})
    else
        Sentryclient.notify(source, {'~r~You need to have this item on you to drop it.'})
    end
end)

RegisterNetEvent('Sentry:FetchTrunkInventory')
AddEventHandler('Sentry:FetchTrunkInventory', function(spawnCode)
    local source = source
    local user_id = Sentry.getUserId({source})
    if InventoryCoolDown[source] then Sentryclient.notify(source, {'~r~The server is still processing your request.'}) return end
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    Sentry.getSData({carformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = Sentry.getItemName({i}), Weight = Sentry.getItemWeight({i})}
        end
        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        TriggerClientEvent('Sentry:SendSecondaryInventoryData', source, FormattedInventoryData, Sentry.computeItemsWeight({cdata}), maxVehKg)
    end})
end)



RegisterNetEvent('Sentry:UseItem')
AddEventHandler('Sentry:UseItem', function(itemId, itemLoc)
    local source = source
    if not itemId then    Sentryclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        Sentry.RunInventoryTask({source, itemId})
    else
        Sentryclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)


RegisterNetEvent('Sentry:MoveItem')
AddEventHandler('Sentry:MoveItem', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local UserId = Sentry.getUserId({source}) 
    local data = Sentry.getUserDataTable({UserId})
    if InventoryCoolDown[source] then Sentryclient.notify(source, {'~r~The server is still processing your request.'}) return end
    if not itemId then  Sentryclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local Quantity = parseInt(1)
            if Quantity then
                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                Sentry.getSData({carformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and cdata[itemId].amount >= 1 then
                        local weightCalculation = Sentry.getInventoryWeight({UserId})+Sentry.getItemWeight({itemId})
                        if weightCalculation <= Sentry.getInventoryMaxWeight({UserId}) then
                            if cdata[itemId].amount > 1 then
                                cdata[itemId].amount = cdata[itemId].amount - 1; 
                                Sentry.giveInventoryItem({UserId, itemId, 1, true})
                            else 
                                cdata[itemId] = nil;
                                Sentry.giveInventoryItem({UserId, itemId, 1, true})
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = Sentry.getItemName({i}), Weight = Sentry.getItemWeight({i})}
                            end
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            TriggerClientEvent('Sentry:SendSecondaryInventoryData', source, FormattedInventoryData, Sentry.computeItemsWeight({cdata}), maxVehKg)
                            TriggerEvent('Sentry:RefreshInventory', source)
                            InventoryCoolDown[source] = false;
                            Sentry.setSData({carformat, json.encode(cdata)})
                        else 
                            InventoryCoolDown[source] = false;
                            Sentryclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        InventoryCoolDown[source] = false;
                        print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                    end
                end})
            end
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                local weightCalculation = Sentry.getInventoryWeight({UserId})+Sentry.getItemWeight({itemId})
                if weightCalculation <= Sentry.getInventoryMaxWeight({UserId}) then
                    if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > 1 then
                        LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - 1 
                        Sentry.giveInventoryItem({UserId, itemId, 1, true})
                    else 
                        LootBagEntities[inventoryInfo].Items[itemId] = nil;
                        Sentry.giveInventoryItem({UserId, itemId, 1, true})
                    end
                    local FormattedInventoryData = {}
                    for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                        FormattedInventoryData[i] = {amount = v.amount, ItemName = Sentry.getItemName({i}), Weight = Sentry.getItemWeight({i})}
                    end
                    local maxVehKg = 200
                    TriggerClientEvent('Sentry:SendSecondaryInventoryData', source, FormattedInventoryData, Sentry.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                    TriggerEvent('Sentry:RefreshInventory', source)
                else 
                    Sentryclient.notify(source, {'~r~You do not have enough inventory space.'})
                end
            end
        elseif inventoryType == "Housing" then
            -- Housing integration..
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    InventoryCoolDown[source] = true;
                    local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                    Sentry.getSData({carformat, function(cdata)
                        cdata = json.decode(cdata) or {}
                        if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                            local weightCalculation = Sentry.computeItemsWeight({cdata})+Sentry.getItemWeight({itemId})
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            if weightCalculation <= maxVehKg then
                                if Sentry.tryGetInventoryItem({UserId, itemId, 1, true}) then
                                    if cdata[itemId] then
                                       cdata[itemId].amount = cdata[itemId].amount + 1
                                    else 
                                        cdata[itemId] = {}
                                        cdata[itemId].amount = 1
                                    end
                                end 
                                local FormattedInventoryData = {}
                                for i, v in pairs(cdata) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = Sentry.getItemName({i}), Weight = Sentry.getItemWeight({i})}
                                end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                TriggerClientEvent('Sentry:SendSecondaryInventoryData', source, FormattedInventoryData, Sentry.computeItemsWeight({cdata}), maxVehKg)
                                TriggerEvent('Sentry:RefreshInventory', source)
                                InventoryCoolDown[source] = nil;
                                Sentry.setSData({carformat, json.encode(cdata)})
                            else 
                                InventoryCoolDown[source] = nil;
                                Sentryclient.notify(source, {'~r~You do not have enough inventory space.'})
                            end
                        else 
                            InventoryCoolDown[source] = nil;
                            print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                        end
                    end})
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



RegisterNetEvent('Sentry:MoveItemX')
AddEventHandler('Sentry:MoveItemX', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local UserId = Sentry.getUserId({source}) 
    local data = Sentry.getUserDataTable({UserId})
    if InventoryCoolDown[source] then Sentryclient.notify(source, {'~r~The server is still processing your request.'}) return end
    if not itemId then  Sentryclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            TriggerClientEvent('Sentry:ToggleNUIFocus', source, false)
            Sentry.prompt({source, 'How many ' .. Sentry.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                Quantity = parseInt(Quantity)
                TriggerClientEvent('Sentry:ToggleNUIFocus', source, true)
                if Quantity then
                    local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                    Sentry.getSData({carformat, function(cdata)
                        cdata = json.decode(cdata) or {}
                        if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                            local weightCalculation = Sentry.getInventoryWeight({UserId})+(Sentry.getItemWeight({itemId}) * Quantity)
                            if weightCalculation <= Sentry.getInventoryMaxWeight({UserId}) then
                                if cdata[itemId].amount > Quantity then
                                    cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                    Sentry.giveInventoryItem({UserId, itemId, Quantity, true})
                                else 
                                    cdata[itemId] = nil;
                                    Sentry.giveInventoryItem({UserId, itemId, Quantity, true})
                                end 
                                local FormattedInventoryData = {}
                                for i, v in pairs(cdata) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = Sentry.getItemName({i}), Weight = Sentry.getItemWeight({i})}
                                end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                TriggerClientEvent('Sentry:SendSecondaryInventoryData', source, FormattedInventoryData, Sentry.computeItemsWeight({cdata}), maxVehKg)
                                TriggerEvent('Sentry:RefreshInventory', source)
                                InventoryCoolDown[source] = nil;
                                Sentry.setSData({carformat, json.encode(cdata)})
                            else 
                                InventoryCoolDown[source] = nil;
                                Sentryclient.notify(source, {'~r~You do not have enough inventory space.'})
                            end
                        else 
                            InventoryCoolDown[source] = nil;
                            Sentryclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end
                    end})
                else 
                    Sentryclient.notify(source, {'~r~Invalid input!'})
                end
            end})
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                TriggerClientEvent('Sentry:ToggleNUIFocus', source, false)
                Sentry.prompt({source, 'How many ' .. Sentry.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                    Quantity = parseInt(Quantity)
                    TriggerClientEvent('Sentry:ToggleNUIFocus', source, true)
                    if Quantity then
                        local weightCalculation = Sentry.getInventoryWeight({UserId})+(Sentry.getItemWeight({itemId}) * Quantity)
                        if weightCalculation <= Sentry.getInventoryMaxWeight({UserId}) then
                            if Quantity <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                                if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > Quantity then
                                    LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - Quantity
                                    Sentry.giveInventoryItem({UserId, itemId, Quantity, true})
                                else 
                                    LootBagEntities[inventoryInfo].Items[itemId] = nil;
                                    Sentry.giveInventoryItem({UserId, itemId, Quantity, true})
                                end
                                local FormattedInventoryData = {}
                                for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = Sentry.getItemName({i}), Weight = Sentry.getItemWeight({i})}
                                end
                                local maxVehKg = 200
                                TriggerClientEvent('Sentry:SendSecondaryInventoryData', source, FormattedInventoryData, Sentry.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                                TriggerEvent('Sentry:RefreshInventory', source)
                            else 
                                Sentryclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end 
                        else 
                            Sentryclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        Sentryclient.notify(source, {'~r~Invalid input!'})
                    end
                end})
            end
        elseif inventoryType == "Housing" then
            -- Housing integration..
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    InventoryCoolDown[source] = true;
                    TriggerClientEvent('Sentry:ToggleNUIFocus', source, false)
                    Sentry.prompt({source, 'How many ' .. Sentry.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                        Quantity = parseInt(Quantity)
                        TriggerClientEvent('Sentry:ToggleNUIFocus', source, true)
                        if Quantity then
                            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                            Sentry.getSData({carformat, function(cdata)
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                    local weightCalculation = Sentry.computeItemsWeight({cdata})+(Sentry.getItemWeight({itemId}) * Quantity)
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    if weightCalculation <= maxVehKg then
                                        if Sentry.tryGetInventoryItem({UserId, itemId, Quantity, true}) then
                                            if cdata[itemId] then
                                                cdata[itemId].amount = cdata[itemId].amount + Quantity
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = Quantity
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, ItemName = Sentry.getItemName({i}), Weight = Sentry.getItemWeight({i})}
                                        end
                                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                        TriggerClientEvent('Sentry:SendSecondaryInventoryData', source, FormattedInventoryData, Sentry.computeItemsWeight({cdata}), maxVehKg)
                                        TriggerEvent('Sentry:RefreshInventory', source)
                                        InventoryCoolDown[source] = nil;
                                        Sentry.setSData({carformat, json.encode(cdata)})
                                    else 
                                        InventoryCoolDown[source] = nil;
                                        Sentryclient.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                else 
                                    InventoryCoolDown[source] = nil;
                                    Sentryclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end
                            end})
                        else 
                            Sentryclient.notify(source, {'~r~Invalid input!'})
                        end
                    end})
                else
                    print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


RegisterNetEvent('Sentry:MoveItemAll')
AddEventHandler('Sentry:MoveItemAll', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local UserId = Sentry.getUserId({source}) 
    local data = Sentry.getUserDataTable({UserId})
    if not itemId then  Sentryclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if InventoryCoolDown[source] then Sentryclient.notify(source, {'~r~The server is still processing your request.'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
            Sentry.getSData({carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = Sentry.getInventoryWeight({UserId})+(Sentry.getItemWeight({itemId}) * cdata[itemId].amount)
                    if weightCalculation <= Sentry.getInventoryMaxWeight({UserId}) then
                        Sentry.giveInventoryItem({UserId, itemId, cdata[itemId].amount, true})
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = Sentry.getItemName({i}), Weight = Sentry.getItemWeight({i})}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('Sentry:SendSecondaryInventoryData', source, FormattedInventoryData, Sentry.computeItemsWeight({cdata}), maxVehKg)
                        TriggerEvent('Sentry:RefreshInventory', source)
                        InventoryCoolDown[source] = nil;
                        Sentry.setSData({carformat, json.encode(cdata)})
                    else 
                        InventoryCoolDown[source] = nil;
                        Sentryclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    InventoryCoolDown[source] = nil;
                    Sentryclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end})
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                local weightCalculation = Sentry.getInventoryWeight({UserId})+(Sentry.getItemWeight({itemId}) *  LootBagEntities[inventoryInfo].Items[itemId].amount)
                if weightCalculation <= Sentry.getInventoryMaxWeight({UserId}) then
                    if  LootBagEntities[inventoryInfo].Items[itemId].amount <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                        Sentry.giveInventoryItem({UserId, itemId, LootBagEntities[inventoryInfo].Items[itemId].amount, true})
                        LootBagEntities[inventoryInfo].Items[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = Sentry.getItemName({i}), Weight = Sentry.getItemWeight({i})}
                        end
                        local maxVehKg = 200
                        TriggerClientEvent('Sentry:SendSecondaryInventoryData', source, FormattedInventoryData, Sentry.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                        TriggerEvent('Sentry:RefreshInventory', source)
                    else 
                        Sentryclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end 
                else 
                    Sentryclient.notify(source, {'~r~You do not have enough inventory space.'})
                end
            end
        elseif inventoryType == "Housing" then
            -- Housing integration..
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    InventoryCoolDown[source] = true;
                    local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                    Sentry.getSData({carformat, function(cdata)
                        cdata = json.decode(cdata) or {}
                        if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                            local weightCalculation = Sentry.computeItemsWeight({cdata})+(Sentry.getItemWeight({itemId}) * data.inventory[itemId].amount)
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            if weightCalculation <= maxVehKg then
                                if Sentry.tryGetInventoryItem({UserId, itemId, data.inventory[itemId].amount, true}) then
                                    if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + data.inventory[itemId].amount
                                    else 
                                        cdata[itemId] = {}
                                        cdata[itemId].amount = data.inventory[itemId].amount
                                    end
                                end 
                                local FormattedInventoryData = {}
                                for i, v in pairs(cdata) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = Sentry.getItemName({i}), Weight = Sentry.getItemWeight({i})}
                                end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                TriggerClientEvent('Sentry:SendSecondaryInventoryData', source, FormattedInventoryData, Sentry.computeItemsWeight({cdata}), maxVehKg)
                                TriggerEvent('Sentry:RefreshInventory', source)
                                InventoryCoolDown[source] = nil;
                                Sentry.setSData({carformat, json.encode(cdata)})
                            else 
                                InventoryCoolDown[source] = nil;
                                Sentryclient.notify(source, {'~r~You do not have enough inventory space.'})
                            end
                        else 
                            InventoryCoolDown[source] = nil;
                            Sentryclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end
                    end})
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

RegisterNetEvent('Sentry:InComa')
AddEventHandler('Sentry:InComa', function()
    local source = source
    Sentryclient.isInComa(source, {}, function(in_coma) 
        if in_coma then
            Wait(1500)
            local user_id = Sentry.getUserId({source})
            local model = GetHashKey('prop_cs_heist_bag_01')
            local name1 = GetPlayerName(source)
            local lootbag = CreateObjectNoOffset(model, GetEntityCoords(GetPlayerPed(source)) + 0.4, true, true, false)
            local lootbagnetid = NetworkGetNetworkIdFromEntity(lootbag)
            LootBagEntities[lootbagnetid] = {lootbag, lootbag, false, source}
            LootBagEntities[lootbagnetid].Items = {}
            LootBagEntities[lootbagnetid].name = name1 
            local ndata = Sentry.getUserDataTable({user_id})
            local stored_inventory = nil;
            if ndata ~= nil then
                if ndata.inventory ~= nil then
                    stored_inventory = ndata.inventory
                    Sentry.clearInventory({user_id})
                    for k, v in pairs(stored_inventory) do
                        LootBagEntities[lootbagnetid].Items[k] = {}
                        LootBagEntities[lootbagnetid].Items[k].amount = v.amount
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('Sentry:LootBag')
AddEventHandler('Sentry:LootBag', function(netid)
    local source = source
    Sentryclient.isInComa(source, {}, function(in_coma) 
        if not in_coma then
            if LootBagEntities[netid] and #(GetEntityCoords(LootBagEntities[netid][1]) - GetEntityCoords(GetPlayerPed(source))) < 2.0 then
                LootBagEntities[netid][3] = true;
                local user_id = Sentry.getUserId({source})
                if user_id ~= nil then
                    LootBagEntities[netid][5] = source
                    OpenInv(source, netid, LootBagEntities[netid].Items)
                    Sentryclient.notify(source,{"~g~You have opened " .. LootBagEntities[netid].name .. "'s lootbag"})
                end
 
            end
        else 
            Sentryclient.notify(source, {'~r~You cannot open this while dead silly.'})
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
                if #(objectcoords - coords) > 2.0 then
                    CloseInv(v[5])
                    Wait(3000)
                    v[3] = false; 
                    v[5] = nil;
                end
            end
        end
    end
end)

RegisterNetEvent('Sentry:CloseLootbag')
AddEventHandler('Sentry:CloseLootbag', function()
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
    TriggerClientEvent('Sentry:InventoryOpen', source, false, false)
end

function OpenInv(source, netid, LootBagItems)
    local UserId = Sentry.getUserId({source})
    local data = Sentry.getUserDataTable({UserId})
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = Sentry.getItemName({i}), Weight = Sentry.getItemWeight({i})}
        end
        TriggerClientEvent('Sentry:FetchPersonalInventory', source, FormattedInventoryData, Sentry.computeItemsWeight({data.inventory}), Sentry.getInventoryMaxWeight({UserId}))
        InventorySpamTrack[source] = false;
    else 
        print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
    TriggerClientEvent('Sentry:InventoryOpen', source, true, true)
    local FormattedInventoryData = {}
    for i, v in pairs(LootBagItems) do
        FormattedInventoryData[i] = {amount = v.amount, ItemName = Sentry.getItemName({i}), Weight = Sentry.getItemWeight({i})}
    end
    local maxVehKg = 200
    TriggerClientEvent('Sentry:SendSecondaryInventoryData', source, FormattedInventoryData, Sentry.computeItemsWeight({LootBagItems}), maxVehKg)
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