RegisterServerEvent("ARMA:stretcherAttachPlayer")
AddEventHandler('ARMA:stretcherAttachPlayer', function(playersrc)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('ARMA:stretcherAttachPlayer', source, playersrc)
    end
end)

RegisterServerEvent("ARMA:toggleAmbulanceDoors")
AddEventHandler('ARMA:toggleAmbulanceDoors', function(stretcherNetid)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('ARMA:toggleAmbulanceDoorStatus', -1, stretcherNetid)
    end
end)

RegisterServerEvent("ARMA:updateHasStretcherInsideDecor")
AddEventHandler('ARMA:updateHasStretcherInsideDecor', function(stretcherNetid, status)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('ARMA:setHasStretcherInsideDecor', -1, stretcherNetid, status)
    end
end)

RegisterServerEvent("ARMA:updateStretcherLocation")
AddEventHandler('ARMA:updateStretcherLocation', function(a,b)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('ARMA:ARMA:setStretcherInside', -1, a,b)
    end
end)

RegisterServerEvent("ARMA:removeStretcher")
AddEventHandler('ARMA:removeStretcher', function(stretcher)
    local source = source
    local user_id = ARMA.getUserId(source)
    print(stretcher)
    if ARMA.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('ARMA:deletePropClient', -1, stretcher)
    end
end)

RegisterServerEvent("ARMA:forcePlayerOnToStretcher")
AddEventHandler('ARMA:forcePlayerOnToStretcher', function(id, stretcher)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('ARMA:forcePlayerOnToStretcher', id, stretcher)
    end
end)