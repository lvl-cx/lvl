local purgeLB = {[1] = {"cnr", 10}}

RegisterServerEvent('ARMA:getTopFraggers')
AddEventHandler('ARMA:getTopFraggers', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    TriggerClientEvent('ARMA:gotTopFraggers', source, purgeLB)
end)

RegisterCommand('addkill', function()
    TriggerClientEvent('ARMA:incrementPurgeKills', -1)
end)

RegisterCommand('purgespawn', function()
    TriggerClientEvent('ARMA:purgeSpawnClient', -1)
end)