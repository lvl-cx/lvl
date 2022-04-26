
RegisterNetEvent('ATM:GatherGold')
AddEventHandler('ATM:GatherGold', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = ATM.getUserId(source)
      if #(playerCoords - vector3(Drugs.Gold.Gather.x,Drugs.Gold.Gather.y,Drugs.Gold.Gather.z)) <= Drugs.Gold.Gather.radius then 
        if user_id ~= nil and ATM.hasPermission(user_id, "gold.job") then
          local amount = 5
          local item = 1.00
          local new_weight = ATM.getInventoryWeight(user_id)+(item*amount)
          if new_weight > ATM.getInventoryMaxWeight(user_id) then
            ATMclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              ATM.giveInventoryItem(user_id, 'golddust', 5, true)
          end
        else
          ATMclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('ATM:ProcessGold')
AddEventHandler('ATM:ProcessGold', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = ATM.getUserId(source)
    if #(playerCoords - vector3(Drugs.Gold.Process.x,Drugs.Gold.Process.y,Drugs.Gold.Process.z)) <= Drugs.Gold.Process.radius then 
      if ATM.hasPermission(user_id, "gold.job") then 
          if ATM.getInventoryItemAmount(user_id, 'golddust') >= 5 then

            if ATM.getInventoryItemAmount(user_id, 'golddust') >= 5 then
              ATM.tryGetInventoryItem(user_id, 'golddust', 5, true)
              ATM.giveInventoryItem(user_id, 'gold', 1, true)

            end
          else
            ATMclient.notify(source, {"~r~You do not have that much Gold Dust."})
          end
      else
        ATMclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

RegisterNetEvent('ATM:SellGold')
AddEventHandler('ATM:SellGold', function()
    local user_id = ATM.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Gold.Sell.x,Drugs.Gold.Sell.y,Drugs.Gold.Sell.z)) <= 5.0 then 
      if ATM.tryGetInventoryItem(user_id,'gold', 1) then
        if user_id ~= nil then

        local price = 2500 -- [Per Piece Price]
        ATM.giveMoney(user_id,price)

        ATMclient.notify(source, {"~g~Successfully sold 1 gold for £" .. price})

        end
      end
    end
end)
