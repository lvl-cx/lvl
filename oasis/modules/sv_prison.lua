MySQL.createCommand("OASIS/get_prison_time","SELECT prison_time FROM oasis_prison WHERE user_id = @user_id")
MySQL.createCommand("OASIS/set_prison_time","UPDATE oasis_prison SET prison_time = @prison_time WHERE user_id = @user_id")
MySQL.createCommand("OASIS/add_prisoner", "INSERT IGNORE INTO oasis_prison SET user_id = @user_id")
MySQL.createCommand("OASIS/get_current_prisoners", "SELECT * FROM oasis_prison WHERE prison_time > 0")

local cfg = module("cfg/cfg_prison")
local prisonItems = {"toothbrush", "blade", "rope", "metal_rod", "spring"}

local lastCellUsed = 0

AddEventHandler("playerJoining", function()
    local user_id = OASIS.getUserId(source)
    MySQL.execute("OASIS/add_prisoner", {user_id = user_id})
end)

AddEventHandler("OASIS:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        MySQL.query("OASIS/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 0 then
                    if lastCellUsed == 27 then
                        lastCellUsed = 0
                    end
                    TriggerClientEvent('OASIS:putInPrisonOnSpawn', source, lastCellUsed+1)
                    TriggerClientEvent('OASIS:forcePlayerInPrison', source, true)
                    TriggerClientEvent('OASIS:prisonCreateBreakOutAreas', source)
                    TriggerClientEvent('OASIS:prisonUpdateClientTimer', source, prisontime[1].prison_time)
                    local prisonItemsTable = {}
                    for k,v in pairs(cfg.prisonItems) do
                        local item = math.random(1, #prisonItems)
                        prisonItemsTable[prisonItems[item]] = v
                    end
                    TriggerClientEvent('OASIS:prisonCreateItemAreas', source, prisonItemsTable)
                end
            end
        end)
    end
end)

