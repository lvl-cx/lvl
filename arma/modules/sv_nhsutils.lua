local netObjects = {}

RegisterServerEvent("ARMA:requestBodyBag")
AddEventHandler('ARMA:requestBodyBag', function(playerToBodyBag)
    local source = source
    netObjects[playerToBodyBag] = {source = source, id = ARMA.getUserId(source)}
end)

RegisterServerEvent("ARMA:removeBodybag")
AddEventHandler('ARMA:removeBodybag', function(oldBodyBag)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.tickets') then
        for k,v in pairs(netObjects) do
            if v.source == source and k == oldBodyBag then
                netObjects[k] = nil
                TriggerClientEvent('ARMA:removeIfOwned', source, oldBodyBag)
            end
        end
    else
        TriggerEvent("ARMA:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Remove Bodybag')
    end
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
        ARMAclient.getNearestPlayer(source, {10}, function(nplayer)
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
                lifePaksConnected[k] = nil
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
        for k,v in pairs(lifePaksConnected) do
            if k == user_id and ARMA.getUserSource(v.permid) == playersrc then
                ARMAclient.isInComa(nplayer, {}, function(in_coma)
                    TriggerClientEvent('ARMA:beginRevive', source, in_coma, ARMA.getUserId(playersrc), playersrc, GetPlayerName(playersrc))
                    lifePaksConnected[user_id] = {permid = ARMA.getUserId(playersrc)} 
                end)
            end
        end
    else
        TriggerEvent("ARMA:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger NHS Revive')
    end
end)

RegisterServerEvent("ARMA:attemptCPR") -- cpr on radial
AddEventHandler('ARMA:attemptCPR', function(playersrc)
    local source = source
    local user_id = ARMA.getUserId(source)
    local cprChance = math.random(1,8)
    ARMAclient.getNearestPlayer(source, {10}, function(nplayer)
        local nuser_id = ARMA.getUserId(nplayer)
        if nuser_id ~= nil then
            ARMAclient.isInComa(nplayer, {}, function(in_coma)
                if in_coma then
                    if cprChance == math.random(1,8) then
                        ARMAclient.RevivePlayer(nplayer, {})
                    else
                        ARMAclient.notify(source, {'~r~Failed to CPR.'})
                    end
                else
                    ARMAclient.notify(source, {'~r~This player is already healthy.'})
                end
            end)
        else
            ARMAclient.notify(source, {"~r~There is no player nearby"})
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




