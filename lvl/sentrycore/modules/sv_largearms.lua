

largearms = {}

largearms.location = vector3(-1111.3123779297,4937.2846679688,218.3872833252)

local commision = 0
local finalID = nil
RegisterServerEvent("LargeArms:BuyWeapon")
AddEventHandler('LargeArms:BuyWeapon', function(price, hash)
    local source = source
    userid = LVL.getUserId(source)
    local coords = largearms.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    finalCommision = price * (commision / 100)

    if #(playerCoords - coords) <= 5.0 then 
        if LVL.getInventoryWeight(userid) <= 25 then

            if LVL.tryPayment(userid, finalCommision + price) then
                GiveWeaponToPed(source, hash, 250, false, false)
                TriggerClientEvent("LVL:PlaySound", source, 1)
                LVLclient.notify(source, {"~b~Purchased Weapon. Paid £" .. tostring(price + finalCommision) .. " ~w~+" .. commision .. "% Commision!"})
                if finalID ~= nil then
                    LVL.giveBankMoney(LVL.getUserId(finalID),finalCommision)
                    LVLclient.notify(finalID,{"~b~You have been given ~w~£" .. finalCommision.. "~b~."})
                end
            else 
                LVLclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("LVL:PlaySound", source, 2)
            end

        else
            LVLclient.notify(source,{'~r~Not enough Weight.'})
            TriggerClientEvent("LVL:PlaySound", source, 2)
        end
    else 
        LVL.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

RegisterServerEvent("LargeArms:BuyArmour")
AddEventHandler('LargeArms:BuyArmour', function()
    local source = source
    userid = LVL.getUserId(source)
    local coords = largearms.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    finalCommision = 50000 * (commision / 100)

    if #(playerCoords - coords) <= 5.0 then 
 
        
        if LVL.tryPayment(userid, 50000 + finalCommision) then
            SetPedArmour(source, 50)
            TriggerClientEvent("LVL:PlaySound", source, 1)
            LVLclient.notify(source, {"~b~Purchased Level 2 Armour. Paid £" .. tostring(50000 + finalCommision) .. " ~w~+" .. commision .. "% Commision!"})
            TriggerClientEvent('LVL:SetVest', source)
            if finalID ~= nil then
                LVL.giveBankMoney(LVL.getUserId(finalID),finalCommision)
                LVLclient.notify(finalID,{"~b~You have been given ~w~£" .. finalCommision.. "~b~."})
            end
        else 
            LVLclient.notify(source, {"~r~Not enough money."})
            TriggerClientEvent("LVL:PlaySound", source, 2)
        end

    else 
        LVL.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

function SendLargeArms(som, userid2)
    commision = som 
    finalID = userid2
end

