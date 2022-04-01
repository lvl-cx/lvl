

largearms = {}

largearms.location = vector3(-1111.3123779297,4937.2846679688,218.3872833252)

RegisterServerEvent("LargeArms:BuyWeapon")
AddEventHandler('LargeArms:BuyWeapon', function(price, hash)
    local source = source
    userid = Sentry.getUserId(source)
    local coords = largearms.location
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

RegisterServerEvent("LargeArms:BuyArmour")
AddEventHandler('LargeArms:BuyArmour', function()
    local source = source
    userid = Sentry.getUserId(source)
    local coords = largearms.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
 
        
        if Sentry.tryPayment(userid, 50000) then
            SetPedArmour(source, 50)
            TriggerClientEvent("Sentry:PlaySound", source, 1)
            Sentryclient.notify(source, {"~g~Paid ".. '£50,000'})
        else 
            Sentryclient.notify(source, {"~r~Not enough money."})
            TriggerClientEvent("Sentry:PlaySound", source, 2)
        end

    else 
        Sentry.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

