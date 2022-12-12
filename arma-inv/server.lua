local Tunnel = module("arma", "lib/Tunnel")
local Proxy = module("arma", "lib/Proxy")
local ARMA = Proxy.getInterface("ARMA")
local ARMAclient = Tunnel.getInterface("ARMA","ARMA")

MySQL = module("arma_mysql", "MySQL")

local Inventory = module("arma", "cfg/inventory")
local Housing = module("arma", "cfg/cfg_housing")
local InventorySpamTrack = {}
local LootBagEntities = {}
local InventoryCoolDown = {}
local a = module("cfg/weapons")
local houseName = ""

RegisterNetEvent('ARMA:FetchPersonalInventory')
AddEventHandler('ARMA:FetchPersonalInventory', function()
    local source = source
    if not InventorySpamTrack[source] then
        InventorySpamTrack[source] = true;
        local UserId = ARMA.getUserId({source}) 
        local data = ARMA.getUserDataTable({UserId})
        if data and data.inventory then
            local FormattedInventoryData = {}
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
            end
            exports['ghmattimysql']:execute("SELECT * FROM arma_subscriptions WHERE user_id = @user_id", {user_id = UserId}, function(vipClubData)
                if #vipClubData > 0 then
                    if vipClubData[1].plathours > 0 then
                        TriggerClientEvent('ARMA:FetchPersonalInventory', source, FormattedInventoryData, ARMA.computeItemsWeight({data.inventory}), ARMA.getInventoryMaxWeight({UserId})+20)
                    elseif vipClubData[1].plushours > 0 then
                        TriggerClientEvent('ARMA:FetchPersonalInventory', source, FormattedInventoryData, ARMA.computeItemsWeight({data.inventory}), ARMA.getInventoryMaxWeight({UserId})+10)
                    else
                        TriggerClientEvent('ARMA:FetchPersonalInventory', source, FormattedInventoryData, ARMA.computeItemsWeight({data.inventory}), ARMA.getInventoryMaxWeight({UserId}))
                    end
                    InventorySpamTrack[source] = false;
                end
            end)
        else 
            print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
        end
    end
end)


AddEventHandler('ARMA:RefreshInventory', function(source)
    local UserId = ARMA.getUserId({source}) 
    local data = ARMA.getUserDataTable({UserId})
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
        end
        exports['ghmattimysql']:execute("SELECT * FROM arma_subscriptions WHERE user_id = @user_id", {user_id = UserId}, function(vipClubData)
            if #vipClubData > 0 then
                if vipClubData[1].plathours > 0 then
                    TriggerClientEvent('ARMA:FetchPersonalInventory', source, FormattedInventoryData, ARMA.computeItemsWeight({data.inventory}), ARMA.getInventoryMaxWeight({UserId})+20)
                elseif vipClubData[1].plushours > 0 then
                    TriggerClientEvent('ARMA:FetchPersonalInventory', source, FormattedInventoryData, ARMA.computeItemsWeight({data.inventory}), ARMA.getInventoryMaxWeight({UserId})+10)
                else
                    TriggerClientEvent('ARMA:FetchPersonalInventory', source, FormattedInventoryData, ARMA.computeItemsWeight({data.inventory}), ARMA.getInventoryMaxWeight({UserId}))
                end
                InventorySpamTrack[source] = false;
            end
        end)
    else 
        print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)

RegisterNetEvent('ARMA:GiveItem')
AddEventHandler('ARMA:GiveItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  ARMAclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        ARMA.RunGiveTask({source, itemId})
        TriggerEvent('ARMA:RefreshInventory', source)
    else
        ARMAclient.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)

RegisterNetEvent('ARMA:TrashItem')
AddEventHandler('ARMA:TrashItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  ARMAclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        ARMA.RunTrashTask({source, itemId})
        TriggerEvent('ARMA:RefreshInventory', source)
    else
        ARMAclient.notify(source, {'~r~You need to have this item on you to drop it.'})
    end
end)

