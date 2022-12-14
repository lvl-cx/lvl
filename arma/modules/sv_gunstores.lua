local cfg = module("cfg/cfg_gunstores")
local organheist = module('cfg/cfg_organheist')

MySQL.createCommand("ARMA/get_weapons", "SELECT weapon_info FROM arma_weapon_whitelists WHERE user_id = @user_id")
MySQL.createCommand("ARMA/set_weapons", "UPDATE arma_weapon_whitelists SET weapon_info = @weapon_info WHERE user_id = @user_id")
MySQL.createCommand("ARMA/add_user", "INSERT IGNORE INTO arma_weapon_whitelists SET user_id = @user_id, weapon_info = ''")
MySQL.createCommand("ARMA/get_all_weapons", "SELECT * FROM arma_weapon_whitelists")
MySQL.createCommand("ARMA/create_weapon_code", "INSERT IGNORE INTO arma_weapon_codes SET user_id = @user_id, spawncode = @spawncode, weapon_code = @weapon_code")
MySQL.createCommand("ARMA/remove_weapon_code", "DELETE FROM arma_weapon_codes WHERE weapon_code = @weapon_code")
MySQL.createCommand("ARMA/get_weapon_codes", "SELECT * FROM arma_weapon_codes")

AddEventHandler("playerJoining", function()
    local user_id = ARMA.getUserId(source)
    MySQL.execute("ARMA/add_user", {user_id = user_id})
end)


-- {"policeLargeArms":{"WEAPON_AX50":["AX 50",0,0,"N/A","w_sr_ax50"]}}


local whitelistedGuns = {
    ["policeLargeArms"]={
        ["WEAPON_AX50"]={"AX 50",0,0,"N/A","w_sr_ax50",1}
    },
}


RegisterNetEvent("ARMA:getCustomWeaponsOwned")
AddEventHandler("ARMA:getCustomWeaponsOwned",function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local ownedWhitelists = {}
    MySQL.query("ARMA/get_weapons", {user_id = user_id}, function(weaponWhitelists)
        if weaponWhitelists[1]['weapon_info'] ~= nil then
            data = json.decode(weaponWhitelists[1]['weapon_info'])
            for k,v in pairs(data) do
                for a,b in pairs(v) do
                    for c,d in pairs(whitelistedGuns) do
                        for e,f in pairs(d) do
                            if e == a and f[6] == user_id then
                                ownedWhitelists[a] = b[1]
                            end
                        end
                    end
                end
            end
            TriggerClientEvent('ARMA:gotCustomWeaponsOwned', source, ownedWhitelists)
        end
    end)
end)

RegisterNetEvent("ARMA:requestWhitelistedUsers")
AddEventHandler("ARMA:requestWhitelistedUsers",function(spawncode)
    local source = source
    local user_id = ARMA.getUserId(source)
    local whitelistOwners = {}
    MySQL.query("ARMA/get_all_weapons", {}, function(weaponWhitelists)
        for k,v in pairs(weaponWhitelists) do
            if v['weapon_info'] ~= '' then
                data = json.decode(v['weapon_info'])
                for a,b in pairs(data) do
                    if b[spawncode] then
                        whitelistOwners[v['user_id']] = (exports['ghmattimysql']:executeSync("SELECT username FROM arma_users WHERE id = @user_id", {user_id = user_id})[1]).username
                    end
                end
            end
        end
        TriggerClientEvent('ARMA:getWhitelistedUsers', source, whitelistOwners)
    end)
end)

RegisterNetEvent("ARMA:generateWeaponAccessCode")
AddEventHandler("ARMA:generateWeaponAccessCode",function(spawncode, id)
    local source = source
    local user_id = ARMA.getUserId(source)
    local code = math.random(100000,999999)
    for a,b in pairs(whitelistedGuns) do
        for c,d in pairs(b) do
            if b[spawncode] and d[6]== user_id then
                MySQL.execute("ARMA/create_weapon_code", {user_id = id, spawncode = spawncode, weapon_code = code})
                TriggerClientEvent('ARMA:generatedAccessCode', source, code)
            end
        end
    end
end)

