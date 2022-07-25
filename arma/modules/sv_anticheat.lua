local m = module("arma-vehicles", "garages")
m=m.garage_types
local f = module("arma-weapons", "cfg_weaponsonback")
f=f.RealWeapons

local gettingScreenshot = false

local cheatingCrashes = { -- Place all known cheating crashes here, they will be logged
    --'Exiting' (Example)
    'Game crashed: GTA5_b2189.exe!rage::grcTextureFactoryDX11::PopRenderTarget (0xfd)',
    'Game crashed: GTA5_b2189.exe!sub_141377114 (0x2e)',
}

local actypes = {
    {type = 1, desc = 'Noclip'},
    {type = 2, desc = 'Spawning of Weapon(s)'},
    {type = 3, desc = 'Explosion Event'},
    {type = 4, desc = 'Blacklisted Event'},
    {type = 5, desc = 'Removal of Weapon(s)'},
    {type = 6, desc = 'Godmode'},
    {type = 7, desc = 'Mod Menu'},
    {type = 8, desc = 'Weapon Modifier'},
    {type = 9, desc = 'Armour Modifier'},
    {type = 10, desc = 'Health Modifier'},
    {type = 11, desc = 'Server Trigger'},
}

local allowedEntities = {
    [`prop_v_parachute`] = true,
    [`imp_prop_impexp_para_s`] = true,
    [`prop_ld_jerrycan_01`] = true,
    [`prop_amb_phone`] = true,
    [`ba_prop_battle_glowstick_01`] = true,
    [`ba_prop_battle_hobby_horse`] = true,
    [`p_amb_brolly_01`] = true,
    [`prop_notepad_01`] = true,
    [`prop_pencil_01`] = true,
    [`hei_prop_heist_box`] = true,
    [`prop_single_rose`] = true,
    [`prop_cs_ciggy_01`] = true,
    [`hei_heist_sh_bong_01`] = true,
    [`prop_ld_suitcase_01`] = true,
    [`prop_security_case_01`] = true,
    [`p_amb_coffeecup_01`] = true,
    [`prop_drink_whisky`] = true,
    [`prop_amb_beer_bottle`] = true,
    [`prop_plastic_cup_02`] = true,
    [`prop_cs_burger_01`] = true,
    [`prop_sandwich_01`] = true,
    [`prop_ecola_can`] = true,
    [`prop_choc_ego`] = true,
    [`prop_drink_redwine`] = true,
    [`prop_champ_flute`] = true,
    [`prop_drink_champ`] = true,
    [`prop_cigar_02`] = true,
    [`prop_cigar_01`] = true,
    [`prop_acc_guitar_01`] = true,
    [`prop_el_guitar_01`] = true,
    [`prop_el_guitar_03`] = true,
    [`prop_cigar_02`] = true,
    [`prop_novel_01`] = true,
    [`prop_snow_flower_02`] = true,
    [`v_ilev_mr_rasberryclean`] = true,
    [`p_michael_backpack_s`] = true,
    [`p_amb_clipboard_01`] = true,
    [`prop_tourist_map_01`] = true,
    [`prop_beggers_sign_03`] = true,
    [`prop_anim_cash_pile_01`] = true,
    [`prop_pap_camera_01`] = true,
    [`ba_prop_battle_champ_open`] = true,
    [`p_cs_joint_02`] = true,
    [`prop_amb_ciggy_01`] = true,
    [`prop_ld_case_01`] = true,
    [`prop_cs_tablet`] = true,
    [`prop_npc_phone_02`] = true,
    [`prop_sponge_01`] = true,
    [`hei_prop_heist_drill`] = true,
    [`p_cargo_chute_s`] = true,
    [`prop_drop_crate_01_set2`] = true,
    [`xs_prop_arena_crate_01a`] = true,
    [`p_parachute1_mp_s`] = true,
    [`p_parachute1_sp_s`] = true,
    [`sr_prop_specraces_para_s_01`] = true,
    [`lts_p_para_pilot2_sp_s`] = true,
    [`pil_p_para_pilot_sp_s`] = true,
    [`p_parachute1_s`] = true,
    [`sr_prop_specraces_para_s`] = true,
    [`gr_prop_gr_para_s_01`] = true,
    [`xm_prop_x17_para_sp_s`] = true,
    [`p_cs_cuffs_02_s`] = true,
    [`p_parachute1_mp_dec`] = true,
    [`p_parachute1_s`] = true,
    [`p_parachute1_mp_s`] = true,
    [`p_parachute1_sp_dec`] = true,
    [`prop_roadcone01a`] = true,
    [`prop_roadcone02b`] = true,
    [`prop_gazebo_02`] = true,
    [`prop_worklight_03b`] = true,
    [`prop_barrier_work05`] = true,
    [`ba_prop_battle_barrier_02a`] = true,
    [`prop_mp_barrier_01`] = true,
    [`prop_mp_barrier_01b`] = true,
}

