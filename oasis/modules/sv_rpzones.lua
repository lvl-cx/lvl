local rpZones = {}
local numRP = 0
RegisterServerEvent("OASIS:createRPZone")
AddEventHandler("OASIS:createRPZone", function(a)
	local source = source
	local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'group.remove') then
        numRP = numRP + 1
        a['uuid'] = numRP
        rpZones[numRP] = a
        TriggerClientEvent('OASIS:createRPZone', -1, a)
    end
end)

RegisterServerEvent("OASIS:removeRPZone")
AddEventHandler("OASIS:removeRPZone", function(b)
	local source = source
	local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'group.remove') then
        if next(rpZones) then
            for k,v in pairs(rpZones) do
                if v.uuid == b then
                    rpZones[k] = nil
                    TriggerClientEvent('OASIS:removeRPZone', -1, b)
                end
            end
        end
    end
end)

AddEventHandler("OASIS:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        for k,v in pairs(rpZones) do
            TriggerClientEvent('OASIS:createRPZone', source, rpZones)
        end
    end
end)
