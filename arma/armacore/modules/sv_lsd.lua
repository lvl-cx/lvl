
RegisterNetEvent('ARMA:GatherLSD')
AddEventHandler('ARMA:GatherLSD', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = ARMA.getUserId(source)
      if #(playerCoords - vector3(Drugs.LSD.Gather.x,Drugs.LSD.Gather.y,Drugs.LSD.Gather.z)) <= Drugs.LSD.Gather.radius then 
        if user_id ~= nil and ARMA.hasPermission(user_id, "lsd.job") then
          local amount = 5
          local item = 1.00
          local new_weight = ARMA.getInventoryWeight(user_id)+(item*amount)
          if new_weight > ARMA.getInventoryMaxWeight(user_id) then
            ARMAclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              ARMA.giveInventoryItem(user_id, 'acid', 5, true)
          end
        else
          ARMAclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('ARMA:ProcessLSD')
AddEventHandler('ARMA:ProcessLSD', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = ARMA.getUserId(source)
    if #(playerCoords - vector3(Drugs.LSD.Process.x,Drugs.LSD.Process.y,Drugs.LSD.Process.z)) <= Drugs.LSD.Process.radius then 
      if ARMA.hasPermission(user_id, "lsd.job") then 
          if ARMA.getInventoryItemAmount(user_id, 'acid') >= 5 then

            if ARMA.getInventoryItemAmount(user_id, 'acid') >= 5 then
              ARMA.tryGetInventoryItem(user_id, 'acid', 5, true)
              ARMA.giveInventoryItem(user_id, 'lsd', 1, true)

            end
          else
            ARMAclient.notify(source, {"~r~You do not have that much Lysergic Acid."})
          end
      else
        ARMAclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

local commision = 0
local finalID = nil
RegisterNetEvent('ARMA:SellLSD')
AddEventHandler('ARMA:SellLSD', function()
    local user_id = ARMA.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.LSD.Sell.x,Drugs.LSD.Sell.y,Drugs.LSD.Sell.z)) <= 5.0 then 
      if ARMA.tryGetInventoryItem(user_id,'lsd', 1) then
        if user_id ~= nil then

          local price = 40000 -- [Per Piece Price]
          finalCommision = price * (commision / 100)
          ARMA.giveMoney(user_id,price+finalCommision)
  
          ARMAclient.notify(source, {"~g~Sold 1 LSD for £" .. tostring(price - finalCommision) .. " +" .. commision .. "% Commision!"})
  
          if finalID ~= nil then
            exports['ghmattimysql']:execute("SELECT * FROM ganginfo WHERE userid = @uid", {uid = ARMA.getUserId(finalID)}, function(result)
              fundsavailable = result
              for k,v in pairs(fundsavailable) do 
                  AvailableGangFunds = v.gangfunds
      
                  local moneyleft = AvailableGangFunds + finalCommision
                  exports.ghmattimysql:execute("UPDATE ganginfo SET gangfunds = @money WHERE userid = @userid", {money = moneyleft, userid = ARMA.getUserId(finalID)})
      
              end
            end)
            ARMAclient.notify(finalID,{"~g~You have been given £" .. finalCommision.. "~g~."})
          end

        end
      end
    end
end)

function SendLSD(som, userid2)
  commision = som 
  finalID = userid2
  TriggerClientEvent('LSDrecieveTurf', tostring(commision))
end
