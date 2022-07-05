RegisterServerEvent("ARMA:alertNoProps")
AddEventHandler("ARMA:alertNoProps", function(a,b,c,d,e)
	local source = source
	local user_id = ARMA.getUserId(source)
    if tonumber(user_id) == 1 or tonumber(user_id) == 2 then return end
	ARMA.kick(source, "No props was detected. Remove the pack to join.")
end)