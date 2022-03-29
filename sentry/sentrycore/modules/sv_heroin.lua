
RegisterNetEvent('Sentry:GatherHeroin')
AddEventHandler('Sentry:GatherHeroin', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = Sentry.getUserId(source)
      if #(playerCoords - vector3(Drugs.Heroin.Gather.x,Drugs.Heroin.Gather.y,Drugs.Heroin.Gather.z)) <= Drugs.Heroin.Gather.radius then 
        if user_id ~= nil and Sentry.hasPermission(user_id, "heroin.job") then
          local amount = 5
          local item = 1.00
          local new_weight = Sentry.getInventoryWeight(user_id)+(item*amount)
          if new_weight > Sentry.getInventoryMaxWeight(user_id) then
            Sentryclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              Sentry.giveInventoryItem(user_id, 'opium', 5, false)
          end
        else
          Sentryclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('Sentry:ProcessHeroin')
AddEventHandler('Sentry:ProcessHeroin', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = Sentry.getUserId(source)
    if #(playerCoords - vector3(Drugs.Heroin.Process.x,Drugs.Heroin.Process.y,Drugs.Heroin.Process.z)) <= Drugs.Heroin.Process.radius then 
      if Sentry.hasPermission(user_id, "heroin.job") then 
          if Sentry.getInventoryItemAmount(user_id, 'opium') >= 5 then

            if Sentry.getInventoryItemAmount(user_id, 'opium') >= 5 then
              Sentry.tryGetInventoryItem(user_id, 'opium', 5, true)
              Sentry.giveInventoryItem(user_id, 'heroin', 1, true)

            end
          else
            Sentryclient.notify(source, {"~r~You do not have that much Opium."})
          end
      else
        Sentryclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

RegisterNetEvent('Sentry:SellHeroin')
AddEventHandler('Sentry:SellHeroin', function()
    local user_id = Sentry.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Heroin.Sell.x,Drugs.Heroin.Sell.y,Drugs.Heroin.Sell.z)) <= 5.0 then 
      if Sentry.tryGetInventoryItem(user_id,'heroin', 1) then
        if user_id ~= nil then

        local price = 15000 -- [Per Piece Price]
        Sentry.giveMoney(user_id,price)

        Sentryclient.notify(source, {"~g~Successfully sold 1 heroin for £" .. price})

        end
      end
    end
end)
