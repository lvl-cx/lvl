local playersInOrganHeist = {}
local timeTillOrgan = 0
local inWaitingStage = false
local inGamePhase = false
local policeInGame = 0
local civsInGame = 0
local cfg = module('cfg/cfg_organheist')


RegisterNetEvent("OASIS:joinOrganHeist")
AddEventHandler("OASIS:joinOrganHeist",function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if not playersInOrganHeist[user_id] then
        if inWaitingStage then
            if OASIS.hasPermission(user_id, 'police.onduty.permission') then
                playersInOrganHeist[source] = {type = 'police'}
                policeInGame = policeInGame+1
                TriggerClientEvent('OASIS:addOrganHeistPlayer', -1, source, 'police')
                TriggerClientEvent('OASIS:teleportToOrganHeist', source, cfg.locations[1].safePositions[math.random(2)], timeTillOrgan, 'police', 1)
            elseif OASIS.hasPermission(user_id, 'nhs.onduty.permission') then
                OASISclient.notify(source, {'~r~You cannot enter Organ Heist whilst clocked on NHS.'})
            else
                playersInOrganHeist[source] = {type = 'civ'}
                civsInGame = civsInGame+1
                TriggerClientEvent('OASIS:addOrganHeistPlayer', -1, source, 'civ')
                TriggerClientEvent('OASIS:teleportToOrganHeist', source, cfg.locations[2].safePositions[math.random(2)], timeTillOrgan, 'civ', 2)
                OASISclient.giveWeapons(source, {{['WEAPON_ROOK'] = {ammo = 250}}, false})
            end
            tOASIS.setBucket(source, 15)
            OASISclient.setArmour(source, {100, true})
        else
            OASISclient.notify(source, {'~r~The organ heist has already started.'})
        end
    end
end)

RegisterNetEvent("OASIS:diedInOrganHeist")
AddEventHandler("OASIS:diedInOrganHeist",function(killer)
    local source = source
    if playersInOrganHeist[source] then
        if OASIS.getUserId(killer) ~= nil then
            local killerID = OASIS.getUserId(killer)
            OASIS.giveBankMoney(killerID, 25000)
            TriggerClientEvent('OASIS:organHeistKillConfirmed', killer, GetPlayerName(source))
        end
        TriggerClientEvent('OASIS:endOrganHeist', source)
        TriggerClientEvent('OASIS:removeFromOrganHeist', -1, source)
        tOASIS.setBucket(source, 0)
        playersInOrganHeist[source] = nil
    end
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    if playersInOrganHeist[source] then
        playersInOrganHeist[source] = nil
        TriggerClientEvent('OASIS:removeFromOrganHeist', -1, source)
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
                        TriggerClientEvent('OASIS:endOrganHeistWinner', k, 'Civillians')
                    elseif civAlive == 0 then
                        TriggerClientEvent('OASIS:endOrganHeistWinner', k, 'Police')
                    end
                    TriggerClientEvent('OASIS:endOrganHeist', k)
                    tOASIS.setBucket(k, 0)
                    OASIS.giveBankMoney(OASIS.getUserId(k), 250000)
                end
                playersInOrganHeist = {}
                inWaitingStage = false
                inGamePhase = false
            end
        else
            if timeTillOrgan > 0 then
                timeTillOrgan = timeTillOrgan - 1
            end
            if tonumber(time["hour"]) == 18 and tonumber(time["min"]) >= 50 and tonumber(time["sec"]) == 0 then
                inWaitingStage = true
                timeTillOrgan = ((60-tonumber(time["min"]))*60)
                TriggerClientEvent('chatMessage', -1, "^7Organ Heist starts in ^1"..math.floor((timeTillOrgan/60)).." minutes.", { 128, 128, 128 }, message, "alert")
            elseif tonumber(time["hour"]) == 19 and tonumber(time["min"]) == 0 and tonumber(time["sec"]) == 0 then
                if civsInGame > 0 and policeInGame > 0 then
                    TriggerClientEvent('OASIS:startOrganHeist', -1)
                    inGamePhase = true
                    inWaitingStage = false
                else
                    for k,v in pairs(playersInOrganHeist) do
                        TriggerClientEvent('OASIS:endOrganHeist', k)
                        OASISclient.notify(k, {'~r~Organ Heist was cancelled as not enough players joined.'})
                        SetEntityCoords(GetPlayerPed(k), 240.31098937988, -1379.8699951172, 33.741794586182)
                        tOASIS.setBucket(k, 0)
                    end
                end
            end
        end
    end
end)