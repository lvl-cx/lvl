RegisterServerEvent("ARMA:alertNoProps")
AddEventHandler("ARMA:alertNoProps", function(a,b,c,d,e)
	local source = source
	local user_id = ARMA.getUserId(source)
    if tonumber(user_id) == 1 or tonumber(user_id) == 2 then return end
	DropPlayer(source, "No props was detected. Remove the pack to join.")
	local webhook = "https://discord.com/api/webhooks/1047298764974588026/IZIqbvTBgtUOLaVikrnUH-4pwqt211SS29w6_XkVdf5kmWQnEd1t-u1qONTFKfwBWrtd"
	local embed = {
		{
		["color"] = "16448403",
		["title"] = "No Prop Logs",
		["description"] = "",
		["text"] = "ARMA Server #1",
		["fields"] = {
			{
				["name"] = "Player Name",
				["value"] = GetPlayerName(source),
				["inline"] = true
			},
			{
				["name"] = "Player Perm ID",
				["value"] = user_id,
				["inline"] = true
			},
			{
				["name"] = "Player Temp ID",
				["value"] = source,
				["inline"] = true
			},
			{
				["name"] = "Prop Information",
				["value"] = a,b,c,d,e,
				["inline"] = true
			},
		}
		}
	}
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = embed}), { ['Content-Type'] = 'application/json' })
end)