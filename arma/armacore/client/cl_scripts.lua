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
        if handsup then
            DisableControlAction(2, 37, true)
            DisableControlAction(0,24,true) -- disable attack
            DisableControlAction(0,25,true) -- disable aim
            DisableControlAction(0,47,true) -- disable weapon
            DisableControlAction(0,58,true) -- disable weapon
            DisablePlayerFiring(GetPlayerPed(-1),true)
        end
    end
end)


-- NO NPC --
Citizen.CreateThread(function()
    while true 
    	do
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

-- NO BULLET PROOF HELMETS --
CreateThread(function()
    while true do
        Wait(0)
        SetPlayerLockon(PlayerId(), false)
        SetPedConfigFlag(PlayerPedId(), 149, true)
        SetPedConfigFlag(PlayerPedId(), 438, true)
    end
end)

-- NO WANTED --
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end
    end
end)

-- NO PED DRIVE BY --
local passengerDriveBy = false

Citizen.CreateThread(function()
	while true do
		Wait(1)
		playerPed = GetPlayerPed(-1)
		car = GetVehiclePedIsIn(playerPed, false)
		if car then
			if GetPedInVehicleSeat(car, -1) == playerPed then
				SetPlayerCanDoDriveBy(PlayerId(), false)
			elseif passengerDriveBy then
				SetPlayerCanDoDriveBy(PlayerId(), true)
			else
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		end
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

-- window roll down/up --
local windowup = true

RegisterCommand("windows", function(source, args, raw)
	local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(playerPed, false) then
        local playerCar = GetVehiclePedIsIn(playerPed, false)
		if ( GetPedInVehicleSeat( playerCar, -1 ) == playerPed ) then 
            SetEntityAsMissionEntity( playerCar, true, true )
		
			if ( windowup ) then
				RollDownWindow(playerCar, 0)
				RollDownWindow(playerCar, 1)
				TriggerEvent('chatMessage', '', {255,0,0}, 'Windows down')
				windowup = false
			else
				RollUpWindow(playerCar, 0)
				RollUpWindow(playerCar, 1)
				TriggerEvent('chatMessage', '', {255,0,0}, 'Windows up')
				windowup = true
			end
		end
	end
end, false)

-- ARMA PVP -- 
AddEventHandler("playerSpawned", function(spawn)
	SetCanAttackFriendly(GetPlayerPed(-1), true, false)
	NetworkSetFriendlyFireOption(true)
end)

-- STUN GUN SCREEN --
Citizen.CreateThread(function()
	while true do
        if IsPedBeingStunned(GetPlayerPed(-1)) then
            taserFX()
        end
        Wait(100)
    end
end)

function taserFX()
    local playerPed = GetPlayerPed(-1)
    RequestAnimSet("move_m@drunk@verydrunk")
    while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
      Citizen.Wait(0)
    end
    SetPedMinGroundTimeForStungun(GetPlayerPed(-1), 15000)
    SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)
    SetTimecycleModifier("spectator5")
    SetPedIsDrunk(playerPed, true)
    Wait(15000)
    SetPedMotionBlur(playerPed, true)
    Wait(60000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(playerPed, 0)
    SetPedIsDrunk(playerPed, false)
    SetPedMotionBlur(playerPed, false)
end

-- Remove random GTA UI'S --

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      HideHudComponentThisFrame( 7 ) -- Area Name
      HideHudComponentThisFrame( 9 ) -- Street Name
      HideHudComponentThisFrame( 3 ) -- SP Cash display 
      HideHudComponentThisFrame( 4 )  -- MP Cash display
      HideHudComponentThisFrame( 13 ) -- Cash changes
      HideHudComponentThisFrame( 6 ) -- Veh Name
      HideHudComponentThisFrame( 8 ) -- Veh Class
    end
  end)

-- AntiVDM --
Citizen.CreateThread(function()
    while true do 
        local ped = PlayerPedId()
        local vehiclecheck = GetVehiclePedIsIn(ped, false)
        local players = GetActivePlayers()
        for d,e in pairs(GetGamePool("CVehicle"))do 
            local VehicleC = GetVehicleClass(e)
            if f~=14 and f~=15 and f~=16 then 
                if GetEntitySpeed(e) > 2.0 then 
                    if GetPedInVehicleSeat(e, -1) ~= 0 then 
                        SetEntityNoCollisionEntity(ped, e, true)
                        SetEntityNoCollisionEntity(e, ped, true)
                    end;
                    for d,g in pairs(players) do 
                        local h=GetPlayerPed(g)
                        SetEntityNoCollisionEntity(vehiclecheck, h, true)
                        SetEntityNoCollisionEntity(h, vehiclecheck, true)
                    end 
                end 
            end
         end;
         Wait(0)
        end 
end)

-- British Plates --
Citizen.CreateThread(function()


    RequestStreamedTextureDict("regplates")
    while not HasStreamedTextureDictLoaded("regplates") do
        Citizen.Wait(1)
    end

    AddReplaceTexture("vehshare", "plate01", "regplates", "plate01")
    AddReplaceTexture("vehshare", "plate01_n", "regplates", "plate01_n")
    AddReplaceTexture("vehshare", "plate02", "regplates", "plate02")
    AddReplaceTexture("vehshare", "plate02_n", "regplates", "plate02_n")
    AddReplaceTexture("vehshare", "plate03", "regplates", "plate03")
    AddReplaceTexture("vehshare", "plate03_n", "regplates", "plate03_n")
    AddReplaceTexture("vehshare", "plate04", "regplates", "plate04")
    AddReplaceTexture("vehshare", "plate04_n","regplates", "plate04_n")
    AddReplaceTexture("vehshare", "plate05", "regplates", "plate05")
    AddReplaceTexture("vehshare", "plate05_n", "regplates", "plate05_n")
end)