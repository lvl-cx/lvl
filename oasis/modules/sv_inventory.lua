MySQL = module("modules/MySQL")

local Inventory = module("oasis-vehicles", "inventory")
local Housing = module("oasis", "cfg/cfg_housing")
local InventorySpamTrack = {}
local LootBagEntities = {}
local InventoryCoolDown = {}
local a = module("oasis-weapons", "cfg/weapons")

AddEventHandler("OASIS:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if not InventorySpamTrack[source] then
            InventorySpamTrack[source] = true;
            local UserId = OASIS.getUserId(source) 
            local data = OASIS.getUserDataTable(UserId)
            if data and data.inventory then
                local FormattedInventoryData = {}
                for i,v in pairs(data.inventory) do
                    FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                end
                TriggerClientEvent('OASIS:FetchPersonalInventory', source, FormattedInventoryData, OASIS.computeItemsWeight(data.inventory), OASIS.getInventoryMaxWeight(UserId))
                InventorySpamTrack[source] = false;
            else 
                --print('An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
            end
        end
    end
end)

RegisterNetEvent('OASIS:FetchPersonalInventory')
AddEventHandler('OASIS:FetchPersonalInventory', function()
    local source = source
    if not InventorySpamTrack[source] then
        InventorySpamTrack[source] = true;
        local UserId = OASIS.getUserId(source) 
        local data = OASIS.getUserDataTable(UserId)
        if data and data.inventory then
            local FormattedInventoryData = {}
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
            end
            TriggerClientEvent('OASIS:FetchPersonalInventory', source, FormattedInventoryData, OASIS.computeItemsWeight(data.inventory), OASIS.getInventoryMaxWeight(UserId))
            InventorySpamTrack[source] = false;
        else 
            --print('An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
        end
    end
end)


AddEventHandler('OASIS:RefreshInventory', function(source)
    local UserId = OASIS.getUserId(source) 
    local data = OASIS.getUserDataTable(UserId)
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
        end
        TriggerClientEvent('OASIS:FetchPersonalInventory', source, FormattedInventoryData, OASIS.computeItemsWeight(data.inventory), OASIS.getInventoryMaxWeight(UserId))
        InventorySpamTrack[source] = false;
    else 
        --print('An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)

RegisterNetEvent('OASIS:GiveItem')
AddEventHandler('OASIS:GiveItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  OASISclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        OASIS.RunGiveTask(source, itemId)
        TriggerEvent('OASIS:RefreshInventory', source)
    else
        OASISclient.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)

RegisterNetEvent('OASIS:TrashItem')
AddEventHandler('OASIS:TrashItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  OASISclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        OASIS.RunTrashTask(source, itemId)
        TriggerEvent('OASIS:RefreshInventory', source)
    else
        OASISclient.notify(source, {'~r~You need to have this item on you to drop it.'})
    end
end)

RegisterNetEvent('OASIS:FetchTrunkInventory')
AddEventHandler('OASIS:FetchTrunkInventory', function(spawnCode)
    local source = source
    local user_id = OASIS.getUserId(source)
    if InventoryCoolDown[source] then OASISclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    OASIS.getSData(carformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
        end
        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(cdata), maxVehKg)
        TriggerEvent('OASIS:RefreshInventory', source)
    end)
end)

local inHouse = {}
RegisterNetEvent('OASIS:FetchHouseInventory')
AddEventHandler('OASIS:FetchHouseInventory', function(nameHouse)
    local source = source
    local user_id = OASIS.getUserId(source)
    getUserByAddress(nameHouse, 1, function(huser_id)
        if huser_id == user_id then
            inHouse[user_id] = nameHouse
            local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
            OASIS.getSData(homeformat, function(cdata)
                local processedChest = {};
                cdata = json.decode(cdata) or {}
                local FormattedInventoryData = {}
                for i, v in pairs(cdata) do
                    FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                end
                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(cdata), maxVehKg)
            end)
        else
            OASISclient.notify(player,{"~r~You do not own this house!"})
        end
    end)
end)

local currentlySearching = {}

RegisterNetEvent('OASIS:cancelPlayerSearch')
AddEventHandler('OASIS:cancelPlayerSearch', function()
    local source = source
    local user_id = OASIS.getUserId(source) 
    if currentlySearching[user_id] ~= nil then
        TriggerClientEvent('OASIS:cancelPlayerSearch', currentlySearching[user_id])
    end
end)

RegisterNetEvent('OASIS:searchPlayer')
AddEventHandler('OASIS:searchPlayer', function(playersrc)
    local source = source
    local user_id = OASIS.getUserId(source) 
    local data = OASIS.getUserDataTable(user_id)
    local their_id = OASIS.getUserId(playersrc) 
    local their_data = OASIS.getUserDataTable(their_id)
    if data and data.inventory and not currentlySearching[user_id] then
        currentlySearching[user_id] = playersrc
        TriggerClientEvent('OASIS:startSearchingSuspect', source)
        TriggerClientEvent('OASIS:startBeingSearching', playersrc, source)
        OASISclient.notify(playersrc, {'~b~You are being searched.'})
        Wait(10000)
        if currentlySearching[user_id] then
            local FormattedInventoryData = {}
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
            end
            exports['ghmattimysql']:execute("SELECT * FROM oasis_subscriptions WHERE user_id = @user_id", {user_id = user_id}, function(vipClubData)
                if #vipClubData > 0 then
                    if their_data and their_data.inventory then
                        local FormattedSecondaryInventoryData = {}
                        for i,v in pairs(their_data.inventory) do
                            FormattedSecondaryInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                        end
                        if OASIS.getMoney(their_id) > 0 then
                            FormattedSecondaryInventoryData['cash'] = {amount = OASIS.getMoney(their_id), ItemName = 'Cash', Weight = 0.00}
                        end
                        TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedSecondaryInventoryData, OASIS.computeItemsWeight(their_data.inventory), 200)
                    end
                    if vipClubData[1].plathours > 0 then
                        TriggerClientEvent('OASIS:FetchPersonalInventory', source, FormattedInventoryData, OASIS.computeItemsWeight(data.inventory), OASIS.getInventoryMaxWeight(user_id)+20)
                    elseif vipClubData[1].plushours > 0 then
                        TriggerClientEvent('OASIS:FetchPersonalInventory', source, FormattedInventoryData, OASIS.computeItemsWeight(data.inventory), OASIS.getInventoryMaxWeight(user_id)+10)
                    else
                        TriggerClientEvent('OASIS:FetchPersonalInventory', source, FormattedInventoryData, OASIS.computeItemsWeight(data.inventory), OASIS.getInventoryMaxWeight(user_id))
                    end
                    TriggerClientEvent('OASIS:InventoryOpen', source, true)
                    currentlySearching[user_id] = nil
                end
            end)
        end
    end
end)


-- rob player where it gives you their inventory
RegisterNetEvent('OASIS:robPlayer')
AddEventHandler('OASIS:robPlayer', function(playersrc)
    local source = source
    OASISclient.globalSurrenderring(playersrc, {}, function(is_surrendering) 
        if is_surrendering then
            if not InventorySpamTrack[source] then
                InventorySpamTrack[source] = true;
                local user_id = OASIS.getUserId(source) 
                local data = OASIS.getUserDataTable(user_id)
                local their_id = OASIS.getUserId(playersrc) 
                local their_data = OASIS.getUserDataTable(their_id)
                if data and data.inventory then
                    local FormattedInventoryData = {}
                    for i,v in pairs(data.inventory) do
                        FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                    end
                    exports['ghmattimysql']:execute("SELECT * FROM oasis_subscriptions WHERE user_id = @user_id", {user_id = user_id}, function(vipClubData)
                        if #vipClubData > 0 then
                            if their_data and their_data.inventory then
                                local FormattedSecondaryInventoryData = {}
                                for i,v in pairs(their_data.inventory) do
                                    OASIS.giveInventoryItem(user_id, i, v.amount)
                                    OASIS.tryGetInventoryItem(their_id, i, v.amount)
                                end
                            end
                            if OASIS.getMoney(their_id) > 0 then
                                OASIS.giveMoney(user_id, OASIS.getMoney(their_id))
                                OASIS.tryPayment(their_id, OASIS.getMoney(their_id))
                            end
                            if vipClubData[1].plathours > 0 then
                                TriggerClientEvent('OASIS:FetchPersonalInventory', source, FormattedInventoryData, OASIS.computeItemsWeight(data.inventory), OASIS.getInventoryMaxWeight(user_id)+20)
                            elseif vipClubData[1].plushours > 0 then
                                TriggerClientEvent('OASIS:FetchPersonalInventory', source, FormattedInventoryData, OASIS.computeItemsWeight(data.inventory), OASIS.getInventoryMaxWeight(user_id)+10)
                            else
                                TriggerClientEvent('OASIS:FetchPersonalInventory', source, FormattedInventoryData, OASIS.computeItemsWeight(data.inventory), OASIS.getInventoryMaxWeight(user_id))
                            end
                            TriggerClientEvent('OASIS:InventoryOpen', source, true)
                            InventorySpamTrack[source] = false;
                        end
                    end)
                else 
                    --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
                end
            end
        end
    end)
end)

RegisterNetEvent('OASIS:UseItem')
AddEventHandler('OASIS:UseItem', function(itemId, itemLoc)
    local source = source
    local user_id = OASIS.getUserId(source) 
    local data = OASIS.getUserDataTable(user_id)
    if not itemId then OASISclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        tOASIS.getSubscriptions(user_id, function(cb, plushours, plathours)
            if cb then
                local invcap = 30
                if plathours > 0 then
                    invcap = 50
                elseif plushours > 0 then
                    invcap = 40
                end
                if OASIS.getInventoryMaxWeight(user_id) ~= nil then
                    if OASIS.getInventoryMaxWeight(user_id) > invcap then
                        return
                    end
                end
                if itemId == "offwhitebag" then
                    OASIS.tryGetInventoryItem(user_id, itemId, 1, true)
                    OASIS.updateInvCap(user_id, invcap+15)
                    TriggerClientEvent('OASIS:boughtBackpack', source, 5, 92, 0,40000,15, 'Off White Bag (+15kg)')
                elseif itemId == "guccibag" then 
                    OASIS.tryGetInventoryItem(user_id, itemId, 1, true)
                    OASIS.updateInvCap(user_id, invcap+20)
                    TriggerClientEvent('OASIS:boughtBackpack', source, 5, 94, 0,60000,20, 'Gucci Bag (+20kg)')
                elseif itemId == "nikebag" then 
                    OASIS.tryGetInventoryItem(user_id, itemId, 1, true)
                    OASIS.updateInvCap(user_id, invcap+30)
                elseif itemId == "huntingbackpack" then 
                    OASIS.tryGetInventoryItem(user_id, itemId, 1, true)
                    OASIS.updateInvCap(user_id, invcap+35)
                    TriggerClientEvent('OASIS:boughtBackpack', source, 5, 91, 0,100000,35, 'Hunting Backpack (+35kg)')
                elseif itemId == "greenhikingbackpack" then 
                    OASIS.tryGetInventoryItem(user_id, itemId, 1, true)
                    OASIS.updateInvCap(user_id, invcap+40)
                elseif itemId == "rebelbackpack" then 
                    OASIS.tryGetInventoryItem(user_id, itemId, 1, true)
                    OASIS.updateInvCap(user_id, invcap+70)
                    TriggerClientEvent('OASIS:boughtBackpack', source, 5, 90, 0,250000,70, 'Rebel Backpack (+70kg)')
                elseif itemId == "Shaver" then 
                    OASIS.ShaveHead(source)
                elseif itemId == "handcuffkeys" then 
                    OASIS.handcuffKeys(source)
                end
                TriggerEvent('OASIS:RefreshInventory', source)
            end
        end)  
    end
    if itemLoc == "Plr" then
        OASIS.RunInventoryTask(source, itemId)
        TriggerEvent('OASIS:RefreshInventory', source)
    else
        OASISclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)

RegisterNetEvent('OASIS:UseAllItem')
AddEventHandler('OASIS:UseAllItem', function(itemId, itemLoc)
    local source = source
    local user_id = OASIS.getUserId(source) 
    if not itemId then OASISclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        OASIS.LoadAllTask(source, itemId)
        TriggerEvent('OASIS:RefreshInventory', source)
    else
        OASISclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)


RegisterNetEvent('OASIS:MoveItem')
AddEventHandler('OASIS:MoveItem', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local UserId = OASIS.getUserId(source) 
    local data = OASIS.getUserDataTable(UserId)
    if InventoryCoolDown[source] then OASISclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if not itemId then OASISclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
            OASIS.getSData(carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount >= 1 then
                    local weightCalculation = OASIS.getInventoryWeight(UserId)+OASIS.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= OASIS.getInventoryMaxWeight(UserId) then
                        if cdata[itemId].amount > 1 then
                            cdata[itemId].amount = cdata[itemId].amount - 1; 
                            OASIS.giveInventoryItem(UserId, itemId, 1, true)
                        else 
                            cdata[itemId] = nil;
                            OASIS.giveInventoryItem(UserId, itemId, 1, true)
                        end 
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('OASIS:RefreshInventory', source)
                        InventoryCoolDown[source] = false;
                        OASIS.setSData(carformat, json.encode(cdata))
                    else 
                        InventoryCoolDown[source] = false;
                        OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    InventoryCoolDown[source] = false;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end)
        elseif inventoryType == "LootBag" then  
            if itemId ~= nil then  
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = OASIS.getInventoryWeight(UserId)+OASIS.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= OASIS.getInventoryMaxWeight(UserId) then
                        if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > 1 then
                            LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - 1 
                            OASIS.giveInventoryItem(UserId, itemId, 1, true)
                        else 
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            OASIS.giveInventoryItem(UserId, itemId, 1, true)
                        end
                        local FormattedInventoryData = {}
                        for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                        end
                        local maxVehKg = 200
                        TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                        TriggerEvent('OASIS:RefreshInventory', source)
                        InventoryCoolDown[source] = false
                        if not next(LootBagEntities[inventoryInfo].Items) then
                            CloseInv(source)
                        end
                    else 
                        OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            end
        elseif inventoryType == "Housing" then
            InventoryCoolDown[source] = true
            local homeformat = "chest:u" .. UserId .. "home" ..inHouse[user_id]
            OASIS.getSData(homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount >= 1 then
                    local weightCalculation = OASIS.getInventoryWeight(UserId)+OASIS.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= OASIS.getInventoryMaxWeight(UserId) then
                        if cdata[itemId].amount > 1 then
                            cdata[itemId].amount = cdata[itemId].amount - 1; 
                            OASIS.giveInventoryItem(UserId, itemId, 1, true)
                        else 
                            cdata[itemId] = nil;
                            OASIS.giveInventoryItem(UserId, itemId, 1, true)
                        end 
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                        end
                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                        TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('OASIS:RefreshInventory', source)
                        InventoryCoolDown[source] = false;
                        OASIS.setSData("chest:u" .. UserId .. "home" ..inHouse[user_id], json.encode(cdata))
                    else 
                        OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the home.')
                end
            end)
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitem)
                        local homeFormat = "chest:u" .. UserId .. "home" ..inHouse[user_id]
                        OASIS.getSData(homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = OASIS.computeItemsWeight(cdata)+OASIS.getItemWeight(itemId)
                                if weightCalculation == nil then return end
                                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                if weightCalculation <= maxVehKg then
                                    if OASIS.tryGetInventoryItem(UserId, itemId, 1, true) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                                    end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('OASIS:RefreshInventory', source)
                                    OASIS.setSData("chest:u" .. UserId .. "home" ..inHouse[user_id], json.encode(cdata))
                                else 
                                    OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the home.')
                            end
                        end) --end of housing intergration (moveitem)
                    else
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                        OASIS.getSData(carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = OASIS.computeItemsWeight(cdata)+OASIS.getItemWeight(itemId)
                                if weightCalculation == nil then return end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if OASIS.tryGetInventoryItem(UserId, itemId, 1, true) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('OASIS:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    OASIS.setSData(carformat, json.encode(cdata))
                                else 
                                    InventoryCoolDown[source] = nil;
                                    OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                            end
                        end)
                    end
                else
                    InventoryCoolDown[source] = nil;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        InventoryCoolDown[source] = nil;
        --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)



RegisterNetEvent('OASIS:MoveItemX')
AddEventHandler('OASIS:MoveItemX', function(inventoryType, itemId, inventoryInfo, Lootbag, Quantity)
    local source = source
    local UserId = OASIS.getUserId(source) 
    local data = OASIS.getUserDataTable(UserId)
    if InventoryCoolDown[source] then OASISclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if not itemId then  OASISclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            if Quantity >= 1 then
                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                OASIS.getSData(carformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                        local weightCalculation = OASIS.getInventoryWeight(UserId)+(OASIS.getItemWeight(itemId) * Quantity)
                        if weightCalculation == nil then return end
                        if weightCalculation <= OASIS.getInventoryMaxWeight(UserId) then
                            if cdata[itemId].amount > Quantity then
                                cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                OASIS.giveInventoryItem(UserId, itemId, Quantity, true)
                            else 
                                cdata[itemId] = nil;
                                OASIS.giveInventoryItem(UserId, itemId, Quantity, true)
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                            end
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(cdata), maxVehKg)
                            TriggerEvent('OASIS:RefreshInventory', source)
                            InventoryCoolDown[source] = nil;
                            OASIS.setSData(carformat, json.encode(cdata))
                        else 
                            InventoryCoolDown[source] = nil;
                            OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        InventoryCoolDown[source] = nil;
                        OASISclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end
                end)
            else
                InventoryCoolDown[source] = nil;
                OASISclient.notify(source, {'~r~Invalid Amount!'})
            end
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                Quantity = parseInt(Quantity)
                if Quantity then
                    local weightCalculation = OASIS.getInventoryWeight(UserId)+(OASIS.getItemWeight(itemId) * Quantity)
                    if weightCalculation == nil then return end
                    if weightCalculation <= OASIS.getInventoryMaxWeight(UserId) then
                        if Quantity <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                            if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > Quantity then
                                LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - Quantity
                                OASIS.giveInventoryItem(UserId, itemId, Quantity, true)
                            else 
                                LootBagEntities[inventoryInfo].Items[itemId] = nil;
                                OASIS.giveInventoryItem(UserId, itemId, Quantity, true)
                            end
                            local FormattedInventoryData = {}
                            for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                            end
                            local maxVehKg = 200
                            TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                            TriggerEvent('OASIS:RefreshInventory', source)
                            if not next(LootBagEntities[inventoryInfo].Items) then
                                CloseInv(source)
                            end
                        else 
                            OASISclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end 
                    else 
                        OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    OASISclient.notify(source, {'~r~Invalid input!'})
                end
            end
        elseif inventoryType == "Housing" then
            Quantity = parseInt(Quantity)
            if Quantity then
                local homeformat = "chest:u" .. UserId .. "home" ..inHouse[user_id]
                OASIS.getSData(homeformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                        local weightCalculation = OASIS.getInventoryWeight(UserId)+(OASIS.getItemWeight(itemId) * Quantity)
                        if weightCalculation == nil then return end
                        if weightCalculation <= OASIS.getInventoryMaxWeight(UserId) then
                            if cdata[itemId].amount > Quantity then
                                cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                OASIS.giveInventoryItem(UserId, itemId, Quantity, true)
                            else 
                                cdata[itemId] = nil;
                                OASIS.giveInventoryItem(UserId, itemId, Quantity, true)
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                            end
                            local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                            TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(cdata), maxVehKg)
                            TriggerEvent('OASIS:RefreshInventory', source)
                            OASIS.setSData("chest:u" .. UserId .. "home" ..inHouse[user_id], json.encode(cdata))
                        else 
                            OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        OASISclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end
                end)
            else 
                OASISclient.notify(source, {'~r~Invalid input!'})
            end
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitemx)
                        Quantity = parseInt(Quantity)
                        if Quantity then
                            local homeFormat = "chest:u" .. UserId .. "home" ..inHouse[user_id]
                            OASIS.getSData(homeFormat, function(cdata)
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                    local weightCalculation = OASIS.computeItemsWeight(cdata)+(OASIS.getItemWeight(itemId) * Quantity)
                                    if weightCalculation == nil then return end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    if weightCalculation <= maxVehKg then
                                        if OASIS.tryGetInventoryItem(UserId, itemId, Quantity, true) then
                                            if cdata[itemId] then
                                                cdata[itemId].amount = cdata[itemId].amount + Quantity
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = Quantity
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                                        end
                                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                        TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(cdata), maxVehKg)
                                        TriggerEvent('OASIS:RefreshInventory', source)
                                        OASIS.setSData("chest:u" .. UserId .. "home" ..inHouse[user_id], json.encode(cdata))
                                    else 
                                        OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                else 
                                    OASISclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end
                            end)
                        else 
                            OASISclient.notify(source, {'~r~Invalid input!'})
                        end
                    else
                        InventoryCoolDown[source] = true;
                        Quantity = parseInt(Quantity)
                        if Quantity then
                            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                            OASIS.getSData(carformat, function(cdata)
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                    local weightCalculation = OASIS.computeItemsWeight(cdata)+(OASIS.getItemWeight(itemId) * Quantity)
                                    if weightCalculation == nil then return end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    if weightCalculation <= maxVehKg then
                                        if OASIS.tryGetInventoryItem(UserId, itemId, Quantity, true) then
                                            if cdata[itemId] then
                                                cdata[itemId].amount = cdata[itemId].amount + Quantity
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = Quantity
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                                        end
                                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                        TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(cdata), maxVehKg)
                                        TriggerEvent('OASIS:RefreshInventory', source)
                                        InventoryCoolDown[source] = nil;
                                        OASIS.setSData(carformat, json.encode(cdata))
                                    else 
                                        InventoryCoolDown[source] = nil;
                                        OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                else 
                                    InventoryCoolDown[source] = nil;
                                    OASISclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end
                            end)
                        else 
                            OASISclient.notify(source, {'~r~Invalid input!'})
                        end
                    end
                else
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


