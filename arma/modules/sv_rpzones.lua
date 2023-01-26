local rpZones = {}
RegisterServerEvent("ARMA:createRPZone")
AddEventHandler("ARMA:createRPZone", function(a)
	local source = source
	local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'group.remove') then
        a['uuid'] = #rpZones+1
        rpZones = a
        TriggerClientEvent('ARMA:createRPZone', -1, rpZones)
    end
end)

RegisterServerEvent("ARMA:removeRPZone")
AddEventHandler("ARMA:removeRPZone", function(b)
	local source = source
	local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'group.remove') then
        TriggerClientEvent('ARMA:removeRPZone', -1, b)
        if next(rpZones) then
            for k,v in pairs(rpZones) do
                if v.uuid == b then
                    rpZones[k] = nil
                end
            end
        end
    end
end)

AddEventHandler("ARMA:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        for k,v in pairs(rpZones) do
            TriggerClientEvent('ARMA:createRPZone', source, rpZones)
        end
    end
end)
