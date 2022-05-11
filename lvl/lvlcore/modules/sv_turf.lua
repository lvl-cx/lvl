

local isPlayerInTurf = {}

local completedTurf = false

RegisterServerEvent('LVL:TooFar')
AddEventHandler('LVL:TooFar', function(isnTurf)

	local user_id = LVL.getUserId(source)
	local player = LVL.getUserSource(user_id)

	if turfs[isnTurf] then
		local turf = turfs[isnTurf]
		if(isPlayerInTurf[source]) then
			TriggerClientEvent('LVL:OutOfZone', source)
			isPlayerInTurf[source] = nil

			TriggerClientEvent('chatMessage', source, "^7[^1LVL^7]:", {255, 255, 255}, "Turf capture sucessful at ^2" .."Turf capture failed at ^3" .. turf.nameofturf .. "alert")
			TriggerClientEvent("LVL:MakeTurfTrue", -1, false)
			completedTurf = false
			TriggerClientEvent("LVL:DontIt", -1, false)
			TriggerClientEvent("LVL:DontItWeed", -1, false)
			TriggerClientEvent("LVL:DontItCocaine", -1, false)
			TriggerClientEvent("LVL:DontItLSD", -1, false)
			TriggerClientEvent("LVL:DontItHeroin", -1, false)
		end
	end

end)

RegisterServerEvent('LVL:PlayerDied')
AddEventHandler('LVL:PlayerDied', function(isnTurf)

	
	local user_id = LVL.getUserId(source)
	local player = LVL.getUserSource(user_id)

	if turfs[isnTurf] then
		local turf = turfs[isnTurf]
		if(isPlayerInTurf[source])then
			TriggerClientEvent('LVL:PlayerDied', source)
			isPlayerInTurf[source] = nil
			TriggerClientEvent('chatMessage', source, "^7[^1LVL^7]:", {255, 255, 255}, "Turf capture sucessful at ^2" .."Turf capture failed at ^3" .. turf.nameofturf .. "alert")

			TriggerClientEvent("LVL:MakeTurfTrue", -1, false)
			TriggerClientEvent("LVL:DontIt", -1, false)
			TriggerClientEvent("LVL:DontItWeed", -1, false)
			TriggerClientEvent("LVL:DontItCocaine", -1, false)
			TriggerClientEvent("LVL:DontItLSD", -1, false)
			TriggerClientEvent("LVL:DontItHeroin", -1, false)
			completedTurf = false
		end
	end
end)

