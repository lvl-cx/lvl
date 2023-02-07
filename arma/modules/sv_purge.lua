local purgeLB = {}

RegisterServerEvent('ARMA:getTopFraggers')
AddEventHandler('ARMA:getTopFraggers', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    TriggerClientEvent('ARMA:gotTopFraggers', source, purgeLB)
end)

RegisterCommand('addkill', function()
    TriggerClientEvent('ARMA:incrementPurgeKills', -1)
end)