


local crateLocations = {
    vector3(1875.281, 285.2199, 164.3051),
    vector3(2945.5515136719,2795.4934082031,40.646308898926),
    vector3(-1627.5288085938,720.173828125,192.08515930176),
    vector3(-62.860485076904,-2493.8740234375,6.0251984596252),
}
local activeCrates = {}

local stayTime = 15*60 --How long till the airdrop disappears
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
    if #(GetEntityCoords(GetPlayerPed(source)) - crateLocations[crateID]) < 2.0 then
        table.remove(activeCrates, crateID)
        FreezeEntityPosition(GetPlayerPed(source), true)
        ARMAclient.startCircularProgressBar(source, {"", 15000, nil})
        local anims = {
            {'amb@medic@standing@kneel@base', 'base', 1},
            {'anim@gangops@facility@servers@bodysearch@', 'player_search', 1},
        }
        ARMAclient.playAnim(source,{true,anims,false})
        Wait(15000)
        local lootAmount = math.random(2,5)
        while lootAmount > 0 do
            local randomItem = math.random(1, #availableItems)
            for k,v in pairs(availableItems) do
                if k == randomItem then
                    ARMA.giveInventoryItem(user_id, v[1], v[2], true)
                end
            end
            lootAmount = lootAmount - 1
        end
        ARMA.giveMoney(user_id,math.random(50000,150000))
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "Crate drop has been looted.", "alert")
        FreezeEntityPosition(GetPlayerPed(source), false)
        TriggerClientEvent("ARMA:removeLootcrate", crateID)
        TriggerClientEvent("ARMA:removeCrateRedzone", -1)
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
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "A cartel plane carrying supplies has had to bail and is parachuting to the ground! Get to it quick, check your GPS!", "alert")
        Wait(stayTime * 1000)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The airdrop has disappeared.", "alert")
            table.remove(activeCrates, crateID)
            TriggerClientEvent("ARMA:removeLootcrate", -1, crateID)
        end
        Wait(1000)
    end
end)