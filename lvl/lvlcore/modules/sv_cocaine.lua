
RegisterNetEvent('LVL:GatherCocaine')
AddEventHandler('LVL:GatherCocaine', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = LVL.getUserId(source)
      if #(playerCoords - vector3(Drugs.Cocaine.Gather.x,Drugs.Cocaine.Gather.y,Drugs.Cocaine.Gather.z)) <= Drugs.Cocaine.Gather.radius then 
        if user_id ~= nil and LVL.hasPermission(user_id, "cocaine.job") then
          local amount = 5
          local item = 1.00
          local new_weight = LVL.getInventoryWeight(user_id)+(item*amount)
          if new_weight > LVL.getInventoryMaxWeight(user_id) then
            LVLclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              LVL.giveInventoryItem(user_id, 'coca', 5, true)
          end
        else
          LVLclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('LVL:ProcessCocaine')
AddEventHandler('LVL:ProcessCocaine', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = LVL.getUserId(source)
    if #(playerCoords - vector3(Drugs.Cocaine.Process.x,Drugs.Cocaine.Process.y,Drugs.Cocaine.Process.z)) <= Drugs.Cocaine.Process.radius then 
      if LVL.hasPermission(user_id, "cocaine.job") then 
          if LVL.getInventoryItemAmount(user_id, 'coca') >= 5 then

            if LVL.getInventoryItemAmount(user_id, 'coca') >= 5 then
              LVL.tryGetInventoryItem(user_id, 'coca', 5, true)
              LVL.giveInventoryItem(user_id, 'cocaine', 1, true)

            end
          else
            LVLclient.notify(source, {"~r~You do not have that much Coca Leaf."})
          end
      else
        LVLclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

local commision = 0
local finalID = nil
RegisterNetEvent('LVL:SellCocaine')
AddEventHandler('LVL:SellCocaine', function()
    local user_id = LVL.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Cocaine.Sell.x,Drugs.Cocaine.Sell.y,Drugs.Cocaine.Sell.z)) <= 5.0 then 
      if LVL.tryGetInventoryItem(user_id,'cocaine', 1) then
        if user_id ~= nil then

          local price = 1250 -- [Per Piece Price]
          finalCommision = price * (commision / 100)
          LVL.giveMoney(user_id,price+finalCommision)
  
          LVLclient.notify(source, {"~g~Sold 1 cocaine for £" .. tostring(price - finalCommision) .. " +" .. commision .. "% Commision!"})
  
          if finalID ~= nil then
            LVL.giveBankMoney(LVL.getUserId(finalID),finalCommision)
            LVLclient.notify(finalID,{"~g~You have been given £" .. finalCommision.. "~g~."})
          end

        end
      end
    end
end)

function SendCocaine(som, userid2)
  commision = som 
  finalID = userid2
  TriggerClientEvent('CocainerecieveTurf', -1, tostring(commision))
end
