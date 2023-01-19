local bodyBags = {}

RegisterServerEvent("ARMA:requestBodyBag")
AddEventHandler('ARMA:requestBodyBag', function(playerToBodyBag)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('ARMA:placeBodyBag', playerToBodyBag)
    end
end)

RegisterServerEvent("ARMA:removeBodybag")
AddEventHandler('ARMA:removeBodybag', function(bodybagObject)
    local source = source
    local user_id = ARMA.getUserId(source)
    TriggerClientEvent('ARMA:removeIfOwned', -1, NetworkGetEntityFromNetworkId(bodybagObject))
end)

RegisterServerEvent("ARMA:playNhsSound")
AddEventHandler('ARMA:playNhsSound', function(sound)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'nhs.onduty.permission') then
        TriggerClientEvent('ARMA:clientPlayNhsSound', -1, GetEntityCoords(GetPlayerPed(source)), sound)
    else
        TriggerEvent("ARMA:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Play NHS Sound')
    end
end)


-- a = coma
-- c = userid
-- b = permid
-- 4th ready to revive
-- name

local lifePaksConnected = {}

RegisterServerEvent("ARMA:attachLifepakServer")
AddEventHandler('ARMA:attachLifepakServer', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'nhs.onduty.permission') then
        ARMAclient.getNearestPlayer(source, {3}, function(nplayer)
            local nuser_id = ARMA.getUserId(nplayer)
            if nuser_id ~= nil then
                ARMAclient.isInComa(nplayer, {}, function(in_coma)
                    TriggerClientEvent('ARMA:attachLifepak', source, in_coma, nuser_id, nplayer, GetPlayerName(nplayer))
                    lifePaksConnected[user_id] = {permid = nuser_id} 
                end)
            else
                ARMAclient.notify(source, {"~r~There is no player nearby"})
            end
        end)
    else
        TriggerEvent("ARMA:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Attack Lifepak')
    end
end)


RegisterServerEvent("ARMA:finishRevive")
AddEventHandler('ARMA:finishRevive', function(permid)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'nhs.onduty.permission') then 
        for k,v in pairs(lifePaksConnected) do
            if k == user_id and v.permid == permid then
                TriggerClientEvent('ARMA:returnRevive', source)
                ARMA.giveBankMoney(user_id, 5000)
                ARMAclient.notify(source, {"~g~You have been paid £5,000 for reviving this person."})
                lifePaksConnected[k] = nil
                Wait(15000)
                ARMAclient.RevivePlayer(ARMA.getUserSource(permid), {})
            end
        end
    else
        TriggerEvent("ARMA:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Finish Revive')
    end
end)


RegisterServerEvent("ARMA:nhsRevive") -- nhs radial revive
AddEventHandler('ARMA:nhsRevive', function(playersrc)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'nhs.onduty.permission') then
        ARMAclient.isInComa(playersrc, {}, function(in_coma)
            if in_coma then
                TriggerClientEvent('ARMA:beginRevive', source, in_coma, ARMA.getUserId(playersrc), playersrc, GetPlayerName(playersrc))
                lifePaksConnected[user_id] = {permid = ARMA.getUserId(playersrc)} 
            end
        end)
    else
        TriggerEvent("ARMA:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger NHS Revive')
    end
end)

RegisterServerEvent("ARMA:attemptCPR")
AddEventHandler('ARMA:attemptCPR', function(playersrc)
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMAclient.getNearestPlayers(source,{15},function(nplayers)
        if nplayers[playersrc] then
            if GetEntityHealth(GetPlayerPed(playersrc)) > 102 then
                ARMAclient.notify(source, {"~r~This person already healthy."})
            else
                Wait(15000)
                local cprChance = math.random(1,8)
                if cprChance == 1 then
                    ARMAclient.RevivePlayer(playersrc, {})
                    ARMAclient.notify(playersrc, {"~b~Your life has been saved."})
                    ARMAclient.notify(source, {"~b~You have saved this Person's Life."})
                else
                    ARMAclient.notify(source, {'~r~Failed to CPR.'})
                end
            end
        else
            ARMAclient.notify(source, {"~r~Player not found."})
        end
    end)
end)

RegisterServerEvent("ARMA:syncWheelchairPosition")
AddEventHandler('ARMA:syncWheelchairPosition', function(netid, coords, heading)
    local source = source
    local user_id = ARMA.getUserId(source)
    entity = NetworkGetEntityFromNetworkId(netid)
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    SetEntityHeading(entity, heading)
end)

RegisterServerEvent("ARMA:wheelchairAttachPlayer")
AddEventHandler('ARMA:wheelchairAttachPlayer', function(entity)
    local source = source
    local user_id = ARMA.getUserId(source)
    TriggerClientEvent('ARMA:wheelchairAttachPlayer', -1, entity, source)
end)