
RegisterNetEvent('ATM:GatherDiamond')
AddEventHandler('ATM:GatherDiamond', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = ATM.getUserId(source)
      if #(playerCoords - vector3(Drugs.Diamond.Gather.x,Drugs.Diamond.Gather.y,Drugs.Diamond.Gather.z)) <= Drugs.Diamond.Gather.radius then 
        if user_id ~= nil and ATM.hasPermission(user_id, "diamond.job") then
          local amount = 5
          local item = 1.00
          local new_weight = ATM.getInventoryWeight(user_id)+(item*amount)
          if new_weight > ATM.getInventoryMaxWeight(user_id) then
            ATMclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              ATM.giveInventoryItem(user_id, 'crystal', 5, true)
          end
        else
          ATMclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('ATM:ProcessDiamond')
AddEventHandler('ATM:ProcessDiamond', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = ATM.getUserId(source)
    if #(playerCoords - vector3(Drugs.Diamond.Process.x,Drugs.Diamond.Process.y,Drugs.Diamond.Process.z)) <= Drugs.Diamond.Process.radius then 
      if ATM.hasPermission(user_id, "diamond.job") then 
          if ATM.getInventoryItemAmount(user_id, 'crystal') >= 5 then

            if ATM.getInventoryItemAmount(user_id, 'crystal') >= 5 then
              ATM.tryGetInventoryItem(user_id, 'crystal', 5, true)
              ATM.giveInventoryItem(user_id, 'diamond', 1, true)

            end
          else
            ATMclient.notify(source, {"~r~You do not have that much Diamond Crystal."})
          end
      else
        ATMclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

RegisterNetEvent('ATM:SellDiamond')
AddEventHandler('ATM:SellDiamond', function()
    local user_id = ATM.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Diamond.Sell.x,Drugs.Diamond.Sell.y,Drugs.Diamond.Sell.z)) <= 5.0 then 
      if ATM.tryGetInventoryItem(user_id,'diamond', 1) then
        if user_id ~= nil then

        local price = 10000 -- [Per Piece Price]
        ATM.giveMoney(user_id,price)

        ATMclient.notify(source, {"~g~Successfully sold 1 diamond for £" .. price})

        end
      end
    end
end)
