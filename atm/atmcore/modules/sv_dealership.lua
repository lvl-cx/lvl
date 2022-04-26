
RegisterNetEvent('sendPD')
AddEventHandler('sendPD', function()
    user_id = ATM.getUserId(source)
    if ATM.hasPermission(user_id, 'police.menu') then 
        TriggerClientEvent('returnPd2', source, true)
    else
        TriggerClientEvent('returnPd2', source, false)
    end
end)

RegisterNetEvent('whoIs')
AddEventHandler('whoIs', function(vehicle, price)
    local source = source
    local user_id = ATM.getUserId(source)
    local correctcar = false 
    local wrongprice = false 
    local player = source
    local user_id = ATM.getUserId(source)
    local playerName = GetPlayerName(source)   


 
        MySQL.query("ATM/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
            if #pvehicle > 0 then
                ATMclient.notify(player,{"~r~Vehicle already owned."})
                TriggerClientEvent("ATM:PlaySound", player, 2)
            else

                if ATM.tryFullPayment(user_id, price) then
                ATM.getUserIdentity(user_id, function(identity)
                    MySQL.execute("ATM/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = "P "..identity.registration})
                end)

                    ATMclient.notify(player,{"You paid ~g~£"..price.."~w~."})
                    TriggerClientEvent("ATM:PlaySound", player, 1)
                    
                else
                    ATMclient.notify(player,{"~r~Not enough money."})
                    TriggerClientEvent("ATM:PlaySound", player, 2)
                end
            end
        end)
   
end)