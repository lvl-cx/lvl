-- RANDO PUNCHING --
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
		if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_UNARMED") then
			DisableControlAction(0,263,true)
			DisableControlAction(0,264,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,140,true) 
			DisableControlAction(0,141,true) 
			DisableControlAction(0,142,true)
			DisableControlAction(0,143,true) 
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true) 
		end
	SetPedCanBeDraggedOut(PlayerPedId(),false)
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

-- WHISTLE --
CreateThread(function()
    while true do
      if IsControlPressed(1, 19) and IsControlJustPressed(1, 32) then
        ExecuteCommand("e whistle2")
      end
      Wait(1)
    end
end)

-- STAMINA --
Citizen.CreateThread( function()
    while true do
       Citizen.Wait(1)
       RestorePlayerStamina(PlayerId(), 1.0)
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

-- [`] BIGGER MINIMAP 2 --
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(1, 243) then
			Citizen.Wait(0)
			if not isRadarExtended then
				SetBigmapActive(true, true)
				LastGameTimer = GetGameTimer()
				isRadarExtended = true
			elseif isRadarExtended then
				SetBigmapActive(false, false)
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

-- Sentry PVP -- 
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

-- Disable Aim Assist -- 
CreateThread(function()
    while true do
        Wait(0)
        SetPlayerTargetingMode(2)
    end
end)