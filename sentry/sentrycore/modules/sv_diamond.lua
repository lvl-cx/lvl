
RegisterNetEvent('Sentry:GatherDiamond')
AddEventHandler('Sentry:GatherDiamond', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = Sentry.getUserId(source)
      if #(playerCoords - vector3(Drugs.Diamond.Gather.x,Drugs.Diamond.Gather.y,Drugs.Diamond.Gather.z)) <= Drugs.Diamond.Gather.radius then 
        if user_id ~= nil and Sentry.hasPermission(user_id, "diamond.job") then
          local amount = 5
          local item = 1.00
          local new_weight = Sentry.getInventoryWeight(user_id)+(item*amount)
          if new_weight > Sentry.getInventoryMaxWeight(user_id) then
            Sentryclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              Sentry.giveInventoryItem(user_id, 'crystal', 5, true)
          end
        else
          Sentryclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('Sentry:ProcessDiamond')
AddEventHandler('Sentry:ProcessDiamond', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = Sentry.getUserId(source)
    if #(playerCoords - vector3(Drugs.Diamond.Process.x,Drugs.Diamond.Process.y,Drugs.Diamond.Process.z)) <= Drugs.Diamond.Process.radius then 
      if Sentry.hasPermission(user_id, "diamond.job") then 
          if Sentry.getInventoryItemAmount(user_id, 'crystal') >= 5 then

            if Sentry.getInventoryItemAmount(user_id, 'crystal') >= 5 then
              Sentry.tryGetInventoryItem(user_id, 'crystal', 5, true)
              Sentry.giveInventoryItem(user_id, 'diamond', 1, true)

            end
          else
            Sentryclient.notify(source, {"~r~You do not have that much Diamond Crystal."})
          end
      else
        Sentryclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

RegisterNetEvent('Sentry:SellDiamond')
AddEventHandler('Sentry:SellDiamond', function()
    local user_id = Sentry.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Diamond.Sell.x,Drugs.Diamond.Sell.y,Drugs.Diamond.Sell.z)) <= 5.0 then 
      if Sentry.tryGetInventoryItem(user_id,'diamond', 1) then
        if user_id ~= nil then

        local price = 15000 -- [Per Piece Price]
        Sentry.giveMoney(user_id,price)

        Sentryclient.notify(source, {"~g~Successfully sold 1 diamond for £" .. price})

        end
      end
    end
end)
