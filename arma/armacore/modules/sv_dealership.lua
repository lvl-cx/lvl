
RegisterNetEvent('sendPD')
AddEventHandler('sendPD', function()
    user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.menu') then 
        TriggerClientEvent('returnPd2', source, true)
    else
        TriggerClientEvent('returnPd2', source, false)
    end
end)

RegisterNetEvent('whoIs')
AddEventHandler('whoIs', function(vehicle, price)
    local source = source
    local user_id = ARMA.getUserId(source)
    local correctcar = false 
    local wrongprice = false 
    local player = source
    local user_id = ARMA.getUserId(source)
    local playerName = GetPlayerName(source)   


 
        MySQL.query("ARMA/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
            if #pvehicle > 0 then
                ARMAclient.notify(player,{"~r~Vehicle already owned."})
                TriggerClientEvent("ARMA:PlaySound", player, 2)
            else

                if ARMA.tryFullPayment(user_id, price) then
                ARMA.getUserIdentity(user_id, function(identity)
                    MySQL.execute("ARMA/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = "P "..identity.registration})
                end)

                    ARMAclient.notify(player,{"You paid ~g~£"..price.."."})
                    TriggerClientEvent("ARMA:PlaySound", player, 1)
                    
                else
                    ARMAclient.notify(player,{"~r~Not enough money."})
                    TriggerClientEvent("ARMA:PlaySound", player, 2)
                end
            end
        end)
   
end)