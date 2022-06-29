
armoury = {}

armoury.location = vector3(451.34454345703,-980.09381103516,30.689605712891)

RegisterServerEvent("PD:BuyWeapon")
AddEventHandler('PD:BuyWeapon', function(hash)
    local source = source
    userid = ARMA.getUserId(source)
    local coords = armoury.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if ARMA.hasPermission(userid, 'cop.keycard') then
            GiveWeaponToPed(source, hash, 250, false, false)
            TriggerClientEvent("ARMA:PlaySound", source, 1)
            ARMAclient.notify(source, {"~g~Paid ".. '£0'})

            webhook = "https://discord.com/api/webhooks/991558379979931749/rND_Azu9PE3AeMUPWSgcRA6aoJhxQjM6Jp-bgHC7y0Qg3oyp_W2j3H1-ZoxsMJxdMtM2"
                
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
            ARMAclient.notify(source,{'~r~You are not PD/ Clocked on!'})
            TriggerClientEvent("ARMA:PlaySound", source, 2)
        end

    else 
        ARMA.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

RegisterServerEvent("PD:BuyArmour")
AddEventHandler('PD:BuyArmour', function()
    local source = source
    userid = ARMA.getUserId(source)
    local coords = armoury.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if ARMA.hasPermission(userid, 'cop.keycard') then
    
    
            SetPedArmour(source, 96)
            TriggerClientEvent("ARMA:PlaySound", source, 1)
            ARMAclient.notify(source, {"~g~Paid ".. '£0'})
            TriggerClientEvent('ARMA:SetVest', source)
        else
            ARMAclient.notify(source,{'~r~You are not PD/ Clocked on!'})
            TriggerClientEvent("ARMA:PlaySound", source, 2)
        end
    else 
        ARMA.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

