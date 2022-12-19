MySQL.createCommand("ARMA/get_prison_time","SELECT prison_time FROM arma_prison WHERE user_id = @user_id")
MySQL.createCommand("ARMA/set_prison_time","UPDATE arma_prison SET prison_time = @prison_time WHERE user_id = @user_id")
MySQL.createCommand("ARMA/add_prisoner", "INSERT IGNORE INTO arma_prison SET user_id = @user_id")
MySQL.createCommand("ARMA/get_current_prisoners", "SELECT * FROM arma_prison WHERE prison_time > 0")

local cfg = module("cfg/cfg_prison")
local prisonItems = {"toothbrush", "blade", "rope", "metal_rod", "spring"}

local lastCellUsed = 0

AddEventHandler("playerJoining", function()
    local user_id = ARMA.getUserId(source)
    MySQL.execute("ARMA/add_prisoner", {user_id = user_id})
end)

AddEventHandler("ARMA:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        MySQL.query("ARMA/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 0 then
                    if lastCellUsed == 27 then
                        lastCellUsed = 0
                    end
                    TriggerClientEvent('ARMA:putInPrisonOnSpawn', source, lastCellUsed+1)
                    TriggerClientEvent('ARMA:forcePlayerInPrison', source, true)
                    TriggerClientEvent('ARMA:prisonCreateBreakOutAreas', source)
                    TriggerClientEvent('ARMA:prisonUpdateClientTimer', source, prisontime[1].prison_time)
                    local prisonItemsTable = {}
                    for k,v in pairs(cfg.prisonItems) do
                        local item = math.random(1, #prisonItems)
                        prisonItemsTable[prisonItems[item]] = v
                    end
                    TriggerClientEvent('ARMA:prisonCreateItemAreas', source, prisonItemsTable)
                end
            end
        end)
    end
end)

RegisterNetEvent("ARMA:getNumOfNHSOnline")
AddEventHandler("ARMA:getNumOfNHSOnline", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    MySQL.query("ARMA/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                TriggerClientEvent('ARMA:prisonSpawnInMedicalBay', source)
                ARMAclient.RevivePlayer(source, {})
            else
                TriggerClientEvent('ARMA:getNumberOfDocsOnline', source, #ARMA.getUsersByPermission('nhs.onduty.permission'))
            end
        end
    end)
end)

RegisterServerEvent("ARMA:prisonArrivedForJail")
AddEventHandler("ARMA:prisonArrivedForJail", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    MySQL.query("ARMA/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                SetPlayerRoutingBucket(source, 0)
                TriggerClientEvent('ARMA:forcePlayerInPrison', source, true)
                TriggerClientEvent('ARMA:prisonCreateBreakOutAreas', source)
                TriggerClientEvent('ARMA:prisonUpdateClientTimer', source, prisontime[1].prison_time)
            end
        end
    end)
end)

local prisonPlayerJobs = {}

RegisterServerEvent("ARMA:prisonStartJob")
AddEventHandler("ARMA:prisonStartJob", function(job)
    local source = source
    local user_id = ARMA.getUserId(source)
    prisonPlayerJobs[user_id] = job
end)

RegisterServerEvent("ARMA:prisonEndJob")
AddEventHandler("ARMA:prisonEndJob", function(job)
    local source = source
    local user_id = ARMA.getUserId(source)
    if prisonPlayerJobs[user_id] == job then
        prisonPlayerJobs[user_id] = nil
        MySQL.query("ARMA/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 21 then
                    MySQL.execute("ARMA/set_prison_time", {user_id = user_id, prison_time = prisontime[1].prison_time - 20})
                    TriggerClientEvent('ARMA:prisonUpdateClientTimer', source, prisontime[1].prison_time - 20)
                    ARMAclient.notify(source, {"~g~Prison time reduced by 20s."})
                end
            end
        end)
    end
end)

RegisterServerEvent("ARMA:jailPlayer")
AddEventHandler("ARMA:jailPlayer", function(player)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
        ARMAclient.getNearestPlayers(source,{15},function(nplayers)
            if nplayers[player] then
                ARMAclient.isHandcuffed(player,{}, function(handcuffed)  -- check handcuffed
                    if handcuffed then
                        -- check for gc in cfg 
                        MySQL.query("ARMA/get_prison_time", {user_id = ARMA.getUserId(player)}, function(prisontime)
                            if prisontime ~= nil then 
                                if prisontime[1].prison_time == 0 then
                                    ARMA.prompt(source,"Jail Time (in minutes):","",function(source,jailtime) 
                                        local jailtime = math.floor(tonumber(jailtime) * 60)
                                        if jailtime > 0 and jailtime <= cfg.maxTimeNotGc then
                                            -- check if gc then compare jailtime to 
                                            -- maxTimeGc = 7200,
                                            MySQL.execute("ARMA/set_prison_time", {user_id = ARMA.getUserId(player), prison_time = jailtime})
                                            if lastCellUsed == 27 then
                                                lastCellUsed = 0
                                            end
                                            TriggerClientEvent('ARMA:prisonTransportWithBus', player, lastCellUsed+1)
                                            SetPlayerRoutingBucket(player, lastCellUsed+1)
                                            local prisonItemsTable = {}
                                            for k,v in pairs(cfg.prisonItems) do
                                                local item = math.random(1, #prisonItems)
                                                prisonItemsTable[prisonItems[item]] = v
                                            end
                                            TriggerClientEvent('ARMA:prisonCreateItemAreas', player, prisonItemsTable)
                                            ARMAclient.notify(source, {"~g~Jailed Player."})
                                        else
                                            ARMAclient.notify(source, {"~r~Invalid time."})
                                        end
                                    end)
                                else
                                    ARMAclient.notify(source, {"~r~Player is already in prison."})
                                end
                            end
                        end)
                    else
                        ARMAclient.notify(source, {"~r~You must have the player handcuffed."})
                    end
                end)
            else
                ARMAclient.notify(source, {"~r~Player not found."})
            end
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        MySQL.query("ARMA/get_current_prisoners", {}, function(currentPrisoners)
            if #currentPrisoners > 0 then 
                for k,v in pairs(currentPrisoners) do
                    MySQL.execute("ARMA/set_prison_time", {user_id = v.user_id, prison_time = v.prison_time-1})
                    if v.prison_time-1 == 0 and ARMA.getUserSource(v.user_id) ~= nil then
                        TriggerClientEvent('ARMA:prisonStopClientTimer', ARMA.getUserSource(v.user_id))
                        TriggerClientEvent('ARMA:prisonReleased', ARMA.getUserSource(v.user_id))
                        TriggerClientEvent('ARMA:forcePlayerInPrison', ARMA.getUserSource(v.user_id), false)
                    end
                end
            end
        end)
        Citizen.Wait(1000)
    end
end)

-- on pickup 
-- ARMA:prisonRemoveItemAreas(item)

-- hmp should be able to see all prisoners
-- ARMA:requestPrisonerData