local cfg=module("arma-vehicles", "garages")


RegisterNetEvent("ARMA:refreshGaragePermissions")
AddEventHandler("ARMA:refreshGaragePermissions",function()
    local source=source
    local garageTable={}
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(cfg.garages) do
        for a,b in pairs(v) do
            if a == "_config" then
                if b.permissions[1] ~= nil then
                    if ARMA.hasPermission(ARMA.getUserId(source),b.permissions[1])then
                        table.insert(garageTable, k)
                    end
                else
                    table.insert(garageTable, k)
                end
            end
        end
    end
    TriggerClientEvent("ARMA:recieveRefreshedGaragePermissions",source,garageTable)
end)