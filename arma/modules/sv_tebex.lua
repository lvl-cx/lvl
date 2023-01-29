function rank(_, arg)
    if _ ~= 0 then return end
	local user_id = tonumber(arg[1])
    local usource = ARMA.getUserSource(user_id)
    local rank = arg[2]
    print(user_id.." has bought "..rank.."! ^7")
    print(GetPlayerName(usource)..'['..user_id..'] has bought '..rank)
    ARMAclient.notify(usource, {"~g~You have purchased the "..rank.." Rank! ❤️"})
    TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0"..GetPlayerName(usource).." has bought "..rank.."! ❤️", "alert")
    tARMA.sendWebhook('donation',"ARMA Donation Logs", "> Player Name: **"..GetPlayerName(usource).."**\n> Player TempID: **"..usource.."**\n> Player PermID: **"..user_id.."**\n> Package: **"..rank.."**")
    ARMA.addUserGroup(user_id,rank)    
end

function moneybag(_, arg)
    if _ ~= 0 then return end
    user_id = tonumber(arg[1])
    usource = ARMA.getUserSource(user_id)
    print(GetPlayerName(usource)..'['..user_id..'] has bought a '..getMoneyStringFormatted(arg[2])..' Money Bag')
    ARMAclient.notify(usource, {"~g~You have purchased a £" .. getMoneyStringFormatted(arg[2]) .. " Money Bag! ❤️"})
    tARMA.sendWebhook('donation',"ARMA Donation Logs", "> Player Name: **"..GetPlayerName(usource).."**\n> Player TempID: **"..usource.."**\n> Player PermID: **"..user_id.."**\n> Package: **£"..getMoneyStringFormatted(arg[2]).." money bag**")
    ARMA.giveBankMoney(user_id, tonumber(arg[2]))
end

function plus(_, arg)
    if _ ~= 0 then return end
	local user_id = tonumber(arg[1])
    local usource = ARMA.getUserSource(user_id)
    local newhours = tonumber(arg[2])
    tARMA.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            print(GetPlayerName(usource)..'['..user_id..'] has bought '..newhours..' hours of Plus subscription.')
            MySQL.execute("subscription/set_plushours", {user_id = user_id, plushours = plushours + newhours})
            TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0"..GetPlayerName(usource).." has bought a Plus Subscription! ❤️", "alert")
            tARMA.sendWebhook('donation',"ARMA Donation Logs", "> Player Name: **"..GetPlayerName(usource).."**\n> Player TempID: **"..usource.."**\n> Player PermID: **"..user_id.."**\n> Package: **"..newhours.." of Plus**")
        end
    end)
end

function platinum(_, arg)
    if _ ~= 0 then return end
	local user_id = tonumber(arg[1])
    local usource = ARMA.getUserSource(user_id)
    local newhours = tonumber(arg[2])
    tARMA.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            print(GetPlayerName(usource)..'['..user_id..'] has bought '..newhours..' hours of Platinum subscription.')
            MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = plathours + newhours})
            TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0"..GetPlayerName(usource).." has bought a Platinum Subscription! ❤️", "alert")
            tARMA.sendWebhook('donation',"ARMA Donation Logs", "> Player Name: **"..GetPlayerName(usource).."**\n> Player TempID: **"..usource.."**\n> Player PermID: **"..user_id.."**\n> Package: **"..newhours.." of Platinum**")
        end
    end)
end

function addweaponwhitelist(_, arg)
    if _ ~= 0 then return end
    local user_id = tonumber(arg[1])
    local code = tonumber(arg[2])
    local usource = ARMA.getUserSource(user_id)
    local ownedWhitelists = {}
    MySQL.query("ARMA/get_weapon_codes", {}, function(weaponCodes)
        if #weaponCodes > 0 then
            for e,f in pairs(weaponCodes) do
                if f['user_id'] == user_id and f['weapon_code'] == code then
                    MySQL.query("ARMA/get_weapons", {user_id = user_id}, function(weaponWhitelists)
                        if next(weaponWhitelists) then
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
                            tARMA.sendWebhook('donation',"ARMA Donation Logs", "> Player Name: **"..GetPlayerName(usource).."**\n> Player TempID: **"..usource.."**\n> Player PermID: **"..user_id.."**\n> Package: **Access code: "..code.."**")
                        end
                    end)
                end
            end
        end
    end)
end

function setphonenumber(_, arg)
    if _ ~= 0 then return end
    local user_id = tonumber(arg[1])
    local phone_number = tonumber(arg[2])
    local usource = ARMA.getUserSource(user_id)
    MySQL.query("ARMA/get_userbyphone", {phone_number}, function(phoneNumberTaken)
        if #phoneNumberTaken > 0 then
            if ARMA.getUserSource(user_id) ~= nil then
                ARMAclient.notify(usource, {'~r~The phone number you requested has already been taken. Please open a support ticket to choose an available one.'})
            end
        else
            MySQL.execute("ARMA/update_user_identity", {phone = phone_number, user_id = user_id})
            tARMA.sendWebhook('donation',"ARMA Donation Logs", "> Player Name: **"..GetPlayerName(usource).."**\n> Player TempID: **"..usource.."**\n> Player PermID: **"..user_id.."**\n> Package: **Phone Number: "..phone_number.."**")
        end
    end)
end

function vipcar(_, arg)
    if _ ~= 0 then return end
    local user_id = tonumber(arg[1])
    local spawncode = arg[2]
    local usource = ARMA.getUserSource(user_id)
    ARMAclient.generateUUID(usource, {"plate", 5, "alphanumeric"}, function(uuid)
        local uuid = string.upper(uuid)
        MySQL.execute("ARMA/add_vehicle", {user_id = user_id, vehicle = spawncode, registration = 'P'..uuid})
        tARMA.sendWebhook('donation',"ARMA Donation Logs", "> Player Name: **"..GetPlayerName(usource).."**\n> Player TempID: **"..usource.."**\n> Player PermID: **"..user_id.."**\n> Package: **VIP Car: "..spawncode.."**")
    end)
end

RegisterCommand("rank", rank, true)
RegisterCommand("moneybag", moneybag, true)
RegisterCommand("plus", plus, true)
RegisterCommand("platinum", platinum, true)
RegisterCommand("addweaponwhitelist", addweaponwhitelist, true)
RegisterCommand("setphonenumber", setphonenumber, true)
RegisterCommand("vipcar", vipcar, true)