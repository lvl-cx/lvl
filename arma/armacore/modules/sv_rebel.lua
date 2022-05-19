
rebel = {}

rebel.location = vector3(1545.2042236328,6332.3295898438,24.078683853149)

RegisterServerEvent("Rebel:BuyWeapon")
AddEventHandler('Rebel:BuyWeapon', function(price, hash)
    local source = source
    userid = ARMA.getUserId(source)
    local coords = rebel.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if ARMA.hasPermission(userid, 'rebel.whitelist') then
        
            if ARMA.tryPayment(userid, price) then
                GiveWeaponToPed(source, hash, 250, false, false)
                TriggerClientEvent("ARMA:PlaySound", source, 1)
                ARMAclient.notify(source, {"~g~Paid ".. '£' ..tostring(price)})

                webhook = "https://discord.com/api/webhooks/972476987530674206/WE5J3ibv-IAKx80qWm-UgxLIhABklAjloy1Zx59w5WV58m1iy6sM34jZZfGtL9cdOIm1"
                
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
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
                ARMAclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("ARMA:PlaySound", source, 2)
            end

        else
            ARMAclient.notify(source,{'~r~You do not have Rebel License.'})
            TriggerClientEvent("ARMA:PlaySound", source, 2)
        end
    else 
        ARMA.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

RegisterServerEvent("Rebel:BuyArmour")
AddEventHandler('Rebel:BuyArmour', function()
    local source = source
    userid = ARMA.getUserId(source)
    local coords = rebel.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if ARMA.hasPermission(userid, 'rebel.whitelist') then
        
            if ARMA.tryPayment(userid, 100000) then
                SetPedArmour(source, 96)
                TriggerClientEvent("ARMA:PlaySound", source, 1)
                ARMAclient.notify(source, {"~g~Purchased Level 4 Armour. Paid £" .. '100,000'})
                TriggerClientEvent('ARMA:SetVest', source)
            else 
                ARMAclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("ARMA:PlaySound", source, 2)
            end

        else
            ARMAclient.notify(source,{'~r~You do not have Rebel License.'})
            TriggerClientEvent("ARMA:PlaySound", source, 2)
        end
    else 
        ARMA.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)




