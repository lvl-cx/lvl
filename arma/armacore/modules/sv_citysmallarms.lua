

citysmall = {}

citysmall.location = vector3(-1500.3103027344,-216.56127929688,47.889362335205)

RegisterServerEvent("CitySmall:BuyWeapon")
AddEventHandler('CitySmall:BuyWeapon', function(price, hash)
    local source = source
    userid = ARMA.getUserId(source)
    local coords = citysmall.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if ARMA.getInventoryWeight(userid) <= 25 then

            if ARMA.tryPayment(userid, price) then
                GiveWeaponToPed(source, hash, 250, false, false)
                TriggerClientEvent("ARMA:PlaySound", source, 1)
                ARMAclient.notify(source, {"~g~Purchased Weapon. Paid £" .. tostring(price)})
            else 
                ARMAclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("ARMA:PlaySound", source, 2)
            end

        else
            ARMAclient.notify(source,{'~r~Not enough Weight.'})
            TriggerClientEvent("ARMA:PlaySound", source, 2)
        end
    else 
        ARMA.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)


RegisterServerEvent("CitySmall:BuyArmour")
AddEventHandler('CitySmall:BuyArmour', function()
    local source = source
    userid = ARMA.getUserId(source)
    local coords = citysmall.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
 
        
        if ARMA.tryPayment(userid, 25000) then
            SetPedArmour(source, 25)
            TriggerClientEvent("ARMA:PlaySound", source, 1)
            ARMAclient.notify(source, {"~g~Purchased Level 1 Armour. Paid £" .. tostring(25000)})
            TriggerClientEvent('ARMA:SetVest', source)
        else 
            ARMAclient.notify(source, {"~r~Not enough money."})
            TriggerClientEvent("ARMA:PlaySound", source, 2)
        end

    else 
        ARMA.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)
