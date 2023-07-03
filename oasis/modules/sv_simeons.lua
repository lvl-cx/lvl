local cfg=module("cfg/cfg_simeons")
local inventory=module("oasis-vehicles", "inventory")


RegisterNetEvent("OASIS:refreshSimeonsPermissions")
AddEventHandler("OASIS:refreshSimeonsPermissions",function()
    local source=source
    local simeonsCategories={}
    local user_id = OASIS.getUserId(source)
    for k,v in pairs(cfg.simeonsCategories) do
        for a,b in pairs(v) do
            if a == "_config" then
                if b.permissionTable[1] ~= nil then
                    if OASIS.hasPermission(OASIS.getUserId(source),b.permissionTable[1])then
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
    TriggerClientEvent("OASIS:gotCarDealerInstances",source,cfg.simeonsInstances)
    TriggerClientEvent("OASIS:gotCarDealerCategories",source,simeonsCategories)
end)

RegisterNetEvent('OASIS:purchaseCarDealerVehicle')
AddEventHandler('OASIS:purchaseCarDealerVehicle', function(vehicleclass, vehicle)
    local source = source
    local user_id = OASIS.getUserId(source)
    local playerName = GetPlayerName(source)   
    for k,v in pairs(cfg.simeonsCategories[vehicleclass]) do
        if k == vehicle then
            local vehicle_name = v[1]
            local vehicle_price = v[2]
            MySQL.query("OASIS/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
                if #pvehicle > 0 then
                    OASISclient.notify(source,{"~r~Vehicle already owned."})
                else
                    if OASIS.tryFullPayment(user_id, vehicle_price) then
                        OASISclient.generateUUID(source, {"plate", 5, "alphanumeric"}, function(uuid)
                            local uuid = string.upper(uuid)
                            MySQL.execute("OASIS/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = 'P'..uuid})
                            OASISclient.notify(source,{"~g~You paid £"..vehicle_price.." for "..vehicle_name.."."})
                            TriggerClientEvent("oasis:PlaySound", source, 1)
                        end)
                    else
                        OASISclient.notify(source,{"~r~Not enough money."})
                        TriggerClientEvent("oasis:PlaySound", source, 2)
                    end
                end
            end)
        end
    end
end)
