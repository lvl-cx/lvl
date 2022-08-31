local cfg = module("armacore/cfg/cfg_gunstores")

RegisterNetEvent("ARMA:requestNewGunshopData")
AddEventHandler("ARMA:requestNewGunshopData",function()
    local source = source
    TriggerClientEvent('ARMA:recieveFilteredGunStoreData', source, cfg.GunStores)
end)

RegisterNetEvent("ARMA:buyWeapon")
AddEventHandler("ARMA:buyWeapon",function(spawncode, price, name, weaponshop, purchasetype, vipstore)
    local source = source
    local user_id = ARMA.getUserId(source)
    local hasPerm = false
    for k,v in pairs(cfg.GunStores[weaponshop]) do
        if k == '_config' then
            local withinRadius = false
            for a,b in pairs(v[1]) do
                if #(GetEntityCoords(GetPlayerPed(source)) - b) < 10 then
                    withinRadius = true
                end
            end
            if not withinRadius then
                local player = ARMA.getUserSource(user_id)
                local name = GetPlayerName(source)
                Wait(500)
                TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to purchase gun outside of store radius')
            end
            if json.encode(v[5]) ~= '[""]' then
                for a,b in pairs(v[5]) do
                    if ARMA.hasPermission(user_id, b) then
                        hasPerm = true
                    end
                end
            end
            for c,d in pairs(cfg.GunStores[weaponshop]) do
                if c ~= '_config' then
                    if hasPerm then
                        if c == spawncode then
                            if price == d[2] and name == d[1] then
                                if ARMA.tryPayment(user_id,price) then
                                    if price > 0 then
                                        ARMAclient.notify(source, {'~g~You bought a '..name..' for £'..price..'.'})
                                    else
                                        ARMAclient.notify(source, {'~g~'..name..' purchased.'})
                                    end
                                    TriggerClientEvent("arma:PlaySound", source, 1)
                                    GiveWeaponToPed(source, spawncode, 250, false, false)
                                else
                                    ARMAclient.notify(source, {'You do not have enough money for this purchase.'})
                                    TriggerClientEvent("arma:PlaySound", source, 2)
                                end
                            else
                                local player = ARMA.getUserSource(user_id)
                                local name = GetPlayerName(source)
                                Wait(500)
                                TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to purchase gun with unrecognised name or price')
                            end
                        end
                    else
                        if weaponshop == 'policeLargeArms' or weaponshop == 'policeSmallArms' then
                            ARMAclient.notify(source, {"~r~You shouldn't be in here, ALARM TRIGGERED!!!"})
                        else
                            ARMAclient.notify(source, {"~r~You do not have permissions to access this store."})
                        end
                    end
                end
            end
        end
    end
end)

--TriggerServerEvent("ARMA:buyWeapon",d.model,d.price,d.name,d.weaponShop,"armour")