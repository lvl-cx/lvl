RegisterServerEvent("OASIS:stretcherAttachPlayer")
AddEventHandler('OASIS:stretcherAttachPlayer', function(playersrc)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('OASIS:stretcherAttachPlayer', source, playersrc)
    end
end)

RegisterServerEvent("OASIS:toggleAmbulanceDoors")
AddEventHandler('OASIS:toggleAmbulanceDoors', function(stretcherNetid)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('OASIS:toggleAmbulanceDoorStatus', -1, stretcherNetid)
    end
end)

RegisterServerEvent("OASIS:updateHasStretcherInsideDecor")
AddEventHandler('OASIS:updateHasStretcherInsideDecor', function(stretcherNetid, status)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('OASIS:setHasStretcherInsideDecor', -1, stretcherNetid, status)
    end
end)

RegisterServerEvent("OASIS:updateStretcherLocation")
AddEventHandler('OASIS:updateStretcherLocation', function(a,b)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('OASIS:OASIS:setStretcherInside', -1, a,b)
    end
end)

RegisterServerEvent("OASIS:removeStretcher")
AddEventHandler('OASIS:removeStretcher', function(stretcher)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('OASIS:deletePropClient', -1, stretcher)
    end
end)

RegisterServerEvent("OASIS:forcePlayerOnToStretcher")
AddEventHandler('OASIS:forcePlayerOnToStretcher', function(id, stretcher)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('OASIS:forcePlayerOnToStretcher', id, stretcher)
    end
end)