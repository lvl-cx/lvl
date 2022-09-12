Citizen.CreateThread(function()
  while true do
      local emergencyblips = {}
      local staffblips = {}
      for k,v in pairs(ARMA.getUsers()) do
        local dead = 0
        local health = GetEntityHealth(GetPlayerPed(v))
        local colour = nil
        if health > 102 then
          dead = 0
        else
          dead = 1
        end
        if ARMA.hasPermission(ARMA.getUserId(v), 'police.onduty.permission') then
          colour = 3
          table.insert(emergencyblips, {source = v, position = GetEntityCoords(GetPlayerPed(v)), dead = dead, colour = colour})
        elseif ARMA.hasPermission(ARMA.getUserId(v), 'nhs.onduty.permission') then
          colour = 2
          table.insert(emergencyblips, {source = v, position = GetEntityCoords(GetPlayerPed(v)), dead = dead, colour = colour})
        end
        table.insert(staffblips, {source = v, position = GetEntityCoords(GetPlayerPed(v)), dead = dead, colour = colour, info = GetPlayerName(v)})
      end
      for k,v in pairs(ARMA.getUsers()) do
        local user_id = ARMA.getUserId(v)
        if ARMA.hasGroup(user_id, 'polblips') then
          TriggerClientEvent('ARMA:sendFarBlips', v, emergencyblips)
        end
        if ARMA.hasPermission(user_id, 'admin.staffblips') then
          TriggerClientEvent('ARMA:sendDevBlips', v, staffblips)
        end
      end
      Citizen.Wait(10000)
  end
end)
