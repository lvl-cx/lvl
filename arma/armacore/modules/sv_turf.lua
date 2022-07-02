

local isPlayerInTurf = {}

local completedTurf = false

RegisterServerEvent('ARMA:TooFar')
AddEventHandler('ARMA:TooFar', function(isnTurf)

	local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)

	if turfs[isnTurf] then
		local turf = turfs[isnTurf]
		if(isPlayerInTurf[source]) then
			TriggerClientEvent('ARMA:OutOfZone', source)
			isPlayerInTurf[source] = nil

			TriggerClientEvent('chatMessage', source, "^7[^1ARMA^7]:", {255, 255, 255}, "Turf capture sucessful at ^2" .."Turf capture failed at ^3" .. turf.nameofturf .. "alert")
			TriggerClientEvent("ARMA:MakeTurfTrue", -1, false)
			completedTurf = false
			TriggerClientEvent("ARMA:DontIt", -1, false)
			TriggerClientEvent("ARMA:DontItWeed", -1, false)
			TriggerClientEvent("ARMA:DontItCocaine", -1, false)
			TriggerClientEvent("ARMA:DontItLSD", -1, false)
			TriggerClientEvent("ARMA:DontItHeroin", -1, false)
		end
	end

end)

RegisterServerEvent('ARMA:PlayerDied')
AddEventHandler('ARMA:PlayerDied', function(isnTurf)

	
	local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)

	if turfs[isnTurf] then
		local turf = turfs[isnTurf]
		if(isPlayerInTurf[source])then
			TriggerClientEvent('ARMA:PlayerDied', source)
			isPlayerInTurf[source] = nil
			TriggerClientEvent('chatMessage', source, "^7[^1ARMA^7]:", {255, 255, 255}, "Turf capture sucessful at ^2" .."Turf capture failed at ^3" .. turf.nameofturf .. "alert")

			TriggerClientEvent("ARMA:MakeTurfTrue", -1, false)
			TriggerClientEvent("ARMA:DontIt", -1, false)
			TriggerClientEvent("ARMA:DontItWeed", -1, false)
			TriggerClientEvent("ARMA:DontItCocaine", -1, false)
			TriggerClientEvent("ARMA:DontItLSD", -1, false)
			TriggerClientEvent("ARMA:DontItHeroin", -1, false)
			completedTurf = false
		end
	end
end)

RegisterNetEvent("ARMA:ChangeCommisionWeed")
AddEventHandler("ARMA:ChangeCommisionWeed", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chatMessage', source, "^7[^1ARMA^7]:", {255, 255, 255}, "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Weed Seller", "alert")
			  
				ARMAclient.notify(source,{"~g~You changed commision to " .. com .. "%~g~."})
				SendWeed(com, source)

			end
		else
			ARMAclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("ARMA:ChangeCommisionCocaine")
AddEventHandler("ARMA:ChangeCommisionCocaine", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chatMessage', source, "^7[^1ARMA^7]:", {255, 255, 255}, "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Cocaine Seller", "alert")
			  
				ARMAclient.notify(source,{"~g~You changed commision to " .. com .. "%~g~."})
				SendCocaine(com, source)

			end
		else
			ARMAclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("ARMA:ChangeCommisionLSD")
AddEventHandler("ARMA:ChangeCommisionLSD", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chatMessage', source, "^7[^1ARMA^7]:", {255, 255, 255}, "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at LSD Seller", "alert")
			  
				ARMAclient.notify(source,{"~g~You changed commision to " .. com .. "%~g~."})
				SendLSD(com, source)

			end
		else
			ARMAclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("ARMA:ChangeCommisionHeroin")
AddEventHandler("ARMA:ChangeCommisionHeroin", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chatMessage', source, "^7[^1ARMA^7]:", {255, 255, 255}, "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Heroin Seller", "alert")
			  
				ARMAclient.notify(source,{"~g~You changed commision to " .. com .. "%~g~."})
				SendHeroin(com, source)

			end
		else
			ARMAclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)



RegisterServerEvent('ARMA:TakeTurf')
AddEventHandler('ARMA:TakeTurf', function(isnTurf)
	local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)


	if ARMA.hasGroup(user_id, 'Gang') then
	  if turfs[isnTurf] then
		  local turf = turfs[isnTurf]

			if (os.time() - turf.lastisnTurfed) < 150 and turf.lastisnTurfed ~= 0 then
				ARMAclient.notify(player,{"~r~This Turf has already been capped recently. Please wait another: " .. (150 - (os.time() - turf.lastisnTurfed)) .. " ~r~seconds."})

				return
			end

			-- [Chat Message]
			TriggerClientEvent('chatMessage', source, "^7[^1ARMA^7]:", {255, 255, 255}, "Turf capture started at ^3" .. turf.nameofturf .. " ^0by ^3 '" .. GetPlayerName(player), "alert")
			
			completedTurf = false
			TriggerClientEvent("ARMA:MakeTurfTrue", -1, true)

		  	TriggerClientEvent('ARMA:TakenTurf', player, isnTurf)

				
			if turf.nameofturf == "Heroin" then
				TriggerClientEvent("HeroinZone", -1)
				TriggerClientEvent("GlobalTraderHeroin", -1)
			end

			if turf.nameofturf == "LSD" then
				TriggerClientEvent("LSDZone", -1)
				TriggerClientEvent("GlobalTraderLSD", -1)
			end

			if turf.nameofturf == "Weed" then
				TriggerClientEvent("ARMA:DontItWeed", -1, false)
				TriggerClientEvent("WeedZone", -1)
			end

			if turf.nameofturf == "Cocaine" then
				TriggerClientEvent("CocaineZone", -1)
				TriggerClientEvent("ARMA:DontItCocaine", -1, false)
			end
			  
		  	turfs[isnTurf].lastisnTurfed = os.time()
			  
		  	isPlayerInTurf[player] = isnTurf
		  	local savedSource = player
			
		  	SetTimeout(300 * 1000, function()
			  	if(isPlayerInTurf[savedSource]) then
					
				  	if(user_id) then

						
						TriggerClientEvent('chatMessage', savedSource, "^7[^1ARMA^7]:", {255, 255, 255}, "Turf capture sucessful at ^2" .. turf.nameofturf .. "^0!" .. "'", "alert")

		
					 	TriggerClientEvent('ARMA:TurfComplete', savedSource, turf.reward, turf.nameofturf)
						 TriggerClientEvent("ARMA:MakeTurfTrue", -1, false)
						 completedTurf = true
				  	end

			  	end
		  	end)		
	  	end
	else
		ARMAclient.notify(source, {'~r~You need a Gang License to take a turf!'})
	end
end)
