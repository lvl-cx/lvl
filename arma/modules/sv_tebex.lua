-- Tebex functions need redoing to match
-- Supporter, Premium, Supreme, Kingpin, Rainmaker, Baller

function rank(_, arg)
    if _ ~= 0 then return end
	local user_id = tonumber(arg[1])
    local usource = ARMA.getUserSource(user_id)
    local rank = arg[2]
    print(user_id.." has bought "..rank.."! ^7")
    print(GetPlayerName(usource)..'['..user_id..'] has bought '..rank)
    ARMAclient.notify(usource, {"~g~You have purchased the "..rank.." Rank! ❤️"})
    ARMA.addUserGroup(user_id,rank)    
end

function moneybag(_, arg)
    if _ ~= 0 then return end
    user_id = tonumber(arg[1])
    usource = ARMA.getUserSource(user_id)
    print(GetPlayerName(usource)..'['..user_id..'] has bought a '..getMoneyStringFormatted(arg[2])..' Money Bag')
    ARMAclient.notify(usource, {"~g~You have purchased " .. getMoneyStringFormatted(arg[2]) .. " Money! ❤️"})
    ARMA.giveBankMoney(user_id, tonumber(arg[2]))
end

function plus(_, arg)
    if _ ~= 0 then return end
	local user_id = tonumber(arg[1])
    local usource = ARMA.getUserSource(user_id)
    local newhours = arg[2]
    tARMA.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            print(GetPlayerName(usource)..'['..user_id..'] has bought '..newhours..' hours of Plus subscription.')
            MySQL.execute("subscription/set_plushours", {user_id = user_id, plushours = plushours + newhours})
        end
    end)
end

function platinum(_, arg)
    if _ ~= 0 then return end
	local user_id = tonumber(arg[1])
    local usource = ARMA.getUserSource(user_id)
    local newhours = arg[2]
    tARMA.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            print(GetPlayerName(usource)..'['..user_id..'] has bought '..newhours..' hours of Platinum subscription.')
            MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = plathours + newhours})
        end
    end)
end

function platinum(_, arg)
    if _ ~= 0 then return end
	local user_id = tonumber(arg[1])
    local usource = ARMA.getUserSource(user_id)
    local newhours = arg[2]
    tARMA.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            print(GetPlayerName(usource)..'['..user_id..'] has bought '..newhours..' hours of Platinum subscription.')
            MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = plathours + newhours})
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
                        end
                    end)
                end
            end
        end
    end)
end

-- MySQL.createCommand("ARMA/update_user_identity","UPDATE arma_user_identities SET firstname = @firstname, name = @name, age = @age, registration = @registration, phone = @phone WHERE user_id = @user_id")

-- setphonenumber {userid} {number}
function setphonenumber(_, arg)
    if _ ~= 0 then return end
    local user_id = tonumber(arg[1])
    local phone_number = tonumber(arg[2])
    local usource = ARMA.getUserSource(user_id)
    MySQL.query("ARMA/get_userbyphone", {phone_number}, function(phoneNumberTaken)
        if #phoneNumberTaken > 0 then
            ARMAclient.notify(usource, {'~r~The phone number you requested has already been taken. Please open a support ticket to choose an available one.'})
        else
            MySQL.execute("ARMA/update_user_identity", {phone = phone_number})
        end
    end)
end

RegisterCommand("rank", rank, true)
RegisterCommand("moneybag", moneybag, true)
RegisterCommand("plus", plus, true)
RegisterCommand("platinum", platinum, true)
RegisterCommand("addweaponwhitelist", addweaponwhitelist, true)
RegisterCommand("setphonenumber", setphonenumber, true)