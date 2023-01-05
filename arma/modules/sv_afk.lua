function getPlayerFaction(user_id)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
        return 'pd'
    elseif ARMA.hasPermission(user_id, 'nhs.onduty.permission') then
        return 'nhs'
    elseif ARMA.hasPermission(user_id, 'hmp.onduty.permission') then
        return 'hmp'
    elseif ARMA.hasPermission(user_id, 'lfb.onduty.permission') then
        return 'lfb'
    end
    return nil
end

RegisterServerEvent('ARMA:factionAfkAlert')
AddEventHandler('ARMA:factionAfkAlert', function(text)
    local source = source
    local user_id = ARMA.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        tARMA.sendWebhook(getPlayerFaction(user_id)..'-afk', 'ARMA AFK Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('ARMA:setNoLongerAFK')
AddEventHandler('ARMA:setNoLongerAFK', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        tARMA.sendWebhook(getPlayerFaction(user_id)..'-afk', 'ARMA AFK Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('kick:AFK')
AddEventHandler('kick:AFK', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if not ARMA.hasPermission(user_id, 'group.add') then
        DropPlayer(source, 'You have been kicked for being AFK for too long.')
    end
end)