

citysmall = {}

citysmall.location = vector3(-1500.3103027344,-216.56127929688,47.889362335205)

RegisterServerEvent("CitySmall:BuyWeapon")
AddEventHandler('CitySmall:BuyWeapon', function(price, hash)
    local source = source
    userid = Sentry.getUserId(source)
    local coords = citysmall.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if Sentry.getInventoryWeight(userid) <= 25 then

            if Sentry.tryPayment(userid, price) then
                GiveWeaponToPed(source, hash, 250, false, false)
                TriggerClientEvent("IFN:PlaySound", source, 1)
                Sentryclient.notify(source, {"~g~Paid ".. '£' ..tostring(price)})
            else 
                Sentryclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("IFN:PlaySound", source, 2)
            end

        else
            Sentryclient.notify(source,{'~r~Not enough Weight.'})
            TriggerClientEvent("IFN:PlaySound", source, 2)
        end
    else 
        Sentry.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)


RegisterServerEvent("CitySmall:BuyArmour")
AddEventHandler('CitySmall:BuyArmour', function()
    local source = source
    userid = Sentry.getUserId(source)
    local coords = citysmall.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
 
        
        if Sentry.tryPayment(userid, 25000) then
            SetPedArmour(source, 25)
            TriggerClientEvent("IFN:PlaySound", source, 1)
            Sentryclient.notify(source, {"~g~Paid ".. '£25,000'})
        else 
            Sentryclient.notify(source, {"~r~Not enough money."})
            TriggerClientEvent("IFN:PlaySound", source, 2)
        end

    else 
        Sentry.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

