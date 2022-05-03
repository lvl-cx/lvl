
RegisterNetEvent('LVL:GatherGold')
AddEventHandler('LVL:GatherGold', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = LVL.getUserId(source)
      if #(playerCoords - vector3(Drugs.Gold.Gather.x,Drugs.Gold.Gather.y,Drugs.Gold.Gather.z)) <= Drugs.Gold.Gather.radius then 
        if user_id ~= nil and LVL.hasPermission(user_id, "gold.job") then
          local amount = 5
          local item = 1.00
          local new_weight = LVL.getInventoryWeight(user_id)+(item*amount)
          if new_weight > LVL.getInventoryMaxWeight(user_id) then
            LVLclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              LVL.giveInventoryItem(user_id, 'golddust', 5, true)
          end
        else
          LVLclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('LVL:ProcessGold')
AddEventHandler('LVL:ProcessGold', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = LVL.getUserId(source)
    if #(playerCoords - vector3(Drugs.Gold.Process.x,Drugs.Gold.Process.y,Drugs.Gold.Process.z)) <= Drugs.Gold.Process.radius then 
      if LVL.hasPermission(user_id, "gold.job") then 
          if LVL.getInventoryItemAmount(user_id, 'golddust') >= 5 then

            if LVL.getInventoryItemAmount(user_id, 'golddust') >= 5 then
              LVL.tryGetInventoryItem(user_id, 'golddust', 5, true)
              LVL.giveInventoryItem(user_id, 'gold', 1, true)

            end
          else
            LVLclient.notify(source, {"~r~You do not have that much Gold Dust."})
          end
      else
        LVLclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

RegisterNetEvent('LVL:SellGold')
AddEventHandler('LVL:SellGold', function()
    local user_id = LVL.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Gold.Sell.x,Drugs.Gold.Sell.y,Drugs.Gold.Sell.z)) <= 5.0 then 
      if LVL.tryGetInventoryItem(user_id,'gold', 1) then
        if user_id ~= nil then

        local price = 2500 -- [Per Piece Price]
        LVL.giveMoney(user_id,price)

        LVLclient.notify(source, {"~b~Successfully sold 1 gold for £" .. price})

        end
      end
    end
end)