RegisterNetEvent("LVL:ChangeCommision")
AddEventHandler("LVL:ChangeCommision", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chatMessage', source, "^7[^1LVL^7]:", {255, 255, 255}, "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Global Weapon Trader", "alert")
			  
				LVLclient.notify(source,{"~g~You changed commision to " .. com .. "%~g~."})
				SendLargeArms(com, source)
				SendLargeArms2(com, source)
				SendLargeArms3(com, source)
				SendLargeArms4(com, source)
				TriggerClientEvent('GlobalrecieveTurf', -1, com)
			end
		else
			LVLclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("LVL:ChangeCommisionWeed")
AddEventHandler("LVL:ChangeCommisionWeed", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chatMessage', source, "^7[^1LVL^7]:", {255, 255, 255}, "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Weed Seller", "alert")
			  
				LVLclient.notify(source,{"~g~You changed commision to " .. com .. "%~g~."})
				SendWeed(com, source)

			end
		else
			LVLclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("LVL:ChangeCommisionCocaine")
AddEventHandler("LVL:ChangeCommisionCocaine", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chatMessage', source, "^7[^1LVL^7]:", {255, 255, 255}, "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Cocaine Seller", "alert")
			  
				LVLclient.notify(source,{"~g~You changed commision to " .. com .. "%~g~."})
				SendCocaine(com, source)

			end
		else
			LVLclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("LVL:ChangeCommisionLSD")
AddEventHandler("LVL:ChangeCommisionLSD", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chatMessage', source, "^7[^1LVL^7]:", {255, 255, 255}, "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at LSD Seller", "alert")
			  
				LVLclient.notify(source,{"~g~You changed commision to " .. com .. "%~g~."})
				SendLSD(com, source)

			end
		else
			LVLclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)

RegisterNetEvent("LVL:ChangeCommisionHeroin")
AddEventHandler("LVL:ChangeCommisionHeroin", function(com)
	if completedTurf == true then
		if com <= 35 then
			if com >= 0 then
				TriggerClientEvent('chatMessage', source, "^7[^1LVL^7]:", {255, 255, 255}, "^3" .. GetPlayerName(source) .. " ^0has changed Commision to ^3" .. com .. "% ^0at Heroin Seller", "alert")
			  
				LVLclient.notify(source,{"~g~You changed commision to " .. com .. "%~g~."})
				SendHeroin(com, source)

			end
		else
			LVLclient.notify(source,{"~r~You cannot go higher than 35%."})
		end
	end
end)



RegisterServerEvent('LVL:TakeTurf')
AddEventHandler('LVL:TakeTurf', function(isnTurf)
	local user_id = LVL.getUserId(source)
	local player = LVL.getUserSource(user_id)


	if LVL.hasGroup(user_id, 'Gang') then
	  if turfs[isnTurf] then
		  local turf = turfs[isnTurf]

			if (os.time() - turf.lastisnTurfed) < 150 and turf.lastisnTurfed ~= 0 then
				LVLclient.notify(player,{"~r~This Turf has already been capped recently. Please wait another: " .. (150 - (os.time() - turf.lastisnTurfed)) .. " ~r~seconds."})

				return
			end

			-- [Chat Message]
			TriggerClientEvent('chatMessage', source, "^7[^1LVL^7]:", {255, 255, 255}, "Turf capture started at ^3" .. turf.nameofturf .. " ^0by ^3 '" .. GetPlayerName(player), "alert")
			
			completedTurf = false
			TriggerClientEvent("LVL:MakeTurfTrue", -1, true)

		  	TriggerClientEvent('LVL:TakenTurf', player, isnTurf)

				
			if turf.nameofturf == "Heroin" then
				TriggerClientEvent("HeroinZone", -1)
				TriggerClientEvent("GlobalTraderHeroin", -1)
			end

			if turf.nameofturf == "LSD" then
				TriggerClientEvent("LSDZone", -1)
				TriggerClientEvent("GlobalTraderLSD", -1)
			end

			if turf.nameofturf == "Global Weapon Trader" then
				TriggerClientEvent("LVL:DontIt", -1, false)
				TriggerClientEvent("GlobalTraderZone", -1)
			end

			if turf.nameofturf == "Weed" then
				TriggerClientEvent("LVL:DontItWeed", -1, false)
				TriggerClientEvent("WeedZone", -1)
			end

			if turf.nameofturf == "Cocaine" then
				TriggerClientEvent("CocaineZone", -1)
				TriggerClientEvent("LVL:DontItCocaine", -1, false)
			end
			  
		  	turfs[isnTurf].lastisnTurfed = os.time()
			  
		  	isPlayerInTurf[player] = isnTurf
		  	local savedSource = player
			
		  	SetTimeout(10 * 1000, function()
			  	if(isPlayerInTurf[savedSource]) then
					
				  	if(user_id) then

						
						TriggerClientEvent('chatMessage', savedSource, "^7[^1LVL^7]:", {255, 255, 255}, "Turf capture sucessful at ^2" .. turf.nameofturf .. "^0!" .. "'", "alert")

		
					 	TriggerClientEvent('LVL:TurfComplete', savedSource, turf.reward, turf.nameofturf)
						 TriggerClientEvent("LVL:MakeTurfTrue", -1, false)
						 completedTurf = true
				  	end

			  	end
		  	end)		
	  	end
	else
		LVLclient.notify(source, {'~r~You need a Gang License to take a turf!'})
	end
end)
