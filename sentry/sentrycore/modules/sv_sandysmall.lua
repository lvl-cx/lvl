

sandysmall = {}

sandysmall.location = vector3(2436.9794921875,4966.5571289062,42.347602844238)

RegisterServerEvent("SandySmall:BuyWeapon")
AddEventHandler('SandySmall:BuyWeapon', function(price, hash)
    local source = source
    userid = Sentry.getUserId(source)
    local coords = sandysmall.location
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

RegisterServerEvent("SandySmall")
AddEventHandler('SandySmall', function()
    local source = source
    userid = Sentry.getUserId(source)
    local coords = sandysmall.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
 
        
        if Sentry.tryPayment(userid, 25000) then
            SetPedArmour(source, 25)
            TriggerClientEvent("Sentry:PlaySound", source, 1)
            Sentryclient.notify(source, {"~g~Paid ".. '£25,000'})
        else 
            Sentryclient.notify(source, {"~r~Not enough money."})
            TriggerClientEvent("Sentry:PlaySound", source, 2)
        end

    else 
        Sentry.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)
