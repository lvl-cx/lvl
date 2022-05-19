-- Hot Key TP to WP
function ARMA.TpToWaypoint()
	local user_id = ARMA.getUserId({source})
	local player = ARMA.getUserSource({user_id})
	local tptowaypoint = ARMA.getUsersByPermission({"player.tptowaypoint"})
	Citizen.Trace("Send Nudes")
		if ARMA.hasPermission({user_id,"player.tptowaypoint"}) then
		Citizen.Trace("Send Nudes2")
		TriggerClientEvent("TpToWaypoint", player)
		Citizen.Trace("Send Nudes3")
	end
end

function tARMA.TpToWaypoint()
  ARMA.TpToWaypoint(source)
end