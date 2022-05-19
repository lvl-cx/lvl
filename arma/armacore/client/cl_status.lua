

SetDiscordAppId(970724996223746149)

Citizen.CreateThread(function()
	while true do
		SetDiscordRichPresenceAsset('mainlogo') 
		SetDiscordRichPresenceAssetText("discord.gg/ARMA") 
		SetDiscordRichPresenceAssetSmall('mainlogo') -- Name of the smaller image asset.
		SetDiscordRichPresenceAssetSmallText('ARMA')
		SetRichPresence("" ..#GetActivePlayers().. "/" .. "64" .. " Players") 
		SetDiscordRichPresenceAction(0, 'Discord', 'discord.gg/ARMA')

		Wait(5000)
	end
end)



