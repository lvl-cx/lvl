function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if IsControlPressed(1, 19) and IsControlJustPressed(1,90) and tARMA.globalOnPoliceDuty() then -- LEFTALT + D
			local closestPlayer = tARMA.GetClosestPlayer(3)
			if closestPlayer then
				targetSrc = GetPlayerServerId(closestPlayer)
				if targetSrc then
                    TriggerServerEvent('ARMA:dragPlayer')
				end
			end 
            Wait(1000)
		end
	    if IsControlPressed(1, 19) and IsDisabledControlJustPressed(1,185) then -- LEFTALT + F
			TriggerServerEvent('ARMA:ejectFromVehicle')
            Wait(1000)
		end
		if IsControlPressed(1, 19) and IsControlJustPressed(1,58) and IsPedArmed(tARMA.getPlayerPed(), 7) and GetSelectedPedWeapon(tARMA.getPlayerPed()) ~= 'WEAPON_SNOWBALL' then -- LEFTALT + G
			TriggerServerEvent("ARMA:Knockout")
			Wait(1000)
	    end
		if IsControlPressed(1, 19) and IsControlJustPressed(1,8) and (tARMA.isDev()) then -- LEFTALT + S
			Wait(1000)
			local ad = "melee@unarmed@streamed_variations"
			local anim = "plyr_takedown_front_slap"
			local ped = tARMA.getPlayerPed()

			if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
				loadAnimDict(ad)
				if ( IsEntityPlayingAnim(ped, ad, anim, 3)) then 
					TaskPlayAnim(ped, ad, "exit", 3.0, 1.0, -1, 0, 0, 0, 0, 0)
					ClearPedSecondaryTask(ped)
				else
					TaskPlayAnim(ped, ad, anim, 3.0, 1.0, -1, 0, 0, 0, 0, 0)
				end       
			end
			TriggerServerEvent("ARMA:KnockoutNoAnim")
            Wait(1000)
	    end
		if IsControlPressed(1, 19) and IsControlJustPressed(1,74) and (tARMA.isDev()) then -- LEFTALT + H
			local ad = "melee@unarmed@streamed_variations"
			local anim = "plyr_takedown_front_headbutt"
			local ped = tARMA.getPlayerPed()

			if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
				loadAnimDict(ad)
				if ( IsEntityPlayingAnim(ped, ad, anim, 3)) then 
					TaskPlayAnim(ped, ad, "exit", 3.0, 1.0, -1, 0, 0, 0, 0, 0)
					ClearPedSecondaryTask(ped)
				else
					TaskPlayAnim(ped, ad, anim, 3.0, 1.0, -1, 0, 0, 0, 0, 0)
				end       
			end
			TriggerServerEvent("ARMA:KnockoutNoAnim")
            Wait(1000)
		end
		if IsControlPressed(1, 19) and IsControlJustPressed(1,32) then 
			if not IsPauseMenuActive() and not IsPedInAnyVehicle(tARMA.getPlayerPed(), true) and not IsPedSwimming(tARMA.getPlayerPed()) and not IsPedSwimmingUnderWater(tARMA.getPlayerPed()) and not IsPedShooting(tARMA.getPlayerPed()) and not IsPedDiving(tARMA.getPlayerPed()) and not IsPedFalling(tARMA.getPlayerPed()) and (GetEntityHealth(tARMA.getPlayerPed()) > 102) and not tARMA.isHandcuffed() and not inPTT then 
				tARMA.playAnim(true,{{"rcmnigel1c","hailing_whistle_waive_a"}},false)
			end 
		end
		if IsControlPressed(1, 19) and IsControlJustPressed(1,29) then -- LEFTALT + B
			if not IsPedInAnyVehicle(tARMA.getPlayerPed(),false) then
				local closestPlayer = tARMA.GetClosestPlayer(4)
				local doesTargetHaveHandsUp = IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'missminuteman_1ig_2', 'handsup_enter', 3)
				if doesTargetHaveHandsUp then
					TriggerServerEvent("ARMA:requestPlaceBagOnHead") -- need to do inventory checks and shit
				else
					drawNativeNotification("Player must have his hands up!")
				end
			end
		end
	end
end)