local otherVehicles = {
    [`Seashark`] = true,
    [`devevo`] = true,
    [`titan`] = true,
    [`bmx`] = true,
    [`d1nger`] = true,
}



AddEventHandler('ARMA:playerLeave', function(user_id, source, reason)
    if user_id ~= nil then
        for k,v in pairs(cheatingCrashes) do
            if v == reason then
                PerformHttpRequest('https://discord.com/api/webhooks/999463264616468499/O-tprA7VriJJuGbNg-QtlHoaG3VTlKwtWPD2cD-rnc2D3XDvT2C66hx8GFkWL-6BKGFc', function(err, text, headers) 
                end, "POST", json.encode({username = "ARMA Logs", avatar_url = image, embeds = {
                    {
                        ["color"] = 16448403,
                        ["title"] = "Cheating Crash Error",
                        ["description"] = "> Name: **"..GetPlayerName(source).."**\n> Perm ID: **"..user_id.."**\n> Temp ID: **"..source.."**\n> Reason: **" .. reason .. "**\n\n*These can sometimes be false positives, if a person flags 2 or more times they are most likely cheating*",
                        ["footer"] = {
                            ["text"] = "ARMA - "..os.date("%c"),
                            ["icon_url"] = "",
                        }
                }
                }}), { ["Content-Type"] = "application/json" })
            end
        end
    end
end)

AddEventHandler('entityCreating', function(entity)
    local model = GetEntityModel(entity)
    allowSpawn = false
    for k,v in pairs(m) do
        for a,l in pairs(v) do
            if model == GetHashKey(a) or allowedEntities[model] or otherVehicles[(GetEntityModel(entity))] then
                allowSpawn = true
            end
        end
    end
    for c,d in pairs(f) do
        if model == GetHashKey(d.model) then
            allowSpawn = true
        end
    end
    if not allowSpawn then
        CancelEvent()
    end
end)

-- We are not Banning for " entityCreating " as it can cause false Bans.

-- 
-- Type #1 [Noclip]
-- Type #2 [Spawning Weapons]
-- Type #3 [Explosion Event]
-- Type #4 [Blacklisted Event]
-- Type #5 [Removing Weapons]
-- Type #6 [Godmode]
-- Type #7 [Mod Menu]
-- Type #8 [Weapon Modifiers]
-- Type #9 [Armour Modifier]
-- Type #10 [Health Modifier]
-- Type #11 [Server Triggers]

-- No-Clip Handler
RegisterServerEvent("ARMA:acType1")
AddEventHandler("ARMA:acType1", function()
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)
    local name = GetPlayerName(source)
    if not ARMA.hasPermission(user_id, "admin.noclip") then -- give this group to users you do want getting banned for No-Clipping
        if not table.includes(carrying, player) then
            Wait(500)
            TriggerEvent("ARMA:acBan", user_id, 1, name, player)
        end
    end
end)


function table.includes(table,p)
    for q,r in pairs(table)do 
        if r==p then 
            return true 
        end 
    end
    return false 
end


RegisterServerEvent("ARMA:acType2") -- Player Spawned Weapon!
AddEventHandler("ARMA:acType2", function(theweapon)
	local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("ARMA:acBan", user_id, 2, name, player, theweapon)
end)


local BlockedExplosions = {0, 1, 2, 4, 5, 25, 32, 33, 35, 35, 36, 37, 38, 45}
AddEventHandler('explosionEvent', function(source, ev)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)
    local name = GetPlayerName(source)
    for k, v in ipairs(BlockedExplosions) do 
        if ev.explosionType == v then
            ev.damagescale = 0.0
            CancelEvent()
            Wait(500)
            TriggerEvent("ARMA:acBan", user_id, 3, name, player)
        end
    end
