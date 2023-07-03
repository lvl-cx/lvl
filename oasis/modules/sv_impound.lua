local cfg = module("oasis-vehicles", "garages")
local impoundcfg = module("cfg/cfg_impound")

MySQL.createCommand("OASIS/get_impounded_vehicles", "SELECT * FROM oasis_user_vehicles WHERE user_id = @user_id AND impounded = 1")
MySQL.createCommand("OASIS/get_vehicles", "SELECT vehicle, rentedtime, vehicle_plate, fuel_level FROM oasis_user_vehicles WHERE user_id = @user_id AND rented = 0")
MySQL.createCommand("OASIS/unimpound_vehicle", "UPDATE oasis_user_vehicles SET impounded = 0, impound_info = null, impound_time = null WHERE vehicle = @vehicle AND user_id = @user_id")
MySQL.createCommand("OASIS/impound_vehicle", "UPDATE oasis_user_vehicles SET impounded = 1, impound_info = @impound_info, impound_time = @impound_time WHERE vehicle = @vehicle AND user_id = @user_id")



RegisterNetEvent('OASIS:getImpoundedVehicles')
AddEventHandler('OASIS:getImpoundedVehicles', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    local returned_table = {}
    if user_id then
        MySQL.query("OASIS/get_impounded_vehicles", {user_id = user_id}, function(impoundedvehicles)
            for k,v in pairs(impoundedvehicles) do
                if impoundedvehicles[k]['impound_info'] ~= '' then
                    data = json.decode(impoundedvehicles[k]['impound_info'])
                    returned_table[v.vehicle] = {vehicle = v.vehicle, vehicle_name = data.vehicle_name, impounded_by_name = data.impounded_by_name, impounder = data.impounder, reasons = data.reasons}
                end
            end
            TriggerClientEvent('OASIS:receiveImpoundedVehicles', source, returned_table)
        end)
    end
end)


RegisterNetEvent('OASIS:fetchInfoForVehicleToImpound')
AddEventHandler('OASIS:fetchInfoForVehicleToImpound', function(userid, spawncode, entityid)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') then
        for k,v in pairs(cfg.garages) do
            for a,b in pairs(v) do
                if a == spawncode then
                    vehicle = spawncode
                    vehicle_name = b[1]
                    owner_id = userid
                    vehiclenetid = entityid
                    if OASIS.getUserSource(userid) ~= nil then
                        owner_name = GetPlayerName(OASIS.getUserSource(userid))
                        TriggerClientEvent('OASIS:receiveInfoForVehicleToImpound', source, owner_id, owner_name, vehicle, vehicle_name, vehiclenetid)
                        return
                    else
                        OASISclient.notify(source, {'~r~Unable to locate owner.'})
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('OASIS:releaseImpoundedVehicle')
AddEventHandler('OASIS:releaseImpoundedVehicle', function(spawncode)
    local source = source
    local user_id = OASIS.getUserId(source)
    MySQL.query("OASIS/get_impounded_vehicles", {user_id = user_id}, function(impoundedvehicles)
        for k,v in pairs(impoundedvehicles) do
            if impoundedvehicles[k]['impound_time'] ~= '' then
                if os.time() >= tonumber(impoundedvehicles[k]['impound_time'])+600 then
                    if OASIS.tryFullPayment(user_id, 25000) then
                        MySQL.execute("OASIS/unimpound_vehicle", {vehicle = spawncode, user_id = user_id})
                        local randomSpawn = math.random(#impoundcfg.positions)
                        MySQL.query("OASIS/get_vehicles", {user_id = user_id}, function(result)
                            if result ~= nil then 
                                for k,v in pairs(result) do
                                    if v.vehicle == spawncode then
                                        TriggerClientEvent('OASIS:spawnPersonalVehicle', source, v.vehicle, user_id, false, vector3(impoundcfg.positions[randomSpawn].x, impoundcfg.positions[randomSpawn].y, impoundcfg.positions[randomSpawn].z), v.vehicle_plate, v.fuel_level)
                                        TriggerEvent('OASIS:addToCommunityPot', 10000)
                                        OASISclient.notifyPicture(source, {"polnotification","notification","Your vehicle has been released from the impound at the cost of ~g~£10,000~w~."})
                                        return
                                    end
                                end
                            end
                        end)
                    else
                        OASISclient.notify(source, {'~r~You do not have enough money to retrieve your vehicle from the impound.'})
                    end
                else
                    OASISclient.notifyPicture(source, {"polnotification","notification","This vehicle cannot be unimpounded for another ~r~"..math.floor( (tonumber(impoundedvehicles[k]['impound_time'])+600 - os.time())/60).."minutes ~w~."})
                end
            end
        end
    end)
end)


RegisterNetEvent('OASIS:impoundVehicle')
AddEventHandler('OASIS:impoundVehicle', function(userid, name, spawncode, vehiclename, reasons, entityid)
    local source = source
    local user_id = OASIS.getUserId(source)
    local entitynetid = NetworkGetEntityFromNetworkId(entityid)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') then
        local m = {}
        for k,v in pairs(impoundcfg.reasonsForImpound) do 
            for a,b in pairs(reasons) do
                if k == a then
                    table.insert(m, v.option)
                end
            end
        end
        MySQL.execute("OASIS/impound_vehicle", {impound_info = json.encode({vehicle_name = vehiclename, impounded_by_name = GetPlayerName(source), impounder = user_id, reasons = m}), impound_time = os.time(), vehicle = spawncode, user_id = userid})
        local A,B = GetVehicleColours(entitynetid)
        TriggerClientEvent('OASIS:impoundSuccess', source, entityid, vehiclename, GetPlayerName(OASIS.getUserSource(userid)), spawncode, A, B, GetEntityCoords(entitynetid), GetEntityHeading(entitynetid))
        OASISclient.notifyPicture(OASIS.getUserSource(userid), {"polnotification","notification","Your "..vehiclename.." has been impounded by ~b~"..GetPlayerName(source).." \n\n~w~For more information please visit the impound.","Metropolitan Police","Impound",nil,nil})
        tOASIS.sendWebhook('impound', 'OASIS Seize Boot Logs', "> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Vehicle: **"..spawncode.."**\n> Vehicle Name: **"..vehiclename.."**\n> Owner ID: **"..userid.."**")
    end
end)


RegisterServerEvent("OASIS:deleteImpoundEntities")
AddEventHandler("OASIS:deleteImpoundEntities", function(a,b,c)
    TriggerClientEvent("OASIS:deletePropClient", -1, a)
    TriggerClientEvent("OASIS:deletePropClient", -1, b)
    TriggerClientEvent("OASIS:deletePropClient", -1, c)
end)

RegisterServerEvent("OASIS:awaitTowTruckArrival")
AddEventHandler("OASIS:awaitTowTruckArrival", function(vehicle, flatbed, ped)
    local count = 0
    while count < 30 do
        Citizen.Wait(1000)
        count = count + 1
    end
    if count == 30 then
        TriggerClientEvent("OASIS:deletePropClient", -1, vehicle)
        TriggerClientEvent("OASIS:deletePropClient", -1, flatbed)
        TriggerClientEvent("OASIS:deletePropClient", -1, ped)
    end
end)
