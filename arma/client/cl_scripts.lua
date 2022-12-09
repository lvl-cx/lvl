Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        SetMaxWantedLevel(0)
        RestorePlayerStamina(PlayerId(), 1.0)
        DisablePlayerVehicleRewards(PlayerId())
        SetPedDropsWeaponsWhenDead(GetPlayerPed(-1), 0)
        RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
        RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
        RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
        for i = 1, 12 do
            EnableDispatchService(i, false)
        end
        SetPlayerWantedLevel(PlayerId(), 0, false)
        SetPlayerWantedLevelNow(PlayerId(), false)
        SetPlayerWantedLevelNoDrop(PlayerId(), 0, false)
        if IsPedArmed(ped, 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)


-- NO NPC --
Citizen.CreateThread(function()
    while true do
    	SetVehicleDensityMultiplierThisFrame(0.0)
		SetPedDensityMultiplierThisFrame(0.0)
		SetRandomVehicleDensityMultiplierThisFrame(0.0)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
		local playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(playerPed) 
		RemoveVehiclesFromGeneratorsInArea(pos['x'] - 500.0, pos['y'] - 500.0, pos['z'] - 500.0, pos['x'] + 500.0, pos['y'] + 500.0, pos['z'] + 500.0);
		SetGarbageTrucks(0)
		SetRandomBoats(0)
		Citizen.Wait(1)
	end

end)

-- [Z] BIGGER MINIMAP --
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(1, 20) then
			Citizen.Wait(0)
			if not isRadarExtended then
				SetRadarBigmapEnabled(true, false)
				LastGameTimer = GetGameTimer()
				isRadarExtended = true
			elseif isRadarExtended then
				SetRadarBigmapEnabled(false, false)
				LastGameTimer = 0
				isRadarExtended = false
			end
		end
	end
end)

-- ARMA PVP -- 
AddEventHandler("playerSpawned", function()
	SetCanAttackFriendly(GetPlayerPed(-1), true, false)
	NetworkSetFriendlyFireOption(true)
end)