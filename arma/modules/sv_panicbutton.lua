RegisterServerEvent("ARMA:newPanic")
AddEventHandler("ARMA:newPanic", function(a,b)
	local source = source
	local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') or ARMA.hasPermission(user_id, 'nhs.onduty.permission') or ARMA.hasPermission(user_id, 'lfb.onduty.permission') then
        TriggerClientEvent("ARMA:returnPanic", -1, nil, a, b)
        tARMA.sendWebhook(getPlayerFaction(user_id)..'-panic', 'ARMA Panic Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Coords: **"..a.Coords.."**\n> Location: **"..a.Location.."**")
    end
end)