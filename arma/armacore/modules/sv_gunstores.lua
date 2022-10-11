local cfg = module("armacore/cfg/cfg_gunstores")
local organheist = module('cfg/cfg_organheist')

MySQL.createCommand("ARMA/get_weapons", "SELECT weapon_info FROM arma_weapon_whitelists WHERE user_id = @user_id")
MySQL.createCommand("ARMA/set_weapons", "UPDATE arma_weapon_whitelists SET weapon_info = @weapon_info WHERE AND user_id = @user_id")


local whitelistedGuns = {
    [1] = {
        ["policeLargeArms"]={
            ["WEAPON_AX50"]={"AX 50",0,0,"N/A","w_sr_ax50"},
        }
    }
}

RegisterNetEvent("ARMA:requestNewGunshopData")
AddEventHandler("ARMA:requestNewGunshopData",function()
    local source = source
    local user_id = ARMA.getUserId(source)
    MySQL.query("ARMA/get_weapons", {user_id = user_id}, function(weaponWhitelists) -- need to make the table above so it'll go into sql when a gun whitelist is bought
        for k,v in pairs(weaponWhitelists) do                                       -- pull sql when player requests gun shop data, then insert the whitelisted guns into
            if weaponWhitelists[k]['weapon_info'] ~= '' then                        -- the gunstore table and pass that to the player, just gotta do perm id checks
                data = json.decode(weaponWhitelists[k]['weapon_info'])
                for a,b in pairs(cfg.Gunstores) do
                    if a == data[k] then
                        table.insert(cfg.Gunstores[a], data)
                    end
                end
            end
        end
        TriggerClientEvent('ARMA:recieveFilteredGunStoreData', source, cfg.GunStores)
    end)
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
            for c,d in pairs(organheist.locations) do
                for e,f in pairs(d.gunStores) do
                    for g,h in pairs(f) do
                        if #(GetEntityCoords(GetPlayerPed(source)) - h[3]) < 10 then
                            withinRadius = true
                        end
                    end
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
            else
                hasPerm = true
            end
            for c,d in pairs(cfg.GunStores[weaponshop]) do
                if c ~= '_config' then
                    if hasPerm then
                        if c == spawncode then
                            if price == d[2] and name == d[1] then
                                if ARMA.tryPayment(user_id,price) then
                                    if purchasetype == 'weapon' then
                                        ARMAclient.hasWeapon(source, {spawncode}, function(hasWeapon)
                                            if hasWeapon then
                                                ARMAclient.notify(source, {'~r~Please store this weapon before purchasing another.'})
                                            else
                                                if price > 0 then
                                                    ARMAclient.notify(source, {'~g~You bought a '..name..' for £'..getMoneyStringFormatted(price)..'.'})
                                                else
                                                    ARMAclient.notify(source, {'~g~'..name..' purchased.'})
                                                end
                                                TriggerClientEvent("arma:PlaySound", source, 1)
                                                GiveWeaponToPed(source, spawncode, 250, false, false)
                                            end
                                        end)
                                    elseif purchasetype == 'armour' then
                                        if GetPedArmour(GetPlayerPed(source)) > (price/1000) then
                                            ARMAclient.notify(source, {'~r~You already have '..GetPedArmour(GetPlayerPed(source))..'% armour.'})
                                        else
                                            ARMAclient.notify(source, {'~g~You bought '..name..' for £'..getMoneyStringFormatted(price)..'.'})
                                            TriggerClientEvent("arma:PlaySound", source, 1)
                                            SetPedArmour(GetPlayerPed(source), (math.floor(price/1000)))
                                        end
                                    elseif purchasetype == 'ammo' then
                                        if price > 0 then
                                            ARMAclient.notify(source, {'~g~You bought 250x Ammo for £'..getMoneyStringFormatted(price)..'.'})
                                        else
                                            ARMAclient.notify(source, {'~g~250x Ammo purchased.'})
                                        end
                                        TriggerClientEvent("arma:PlaySound", source, 1)
                                        SetPedAmmo(GetPlayerPed(source), spawncode, 250)
                                    end
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
                            ARMAclient.notify(source, {"~r~You do not have permission to access this store."})
                        end
                    end
                end
            end
        end
    end
end)

--TriggerServerEvent("ARMA:buyWeapon",d.model,d.price,d.name,d.weaponShop,"armour")