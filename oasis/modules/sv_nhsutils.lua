local bodyBags = {}

RegisterServerEvent("OASIS:requestBodyBag")
AddEventHandler('OASIS:requestBodyBag', function(playerToBodyBag)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('OASIS:placeBodyBag', playerToBodyBag)
    end
end)

RegisterServerEvent("OASIS:removeBodybag")
AddEventHandler('OASIS:removeBodybag', function(bodybagObject)
    local source = source
    local user_id = OASIS.getUserId(source)
    TriggerClientEvent('OASIS:removeIfOwned', -1, NetworkGetEntityFromNetworkId(bodybagObject))
end)

RegisterServerEvent("OASIS:playNhsSound")
AddEventHandler('OASIS:playNhsSound', function(sound)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('OASIS:clientPlayNhsSound', -1, GetEntityCoords(GetPlayerPed(source)), sound)
    else
        TriggerEvent("OASIS:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Play NHS Sound')
    end
end)


-- a = coma
-- c = userid
-- b = permid
-- 4th ready to revive
-- name

local lifePaksConnected = {}

RegisterServerEvent("OASIS:attachLifepakServer")
AddEventHandler('OASIS:attachLifepakServer', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'nhs.onduty.permission') then
        OASISclient.getNearestPlayer(source, {3}, function(nplayer)
            local nuser_id = OASIS.getUserId(nplayer)
            if nuser_id ~= nil then
                OASISclient.isInComa(nplayer, {}, function(in_coma)
                    TriggerClientEvent('OASIS:attachLifepak', source, in_coma, nuser_id, nplayer, GetPlayerName(nplayer))
                    lifePaksConnected[user_id] = {permid = nuser_id} 
                end)
            else
                OASISclient.notify(source, {"~r~There is no player nearby"})
            end
        end)
    else
        TriggerEvent("OASIS:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Attack Lifepak')
    end
end)


RegisterServerEvent("OASIS:finishRevive")
AddEventHandler('OASIS:finishRevive', function(permid)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'nhs.onduty.permission') then 
        for k,v in pairs(lifePaksConnected) do
            if k == user_id and v.permid == permid then
                TriggerClientEvent('OASIS:returnRevive', source)
                OASIS.giveBankMoney(user_id, 5000)
                OASISclient.notify(source, {"~g~You have been paid £5,000 for reviving this person."})
                lifePaksConnected[k] = nil
                Wait(15000)
                OASISclient.RevivePlayer(OASIS.getUserSource(permid), {})
            end
        end
    else
        TriggerEvent("OASIS:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Finish Revive')
    end
end)


RegisterServerEvent("OASIS:nhsRevive") -- nhs radial revive
AddEventHandler('OASIS:nhsRevive', function(playersrc)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'nhs.onduty.permission') then
        OASISclient.isInComa(playersrc, {}, function(in_coma)
            if in_coma then
                TriggerClientEvent('OASIS:beginRevive', source, in_coma, OASIS.getUserId(playersrc), playersrc, GetPlayerName(playersrc))
                lifePaksConnected[user_id] = {permid = OASIS.getUserId(playersrc)} 
            end
        end)
    else
        TriggerEvent("OASIS:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger NHS Revive')
    end
end)

local playersInCPR = {}
RegisterServerEvent("OASIS:attemptCPR")
AddEventHandler('OASIS:attemptCPR', function(playersrc)
    local source = source
    local user_id = OASIS.getUserId(source)
    OASISclient.getNearestPlayers(source,{15},function(nplayers)
        if nplayers[playersrc] then
            if GetEntityHealth(GetPlayerPed(playersrc)) > 102 then
                OASISclient.notify(source, {"~r~This person already healthy."})
            else
                playersInCPR[user_id] = true
                TriggerClientEvent('OASIS:attemptCPR', source)
                Wait(15000)
                if playersInCPR[user_id] then
                    local cprChance = math.random(1,5)
                    if cprChance == 1 then
                        OASISclient.RevivePlayer(playersrc, {})
                        OASISclient.notify(playersrc, {"~b~Your life has been saved."})
                        OASISclient.notify(source, {"~b~You have saved this Person's Life."})
                    else
                        OASISclient.notify(source, {'~r~Failed to CPR.'})
                    end
                    playersInCPR[user_id] = nil
                    TriggerClientEvent('OASIS:cancelCPRAttempt', source)
                end
            end
        else
            OASISclient.notify(source, {"~r~Player not found."})
        end
    end)
end)

RegisterServerEvent("OASIS:cancelCPRAttempt")
AddEventHandler('OASIS:cancelCPRAttempt', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if playersInCPR[user_id] then
        playersInCPR[user_id] = nil
        TriggerClientEvent('OASIS:cancelCPRAttempt', source)
    end
end)

RegisterServerEvent("OASIS:syncWheelchairPosition")
AddEventHandler('OASIS:syncWheelchairPosition', function(netid, coords, heading)
    local source = source
    local user_id = OASIS.getUserId(source)
    entity = NetworkGetEntityFromNetworkId(netid)
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    SetEntityHeading(entity, heading)
end)

RegisterServerEvent("OASIS:wheelchairAttachPlayer")
AddEventHandler('OASIS:wheelchairAttachPlayer', function(entity)
    local source = source
    local user_id = OASIS.getUserId(source)
    TriggerClientEvent('OASIS:wheelchairAttachPlayer', -1, entity, source)
end)