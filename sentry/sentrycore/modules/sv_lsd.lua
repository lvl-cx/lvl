
RegisterNetEvent('Sentry:GatherLSD')
AddEventHandler('Sentry:GatherLSD', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = Sentry.getUserId(source)
      if #(playerCoords - vector3(Drugs.LSD.Gather.x,Drugs.LSD.Gather.y,Drugs.LSD.Gather.z)) <= Drugs.LSD.Gather.radius then 
        if user_id ~= nil and Sentry.hasPermission(user_id, "lsd.job") then
          local amount = 5
          local item = 1.00
          local new_weight = Sentry.getInventoryWeight(user_id)+(item*amount)
          if new_weight > Sentry.getInventoryMaxWeight(user_id) then
            Sentryclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              Sentry.giveInventoryItem(user_id, 'acid', 5, false)
          end
        else
          Sentryclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('Sentry:ProcessLSD')
AddEventHandler('Sentry:ProcessLSD', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = Sentry.getUserId(source)
    if #(playerCoords - vector3(Drugs.LSD.Process.x,Drugs.LSD.Process.y,Drugs.LSD.Process.z)) <= Drugs.LSD.Process.radius then 
      if Sentry.hasPermission(user_id, "lsd.job") then 
          if Sentry.getInventoryItemAmount(user_id, 'acid') >= 5 then

            if Sentry.getInventoryItemAmount(user_id, 'acid') >= 5 then
              Sentry.tryGetInventoryItem(user_id, 'acid', 5, true)
              Sentry.giveInventoryItem(user_id, 'lsd', 1, true)

            end
          else
            Sentryclient.notify(source, {"~r~You do not have that much Lysergic Acid."})
          end
      else
        Sentryclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

RegisterNetEvent('Sentry:SellLSD')
AddEventHandler('Sentry:SellLSD', function()
    local user_id = Sentry.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.LSD.Sell.x,Drugs.LSD.Sell.y,Drugs.LSD.Sell.z)) <= 5.0 then 
      if Sentry.tryGetInventoryItem(user_id,'lsd', 1) then
        if user_id ~= nil then

        local price = 15000 -- [Per Piece Price]
        Sentry.giveMoney(user_id,price)

        Sentryclient.notify(source, {"~g~Successfully sold 1 lsd for £" .. price})

        end
      end
    end
end)
