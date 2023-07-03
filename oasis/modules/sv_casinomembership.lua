RegisterNetEvent('OASIS:purchaseHighRollersMembership')
AddEventHandler('OASIS:purchaseHighRollersMembership', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if not OASIS.hasGroup(user_id, 'Highroller') then
        if OASIS.tryFullPayment(user_id,10000000) then
            OASIS.addUserGroup(user_id, 'Highroller')
            OASISclient.notify(source, {'~g~You have purchased the ~b~High Rollers ~g~membership.'})
            tOASIS.sendWebhook('purchase-highrollers',"OASIS Purchased Highrollers Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**")
        else
            OASISclient.notify(source, {'~r~You do not have enough money to purchase this membership.'})
        end
    else
        OASISclient.notify(source, {"~r~You already have High Roller's License."})
    end
end)

RegisterNetEvent('OASIS:removeHighRollersMembership')
AddEventHandler('OASIS:removeHighRollersMembership', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasGroup(user_id, 'Highroller') then
        OASIS.removeUserGroup(user_id, 'Highroller')
    else
        OASISclient.notify(source, {"~r~You do not have High Roller's License."})
    end
end)