end)

local BlacklistedEvents = { -- Place any events that you do not want running
    "esx:getSharedObject",
    "bank:transfer",
    "esx_ambulancejob:revive",
    "esx-qalle-jail:openJailMenu",
    "esx_jailer:wysylandoo",
    "esx_policejob:getarrested",
    "esx_society:openBossMenu",
    "esx:spawnVehicle",
    "esx_status:set",
    "HCheat:TempDisableDetection",
    "UnJP",
    "8321hiue89js",
    "adminmenu:allowall",
    "AdminMenu:giveBank",
    "AdminMenu:giveCash",
    "AdminMenu:giveDirtyMoney",
    "Tem2LPs5Para5dCyjuHm87y2catFkMpV",
    "esx_dmvschool:pay"
}

for i, eventName in ipairs(BlacklistedEvents) do
RegisterNetEvent(eventName)
AddEventHandler(eventName, function()
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)
    local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("ARMA:acBan", user_id, 4, name, player)
end)
end

AddEventHandler('removeWeaponEvent', function(pedid, weaponType)
    CancelEvent()
    local source = source
    local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("ARMA:acBan", user_id, 5, name, player)
end)

AddEventHandler("giveWeaponEvent", function(source)
    CancelEvent()
    local source = source
    local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("ARMA:acBan", user_id, 5, name, player)
end)

AddEventHandler("removeAllWeaponsEvent", function(source)
    CancelEvent()
    local source = source
    local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("ARMA:acBan", user_id, 5, name, player)
end)

RegisterServerEvent("ARMA:acType6")
AddEventHandler("ARMA:acType6", function()
    local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)
	local name = GetPlayerName(source)
    if type6enabled then
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 6, name, player)
    end
end)

RegisterServerEvent("ARMA:acType7")
AddEventHandler("ARMA:acType7", function(modmenu)
    local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("ARMA:acBan", user_id, 7, name, player, modmenu)
end)

RegisterServerEvent("ARMA:acType8")
AddEventHandler("ARMA:acType8", function(extra)
    local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("ARMA:acBan", user_id, 8, name, player, extra)
end)

RegisterServerEvent("ARMA:acType9")
AddEventHandler("ARMA:acType9", function()
    local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("ARMA:acBan", user_id, 9, name, player)
end)

RegisterServerEvent("ARMA:acType10")
AddEventHandler("ARMA:acType10", function()
    local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("ARMA:acBan", user_id, 10, name, player)
end)

RegisterServerEvent("ARMA:acType11")
AddEventHandler("ARMA:acType11", function(extra)
    local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("ARMA:acBan", user_id, 11, name, player, extra)
end)


---------- Server Events


-- Returns table of ac banned players to anticheat menuu
RegisterServerEvent("ARMA:getAnticheatData")
AddEventHandler("ARMA:getAnticheatData",function()
    local source = source
    user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'dev') then
        local bannedplayerstable = {}
        exports['ghmattimysql']:execute("SELECT * FROM `arma_anticheat`", {}, function(result)
            if result ~= nil then
                for k,v in pairs(result) do
                    bannedplayerstable[v.user_id] = {v.ban_id, v.user_id, v.username, v.reason, v.extra}
                end 
                TriggerClientEvent("ARMA:sendAnticheatData", source, bannedplayerstable, #result, actypes)
            end
        end)
    end
end)

