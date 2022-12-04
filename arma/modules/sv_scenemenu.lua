local spikes = 0
local speedzones = 0

RegisterNetEvent("ARMA:placeSpike")
AddEventHandler("ARMA:placeSpike", function(heading, coords)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent('ARMA:addSpike', -1, coords, heading)
    end
end)

RegisterNetEvent("ARMA:removeSpike")
AddEventHandler("ARMA:removeSpike", function(entity)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent('ARMA:deleteSpike', -1, entity)
        TriggerClientEvent("ARMA:deletePropClient", -1, entity)
    end
end)

RegisterNetEvent("ARMA:requestSceneObjectDelete")
AddEventHandler("ARMA:requestSceneObjectDelete", function(prop)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent("ARMA:deletePropClient", -1, prop)
    end
end)

RegisterNetEvent("ARMA:createSpeedZone")
AddEventHandler("ARMA:createSpeedZone", function(coords, radius, speed)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') then
        speedzones = speedzones + 1
        TriggerClientEvent('ARMA:createSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

RegisterNetEvent("ARMA:deleteSpeedZone")
AddEventHandler("ARMA:deleteSpeedZone", function(speedzone)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent('ARMA:deleteSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

