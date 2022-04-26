

sandysmall = {}

sandysmall.location = vector3(2436.9794921875,4966.5571289062,42.347602844238)

local commision = 0
local finalID = nil
RegisterServerEvent("SandySmall:BuyWeapon")
AddEventHandler('SandySmall:BuyWeapon', function(price, hash)
    local source = source
    userid = ATM.getUserId(source)
    local coords = sandysmall.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    finalCommision = price * (commision / 100)

    if #(playerCoords - coords) <= 5.0 then 
        if ATM.getInventoryWeight(userid) <= 25 then

            if ATM.tryPayment(userid, finalCommision + price) then
                GiveWeaponToPed(source, hash, 250, false, false)
                TriggerClientEvent("ATM:PlaySound", source, 1)
                ATMclient.notify(source, {"~g~Purchased Weapon. Paid £" .. tostring(price + finalCommision) .. " ~w~+" .. commision .. "% Commision!"})
                if finalID ~= nil then
                    ATM.giveBankMoney(ATM.getUserId(finalID),finalCommision)
                    ATMclient.notify(finalID,{"~g~You have been given ~w~£" .. finalCommision.. "~g~."})
                end
            else 
                ATMclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("ATM:PlaySound", source, 2)
            end
            
        else
            ATMclient.notify(source,{'~r~Not enough Weight.'})
            TriggerClientEvent("ATM:PlaySound", source, 2)
        end
    else 
        ATM.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

RegisterServerEvent("SandySmall:BuyArmour")
AddEventHandler('SandySmall:BuyArmour', function()
    local source = source
    userid = ATM.getUserId(source)
    local coords = sandysmall.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    finalCommision = 25000 * (commision / 100)

    if #(playerCoords - coords) <= 5.0 then 
 
        
        if ATM.tryPayment(userid, 25000 + finalCommision) then
            SetPedArmour(source, 25)
            TriggerClientEvent("ATM:PlaySound", source, 1)
            ATMclient.notify(source, {"~g~Purchased Level 1 Armour. Paid £" .. tostring(25000 + finalCommision) .. " ~w~+" .. commision .. "% Commision!"})
            TriggerClientEvent('ATM:SetVest', source)
            if finalID ~= nil then
                ATM.giveBankMoney(ATM.getUserId(finalID),finalCommision)
                ATMclient.notify(finalID,{"~g~You have been given ~w~£" .. finalCommision.. "~g~."})
            end
        else 
            ATMclient.notify(source, {"~r~Not enough money."})
            TriggerClientEvent("ATM:PlaySound", source, 2)
        end

    else 
        ATM.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

function SendLargeArms4(som, userid2)
    commision = som 
    finalID = userid2
end
