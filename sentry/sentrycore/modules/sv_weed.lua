
RegisterNetEvent('Sentry:GatherWeed')
AddEventHandler('Sentry:GatherWeed', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = Sentry.getUserId(source)
      if #(playerCoords - vector3(Drugs.Weed.Gather.x,Drugs.Weed.Gather.y,Drugs.Weed.Gather.z)) <= Drugs.Weed.Gather.radius then 
        if user_id ~= nil and Sentry.hasPermission(user_id, "weed.job") then
          local amount = 5
          local item = 1.00
          local new_weight = Sentry.getInventoryWeight(user_id)+(item*amount)
          if new_weight > Sentry.getInventoryMaxWeight(user_id) then
            Sentryclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              Sentry.giveInventoryItem(user_id, 'cannabis', 5, true)
          end
        else
          Sentryclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('Sentry:ProcessWeed')
AddEventHandler('Sentry:ProcessWeed', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = Sentry.getUserId(source)
    if #(playerCoords - vector3(Drugs.Weed.Process.x,Drugs.Weed.Process.y,Drugs.Weed.Process.z)) <= Drugs.Weed.Process.radius then 
      if Sentry.hasPermission(user_id, "weed.job") then 
          if Sentry.getInventoryItemAmount(user_id, 'cannabis') >= 5 then

            if Sentry.getInventoryItemAmount(user_id, 'cannabis') >= 5 then
              Sentry.tryGetInventoryItem(user_id, 'cannabis', 5, true)
              Sentry.giveInventoryItem(user_id, 'weed', 1, true)

            end
          else
            Sentryclient.notify(source, {"~r~You do not have that much Cannabis Sativa."})
          end
      else
        Sentryclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

RegisterNetEvent('Sentry:SellWeed')
AddEventHandler('Sentry:SellWeed', function()
    local user_id = Sentry.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Weed.Sell.x,Drugs.Weed.Sell.y,Drugs.Weed.Sell.z)) <= 5.0 then 
      if Sentry.tryGetInventoryItem(user_id,'weed', 1) then
        if user_id ~= nil then

        local price = 15000 -- [Per Piece Price]
        Sentry.giveMoney(user_id,price)

        Sentryclient.notify(source, {"~g~Successfully sold 1 weed for £" .. price})

        end
      end
    end
end)
