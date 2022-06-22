

SetDiscordAppId(970724996223746149)

Citizen.CreateThread(function()
	while true do
		SetDiscordRichPresenceAsset('mainlogo') 
		SetDiscordRichPresenceAssetText("discord.gg/ArmaGTA") 
		SetDiscordRichPresenceAssetSmall('mainlogo') -- Name of the smaller image asset.
		SetDiscordRichPresenceAssetSmallText('ARMA')
		SetRichPresence("" ..#GetActivePlayers().. "/" .. "128" .. " Players") 
		SetDiscordRichPresenceAction(0, 'Discord', 'discord.gg/ArmaGTA')

		Wait(5000)
	end
end)



