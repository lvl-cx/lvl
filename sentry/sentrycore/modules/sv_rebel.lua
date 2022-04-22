
rebel = {}

rebel.location = vector3(1545.2042236328,6332.3295898438,24.078683853149)

RegisterServerEvent("Rebel:BuyWeapon")
AddEventHandler('Rebel:BuyWeapon', function(price, hash)
    local source = source
    userid = Sentry.getUserId(source)
    local coords = rebel.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if Sentry.hasPermission(userid, 'rebel.whitelist') then
        
            if Sentry.tryPayment(userid, price) then
                GiveWeaponToPed(source, hash, 250, false, false)
                TriggerClientEvent("Sentry:PlaySound", source, 1)
                Sentryclient.notify(source, {"~g~Paid ".. '£' ..tostring(price)})
            else 
                Sentryclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("Sentry:PlaySound", source, 2)
            end

        else
            Sentryclient.notify(source,{'~r~You do not have Rebel License.'})
            TriggerClientEvent("Sentry:PlaySound", source, 2)
        end
    else 
        Sentry.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

RegisterServerEvent("Rebel:BuyArmour")
AddEventHandler('Rebel:BuyArmour', function()
    local source = source
    userid = Sentry.getUserId(source)
    local coords = rebel.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if Sentry.hasPermission(userid, 'rebel.whitelist') then
        
            if Sentry.tryPayment(userid, 100000) then
                SetPedArmour(source, 96)
                TriggerClientEvent("Sentry:PlaySound", source, 1)
                Sentryclient.notify(source, {"~g~Purchased Level 4 Armour. Paid £" .. '100,000'})
                TriggerClientEvent('Sentry:SetVest', source)
            else 
                Sentryclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("Sentry:PlaySound", source, 2)
            end

        else
            Sentryclient.notify(source,{'~r~You do not have Rebel License.'})
            TriggerClientEvent("Sentry:PlaySound", source, 2)
        end
    else 
        Sentry.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)




