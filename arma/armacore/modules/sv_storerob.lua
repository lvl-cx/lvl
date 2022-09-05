local stores = {
    ["paleto_twentyfourseven"] = {
        position = vector3(1728.7196044922, 6417.0654296875, 34.037220001221),
        beingrobbed = false,
        cooldown = 0,
    },
    ["sandyshores_twentyfoursever"] = {
        position = vector3(1959.0535888672, 3741.7045898438, 31.3437995910641),
        beingrobbed = false,
        cooldown = 0,
    },
    ["bar_one"] = {
        position = vector3(1984.4356689453, 3054.7565917969, 47.215145111084),
        beingrobbed = false,
        cooldown = 0,
    },
    ["littleseoul_twentyfourseven"] = {
        position = vector3(-706.16192626953, -913.20764160156, 18.215581893921),
        beingrobbed = false,
        cooldown = 0,
    },
    ["asda"] = {
        position = vector3(24.493055343628, -1345.4788818359, 28.497024536133),
        beingrobbed = false,
        cooldown = 0,
    },
    ["southlossantos_twentyfourseven"] = {
        position = vector3(-46.450626373291, -1757.5461425781, 28.420984268188),
        beingrobbed = false,
        cooldown = 0,
    },
    ["vinewood_twentyfourseven"] = {
        position = vector3(372.95562744141, 328.26510620117, 102.56648254395),
        beingrobbed = false,
        cooldown = 0,
    },
    ["eastlossantos_robsliquor"] = {
        position = vector3(1134.2801513672, -982.96826171875, 45.415786743164),
        beingrobbed = false,
        cooldown = 0,
    },
    ["sandyshores_twentyfourseven"] = {
        position = vector3(2676.5114746094, 3280.2993164063, 54.241176605225),
        beingrobbed = false,
        cooldown = 0,
    },
    ["grapeseed_gasstop"] = {
        position = vector3(1698.5382080078, 4922.6352539063, 41.063629150391),
        beingrobbed = false,
        cooldown = 0,
    },
    ["morningwood_robsliquor"] = {
        position = vector3(-1486.6450195313, -377.64117431641, 39.16344833374),
        beingrobbed = false,
        cooldown = 0,
    },
    ["chumash_robsliquor"] = {
        position = vector3(-2966.4086914063, 391.35339355469, 14.043314933777),
        beingrobbed = false,
        cooldown = 0,
    },
    ["burgershot"] = {
        position = vector3(-1194.9146728516, -893.99810791016, 12.995297431946),
        beingrobbed = false,
        cooldown = 0,
    },
    ["eastlossantos_gasstop"] = {
        position = vector3(1164.5863037109, -322.3291015625, 68.205024719238),
        beingrobbed = false,
        cooldown = 0,
    },
    ["tongva_gasstop"] = {
        position = vector3(-1820.384765625, 794.54663085938, 137.08973693848),
        beingrobbed = false,
        cooldown = 0,
    },
    ["tataviam_twentyfourseven"] = {
        position = vector3(2555.5571289063, 380.84866333008, 107.62292480469),
        beingrobbed = false,
        cooldown = 0,
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
    for k,v in pairs(stores) do
        if k == store then
            if v.cooldown == 0 then
                v.beingrobbed = true
                v.cooldown = 300
                TriggerClientEvent('ARMA:updateStoreRobBlips', -1, stores)
                TriggerClientEvent('ARMA:beginStoreRobbingAnimations', -1, store)
                TriggerClientEvent('ARMA:storeRobberyInProgress', source, true, store)
            else
                TriggerClientEvent('chatMessage', -1, "^7OOC ^1Store Robbery ^7 - Store was robbed too recently, "..v.cooldown.." seconds remaining.", { 128, 128, 128 }, message, "ooc")
            end
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
            end
        end
        Citizen.Wait(1000)
    end
end)