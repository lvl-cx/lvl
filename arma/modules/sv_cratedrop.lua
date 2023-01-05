


local crateLocations = { --Where you want the crate to spawn ALL MESSAGES YOU CAN DELETE AFTER (WOLFHILL)
    vector3(1865.0517578125,294.37481689453,168.91744995117),
    vector3(2945.5515136719,2795.4934082031,40.646308898926),
    vector3(-1627.5288085938,720.173828125,192.08515930176),
    vector3(-62.860485076904,-2493.8740234375,6.0251984596252),
}
local activeCrates = {}

local stayTime = 15*60 --How long till the airdrop disappears
local spawnTime = 20*60 -- Time between each airdrop

local availableItems = { --Where you put you weapons and how frequently you want them to spawn E.G M1911 with its ammo. and put that in there twice and akm once the m1911 will have more chance of spawning
    {"wbody|WEAPON_UMP45", 1},
    {"9mm Bullets", 250},
    {"wbody|WEAPON_MOSIN", 1},
    {"wbody|WEAPON_AKKAL", 1},
    {"7.62mm Bullets", 250},
}

RegisterServerEvent('ARMA:openCrate', function(crateID)
    local source = source
    local user_id = ARMA.getUserId(source)
    print('Current Crate: '..crateID, 'Active Crates: '..json.encode(activeCrates))
    if activeCrates[crateID] == nil then return end
    if #(GetEntityCoords(GetPlayerPed(source)) - crateLocations[crateID]) < 2.0 then
        FreezeEntityPosition(GetPlayerPed(source), true)
        ARMAclient.startCircularProgressBar(source, {"", 15000, nil})
        local anims = {
            {'amb@medic@standing@kneel@base', 'base', 1},
            {'anim@gangops@facility@servers@bodysearch@', 'player_search', 1},
        }
        ARMAclient.playAnim(source,{true,anims,false})
        Wait(15000)
        local lootrandom = math.random(3, 8)
        while lootrandom > 0 do
            local randomItem = math.random(1, #availableItems)
            for k,v in pairs(availableItems) do
                if k == randomItem then
                    ARMA.giveInventoryItem(user_id, v[1], v[2], true)
                end
            end
            lootrandom = lootrandom - 1
        end
        ARMA.giveMoney(user_id,math.random(50000,150000))
        TriggerClientEvent('chatMessage', -1, "^1[ARMA RP]: ^0", {66, 72, 245}, "Crate drop has been looted.", "alert")
        FreezeEntityPosition(GetPlayerPed(source), false)
        TriggerClientEvent("ARMA:removeLootcrate", crateID)
        TriggerClientEvent("ARMA:removeCrateRedzone", -1)
        table.remove(activeCrates, crateID)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(spawnTime * 1000)
        local crateID = math.random(1, #crateLocations)
        local crateCoords = crateLocations[crateID]
        local oilrig = false -- need to setup oil rig loot and coords
        TriggerClientEvent('ARMA:crateDrop', -1, crateCoords, crateID, oilrig)
        table.insert(activeCrates, crateID)
        TriggerClientEvent('chatMessage', -1, "^1[ARMA RP]: ^0", {66, 72, 245}, "An airdrop is landing...", "alert")
        Wait(1000 * stayTime)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^1[ARMA RP]: ^0", {66, 72, 245}, "The airdrop has disappeared.", "alert")
            table.remove(activeCrates, num)
            TriggerClientEvent("ARMA:removeLootcrate", num)
        end
        Wait(1000)
    end
end)

RegisterCommand('testdrop', function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id == 1 then
        local crateID = math.random(1, #crateLocations)
        local crateCoords = crateLocations[crateID]
        local oilrig = false -- need to setup oil rig loot and coords
        TriggerClientEvent('ARMA:crateDrop', -1, crateCoords, crateID, oilrig)
        table.insert(activeCrates, crateID)
        TriggerClientEvent('chatMessage', -1, "^1[ARMA RP]: ^0", {66, 72, 245}, "An airdrop is landing...", "alert")
        Wait(1000 * stayTime)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^1[ARMA RP]: ^0", {66, 72, 245}, "The airdrop has disappeared.", "alert")
            table.remove(activeCrates, num)
            TriggerClientEvent("ARMA:removeLootcrate", num)
        end
        Wait(1000)
    end
end)