RegisterNetEvent('ARMA:FetchTrunkInventory')
AddEventHandler('ARMA:FetchTrunkInventory', function(spawnCode)
    local source = source
    local user_id = ARMA.getUserId({source})
    if InventoryCoolDown[source] then ARMAclient.notify(source, {'~r~The server is still processing your request.'}) return end
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    ARMA.getSData({carformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
        end
        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({cdata}), maxVehKg)
        TriggerEvent('ARMA:RefreshInventory', source)
    end})
end)

RegisterNetEvent('ARMA:FetchHouseInventory')
AddEventHandler('ARMA:FetchHouseInventory', function(nameHouse)
    local source = source
    houseName = nameHouse
    local user_id = ARMA.getUserId({source})
    local homeformat = "chest:u" .. user_id .. "home" ..houseName
    ARMA.getSData({homeformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
        end
        local maxVehKg = Housing.chestsize[houseName] or 500
        TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({cdata}), maxVehKg)
    end})
end)

RegisterNetEvent('ARMA:UseItem')
AddEventHandler('ARMA:UseItem', function(itemId, itemLoc)
    local source = source
    local user_id = ARMA.getUserId({source}) 
    if not itemId then ARMAclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        if ARMA.getInventoryMaxWeight({user_id}) == 30 then
            if itemId == "offwhitebag" then
                ARMA.tryGetInventoryItem({user_id, itemId, 1, true})
                ARMA.updateInvCap({user_id, 45})
                TriggerClientEvent('ARMA:boughtBackpack', source, 5, 92, 0,40000,15, 'Off White Bag (+15kg)')
            elseif itemId == "guccibag" then 
                ARMA.tryGetInventoryItem({user_id, itemId, 1, true})
                ARMA.updateInvCap({user_id, 50})
                TriggerClientEvent('ARMA:boughtBackpack', source, 5, 94, 0,60000,20, 'Gucci Bag (+20kg)')
            elseif itemId == "nikebag" then 
                ARMA.tryGetInventoryItem({user_id, itemId, 1, true})
                ARMA.updateInvCap({user_id, 60})
            elseif itemId == "huntingbackpack" then 
                ARMA.tryGetInventoryItem({user_id, itemId, 1, true})
                ARMA.updateInvCap({user_id, 65})
                TriggerClientEvent('ARMA:boughtBackpack', source, 5, 91, 0,100000,35, 'Hunting Backpack (+35kg)')
            elseif itemId == "greenhikingbackpack" then 
                ARMA.tryGetInventoryItem({user_id, itemId, 1, true})
                ARMA.updateInvCap({user_id, 70})
            elseif itemId == "rebelbackpack" then 
                ARMA.tryGetInventoryItem({user_id, itemId, 1, true})
                ARMA.updateInvCap({user_id, 100})
                TriggerClientEvent('ARMA:boughtBackpack', source, 5, 90, 0,250000,70, 'Rebel Backpack (+70kg)')
            elseif itemId == "shaver" then 
                ARMA.ShaveHead({source})
            end
            TriggerEvent('ARMA:RefreshInventory', source)
        else
            if itemId == "offwhitebag" or itemId == "guccibag" or itemId == "nikebag" or itemId == "huntingbackpack" or itemId == "greenhikingbackpack" or itemId == "rebelbackpack" then
                ARMAclient.notify(source, {'~r~You already have a backpack equipped.'})
            end
        end      
    end
    if itemLoc == "Plr" then
        ARMA.RunInventoryTask({source, itemId})
        TriggerEvent('ARMA:RefreshInventory', source)
    else
        ARMAclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)


