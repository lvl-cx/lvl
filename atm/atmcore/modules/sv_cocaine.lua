
RegisterNetEvent('ATM:GatherCocaine')
AddEventHandler('ATM:GatherCocaine', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = ATM.getUserId(source)
      if #(playerCoords - vector3(Drugs.Cocaine.Gather.x,Drugs.Cocaine.Gather.y,Drugs.Cocaine.Gather.z)) <= Drugs.Cocaine.Gather.radius then 
        if user_id ~= nil and ATM.hasPermission(user_id, "cocaine.job") then
          local amount = 5
          local item = 1.00
          local new_weight = ATM.getInventoryWeight(user_id)+(item*amount)
          if new_weight > ATM.getInventoryMaxWeight(user_id) then
            ATMclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              ATM.giveInventoryItem(user_id, 'coca', 5, true)
          end
        else
          ATMclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('ATM:ProcessCocaine')
AddEventHandler('ATM:ProcessCocaine', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = ATM.getUserId(source)
    if #(playerCoords - vector3(Drugs.Cocaine.Process.x,Drugs.Cocaine.Process.y,Drugs.Cocaine.Process.z)) <= Drugs.Cocaine.Process.radius then 
      if ATM.hasPermission(user_id, "cocaine.job") then 
          if ATM.getInventoryItemAmount(user_id, 'coca') >= 5 then

            if ATM.getInventoryItemAmount(user_id, 'coca') >= 5 then
              ATM.tryGetInventoryItem(user_id, 'coca', 5, true)
              ATM.giveInventoryItem(user_id, 'cocaine', 1, true)

            end
          else
            ATMclient.notify(source, {"~r~You do not have that much Coca Leaf."})
          end
      else
        ATMclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

local commision = 0
local finalID = nil
RegisterNetEvent('ATM:SellCocaine')
AddEventHandler('ATM:SellCocaine', function()
    local user_id = ATM.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Cocaine.Sell.x,Drugs.Cocaine.Sell.y,Drugs.Cocaine.Sell.z)) <= 5.0 then 
      if ATM.tryGetInventoryItem(user_id,'cocaine', 1) then
        if user_id ~= nil then

          local price = 1250 -- [Per Piece Price]
          finalCommision = price * (commision / 100)
          ATM.giveMoney(user_id,price+finalCommision)
  
          ATMclient.notify(source, {"~g~Sold 1 cocaine for £" .. tostring(price - finalCommision) .. " ~w~+" .. commision .. "% Commision!"})
  
          if finalID ~= nil then
            ATM.giveBankMoney(ATM.getUserId(finalID),finalCommision)
            ATMclient.notify(finalID,{"~g~You have been given ~w~£" .. finalCommision.. "~g~."})
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
