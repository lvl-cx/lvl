
licensecentre = {}

licensecentre.location = vector3(-533.50732421875,-193.56317138672,38.222358703613)

RegisterServerEvent("LicenseCentre:BuyGroup")
AddEventHandler('LicenseCentre:BuyGroup', function(price, job, name, priceshow)
    local source = source
    userid = Sentry.getUserId(source)
    local coords = licensecentre.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then
        if Sentry.hasGroup(userid, job) then 
            Sentryclient.notify(source, {"~o~You have already purchased this license!"})
            TriggerClientEvent("IFN:PlaySound", source, 2)
        else
            if Sentry.tryFullPayment(userid, price) then

                Sentry.addUserGroup(userid,job)

                Sentryclient.notify(source, {"~g~Purchased " .. job .. " License for ".. '£' ..tostring(priceshow) .. " ❤️"})
                TriggerClientEvent("IFN:PlaySound", source, 1)

                else 
                Sentryclient.notify(source, {"~r~You do not have enough money to purchase this license!"})
                    TriggerClientEvent("IFN:PlaySound", source, 2)
            end
        end
    else 
        Sentry.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)



