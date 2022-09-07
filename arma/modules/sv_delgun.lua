local netObjects = {}

RegisterServerEvent("ARMA:spawnVehicleCallback")
AddEventHandler('ARMA:spawnVehicleCallback', function(a, b)
    netObjects[b] = {source = ARMA.getUserSource(a), id = a, name = GetPlayerName(ARMA.getUserSource(a))}
end)

RegisterServerEvent("ARMA:delGunDelete")
AddEventHandler("ARMA:delGunDelete", function(object)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("ARMA:deletePropClient", -1, object)
        if netObjects[object] then
            TriggerClientEvent("ARMA:returnObjectDeleted", source, 'This object was created by ~b~'..netObjects[object].name..' ~w~Temp ID: ~b~'..netObjects[object].source..' ~w~Perm ID: ~b~'..netObjects[object].id)
        end
    end
end)