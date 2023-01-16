local cfg = {}
cfg.GunStores={
    ["policeLargeArms"]={
        ["_config"]={{vector3(1840.6104736328,3691.4741210938,33.350730895996),vector3(461.43179321289,-982.66412353516,29.689668655396),vector3(-449.9557800293,6016.5454101563,30.7363982391),vector3(-1102.5059814453,-820.62091064453,13.282785415649)},110,5,"MET Police Large Arms",{"police.onduty.permission","police.loadshop2"},false,true}, 
        ["WEAPON_FLASHBANG"]={"Flashbang",0,0,"N/A","w_me_flashbang"},
        ["WEAPON_G36K"]={"G36K",0,0,"N/A","w_ar_g36k"}, 
        ["WEAPON_M4A1"]={"M4 Carbine",0,0,"N/A","w_ar_m4a1"}, 
        ["WEAPON_MP5"]={"MP5",0,0,"N/A","w_sb_mp5"},
        ["WEAPON_REMINGTON700"]={"Remington 700",0,0,"N/A","w_sr_remington700"}, 
        ["WEAPON_SIGMCX"]={"SigMCX",0,0,"N/A","w_ar_sigmcx"},
        -- smoke grenade
        ["WEAPON_SPAR17"]={"SPAR17",0,0,"N/A","w_ar_spar17"},
        ["WEAPON_STING"]={"Sting 9mm",0,0,"N/A","w_sb_sting"},
    },
    ["policeSmallArms"]={
        ["_config"]={{vector3(461.53082275391,-979.35876464844,29.689668655396),vector3(1842.9096679688,3690.7692871094,33.267082214355),vector3(-448.93994140625,6015.4150390625,30.7363982391),vector3(-1104.5264892578,-821.70153808594,13.282785415649)},110,5,"MET Police Small Arms",{"police.onduty.permission"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
        ["WEAPON_PDGLOCK"]={"Glock",0,0,"N/A","w_pi_glock"},
        ["WEAPON_NIGHTSTICK"]={"Police Baton",0,0,"N/A","w_me_nightstick"},
        ["WEAPON_REMINGTON870"]={"Remington 870",0,0,"N/A","w_sg_remington870"},
        ["WEAPON_STAFFGUN"]={"Speed Gun",0,0,"N/A","w_pi_staffgun"},
        ["WEAPON_STUNGUN"]={"Tazer",0,0,"N/A","w_pi_stungun"},
    },
    ["prisonArmoury"]={
        ["_config"]={{vector3(1779.3741455078,2542.5639648438,45.797782897949)},110,5,"Prison Armoury",{"prisonguard.onduty.permission"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
        ["WEAPON_PDGLOCK"]={"Glock",0,0,"N/A","w_pi_glock"},
        ["WEAPON_NIGHTSTICK"]={"Police Baton",0,0,"N/A","w_me_nightstick"},
        ["WEAPON_REMINGTON870"]={"Remington 870",0,0,"N/A","w_sg_remington870"},
        ["WEAPON_STUNGUN"]={"Tazer",0,0,"N/A","w_pi_stungun"},
    },
    ["NHS"]={
        ["_config"]={{vector3(340.41757202148,-582.71209716797,27.973259765625),vector3(-435.27032470703,-318.29010009766,34.08971484375)},110,5,"NHS Armoury",{"nhs.onduty.permission"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
    },
    ["LFB"]={
        ["_config"]={{vector3(1210.193359375,-1484.1494140625,34.241326171875),vector3(216.63296508789,-1648.6680908203,29.0179375)},110,5,"LFB Armoury",{"lfb.onduty.permission"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
        ["WEAPON_FIREAXE"]={"Fireaxe",0,0,"N/A","w_me_fireaxe"},
    },
    ["VIP"]={
        ["_config"]={{vector3(-2151.5739746094,5191.2548828125,14.718822479248)},110,5,"VIP Gun Store",{"vip.gunstore"},true},
        ["WEAPON_GOLDAK"]={"Golden AK-47",750000,0,"N/A","w_ar_goldak"},
        ["WEAPON_FIREEXTINGUISHER"]={"Fire Extinguisher",10000,0,"N/A","prop_fire_exting_1b"},
        ["WEAPON_MJOLNIR"]={"Mjlonir",10000,0,"N/A","w_me_mjolnir"},
        ["WEAPON_MOLOTOV"]={"Molotov Cocktail",5000,0,"N/A","w_ex_molotov"},
        -- smoke grenade
        ["WEAPON_SNOWBALL"]={"Snowball",10000,0,"N/A","w_ex_snowball"},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup"},
        ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02"},
    },
    ["Rebel"]={
        ["_config"]={{vector3(1545.2521972656,6331.5615234375,23.07857131958),vector3(4925.6259765625,-5243.0908203125,1.524599313736)},110,5,"Rebel Gun Store",{"rebellicense.whitelisted"},true},
        ["GADGET_PARACHUTE"]={"Parachute",1000,0,"N/A","p_parachute_s"},
        ["WEAPON_AK200"]={"AK-200",750000,0,"N/A","w_ar_akkal"},
        ["WEAPON_AKM"]={"AKM",700000,0,"N/A","w_ar_akm"},
        ["WEAPON_REVOLVER"]={"Revolver",200000,0,"N/A","w_pi_revolver"},
        ["WEAPON_SPAS12"]={"Spas 12",400000,0,"N/A","w_sg_spaz"},
        ["WEAPON_SVD"]={"Dragunov SVD",2500000,0,"N/A","w_sr_svd"},
        ["WEAPON_WINCHESTER12"]={"Winchester 12",350000,0,"N/A","w_sg_winchester12"},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup"},
        ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02"},
        ["item3"]={"LVL 3 Armour",75000,0,"N/A","prop_bodyarmour_03"},
        ["item4"]={"LVL 4 Armour",100000,0,"N/A","prop_bodyarmour_04"},
        ["item|fillUpArmour"]={"Replenish Armour",100000,0,"N/A","prop_armour_pickup"},
    },
    ["LargeArmsDealer"]={
        ["_config"]={{vector3(-1108.3199462891,4934.7392578125,217.35540771484),vector3(5065.6201171875,-4591.3857421875,1.8652405738831)},110,1,"Large Arms Dealer",{"gang.whitelisted"},false},
        ["WEAPON_GOLDAK"]={"AK-47 Assault Rifle",750000,0,"N/A","w_ar_goldak",750000},
        ["WEAPON_MOSIN"]={"Mosin Bolt-Action",900000,0,"N/A","w_ar_mosin",900000},
        ["WEAPON_OLYMPIA"]={"Olympia Shotgun",900000,0,"N/A","w_sg_olympia",900000},
        ["WEAPON_UMP45"]={"UMP45 SMG",300000,0,"N/A","w_sb_ump45",300000},
        ["WEAPON_UZI"]={"Uzi SMG",250000,0,"N/A","w_sb_uzi",250000},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup",25000},
        ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02",50000},
    },
    ["SmallArmsDealer"]={
        ["_config"]={{vector3(2437.5708007813,4966.5610351563,41.34761428833),vector3(-1500.4978027344,-216.72758483887,46.889373779297),vector3(1242.7232666016,-426.84201049805,67.913963317871),vector3(1242.791,-426.7525,67.93467)},110,1,"Small Arms Dealer",{""},true},
        ["WEAPON_BERETTA"]={"Berreta M9 Pistol",60000/2,0,"N/A","w_pi_beretta"},
        ["WEAPON_M1911"]={"M1911 Pistol",60000/2,0,"N/A","w_pi_m1911"},
        ["WEAPON_MPX"]={"MPX",300000/2,0,"N/A","w_pi_beretta"}, -- need model
        ["WEAPON_PYTHON"]={"Python .357 Revolver",50000/2,0,"N/A","w_pi_python"},
        ["WEAPON_ROOK"]={"Rook 9mm",60000/2,0,"N/A","w_pi_rook"},
        ["WEAPON_TEC9"]={"Tec-9",50000/2,0,"N/A","w_sb_tec9"},
        ["WEAPON_UMP45"]={"UMP-45",300000/2,0,"N/A","w_sb_ump45"},
        ["item1"]={"LVL 1 Armour",25000/2,0,"N/A","prop_armour_pickup"},
    },
    ["Legion"]={
        ["_config"]={{vector3(-3171.5241699219,1087.5402832031,19.838747024536),vector3(-330.56484985352,6083.6059570312,30.454759597778),vector3(2567.6704101562,294.36923217773,107.70868457031)},154,1,"B&Q Tool Shop",{""},true},
        ["WEAPON_BROOM"]={"Broom",2500,0,"N/A","w_me_broom"},
        ["WEAPON_BASEBALLBAT"]={"Baseball Bat",2500,0,"N/A","w_me_baseballbat"},
        ["WEAPON_CLEAVER"]={"Cleaver",7500,0,"N/A","w_me_cleaver"},
        ["WEAPON_CRICKETBAT"]={"Cricket Bat",2500,0,"N/A","w_me_cricketbat"},
        ["WEAPON_DILDO"]={"Dildo",2500,0,"N/A","w_me_dildo"},
        ["WEAPON_FIREAXE"]={"Fireaxe",2500,0,"N/A","w_me_fireaxe"},
        ["WEAPON_GUITAR"]={"Guitar",2500,0,"N/A","w_me_guitar"},
        ["WEAPON_HAMAXEHAM"]={"Hammer Axe Hammer",2500,0,"N/A","w_me_hamaxeham"},
        ["WEAPON_KITCHENKNIFE"]={"Kitchen Knife",7500,0,"N/A","w_me_kitchenknife"},
        ["WEAPON_SHANK"]={"Shank",7500,0,"N/A","w_me_shank"},
        ["WEAPON_SLEDGEHAMMER"]={"Sledge Hammer",2500,0,"N/A","w_me_sledgehammer"},
        ["WEAPON_TOILETBRUSH"]={"Toilet Brush",2500,0,"N/A","w_me_toiletbrush"},
        ["WEAPON_TRAFFICSIGN"]={"Traffic Sign",2500,0,"N/A","w_me_trafficsign"},
        ["WEAPON_SHOVEL"]={"Shovel",2500,0,"N/A","w_me_shovel"},
    },
}
local organheist = module('cfg/cfg_organheist')

MySQL.createCommand("ARMA/get_weapons", "SELECT weapon_info FROM arma_weapon_whitelists WHERE user_id = @user_id")
MySQL.createCommand("ARMA/set_weapons", "UPDATE arma_weapon_whitelists SET weapon_info = @weapon_info WHERE user_id = @user_id")
MySQL.createCommand("ARMA/add_user", "INSERT IGNORE INTO arma_weapon_whitelists SET user_id = @user_id")
MySQL.createCommand("ARMA/get_all_weapons", "SELECT * FROM arma_weapon_whitelists")
MySQL.createCommand("ARMA/create_weapon_code", "INSERT IGNORE INTO arma_weapon_codes SET user_id = @user_id, spawncode = @spawncode, weapon_code = @weapon_code")
MySQL.createCommand("ARMA/remove_weapon_code", "DELETE FROM arma_weapon_codes WHERE weapon_code = @weapon_code")
MySQL.createCommand("ARMA/get_weapon_codes", "SELECT * FROM arma_weapon_codes")

AddEventHandler("playerJoining", function()
    local user_id = ARMA.getUserId(source)
    MySQL.execute("ARMA/add_user", {user_id = user_id})
end)

local whitelistedGuns = {
    -- [store] = {
    --     [weapon_spawncode] = {weapon_name, weapon_price, 0, "N/A", model, owner_userid}
    -- }
    ["policeLargeArms"]={
        ["WEAPON_AX50"]={"AX 50",0,0,"N/A","w_sr_ax50",1},
        ["WEAPON_MK18V2"]={"MK18 V2",0,0,"N/A","w_ar_mk18v2",33}
    },
    -- ["policeSmallArms"]={},
    -- ["prisonArmoury"]={},
    -- ["NHS"]={},
    -- ["LFB"]={},
    -- ["VIP"]={},
    -- ["Rebel"]={},
    ["LargeArmsDealer"] = {
        ["WEAPON_AMELIV"]={"CETME Ameli",2000000,0,"N/A","w_mg_ameliv",3},
    },
    -- ["SmallArmsDealer"] = {},
    -- ["Legion"] = {},
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
            if v['weapon_info'] ~= nil then
                data = json.decode(v['weapon_info'])
                for a,b in pairs(data) do
                    if b[spawncode] then
                        whitelistOwners[v['user_id']] = (exports['ghmattimysql']:executeSync("SELECT username FROM arma_users WHERE id = @user_id", {user_id = v['user_id']})[1]).username
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
RegisterCommand("addweaponwhitelist", addweaponwhitelist, true)


function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

RegisterNetEvent("ARMA:requestNewGunshopData")
AddEventHandler("ARMA:requestNewGunshopData",function()
    local source = source
    local user_id = ARMA.getUserId(source)
    MySQL.query("ARMA/get_weapons", {user_id = user_id}, function(weaponWhitelists)
        local gunstoreData = deepcopy(cfg.GunStores)
        if weaponWhitelists[1]['weapon_info'] ~= nil then
            local data = json.decode(weaponWhitelists[1]['weapon_info'])
            for a,b in pairs(gunstoreData) do
                for c,d in pairs(data) do
                    if a == c then
                        for e,f in pairs(data[a]) do
                            gunstoreData[a][e] = f
                        end
                    end
                end
            end
        end
        for k,v in pairs(gunstoreData) do
            local hasPerm = false
            if v['_config'] then
                if json.encode(v['_config'][5]) ~= '[""]' then
                    local hasPermissions = 0
                    for a,b in pairs(v['_config'][5]) do
                        if ARMA.hasPermission(user_id, b) then
                            hasPermissions = hasPermissions + 1
                        end
                    end
                    if hasPermissions == #v['_config'][5] then
                        hasPerm = true
                    end
                else
                    hasPerm = true
                end
            end
            if not hasPerm then
                gunstoreData[k] = nil
            end
        end
        TriggerClientEvent('ARMA:recieveFilteredGunStoreData', source, gunstoreData)
    end)
end)

function gunStoreLogs(weaponshop, webhook, title, text)
    if weaponshop == 'policeLargeArms' or weaponshop == 'policeSmallArms' then
        tARMA.sendWebhook('pd-armoury', 'ARMA Police Armoury Logs', text)
    elseif weaponshop == 'NHS' then
        tARMA.sendWebhook('nhs-armoury', 'ARMA NHS Armoury Logs', text)
    elseif weaponshop == 'prisonArmoury' then
        tARMA.sendWebhook('hmp-armoury', 'ARMA HMP Armoury Logs', text)
    elseif weaponshop == 'LFB' then
        tARMA.sendWebhook('lfb-armoury', 'ARMA LFB Armoury Logs', text)
    end
    tARMA.sendWebhook(webhook,title,text)
end

RegisterNetEvent("ARMA:buyWeapon")
AddEventHandler("ARMA:buyWeapon",function(spawncode, price, name, weaponshop, purchasetype, vipstore)
    local source = source
    local user_id = ARMA.getUserId(source)
    local hasPerm = false
    local gunstoreData = deepcopy(cfg.GunStores)
    MySQL.query("ARMA/get_weapons", {user_id = user_id}, function(weaponWhitelists)
        local gunstoreData = deepcopy(cfg.GunStores)
        if weaponWhitelists[1]['weapon_info'] ~= nil then
            local data = json.decode(weaponWhitelists[1]['weapon_info'])
            for a,b in pairs(gunstoreData) do
                for c,d in pairs(data) do
                    if a == c then
                        for e,f in pairs(data[a]) do
                            gunstoreData[a][e] = f
                        end
                    end
                end
            end
        end
        for k,v in pairs(gunstoreData[weaponshop]) do
            if k == '_config' then
                local withinRadius = false
                for a,b in pairs(v[1]) do
                    if #(GetEntityCoords(GetPlayerPed(source)) - b) < 10 then
                        withinRadius = true
                    end
                end
                if vipstore then
                    if #(GetEntityCoords(GetPlayerPed(source)) - gunstoreData["VIP"]['_config'][1][1] ) < 10 then
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
                if not withinRadius then return end
                if json.encode(v[5]) ~= '[""]' then
                    local hasPermissions = 0
                    for a,b in pairs(v[5]) do
                        if ARMA.hasPermission(user_id, b) then
                            hasPermissions = hasPermissions + 1
                        end
                    end
                    if hasPermissions == #v[5] then
                        hasPerm = true
                    end
                else
                    hasPerm = true
                end
                for c,d in pairs(gunstoreData[weaponshop]) do
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
                                                gunStoreLogs(weaponshop, 'weapon-shops',"ARMA Weapon Shop Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
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
                                            gunStoreLogs(weaponshop, 'weapon-shops',"ARMA Weapon Shop Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                            if weaponshop == 'LargeArmsDealer' then
                                                ARMA.turfSaleToGangFunds(price, 'LargeArms')
                                            end
                                        else
                                            ARMAclient.notify(source, {'~r~You do not have enough money for this purchase.'})
                                            TriggerClientEvent("arma:PlaySound", source, 2)
                                        end
                                    elseif purchasetype == 'weapon' then
                                        ARMAclient.hasWeapon(source, {spawncode}, function(hasWeapon)
                                            if hasWeapon then
                                                ARMAclient.notify(source, {'~r~You must store your current '..name..' before purchasing another.'})
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
                                                    gunStoreLogs(weaponshop, 'weapon-shops',"ARMA Weapon Shop Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                                else
                                                    ARMAclient.notify(source, {'~r~You do not have enough money for this purchase.'})
                                                    TriggerClientEvent("arma:PlaySound", source, 2)
                                                end
                                            end
                                        end)
                                    elseif purchasetype == 'ammo' then
                                        price = price/2
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
                                            gunStoreLogs(weaponshop, 'weapon-shops',"ARMA Weapon Shop Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                        else
                                            ARMAclient.notify(source, {'~r~You do not have enough money for this purchase.'})
                                            TriggerClientEvent("arma:PlaySound", source, 2)
                                        end
                                    end
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
end)