cop = {}
nhs = {}

RegisterServerEvent("ARMA:ENABLEBLIPS")
AddEventHandler("ARMA:ENABLEBLIPS", function()
  local user_id = ARMA.getUserId(source)
  if ARMA.hasPermission(user_id, "police.menu") or ARMA.hasPermission(user_id, "emergency.vehicle") then
    print("works")
    TriggerClientEvent("ARMA:BLIPS",source,cop,nhs)
  end
end)

Citizen.CreateThread(function()
  while true do
    Wait(10000)
    cop = {}
    nhs = {}
    local players = GetPlayers()
    for i,v in pairs(players) do
      name = GetPlayerName(v)
      local  user_id = ARMA.getUserId(v)
      if user_id ~= nil then
        local coords = GetPlayerPed(v)

        if ARMA.hasPermission(user_id, "police.menu") then
          cop[user_id] = {coords,v}
        end

        if ARMA.hasPermission(user_id, "emergency.vehicle") then
          nhs[user_id] = {coords,v}
        end
      end
    end
  end
end)