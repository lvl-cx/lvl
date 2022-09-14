RegisterServerEvent("ARMA:newPanic")
AddEventHandler("ARMA:newPanic", function(a,b)
	local source = source
	local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') or ARMA.hasPermission(user_id, 'nhs.onduty.permission') or ARMA.hasPermission(user_id, 'lfb.onduty.permission') then
        TriggerClientEvent("ARMA:returnPanic", -1, nil, a, b)
    end
end)