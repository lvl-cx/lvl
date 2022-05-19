

citysmall = {}

citysmall.location = vector3(-1500.3103027344,-216.56127929688,47.889362335205)

local commision = 0
local finalID = nil
RegisterServerEvent("CitySmall:BuyWeapon")
AddEventHandler('CitySmall:BuyWeapon', function(price, hash)
    local source = source
    userid = ARMA.getUserId(source)
    local coords = citysmall.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    finalCommision = price * (commision / 100)

    if #(playerCoords - coords) <= 5.0 then 
        if ARMA.getInventoryWeight(userid) <= 25 then

            if ARMA.tryPayment(userid, finalCommision + price) then
                GiveWeaponToPed(source, hash, 250, false, false)
                TriggerClientEvent("ARMA:PlaySound", source, 1)
                ARMAclient.notify(source, {"~g~Purchased Weapon. Paid £" .. tostring(price + finalCommision) .. " +" .. commision .. "% Commision!"})
                if finalID ~= nil then
                    ARMA.giveBankMoney(ARMA.getUserId(finalID),finalCommision)
                    ARMAclient.notify(finalID,{"~g~You have been given £" .. finalCommision.. "~g~."})
                end
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
    finalCommision = 25000 * (commision / 100)

    if #(playerCoords - coords) <= 5.0 then 
 
        
        if ARMA.tryPayment(userid, 25000 + finalCommision) then
            SetPedArmour(source, 25)
            TriggerClientEvent("ARMA:PlaySound", source, 1)
            ARMAclient.notify(source, {"~g~Purchased Level 1 Armour. Paid £" .. tostring(25000 + finalCommision) .. " +" .. commision .. "% Commision!"})
            TriggerClientEvent('ARMA:SetVest', source)
            if finalID ~= nil then
                ARMA.giveBankMoney(ARMA.getUserId(finalID),finalCommision)
                ARMAclient.notify(finalID,{"~g~You have been given £" .. finalCommision.. "~g~."})
            end
        else 
            ARMAclient.notify(source, {"~r~Not enough money."})
            TriggerClientEvent("ARMA:PlaySound", source, 2)
        end

    else 
        ARMA.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

function SendLargeArms2(som, userid2)
    commision = som 
    finalID = userid2
end
