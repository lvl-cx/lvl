RegisterServerEvent('ARMA:tryTackle')
AddEventHandler('ARMA:tryTackle', function(id)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent('ARMA:playTackle', source)
        TriggerClientEvent('ARMA:getTackled', id, source)
    end
end)