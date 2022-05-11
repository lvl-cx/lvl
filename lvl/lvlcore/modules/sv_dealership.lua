
RegisterNetEvent('sendPD')
AddEventHandler('sendPD', function()
    user_id = LVL.getUserId(source)
    if LVL.hasPermission(user_id, 'police.menu') then 
        TriggerClientEvent('returnPd2', source, true)
    else
        TriggerClientEvent('returnPd2', source, false)
    end
end)

RegisterNetEvent('whoIs')
AddEventHandler('whoIs', function(vehicle, price)
    local source = source
    local user_id = LVL.getUserId(source)
    local correctcar = false 
    local wrongprice = false 
    local player = source
    local user_id = LVL.getUserId(source)
    local playerName = GetPlayerName(source)   


 
        MySQL.query("LVL/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
            if #pvehicle > 0 then
                LVLclient.notify(player,{"~r~Vehicle already owned."})
                TriggerClientEvent("LVL:PlaySound", player, 2)
            else

                if LVL.tryFullPayment(user_id, price) then
                LVL.getUserIdentity(user_id, function(identity)
                    MySQL.execute("LVL/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = "P "..identity.registration})
                end)

                    LVLclient.notify(player,{"You paid ~g~£"..price.."."})
                    TriggerClientEvent("LVL:PlaySound", player, 1)
                    
                else
                    LVLclient.notify(player,{"~r~Not enough money."})
                    TriggerClientEvent("LVL:PlaySound", player, 2)
                end
            end
        end)
   
end)