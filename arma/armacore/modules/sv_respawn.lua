RegisterNetEvent('ARMA:PoliceCheck')
AddEventHandler('ARMA:PoliceCheck', function()
    local source = source
    user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('ARMA:PolicePerms', source, true)
    else
        TriggerClientEvent('ARMA:PolicePerms', source, false)
    end
end)

RegisterNetEvent('ARMA:RebelCheck')
AddEventHandler('ARMA:RebelCheck', function()
    local source = source
    user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'rebel.guns') then
        TriggerClientEvent('ARMA:RebelPerms', source, true)
    else
        TriggerClientEvent('ARMA:RebelPerms', source, false)
    end
end)


RegisterNetEvent('ARMA:VIPCheck')
AddEventHandler('ARMA:VIPCheck', function()
    local source = source
    user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'vip.guns') then
        TriggerClientEvent('ARMA:VIPPerms', source, true)
    else
        TriggerClientEvent('ARMA:VIPPerms', source, false)
    end
end)

