-- Hot Key TP to WP
function Sentry.TpToWaypoint()
	local user_id = Sentry.getUserId({source})
	local player = Sentry.getUserSource({user_id})
	local tptowaypoint = Sentry.getUsersByPermission({"player.tptowaypoint"})
	Citizen.Trace("Send Nudes")
		if Sentry.hasPermission({user_id,"player.tptowaypoint"}) then
		Citizen.Trace("Send Nudes2")
		TriggerClientEvent("TpToWaypoint", player)
		Citizen.Trace("Send Nudes3")
	end
end

function tSentry.TpToWaypoint()
  Sentry.TpToWaypoint(source)
end