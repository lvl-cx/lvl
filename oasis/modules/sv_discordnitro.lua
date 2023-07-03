RegisterCommand('craftbmx', function(source)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("OASIS:spawnNitroBMX", source)
    else
        if tOASIS.checkForRole(user_id, '975543463808487465') then
            TriggerClientEvent("OASIS:spawnNitroBMX", source)
        end
    end
end)

RegisterCommand('craftmoped', function(source)
    local source = source
    local user_id = OASIS.getUserId(source)
    OASISclient.isPlatClub(source, {}, function(isPlatClub)
        if isPlatClub then
            TriggerClientEvent("OASIS:spawnMoped", source)
        end
    end)
end)