RegisterNetEvent('OASIS:MoveItemAll')
AddEventHandler('OASIS:MoveItemAll', function(inventoryType, itemId, inventoryInfo, vehid)
    local source = source
    local UserId = OASIS.getUserId(source) 
    local data = OASIS.getUserDataTable(UserId)
    if not itemId then OASISclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if InventoryCoolDown[source] then OASISclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local idz = NetworkGetEntityFromNetworkId(vehid)
            local user_id = OASIS.getUserId(NetworkGetEntityOwner(idz))
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
            OASIS.getSData(carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = OASIS.getInventoryWeight(user_id)+(OASIS.getItemWeight(itemId) * cdata[itemId].amount)
                    if weightCalculation == nil then return end
                    local amount = cdata[itemId].amount
                    if weightCalculation > OASIS.getInventoryMaxWeight(user_id) and OASIS.getInventoryWeight(user_id) ~= OASIS.getInventoryMaxWeight(user_id) then
                        amount = math.floor((OASIS.getInventoryMaxWeight(user_id)-OASIS.getInventoryWeight(user_id)) / OASIS.getItemWeight(itemId))
                    end
                    if math.floor(amount) > 0 or (weightCalculation <= OASIS.getInventoryMaxWeight(user_id)) then
                        OASIS.giveInventoryItem(user_id, itemId, amount, true)
                        local FormattedInventoryData = {}
                        if (cdata[itemId].amount - amount) > 0 then
                            cdata[itemId].amount = cdata[itemId].amount - amount
                        else
                            cdata[itemId] = nil
                        end
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('OASIS:RefreshInventory', source)
                        InventoryCoolDown[source] = nil;
                        OASIS.setSData(carformat, json.encode(cdata))
                    else 
                        InventoryCoolDown[source] = nil;
                        OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    InventoryCoolDown[source] = nil;
                    OASISclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end)
        elseif inventoryType == "LootBag" then
            if itemId ~= nil then    
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = OASIS.getInventoryWeight(UserId)+(OASIS.getItemWeight(itemId) *  LootBagEntities[inventoryInfo].Items[itemId].amount)
                    if weightCalculation == nil then return end
                    if weightCalculation <= OASIS.getInventoryMaxWeight(UserId) then
                        if  LootBagEntities[inventoryInfo].Items[itemId].amount <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                            OASIS.giveInventoryItem(UserId, itemId, LootBagEntities[inventoryInfo].Items[itemId].amount, true)
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            local FormattedInventoryData = {}
                            for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                            end
                            local maxVehKg = 200
                            TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                            TriggerEvent('OASIS:RefreshInventory', source)
                            if not next(LootBagEntities[inventoryInfo].Items) then
                                CloseInv(source)
                            end
                        else 
                            OASISclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end 
                    else 
                        OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            end
        elseif inventoryType == "Housing" then
            local homeformat = "chest:u" .. UserId .. "home" ..inHouse[user_id]
            OASIS.getSData(homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = OASIS.getInventoryWeight(UserId)+(OASIS.getItemWeight(itemId) * cdata[itemId].amount)
                    if weightCalculation == nil then return end
                    if weightCalculation <= OASIS.getInventoryMaxWeight(UserId) then
                        OASIS.giveInventoryItem(UserId, itemId, cdata[itemId].amount, true)
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                        end
                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                        TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('OASIS:RefreshInventory', source)
                        OASIS.setSData("chest:u" .. UserId .. "home" ..inHouse[user_id], json.encode(cdata))
                    else 
                        OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    OASISclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end)
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then
                        local homeFormat = "chest:u" .. UserId .. "home" ..inHouse[user_id]
                        OASIS.getSData(homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local itemAmount = data.inventory[itemId].amount
                                local weightCalculation = OASIS.computeItemsWeight(cdata)+(OASIS.getItemWeight(itemId) * itemAmount)
                                if weightCalculation == nil then return end
                                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                if weightCalculation <= maxVehKg then
                                    if OASIS.tryGetInventoryItem(UserId, itemId, itemAmount, true) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + itemAmount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = itemAmount
                                        end 
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                                    end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('OASIS:RefreshInventory', source)
                                    OASIS.setSData("chest:u" .. UserId .. "home" ..inHouse[user_id], json.encode(cdata))
                                else 
                                    OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                OASISclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end) --end of housing intergration (moveitemall)
                    else 
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                        OASIS.getSData(carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local itemAmount = data.inventory[itemId].amount
                                local weightCalculation = OASIS.computeItemsWeight(cdata)+(OASIS.getItemWeight(itemId) * itemAmount)
                                if weightCalculation == nil then return end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if OASIS.tryGetInventoryItem(UserId, itemId, itemAmount, true) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + itemAmount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = itemAmount
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('OASIS:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    OASIS.setSData(carformat, json.encode(cdata))
                                else 
                                    InventoryCoolDown[source] = nil;
                                    OASISclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                OASISclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end)
                    end
                else
                    InventoryCoolDown[source] = nil;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        InventoryCoolDown[source] = nil;
        --print('An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


-- LOOTBAGS CODE BELOW HERE 

RegisterNetEvent('OASIS:InComa')
AddEventHandler('OASIS:InComa', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    OASISclient.isInComa(source, {}, function(in_coma) 
        if in_coma then
            Wait(1500)
            local weight = OASIS.getInventoryWeight(user_id)
            if weight == 0 then return end
            local model = GetHashKey('xs_prop_arena_bag_01')
            local name1 = GetPlayerName(source)
            local lootbag = CreateObjectNoOffset(model, GetEntityCoords(GetPlayerPed(source)) + 0.2, true, true, false)
            local lootbagnetid = NetworkGetNetworkIdFromEntity(lootbag)
            SetEntityRoutingBucket(lootbag, GetPlayerRoutingBucket(source))
            local ndata = OASIS.getUserDataTable(user_id)
            local stored_inventory = nil;
            TriggerEvent('OASIS:StoreWeaponsRequest', source)
            LootBagEntities[lootbagnetid] = {lootbag, lootbag, false, source}
            LootBagEntities[lootbagnetid].Items = {}
            LootBagEntities[lootbagnetid].name = name1 
            if ndata ~= nil then
                if ndata.inventory ~= nil then
                    stored_inventory = ndata.inventory
                    OASIS.clearInventory(user_id)
                    for k, v in pairs(stored_inventory) do
                        LootBagEntities[lootbagnetid].Items[k] = {}
                        LootBagEntities[lootbagnetid].Items[k].amount = v.amount
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('OASIS:LootBag')
AddEventHandler('OASIS:LootBag', function(netid)
    local source = source
    OASISclient.isInComa(source, {}, function(in_coma) 
        if not in_coma then
            if LootBagEntities[netid] then
                LootBagEntities[netid][3] = true;
                local user_id = OASIS.getUserId(source)
                if user_id ~= nil then
                    TriggerClientEvent("oasis:PlaySound", source, "zipper")
                    LootBagEntities[netid][5] = source
                    if OASIS.hasPermission(user_id, "police.armoury") then
                        local bagData = LootBagEntities[netid].Items
                        if bagData == nil then return end
                        for a,b in pairs(bagData) do
                            if string.find(a, 'wbody|') then
                                c = a:gsub('wbody|', '')
                                bagData[c] = b
                                bagData[a] = nil
                            end
                        end
                        for k,v in pairs(a.weapons) do
                            if bagData[k] ~= nil then
                                if not v.policeWeapon then
                                    OASISclient.notify(source, {'~r~Seized '..v.name..' x'..bagData[k].amount..'.'})
                                    bagData[k] = nil
                                end
                            end
                        end
                        for c,d in pairs(bagData) do
                            if seizeBullets[c] then
                                OASISclient.notify(source, {'~r~Seized '..c..' x'..d.amount..'.'})
                                bagData[c] = nil
                            end
                        end
                        LootBagEntities[netid].Items = bagData
                        OASISclient.notify(source,{"~r~You have seized " .. LootBagEntities[netid].name .. "'s items"})
                        if #LootBagEntities[netid].Items > 0 then
                            OpenInv(source, netid, LootBagEntities[netid].Items)
                        end
                    else
                        OpenInv(source, netid, LootBagEntities[netid].Items)
                    end  
                end
            else
                OASISclient.notify(source, {'~r~This loot bag is unavailable.'})
            end
        else 
            OASISclient.notify(source, {'~r~You cannot open this while dead silly.'})
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

RegisterNetEvent('OASIS:CloseLootbag')
AddEventHandler('OASIS:CloseLootbag', function()
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
    TriggerClientEvent('OASIS:InventoryOpen', source, false, false)
end

function OpenInv(source, netid, LootBagItems)
    local UserId = OASIS.getUserId(source)
    local data = OASIS.getUserDataTable(UserId)
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
        end
        TriggerClientEvent('OASIS:FetchPersonalInventory', source, FormattedInventoryData, OASIS.computeItemsWeight(data.inventory), OASIS.getInventoryMaxWeight(UserId))
        InventorySpamTrack[source] = false;
    else 
        --print('An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
    TriggerClientEvent('OASIS:InventoryOpen', source, true, true, netid)
    local FormattedInventoryData = {}
    for i, v in pairs(LootBagItems) do
        FormattedInventoryData[i] = {amount = v.amount, ItemName = OASIS.getItemName(i), Weight = OASIS.getItemWeight(i)}
    end
    local maxVehKg = 200
    TriggerClientEvent('OASIS:SendSecondaryInventoryData', source, FormattedInventoryData, OASIS.computeItemsWeight(LootBagItems), maxVehKg)
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
                    LootBagEntities[i] = nil;
                end
            end
        end
    end
end)

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

-- local usersLockpicking = {}

-- RegisterNetEvent('OASIS:attemptLockpick')
-- AddEventHandler('OASIS:attemptLockpick', function(veh, netveh)
--     local source = source
--     local user_id = OASIS.getUserId(source)
--     if OASIS.tryGetInventoryItem(user_id, 'Lockpick', 1, true) then
--         local chance = math.random(1,8)
--         if chance == 1 then
--             TriggerClientEvent('OASIS:lockpickClient', source, veh, true)
--         else
--             TriggerClientEvent('OASIS:lockpickClient', source, veh, false)
--         end
--     end
-- end)

-- RegisterNetEvent('OASIS:lockpickVehicle')
-- AddEventHandler('OASIS:lockpickVehicle', function(spawncode, ownerid)
--     local source = source
--     local user_id = OASIS.getUserId(source)
    
-- end)

-- RegisterNetEvent('OASIS:setVehicleLock')
-- AddEventHandler('OASIS:setVehicleLock', function(netid)
--     local source = source
--     local user_id = OASIS.getUserId(source)
--     if usersLockpicking[user_id] then
--         SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(netid), false)
--     end
-- end)