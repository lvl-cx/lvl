
RegisterNetEvent('Sentry:GatherCocaine')
AddEventHandler('Sentry:GatherCocaine', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = Sentry.getUserId(source)
      if #(playerCoords - vector3(Drugs.Cocaine.Gather.x,Drugs.Cocaine.Gather.y,Drugs.Cocaine.Gather.z)) <= Drugs.Cocaine.Gather.radius then 
        if user_id ~= nil and Sentry.hasPermission(user_id, "cocaine.job") then
          local amount = 5
          local item = 1.00
          local new_weight = Sentry.getInventoryWeight(user_id)+(item*amount)
          if new_weight > Sentry.getInventoryMaxWeight(user_id) then
            Sentryclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              Sentry.giveInventoryItem(user_id, 'coca', 5, true)
          end
        else
          Sentryclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('Sentry:ProcessCocaine')
AddEventHandler('Sentry:ProcessCocaine', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = Sentry.getUserId(source)
    if #(playerCoords - vector3(Drugs.Cocaine.Process.x,Drugs.Cocaine.Process.y,Drugs.Cocaine.Process.z)) <= Drugs.Cocaine.Process.radius then 
      if Sentry.hasPermission(user_id, "cocaine.job") then 
          if Sentry.getInventoryItemAmount(user_id, 'coca') >= 5 then

            if Sentry.getInventoryItemAmount(user_id, 'coca') >= 5 then
              Sentry.tryGetInventoryItem(user_id, 'coca', 5, true)
              Sentry.giveInventoryItem(user_id, 'cocaine', 1, true)

            end
          else
            Sentryclient.notify(source, {"~r~You do not have that much Coca Leaf."})
          end
      else
        Sentryclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

local commision = 0
local finalID = nil
RegisterNetEvent('Sentry:SellCocaine')
AddEventHandler('Sentry:SellCocaine', function()
    local user_id = Sentry.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Cocaine.Sell.x,Drugs.Cocaine.Sell.y,Drugs.Cocaine.Sell.z)) <= 5.0 then 
      if Sentry.tryGetInventoryItem(user_id,'cocaine', 1) then
        if user_id ~= nil then

          local price = 500 -- [Per Piece Price]
          finalCommision = price * (commision / 100)
          Sentry.giveMoney(user_id,price+finalCommision)
  
          Sentryclient.notify(source, {"~g~Sold 1 cocaine for £" .. tostring(price - finalCommision) .. " ~w~+" .. commision .. "% Commision!"})
  
          if finalID ~= nil then
            Sentry.giveBankMoney(Sentry.getUserId(finalID),finalCommision)
            Sentryclient.notify(finalID,{"~g~You have been given ~w~£" .. finalCommision.. "~g~."})
          end

        end
      end
    end
end)

function SendCocaine(som, userid2)
  commision = som 
  finalID = userid2
end
