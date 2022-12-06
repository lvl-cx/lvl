RegisterCommand('craftbmx', function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("ARMA:spawnNitroBMX", source)
    else
        exports["discordroles"]:isRolePresent(source, {'975543463808487465'}, function(hasRole, roles)
            if (not roles) then 
                ARMAclient.notify(source,{"~r~It seems you don't have discord running or installed try restart fivem if this issue persists /calladmin."})
            end
            if hasRole then
                TriggerClientEvent("ARMA:spawnNitroBMX", source)
            end
        end)
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