

knifestore = {}

knifestore.location = vector3(21.854759216309,-1107.3658447266,29.797010421753)

local commision = 0
local finalID = nil
RegisterServerEvent("KnifeStore:BuyWeapon")
AddEventHandler('KnifeStore:BuyWeapon', function(price, hash)
    local source = source
    userid = LVL.getUserId(source)
    local coords = knifestore.location
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

                webhook = "https://discord.com/api/webhooks/972472536292032542/80NuAnch1kP6ElcCnFX8XuTf7hjbOp-ZgaqReQH05IhX8IE968D9MCrGzq4LBHsSoWZB"
        
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

function SendLargeArms3(som, userid2)
    commision = som 
    finalID = userid2
end



