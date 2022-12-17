local f = module("cfg/weapons")
f=f.weapons

local gettingVideo = false

local actypes = {
    {type = 1, desc = 'Noclip'},
    {type = 2, desc = 'Spawning of Weapon(s)'},
    {type = 3, desc = 'Explosion Event'},
    {type = 4, desc = 'Blacklisted Event'},
    {type = 5, desc = 'Removal of Weapon(s)'},
    {type = 6, desc = 'Semi Godmode'},
    {type = 7, desc = 'Mod Menu'},
    {type = 8, desc = 'Weapon Modifier'},
    {type = 9, desc = 'Armour Modifier'},
    {type = 10, desc = 'Health Modifier'},
    {type = 11, desc = 'Server Trigger'},
    {type = 12, desc = 'Vehicle Parachute'},
    {type = 13, desc = 'Night Vision'},
    {type = 14, desc = 'Model Dimensions'},
    {type = 15, desc = 'Godmoding'},
}

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
    if theweapon ~= 'GADGET_PARACHUTE' then
        TriggerEvent("ARMA:acBan", user_id, 2, name, player, theweapon)
    end
end)


local BlockedExplosions = {--0, 
1, 2, --4, 
5, --25, 
32, 33, 35, 35, 36, 37, 38, 45}
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

local BlacklistedEvents = {
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
    local source = pedid
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
    Wait(500)
    TriggerEvent("ARMA:acBan", user_id, 6, name, player)
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

RegisterServerEvent("ARMA:acType12")
AddEventHandler("ARMA:acType12", function(extra)
    local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("ARMA:acBan", user_id, 12, name, player, extra)
end)

RegisterServerEvent("ARMA:acType13")
AddEventHandler("ARMA:acType13", function()
    local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("ARMA:acBan", user_id, 13, name, player)
end)

RegisterServerEvent("ARMA:acType14")
AddEventHandler("ARMA:acType14", function()
    local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)
	local name = GetPlayerName(source)
    Wait(500)
    TriggerEvent("ARMA:acBan", user_id, 14, name, player)
end)

local godmodeVid = false
RegisterServerEvent("ARMA:acType15")
AddEventHandler("ARMA:acType15", function()
    local user_id = ARMA.getUserId(source)
	local player = ARMA.getUserSource(user_id)
	local name = GetPlayerName(source)
    Wait(500)
    if not godmodeVid then
        TriggerClientEvent("ARMA:takeClientVideoAndUpload", player, tARMA.getWebhook('anticheat'))
        Wait(30000)
        godmodeVid = true
    end
    godmodeVid = false
    tARMA.sendWebhook('anticheat', 'Anticheat Log', "> Players Name: **"..name.."**\n> Players Perm ID: **"..user_id.."**\n> Reason: **Type #15**\n> Type Meaning: **Godmoding**")
end)



RegisterServerEvent("ARMA:getAnticheatData")
AddEventHandler("ARMA:getAnticheatData",function()
    local source = source
    user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'Developer') then
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


RegisterServerEvent("ARMA:acBan")
AddEventHandler("ARMA:acBan",function(user_id, bantype, name, player, extra)
    local desc = ''
    local reason = ''
    if extra == nil then extra = 'None' end
    if source == '' then
        if not gettingVideo then
            for k,v in pairs(actypes) do
                if bantype == v.type then
                    reason = 'Type #'..bantype
                    desc = v.desc
                end
            end
            gettingVideo = true
            TriggerClientEvent("ARMA:takeClientVideoAndUpload", player, tARMA.getWebhook('anticheat'))
            Wait(30000)
            gettingVideo = false
            tARMA.sendWebhook('anticheat', 'Anticheat Ban', "> Players Name: **"..name.."**\n> Players Perm ID: **"..user_id.."**\n> Reason: **"..reason.."**\n> Type Meaning: **"..desc.."**\n> Extra Info: **"..extra.."**")
            TriggerClientEvent("chatMessage", -1, "^7^*[ARMA Anticheat]", {180, 0, 0}, name .. " ^7 Was Banned | Reason: Cheating "..reason, "alert")
            ARMA.banConsole(user_id,"perm","Cheating "..reason)
            exports['ghmattimysql']:execute("INSERT INTO `arma_anticheat` (`user_id`, `username`, `reason`, `extra`) VALUES (@user_id, @username, @reason, @extra);", {user_id = user_id, username = name, reason = reason, extra = extra}, function() end) 
        end
    end
end)

RegisterServerEvent("ARMA:acUnban")
AddEventHandler("ARMA:acUnban",function(permid)
    local source = source
    local user_id = ARMA.getUserId(source)
    local playerName = GetPlayerName(source)
    if ARMA.hasGroup(user_id, 'Developer') then
        ARMAclient.notify(source,{'~g~AC Unbanned ID: ' .. permid})
        tARMA.sendWebhook('anticheat', 'Anticheat Unban', "> Admin Name: **"..playerName.."**\n> Admin Perm ID: **"..user_id.."**\n> Players Perm ID: **"..permid.."**")
        ARMA.setBanned(permid,false)
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to AC Unban Someone')
    end
end)


RegisterServerEvent("ARMA:editACVehicleWhitelist")
AddEventHandler("ARMA:editACVehicleWhitelist", function(manage)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)
    local name = GetPlayerName(source)
    if ARMA.hasGroup(user_id, 'Developer') then
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
