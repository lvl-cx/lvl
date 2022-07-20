
licensecentre = {}

licensecentre.location = vector3(-926.37622070312,-2037.8065185547,9.4023275375366)

RegisterServerEvent("LicenseCentre:BuyGroup")
AddEventHandler('LicenseCentre:BuyGroup', function(price, job, name, priceshow)
    local source = source
    local userid = ARMA.getUserId(source)
    local coords = licensecentre.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then
        if ARMA.hasGroup(userid, job) then 
            ARMAclient.notify(source, {"~o~You have already purchased this license!"})
            TriggerClientEvent("ARMA:PlaySound", source, 2)
        else
            if ARMA.tryFullPayment(userid, price) then

                ARMA.addUserGroup(userid,job)

                ARMAclient.notify(source, {"~g~Purchased " .. job .. " License for ".. '£' ..priceshow .. " ❤️"})
                TriggerClientEvent("ARMA:PlaySound", source, 1)

                else 
                ARMAclient.notify(source, {"~r~You do not have enough money to purchase this license!"})
                    TriggerClientEvent("ARMA:PlaySound", source, 2)
            end
        end
    else 
        TriggerEvent("ARMA:acBan", userid, 11, GetPlayerName(source), source, 'Trigger Lincense menu purchase')
    end
end)



