cop = {}
nhs = {}

RegisterServerEvent("ATM:ENABLEBLIPS")
AddEventHandler("ATM:ENABLEBLIPS", function()
  local user_id = ATM.getUserId(source)
  if ATM.hasPermission(user_id, "police.menu") or ATM.hasPermission(user_id, "emergency.vehicle") then
    print("works")
    TriggerClientEvent("ATM:BLIPS",source,cop,nhs)
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
      local  user_id = ATM.getUserId(v)
      if user_id ~= nil then
        local coords = GetPlayerPed(v)

        if ATM.hasPermission(user_id, "police.menu") then
          cop[user_id] = {coords,v}
        end

        if ATM.hasPermission(user_id, "emergency.vehicle") then
          nhs[user_id] = {coords,v}
        end
      end
    end
  end
end)