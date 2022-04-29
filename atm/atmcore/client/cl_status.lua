

SetDiscordAppId(968890575535374336)

Citizen.CreateThread(function()
	while true do
		SetDiscordRichPresenceAsset('mainlogo')
		SetDiscordRichPresenceAssetText("discord.gg/ATMWrld") 
		SetDiscordRichPresenceAssetSmall('mainlogo') -- Name of the smaller image asset.
		SetDiscordRichPresenceAssetSmallText('ATM Wrld')
		SetRichPresence("" ..#GetActivePlayers().. "/" .. "128" .. " Players") 
		SetDiscordRichPresenceAction(0, 'Discord', 'discord.gg/ATMWrld')

		Wait(5000)
	end
end)