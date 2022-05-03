
RegisterNetEvent('LVL:GatherDiamond')
AddEventHandler('LVL:GatherDiamond', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = LVL.getUserId(source)
      if #(playerCoords - vector3(Drugs.Diamond.Gather.x,Drugs.Diamond.Gather.y,Drugs.Diamond.Gather.z)) <= Drugs.Diamond.Gather.radius then 
        if user_id ~= nil and LVL.hasPermission(user_id, "diamond.job") then
          local amount = 5
          local item = 1.00
          local new_weight = LVL.getInventoryWeight(user_id)+(item*amount)
          if new_weight > LVL.getInventoryMaxWeight(user_id) then
            LVLclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              LVL.giveInventoryItem(user_id, 'crystal', 5, true)
          end
        else
          LVLclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('LVL:ProcessDiamond')
AddEventHandler('LVL:ProcessDiamond', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = LVL.getUserId(source)
    if #(playerCoords - vector3(Drugs.Diamond.Process.x,Drugs.Diamond.Process.y,Drugs.Diamond.Process.z)) <= Drugs.Diamond.Process.radius then 
      if LVL.hasPermission(user_id, "diamond.job") then 
          if LVL.getInventoryItemAmount(user_id, 'crystal') >= 5 then

            if LVL.getInventoryItemAmount(user_id, 'crystal') >= 5 then
              LVL.tryGetInventoryItem(user_id, 'crystal', 5, true)
              LVL.giveInventoryItem(user_id, 'diamond', 1, true)

            end
          else
            LVLclient.notify(source, {"~r~You do not have that much Diamond Crystal."})
          end
      else
        LVLclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

RegisterNetEvent('LVL:SellDiamond')
AddEventHandler('LVL:SellDiamond', function()
    local user_id = LVL.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Diamond.Sell.x,Drugs.Diamond.Sell.y,Drugs.Diamond.Sell.z)) <= 5.0 then 
      if LVL.tryGetInventoryItem(user_id,'diamond', 1) then
        if user_id ~= nil then

        local price = 10000 -- [Per Piece Price]
        LVL.giveMoney(user_id,price)

        LVLclient.notify(source, {"~b~Successfully sold 1 diamond for £" .. price})

        end
      end
    end
end)
