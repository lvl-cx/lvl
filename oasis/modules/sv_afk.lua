function getPlayerFaction(user_id)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') then
        return 'pd'
    elseif OASIS.hasPermission(user_id, 'nhs.onduty.permission') then
        return 'nhs'
    elseif OASIS.hasPermission(user_id, 'hmp.onduty.permission') then
        return 'hmp'
    elseif OASIS.hasPermission(user_id, 'lfb.onduty.permission') then
        return 'lfb'
    end
    return nil
end

RegisterServerEvent('OASIS:factionAfkAlert')
AddEventHandler('OASIS:factionAfkAlert', function(text)
    local source = source
    local user_id = OASIS.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        tOASIS.sendWebhook(getPlayerFaction(user_id)..'-afk', 'OASIS AFK Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('OASIS:setNoLongerAFK')
AddEventHandler('OASIS:setNoLongerAFK', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        tOASIS.sendWebhook(getPlayerFaction(user_id)..'-afk', 'OASIS AFK Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('kick:AFK')
AddEventHandler('kick:AFK', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if not OASIS.hasPermission(user_id, 'group.add') then
        DropPlayer(source, 'You have been kicked for being AFK for too long.')
    end
end)