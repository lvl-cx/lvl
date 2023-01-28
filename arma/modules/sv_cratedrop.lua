local crateLocations = {
    vector3(2558.714, 6155.399, 161.8665), -- Rebel 
    vector3(375.0662, 6852.992, 4.083869), -- Paleto 
    vector3(-880.6389, 4414.064, 20.36799), -- Large arms
    vector3(-3032.489, 3402.802, 8.417397), -- mil base 
    vector3(-119.2925, 3022.1, 32.18053), -- diamond mine river
    vector3(36.50002, 4344.443, 41.47789), -- Large arms bridge
    vector3(499.4316, 5536.806, 777.696), -- mt chilliad
    vector3(-1518.191, 2140.92, 55.53791), -- wine mansion
    vector3(-191.0104, 1477.419, 288.4325), -- Vinewood 1
    vector3(828.4253, 1300.878, 363.6823), -- Vinewood sign
    vector3(2348.622, 2138.061, 104.3607), -- wind turbines
    vector3(1877.604, 352.0831, 162.9319), -- Vinewood lake
    vector3(2836.016, -1447.626, 10.45845), -- island near lsd
    vector3(2543.626, 3615.884, 96.89672), -- Youtool hill
    vector3(2856.744, 4631.319, 48.39237), -- H Bunker
    vector3(4784.917, -5530.945, 19.46264), -- Cayo Perico
    vector3(254.3428, 3583.882, 33.73079), -- Biker city
}
local rigLocations = {
    vector3(-1716.5004882812,8886.94921875,27.144144058228),
}
local activeCrates = {}
local spawnTime = 20*60 -- Time between each airdrop

local availableItems = {
    {"wbody|WEAPON_UMP45", 1},
    {"9mm Bullets", 250},
    {"wbody|WEAPON_MOSIN", 1},
    {"wbody|WEAPON_AK200", 1},
    {"7.62mm Bullets", 250},
}

AddEventHandler("ARMA:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
       if #activeCrates > 0 then
            for k,v in pairs(activeCrates) do
                TriggerClientEvent('ARMA:addCrateDropRedzone', source, v, crateLocations[v])
            end
       end
    end
end)

RegisterServerEvent('ARMA:openCrate', function(crateID)
    local source = source
    local user_id = ARMA.getUserId(source)
    if activeCrates[crateID] == nil then return end
    if #(GetEntityCoords(GetPlayerPed(source)) - crateLocations[crateID]) < 2.0 or #(GetEntityCoords(GetPlayerPed(source)) - rigLocations[crateID]) < 2.0  then
        TriggerClientEvent("ARMA:removeLootcrate", -1, crateID)
        FreezeEntityPosition(GetPlayerPed(source), true)
        ARMAclient.startCircularProgressBar(source, {"", 15000, nil})
        local anims = {
            {'amb@medic@standing@kneel@base', 'base', 1},
            {'anim@gangops@facility@servers@bodysearch@', 'player_search', 1},
        }
        ARMAclient.playAnim(source,{true,anims,false})
        Wait(15000)
        local lootAmount = nil
        if activeCrates[crateID].oilrig then
            lootAmount = 8
        else
            lootAmount = 3
        end
        while lootAmount > 0 do
            local randomItem = math.random(1, #availableItems)
            for k,v in pairs(availableItems) do
                if k == randomItem then
                    ARMA.giveInventoryItem(user_id, v[1], v[2], true)
                end
            end
            lootAmount = lootAmount - 1
        end
        activeCrates[crateID] = nil
        ARMA.giveMoney(user_id,math.random(50000,150000))
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "Crate drop has been looted.", "alert")
        FreezeEntityPosition(GetPlayerPed(source), false)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(30*60*1000)
        local crateID = math.random(1, #crateLocations)
        local crateCoords = crateLocations[crateID]
        TriggerClientEvent('ARMA:crateDrop', -1, crateCoords, crateID, false)
        activeCrates[crateID] = {oilrig = false}
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "A cartel plane carrying supplies has had to bail and is parachuting to the ground! Get to it quick, check your GPS!", "alert")
        Wait(20*60*1000)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The airdrop has disappeared.", "alert")
            activeCrates[crateID] = nil
            TriggerClientEvent("ARMA:removeLootcrate", -1, crateID)
        end
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(3*60*60*1000)
        local crateID = math.random(1, #rigLocations)
        local crateCoords = rigLocations[crateID]
        TriggerClientEvent('ARMA:crateDrop', -1, crateCoords, crateID, true)
        activeCrates[crateID] = {oilrig = true}
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "A cartel plane carrying supplies has had to bail and is parachuting to the ground! Get to it quick, check your GPS!", "alert")
        Wait(20*60*1000)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The airdrop has disappeared.", "alert")
            activeCrates[crateID] = nil
            TriggerClientEvent("ARMA:removeLootcrate", -1, crateID)
        end
        Wait(1000)
    end
end)