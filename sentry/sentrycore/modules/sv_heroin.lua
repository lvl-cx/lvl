
RegisterNetEvent('Sentry:GatherHeroin')
AddEventHandler('Sentry:GatherHeroin', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = Sentry.getUserId(source)
      if #(playerCoords - vector3(Drugs.Heroin.Gather.x,Drugs.Heroin.Gather.y,Drugs.Heroin.Gather.z)) <= Drugs.Heroin.Gather.radius then 
        if user_id ~= nil and Sentry.hasPermission(user_id, "heroin.job") then
          local amount = 5
          local item = 1.00
          local new_weight = Sentry.getInventoryWeight(user_id)+(item*amount)
          if new_weight > Sentry.getInventoryMaxWeight(user_id) then
            Sentryclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              Sentry.giveInventoryItem(user_id, 'opium', 5, true)
          end
        else
          Sentryclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('Sentry:ProcessHeroin')
AddEventHandler('Sentry:ProcessHeroin', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = Sentry.getUserId(source)
    if #(playerCoords - vector3(Drugs.Heroin.Process.x,Drugs.Heroin.Process.y,Drugs.Heroin.Process.z)) <= Drugs.Heroin.Process.radius then 
      if Sentry.hasPermission(user_id, "heroin.job") then 
          if Sentry.getInventoryItemAmount(user_id, 'opium') >= 5 then

            if Sentry.getInventoryItemAmount(user_id, 'opium') >= 5 then
              Sentry.tryGetInventoryItem(user_id, 'opium', 5, true)
              Sentry.giveInventoryItem(user_id, 'heroin', 1, true)

            end
          else
            Sentryclient.notify(source, {"~r~You do not have that much Opium."})
          end
      else
        Sentryclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

local commision = 0
local finalID = nil
RegisterNetEvent('Sentry:SellHeroin')
AddEventHandler('Sentry:SellHeroin', function()
    local user_id = Sentry.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Heroin.Sell.x,Drugs.Heroin.Sell.y,Drugs.Heroin.Sell.z)) <= 5.0 then 
      if Sentry.tryGetInventoryItem(user_id,'heroin', 1) then
        if user_id ~= nil then

          local price = 20000 -- [Per Piece Price]
          finalCommision = price * (commision / 100)
          Sentry.giveMoney(user_id,price+finalCommision)
  
          Sentryclient.notify(source, {"~g~Sold 1 heroin for £" .. tostring(price - finalCommision) .. " ~w~+" .. commision .. "% Commision!"})
  
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

function SendHeroin(som, userid2)
  commision = som 
  finalID = userid2
  TriggerClientEvent('HeroinrecieveTurf', -1, tostring(commision))
end
