local stores = {
    ["paleto_twentyfourseven"] = {
        position = vector3(1728.7196044922, 6417.0654296875, 34.037220001221),
        beingrobbed = false,
        cooldown = 0,
        storename = 'Paleto 24/7',
    },
    ["sandyshores_twentyfoursever"] = {
        position = vector3(1959.0535888672, 3741.7045898438, 31.3437995910641),
        beingrobbed = false,
        cooldown = 0,
        storename = 'Sandy Shores 24/7',
    },
    ["bar_one"] = {
        position = vector3(1984.4356689453, 3054.7565917969, 47.215145111084),
        beingrobbed = false,
        cooldown = 0,
        storename = 'Bar One',
    },
    ["littleseoul_twentyfourseven"] = {
        position = vector3(-706.16192626953, -913.20764160156, 18.215581893921),
        beingrobbed = false,
        cooldown = 0,
        storename = 'Little Seoul 24/7',
    },
    ["asda"] = {
        position = vector3(24.493055343628, -1345.4788818359, 28.497024536133),
        beingrobbed = false,
        cooldown = 0,
        storename = 'Asda',
    },
    ["southlossantos_twentyfourseven"] = {
        position = vector3(-46.450626373291, -1757.5461425781, 28.420984268188),
        beingrobbed = false,
        cooldown = 0,
        storename = 'South Los Santos 24/7',
    },
    ["vinewood_twentyfourseven"] = {
        position = vector3(372.95562744141, 328.26510620117, 102.56648254395),
        beingrobbed = false,
        cooldown = 0,
        storename = 'Vinewood 24/7',
    },
    ["eastlossantos_robsliquor"] = {
        position = vector3(1134.2801513672, -982.96826171875, 45.415786743164),
        beingrobbed = false,
        cooldown = 0,
        storename = 'East Los Santos Rob\'s Liquor',
    },
    ["sandyshores_twentyfourseven"] = {
        position = vector3(2676.5114746094, 3280.2993164063, 54.241176605225),
        beingrobbed = false,
        cooldown = 0,
        storename = 'Sandy Shores 24/7',
    },
    ["grapeseed_gasstop"] = {
        position = vector3(1698.5382080078, 4922.6352539063, 41.063629150391),
        beingrobbed = false,
        cooldown = 0,
        storename = 'Grapeseed Gas Stop',
    },
    ["morningwood_robsliquor"] = {
        position = vector3(-1486.6450195313, -377.64117431641, 39.16344833374),
        beingrobbed = false,
        cooldown = 0,
        storename = 'Morningwood Rob\'s Liquor',
    },
    ["chumash_robsliquor"] = {
        position = vector3(-2966.4086914063, 391.35339355469, 14.043314933777),
        beingrobbed = false,
        cooldown = 0,
        storename = 'Chumash Rob\'s Liquor',
    },
    ["burgershot"] = {
        position = vector3(-1194.9146728516, -893.99810791016, 12.995297431946),
        beingrobbed = false,
        cooldown = 0,
        storename = 'Burger Shot',
    },
    ["eastlossantos_gasstop"] = {
        position = vector3(1164.5863037109, -322.3291015625, 68.205024719238),
        beingrobbed = false,
        cooldown = 0,
        storename = 'East Los Santos Gas Stop',
    },
    ["tongva_gasstop"] = {
        position = vector3(-1820.384765625, 794.54663085938, 137.08973693848),
        beingrobbed = false,
        cooldown = 0,
        storename = 'Tongva Gas Stop',
    },
    ["tataviam_twentyfourseven"] = {
        position = vector3(2555.5571289063, 380.84866333008, 107.62292480469),
        beingrobbed = false,
        cooldown = 0,
        storename = 'Tataviam 24/7',
    }
}

RegisterNetEvent('ARMA:getStoreRobBlips')
AddEventHandler('ARMA:getStoreRobBlips', function()
    local source = source
    TriggerClientEvent('ARMA:updateStoreRobBlips', -1, stores)
end)


RegisterNetEvent('ARMA:initiateStoreRobbery')
AddEventHandler('ARMA:initiateStoreRobbery', function(store)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "police.onduty.permission") then
        TriggerClientEvent('ARMA:resetStorePed', source, store)
    else
        if #ARMA.getUsersByPermission('police.onduty.permission') > 2 then
            for k,v in pairs(stores) do
                if k == store then
                    if v.cooldown == 0 then
                        v.beingrobbed = true
                        v.cooldown = 300
                        TriggerClientEvent('ARMA:updateStoreRobBlips', -1, stores)
                        TriggerClientEvent('ARMA:beginStoreRobbingAnimations', -1, store)
                        TriggerClientEvent('ARMA:storeRobberyInProgress', source, true, store)
                        for a, b in pairs(ARMA.getUsers({})) do
                            if ARMA.hasPermission(b, "police.onduty.permission") then
                                TriggerClientEvent('chatMessage', -1, "^7Robbery in progress at ^2"..v.storename, { 128, 128, 128 }, message, "alert")
                            end
                        end
                    else
                        TriggerClientEvent('chatMessage', source, "^7OOC ^1Store Robbery ^7 - Store was robbed too recently, "..v.cooldown.." seconds remaining.", { 128, 128, 128 }, message, "ooc")
                    end
                end
            end
        else
            ARMAclient.notify(source, {'~r~There are not enough police on duty to rob a store.'})
            TriggerClientEvent('ARMA:resetStorePed', source, store)
        end
    end
end)

RegisterNetEvent('ARMA:completeSafeCracking')
AddEventHandler('ARMA:completeSafeCracking', function(store)
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMA.giveMoney(user_id, math.random(85000, 100000))
    TriggerClientEvent('ARMA:syncCloseSafeDoor', -1, store)
    TriggerClientEvent('ARMA:resetStorePed', -1, store)
    for k,v in pairs(stores) do
        if k == store then
            v.beingrobbed = false
        end
    end
    TriggerClientEvent('ARMA:updateStoreRobBlips', -1, stores)
    TriggerClientEvent('ARMA:storeRobberyInProgress', source, false, store)
end)

RegisterNetEvent('ARMA:forceEndRobbery')
AddEventHandler('ARMA:forceEndRobbery', function(store)
    local source = source
    local user_id = ARMA.getUserId(source)
    TriggerClientEvent('ARMA:resetStorePed', -1, store)
    for k,v in pairs(stores) do
        if k == store then
            v.beingrobbed = false
        end
    end
    TriggerClientEvent('ARMA:updateStoreRobBlips', -1, stores)
    TriggerClientEvent('ARMA:storeRobberyInProgress', source, false, store)
end)

RegisterNetEvent('ARMA:syncOpenSafeDoor')
AddEventHandler('ARMA:syncOpenSafeDoor', function(store)
    local source = source
    TriggerClientEvent('ARMA:syncOpenSafeDoor', -1, store)
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(stores) do
            if v.cooldown > 0 then
                v.cooldown = v.cooldown - 1
                if v.cooldown == 0 then
                    v.beingrobbed = false
                    TriggerClientEvent('ARMA:updateStoreRobBlips', -1, stores)
                end
            end
        end
        Citizen.Wait(1000)
    end
end)