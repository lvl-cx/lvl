
ammo = {}

ammo.location = vector3(-458.36862182617,-2274.5075683594,8.5158195495605)

RegisterServerEvent("Ammo:BuyAmmo")
AddEventHandler('Ammo:BuyAmmo', function(price, hash, amount)
    local source = source
    userid = Sentry.getUserId(source)
    local coords = ammo.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        
        
        if Sentry.tryPayment(userid, price) then
           -- GiveWeaponToPed(source, hash, 250, false, false)
            Sentry.giveInventoryItem(userid, hash, amount, false)
            TriggerClientEvent("Sentry:PlaySound", source, 1)
            Sentryclient.notify(source, {"~g~Paid ".. '£' ..tostring(price)})
        else 
            Sentryclient.notify(source, {"~r~Not enough money."})
            TriggerClientEvent("Sentry:PlaySound", source, 2)
        end


    else 
        Sentry.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)





