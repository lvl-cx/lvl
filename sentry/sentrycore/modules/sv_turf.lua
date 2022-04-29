

local isPlayerInTurf = {}

local completedTurf = false

RegisterServerEvent('Sentry:TooFar')
AddEventHandler('Sentry:TooFar', function(isnTurf)

	local user_id = Sentry.getUserId(source)
	local player = Sentry.getUserSource(user_id)

	if turfs[isnTurf] then
		local turf = turfs[isnTurf]
		if(isPlayerInTurf[source]) then
			TriggerClientEvent('Sentry:OutOfZone', source)
			isPlayerInTurf[source] = nil

			TriggerClientEvent('chat:addMessage', -1, {
				template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "Turf capture sucessful at ^2" .."Turf capture failed at ^3" .. turf.nameofturf .. '</div>',
				args = { playerName, msg }
			  })
			TriggerClientEvent("Sentry:MakeTurfTrue", -1, false)
			completedTurf = false
			TriggerClientEvent("Sentry:DontIt", -1, false)
			TriggerClientEvent("Sentry:DontItWeed", -1, false)
			TriggerClientEvent("Sentry:DontItCocaine", -1, false)
			TriggerClientEvent("Sentry:DontItLSD", -1, false)
			TriggerClientEvent("Sentry:DontItHeroin", -1, false)
		end
	end

end)

RegisterServerEvent('Sentry:PlayerDied')
AddEventHandler('Sentry:PlayerDied', function(isnTurf)

	
	local user_id = Sentry.getUserId(source)
	local player = Sentry.getUserSource(user_id)

	if turfs[isnTurf] then
		local turf = turfs[isnTurf]
		if(isPlayerInTurf[source])then
			TriggerClientEvent('Sentry:PlayerDied', source)
			isPlayerInTurf[source] = nil
			TriggerClientEvent('chat:addMessage', -1, {
				template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "Turf capture sucessful at ^2" .."Turf capture failed at ^3" .. turf.nameofturf .. '</div>',
				args = { playerName, msg }
			  })

			TriggerClientEvent("Sentry:MakeTurfTrue", -1, false)
			TriggerClientEvent("Sentry:DontIt", -1, false)
			TriggerClientEvent("Sentry:DontItWeed", -1, false)
			TriggerClientEvent("Sentry:DontItCocaine", -1, false)
			TriggerClientEvent("Sentry:DontItLSD", -1, false)
			TriggerClientEvent("Sentry:DontItHeroin", -1, false)
			completedTurf = false
		end
	end
end)

RegisterNetEvent("Sentry:ChangeCommision")
AddEventHandler("Sentry:ChangeCommision", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Global Weapon Trader" .. '</div>',
					args = { playerName, msg }
				  })
			  
				Sentryclient.notify(source,{"~g~You changed commision to ~w~" .. com .. "%~g~."})
				SendLargeArms(com, source)
				SendLargeArms2(com, source)
				SendLargeArms3(com, source)
				SendLargeArms4(com, source)
				TriggerClientEvent('GlobalrecieveTurf', -1, com)
			end
		else
			Sentryclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("Sentry:ChangeCommisionWeed")
AddEventHandler("Sentry:ChangeCommisionWeed", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Weed Seller" .. '</div>',
					args = { playerName, msg }
				  })
			  
				Sentryclient.notify(source,{"~g~You changed commision to ~w~" .. com .. "%~g~."})
				SendWeed(com, source)

			end
		else
			Sentryclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("Sentry:ChangeCommisionCocaine")
AddEventHandler("Sentry:ChangeCommisionCocaine", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Cocaine Seller" .. '</div>',
					args = { playerName, msg }
				  })
			  
				Sentryclient.notify(source,{"~g~You changed commision to ~w~" .. com .. "%~g~."})
				SendCocaine(com, source)

			end
		else
			Sentryclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("Sentry:ChangeCommisionLSD")
AddEventHandler("Sentry:ChangeCommisionLSD", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at LSD Seller" .. '</div>',
					args = { playerName, msg }
				  })
			  
				Sentryclient.notify(source,{"~g~You changed commision to ~w~" .. com .. "%~g~."})
				SendLSD(com, source)

			end
		else
			Sentryclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("Sentry:ChangeCommisionHeroin")
AddEventHandler("Sentry:ChangeCommisionHeroin", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Heroin Seller" .. '</div>',
					args = { playerName, msg }
				  })
			  
				Sentryclient.notify(source,{"~g~You changed commision to ~w~" .. com .. "%~g~."})
				SendHeroin(com, source)

			end
		else
			Sentryclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)



RegisterServerEvent('Sentry:TakeTurf')
AddEventHandler('Sentry:TakeTurf', function(isnTurf)
	local user_id = Sentry.getUserId(source)
	local player = Sentry.getUserSource(user_id)


	if Sentry.hasGroup(user_id, 'Gang') then
	  if turfs[isnTurf] then
		  local turf = turfs[isnTurf]

			if (os.time() - turf.lastisnTurfed) < 150 and turf.lastisnTurfed ~= 0 then
				Sentryclient.notify(player,{"~r~This Turf has already been capped recently. Please wait another: ~w~" .. (150 - (os.time() - turf.lastisnTurfed)) .. " ~r~seconds."})

				return
			end

			-- [Chat Message]
			TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> Turfs^7: ' .. "Turf capture started at ^3" .. turf.nameofturf .. " ^0by ^3 '" .. GetPlayerName(player) .. "'" .. '</div>',
			args = { playerName, msg }
			})
			
			completedTurf = false
			TriggerClientEvent("Sentry:MakeTurfTrue", -1, true)

		  	TriggerClientEvent('Sentry:TakenTurf', player, isnTurf)

				
			if turf.nameofturf == "Heroin" then
				TriggerClientEvent("HeroinZone", -1)
				TriggerClientEvent("GlobalTraderHeroin", -1)
			end

			if turf.nameofturf == "LSD" then
				TriggerClientEvent("LSDZone", -1)
				TriggerClientEvent("GlobalTraderLSD", -1)
			end

			if turf.nameofturf == "Global Weapon Trader" then
				TriggerClientEvent("Sentry:DontIt", -1, false)
				TriggerClientEvent("GlobalTraderZone", -1)
			end

			if turf.nameofturf == "Weed" then
				TriggerClientEvent("Sentry:DontItWeed", -1, false)
				TriggerClientEvent("WeedZone", -1)
			end

			if turf.nameofturf == "Cocaine" then
				TriggerClientEvent("CocaineZone", -1)
				TriggerClientEvent("Sentry:DontItCocaine", -1, false)
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

		
					 	TriggerClientEvent('Sentry:TurfComplete', savedSource, turf.reward, turf.nameofturf)
						 TriggerClientEvent("Sentry:MakeTurfTrue", -1, false)
						 completedTurf = true
				  	end

			  	end
		  	end)		
	  	end
	else
		Sentryclient.notify(source, {'~r~You need a Gang License to take a turf!'})
	end
end)
