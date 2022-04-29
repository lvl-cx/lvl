
RegisterNetEvent('Sentry:GatherWeed')
AddEventHandler('Sentry:GatherWeed', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = Sentry.getUserId(source)
      if #(playerCoords - vector3(Drugs.Weed.Gather.x,Drugs.Weed.Gather.y,Drugs.Weed.Gather.z)) <= Drugs.Weed.Gather.radius then 
        if user_id ~= nil and Sentry.hasPermission(user_id, "weed.job") then
          local amount = 5
          local item = 1.00
          local new_weight = Sentry.getInventoryWeight(user_id)+(item*amount)
          if new_weight > Sentry.getInventoryMaxWeight(user_id) then
            Sentryclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              Sentry.giveInventoryItem(user_id, 'cannabis', 5, true)
          end
        else
          Sentryclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('Sentry:ProcessWeed')
AddEventHandler('Sentry:ProcessWeed', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = Sentry.getUserId(source)
    if #(playerCoords - vector3(Drugs.Weed.Process.x,Drugs.Weed.Process.y,Drugs.Weed.Process.z)) <= Drugs.Weed.Process.radius then 
      if Sentry.hasPermission(user_id, "weed.job") then 
          if Sentry.getInventoryItemAmount(user_id, 'cannabis') >= 5 then

            if Sentry.getInventoryItemAmount(user_id, 'cannabis') >= 5 then
              Sentry.tryGetInventoryItem(user_id, 'cannabis', 5, true)
              Sentry.giveInventoryItem(user_id, 'weed', 1, true)

            end
          else
            Sentryclient.notify(source, {"~r~You do not have that much Cannabis Sativa."})
          end
      else
        Sentryclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

local commision = 0
local finalID = nil
RegisterNetEvent('Sentry:SellWeed')
AddEventHandler('Sentry:SellWeed', function()
    local user_id = Sentry.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Weed.Sell.x,Drugs.Weed.Sell.y,Drugs.Weed.Sell.z)) <= 5.0 then 
      if Sentry.tryGetInventoryItem(user_id,'weed', 1) then
        if user_id ~= nil then

        local price = 500 -- [Per Piece Price]
        finalCommision = price * (commision / 100)
        Sentry.giveMoney(user_id,price+finalCommision)

        Sentryclient.notify(source, {"~g~Sold 1 weed for £" .. tostring(price - finalCommision) .. " ~w~+" .. commision .. "% Commision!"})

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

function SendWeed(som, userid2)
  commision = som 
  finalID = userid2
  TriggerClientEvent('WeedrecieveTurf', -1, tostring(commision))
end