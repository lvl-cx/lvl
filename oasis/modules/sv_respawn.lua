local cfg=module("cfg/cfg_respawn")


RegisterNetEvent("OASIS:SendSpawnMenu")
AddEventHandler("OASIS:SendSpawnMenu",function()
    local source = source
    local user_id = OASIS.getUserId(source)
    local spawnTable={}
    for k,v in pairs(cfg.spawnLocations)do
        if v.permission[1] ~= nil then
            if OASIS.hasPermission(OASIS.getUserId(source),v.permission[1])then
                table.insert(spawnTable, k)
            end
        else
            table.insert(spawnTable, k)
        end
    end
    exports['ghmattimysql']:execute("SELECT * FROM `oasis_user_homes` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for a,b in pairs(result) do
                table.insert(spawnTable, b.home)
            end
            TriggerClientEvent("OASIS:OpenSpawnMenu",source,spawnTable)
            OASIS.clearInventory(user_id) 
            OASISclient.setPlayerCombatTimer(source, {0})
        end
    end)
end)