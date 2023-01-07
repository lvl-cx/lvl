local cfg=module("cfg/cfg_respawn")


RegisterNetEvent("ARMA:SendSpawnMenu")
AddEventHandler("ARMA:SendSpawnMenu",function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local spawnTable={}
    for k,v in pairs(cfg.spawnLocations)do
        if v.permission[1] ~= nil then
            if ARMA.hasPermission(ARMA.getUserId(source),v.permission[1])then
                table.insert(spawnTable, k)
            end
        else
            table.insert(spawnTable, k)
        end
    end
    exports['ghmattimysql']:execute("SELECT * FROM `arma_user_homes` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for a,b in pairs(result) do
                table.insert(spawnTable, b.home)
            end
            TriggerClientEvent("ARMA:OpenSpawnMenu",source,spawnTable)
            ARMA.clearInventory(user_id) 
        end
    end)
end)