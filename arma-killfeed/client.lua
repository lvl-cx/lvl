-- Configuration Options
local config = {
	prox_enabled = false,					-- Proximity Enabled
	prox_range = 100,						-- Distance
	togglecommand = 'killfeed',	        	-- Toggle Kill Feed Command
	chatPrefix = '!',
}

local weapons = {
	[-1569615261] = 'knife',
	[-1569615261] = 'death',

	[GetHashKey("WEAPON_mosin")] = 'mosin',

    [GetHashKey("WEAPON_shank")] = 'melee',

    [GetHashKey("WEAPON_glock")] = 'pistol',
    
    [GetHashKey("WEAPON_mp7")] = 'smg',

    [GetHashKey("WEAPON_winchester")] = 'shotgun',

    [GetHashKey("WEAPON_svd")] = 'sniper',

	[GetHashKey("WEAPON_ODIN")] = "lmg",
}


local feedActive = true
local isDead = false
Citizen.CreateThread(function()
    while true do
		local killed = GetPlayerPed(PlayerId())
		local killedCoords = GetEntityCoords(killed)
		if IsEntityDead(killed) and not isDead then
            local killer = GetPedKiller(killed)
            if killer ~= 0 then
				local killerCoords = GetEntityCoords(killer)
                if killer == killed then
					TriggerServerEvent('KillFeed:Died', killedCoords)
				else
					local KillerNetwork = NetworkGetPlayerIndexFromPed(killer)
					if KillerNetwork == "**Invalid**" or KillerNetwork == -1 then
						TriggerServerEvent('KillFeed:Died', killedCoords)
					else
						TriggerEvent('Killfeed:Killed', GetPlayerServerId(KillerNetwork), hashToWeapon(GetPedCauseOfDeath(killed)), killedCoords, killerCoords)
					end
                end
            else
				TriggerServerEvent('KillFeed:Died', killedCoords)
            end
            isDead = true
        end
		if not IsEntityDead(killed) then
			isDead = false
		end
        Citizen.Wait(50)
    end
end)

RegisterNetEvent('KillFeed:AnnounceKill')
AddEventHandler('KillFeed:AnnounceKill', function(killed, killer, weapon, distance, coords, killerGroup, killedGroup)
	if feedActive then
		if killed == GetPlayerName(PlayerId()) or killer == GetPlayerName(PlayerId()) then
			style = "killContainerOwn"
		else
			style = "killContainer"
		end

		if coords ~= nil and config.prox_enabled then
			local myLocation = GetEntityCoords(GetPlayerPed(PlayerId()))
			if #(myLocation - coords) < config.prox_range then
				SendNUIMessage({
					type = 'newKill',
					killer = killer,
					killed = killed,
					weapon = weapon,
					distance = distance,
					style = style,
					killerGroup = killerGroup,
					killedGroup = killedGroup,
				})
			end
		else
			SendNUIMessage({
				type = 'newKill',
				killer = killer,
				killed = killed,
				weapon = weapon,
				distance = distance,
				style = style,
				killerGroup = killerGroup,
				killedGroup = killedGroup,
			})
		end
	end
end)

RegisterNetEvent('KillFeed:AnnounceDeath')
AddEventHandler('KillFeed:AnnounceDeath', function(killed, coords, killedGroup)
	if feedActive then
		if killed == GetPlayerName(PlayerId()) or killer == GetPlayerName(PlayerId()) then
			style = "killContainerOwn"
		else
			style = "killContainer"
		end

		if coords ~= nil and config.prox_enabled then
			local myLocation = GetEntityCoords(GetPlayerPed(PlayerId()))
			if #(myLocation - coords) < config.prox_range then
				SendNUIMessage({
					type = 'newDeath',
					killed = killed,
					style = style,
					killedGroup = killedGroup,
				})
			end
		else
			SendNUIMessage({
				type = 'newDeath',
				killed = killed,
				style = style,
				killedGroup = killedGroup,
			})
		end
	end
end)

function hashToWeapon(hash)
	if weapons[hash] ~= nil then
		return weapons[hash]
	else
		return 'death'
end
RegisterNetEvent('showNotify')
AddEventHandler('showNotify', function(notify)
	ShowAboveRadarMessage(notify)
end)

function ShowAboveRadarMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

RegisterCommand("killfeed", function(source, args, raw)
	feedActive = not feedActive
	if feedActive then
		notify("~g~Killfeed has been enabled.")
	else
		notify("~r~Killfeed has been disabled.")
	end
end)
