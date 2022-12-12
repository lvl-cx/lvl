local config = {}
config.initialized = true
local stealth = {}
local cor = {}

Citizen.CreateThread(function()	
	while config == nil or config.initialized == nil do
		Citizen.Wait(0)
	end
	

	cor.stanceChangeCooldownRunning = false
	cor.actionmode = false
	cor.forcedActionmode = false
	cor.timer = 0
	
	cor.stanceChangeCooldown = function (ms)
		cor.stanceChangeCooldownRunning = true
		cor.timer = ms
	end
	
	cor.initialized = true
	
	while true do
		if cor.stanceChangeCooldownRunning then
			Citizen.Wait(cor.timer)
			cor.stanceChangeCooldownRunning = false
		else
			Citizen.Wait(0)
		end
	end
end)

Citizen.CreateThread(function()
	local playerped = PlayerPedId()
	local player = GetPlayerIndex()
	local stance = 3
	local lastHighStance = 3
	local lastLowStance = 1
	
	while config == nil or config.initialized == nil or cor == nil or cor.initialized == nil or stealth == nil or stealth.initialized == nil do
		Citizen.Wait(0)
	end
	
	local smoothStanceChange = false
	local stanceModifier = false
	local stealthAim = true
	local stanceChangeCooldownDuration = 500
	
	local toggleCrouchWithDuckBind = true
	local persistentCrouchStance = false
	local moveSpeedCrouched = 10.0
	local moveSpeedCrouchedADS = 0.2
	local moveSpeedCrouchedFreeaim = 0.2
	local crouchSpeed = 0.35
	
	local proneEnabled = false
	local persistentProneStance = true
	local holdDuckBindToProne = false
	local moveSpeedProne = 0.2
	local moveSpeedProneADS = 0.0
	local moveSpeedProneFreeaim = 0.0
	local proneSpeed = 0.5
	
	local freeAimMaxMoveSpeed = 10.0
	local adsMaxMoveSpeed = 10.0
	
	local enableStealthStance= false
	local persistentStealthStance = false
	local stealthFreeAimMaxMoveSpeed = 10.0
	local stealthADSMaxMoveSpeed = 10.0
	
	local function refreshPlayerData ()
		playerped = PlayerPedId()
		player = GetPlayerIndex()
	end
	
	local function thisStealth (b)
		SetPedStealthMovement(playerped, b, "DEFAULT_ACTION")
		stealth.on = b
	end
	
	local function forcedStealth (b)
		stealth.forced = b
	end
	
	local function actionmode (b)
		SetPedUsingActionMode(playerped, b, -1, "DEFAULT_ACTION")
		cor.actionmode = b
	end
	
	local function forcedActionmode (b)
		cor.forcedActionmode = b
	end
	
	local function reset()
		ResetPedMovementClipset(playerped, 0.55)
		ResetPedStrafeClipset(playerped)
		SetPedCanPlayAmbientAnims(playerped, true)
		SetPedCanPlayAmbientBaseAnims(playerped, true)
		ResetPedWeaponMovementClipset(playerped)
		thisStealth(false)
		forcedStealth(true)
		actionmode(false)
		forcedActionmode(true)
		
		if (not persistentProneStance) and stance == 0 then
			stance = 1
		end
		
		if (not persistentCrouchStance) and stance == 1 then
			if enableStealthStance then
				stance = 2
			else
				stance = 3
			end
		end
		
		if (not persistentStealthStance) and stance == 2 then
			stance = 3
		end
		
	end
	
	local function duckBindPressed()
		return IsDisabledControlJustReleased(0, 36)
	end
	
	local function stanceChangeCooldown (ms)
		cor.stanceChangeCooldown(ms)
	end
	
	local function stanceChangeCooldownRunning ()
		return cor.stanceChangeCooldownRunning
	end
	
	local function upStance ()
		-- 3 = standing; 
		-- 2* = stealth; 
		-- 1 = crouched; 
		-- 0* = prone.
		
		if stance == 0 or stance == 2 then
			if stance == 0 then
				lastLowStance = 0
			else
				lastHighStance = 2
			end
			stance = stance + 1
			return stance
		
		else
			if stance == 1 then
				lastLowStance = stance
				if enableStealthStance then
					stance = 2
					return stance
				else
					stance = 3
					return stance
				end
			else
				return stance
			end
		end	
	end
	
	local function downStance ()
		-- 3 = standing; 
		-- 2* = stealth; 
		-- 1 = crouched; 
		-- 0* = prone.
		
		if stance == 2 then
			lastHighStance = stance
			stance = 1
			return stance
		
		else
			if stance == 1 then
				if proneEnabled then
					lastLowStance = stance
					stance = 0
					return stance
				else
					return stance
				end
			else	
				if stance == 3 then
					lastHighStance = stance
					if enableStealthStance then
						stance = 2
						return stance
					end

					stance = 1
					return stance
				else
					return stance
				end
			end
		end	
	end
	
	local function toggleCrouch ()
		if stance == 1 then
			lastLowStance = stance
			stance = lastHighStance
			return stance
		else
			if not stance == 0 then
				lastHighStance = stance
				stance = 1
				return stance
			else
				lastLowStance = stance
				stance = 1
				return stance
			end
		end
	end
	
	local function stand ()
		reset()
		thisStealth (false)
		forcedStealth(true)
	end
	
	local function tickStanding ()
		if IsPlayerFreeAiming(player) then
			SetPedMaxMoveBlendRatio(playerped, adsMaxMoveSpeed)
			if stealthAim then
				thisStealth(true)
				forcedStealth(true)
			else
				thisStealth (false)
				forcedStealth(true)
			end

		else
			thisStealth(false)
			forcedStealth(true)
			if IsAimCamActive() or IsAimCamThirdPersonActive() then
				SetPedMaxMoveBlendRatio(playerped, freeAimMaxMoveSpeed)	
				--tARMA.notify("PLAYER FREE-AIMING")
			end
		end
	end
	
	local function goStealthy ()
		thisStealth(true)
		forcedStealth(true)
	end
	
	local function tickStealthy ()
		if IsPlayerFreeAiming(player) then
			SetPedMaxMoveBlendRatio(playerped, stealthADSMaxMoveSpeed)
			--tARMA.notify("PLAYER AIMING STEALTHY")
		else
			if IsAimCamActive() or IsAimCamThirdPersonActive() then
				SetPedMaxMoveBlendRatio(playerped, stealthFreeAimMaxMoveSpeed)	
				--tARMA.notify("PLAYER FREE-AIMING STEALTHY")
			end
		end
	end
	
	local function crouch ()
		--tARMA.notify("CROUCHING")
		RequestAnimSet("move_ped_crouched")
		thisStealth(false)
		forcedStealth(true)
		actionmode(false)
		forcedActionmode(true)
		SetPedCanPlayAmbientAnims(playerped, false)
		SetPedCanPlayAmbientBaseAnims(playerped, false)
		--if (GetFollowPedCamViewMode() == 4) then
			--SetFollowPedCamViewMode(0)
		--end
		while not HasAnimSetLoaded("move_ped_crouched") do
			Citizen.Wait(0)
			RequestAnimSet("move_ped_crouched")
			--tARMA.notify("LOADING ANIM SET")
		end
		SetPedMovementClipset(playerped, "move_ped_crouched", crouchSpeed)
		SetPedStrafeClipset(playerped, "move_ped_crouched_strafing")
		SetWeaponAnimationOverride(playerped, "Ballistic")
		--tARMA.notify("CROUCHED")
	end
	
	local function tickCrouched ()
		if IsPlayerFreeAiming(player) then
			SetPedMaxMoveBlendRatio(playerped, moveSpeedCrouchedADS)
			--tARMA.notify("PLAYER AIMING CROUCHED")
		else
			if IsAimCamActive() or IsAimCamThirdPersonActive() then
				SetPedMaxMoveBlendRatio(playerped, moveSpeedCrouchedFreeaim)
				--tARMA.notify("PLAYER FREEAIMING CROUCHED")
			else
				SetPedMaxMoveBlendRatio(playerped, moveSpeedCrouched)
				--tARMA.notify("PLAYER CROUCHED")
			end
		end
	end
	
	local function prone ()
		tARMA.notify("PLAYER PRONE")
	end
	
	local function tickProne ()
		Citizen.Wait(tARMA.notify("PLAYER STILL PRONE"))
	end
	
	local function updateStance ()
		if stance == 3 then
			stand()
		end
		
		if stance == 2 then
			goStealthy()
		end
		
		if stance == 1 then
			crouch()
		end
		
		if stance == 0 then
			prone()
		end
	end
	
	local function updateTickStance ()
		if stance == 3 then
			tickStanding()
		end
		
		if stance == 2 then
			tickStealthy()
		end
		
		if stance == 1 then
			tickCrouched()
		end
		
		if stance == 0 then
			tickProne()
		end
	end

	SetGameplayCamRelativeHeading(180.0)
	while true do
		SetPedDucking(playerped, true)
		Citizen.Wait(0)
		refreshPlayerData()
		if toggleCrouchWithDuckBind and duckBindPressed() and not noclipActive then
			if IsPedOnFoot(playerped) and not IsPedJumping(playerped) and not IsPedFalling(playerped) and not IsPlayerDead(player) then
				if not stanceChangeCooldownRunning() then
					stanceChangeCooldown(stanceChangeCooldownDuration)
					toggleCrouch()
					updateStance()
				else
					DisableControlAction(2, 36, true)
				end
				updateTickStance()
			else
				reset()
			end
		end
	end
end)

Citizen.CreateThread(function()	
	stealth.on = false
	stealth.forced = false
	stealth.initialized = true
	local playerped = PlayerPedId()
	while config == nil or config.initialized == nil or cor == nil or cor.initialized == nil do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		
		if stealth.forced then
			SetPedStealthMovement(playerped, stealth.on, "DEFAULT_ACTION")
		end	
		
		if cor.forcedActionmode then
			SetPedUsingActionMode(playerped, cor.actionmode, -1, "DEFAULT_ACTION")
		end	
	end
end)