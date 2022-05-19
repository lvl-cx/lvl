
RegisterNetEvent('ARMA:GatherGold')
AddEventHandler('ARMA:GatherGold', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = ARMA.getUserId(source)
      if #(playerCoords - vector3(Drugs.Gold.Gather.x,Drugs.Gold.Gather.y,Drugs.Gold.Gather.z)) <= Drugs.Gold.Gather.radius then 
        if user_id ~= nil and ARMA.hasPermission(user_id, "gold.job") then
          local amount = 5
          local item = 1.00
          local new_weight = ARMA.getInventoryWeight(user_id)+(item*amount)
          if new_weight > ARMA.getInventoryMaxWeight(user_id) then
            ARMAclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              ARMA.giveInventoryItem(user_id, 'golddust', 5, true)
          end
        else
          ARMAclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('ARMA:ProcessGold')
AddEventHandler('ARMA:ProcessGold', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = ARMA.getUserId(source)
    if #(playerCoords - vector3(Drugs.Gold.Process.x,Drugs.Gold.Process.y,Drugs.Gold.Process.z)) <= Drugs.Gold.Process.radius then 
      if ARMA.hasPermission(user_id, "gold.job") then 
          if ARMA.getInventoryItemAmount(user_id, 'golddust') >= 5 then

            if ARMA.getInventoryItemAmount(user_id, 'golddust') >= 5 then
              ARMA.tryGetInventoryItem(user_id, 'golddust', 5, true)
              ARMA.giveInventoryItem(user_id, 'gold', 1, true)

            end
          else
            ARMAclient.notify(source, {"~r~You do not have that much Gold Dust."})
          end
      else
        ARMAclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

RegisterNetEvent('ARMA:SellGold')
AddEventHandler('ARMA:SellGold', function()
    local user_id = ARMA.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Gold.Sell.x,Drugs.Gold.Sell.y,Drugs.Gold.Sell.z)) <= 5.0 then 
      if ARMA.tryGetInventoryItem(user_id,'gold', 1) then
        if user_id ~= nil then

        local price = 2500 -- [Per Piece Price]
        ARMA.giveMoney(user_id,price)

        ARMAclient.notify(source, {"~g~Successfully sold 1 gold for £" .. price})

        end
      end
    end
end)
