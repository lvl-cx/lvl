

knifestore = {}

knifestore.location = vector3(-676.46417236328,-878.25500488281,24.473949432373)

RegisterServerEvent("KnifeStore:BuyWeapon")
AddEventHandler('KnifeStore:BuyWeapon', function(price, hash)
    local source = source
    userid = Sentry.getUserId(source)
    local coords = knifestore.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if Sentry.getInventoryWeight(userid) <= 25 then

            if Sentry.tryPayment(userid, price) then
                GiveWeaponToPed(source, hash, 250, false, false)
                TriggerClientEvent("Sentry:PlaySound", source, 1)
                Sentryclient.notify(source, {"~g~Paid ".. '£' ..tostring(price)})
            else 
                Sentryclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("Sentry:PlaySound", source, 2)
            end
            
        else
            Sentryclient.notify(source,{'~r~Not enough Weight.'})
            TriggerClientEvent("Sentry:PlaySound", source, 2)
        end
    else 
        Sentry.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)



