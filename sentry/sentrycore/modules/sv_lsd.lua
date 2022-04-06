
RegisterNetEvent('Sentry:GatherLSD')
AddEventHandler('Sentry:GatherLSD', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = Sentry.getUserId(source)
      if #(playerCoords - vector3(Drugs.LSD.Gather.x,Drugs.LSD.Gather.y,Drugs.LSD.Gather.z)) <= Drugs.LSD.Gather.radius then 
        if user_id ~= nil and Sentry.hasPermission(user_id, "lsd.job") then
          local amount = 5
          local item = 1.00
          local new_weight = Sentry.getInventoryWeight(user_id)+(item*amount)
          if new_weight > Sentry.getInventoryMaxWeight(user_id) then
            Sentryclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              Sentry.giveInventoryItem(user_id, 'acid', 5, true)
          end
        else
          Sentryclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('Sentry:ProcessLSD')
AddEventHandler('Sentry:ProcessLSD', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = Sentry.getUserId(source)
    if #(playerCoords - vector3(Drugs.LSD.Process.x,Drugs.LSD.Process.y,Drugs.LSD.Process.z)) <= Drugs.LSD.Process.radius then 
      if Sentry.hasPermission(user_id, "lsd.job") then 
          if Sentry.getInventoryItemAmount(user_id, 'acid') >= 5 then

            if Sentry.getInventoryItemAmount(user_id, 'acid') >= 5 then
              Sentry.tryGetInventoryItem(user_id, 'acid', 5, true)
              Sentry.giveInventoryItem(user_id, 'lsd', 1, true)

            end
          else
            Sentryclient.notify(source, {"~r~You do not have that much Lysergic Acid."})
          end
      else
        Sentryclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

local commision = 0
local finalID = nil
RegisterNetEvent('Sentry:SellLSD')
AddEventHandler('Sentry:SellLSD', function()
    local user_id = Sentry.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.LSD.Sell.x,Drugs.LSD.Sell.y,Drugs.LSD.Sell.z)) <= 5.0 then 
      if Sentry.tryGetInventoryItem(user_id,'lsd', 1) then
        if user_id ~= nil then

          local price = 500 -- [Per Piece Price]
          finalCommision = price * (commision / 100)
          Sentry.giveMoney(user_id,price+finalCommision)
  
          Sentryclient.notify(source, {"~g~Sold 1 cocaine for £" .. tostring(price - finalCommision) .. " ~w~+" .. commision .. "% Commision!"})
  
          if finalID ~= nil then
            exports['ghmattimysql']:execute("SELECT * FROM ganginfo WHERE userid = @uid", {uid = Sentry.getUserId(finalID)}, function(result)
              fundsavailable = result
              for k,v in pairs(fundsavailable) do 
                  AvailableGangFunds = v.gangfunds
      
                  local moneyleft = AvailableGangFunds + finalCommision
                  exports.ghmattimysql:execute("UPDATE ganginfo SET gangfunds = @money WHERE userid = @userid", {money = moneyleft, userid = Sentry.getUserId(finalID)})
      
              end
            end)
            Sentryclient.notify(finalID,{"~g~You have been given ~w~£" .. finalCommision.. "~g~."})
          end

        end
      end
    end
end)

function SendLSD(som, userid2)
  commision = som 
  finalID = userid2
end
