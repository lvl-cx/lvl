local cfg=module("armacore/cfg/cfg_respawn")

RegisterNetEvent("ARMA:SendSpawnMenu")
AddEventHandler("ARMA:SendSpawnMenu",function()
    local source=source
    local spawnTable={}
    for k,v in pairs(cfg.spawnLocations)do
        if v.permission[1]~=nil then
            if ARMA.hasPermission(ARMA.getUserId(source),v.permission[1])then
                table.insert(spawnTable,{v.name})
            end
        else
            table.insert(spawnTable,{v.name})
        end
    end
    TriggerClientEvent("ARMA:OpenSpawnMenu",source,spawnTable)
end)

RegisterNetEvent("ARMA:TakeAmount")
AddEventHandler("ARMA:TakeAmount",function(amount)
    local source=source
    ARMA.tryBankPayment(ARMA.getUserId(source),amount)
end)