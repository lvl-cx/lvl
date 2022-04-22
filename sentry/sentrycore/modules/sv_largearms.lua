

largearms = {}

largearms.location = vector3(-1111.3123779297,4937.2846679688,218.3872833252)

local commision = 0
local finalID = nil
RegisterServerEvent("LargeArms:BuyWeapon")
AddEventHandler('LargeArms:BuyWeapon', function(price, hash)
    local source = source
    userid = Sentry.getUserId(source)
    local coords = largearms.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    finalCommision = price * (commision / 100)

    if #(playerCoords - coords) <= 5.0 then 
        if Sentry.getInventoryWeight(userid) <= 25 then

            if Sentry.tryPayment(userid, finalCommision + price) then
                GiveWeaponToPed(source, hash, 250, false, false)
                TriggerClientEvent("Sentry:PlaySound", source, 1)
                Sentryclient.notify(source, {"~g~Purchased Weapon. Paid £" .. tostring(price + finalCommision) .. " ~w~+" .. commision .. "% Commision!"})
                if finalID ~= nil then
                    Sentry.giveBankMoney(Sentry.getUserId(finalID),finalCommision)
                    Sentryclient.notify(finalID,{"~g~You have been given ~w~£" .. finalCommision.. "~g~."})
                end
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
    finalCommision = 50000 * (commision / 100)

    if #(playerCoords - coords) <= 5.0 then 
 
        
        if Sentry.tryPayment(userid, 50000 + finalCommision) then
            SetPedArmour(source, 50)
            TriggerClientEvent("Sentry:PlaySound", source, 1)
            Sentryclient.notify(source, {"~g~Purchased Level 2 Armour. Paid £" .. tostring(50000 + finalCommision) .. " ~w~+" .. commision .. "% Commision!"})
            TriggerClientEvent('Sentry:SetVest', source)
            if finalID ~= nil then
                Sentry.giveBankMoney(Sentry.getUserId(finalID),finalCommision)
                Sentryclient.notify(finalID,{"~g~You have been given ~w~£" .. finalCommision.. "~g~."})
            end
        else 
            Sentryclient.notify(source, {"~r~Not enough money."})
            TriggerClientEvent("Sentry:PlaySound", source, 2)
        end

    else 
        Sentry.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

function SendLargeArms(som, userid2)
    commision = som 
    finalID = userid2
end

