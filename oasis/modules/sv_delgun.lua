netObjects = {}

RegisterServerEvent("OASIS:spawnVehicleCallback")
AddEventHandler('OASIS:spawnVehicleCallback', function(a, b)
    netObjects[b] = {source = OASIS.getUserSource(a), id = a, name = GetPlayerName(OASIS.getUserSource(a))}
end)

RegisterServerEvent("OASIS:delGunDelete")
AddEventHandler("OASIS:delGunDelete", function(object)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("OASIS:deletePropClient", -1, object)
        if netObjects[object] then
            TriggerClientEvent("OASIS:returnObjectDeleted", source, 'This object was created by ~b~'..netObjects[object].name..'~w~. Temp ID: ~b~'..netObjects[object].source..'~w~.\nPerm ID: ~b~'..netObjects[object].id..'~w~.')
        end
    end
end)