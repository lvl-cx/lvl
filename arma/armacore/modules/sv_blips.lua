local clockedon = {}

RegisterServerEvent("ARMA:ENABLEBLIPS")
AddEventHandler("ARMA:ENABLEBLIPS", function()
  local user_id = ARMA.getUserId(source)
  if ARMA.hasPermission(user_id, "police.menu") or ARMA.hasPermission(user_id, "emergency.vehicle") then
    TriggerClientEvent("ARMA:BLIPS",source,clockedon)
  end
end)

Citizen.CreateThread(function()
  while true do
    Wait(10000)
    local players = GetPlayers()
    for i,v in pairs(players) do
      name = GetPlayerName(v)
      local  user_id = ARMA.getUserId(v)
      if user_id ~= nil then
        local coords = GetPlayerPed(v)

        if ARMA.hasPermission(user_id, "police.menu") then
          clockedon[user_id] = {'metpd'}
        end

        if ARMA.hasPermission(user_id, "emergency.vehicle") then
          clockedon[user_id] = {'nhs'}
        end
      end
    end
  end
end)