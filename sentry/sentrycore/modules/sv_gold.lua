
RegisterNetEvent('Sentry:GatherGold')
AddEventHandler('Sentry:GatherGold', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = Sentry.getUserId(source)
      if #(playerCoords - vector3(Drugs.Gold.Gather.x,Drugs.Gold.Gather.y,Drugs.Gold.Gather.z)) <= Drugs.Gold.Gather.radius then 
        if user_id ~= nil and Sentry.hasPermission(user_id, "gold.job") then
          local amount = 5
          local item = 1.00
          local new_weight = Sentry.getInventoryWeight(user_id)+(item*amount)
          if new_weight > Sentry.getInventoryMaxWeight(user_id) then
            Sentryclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              Sentry.giveInventoryItem(user_id, 'golddust', 5, true)
          end
        else
          Sentryclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('Sentry:ProcessGold')
AddEventHandler('Sentry:ProcessGold', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = Sentry.getUserId(source)
    if #(playerCoords - vector3(Drugs.Gold.Process.x,Drugs.Gold.Process.y,Drugs.Gold.Process.z)) <= Drugs.Gold.Process.radius then 
      if Sentry.hasPermission(user_id, "gold.job") then 
          if Sentry.getInventoryItemAmount(user_id, 'golddust') >= 5 then

            if Sentry.getInventoryItemAmount(user_id, 'golddust') >= 5 then
              Sentry.tryGetInventoryItem(user_id, 'golddust', 5, true)
              Sentry.giveInventoryItem(user_id, 'gold', 1, true)

            end
          else
            Sentryclient.notify(source, {"~r~You do not have that much Gold Dust."})
          end
      else
        Sentryclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

RegisterNetEvent('Sentry:SellGold')
AddEventHandler('Sentry:SellGold', function()
    local user_id = Sentry.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Gold.Sell.x,Drugs.Gold.Sell.y,Drugs.Gold.Sell.z)) <= 5.0 then 
      if Sentry.tryGetInventoryItem(user_id,'gold', 1) then
        if user_id ~= nil then

        local price = 2500 -- [Per Piece Price]
        Sentry.giveMoney(user_id,price)

        Sentryclient.notify(source, {"~g~Successfully sold 1 gold for £" .. price})

        end
      end
    end
end)
