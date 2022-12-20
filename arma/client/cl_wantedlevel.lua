Citizen.CreateThread(function()
    SetMaxWantedLevel(0)
end)
function func_handleVehicleRewards(a)
    DisablePlayerVehicleRewards(a.playerId)
end
tARMA.createThreadOnTick(func_handleVehicleRewards)
