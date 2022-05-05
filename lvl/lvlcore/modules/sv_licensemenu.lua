
licensecentre = {}

licensecentre.location = vector3(-926.37622070312,-2037.8065185547,9.4023275375366)

RegisterServerEvent("LicenseCentre:BuyGroup")
AddEventHandler('LicenseCentre:BuyGroup', function(price, job, name, priceshow)
    local source = source
    userid = LVL.getUserId(source)
    local coords = licensecentre.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then
        if LVL.hasGroup(userid, job) then 
            LVLclient.notify(source, {"~o~You have already purchased this license!"})
            TriggerClientEvent("LVL:PlaySound", source, 2)
        else
            if LVL.tryFullPayment(userid, price) then

                LVL.addUserGroup(userid,job)

                LVLclient.notify(source, {"~g~Purchased " .. job .. " License for ".. '£' ..tostring(priceshow) .. " ❤️"})
                TriggerClientEvent("LVL:PlaySound", source, 1)

                else 
                LVLclient.notify(source, {"~r~You do not have enough money to purchase this license!"})
                    TriggerClientEvent("LVL:PlaySound", source, 2)
            end
        end
    else 
        LVL.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)



