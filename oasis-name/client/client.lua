RegisterNetEvent('oasis-name')
AddEventHandler('oasis-name', function(time)
    if Config.ShowServerName and Config.ServerName then
        time = time .." | © " .. Config.ServerName
    end
    if Config.ShowPlayerName then
        time = time .."\n" .. GetPlayerName(NetworkGetEntityOwner(PlayerPedId()))
    end
    if Config.ShowPlayerID then
        time = time .."\nPlayer ID: " .. GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId()))
    end
    SendNUIMessage({
        action = "setTimeAndDate",
        time = time
    })
end)