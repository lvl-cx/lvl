RegisterCommand('craftbmx', function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("ARMA:spawnNitroBMX", source)
    else
        if tARMA.checkForRole(user_id, '975543463808487465') then
            TriggerClientEvent("ARMA:spawnNitroBMX", source)
        end
    end
end)

RegisterCommand('craftmoped', function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMAclient.isPlatClub(source, {}, function(isPlatClub)
        if isPlatClub then
            TriggerClientEvent("ARMA:spawnMoped", source)
        end
    end)
end)