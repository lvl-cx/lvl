
RegisterNetEvent('LVL:GatherLSD')
AddEventHandler('LVL:GatherLSD', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = LVL.getUserId(source)
      if #(playerCoords - vector3(Drugs.LSD.Gather.x,Drugs.LSD.Gather.y,Drugs.LSD.Gather.z)) <= Drugs.LSD.Gather.radius then 
        if user_id ~= nil and LVL.hasPermission(user_id, "lsd.job") then
          local amount = 5
          local item = 1.00
          local new_weight = LVL.getInventoryWeight(user_id)+(item*amount)
          if new_weight > LVL.getInventoryMaxWeight(user_id) then
            LVLclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              LVL.giveInventoryItem(user_id, 'acid', 5, true)
          end
        else
          LVLclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('LVL:ProcessLSD')
AddEventHandler('LVL:ProcessLSD', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = LVL.getUserId(source)
    if #(playerCoords - vector3(Drugs.LSD.Process.x,Drugs.LSD.Process.y,Drugs.LSD.Process.z)) <= Drugs.LSD.Process.radius then 
      if LVL.hasPermission(user_id, "lsd.job") then 
          if LVL.getInventoryItemAmount(user_id, 'acid') >= 5 then

            if LVL.getInventoryItemAmount(user_id, 'acid') >= 5 then
              LVL.tryGetInventoryItem(user_id, 'acid', 5, true)
              LVL.giveInventoryItem(user_id, 'lsd', 1, true)

            end
          else
            LVLclient.notify(source, {"~r~You do not have that much Lysergic Acid."})
          end
      else
        LVLclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

local commision = 0
local finalID = nil
RegisterNetEvent('LVL:SellLSD')
AddEventHandler('LVL:SellLSD', function()
    local user_id = LVL.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.LSD.Sell.x,Drugs.LSD.Sell.y,Drugs.LSD.Sell.z)) <= 5.0 then 
      if LVL.tryGetInventoryItem(user_id,'lsd', 1) then
        if user_id ~= nil then

          local price = 40000 -- [Per Piece Price]
          finalCommision = price * (commision / 100)
          LVL.giveMoney(user_id,price+finalCommision)
  
          LVLclient.notify(source, {"~g~Sold 1 LSD for £" .. tostring(price - finalCommision) .. " +" .. commision .. "% Commision!"})
  
          if finalID ~= nil then
            exports['ghmattimysql']:execute("SELECT * FROM ganginfo WHERE userid = @uid", {uid = LVL.getUserId(finalID)}, function(result)
              fundsavailable = result
              for k,v in pairs(fundsavailable) do 
                  AvailableGangFunds = v.gangfunds
      
                  local moneyleft = AvailableGangFunds + finalCommision
                  exports.ghmattimysql:execute("UPDATE ganginfo SET gangfunds = @money WHERE userid = @userid", {money = moneyleft, userid = LVL.getUserId(finalID)})
      
              end
            end)
            LVLclient.notify(finalID,{"~g~You have been given £" .. finalCommision.. "~g~."})
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
