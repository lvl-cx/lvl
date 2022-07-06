local a = 0

SetDiscordAppId(970724996223746149)

Citizen.CreateThread(function()
	while true do
		SetDiscordRichPresenceAsset('mainlogo') 
		SetDiscordRichPresenceAssetText("discord.gg/armarp") 
		SetDiscordRichPresenceAssetSmall('mainlogo') -- Name of the smaller image asset.
		SetDiscordRichPresenceAssetSmallText('ARMA')
		while (a == 0 ) do
			SetRichPresence("[ID:fetching...] | " ..#GetActivePlayers().. "/" .. "64" .. " Players") 
			Wait(0)
		end
		SetRichPresence("[ID:"..a.."] | " ..#GetActivePlayers().. "/" .. "64" .. " Players") 
		SetDiscordRichPresenceAction(0, 'Discord', 'discord.gg/armarp')

		Wait(5000)
	end
end)

RegisterNetEvent("gettingUserId",function(user_id)
	a = user_id
end)

