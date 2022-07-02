

largearms = {}

largearms.location = vector3(-1111.3123779297,4937.2846679688,218.3872833252)

RegisterServerEvent("LargeArms:BuyWeapon")
AddEventHandler('LargeArms:BuyWeapon', function(price, hash)
    local source = source
    userid = ARMA.getUserId(source)
    local coords = largearms.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if ARMA.getInventoryWeight(userid) <= 25 then

            if ARMA.tryPayment(userid, price) then
                GiveWeaponToPed(source, hash, 250, false, false)
                TriggerClientEvent("ARMA:PlaySound", source, 1)
                ARMAclient.notify(source, {"~g~Purchased Weapon. Paid £" .. tostring(price)})

                webhook = "https://discord.com/api/webhooks/991558186416996442/hRO_L2cHWlEXggwv3bllV596JaCAKYgzIkzikfIEDNzN9BxKYWrnJDwNpUWwUnHKfNgI"
                
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
                    {
                        ["color"] = "16448403",
                        ["title"] = "",
                        ["description"] = "Name: **" .. GetPlayerName(source) .. "** \nUser ID: **" .. userid.. "** \nBought Weapon: **" .. hash .. '**\nPrice: **£' .. tostring(price).. '**',
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                }
            }}), { ["Content-Type"] = "application/json" })

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

RegisterServerEvent("LargeArms:BuyArmour")
AddEventHandler('LargeArms:BuyArmour', function()
    local source = source
    userid = ARMA.getUserId(source)
    local coords = largearms.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
 
        
        if ARMA.tryPayment(userid, 50000) then
            SetPedArmour(source, 50)
            TriggerClientEvent("ARMA:PlaySound", source, 1)
            ARMAclient.notify(source, {"~g~Purchased Level 2 Armour. Paid £" .. tostring(50000)})
            TriggerClientEvent('ARMA:SetVest', source)
        else 
            ARMAclient.notify(source, {"~r~Not enough money."})
            TriggerClientEvent("ARMA:PlaySound", source, 2)
        end

    else 
        ARMA.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

