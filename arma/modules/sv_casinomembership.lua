RegisterNetEvent('ARMA:purchaseHighRollersMembership')
AddEventHandler('ARMA:purchaseHighRollersMembership', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if not ARMA.hasGroup(user_id, 'Highroller') then
        if ARMA.tryFullPayment(user_id,10000000) then
            ARMA.addUserGroup(user_id, 'Highroller')
            ARMAclient.notify(source, {'~g~You have purchased the ~b~High Rollers ~g~membership.'})
        else
            ARMAclient.notify(source, {'~r~You do not have enough money to purchase this membership.'})
        end
    else
        ARMAclient.notify(source, {"~r~You already have High Roller's License."})
    end
end)

RegisterNetEvent('ARMA:removeHighRollersMembership')
AddEventHandler('ARMA:removeHighRollersMembership', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'Highroller') then
        ARMA.removeUserGroup(user_id, 'Highroller')
    else
        ARMAclient.notify(source, {"~r~You do not have High Roller's License."})
    end
end)