voteCooldown = 1800
currentWeather = "CLEAR"

weatherVoterCooldown = voteCooldown

RegisterServerEvent("ARMA:vote") 
AddEventHandler("ARMA:vote", function(weatherType)
    TriggerClientEvent("ARMA:voteStateChange",-1,weatherType)
end)

RegisterServerEvent("ARMA:tryStartWeatherVote") 
AddEventHandler("ARMA:tryStartWeatherVote", function()
	local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.managecommunitypot') then
        if weatherVoterCooldown >= voteCooldown then
            TriggerClientEvent("ARMA:startWeatherVote", -1)
            weatherVoterCooldown = 0
        else
            TriggerClientEvent("chatMessage", source, "Another vote can be started in " .. tostring(voteCooldown-weatherVoterCooldown) .. " seconds!", {255, 0, 0})
        end
    else
        ARMAclient.notify(source, {'~r~You do not have permission for this.'})
    end
end)

RegisterServerEvent("ARMA:getCurrentWeather") 
AddEventHandler("ARMA:getCurrentWeather", function()
    local source = source
    TriggerClientEvent("ARMA:voteFinished",source,currentWeather)
end)

RegisterServerEvent("ARMA:setCurrentWeather")
AddEventHandler("ARMA:setCurrentWeather", function(newWeather)
	currentWeather = newWeather
end)

Citizen.CreateThread(function()
	while true do
		weatherVoterCooldown = weatherVoterCooldown + 1
		Citizen.Wait(1000)
	end
end)