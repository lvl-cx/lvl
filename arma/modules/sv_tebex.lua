function rank(_, arg)
    if _ ~= 0 then return end
	local user_id = tonumber(arg[1])
    local rank = arg[2]
    print(user_id.." has bought "..rank.."! ^7")
    tARMA.sendWebhook('donation',"ARMA Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **"..rank.."**")
    if ARMA.getUserSource(user_id) ~= nil then
        ARMA.addUserGroup(user_id,rank)  
    else
        exports['ghmattimysql']:execute("SELECT * FROM arma_user_data WHERE user_id = @user_id", {user_id = user_id}, function(result) 
            if result ~= nil then
                local dvalue = json.decode(result[0].dvalue)
                local groups = dvalue.groups
                groups[rank] = true
                exports['ghmattimysql']:execute("UPDATE arma_user_data SET dvalue = @dvalue WHERE user_id = @user_id", {dvalue = json.encode(dvalue), user_id = user_id}, function() end)
            end
        end)
    end  
end

function moneybag(_, arg)
    if _ ~= 0 then return end
    user_id = tonumber(arg[1])
    tARMA.sendWebhook('donation',"ARMA Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **£"..getMoneyStringFormatted(arg[2]).." money bag**")
    if ARMA.getUserSource(user_id) ~= nil then
        ARMA.giveBankMoney(user_id, tonumber(arg[2]))
    else
        exports['ghmattimysql']:execute("UPDATE arma_user_moneys SET bank = bank + @newamount WHERE user_id = @user_id", {newamount = tonumber(args[2]), user_id = user_id}, function() end)
    end
end

function plus(_, arg)
    if _ ~= 0 then return end
	local user_id = tonumber(arg[1])
    local newhours = tonumber(arg[2])
    tARMA.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            MySQL.execute("subscription/set_plushours", {user_id = user_id, plushours = plushours + newhours})
            tARMA.sendWebhook('donation',"ARMA Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **"..newhours.." of Plus**")
        end
    end)
end

function platinum(_, arg)
    if _ ~= 0 then return end
	local user_id = tonumber(arg[1])
    local newhours = tonumber(arg[2])
    tARMA.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = plathours + newhours})
            tARMA.sendWebhook('donation',"ARMA Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **"..newhours.." of Platinum**")
        end
    end)
end

function addweaponwhitelist(_, arg)
    if _ ~= 0 then return end
    local user_id = tonumber(arg[1])
    local code = tonumber(arg[2])
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
                        tARMA.sendWebhook('donation',"ARMA Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **Access code: "..code.."**")
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
    MySQL.query("ARMA/get_userbyphone", {phone_number}, function(phoneNumberTaken)
        if #phoneNumberTaken > 0 then
        else
            MySQL.execute("ARMA/update_user_identity", {phone = phone_number, user_id = user_id})
            tARMA.sendWebhook('donation',"ARMA Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **Phone Number: "..phone_number.."**")
        end
    end)
end

function vipcar(_, arg)
    if _ ~= 0 then return end
    local user_id = tonumber(arg[1])
    local spawncode = arg[2]
    MySQL.execute("ARMA/add_vehicle", {user_id = user_id, vehicle = spawncode, registration = 'P'..math.random(10000,99999)})
    tARMA.sendWebhook('donation',"ARMA Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **VIP Car: "..spawncode.."**")
end

RegisterCommand("rank", rank, true)
RegisterCommand("moneybag", moneybag, true)
RegisterCommand("plus", plus, true)
RegisterCommand("platinum", platinum, true)
RegisterCommand("addweaponwhitelist", addweaponwhitelist, true)
RegisterCommand("setphonenumber", setphonenumber, true)
RegisterCommand("vipcar", vipcar, true)