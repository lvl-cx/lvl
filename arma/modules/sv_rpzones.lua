local z = 0
RegisterServerEvent("ARMA:createRPZone")
AddEventHandler("ARMA:createRPZone", function(a)
	local source = source
	local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'group.remove') then
        z=z+1
        a['uuid'] = z
        TriggerClientEvent('ARMA:createRPZone', -1, a)
    end
end)

RegisterServerEvent("ARMA:removeRPZone")
AddEventHandler("ARMA:removeRPZone", function(b)
	local source = source
	local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'group.remove') then
        TriggerClientEvent('ARMA:removeRPZone', -1, b)
    end
end)