

sandysmall = {}

sandysmall.location = vector3(2436.9794921875,4966.5571289062,42.347602844238)

local commision = 0
local finalID = nil
RegisterServerEvent("SandySmall:BuyWeapon")
AddEventHandler('SandySmall:BuyWeapon', function(price, hash)
    local source = source
    userid = LVL.getUserId(source)
    local coords = sandysmall.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    finalCommision = price * (commision / 100)

    if #(playerCoords - coords) <= 5.0 then 
        if LVL.getInventoryWeight(userid) <= 25 then

            if LVL.tryPayment(userid, finalCommision + price) then
                GiveWeaponToPed(source, hash, 250, false, false)
                TriggerClientEvent("LVL:PlaySound", source, 1)
                LVLclient.notify(source, {"~g~Purchased Weapon. Paid £" .. tostring(price + finalCommision) .. " +" .. commision .. "% Commision!"})
                if finalID ~= nil then
                    LVL.giveBankMoney(LVL.getUserId(finalID),finalCommision)
                    LVLclient.notify(finalID,{"~g~You have been given £" .. finalCommision.. "~g~."})
                end

                webhook = "https://discord.com/api/webhooks/972477157387403285/amx-pPsAKI-ecYGqx6X_yJuVrBj90VKmgemWGPau0dAevUNn5TPECeLKSYLVygYtbfW1"
                
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "LVL Roleplay", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "",
                        ["description"] = "Name: **" .. GetPlayerName(source) .. "** \nUser ID: **" .. userid.. "** \nBought Weapon: **" .. hash .. '**\nPrice: **£' .. tostring(price).. '**',
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                }
            }}), { ["Content-Type"] = "application/json" })

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

RegisterServerEvent("SandySmall:BuyArmour")
AddEventHandler('SandySmall:BuyArmour', function()
    local source = source
    userid = LVL.getUserId(source)
    local coords = sandysmall.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    finalCommision = 25000 * (commision / 100)

    if #(playerCoords - coords) <= 5.0 then 
 
        
        if LVL.tryPayment(userid, 25000 + finalCommision) then
            SetPedArmour(source, 25)
            TriggerClientEvent("LVL:PlaySound", source, 1)
            LVLclient.notify(source, {"~g~Purchased Level 1 Armour. Paid £" .. tostring(25000 + finalCommision) .. " +" .. commision .. "% Commision!"})
            TriggerClientEvent('LVL:SetVest', source)
            if finalID ~= nil then
                LVL.giveBankMoney(LVL.getUserId(finalID),finalCommision)
                LVLclient.notify(finalID,{"~g~You have been given £" .. finalCommision.. "~g~."})
            end
        else 
            LVLclient.notify(source, {"~r~Not enough money."})
            TriggerClientEvent("LVL:PlaySound", source, 2)
        end

    else 
        LVL.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

function SendLargeArms4(som, userid2)
    commision = som 
    finalID = userid2
end
