local purgeLB = {[1] = {"cnr", 10}}

RegisterServerEvent('OASIS:getTopFraggers')
AddEventHandler('OASIS:getTopFraggers', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    TriggerClientEvent('OASIS:gotTopFraggers', source, purgeLB)
end)

RegisterCommand('addkill', function()
    TriggerClientEvent('OASIS:incrementPurgeKills', -1)
end)

RegisterCommand('purgespawn', function()
    TriggerClientEvent('OASIS:purgeSpawnClient', -1)
end)