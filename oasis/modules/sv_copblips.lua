Citizen.CreateThread(function()
  while true do
      for k,v in pairs(OASIS.getUsers()) do
        OASISclient.copBlips(v, {}, function(blipsEnabled)
          if blipsEnabled then
            local emergencyblips = {}
            if OASIS.hasGroup(k, 'polblips') and (OASIS.hasPermission(k, 'police.onduty.permission') or OASIS.hasPermission(k, 'nhs.onduty.permission')) then
              for a,b in pairs(OASIS.getUsers()) do
                local dead = 0
                local health = GetEntityHealth(GetPlayerPed(b))
                local colour = nil
                if health > 102 then
                  dead = 0
                else
                  dead = 1
                end
                if OASIS.hasPermission(a, 'police.onduty.permission') then
                  colour = 3
                  table.insert(emergencyblips, {source = b, position = GetEntityCoords(GetPlayerPed(b)), dead = dead, colour = colour, bucket = GetPlayerRoutingBucket(b)})
                elseif OASIS.hasPermission(a, 'nhs.onduty.permission') then
                  colour = 2
                  table.insert(emergencyblips, {source = b, position = GetEntityCoords(GetPlayerPed(b)), dead = dead, colour = colour, bucket = GetPlayerRoutingBucket(b)})
                end
              end
            end
            TriggerClientEvent('OASIS:sendFarBlips', v, emergencyblips)
          end
        end)
      end
      Citizen.Wait(10000)
  end
end)
