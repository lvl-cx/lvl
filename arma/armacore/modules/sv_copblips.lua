Citizen.CreateThread(function()
  while true do
      for k,v in pairs(ARMA.getUsers()) do
        ARMAclient.copBlips(v, {}, function(blipsEnabled)
          if blipsEnabled then
            local emergencyblips = {}
            if ARMA.hasGroup(k, 'polblips') and (ARMA.hasPermission(k, 'police.onduty.permission') or ARMA.hasPermission(k, 'nhs.onduty.permission')) then
              for a,b in pairs(ARMA.getUsers()) do
                local dead = 0
                local health = GetEntityHealth(GetPlayerPed(b))
                local colour = nil
                if health > 102 then
                  dead = 0
                else
                  dead = 1
                end
                if ARMA.hasPermission(a, 'police.onduty.permission') then
                  colour = 3
                  table.insert(emergencyblips, {source = b, position = GetEntityCoords(GetPlayerPed(b)), dead = dead, colour = colour})
                elseif ARMA.hasPermission(a, 'nhs.onduty.permission') then
                  colour = 2
                  table.insert(emergencyblips, {source = b, position = GetEntityCoords(GetPlayerPed(b)), dead = dead, colour = colour})
                end
              end
            end
            TriggerClientEvent('ARMA:sendFarBlips', ARMA.getUserSource(k), emergencyblips)
          end
        end)
      end
      Citizen.Wait(10000)
  end
end)
