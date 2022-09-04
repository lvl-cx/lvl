local cfg=module("cfg/cfg_simeons")
local inventory=module("cfg/inventory")


RegisterNetEvent("ARMA:refreshSimeonsPermissions")
AddEventHandler("ARMA:refreshSimeonsPermissions",function()
    local source=source
    local simeonsCategories={}
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(cfg.simeonsCategories) do
        for a,b in pairs(v) do
            if a == "_config" then
                if b.permissionTable[1] ~= nil then
                    if ARMA.hasPermission(ARMA.getUserId(source),b.permissionTable[1])then
                        for c,d in pairs(v) do
                            if inventory.vehicle_chest_weights[c] then
                                table.insert(v[c],inventory.vehicle_chest_weights[c])
                            else
                                table.insert(v[c],30)
                            end
                        end
                        simeonsCategories[k] = v
                    end
                else
                    for c,d in pairs(v) do
                        if inventory.vehicle_chest_weights[c] then
                            table.insert(v[c],inventory.vehicle_chest_weights[c])
                        else
                            table.insert(v[c],30)
                        end
                    end
                    simeonsCategories[k] = v
                end
            end
        end
    end
    TriggerClientEvent("ARMA:gotCarDealerInstances",source,cfg.simeonsInstances)
    TriggerClientEvent("ARMA:gotCarDealerCategories",source,simeonsCategories)
end)

RegisterNetEvent('ARMA:purchaseCarDealerVehicle')
AddEventHandler('ARMA:purchaseCarDealerVehicle', function(vehicleclass, vehicle)
    local player = source
    local user_id = ARMA.getUserId(source)
    local playerName = GetPlayerName(source)   
    for k,v in pairs(cfg.simeonsCategories[vehicleclass]) do
        if k == vehicle then
            local vehicle_name = v[1]
            local vehicle_price = v[2]
            MySQL.query("ARMA/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
                if #pvehicle > 0 then
                    ARMAclient.notify(player,{"~r~Vehicle already owned."})
                else
                    if ARMA.tryFullPayment(user_id, vehicle_price) then
                        ARMA.getUserIdentity(user_id, function(identity)
                            MySQL.execute("ARMA/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = "P "..identity.registration})
                        end)
                        ARMAclient.notify(player,{"~g~You paid £"..vehicle_price.." for "..vehicle_name.."."})
                        TriggerClientEvent("ARMA:PlaySound", player, 1)
                    else
                        ARMAclient.notify(player,{"~r~Not enough money."})
                        TriggerClientEvent("ARMA:PlaySound", player, 2)
                    end
                end
            end)
        end
    end
end)
