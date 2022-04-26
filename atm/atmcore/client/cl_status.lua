

SetDiscordAppId(965536574404177980)

Citizen.CreateThread(function()
	while true do
		SetDiscordRichPresenceAsset('6f8144df-fd1f-4068-a450-4eb1d4b442dc') 
		SetDiscordRichPresenceAssetText("discord.gg/ATMGTA") 
		SetDiscordRichPresenceAssetSmall('6f8144df-fd1f-4068-a450-4eb1d4b442dc') -- Name of the smaller image asset.
		SetDiscordRichPresenceAssetSmallText('ATM')
		SetRichPresence("" ..#GetActivePlayers().. "/" .. "64" .. " Players") 
		SetDiscordRichPresenceAction(0, 'Discord', 'discord.gg/ATMGTA')

		Wait(5000)
	end
end)