function addweaponwhitelist(_, arg)
    if _ ~= 0 and ARMA.getUserId(_) ~= 1 then return end
    if ARMA.getUserId(_) == 1 then
        local user_id = tonumber(arg[1])
        local spawncode = arg[2]
        local ownedWhitelists = {}
        MySQL.query("ARMA/get_weapons", {user_id = user_id}, function(weaponWhitelists)
            if not next(weaponWhitelists) == nil then
                ownedWhitelists = json.decode(weaponWhitelists[1]['weapon_info'])
            end
            for a,b in pairs(whitelistedGuns) do
                for c,d in pairs(b) do
                    if c == spawncode then
                        if not ownedWhitelists[a] then
                            ownedWhitelists[a] = {}
                        end
                        ownedWhitelists[a][c] = d
                    end
                end
            end
            MySQL.execute("ARMA/set_weapons", {user_id = user_id, weapon_info = json.encode(ownedWhitelists)})
            ARMAclient.notify(_, {'~g~Added '..spawncode..' whitelist to '..user_id..'.'})
            if ARMA.getUserSource(user_id) ~= nil then
                TriggerClientEvent('ARMA:refreshGunStorePermissions', ARMA.getUserSource(user_id))
            end
        end)
    else
        local user_id = tonumber(arg[1])
        local code = tonumber(arg[2])
        local usource = ARMA.getUserSource(user_id)
        local ownedWhitelists = {}
        MySQL.query("ARMA/get_weapon_codes", {}, function(weaponCodes)
            if #weaponCodes > 0 then
                for e,f in pairs(weaponCodes) do
                    if f['user_id'] == user_id and f['weapon_code'] == code then
                        MySQL.query("ARMA/get_weapons", {user_id = user_id}, function(weaponWhitelists)
                            if not next(weaponWhitelists) == nil then
                                ownedWhitelists = json.decode(weaponWhitelists[1]['weapon_info'])
                            end
                            for a,b in pairs(whitelistedGuns) do
                                for c,d in pairs(b) do
                                    if c == f['spawncode'] then
                                        if not ownedWhitelists[a] then
                                            ownedWhitelists[a] = {}
                                        end
                                        ownedWhitelists[a][c] = d
                                    end
                                end
                            end
                            MySQL.execute("ARMA/set_weapons", {user_id = user_id, weapon_info = json.encode(ownedWhitelists)})
                            MySQL.execute("ARMA/remove_weapon_code", {weapon_code = code})
                            if usource ~= nil then
                                TriggerClientEvent('ARMA:refreshGunStorePermissions', usource)
                                print(GetPlayerName(usource)..'['..user_id..'] has redeemed a weapon whitelist code.')
                                ARMAclient.notify(usource, {"~g~Your whitelist access has been granted. ❤️"})
                            end
                        end)
                    end
                end
            end
        end)
    end
end
RegisterCommand("addweaponwhitelist", addweaponwhitelist, true)


