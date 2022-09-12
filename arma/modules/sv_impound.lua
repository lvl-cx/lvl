local cfg = module("arma-vehicles", "garages")
local impoundcfg = module("cfg/cfg_impound")

MySQL.createCommand("ARMA/get_impounded_vehicles", "SELECT * FROM arma_user_vehicles WHERE user_id = @user_id AND impounded = 1")
MySQL.createCommand("ARMA/get_vehicles", "SELECT vehicle, rentedtime, vehicle_plate, fuel_level FROM arma_user_vehicles WHERE user_id = @user_id AND rented = 0")
MySQL.createCommand("ARMA/unimpound_vehicle", "UPDATE arma_user_vehicles SET impounded = 0, impound_info = null, impound_time = null WHERE vehicle = @vehicle AND user_id = @user_id")
MySQL.createCommand("ARMA/impound_vehicle", "UPDATE arma_user_vehicles SET impounded = 1, impound_info = @impound_info, impound_time = @impound_time WHERE vehicle = @vehicle AND user_id = @user_id")



RegisterNetEvent('ARMA:getImpoundedVehicles')
AddEventHandler('ARMA:getImpoundedVehicles', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local returned_table = {}
    if user_id then
        MySQL.query("ARMA/get_impounded_vehicles", {user_id = user_id}, function(impoundedvehicles)
            for k,v in pairs(impoundedvehicles) do
                if impoundedvehicles[k]['impound_info'] ~= '' then
                    data = json.decode(impoundedvehicles[k]['impound_info'])
                    returned_table[v.vehicle] = {vehicle = v.vehicle, vehicle_name = data.vehicle_name, impounded_by_name = data.impounded_by_name, impounder = data.impounder, reasons = data.reasons}
                end
            end
            TriggerClientEvent('ARMA:receiveImpoundedVehicles', source, returned_table)
        end)
    end
end)


RegisterNetEvent('ARMA:fetchInfoForVehicleToImpound')
AddEventHandler('ARMA:fetchInfoForVehicleToImpound', function(userid, spawncode, entityid)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
        for k,v in pairs(cfg.garages) do
            for a,b in pairs(v) do
                if a == spawncode then
                    vehicle = spawncode
                    vehicle_name = b[1]
                    owner_id = userid
                    vehiclenetid = entityid
                    owner_name = GetPlayerName(ARMA.getUserSource(userid)) or 'Unknown'
                    TriggerClientEvent('ARMA:receiveInfoForVehicleToImpound', source, owner_id, owner_name, vehicle, vehicle_name, vehiclenetid)
                end
            end
        end
    end
end)

RegisterNetEvent('ARMA:releaseImpoundedVehicle')
AddEventHandler('ARMA:releaseImpoundedVehicle', function(spawncode)
    local source = source
    local user_id = ARMA.getUserId(source)
    MySQL.query("ARMA/get_impounded_vehicles", {user_id = user_id}, function(impoundedvehicles)
        for k,v in pairs(impoundedvehicles) do
            if impoundedvehicles[k]['impound_time'] ~= '' then
                if os.time() >= tonumber(impoundedvehicles[k]['impound_time'])+600 then
                    if ARMA.tryFullPayment(user_id, 25000) then
                        MySQL.execute("ARMA/unimpound_vehicle", {vehicle = spawncode, user_id = user_id})
                        local randomSpawn = math.random(#impoundcfg.positions)
                        MySQL.query("ARMA/get_vehicles", {user_id = user_id}, function(result)
                            if result ~= nil then 
                                for k,v in pairs(result) do
                                    if v.vehicle == spawncode then
                                        TriggerClientEvent('ARMA:spawnPersonalVehicle', source, v.vehicle, user_id, false, vector3(impoundcfg.positions[randomSpawn].x, impoundcfg.positions[randomSpawn].y, impoundcfg.positions[randomSpawn].z), v.vehicle_plate, v.fuel_level)
                                        return
                                    end
                                end
                            end
                        end)
                    else
                        ARMAclient.notify(source, {'~r~You do not have enough money to retrieve your vehicle from the impound.'})
                    end
                else
                    ARMAclient.notify(source, {'~r~You must wait '..math.floor( (tonumber(impoundedvehicles[k]['impound_time'])+600 - os.time())/60)..' minutes before retrieving your vehicle from the impound.'})
                end
            end
        end
    end)
end)


RegisterNetEvent('ARMA:impoundVehicle')
AddEventHandler('ARMA:impoundVehicle', function(userid, name, spawncode, vehiclename, reasons, entityid)
    local source = source
    local user_id = ARMA.getUserId(source)
    local entitynetid = NetworkGetEntityFromNetworkId(entityid)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
        local m = {}
        for k,v in pairs(impoundcfg.reasonsForImpound) do 
            for a,b in pairs(reasons) do
                if k == a then
                    table.insert(m, v.option)
                end
            end
        end
        MySQL.execute("ARMA/impound_vehicle", {impound_info = json.encode({vehicle_name = vehiclename, impounded_by_name = GetPlayerName(source), impounder = user_id, reasons = m}), impound_time = os.time(), vehicle = spawncode, user_id = userid})
        local A,B = GetVehicleColours(entitynetid)
        TriggerClientEvent('ARMA:impoundSuccess', source, entityid, vehiclename, GetPlayerName(ARMA.getUserSource(userid)), spawncode, A, B, GetEntityCoords(entitynetid), GetEntityHeading(entitynetid))
        ARMAclient.notifyPicture(ARMA.getUserSource(userid), {"polnotification","notification","Your "..vehiclename.." has been impounded by ~b~"..GetPlayerName(source).." \n\n~w~For more information please visit the impound.","Metropolitan Police","Impound",nil,nil})
    end
end)


RegisterServerEvent("ARMA:deleteImpoundEntities")
AddEventHandler("ARMA:deleteImpoundEntities", function(a,b,c)
    TriggerClientEvent("ARMA:deletePropClient", -1, a)
    TriggerClientEvent("ARMA:deletePropClient", -1, b)
    TriggerClientEvent("ARMA:deletePropClient", -1, c)
end)

RegisterServerEvent("ARMA:awaitTowTruckArrival")
AddEventHandler("ARMA:awaitTowTruckArrival", function(vehicle, flatbed, ped)
    local count = 0
    while count < 30 do
        Citizen.Wait(1000)
        count = count + 1
    end
    if count == 30 then
        TriggerClientEvent("ARMA:deletePropClient", -1, vehicle)
        TriggerClientEvent("ARMA:deletePropClient", -1, flatbed)
        TriggerClientEvent("ARMA:deletePropClient", -1, ped)
    end
end)
