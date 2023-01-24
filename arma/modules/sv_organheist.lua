local playersInOrganHeist = {}
local timeTillOrgan = 0
local inWaitingStage = false
local inGamePhase = false
local policeInGame = 0
local civsInGame = 0
local cfg = module('cfg/cfg_organheist')


RegisterNetEvent("ARMA:joinOrganHeist")
AddEventHandler("ARMA:joinOrganHeist",function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if not playersInOrganHeist[user_id] then
        if inWaitingStage then
            if ARMA.hasPermission(user_id, 'police.onduty.permission') then
                playersInOrganHeist[user_id] = {type = 'police'}
                policeInGame = policeInGame+1
                TriggerClientEvent('ARMA:addOrganHeistPlayer', -1, user_id, 'police')
                TriggerClientEvent('ARMA:teleportToOrganHeist', source, cfg.locations[1].safePositions[math.random(2)], timeTillOrgan, 'police', 1)
            elseif ARMA.hasPermission(user_id, 'nhs.onduty.permission') then
                ARMAclient.notify(source, {'~r~You cannot enter Organ Heist whilst clocked on NHS.'})
            else
                playersInOrganHeist[user_id] = {type = 'civ'}
                civsInGame = civsInGame+1
                TriggerClientEvent('ARMA:addOrganHeistPlayer', -1, user_id, 'civ')
                TriggerClientEvent('ARMA:teleportToOrganHeist', source, cfg.locations[2].safePositions[math.random(2)], timeTillOrgan, 'civ', 2)
                ARMAclient.giveWeapons(source, {{['WEAPON_ROOK'] = {ammo = 250}}, false})
            end
            tARMA.setBucket(source, 15)
            ARMAclient.setArmour(source, {100, true})
        else
            ARMAclient.notify(source, {'~r~The organ heist has already started.'})
        end
    end
end)

RegisterNetEvent("ARMA:diedInOrganHeist")
AddEventHandler("ARMA:diedInOrganHeist",function(killer)
    local source = source
    local user_id = ARMA.getUserId(source)
    local killerID = ARMA.getUserId(killer)
    if playersInOrganHeist[user_id] then
        if ARMA.getUserId(killer) ~= nil then
            ARMA.giveBankMoney(killerID, 25000)
            TriggerClientEvent('ARMA:organHeistKillConfirmed', killer, GetPlayerName(source))
        end
        TriggerClientEvent('ARMA:endOrganHeist', source)
        TriggerClientEvent('ARMA:removeFromOrganHeist', -1, killedID)
        tARMA.setBucket(source, 0)
        playersInOrganHeist[killedID] = nil
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


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local time = os.date("*t")
        if inGamePhase then
            local policeAlive = 0
            local civAlive = 0
            for k,v in pairs(playersInOrganHeist) do
                if v.type == 'police' then
                    policeAlive = policeAlive + 1
                elseif v.type == 'civ' then
                    civAlive = civAlive +1
                end
            end
            if policeAlive == 0 or civAlive == 0 then
                for k,v in pairs(playersInOrganHeist) do
                    if policeAlive == 0 then
                        TriggerClientEvent('ARMA:endOrganHeistWinner', ARMA.getUserSource(k), 'Civillians')
                    elseif civAlive == 0 then
                        TriggerClientEvent('ARMA:endOrganHeistWinner', ARMA.getUserSource(k), 'Police')
                    end
                    TriggerClientEvent('ARMA:endOrganHeist', ARMA.getUserSource(k))
                    tARMA.setBucket(ARMA.getUserSource(k), 0)
                    ARMA.giveBankMoney(k, 250000)
                end
                playersInOrganHeist = {}
                inWaitingStage = false
                inGamePhase = false
            end
        else
            if timeTillOrgan > 0 then
                timeTillOrgan = timeTillOrgan - 1
            end
            if tonumber(time["hour"]) == 20 and tonumber(time["min"]) >= 20 and tonumber(time["sec"]) == 0 then
                inWaitingStage = true
                timeTillOrgan = ((30-tonumber(time["min"]))*60)
                TriggerClientEvent('chatMessage', -1, "^7Organ Heist starts in ^1"..math.floor((timeTillOrgan/60)).." minutes.", { 128, 128, 128 }, message, "alert")
            elseif tonumber(time["hour"]) == 20 and tonumber(time["min"]) == 30 and tonumber(time["sec"]) == 0 then
                if civsInGame > 0 and policeInGame > 0 then
                    TriggerClientEvent('ARMA:startOrganHeist', -1)
                    inGamePhase = true
                    inWaitingStage = false
                else
                    for k,v in pairs(playersInOrganHeist) do
                        TriggerClientEvent('ARMA:endOrganHeist', ARMA.getUserSource(k))
                        ARMAclient.notify(ARMA.getUserSource(k), {'~r~Organ Heist was cancelled as not enough players joined.'})
                        SetEntityCoords(GetPlayerPed(ARMA.getUserSource(k)), 240.31098937988, -1379.8699951172, 33.741794586182)
                        tARMA.setBucket(ARMA.getUserSource(k), 0)
                    end
                end
            end
        end
    end
end)