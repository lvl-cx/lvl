
RegisterNetEvent('sendPD')
AddEventHandler('sendPD', function()
    user_id = Sentry.getUserId(source)
    if Sentry.hasPermission(user_id, 'police.menu') then 
        TriggerClientEvent('returnPd2', source, true)
    else
        TriggerClientEvent('returnPd2', source, false)
    end
end)

RegisterNetEvent('whoIs')
AddEventHandler('whoIs', function(vehicle, price)
    local source = source
    local user_id = Sentry.getUserId(source)
    local correctcar = false 
    local wrongprice = false 
    local player = source
    local user_id = Sentry.getUserId(source)
    local playerName = GetPlayerName(source)   


 
        MySQL.query("Sentry/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
            if #pvehicle > 0 then
                Sentryclient.notify(player,{"~r~Vehicle already owned."})
                TriggerClientEvent("Sentry:PlaySound", player, 2)
            else

                if Sentry.tryFullPayment(user_id, price) then
                Sentry.getUserIdentity(user_id, function(identity)
                    MySQL.execute("Sentry/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = "P "..identity.registration})
                end)

                    Sentryclient.notify(player,{"You paid ~g~£"..price.."~w~."})
                    TriggerClientEvent("Sentry:PlaySound", player, 1)
                    
                else
                    Sentryclient.notify(player,{"~r~Not enough money."})
                    TriggerClientEvent("Sentry:PlaySound", player, 2)
                end
            end
        end)
   
end)