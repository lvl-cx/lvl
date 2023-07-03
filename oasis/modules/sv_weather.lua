voteCooldown = 1800
currentWeather = "CLEAR"

weatherVoterCooldown = voteCooldown

RegisterServerEvent("OASIS:vote") 
AddEventHandler("OASIS:vote", function(weatherType)
    TriggerClientEvent("OASIS:voteStateChange",-1,weatherType)
end)

RegisterServerEvent("OASIS:tryStartWeatherVote") 
AddEventHandler("OASIS:tryStartWeatherVote", function()
	local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'admin.managecommunitypot') then
        if weatherVoterCooldown >= voteCooldown then
            TriggerClientEvent("OASIS:startWeatherVote", -1)
            weatherVoterCooldown = 0
        else
            TriggerClientEvent("chatMessage", source, "Another vote can be started in " .. tostring(voteCooldown-weatherVoterCooldown) .. " seconds!", {255, 0, 0})
        end
    else
        OASISclient.notify(source, {'~r~You do not have permission for this.'})
    end
end)

RegisterServerEvent("OASIS:getCurrentWeather") 
AddEventHandler("OASIS:getCurrentWeather", function()
    local source = source
    TriggerClientEvent("OASIS:voteFinished",source,currentWeather)
end)

RegisterServerEvent("OASIS:setCurrentWeather")
AddEventHandler("OASIS:setCurrentWeather", function(newWeather)
	currentWeather = newWeather
end)

Citizen.CreateThread(function()
	while true do
		weatherVoterCooldown = weatherVoterCooldown + 1
		Citizen.Wait(1000)
	end
end)