-- Hot Key TP to WP
function ATM.TpToWaypoint()
	local user_id = ATM.getUserId({source})
	local player = ATM.getUserSource({user_id})
	local tptowaypoint = ATM.getUsersByPermission({"player.tptowaypoint"})
	Citizen.Trace("Send Nudes")
		if ATM.hasPermission({user_id,"player.tptowaypoint"}) then
		Citizen.Trace("Send Nudes2")
		TriggerClientEvent("TpToWaypoint", player)
		Citizen.Trace("Send Nudes3")
	end
end

function tATM.TpToWaypoint()
  ATM.TpToWaypoint(source)
end