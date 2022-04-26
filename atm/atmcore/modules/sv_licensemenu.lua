
licensecentre = {}

licensecentre.location = vector3(-926.37622070312,-2037.8065185547,9.4023275375366)

RegisterServerEvent("LicenseCentre:BuyGroup")
AddEventHandler('LicenseCentre:BuyGroup', function(price, job, name, priceshow)
    local source = source
    userid = ATM.getUserId(source)
    local coords = licensecentre.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then
        if ATM.hasGroup(userid, job) then 
            ATMclient.notify(source, {"~o~You have already purchased this license!"})
            TriggerClientEvent("ATM:PlaySound", source, 2)
        else
            if ATM.tryFullPayment(userid, price) then

                ATM.addUserGroup(userid,job)

                ATMclient.notify(source, {"~g~Purchased " .. job .. " License for ".. '£' ..tostring(priceshow) .. " ❤️"})
                TriggerClientEvent("ATM:PlaySound", source, 1)

                else 
                ATMclient.notify(source, {"~r~You do not have enough money to purchase this license!"})
                    TriggerClientEvent("ATM:PlaySound", source, 2)
            end
        end
    else 
        ATM.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)



