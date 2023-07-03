local spikes = 0
local speedzones = 0

RegisterNetEvent("OASIS:placeSpike")
AddEventHandler("OASIS:placeSpike", function(heading, coords)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') then
        TriggerClientEvent('OASIS:addSpike', -1, coords, heading)
    end
end)

RegisterNetEvent("OASIS:removeSpike")
AddEventHandler("OASIS:removeSpike", function(entity)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') then
        TriggerClientEvent('OASIS:deleteSpike', -1, entity)
        TriggerClientEvent("OASIS:deletePropClient", -1, entity)
    end
end)

RegisterNetEvent("OASIS:requestSceneObjectDelete")
AddEventHandler("OASIS:requestSceneObjectDelete", function(prop)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') or OASIS.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent("OASIS:deletePropClient", -1, prop)
    end
end)

RegisterNetEvent("OASIS:createSpeedZone")
AddEventHandler("OASIS:createSpeedZone", function(coords, radius, speed)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') or OASIS.hasPermission(user_id, 'prisonguard.onduty.permission') then
        speedzones = speedzones + 1
        TriggerClientEvent('OASIS:createSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

RegisterNetEvent("OASIS:deleteSpeedZone")
AddEventHandler("OASIS:deleteSpeedZone", function(speedzone)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') or OASIS.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent('OASIS:deleteSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