RegisterNetEvent("OASIS:getNumOfNHSOnline")
AddEventHandler("OASIS:getNumOfNHSOnline", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    MySQL.query("OASIS/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                TriggerClientEvent('OASIS:prisonSpawnInMedicalBay', source)
                OASISclient.RevivePlayer(source, {})
            else
                TriggerClientEvent('OASIS:getNumberOfDocsOnline', source, #OASIS.getUsersByPermission('nhs.onduty.permission'))
            end
        end
    end)
end)

RegisterServerEvent("OASIS:prisonArrivedForJail")
AddEventHandler("OASIS:prisonArrivedForJail", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    MySQL.query("OASIS/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                tOASIS.setBucket(source, 0)
                TriggerClientEvent('OASIS:forcePlayerInPrison', source, true)
                TriggerClientEvent('OASIS:prisonCreateBreakOutAreas', source)
                TriggerClientEvent('OASIS:prisonUpdateClientTimer', source, prisontime[1].prison_time)
            end
        end
    end)
end)

local prisonPlayerJobs = {}

RegisterServerEvent("OASIS:prisonStartJob")
AddEventHandler("OASIS:prisonStartJob", function(job)
    local source = source
    local user_id = OASIS.getUserId(source)
    prisonPlayerJobs[user_id] = job
end)

RegisterServerEvent("OASIS:prisonEndJob")
AddEventHandler("OASIS:prisonEndJob", function(job)
    local source = source
    local user_id = OASIS.getUserId(source)
    if prisonPlayerJobs[user_id] == job then
        prisonPlayerJobs[user_id] = nil
        MySQL.query("OASIS/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 21 then
                    MySQL.execute("OASIS/set_prison_time", {user_id = user_id, prison_time = prisontime[1].prison_time - 20})
                    TriggerClientEvent('OASIS:prisonUpdateClientTimer', source, prisontime[1].prison_time - 20)
                    OASISclient.notify(source, {"~g~Prison time reduced by 20s."})
                end
            end
        end)
    end
end)

RegisterServerEvent("OASIS:jailPlayer")
AddEventHandler("OASIS:jailPlayer", function(player)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') then
        OASISclient.getNearestPlayers(source,{15},function(nplayers)
            if nplayers[player] then
                OASISclient.isHandcuffed(player,{}, function(handcuffed)  -- check handcuffed
                    if handcuffed then
                        -- check for gc in cfg 
                        MySQL.query("OASIS/get_prison_time", {user_id = OASIS.getUserId(player)}, function(prisontime)
                            if prisontime ~= nil then 
                                if prisontime[1].prison_time == 0 then
                                    OASIS.prompt(source,"Jail Time (in minutes):","",function(source,jailtime) 
                                        local jailtime = math.floor(tonumber(jailtime) * 60)
                                        if jailtime > 0 and jailtime <= cfg.maxTimeNotGc then
                                            -- check if gc then compare jailtime to 
                                            -- maxTimeGc = 7200,
                                            MySQL.execute("OASIS/set_prison_time", {user_id = OASIS.getUserId(player), prison_time = jailtime})
                                            if lastCellUsed == 27 then
                                                lastCellUsed = 0
                                            end
                                            TriggerClientEvent('OASIS:prisonTransportWithBus', player, lastCellUsed+1)
                                            tOASIS.setBucket(player, lastCellUsed+1)
                                            local prisonItemsTable = {}
                                            for k,v in pairs(cfg.prisonItems) do
                                                local item = math.random(1, #prisonItems)
                                                prisonItemsTable[prisonItems[item]] = v
                                            end
                                            TriggerClientEvent('OASIS:prisonCreateItemAreas', player, prisonItemsTable)
                                            OASISclient.notify(source, {"~g~Jailed Player."})
                                            tOASIS.sendWebhook('jail-player', 'OASIS Jail Logs',"> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Criminal Name: **"..GetPlayerName(player).."**\n> Criminal PermID: **"..OASIS.getUserId(player).."**\n> Criminal TempID: **"..player.."**\n> Duration: **"..math.floor(jailtime/60).." minutes**")
                                        else
                                            OASISclient.notify(source, {"~r~Invalid time."})
                                        end
                                    end)
                                else
                                    OASISclient.notify(source, {"~r~Player is already in prison."})
                                end
                            end
                        end)
                    else
                        OASISclient.notify(source, {"~r~You must have the player handcuffed."})
                    end
                end)
            else
                OASISclient.notify(source, {"~r~Player not found."})
            end
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        MySQL.query("OASIS/get_current_prisoners", {}, function(currentPrisoners)
            if #currentPrisoners > 0 then 
                for k,v in pairs(currentPrisoners) do
                    MySQL.execute("OASIS/set_prison_time", {user_id = v.user_id, prison_time = v.prison_time-1})
                    if v.prison_time-1 == 0 and OASIS.getUserSource(v.user_id) ~= nil then
                        TriggerClientEvent('OASIS:prisonStopClientTimer', OASIS.getUserSource(v.user_id))
                        TriggerClientEvent('OASIS:prisonReleased', OASIS.getUserSource(v.user_id))
                        TriggerClientEvent('OASIS:forcePlayerInPrison', OASIS.getUserSource(v.user_id), false)
                        OASISclient.setHandcuffed(OASIS.getUserSource(v.user_id), {false})
                    end
                end
            end
        end)
        Citizen.Wait(1000)
    end
end)

RegisterCommand('unjail', function(source)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'admin.noclip') then
        OASIS.prompt(source,"Enter Temp ID:","",function(source, player) 
            local player = tonumber(player)
            if player ~= nil then
                MySQL.execute("OASIS/set_prison_time", {user_id = OASIS.getUserId(player), prison_time = 0})
                TriggerClientEvent('OASIS:prisonStopClientTimer', player)
                TriggerClientEvent('OASIS:prisonReleased', player)
                TriggerClientEvent('OASIS:forcePlayerInPrison', player, false)
                OASISclient.setHandcuffed(player, {false})
                OASISclient.notify(source, {"~g~Target will be released soon."})
            else
                OASISclient.notify(source, {"~r~Invalid ID."})
            end
        end)
    end
end)


AddEventHandler("OASIS:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent('OASIS:prisonUpdateGuardNumber', -1, #OASIS.getUsersByPermission('prisonguard.onduty.permission'))
    end
end)

local currentLockdown = false
RegisterServerEvent("OASIS:prisonToggleLockdown")
AddEventHandler("OASIS:prisonToggleLockdown", function(lockdownState)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'dev.menu') then -- change this to the hmp hq permission
        currentLockdown = lockdownState
        if currentLockdown then
            TriggerClientEvent('OASIS:prisonSetAllDoorStates', -1, 1)
        else
            TriggerClientEvent('OASIS:prisonSetAllDoorStates', -1)
        end
    end
end)

RegisterServerEvent("OASIS:prisonSetDoorState")
AddEventHandler("OASIS:prisonSetDoorState", function(doorHash, state)
    local source = source
    local user_id = OASIS.getUserId(source)
    TriggerClientEvent('OASIS:prisonSyncDoor', -1, doorHash, state)
end)

RegisterServerEvent("OASIS:enterPrisonAreaSyncDoors")
AddEventHandler("OASIS:enterPrisonAreaSyncDoors", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    TriggerClientEvent('OASIS:prisonAreaSyncDoors', source, doors)
end)

-- on pickup 
-- OASIS:prisonRemoveItemAreas(item)

-- hmp should be able to see all prisoners
-- OASIS:requestPrisonerData