
rebel = {}

rebel.location = vector3(1545.2042236328,6332.3295898438,24.078683853149)

RegisterServerEvent("Rebel:BuyWeapon")
AddEventHandler('Rebel:BuyWeapon', function(price, hash)
    local source = source
    userid = ATM.getUserId(source)
    local coords = rebel.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if ATM.hasPermission(userid, 'rebel.whitelist') then
        
            if ATM.tryPayment(userid, price) then
                GiveWeaponToPed(source, hash, 250, false, false)
                TriggerClientEvent("ATM:PlaySound", source, 1)
                ATMclient.notify(source, {"~g~Paid ".. '£' ..tostring(price)})
            else 
                ATMclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("ATM:PlaySound", source, 2)
            end

        else
            ATMclient.notify(source,{'~r~You do not have Rebel License.'})
            TriggerClientEvent("ATM:PlaySound", source, 2)
        end
    else 
        ATM.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

RegisterServerEvent("Rebel:BuyArmour")
AddEventHandler('Rebel:BuyArmour', function()
    local source = source
    userid = ATM.getUserId(source)
    local coords = rebel.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if ATM.hasPermission(userid, 'rebel.whitelist') then
        
            if ATM.tryPayment(userid, 100000) then
                SetPedArmour(source, 96)
                TriggerClientEvent("ATM:PlaySound", source, 1)
                ATMclient.notify(source, {"~g~Purchased Level 4 Armour. Paid £" .. '100,000'})
                TriggerClientEvent('ATM:SetVest', source)
            else 
                ATMclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("ATM:PlaySound", source, 2)
            end

        else
            ATMclient.notify(source,{'~r~You do not have Rebel License.'})
            TriggerClientEvent("ATM:PlaySound", source, 2)
        end
    else 
        ATM.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)




