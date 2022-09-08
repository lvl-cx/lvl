local playersInOrganHeist = {}
local timeTillOrgan = 0
local inWaitingStage = false
local inGameStage = false
local policeInGame = 0
local civsInGame = 0
local cfg = module('cfg/cfg_organheist')

RegisterNetEvent("ARMA:joinOrganHeist")
AddEventHandler("ARMA:joinOrganHeist",function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if not playersInOrganHeist[user_id] then
        if inWaitingStage then
            local randomSafePosition = math.random(2)
            if ARMA.hasPermission(user_id, 'police.onduty.permission') then
                playersInOrganHeist[user_id] = {type = 'police'}
                policeInGame = policeInGame+1
                TriggerClientEvent('ARMA:addOrganHeistPlayer', -1, user_id, 'police')
                TriggerClientEvent('ARMA:teleportToOrganHeist', source, cfg.locations[1].safePositions[randomSafePosition], timeTillOrgan, 'police', 1)
            else
                playersInOrganHeist[user_id] = {type = 'civ'}
                civsInGame = civsInGame+1
                TriggerClientEvent('ARMA:addOrganHeistPlayer', -1, user_id, 'civ')
                TriggerClientEvent('ARMA:teleportToOrganHeist', source, cfg.locations[2].safePositions[randomSafePosition], timeTillOrgan, 'civ', 2)
                ARMAclient.giveWeapons(source, {{['WEAPON_M1911'] = {ammo = 250}}, false})
            end
        else
            ARMAclient.notify(source, {'~r~The organ heist has already started.'})
        end
    end
end)

RegisterNetEvent("ARMA:checkOrganHeistKill")
AddEventHandler("ARMA:checkOrganHeistKill",function(killed, killer)
    local killedID = ARMA.getUserId(killed)
    if playersInOrganHeist[killedID] then
        if killer ~= nil then
            local killerID = ARMA.getUserId(killer)
            ARMA.giveBankMoney(killerID, 25000)
            TriggerClientEvent('ARMA:organHeistKillConfirmed', killer, GetPlayerName(killed))
            playersInOrganHeist[ARMA.getUserId(killed)] = nil
            TriggerClientEvent('ARMA:removeFromOrganHeist', -1, killedID)
            TriggerClientEvent('ARMA:endOrganHeist', killed)
            ARMAclient.setDeathInOrganHeist(killed, {})
        else
            playersInOrganHeist[killedID] = nil
            TriggerClientEvent('ARMA:removeFromOrganHeist', -1, killedID)
            TriggerClientEvent('ARMA:endOrganHeist', killed)
            ARMAclient.setDeathInOrganHeist(killed, {})
        end
    end
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    local user_id = ARMA.getUserId(source)
    if playersInOrganHeist[user_id] then
        playersInOrganHeist[user_id] = nil
        TriggerClientEvent('ARMA:removeFromOrganHeist', -1, user_id)
    end
end)


local organHeistTime = 19 -- 0-23 (24 hour format)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if timeTillOrgan >0 then
            timeTillOrgan = timeTillOrgan - 1
        end
        local time = os.date("*t")
        if inGameStage then
            local policeAlive = 0
            local civAlive = 0
            for k,v in pairs(playersInOrganHeist) do
                if v.type == 'police' then
                    policeAlive = policeAlive + 1
                elseif v.type == 'civ' then
                    civAlive = civAlive +1
                end
            end
            if policeAlive == 0 then
                for k,v in pairs(playersInOrganHeist) do
                    TriggerClientEvent('ARMA:endOrganHeistWinner', ARMA.getUserSource(k), 'Civillians')
                    TriggerClientEvent('ARMA:endOrganHeist', ARMA.getUserSource(k))
                    ARMA.giveBankMoney(k, 250000)
                end
                playersInOrganHeist = {}
                inWaitingStage = false
                inGameStage = false
            elseif civAlive == 0 then
                for k,v in pairs(playersInOrganHeist) do
                    TriggerClientEvent('ARMA:endOrganHeistWinner', ARMA.getUserSource(k), 'Police')
                    TriggerClientEvent('ARMA:endOrganHeist', ARMA.getUserSource(k))
                    ARMA.giveBankMoney(k, 250000)
                end
                playersInOrganHeist = {}
                inWaitingStage = false
                inGameStage = false
            end
        end
        if tonumber(time["hour"]) == (organHeistTime-1) and tonumber(time["min"]) >= 50 and tonumber(time["sec"]) == 0 then
            inWaitingStage = true
            timeTillOrgan = ((60-tonumber(time["min"]))*60)
            TriggerClientEvent('chatMessage', -1, "^7Organ Heist starts in ^1"..(timeTillOrgan/60).." minutes.", { 128, 128, 128 }, message, "alert")
        elseif tonumber(time["hour"]) == organHeistTime and tonumber(time["mine"]) == 0 and tonumber(time["sec"]) == 0 then
            if civsInGame > 0 and policeInGame > 0 then
                TriggerClientEvent('ARMA:startOrganHeist', -1)
                inGameStage = true
            else
                for k,v in pairs(playersInOrganHeist) do
                    TriggerClientEvent('ARMA:endOrganHeist', ARMA.getUserSource(k))
                    ARMAclient.notify(ARMA.getUserSource(k), {'~r~Organ Heist was cancelled as not enough players joined.'})
                    SetEntityCoords(GetPlayerPed(ARMA.getUserSource(k)), 240.31098937988, -1379.8699951172, 33.741794586182)
                end
            end
        end
    end
end)

RegisterCommand('organheist', function(source, args, rawCommand) -- test case for organ heist
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'founder') then
        inWaitingStage = true
        timeTillOrgan = 10
        Wait(10000)
        if civsInGame > 0 and policeInGame > 0 then
            TriggerClientEvent('ARMA:startOrganHeist', -1)
            inGameStage = true
        else
            for k,v in pairs(playersInOrganHeist) do
                TriggerClientEvent('ARMA:endOrganHeist', ARMA.getUserSource(k))
                ARMAclient.notify(ARMA.getUserSource(k), {'~r~Organ Heist was cancelled as not enough players joined.'})
                SetEntityCoords(GetPlayerPed(ARMA.getUserSource(k)), 240.31098937988, -1379.8699951172, 33.741794586182)
            end
        end
    end
end)
