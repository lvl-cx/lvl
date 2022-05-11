
RegisterNetEvent('LVL:GatherWeed')
AddEventHandler('LVL:GatherWeed', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = LVL.getUserId(source)
      if #(playerCoords - vector3(Drugs.Weed.Gather.x,Drugs.Weed.Gather.y,Drugs.Weed.Gather.z)) <= Drugs.Weed.Gather.radius then 
        if user_id ~= nil and LVL.hasPermission(user_id, "weed.job") then
          local amount = 5
          local item = 1.00
          local new_weight = LVL.getInventoryWeight(user_id)+(item*amount)
          if new_weight > LVL.getInventoryMaxWeight(user_id) then
            LVLclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              LVL.giveInventoryItem(user_id, 'cannabis', 5, true)
          end
        else
          LVLclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('LVL:ProcessWeed')
AddEventHandler('LVL:ProcessWeed', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = LVL.getUserId(source)
    if #(playerCoords - vector3(Drugs.Weed.Process.x,Drugs.Weed.Process.y,Drugs.Weed.Process.z)) <= Drugs.Weed.Process.radius then 
      if LVL.hasPermission(user_id, "weed.job") then 
          if LVL.getInventoryItemAmount(user_id, 'cannabis') >= 5 then

            if LVL.getInventoryItemAmount(user_id, 'cannabis') >= 5 then
              LVL.tryGetInventoryItem(user_id, 'cannabis', 5, true)
              LVL.giveInventoryItem(user_id, 'weed', 1, true)

            end
          else
            LVLclient.notify(source, {"~r~You do not have that much Cannabis Sativa."})
          end
      else
        LVLclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

local commision = 0
local finalID = nil
RegisterNetEvent('LVL:SellWeed')
AddEventHandler('LVL:SellWeed', function()
    local user_id = LVL.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Weed.Sell.x,Drugs.Weed.Sell.y,Drugs.Weed.Sell.z)) <= 5.0 then 
      if LVL.tryGetInventoryItem(user_id,'weed', 1) then
        if user_id ~= nil then

        local price = 500 -- [Per Piece Price]
        finalCommision = price * (commision / 100)
        LVL.giveMoney(user_id,price+finalCommision)

        LVLclient.notify(source, {"~g~Sold 1 weed for £" .. tostring(price - finalCommision) .. " +" .. commision .. "% Commision!"})

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

function SendWeed(som, userid2)
  commision = som 
  finalID = userid2
  TriggerClientEvent('WeedrecieveTurf', -1, tostring(commision))
end