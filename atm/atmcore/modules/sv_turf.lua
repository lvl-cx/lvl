

local isPlayerInTurf = {}

local completedTurf = false

RegisterServerEvent('ATM:TooFar')
AddEventHandler('ATM:TooFar', function(isnTurf)

	local user_id = ATM.getUserId(source)
	local player = ATM.getUserSource(user_id)

	if turfs[isnTurf] then
		local turf = turfs[isnTurf]
		if(isPlayerInTurf[source]) then
			TriggerClientEvent('ATM:OutOfZone', source)
			isPlayerInTurf[source] = nil

			TriggerClientEvent('chat:addMessage', -1, {
				template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "Turf capture sucessful at ^2" .."Turf capture failed at ^3" .. turf.nameofturf .. '</div>',
				args = { playerName, msg }
			  })
			TriggerClientEvent("ATM:MakeTurfTrue", -1, false)
			completedTurf = false
			TriggerClientEvent("ATM:DontIt", -1, false)
			TriggerClientEvent("ATM:DontItWeed", -1, false)
			TriggerClientEvent("ATM:DontItCocaine", -1, false)
			TriggerClientEvent("ATM:DontItLSD", -1, false)
			TriggerClientEvent("ATM:DontItHeroin", -1, false)
		end
	end

end)

RegisterServerEvent('ATM:PlayerDied')
AddEventHandler('ATM:PlayerDied', function(isnTurf)

	
	local user_id = ATM.getUserId(source)
	local player = ATM.getUserSource(user_id)

	if turfs[isnTurf] then
		local turf = turfs[isnTurf]
		if(isPlayerInTurf[source])then
			TriggerClientEvent('ATM:PlayerDied', source)
			isPlayerInTurf[source] = nil
			TriggerClientEvent('chat:addMessage', -1, {
				template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "Turf capture sucessful at ^2" .."Turf capture failed at ^3" .. turf.nameofturf .. '</div>',
				args = { playerName, msg }
			  })

			TriggerClientEvent("ATM:MakeTurfTrue", -1, false)
			TriggerClientEvent("ATM:DontIt", -1, false)
			TriggerClientEvent("ATM:DontItWeed", -1, false)
			TriggerClientEvent("ATM:DontItCocaine", -1, false)
			TriggerClientEvent("ATM:DontItLSD", -1, false)
			TriggerClientEvent("ATM:DontItHeroin", -1, false)
			completedTurf = false
		end
	end
end)

RegisterNetEvent("ATM:ChangeCommision")
AddEventHandler("ATM:ChangeCommision", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Global Weapon Trader" .. '</div>',
					args = { playerName, msg }
				  })
			  
				ATMclient.notify(source,{"~g~You changed commision to ~w~" .. com .. "%~g~."})
				SendLargeArms(com, source)
				SendLargeArms2(com, source)
				SendLargeArms3(com, source)
				SendLargeArms4(com, source)
				TriggerClientEvent('GlobalrecieveTurf', -1, com)
			end
		else
			ATMclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("ATM:ChangeCommisionWeed")
AddEventHandler("ATM:ChangeCommisionWeed", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Weed Seller" .. '</div>',
					args = { playerName, msg }
				  })
			  
				ATMclient.notify(source,{"~g~You changed commision to ~w~" .. com .. "%~g~."})
				SendWeed(com, source)

			end
		else
			ATMclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("ATM:ChangeCommisionCocaine")
AddEventHandler("ATM:ChangeCommisionCocaine", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Cocaine Seller" .. '</div>',
					args = { playerName, msg }
				  })
			  
				ATMclient.notify(source,{"~g~You changed commision to ~w~" .. com .. "%~g~."})
				SendCocaine(com, source)

			end
		else
			ATMclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("ATM:ChangeCommisionLSD")
AddEventHandler("ATM:ChangeCommisionLSD", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at LSD Seller" .. '</div>',
					args = { playerName, msg }
				  })
			  
				ATMclient.notify(source,{"~g~You changed commision to ~w~" .. com .. "%~g~."})
				SendLSD(com, source)

			end
		else
			ATMclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("ATM:ChangeCommisionHeroin")
AddEventHandler("ATM:ChangeCommisionHeroin", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Heroin Seller" .. '</div>',
					args = { playerName, msg }
				  })
			  
				ATMclient.notify(source,{"~g~You changed commision to ~w~" .. com .. "%~g~."})
				SendHeroin(com, source)

			end
		else
			ATMclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)



RegisterServerEvent('ATM:TakeTurf')
AddEventHandler('ATM:TakeTurf', function(isnTurf)
	local user_id = ATM.getUserId(source)
	local player = ATM.getUserSource(user_id)


	if ATM.hasGroup(user_id, 'Gang') then
	  if turfs[isnTurf] then
		  local turf = turfs[isnTurf]

			if (os.time() - turf.lastisnTurfed) < 150 and turf.lastisnTurfed ~= 0 then
				ATMclient.notify(player,{"~r~This Turf has already been capped recently. Please wait another: ~w~" .. (150 - (os.time() - turf.lastisnTurfed)) .. " ~r~seconds."})

				return
			end

			-- [Chat Message]
			TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "Turf capture started at ^3" .. turf.nameofturf .. " ^0by ^3 '" .. GetPlayerName(player) .. "'" .. '</div>',
			args = { playerName, msg }
			})
			
			completedTurf = false
			TriggerClientEvent("ATM:MakeTurfTrue", -1, true)

		  	TriggerClientEvent('ATM:TakenTurf', player, isnTurf)

				
			if turf.nameofturf == "Heroin" then
				TriggerClientEvent("HeroinZone", -1)
				TriggerClientEvent("GlobalTraderHeroin", -1)
			end

			if turf.nameofturf == "LSD" then
				TriggerClientEvent("LSDZone", -1)
				TriggerClientEvent("GlobalTraderLSD", -1)
			end

			if turf.nameofturf == "Global Weapon Trader" then
				TriggerClientEvent("ATM:DontIt", -1, false)
				TriggerClientEvent("GlobalTraderZone", -1)
			end

			if turf.nameofturf == "Weed" then
				TriggerClientEvent("ATM:DontItWeed", -1, false)
				TriggerClientEvent("WeedZone", -1)
			end

			if turf.nameofturf == "Cocaine" then
				TriggerClientEvent("CocaineZone", -1)
				TriggerClientEvent("ATM:DontItCocaine", -1, false)
			end
			  
		  	turfs[isnTurf].lastisnTurfed = os.time()
			  
		  	isPlayerInTurf[player] = isnTurf
		  	local savedSource = player
			
		  	SetTimeout(10 * 1000, function()
			  	if(isPlayerInTurf[savedSource]) then
					
				  	if(user_id) then

						
			
						  TriggerClientEvent('chat:addMessage', -1, {
							template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "Turf capture sucessful at ^2" .. turf.nameofturf .. "^0!" .. "'" .. '</div>',
							args = { playerName, msg }
						  })

		
					 	TriggerClientEvent('ATM:TurfComplete', savedSource, turf.reward, turf.nameofturf)
						 TriggerClientEvent("ATM:MakeTurfTrue", -1, false)
						 completedTurf = true
				  	end

			  	end
		  	end)		
	  	end
	else
		ATMclient.notify(source, {'~r~You need a Gang License to take a turf!'})
	end
end)