RegisterNetEvent('ARMA:MoveItem')
AddEventHandler('ARMA:MoveItem', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local UserId = ARMA.getUserId({source}) 
    local data = ARMA.getUserDataTable({UserId})
    if InventoryCoolDown[source] then ARMAclient.notify(source, {'~r~The server is still processing your request.'}) return end
    if not itemId then  ARMAclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local Quantity = parseInt(1)
            if Quantity then
                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                ARMA.getSData({carformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and cdata[itemId].amount >= 1 then
                        local weightCalculation = ARMA.getInventoryWeight({UserId})+ARMA.getItemWeight({itemId})
                        if weightCalculation <= ARMA.getInventoryMaxWeight({UserId}) then
                            if cdata[itemId].amount > 1 then
                                cdata[itemId].amount = cdata[itemId].amount - 1; 
                                ARMA.giveInventoryItem({UserId, itemId, 1, true})
                            else 
                                cdata[itemId] = nil;
                                ARMA.giveInventoryItem({UserId, itemId, 1, true})
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                            end
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({cdata}), maxVehKg)
                            TriggerEvent('ARMA:RefreshInventory', source)
                            InventoryCoolDown[source] = false;
                            ARMA.setSData({carformat, json.encode(cdata)})
                        else 
                            InventoryCoolDown[source] = false;
                            ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        InventoryCoolDown[source] = false;
                        print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                    end
                end})
            end
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                local weightCalculation = ARMA.getInventoryWeight({UserId})+ARMA.getItemWeight({itemId})
                if weightCalculation <= ARMA.getInventoryMaxWeight({UserId}) then
                    if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > 1 then
                        LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - 1 
                        ARMA.giveInventoryItem({UserId, itemId, 1, true})
                    else 
                        LootBagEntities[inventoryInfo].Items[itemId] = nil;
                        ARMA.giveInventoryItem({UserId, itemId, 1, true})
                    end
                    local FormattedInventoryData = {}
                    for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                        FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                    end
                    local maxVehKg = 200
                    TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                    TriggerEvent('ARMA:RefreshInventory', source)
                    if not next(LootBagEntities[inventoryInfo].Items) then
                        CloseInv(source)
                    end
                else 
                    ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
                end
            end
        elseif inventoryType == "Housing" then
            local Quantity = parseInt(1)
            if Quantity then
                local homeformat = "chest:u" .. UserId .. "home" ..houseName
                ARMA.getSData({homeformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and cdata[itemId].amount >= 1 then
                        local weightCalculation = ARMA.getInventoryWeight({UserId})+ARMA.getItemWeight({itemId})
                        if weightCalculation <= ARMA.getInventoryMaxWeight({UserId}) then
                            if cdata[itemId].amount > 1 then
                                cdata[itemId].amount = cdata[itemId].amount - 1; 
                                ARMA.giveInventoryItem({UserId, itemId, 1, true})
                            else 
                                cdata[itemId] = nil;
                                ARMA.giveInventoryItem({UserId, itemId, 1, true})
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                            end
                            local maxVehKg = Housing.chestsize[houseName] or 500
                            TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({cdata}), maxVehKg)
                            TriggerEvent('ARMA:RefreshInventory', source)
                            ARMA.setSData({"chest:u" .. UserId .. "home", json.encode(cdata)})
                        else 
                            ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
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
                        local homeFormat = "chest:u" .. UserId .. "home" ..houseName
                        ARMA.getSData({homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = ARMA.computeItemsWeight({cdata})+ARMA.getItemWeight({itemId})
                                local maxVehKg = Housing.chestsize[houseName] or 500
                                if weightCalculation <= maxVehKg then
                                    if ARMA.tryGetInventoryItem({UserId, itemId, 1, true}) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                                    end
                                    local maxVehKg = Housing.chestsize[houseName] or 500
                                    TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('ARMA:RefreshInventory', source)
                                    ARMA.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
                                else 
                                    ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the home.')
                            end
                        end}) --end of housing intergration (moveitem)
                    else
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                        ARMA.getSData({carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = ARMA.computeItemsWeight({cdata})+ARMA.getItemWeight({itemId})
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if ARMA.tryGetInventoryItem({UserId, itemId, 1, true}) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('ARMA:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    ARMA.setSData({carformat, json.encode(cdata)})
                                else 
                                    InventoryCoolDown[source] = nil;
                                    ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
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



RegisterNetEvent('ARMA:MoveItemX')
AddEventHandler('ARMA:MoveItemX', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local UserId = ARMA.getUserId({source}) 
    local data = ARMA.getUserDataTable({UserId})
    if InventoryCoolDown[source] then ARMAclient.notify(source, {'~r~The server is still processing your request.'}) return end
    if not itemId then  ARMAclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            TriggerClientEvent('ARMA:ToggleNUIFocus', source, false)
            ARMA.prompt({source, 'How many ' .. ARMA.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                Quantity = parseInt(Quantity)
        
                
                    TriggerClientEvent('ARMA:ToggleNUIFocus', source, true)
                    if Quantity >= 1 then
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                        ARMA.getSData({carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                                local weightCalculation = ARMA.getInventoryWeight({UserId})+(ARMA.getItemWeight({itemId}) * Quantity)
                                if weightCalculation <= ARMA.getInventoryMaxWeight({UserId}) then
                                    if cdata[itemId].amount > Quantity then
                                        cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                        ARMA.giveInventoryItem({UserId, itemId, Quantity, true})
                                    else 
                                        cdata[itemId] = nil;
                                        ARMA.giveInventoryItem({UserId, itemId, Quantity, true})
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('ARMA:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    ARMA.setSData({carformat, json.encode(cdata)})
                                else 
                                    InventoryCoolDown[source] = nil;
                                    ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                ARMAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end})
                    else
                        InventoryCoolDown[source] = nil;
                        ARMAclient.notify(source, {'~r~Invalid Amount!'})
                    end
  
             
    
            end})
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                TriggerClientEvent('ARMA:ToggleNUIFocus', source, false)
                ARMA.prompt({source, 'How many ' .. ARMA.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                    Quantity = parseInt(Quantity)
                    TriggerClientEvent('ARMA:ToggleNUIFocus', source, true)
                    if Quantity then
                        local weightCalculation = ARMA.getInventoryWeight({UserId})+(ARMA.getItemWeight({itemId}) * Quantity)
                        if weightCalculation <= ARMA.getInventoryMaxWeight({UserId}) then
                            if Quantity <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                                if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > Quantity then
                                    LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - Quantity
                                    ARMA.giveInventoryItem({UserId, itemId, Quantity, true})
                                else 
                                    LootBagEntities[inventoryInfo].Items[itemId] = nil;
                                    ARMA.giveInventoryItem({UserId, itemId, Quantity, true})
                                end
                                local FormattedInventoryData = {}
                                for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                                end
                                local maxVehKg = 200
                                TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                                TriggerEvent('ARMA:RefreshInventory', source)
                                if not next(LootBagEntities[inventoryInfo].Items) then
                                    CloseInv(source)
                                end
                            else 
                                ARMAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end 
                        else 
                            ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        ARMAclient.notify(source, {'~r~Invalid input!'})
                    end
                end})
            end
        elseif inventoryType == "Housing" then
            TriggerClientEvent('ARMA:ToggleNUIFocus', source, false)
            ARMA.prompt({source, 'How many ' .. ARMA.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                Quantity = parseInt(Quantity)
                TriggerClientEvent('ARMA:ToggleNUIFocus', source, true)
                if Quantity then
                    local homeformat = "chest:u" .. UserId .. "home" ..houseName
                    ARMA.getSData({homeformat, function(cdata)
                        cdata = json.decode(cdata) or {}
                        if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                            local weightCalculation = ARMA.getInventoryWeight({UserId})+(ARMA.getItemWeight({itemId}) * Quantity)
                            if weightCalculation <= ARMA.getInventoryMaxWeight({UserId}) then
                                if cdata[itemId].amount > Quantity then
                                    cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                    ARMA.giveInventoryItem({UserId, itemId, Quantity, true})
                                else 
                                    cdata[itemId] = nil;
                                    ARMA.giveInventoryItem({UserId, itemId, Quantity, true})
                                end 
                                local FormattedInventoryData = {}
                                for i, v in pairs(cdata) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                                end
                                local maxVehKg = Housing.chestsize[houseName] or 500
                                TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({cdata}), maxVehKg)
                                TriggerEvent('ARMA:RefreshInventory', source)
                                ARMA.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
                            else 
                                ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
                            end
                        else 
                            ARMAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end
                    end})
                else 
                    ARMAclient.notify(source, {'~r~Invalid input!'})
                end
            end})
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitemx)
                        TriggerClientEvent('ARMA:ToggleNUIFocus', source, false)
                        ARMA.prompt({source, 'How many ' .. ARMA.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                            Quantity = parseInt(Quantity)
                            TriggerClientEvent('ARMA:ToggleNUIFocus', source, true)
                            if Quantity then
                                local homeFormat = "chest:u" .. UserId .. "home" ..houseName
                                ARMA.getSData({homeFormat, function(cdata)
                                    cdata = json.decode(cdata) or {}
                                    if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                        local weightCalculation = ARMA.computeItemsWeight({cdata})+(ARMA.getItemWeight({itemId}) * Quantity)
                                        local maxVehKg = Housing.chestsize[houseName] or 500
                                        if weightCalculation <= maxVehKg then
                                            if ARMA.tryGetInventoryItem({UserId, itemId, Quantity, true}) then
                                                if cdata[itemId] then
                                                    cdata[itemId].amount = cdata[itemId].amount + Quantity
                                                else 
                                                    cdata[itemId] = {}
                                                    cdata[itemId].amount = Quantity
                                                end
                                            end 
                                            local FormattedInventoryData = {}
                                            for i, v in pairs(cdata) do
                                                FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                                            end
                                            local maxVehKg = Housing.chestsize[houseName] or 500
                                            TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({cdata}), maxVehKg)
                                            TriggerEvent('ARMA:RefreshInventory', source)
                                            ARMA.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
                                        else 
                                            ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
                                        end
                                    else 
                                        ARMAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                    end
                                end})
                            else 
                                ARMAclient.notify(source, {'~r~Invalid input!'})
                            end
                        end}) --end of housing intergration (moveitemx)
                    else
                        InventoryCoolDown[source] = true;
                        TriggerClientEvent('ARMA:ToggleNUIFocus', source, false)
                        ARMA.prompt({source, 'How many ' .. ARMA.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                            Quantity = parseInt(Quantity)
                            TriggerClientEvent('ARMA:ToggleNUIFocus', source, true)
                            if Quantity then
                                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                                ARMA.getSData({carformat, function(cdata)
                                    cdata = json.decode(cdata) or {}
                                    if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                        local weightCalculation = ARMA.computeItemsWeight({cdata})+(ARMA.getItemWeight({itemId}) * Quantity)
                                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                        if weightCalculation <= maxVehKg then
                                            if ARMA.tryGetInventoryItem({UserId, itemId, Quantity, true}) then
                                                if cdata[itemId] then
                                                    cdata[itemId].amount = cdata[itemId].amount + Quantity
                                                else 
                                                    cdata[itemId] = {}
                                                    cdata[itemId].amount = Quantity
                                                end
                                            end 
                                            local FormattedInventoryData = {}
                                            for i, v in pairs(cdata) do
                                                FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                                            end
                                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                            TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({cdata}), maxVehKg)
                                            TriggerEvent('ARMA:RefreshInventory', source)
                                            InventoryCoolDown[source] = nil;
                                            ARMA.setSData({carformat, json.encode(cdata)})
                                        else 
                                            InventoryCoolDown[source] = nil;
                                            ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
                                        end
                                    else 
                                        InventoryCoolDown[source] = nil;
                                        ARMAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                    end
                                end})
                            else 
                                ARMAclient.notify(source, {'~r~Invalid input!'})
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


RegisterNetEvent('ARMA:MoveItemAll')
AddEventHandler('ARMA:MoveItemAll', function(inventoryType, itemId, inventoryInfo, vehid)
    local source = source
    local UserId = ARMA.getUserId({source}) 
    local data = ARMA.getUserDataTable({UserId})
    if not itemId then  ARMAclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if InventoryCoolDown[source] then ARMAclient.notify(source, {'~r~The server is still processing your request.'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
                local idz = NetworkGetEntityFromNetworkId(vehid)
             local user_id = ARMA.getUserId({NetworkGetEntityOwner(idz)})
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
            ARMA.getSData({carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = ARMA.getInventoryWeight({user_id})+(ARMA.getItemWeight({itemId}) * cdata[itemId].amount)
                    if weightCalculation <= ARMA.getInventoryMaxWeight({user_id}) then
                        ARMA.giveInventoryItem({user_id, itemId, cdata[itemId].amount, true})
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({cdata}), maxVehKg)
                        TriggerEvent('ARMA:RefreshInventory', source)
                        InventoryCoolDown[source] = nil;
                        ARMA.setSData({carformat, json.encode(cdata)})
                    else 
                        InventoryCoolDown[source] = nil;
                        ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    InventoryCoolDown[source] = nil;
                    ARMAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end})
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                local weightCalculation = ARMA.getInventoryWeight({UserId})+(ARMA.getItemWeight({itemId}) *  LootBagEntities[inventoryInfo].Items[itemId].amount)
                if weightCalculation <= ARMA.getInventoryMaxWeight({UserId}) then
                    if  LootBagEntities[inventoryInfo].Items[itemId].amount <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                        ARMA.giveInventoryItem({UserId, itemId, LootBagEntities[inventoryInfo].Items[itemId].amount, true})
                        LootBagEntities[inventoryInfo].Items[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                        end
                        local maxVehKg = 200
                        TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                        TriggerEvent('ARMA:RefreshInventory', source)
                        if not next(LootBagEntities[inventoryInfo].Items) then
                            CloseInv(source)
                        end
                    else 
                        ARMAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end 
                else 
                    ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
                end
            end
        elseif inventoryType == "Housing" then
            local homeformat = "chest:u" .. UserId .. "home" ..houseName
            ARMA.getSData({homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = ARMA.getInventoryWeight({UserId})+(ARMA.getItemWeight({itemId}) * cdata[itemId].amount)
                    if weightCalculation <= ARMA.getInventoryMaxWeight({UserId}) then
                        ARMA.giveInventoryItem({UserId, itemId, cdata[itemId].amount, true})
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                        end
                        local maxVehKg = Housing.chestsize[houseName] or 500
                        TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({cdata}), maxVehKg)
                        TriggerEvent('ARMA:RefreshInventory', source)
                        ARMA.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
                    else 
                        ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    ARMAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end})
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitemall)
                        local homeFormat = "chest:u" .. UserId .. "home" ..houseName
                        ARMA.getSData({homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local weightCalculation = ARMA.computeItemsWeight({cdata})+(ARMA.getItemWeight({itemId}) * data.inventory[itemId].amount)
                                local maxVehKg = Housing.chestsize[houseName] or 500
                                if weightCalculation <= maxVehKg then
                                    if ARMA.tryGetInventoryItem({UserId, itemId, data.inventory[itemId].amount, true}) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + data.inventory[itemId].amount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = data.inventory[itemId].amount
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                                    end
                                    local maxVehKg = Housing.chestsize[houseName] or 500
                                    TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('ARMA:RefreshInventory', source)
                                    ARMA.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
                                else 
                                    ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                ARMAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end}) --end of housing intergration (moveitemall)
                    else 
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                        ARMA.getSData({carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local weightCalculation = ARMA.computeItemsWeight({cdata})+(ARMA.getItemWeight({itemId}) * data.inventory[itemId].amount)
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if ARMA.tryGetInventoryItem({UserId, itemId, data.inventory[itemId].amount, true}) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + data.inventory[itemId].amount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = data.inventory[itemId].amount
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('ARMA:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    ARMA.setSData({carformat, json.encode(cdata)})
                                else 
                                    InventoryCoolDown[source] = nil;
                                    ARMAclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                ARMAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
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

RegisterNetEvent('ARMA:InComa')
AddEventHandler('ARMA:InComa', function()
    local source = source
    local user_id = ARMA.getUserId({source})
    ARMAclient.isInComa(source, {}, function(in_coma) 
        if in_coma then
            Wait(1500)
            local weight = ARMA.getInventoryWeight({user_id})
            if weight == 0 then return end
            local model = GetHashKey('xs_prop_arena_bag_01')
            local name1 = GetPlayerName(source)
            local lootbag = CreateObjectNoOffset(model, GetEntityCoords(GetPlayerPed(source)) + 0.2, true, true, false)
            local lootbagnetid = NetworkGetNetworkIdFromEntity(lootbag)
            local ndata = ARMA.getUserDataTable({user_id})
            local stored_inventory = nil;
            TriggerEvent('ARMA:StoreWeaponsRequest', source)
            LootBagEntities[lootbagnetid] = {lootbag, lootbag, false, source}
            LootBagEntities[lootbagnetid].Items = {}
            LootBagEntities[lootbagnetid].name = name1 
            if ndata ~= nil then
                if ndata.inventory ~= nil then
                    stored_inventory = ndata.inventory
                    ARMA.clearInventory({user_id})
                    for k, v in pairs(stored_inventory) do
                        LootBagEntities[lootbagnetid].Items[k] = {}
                        LootBagEntities[lootbagnetid].Items[k].amount = v.amount
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('ARMA:LootBag')
AddEventHandler('ARMA:LootBag', function(netid)
    local source = source
    ARMAclient.isInComa(source, {}, function(in_coma) 
        if not in_coma then
            if LootBagEntities[netid] then
                LootBagEntities[netid][3] = true;
                local user_id = ARMA.getUserId({source})
                if user_id ~= nil then
                    TriggerClientEvent("arma:PlaySound", source, "zipper")
                    LootBagEntities[netid][5] = source
                    if ARMA.hasPermission({user_id, "police.armoury"}) then
                        -- this will eventually stop pd weapons from being seized cba to finish tonight icl
                        --[[ local savePDWeapons = {}
                        for k,v in pairs(a.weapons) do
                            print(LootBagEntities[netid].Items[k])
                            if LootBagEntities[netid].Items[k] == k then
                                if v.policeWeapon then
                                    table.insert(savePDWeapons, k)
                                end
                            end
                        end ]]
                        LootBagEntities[netid].Items = {}
                        --LootBagEntities[netid].Items = savePDWeapons
                        ARMAclient.notify(source,{"~r~You have seized " .. LootBagEntities[netid].name .. "'s items"})
                        OpenInv(source, netid, LootBagEntities[netid].Items)
                    else
                        OpenInv(source, netid, LootBagEntities[netid].Items)
                    end  
                end
            else
                ARMAclient.notify(source, {'~r~This loot bag is unavailable.'})
            end
        else 
            ARMAclient.notify(source, {'~r~You cannot open this while dead silly.'})
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

RegisterNetEvent('ARMA:CloseLootbag')
AddEventHandler('ARMA:CloseLootbag', function()
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
    TriggerClientEvent('ARMA:InventoryOpen', source, false, false)
end

function OpenInv(source, netid, LootBagItems)
    local UserId = ARMA.getUserId({source})
    local data = ARMA.getUserDataTable({UserId})
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
        end
        TriggerClientEvent('ARMA:FetchPersonalInventory', source, FormattedInventoryData, ARMA.computeItemsWeight({data.inventory}), ARMA.getInventoryMaxWeight({UserId}))
        InventorySpamTrack[source] = false;
    else 
        print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
    TriggerClientEvent('ARMA:InventoryOpen', source, true, true, netid)
    local FormattedInventoryData = {}
    for i, v in pairs(LootBagItems) do
        FormattedInventoryData[i] = {amount = v.amount, ItemName = ARMA.getItemName({i}), Weight = ARMA.getItemWeight({i})}
    end
    local maxVehKg = 200
    TriggerClientEvent('ARMA:SendSecondaryInventoryData', source, FormattedInventoryData, ARMA.computeItemsWeight({LootBagItems}), maxVehKg)
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