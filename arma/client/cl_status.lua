SetDiscordAppId(970724996223746149)
RegisterNetEvent("gettingUserId",function(user_id, maxplayers)
	Citizen.CreateThread(function()
		while true do
			SetDiscordRichPresenceAsset('mainlogo') 
			SetDiscordRichPresenceAssetText("discord.gg/armarp") 
			SetDiscordRichPresenceAssetSmall('mainlogo')
			SetDiscordRichPresenceAssetSmallText('ARMA')
			while (user_id == 0 ) do
				SetRichPresence("[ID:fetching...] | " ..#GetActivePlayers().. "/" .. maxplayers .. " Players") 
				Wait(0)
			end
			SetRichPresence("[ID:"..user_id.."] | " ..#GetActivePlayers().. "/" .. maxplayers .. " Players") 
			SetDiscordRichPresenceAction(0, 'Discord', 'discord.gg/armarp')
	
			Wait(5000)
		end
	end)
	
end)

