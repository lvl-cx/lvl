
RegisterNetEvent('ARMA:GatherWeed')
AddEventHandler('ARMA:GatherWeed', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = ARMA.getUserId(source)
      if #(playerCoords - vector3(Drugs.Weed.Gather.x,Drugs.Weed.Gather.y,Drugs.Weed.Gather.z)) <= Drugs.Weed.Gather.radius then 
        if user_id ~= nil and ARMA.hasPermission(user_id, "weed.job") then
          local amount = 5
          local item = 1.00
          local new_weight = ARMA.getInventoryWeight(user_id)+(item*amount)
          if new_weight > ARMA.getInventoryMaxWeight(user_id) then
            ARMAclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              ARMA.giveInventoryItem(user_id, 'cannabis', 5, true)
          end
        else
          ARMAclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('ARMA:ProcessWeed')
AddEventHandler('ARMA:ProcessWeed', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = ARMA.getUserId(source)
    if #(playerCoords - vector3(Drugs.Weed.Process.x,Drugs.Weed.Process.y,Drugs.Weed.Process.z)) <= Drugs.Weed.Process.radius then 
      if ARMA.hasPermission(user_id, "weed.job") then 
          if ARMA.getInventoryItemAmount(user_id, 'cannabis') >= 5 then

            if ARMA.getInventoryItemAmount(user_id, 'cannabis') >= 5 then
              ARMA.tryGetInventoryItem(user_id, 'cannabis', 5, true)
              ARMA.giveInventoryItem(user_id, 'weed', 1, true)

            end
          else
            ARMAclient.notify(source, {"~r~You do not have that much Cannabis Sativa."})
          end
      else
        ARMAclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

local commision = 0
local finalID = nil
RegisterNetEvent('ARMA:SellWeed')
AddEventHandler('ARMA:SellWeed', function()
    local user_id = ARMA.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Weed.Sell.x,Drugs.Weed.Sell.y,Drugs.Weed.Sell.z)) <= 5.0 then 
      if ARMA.tryGetInventoryItem(user_id,'weed', 1) then
        if user_id ~= nil then

        local price = 500 -- [Per Piece Price]
        finalCommision = price * (commision / 100)
        ARMA.giveMoney(user_id,price+finalCommision)

        ARMAclient.notify(source, {"~g~Sold 1 weed for £" .. tostring(price - finalCommision) .. " +" .. commision .. "% Commision!"})

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

function SendWeed(som, userid2)
  commision = som 
  finalID = userid2
  TriggerClientEvent('WeedrecieveTurf', -1, tostring(commision))
end