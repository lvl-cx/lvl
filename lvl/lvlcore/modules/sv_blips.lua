cop = {}
nhs = {}

RegisterServerEvent("LVL:ENABLEBLIPS")
AddEventHandler("LVL:ENABLEBLIPS", function()
  local user_id = LVL.getUserId(source)
  if LVL.hasPermission(user_id, "police.menu") or LVL.hasPermission(user_id, "emergency.vehicle") then
    print("works")
    TriggerClientEvent("LVL:BLIPS",source,cop,nhs)
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
      local  user_id = LVL.getUserId(v)
      if user_id ~= nil then
        local coords = GetPlayerPed(v)

        if LVL.hasPermission(user_id, "police.menu") then
          cop[user_id] = {coords,v}
        end

        if LVL.hasPermission(user_id, "emergency.vehicle") then
          nhs[user_id] = {coords,v}
        end
      end
    end
  end
end)