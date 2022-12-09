
RegisterNetEvent('ARMA:GatherHeroin')
AddEventHandler('ARMA:GatherHeroin', function()
      local source = source
      Citizen.Wait(5000)
      local ped = GetPlayerPed(source)
      local playerCoords = GetEntityCoords(ped)
      local user_id = ARMA.getUserId(source)
      if #(playerCoords - vector3(Drugs.Heroin.Gather.x,Drugs.Heroin.Gather.y,Drugs.Heroin.Gather.z)) <= Drugs.Heroin.Gather.radius then 
        if user_id ~= nil and ARMA.hasPermission(user_id, "heroin.job") then
          local amount = 5
          local item = 1.00
          local new_weight = ARMA.getInventoryWeight(user_id)+(item*amount)
          if new_weight > ARMA.getInventoryMaxWeight(user_id) then
            ARMAclient.notify(source,{"~r~Not enough space in inventory."})
          else    
              ARMA.giveInventoryItem(user_id, 'opium', 5, true)
          end
        else
          ARMAclient.notify(source,{"~r~You do not have the correct license."})
        end
      end
    
end)

RegisterNetEvent('ARMA:ProcessHeroin')
AddEventHandler('ARMA:ProcessHeroin', function()
    local source = source
    Citizen.Wait(5000)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local user_id = ARMA.getUserId(source)
    if #(playerCoords - vector3(Drugs.Heroin.Process.x,Drugs.Heroin.Process.y,Drugs.Heroin.Process.z)) <= Drugs.Heroin.Process.radius then 
      if ARMA.hasPermission(user_id, "heroin.job") then 
          if ARMA.getInventoryItemAmount(user_id, 'opium') >= 5 then

            if ARMA.getInventoryItemAmount(user_id, 'opium') >= 5 then
              ARMA.tryGetInventoryItem(user_id, 'opium', 5, true)
              ARMA.giveInventoryItem(user_id, 'heroin', 1, true)

            end
          else
            ARMAclient.notify(source, {"~r~You do not have that much Opium."})
          end
      else
        ARMAclient.notify(source,{"~r~You do not have the correct license."})
      end
    end
end)

local commision = 0
local gangname = nil
RegisterNetEvent('ARMA:SellHeroin')
AddEventHandler('ARMA:SellHeroin', function()
    local user_id = ARMA.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(Drugs.Heroin.Sell.x,Drugs.Heroin.Sell.y,Drugs.Heroin.Sell.z)) <= 5.0 then 
      if ARMA.tryGetInventoryItem(user_id,'heroin', 1) then
        if user_id ~= nil then

          local price = 20000 -- [Per Piece Price]
          finalCommision = price * (commision / 100)
          ARMA.giveMoney(user_id,price+finalCommision)
  
          ARMAclient.notify(source, {"~g~Sold 1 heroin for £" .. tostring(price - finalCommision) .. " +" .. commision .. "% Commision!"})
  
          if gangname ~= nil then
            exports['ghmattimysql']:execute("SELECT * FROM arma_gangs WHERE gangname = @gangname", {gangname = gangname}, function(result)
              AvailableGangFunds = v.funds
              local moneyleft = AvailableGangFunds + finalCommision
              exports.ghmattimysql:execute("UPDATE arma_gangs SET funds = @money WHERE gangname = @gangname", {money = moneyleft, gangname = gangname})
            end)
            ARMAclient.notify(finalID,{"~g~You have been given £" .. finalCommision.. "~g~."})
          end

        end
      end
    end
end)

function SendHeroin(som, a)
  commision = som 
  userid = ARMA.getUserId(a)
  exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
      for K,V in pairs(gotGangs) do
          local array = json.decode(V.gangmembers)
          for I,L in pairs(array) do
              if tostring(userid) == I then
                  gangname = V.gangname
                  break
              end
          end
      end
  end)
  TriggerClientEvent('HeroinrecieveTurf', -1, tostring(commision))
end
