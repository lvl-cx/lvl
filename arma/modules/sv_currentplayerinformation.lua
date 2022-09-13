Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        local currentPlayersInformation = {}
        local playersJobs = {}
        for k,v in pairs(ARMA.getUsers()) do
          table.insert(playersJobs, {user_id = k, jobs = ARMA.getUserGroups(k)})
        end
        currentPlayersInformation['currentStaff'] = ARMA.getUsersByPermission('admin.tickets')
        currentPlayersInformation['jobs'] = playersJobs
        TriggerClientEvent("ARMA:receiveCurrentPlayerInfo", -1, currentPlayersInformation)
    end
end)