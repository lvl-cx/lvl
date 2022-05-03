-- Hot Key TP to WP
function LVL.TpToWaypoint()
	local user_id = LVL.getUserId({source})
	local player = LVL.getUserSource({user_id})
	local tptowaypoint = LVL.getUsersByPermission({"player.tptowaypoint"})
	Citizen.Trace("Send Nudes")
		if LVL.hasPermission({user_id,"player.tptowaypoint"}) then
		Citizen.Trace("Send Nudes2")
		TriggerClientEvent("TpToWaypoint", player)
		Citizen.Trace("Send Nudes3")
	end
end

function tLVL.TpToWaypoint()
  LVL.TpToWaypoint(source)
end