RegisterNetEvent("ARMA:requestNewGunshopData")
AddEventHandler("ARMA:requestNewGunshopData",function()
    local source = source
    local user_id = ARMA.getUserId(source)
    MySQL.query("ARMA/get_weapons", {user_id = user_id}, function(weaponWhitelists)
        if weaponWhitelists[1]['weapon_info'] ~= nil then
            data = json.decode(weaponWhitelists[1]['weapon_info'])
            for a,b in pairs(cfg.GunStores) do
                for c,d in pairs(data) do
                    if a == c then
                        for e,f in pairs(data[a]) do
                            cfg.GunStores[a][e] = f
                        end
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
            if vipstore then
                if #(GetEntityCoords(GetPlayerPed(source)) - cfg.GunStores["VIP"]['_config'][1][1] ) < 10 then
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
                            if name == d[1] then
                                if purchasetype == 'armour' then
                                    if string.find(spawncode, "fillUp") then
                                        price = (100 - GetPedArmour(GetPlayerPed(source))) * 1000
                                        if ARMA.tryPayment(user_id,price) then
                                            ARMAclient.notify(source, {'~g~You bought '..name..' for £'..getMoneyStringFormatted(price)..'.'})
                                            TriggerClientEvent("arma:PlaySound", source, 1)
                                            ARMAclient.setArmour(source, {100, true})
                                            tARMA.sendWebhook('weapon-shops',"ARMA Weapon Shop Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                            return
                                        end
                                    elseif GetPedArmour(GetPlayerPed(source)) >= (price/1000) then
                                        ARMAclient.notify(source, {'~r~You already have '..GetPedArmour(GetPlayerPed(source))..'% armour.'})
                                        return
                                    end
                                    if ARMA.tryPayment(user_id,price) then
                                        ARMAclient.notify(source, {'~g~You bought '..name..' for £'..getMoneyStringFormatted(price)..'.'})
                                        TriggerClientEvent("arma:PlaySound", source, 1)
                                        ARMAclient.setArmour(source, {price/1000, true})
                                        tARMA.sendWebhook('weapon-shops',"ARMA Weapon Shop Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                        if weaponshop == 'LargeArmsDealer' then
                                            ARMA.turfSaleToGangFunds(price, 'LargeArms')
                                        end
                                    else
                                        ARMAclient.notify(source, {'You do not have enough money for this purchase.'})
                                        TriggerClientEvent("arma:PlaySound", source, 2)
                                    end
                                elseif purchasetype == 'weapon' then
                                    ARMAclient.hasWeapon(source, {spawncode}, function(hasWeapon)
                                        if hasWeapon then
                                            ARMAclient.notify(source, {'~r~Please store this weapon before purchasing another.'})
                                        else
                                            if ARMA.tryPayment(user_id,price) then
                                                if price > 0 then
                                                    ARMAclient.notify(source, {'~g~You bought a '..name..' for £'..getMoneyStringFormatted(price)..'.'})
                                                    if weaponshop == 'LargeArmsDealer' then
                                                        ARMA.turfSaleToGangFunds(price, 'LargeArms')
                                                    end
                                                else
                                                    ARMAclient.notify(source, {'~g~'..name..' purchased.'})
                                                end
                                                TriggerClientEvent("arma:PlaySound", source, 1)
                                                ARMAclient.allowWeapon(source,{spawncode})
                                                GiveWeaponToPed(source, spawncode, 250, false, false)
                                                tARMA.sendWebhook('weapon-shops',"ARMA Weapon Shop Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                            else
                                                ARMAclient.notify(source, {'You do not have enough money for this purchase.'})
                                                TriggerClientEvent("arma:PlaySound", source, 2)
                                            end
                                        end
                                    end)
                                elseif purchasetype == 'ammo' then
                                    if ARMA.tryPayment(user_id,price) then
                                        if price > 0 then
                                            ARMAclient.notify(source, {'~g~You bought 250x Ammo for £'..getMoneyStringFormatted(price)..'.'})
                                            if weaponshop == 'LargeArmsDealer' then
                                                ARMA.turfSaleToGangFunds(price, 'LargeArms')
                                            end
                                        else
                                            ARMAclient.notify(source, {'~g~250x Ammo purchased.'})
                                        end
                                        TriggerClientEvent("arma:PlaySound", source, 1)
                                        SetPedAmmo(GetPlayerPed(source), spawncode, 250)
                                        tARMA.sendWebhook('weapon-shops',"ARMA Weapon Shop Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                    else
                                        ARMAclient.notify(source, {'You do not have enough money for this purchase.'})
                                        TriggerClientEvent("arma:PlaySound", source, 2)
                                    end
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