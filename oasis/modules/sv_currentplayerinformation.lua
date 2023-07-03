function OASIS.updateCurrentPlayerInfo()
  local currentPlayersInformation = {}
  local playersJobs = {}
  for k,v in pairs(OASIS.getUsers()) do
    table.insert(playersJobs, {user_id = k, jobs = OASIS.getUserGroups(k)})
  end
  currentPlayersInformation['currentStaff'] = OASIS.getUsersByPermission('admin.tickets')
  currentPlayersInformation['jobs'] = playersJobs
  TriggerClientEvent("OASIS:receiveCurrentPlayerInfo", -1, currentPlayersInformation)
end

AddEventHandler("playerJoining", function()
  OASIS.updateCurrentPlayerInfo()
end)