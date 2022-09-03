Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        local currentPlayersInformation = {}
        local playersJobs = {}
        for k,v in pairs(ARMA.getUsers()) do
          local user_id = ARMA.getUserId(v)
          table.insert(playersJobs, {user_id = user_id, jobs = ARMA.getUserGroups(user_id)})
        end
        currentPlayersInformation['currentStaff'] = ARMA.getUsersByPermission('admin.tickets')
        currentPlayersInformation['jobs'] = playersJobs
        TriggerClientEvent("ARMA:receiveCurrentPlayerInfo", -1, currentPlayersInformation)
    end
end)