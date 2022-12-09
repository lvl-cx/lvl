
RegisterNetEvent('ARMA:GatherDiamond')
AddEventHandler('ARMA:GatherDiamond', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = ARMA.getUserId(source)
      if #(playerCoords - vector3(Drugs.Diamond.Gather.x,Drugs.Diamond.Gather.y,Drugs.Diamond.Gather.z)) <= Drugs.Diamond.Gather.radius then 
        if user_id ~= nil and ARMA.hasPermission(user_id, "diamond.job") then
          local amount = 5
          local item = 1.00
          local new_weight = ARMA.getInventoryWeight(user_id)+(item*amount)
          if new_weight > ARMA.getInventoryMaxWeight(user_id) then
            ARMAclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              ARMA.giveInventoryItem(user_id, 'crystal', 5, true)
          end
        else
          ARMAclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('ARMA:ProcessDiamond')
AddEventHandler('ARMA:ProcessDiamond', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = ARMA.getUserId(source)
    if #(playerCoords - vector3(Drugs.Diamond.Process.x,Drugs.Diamond.Process.y,Drugs.Diamond.Process.z)) <= Drugs.Diamond.Process.radius then 
      if ARMA.hasPermission(user_id, "diamond.job") then 
          if ARMA.getInventoryItemAmount(user_id, 'crystal') >= 5 then

            if ARMA.getInventoryItemAmount(user_id, 'crystal') >= 5 then
              ARMA.tryGetInventoryItem(user_id, 'crystal', 5, true)
              ARMA.giveInventoryItem(user_id, 'diamond', 1, true)

            end
          else
            ARMAclient.notify(source, {"~r~You do not have that much Diamond Crystal."})
          end
      else
        ARMAclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

RegisterNetEvent('ARMA:SellDiamond')
AddEventHandler('ARMA:SellDiamond', function()
    local user_id = ARMA.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Diamond.Sell.x,Drugs.Diamond.Sell.y,Drugs.Diamond.Sell.z)) <= 5.0 then 
      if ARMA.tryGetInventoryItem(user_id,'diamond', 1) then
        if user_id ~= nil then

        local price = 10000 -- [Per Piece Price]
        ARMA.giveMoney(user_id,price)

        ARMAclient.notify(source, {"~g~Successfully sold 1 diamond for £" .. price})

        end
      end
    end
end)