-- Anticheat Ban/Unban Functions
RegisterServerEvent("ARMA:acBan")
AddEventHandler("ARMA:acBan",function(user_id, bantype, name, player, extra)
    local desc = ''
    local reason = ''
    if extra == nil then extra = 'None' end
    if source == '' then
        if not gettingScreenshot then
            for k,v in pairs(actypes) do
                if bantype == v.type then
                    reason = 'Type #'..bantype
                    desc = v.desc
                end
            end
            gettingScreenshot = true
            exports["ac-screenshots"]:requestClientScreenshotUploadToDiscord(player,{
                username = "ARMA Logs",
                avatar_url = image,
                embeds = {
                    {
                        ["color"] = 16448403,
                        ["title"] = "Anticheat Ban (Screenshot Above)",
                        ["description"] = "> Players Name: **"..name.."**\n> Players Perm ID: **"..user_id.."**\n> Reason: **"..reason.."**\n> Type Meaning: **"..desc.."**\n> Extra Info: **"..extra.."**",                        ["footer"] = {
                            ["text"] = "ARMA - "..os.date("%c"),
                            ["icon_url"] = "",
                        }
                    }
                }
            },30000,
            function(error)
                if error then
                    print("^1ERROR: " .. error)
                    local embed = {
                        {
                            ["color"] = 16448403,
                            ["title"] = "Anticheat Ban (Screenshot Failed)",
                            ["description"] = "> Players Name: **"..name.."**\n> Players Perm ID: **"..user_id.."**\n> Reason: **"..reason.."**\n> Type Meaning: **"..desc.."**\n> Extra Info: **"..extra.."**",
                            ["footer"] = {
                                ["text"] = "ARMA - "..os.date("%c"),
                                ["icon_url"] = "",
                            }
                        }
                    }
                    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA Logs", embeds = embed, avatar_url = image}), { ['Content-Type'] = 'application/json' })
                end
                gettingScreenshot = false
                TriggerClientEvent("chatMessage", -1, "^7^*[ARMA Anticheat]", {180, 0, 0}, name .. " ^7 Was Banned | Reason: Cheating "..reason, "alert")
                ARMA.banConsole(user_id,"perm","Cheating "..reason)
                exports['ghmattimysql']:execute("INSERT INTO `arma_anticheat` (`user_id`, `username`, `reason`) VALUES (@user_id, @username, @reason);", {user_id = user_id, username = name, reason = reason}, function() end) 
            end)
        end
    end
end)

RegisterServerEvent("ARMA:acUnban")
AddEventHandler("ARMA:acUnban",function(permid)
    local source = source
    local user_id = ARMA.getUserId(source)
    local playerName = GetPlayerName(source)
    if ARMA.hasGroup(user_id, 'dev') then
        ARMAclient.notify(source,{'~g~AC Unbanned ID: ' .. permid})
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "ARMA Logs", avatar_url = image, embeds = {
            {
                ["color"] = 16448403,
                ["title"] = "Anticheat Unban",
                ["description"] = "> Admin Name: **"..playerName.."**\n> Admin Perm ID: **"..user_id.."**\n> Players Perm ID: **"..permid.."**",
                ["footer"] = {
                    ["text"] = "ARMA - "..os.date("%c"),
                    ["icon_url"] = "",
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        ARMA.setBanned(permid,false)
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to AC Unban Someone')
    end
end)


-- Allows the addition / removal of vehicles to the anticheat whitelist temporarily
RegisterServerEvent("ARMA:editACVehicleWhitelist")
AddEventHandler("ARMA:editACVehicleWhitelist", function(manage)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)
    local name = GetPlayerName(source)
    if ARMA.hasGroup(user_id, 'dev') then
        ARMA.prompt(source,"Spawncode:","",function(source,spawncode)
            if spawncode ~= '' then
                model = GetHashKey(spawncode)
                if manage then
                    if not otherVehicles[model] then
                        otherVehicles[model] = true
                        ARMAclient.notify(source,{"~g~Added "..spawncode.." to the AC Vehicle Whitelist"})
                    else
                        ARMAclient.notify(source,{"~r~"..spawncode.." is already in the AC Vehicle Whitelist"})
                    end
                else
                    if otherVehicles[model] then
                        otherVehicles[model] = false
                        ARMAclient.notify(source,{"~g~Removed "..spawncode.." from the AC Vehicle Whitelist"})
                    else
                        ARMAclient.notify(source,{"~r~"..spawncode.." is not in the AC Vehicle Whitelist"})
                    end
                end
            else
                ARMAclient.notify(source,{"~r~Invalid Input"})
            end
        end)
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to Edit AC Vehicle Whitelist')
    end
end)


----- Creates anticheat tables in database

Citizen.CreateThread(function()
    Wait(2500)
    exports['ghmattimysql']:execute([[
    CREATE TABLE IF NOT EXISTS `arma_anticheat` (
    `ban_id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `username` VARCHAR(100) NOT NULL,
    `reason` VARCHAR(100) NOT NULL,
    `extra` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`ban_id`)
    );]])
    print("[ARMA] ^2Anticheat tables initialised.^0")
end)
