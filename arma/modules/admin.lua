local htmlEntities = module("lib/htmlEntities")
local Tools = module("lib/Tools")

RegisterServerEvent('ARMA:OpenSettings')
AddEventHandler('ARMA:OpenSettings', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil then
        if ARMA.hasPermission(user_id, "admin.tickets") then
            TriggerClientEvent("ARMA:OpenAdminMenu", source, true)
        else
            TriggerClientEvent("ARMA:OpenSettingsMenu", source, false)
        end
    end
end)

RegisterCommand("gethours", function(source, args)
    local v = source
    local UID = ARMA.getUserId(v)
    local D = math.ceil(ARMA.getUserDataTable(UID).PlayerTime/60) or 0
    if UID then
        if D > 5000 then
            DropPlayer(v, "[ARMA] You were permanently banned\nReason: Not Touching Grass\nYour ID: "..UID.."\nIf you believe this was a false ban, appeal @ www.idonttouchgrass.com")
        elseif D > 4000 then
            ARMAclient.notify(v,{"~g~You currently have ~b~"..D.." ~g~hours. Almost as bad as Jamo."})
        elseif D > 3000 then
            ARMAclient.notify(v,{"~g~You currently have ~b~"..D.." ~g~hours. Touch some fucking grass."})
        elseif D > 2000 then
            ARMAclient.notify(v,{"~g~You currently have ~b~"..D.." ~g~hours. Seriously, go outside."})
        elseif D > 1000 then
            ARMAclient.notify(v,{"~g~You currently have ~b~"..D.." ~g~hours. Go outside."})
        else
            ARMAclient.notify(v,{"~g~You currently have ~b~"..D.." ~g~hours."})
        end
    end
end)

RegisterCommand("sethours", function(source, args) 
    if source == 0 then 
        local data = ARMA.getUserDataTable(tonumber(args[1]))
        data.PlayerTime = tonumber(args[2])*60
        print(GetPlayerName(ARMA.getUserSource(tonumber(args[1]))).."'s hours have been set to: "..tonumber(args[2]))
    end  
end)


RegisterNetEvent("ARMA:GetNearbyPlayers")
AddEventHandler("ARMA:GetNearbyPlayers", function(dist)
    local source = source
    local user_id = ARMA.getUserId(source)
    local plrTable = {}
    if ARMA.hasPermission(user_id, 'admin.tickets') then
        ARMAclient.getNearestPlayers(source, {dist}, function(nearbyPlayers)
            for k, v in pairs(nearbyPlayers) do
                data = ARMA.getUserDataTable(ARMA.getUserId(k))
                playtime = data.PlayerTime or 0
                PlayerTimeInHours = playtime/60
                if PlayerTimeInHours < 1 then
                    PlayerTimeInHours = 0
                end
                plrTable[ARMA.getUserId(k)] = {GetPlayerName(k), k, ARMA.getUserId(k), math.ceil(PlayerTimeInHours)}
            end
            plrTable[user_id] = {GetPlayerName(source), source, ARMA.getUserId(source), math.ceil((ARMA.getUserDataTable(user_id).PlayerTime/60)) or 0}
            TriggerClientEvent("ARMA:ReturnNearbyPlayers", source, plrTable)
        end)
    end
end)

RegisterServerEvent("ARMA:requestAccountInfosv")
AddEventHandler("ARMA:requestAccountInfosv",function(permid)
    adminrequest = source
    adminrequest_id = ARMA.getUserId(adminrequest)
    requesteduser = permid
    requestedusersource = ARMA.getUserSource(requesteduser)
    if ARMA.hasPermission(adminrequest_id, 'group.remove') then
        TriggerClientEvent('ARMA:requestAccountInfo', ARMA.getUserSource(permid))
    end
end)

RegisterServerEvent("ARMA:receivedAccountInfo")
AddEventHandler("ARMA:receivedAccountInfo", function(gpu,cpu,userAgent)
    if ARMA.hasPermission(adminrequest_id, 'group.remove') then
        ARMA.prompt(adminrequest,"Account Info","GPU: " .. gpu.." \n\nCPU: "..cpu.." \n\nUser Agent: "..userAgent,function(player,K)
        end)
    end
end)

RegisterServerEvent("ARMA:GetGroups")
AddEventHandler("ARMA:GetGroups",function(perm)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("ARMA:GotGroups", source, ARMA.getUserGroups(perm))
    end
end)

RegisterServerEvent("ARMA:CheckPov")
AddEventHandler("ARMA:CheckPov",function(userperm)
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.tickets") then
        if ARMA.hasPermission(userperm, 'pov.list') then
            TriggerClientEvent('ARMA:ReturnPov', source, true)
        elseif not ARMA.hasPermission(userperm, 'pov.list') then
            TriggerClientEvent('ARMA:ReturnPov', source, false)
        end
    end
end)


RegisterServerEvent("wk:fixVehicle")
AddEventHandler("wk:fixVehicle",function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.noclip') then
        TriggerClientEvent('wk:fixVehicle', source)
    end
end)

local spectatingPositions = {}
RegisterServerEvent("ARMA:spectatePlayer")
AddEventHandler("ARMA:spectatePlayer", function(id)
    local playerssource = ARMA.getUserSource(id)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.spectate") then
        if playerssource ~= nil then
            spectatingPositions[user_id] = {coords = GetEntityCoords(GetPlayerPed(source)), bucket = GetPlayerRoutingBucket(source)}
            SetPlayerRoutingBucket(source, GetPlayerRoutingBucket(playerssource))
            TriggerClientEvent('ARMA:setBucket', source, GetPlayerRoutingBucket(playerssource))
            TriggerClientEvent("ARMA:spectatePlayer",source, playerssource, GetEntityCoords(GetPlayerPed(playerssource)))
            tARMA.sendWebhook('spectate',"ARMA Spectate Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(playerssource).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..playerssource.."**")
        else
            ARMAclient.notify(source, {"~r~You can't spectate an offline player."})
        end
    end
end)

RegisterServerEvent("ARMA:stopSpectatePlayer")
AddEventHandler("ARMA:stopSpectatePlayer", function()
    local source = source
    if ARMA.hasPermission(ARMA.getUserId(source), "admin.spectate") then
        TriggerClientEvent("ARMA:stopSpectatePlayer",source)
        for k,v in pairs(spectatingPositions) do
            if k == ARMA.getUserId(source) then
                TriggerClientEvent("ARMA:stopSpectatePlayer",source,v.coords,v.bucket)
                SetEntityCoords(GetPlayerPed(source),v.coords)
                SetPlayerRoutingBucket(source,v.bucket)
                TriggerClientEvent('ARMA:setBucket', source, v.bucket)
                spectatingPositions[k] = nil
            end
        end
    end
end)

RegisterServerEvent("ARMA:Giveweapon")
AddEventHandler("ARMA:Giveweapon",function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "dev.menu") then
        ARMA.prompt(source,"Weapon Name:","",function(source,hash) 
            ARMAclient.allowWeapon(source,{'WEAPON_'..string.upper(hash)})
            GiveWeaponToPed(source, 'weapon_'..hash, 250, false, true)
            ARMAclient.notify(source,{"~g~Successfully spawned ~b~"..hash})
            tARMA.sendWebhook('spawn-weapon',"ARMA Spawn Weapon Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Weapon Spawned: **WEAPON_"..hash.."**")
        end)
    end
end)

RegisterServerEvent("ARMA:GiveWeaponToPlayer")
AddEventHandler("ARMA:GiveWeaponToPlayer",function()
    local admin = source
    local admin_id = ARMA.getUserId(admin)
    local admin_name = GetPlayerName(admin)
    local source = source
    local userid = ARMA.getUserId(source)
    if ARMA.hasPermission(userid, "dev.menu") then
        ARMA.prompt(source,"Perm ID:","",function(source,permid) 
            local permid = tonumber(permid)
            local permsource = ARMA.getUserSource(permid)
            ARMA.prompt(source,"Weapon Name:","",function(source,hash) 
                ARMAclient.allowWeapon(permsource,{'WEAPON_'..string.upper(hash)})
                GiveWeaponToPed(permsource, 'weapon_'..hash, 250, false, true)
                tARMA.sendWebhook('give-weapon',"ARMA Give Weapon Logs", "> Admin Name: **"..GetPlayerName(admin).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Players Name: **"..GetPlayerName(permsource).."**\n> Players TempID: **"..permsource.."**\n> Players PermID: **"..permid.."**\n> Weapon Given: **WEAPON_"..hash.."**")
                ARMAclient.notify(source,{"~g~Successfully gave ~b~"..hash..' ~g~to '..GetPlayerName(permsource)})
            end)
        end)
    end
end)

RegisterServerEvent("ARMA:ForceClockOff")
AddEventHandler("ARMA:ForceClockOff", function(player_temp)
    local source = source
    local user_id = ARMA.getUserId(source)
    local name = GetPlayerName(source)
    local player_perm = ARMA.getUserId(player_temp)
    if ARMA.hasPermission(user_id,"admin.tp2waypoint") then
        ARMA.removeAllJobs(player_perm)
        ARMAclient.notify(source,{'~g~User clocked off'})
        ARMAclient.notify(player_perm,{'~r~You have been force clocked off'})
        tARMA.sendWebhook('force-clock-off',"ARMA Faction Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..GetPlayerName(player_temp).."**\n> Players TempID: **"..player_temp.."**\n> Players PermID: **"..player_perm.."**")
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to Force Clock Off')
    end
end)

RegisterServerEvent("ARMA:AddGroup")
AddEventHandler("ARMA:AddGroup",function(perm, selgroup)
    local admin_temp = source
    local admin_perm = ARMA.getUserId(admin_temp)
    local user_id = ARMA.getUserId(source)
    local permsource = ARMA.getUserSource(perm)
    local playerName = GetPlayerName(source)
    local povName = GetPlayerName(permsource)
    if ARMA.hasPermission(user_id, "group.add") then
        if selgroup == "Founder" and not ARMA.hasPermission(admin_perm, "group.add.founder") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "operationsmanager" and not ARMA.hasPermission(user_id, "group.add.operationsmanager") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "staffmanager" and not ARMA.hasPermission(admin_perm, "group.add.staffmanager") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "commanager" and not ARMA.hasPermission(admin_perm, "group.add.commanager") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "headadmin" and not ARMA.hasPermission(admin_perm, "group.add.headadmin") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "senioradmin" and not ARMA.hasPermission(admin_perm, "group.add.senioradmin") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "administrator" and not ARMA.hasPermission(admin_perm, "group.add.administrator") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "srmoderator" and not ARMA.hasPermission(admin_perm, "group.add.srmoderator") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "moderator" and not ARMA.hasPermission(admin_perm, "group.add.moderator") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "supportteam" and not ARMA.hasPermission(admin_perm, "group.add.supportteam") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "trialstaff" and not ARMA.hasPermission(admin_perm, "group.add.trial") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "vip" and not ARMA.hasPermission(admin_perm, "group.add.vip") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "pov" and not ARMA.hasGroup(perm, "group.add.pov") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        else
            ARMA.addUserGroup(perm, selgroup)
            local user_groups = ARMA.getUserGroups(perm)
            TriggerClientEvent("ARMA:GotGroups", source, user_groups)
            tARMA.sendWebhook('group',"ARMA Group Logs", "> Admin Name: **"..playerName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..GetPlayerName(permsource).."**\n> Players TempID: **"..permsource.."**\n> Players PermID: **"..perm.."**\n> Group: **"..selgroup.."**\n> Type: **Added**")
        end
    end
end)

RegisterServerEvent("ARMA:RemoveGroup")
AddEventHandler("ARMA:RemoveGroup",function(perm, selgroup)
    local user_id = ARMA.getUserId(source)
    local admin_temp = source
    local permsource = ARMA.getUserSource(perm)
    local playerName = GetPlayerName(source)
    local povName = GetPlayerName(permsource)
    if ARMA.hasPermission(user_id, "group.remove") then
        if selgroup == "Founder" and not ARMA.hasPermission(user_id, "group.remove.founder") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "operationsmanager" and not ARMA.hasPermission(user_id, "group.remove.operationsmanager") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "staffmanager" and not ARMA.hasPermission(user_id, "group.remove.staffmanager") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "commanager" and not ARMA.hasPermission(user_id, "group.remove.commanager") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "headadmin" and not ARMA.hasPermission(user_id, "group.remove.headadmin") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "senioradmin" and not ARMA.hasPermission(user_id, "group.remove.senioradmin") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "administrator" and not ARMA.hasPermission(user_id, "group.remove.administrator") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "srmoderator" and not ARMA.hasPermission(user_id, "group.remove.srmoderator") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "moderator" and not ARMA.hasPermission(user_id, "group.remove.moderator") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "supportteam" and not ARMA.hasPermission(user_id, "group.remove.supportteam") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "trialstaff" and not ARMA.hasPermission(user_id, "group.remove.trial") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "vip" and not ARMA.hasPermission(user_id, "group.remove.vip") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "pov" and not ARMA.hasGroup(perm, "group.remove.pov") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        else
            ARMA.removeUserGroup(perm, selgroup)
            local user_groups = ARMA.getUserGroups(perm)
            TriggerClientEvent("ARMA:GotGroups", source, user_groups)
            tARMA.sendWebhook('group',"ARMA Group Logs", "> Admin Name: **"..playerName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..GetPlayerName(permsource).."**\n> Players TempID: **"..permsource.."**\n> Players PermID: **"..perm.."**\n> Group: **"..selgroup.."**\n> Type: **Removed**")
        end
    end
end)

local bans = {
    {id = "trolling",name = "1.0 Trolling",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "trollingminor",name = "1.0 Trolling (Minor)",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "metagaming",name = "1.1 Metagaming",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "powergaming",name = "1.2 Power Gaming ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "failrp",name = "1.3 Fail RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "rdm", name = "1.4 RDM",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
    {id = "massrdm",name = "1.4.1 Mass RDM",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "nrti",name = "1.5 No Reason to Initiate (NRTI) ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "vdm", name = "1.6 VDM",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
    {id = "massvdm",name = "1.6.1 Mass VDM",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "offlanguageminor",name = "1.7 Offensive Language/Toxicity (Minor)",durations = {2,24,72},bandescription = "1st Offense: 2hr\n2nd Offense: 24hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "offlanguagestandard",name = "1.7 Offensive Language/Toxicity (Standard)",durations = {48,72,168},bandescription = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "offlanguagesevere",name = "1.7 Offensive Language/Toxicity (Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "breakrp",name = "1.8 Breaking Character",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "combatlog",name = "1.9 Combat logging",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "combatstore",name = "1.10 Combat storing",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "exploitingstandard",name = "1.11 Exploiting (Standard)",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "exploitingsevere",name = "1.11 Exploiting (Severe)",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "oogt",name = "1.12 Out of game transactions (OOGT)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "spitereport",name = "1.13 Spite Reporting",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "scamming",name = "1.14 Scamming",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "loans",name = "1.15 Loans",durations = {48,168,-1},bandescription = "1st Offense: 48hr\n2nd Offense: 168hr\n3rd Offense: Permanent",itemchecked = false},
    {id = "wastingadmintime",name = "1.16 Wasting Admin Time",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "ftvl",name = "2.1 Value of Life",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "sexualrp",name = "2.2 Sexual RP",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "terrorrp",name = "2.3 Terrorist RP",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "impwhitelisted",name = "2.4 Impersonation of Whitelisted Factions",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gtadriving",name = "2.5 GTA Online Driving",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "nlr", name = "2.6 NLR",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
    {id = "badrp",name = "2.7 Bad RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "kidnapping",name = "2.8 Kidnapping",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "stealingems",name = "3.0 Theft of Emergency Vehicles",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "whitelistabusestandard",name = "3.1 Whitelist Abuse",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "whitelistabusesevere",name = "3.1 Whitelist Abuse",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "copbaiting",name = "3.2 Cop Baiting",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "pdkidnapping",name = "3.3 PD Kidnapping",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "unrealisticrevival",name = "3.4 Unrealistic Revival",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "interjectingrp",name = "Interjection of RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "combatrev",name = "3.5 Combat Reviving",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gangcap",name = "3.6 Gang Cap",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "maxgang",name = "3.7 Max Gang Numbers",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "gangalliance",name = "3.8 Gang Alliance",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "impgang",name = "3.10 Impersonation of Gangs",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gzstealing",name = "4.1 Stealing Vehicles in Greenzone",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "gzillegal",name = "4.2 Selling Illegal Items in Greenzone",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gzretretreating",name = "4.3 Greenzone Retreating ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "rzhostage",name = "4.5 Taking Hostage into Redzone",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "rzretreating",name = "4.6 Redzone Retreating",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "advert",name = "1.1 Advertising",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "bullying",name = "1.2 Bullying",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "impersonationrule",name = "1.3 Impersonation",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "language",name = "1.4 Language",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "discrim",name = "1.5 Discrimination ",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "attacks",name = "1.6 Malicious Attacks ",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false    },
    {id = "PIIstandard",name = "1.7 PII (Personally Identifiable Information)(Standard)",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "PIIsevere",name = "1.7 PII (Personally Identifiable Information)(Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "chargeback",name = "1.8 Chargeback",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "discretion",name = "1.9 Staff Discretion",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false    },
    {id = "cheating",name = "1.10 Cheating",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "banevading",name = "1.11 Ban Evading",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "fivemcheats",name = "1.12 Withholding/Storing FiveM Cheats",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "altaccount",name = "1.13 Multi-Accounting",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "association",name = "1.14 Association with External Modifications",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "pov",name = "1.15 Failure to provide POV ",durations = {-1,-1,-1},bandescription = "1st Offense: 2hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false    },
    {id = "withholdinginfostandard",name = "1.16 Withholding Information From Staff (Standard)",durations = {48,72,168},bandescription = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "withholdinginfosevere",name = "1.16 Withholding Information From Staff (Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "blackmail",name = "1.17 Blackmailing",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false}
}
    
   

local PlayerOffenses = {}
local PlayerBanCachedDuration = {}
local defaultBans = {}

RegisterServerEvent("ARMA:GenerateBan")
AddEventHandler("ARMA:GenerateBan", function(PlayerID, RulesBroken)
    local source = source
    local PlayerCacheBanMessage = {}
    local PermOffense = false
    local separatormsg = {}
    local points = 0
    PlayerBanCachedDuration[PlayerID] = 0
    PlayerOffenses[PlayerID] = {}
    if ARMA.hasPermission(ARMA.getUserId(source), "admin.tickets") then
        exports['ghmattimysql']:execute("SELECT * FROM arma_bans_offenses WHERE UserID = @UserID", {UserID = PlayerID}, function(result)
            if #result > 0 then
                points = result[1].points
                PlayerOffenses[PlayerID] = json.decode(result[1].Rules)
                for k,v in pairs(RulesBroken) do
                    for a,b in pairs(bans) do
                        if b.id == k then
                            PlayerOffenses[PlayerID][k] = PlayerOffenses[PlayerID][k] + 1
                            if PlayerOffenses[PlayerID][k] > 3 then
                                bans[a].durations[PlayerOffenses[PlayerID][k]] = bans[a].durations[PlayerOffenses[PlayerID][3]]
                            end
                            PlayerBanCachedDuration[PlayerID] = PlayerBanCachedDuration[PlayerID] + bans[a].durations[PlayerOffenses[PlayerID][k]]
                            if bans[a].durations[PlayerOffenses[PlayerID][k]] ~= -1 then
                                points = points + bans[a].durations[PlayerOffenses[PlayerID][k]]/24
                            else
                                points = 10
                            end
                            table.insert(PlayerCacheBanMessage, bans[a].name)
                            if bans[a].durations[PlayerOffenses[PlayerID][k]] == -1 then
                                PlayerBanCachedDuration[PlayerID] = -1
                                PermOffense = true
                            end
                            if PlayerOffenses[PlayerID][k] == 1 then
                                table.insert(separatormsg, bans[a].name ..' ~y~| ~w~1st Offense ~y~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            elseif PlayerOffenses[PlayerID][k] == 2 then
                                table.insert(separatormsg, bans[a].name ..' ~y~| ~w~2nd Offense ~y~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            elseif PlayerOffenses[PlayerID][k] >= 3 then
                                table.insert(separatormsg, bans[a].name ..' ~y~| ~w~3rd Offense ~y~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            end
                        end
                    end
                end
                if PermOffense then 
                    PlayerBanCachedDuration[PlayerID] = -1
                end
                Wait(1500)
                TriggerClientEvent("ARMA:RecieveBanPlayerData", source, PlayerBanCachedDuration[PlayerID], table.concat(PlayerCacheBanMessage, ", "), separatormsg, math.floor(points))
            end
        end)
    end
end)

AddEventHandler("playerJoining", function()
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(bans) do
        defaultBans[v.id] = 0
    end
    exports["ghmattimysql"]:executeSync("INSERT IGNORE INTO arma_bans_offenses(UserID,Rules) VALUES(@UserID, @Rules)", {UserID = user_id, Rules = json.encode(defaultBans)})
    exports["ghmattimysql"]:executeSync("INSERT IGNORE INTO arma_user_notes(user_id) VALUES(@user_id)", {user_id = user_id})
end)

RegisterCommand('removepoints', function(source, args) -- for removing points each month
    local source = source
    if ARMA.getUserId(source) == 1 then
        removePoints = tonumber(args[1])
        exports['ghmattimysql']:execute("UPDATE arma_bans_offenses SET points = CASE WHEN ((points-@removepoints)>0) THEN (points-@removepoints) ELSE 0 END WHERE points > 0", {removepoints = removePoints}, function() end)
        ARMAclient.notify(source, {'~g~Removed '..removePoints..' points from all users.'})
    end
end)

RegisterServerEvent("ARMA:BanPlayer")
AddEventHandler("ARMA:BanPlayer", function(PlayerID, Duration, BanMessage, BanPoints)
    local source = source
    local AdminPermID = ARMA.getUserId(source)
    local AdminName = GetPlayerName(source)
    local CurrentTime = os.time()
    local PlayerDiscordID = 0

    ARMA.prompt(source, "Extra Ban Information (Hidden)","",function(player, Evidence)
        if ARMA.hasPermission(AdminPermID, "admin.tickets") then
            if Evidence == "" then
                ARMAclient.notify(source, {"~r~Evidence field was left empty, please fill this in via Discord."})
            end
            if Duration == -1 then
                banDuration = "perm"
            else
                banDuration = CurrentTime + (60 * 60 * tonumber(Duration))
            end
            tARMA.sendWebhook('ban-player', AdminName.. " banned "..PlayerID, "> Admin Name: **"..AdminName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..AdminPermID.."**\n> Players PermID: **"..PlayerID.."**\n> Ban Duration: **"..Duration.."**")
            ARMA.ban(source,PlayerID,banDuration,BanMessage,Evidence)
            f10Ban(PlayerID, AdminName, BanMessage, Duration)
            exports['ghmattimysql']:execute("UPDATE arma_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = BanPoints}, function() end)
            local a = exports['ghmattimysql']:executeSync("SELECT * FROM arma_bans_offenses WHERE UserID = @uid", {uid = PlayerID})
            for k,v in pairs(a) do
                if v.UserID == PlayerID then
                    if v.points > 10 then
                        exports['ghmattimysql']:execute("UPDATE arma_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = 10}, function() end)
                        ARMA.banConsole(PlayerID,2160,"You have reached 10 points and have received a 3 month ban.")
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent('ARMA:RequestScreenshot')
AddEventHandler('ARMA:RequestScreenshot', function(admin,target)
    local target_id = ARMA.getUserId(target)
    local target_name = GetPlayerName(target)
    local admin_id = ARMA.getUserId(admin)
    local admin_name = GetPlayerName(source)
    if ARMA.hasPermission(admin_id, 'admin.screenshot') then
        TriggerClientEvent("ARMA:takeClientScreenshotAndUpload", target, tARMA.getWebhook('screenshot'))
        tARMA.sendWebhook('screenshot', 'ARMA Screenshot Logs', "> Players Name: **"..GetPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..target_id.."**")
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Request Screenshot')
    end   
end)

RegisterServerEvent('ARMA:RequestVideo')
AddEventHandler('ARMA:RequestVideo', function(admin,target)
    local target_id = ARMA.getUserId(target)
    local target_name = GetPlayerName(target)
    local admin_id = ARMA.getUserId(admin)
    local admin_name = GetPlayerName(source)
    if ARMA.hasPermission(admin_id, 'admin.screenshot') then
        TriggerClientEvent("ARMA:takeClientVideoAndUpload", target, tARMA.getWebhook('video'))
        tARMA.sendWebhook('video', 'ARMA Video Logs', "> Players Name: **"..GetPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..target_id.."**")
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Request Screenshot')
    end   
end)

RegisterServerEvent('ARMA:KickPlayer')
AddEventHandler('ARMA:KickPlayer', function(admin, target, reason, tempid)
    local source = source
    local target_id = ARMA.getUserSource(target)
    local target_permid = target
    local playerName = GetPlayerName(source)
    local playerOtherName = GetPlayerName(tempid)
    local admin_id = ARMA.getUserId(admin)
    local adminName = GetPlayerName(admin)
    if ARMA.hasPermission(admin_id, 'admin.kick') then
        ARMA.prompt(source,"Reason:","",function(source,Reason) 
            if Reason == "" then return end
            tARMA.sendWebhook('kick', 'ARMA Kick Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..playerOtherName.."**\n> Player TempID: **"..target_id.."**\n> Player PermID: **"..target.."**\n> Kick Reason: **"..Reason.."**")
            ARMA.kick(target_id, "ARMA You have been kicked | Your ID is: "..target.." | Reason: " ..Reason.." | Kicked by "..GetPlayerName(admin) or "No reason specified")
            ARMAclient.notify(admin, {'~g~Kicked Player.'})
        end)
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Kick Someone')
    end
end)


RegisterServerEvent('ARMA:RemoveWarning')
AddEventHandler('ARMA:RemoveWarning', function(warningid)
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil then
        if ARMA.hasPermission(user_id, "admin.removewarn") then 
            exports['ghmattimysql']:execute("SELECT * FROM arma_warnings WHERE warning_id = @warning_id", {warning_id = tonumber(warningid)}, function(result) 
                if result ~= nil then
                    for k,v in pairs(result) do
                        if v.warning_id == tonumber(warningid) then
                            exports['ghmattimysql']:execute("DELETE FROM arma_warnings WHERE warning_id = @warning_id", {warning_id = v.warning_id})
                            exports['ghmattimysql']:execute("UPDATE arma_bans_offenses SET points = CASE WHEN ((points-@removepoints)>0) THEN (points-@removepoints) ELSE 0 END WHERE UserID = @UserID", {UserID = v.user_id, removepoints = (v.duration/24)}, function() end)
                            ARMAclient.notify(source, {'~g~Removed F10 Warning #'..warningid..' ('..(v.duration/24)..' points) from ID: '..v.user_id})
                            tARMA.sendWebhook('remove-warning', 'ARMA Remove Warning Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Warning ID: **"..warningid.."**")
                        end
                    end
                end
            end)
        else
            local player = ARMA.getUserSource(admin_id)
            local name = GetPlayerName(source)
            Wait(500)
                TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Remove Warning')
        end
    end
end)

RegisterServerEvent("ARMA:Unban")
AddEventHandler("ARMA:Unban",function()
    local admin_id = ARMA.getUserId(source)
    playerName = GetPlayerName(source)
    if ARMA.hasPermission(admin_id, 'admin.unban') then
        ARMA.prompt(source,"Perm ID:","",function(source,permid) 
            if permid == '' then return end
            permid = parseInt(permid)
            ARMAclient.notify(source,{'~g~Unbanned ID: ' .. permid})
            tARMA.sendWebhook('unban-player', 'ARMA Unban Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player PermID: **"..permid.."**")
            ARMA.setBanned(permid,false)
        end)
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Unban Someone')
    end
end)


RegisterServerEvent("ARMA:getNotes")
AddEventHandler("ARMA:getNotes",function(player)
    local source = source
    local admin_id = ARMA.getUserId(source)
    if ARMA.hasPermission(admin_id, 'admin.spectate') then
        exports['ghmattimysql']:execute("SELECT * FROM arma_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result ~= nil then
                TriggerClientEvent('ARMA:sendNotes', source, result[1].info)
            end
        end)
    end
end)

RegisterServerEvent("ARMA:updatePlayerNotes")
AddEventHandler("ARMA:updatePlayerNotes",function(player, notes)
    local source = source
    local admin_id = ARMA.getUserId(source)
    if ARMA.hasPermission(admin_id, 'admin.spectate') then
        exports['ghmattimysql']:execute("SELECT * FROM arma_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result ~= nil then
                exports['ghmattimysql']:execute("UPDATE arma_user_notes SET info = @info WHERE user_id = @user_id", {user_id = player, info = json.encode(notes)})
                ARMAclient.notify(source, {'~g~Notes updated.'})
            end
        end)
    end
end)

RegisterServerEvent('ARMA:SlapPlayer')
AddEventHandler('ARMA:SlapPlayer', function(admin, target)
    local admin_id = ARMA.getUserId(admin)
    local player_id = ARMA.getUserId(target)
    if ARMA.hasPermission(admin_id, "admin.slap") then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        tARMA.sendWebhook('slap', 'ARMA Slap Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..admin.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..GetPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..player_id.."**")
        TriggerClientEvent('ARMA:SlapPlayer', target)
        ARMAclient.notify(admin, {'~g~Slapped Player.'})
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Slap Someone')
    end
end)

RegisterServerEvent('ARMA:RevivePlayer')
AddEventHandler('ARMA:RevivePlayer', function(admin, targetid, reviveall)
    local admin_id = ARMA.getUserId(admin)
    local player_id = targetid
    local target = ARMA.getUserSource(player_id)
    if target ~= nil then
        if ARMA.hasPermission(admin_id, "admin.revive") then
            ARMAclient.RevivePlayer(target, {})
            if not reviveall then
                local playerName = GetPlayerName(source)
                local playerOtherName = GetPlayerName(target)
                tARMA.sendWebhook('revive', 'ARMA Revive Logs', "> Admin Name: **"..GetPlayerName(admin).."**\n> Admin TempID: **"..admin.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..GetPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..player_id.."**")
                ARMAclient.notify(admin, {'~g~Revived Player.'})
                return
            end
            ARMAclient.notify(admin, {'~g~Revived all Nearby.'})
        else
            local player = ARMA.getUserSource(admin_id)
            local name = GetPlayerName(source)
            Wait(500)
            TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Revive Someone')
        end
    end
end)

frozenplayers = {}

RegisterServerEvent('ARMA:FreezeSV')
AddEventHandler('ARMA:FreezeSV', function(admin, newtarget, isFrozen)
    local admin_id = ARMA.getUserId(admin)
    local player_id = ARMA.getUserId(newtarget)
    if ARMA.hasPermission(admin_id, 'admin.freeze') then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        if isFrozen then
            tARMA.sendWebhook('freeze', 'ARMA Freeze Logs', "> Admin Name: **"..GetPlayerName(admin).."**\n> Admin TempID: **"..admin.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..GetPlayerName(newtarget).."**\n> Player TempID: **"..newtarget.."**\n> Player PermID: **"..player_id.."**\n> Type: **Frozen**")
            ARMAclient.notify(admin, {'~g~Froze Player.'})
            frozenplayers[user_id] = true
            ARMAclient.notify(newtarget, {'~g~You have been frozen.'})
        else
            tARMA.sendWebhook('freeze', 'ARMA Freeze Logs', "> Admin Name: **"..GetPlayerName(admin).."**\n> Admin TempID: **"..admin.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..GetPlayerName(newtarget).."**\n> Player TempID: **"..newtarget.."**\n> Player PermID: **"..player_id.."**\n> Type: **Unfrozen**")
            ARMAclient.notify(admin, {'~g~Unfrozen Player.'})
            ARMAclient.notify(newtarget, {'~g~You have been unfrozen.'})
            frozenplayers[user_id] = nil
        end
        TriggerClientEvent('ARMA:Freeze', newtarget, isFrozen)
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Freeze Someone')
    end
end)

RegisterServerEvent('ARMA:TeleportToPlayer')
AddEventHandler('ARMA:TeleportToPlayer', function(source, newtarget)
    local coords = GetEntityCoords(GetPlayerPed(newtarget))
    local user_id = ARMA.getUserId(source)
    local player_id = ARMA.getUserId(newtarget)
    if ARMA.hasPermission(user_id, 'admin.tp2player') then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        local adminbucket = GetPlayerRoutingBucket(source)
        local playerbucket = GetPlayerRoutingBucket(newtarget)
        if adminbucket ~= playerbucket then
            SetPlayerRoutingBucket(source, playerbucket)
            TriggerClientEvent('ARMA:setBucket', source, playerbucket)
            ARMAclient.notify(source, {'~g~Player was in another bucket, you have been set into their bucket.'})
        end
        ARMAclient.teleport(source, coords)
        ARMAclient.notify(newtarget, {'~g~An admin has teleported to you.'})
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to Teleport to Someone')
    end
end)

RegisterServerEvent('ARMA:Teleport2Legion')
AddEventHandler('ARMA:Teleport2Legion', function(newtarget)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.tp2player') then
        ARMAclient.teleport(newtarget, vector3(178.5132598877, -1007.5575561523, 29.329647064209))
        ARMAclient.notify(newtarget, {'~g~You have been teleported to Legion by an admin.'})
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to Teleport someone to Legion')
    end
end)

RegisterNetEvent('ARMA:BringPlayer')
AddEventHandler('ARMA:BringPlayer', function(id)
    local source = source 
    local SelectedPlrSource = ARMA.getUserSource(id) 
    local user_id = ARMA.getUserId(source)
    local source = source 
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.summon') then
        if id then  
            local ped = GetPlayerPed(source)
            local pedCoords = GetEntityCoords(ped)
            ARMAclient.teleport(id, pedCoords)
            local adminbucket = GetPlayerRoutingBucket(source)
            local playerbucket = GetPlayerRoutingBucket(id)
            if adminbucket ~= playerbucket then
                SetPlayerRoutingBucket(id, adminbucket)
                TriggerClientEvent('ARMA:setBucket', id, adminbucket)
                ARMAclient.notify(source, {'~g~Player was in another bucket, they have been set into your bucket.'})
            end
        else 
            ARMAclient.notify(source,{"~r~This player may have left the game."})
        end
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to Teleport Someone to Them')
    end
end)

RegisterNetEvent('ARMA:GetCoords')
AddEventHandler('ARMA:GetCoords', function()
    local source = source 
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.tickets") then
        ARMAclient.getPosition(source,{},function(coords)
            local x,y,z = table.unpack(coords)
            ARMA.prompt(source,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) 
            end)
        end)
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to Get Coords')
    end
end)

RegisterServerEvent('ARMA:Tp2Coords')
AddEventHandler('ARMA:Tp2Coords', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.tp2coords") then
        ARMA.prompt(source,"Coords x,y,z:","",function(player,fcoords) 
            local coords = {}
            for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
            table.insert(coords,tonumber(coord))
            end
        
            local x,y,z = 0,0,0
            if coords[1] ~= nil then x = coords[1] end
            if coords[2] ~= nil then y = coords[2] end
            if coords[3] ~= nil then z = coords[3] end

            if x and y and z == 0 then
                ARMAclient.notify(source, {"~r~We couldn't find those coords, try again!"})
            else
                ARMAclient.teleport(player,{x,y,z})
            end 
        end)
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to Teleport to Coords')
    end
end)

RegisterServerEvent("ARMA:Teleport2AdminIsland")
AddEventHandler("ARMA:Teleport2AdminIsland",function(id)
    local admin = source
    local admin_id = ARMA.getUserId(admin)
    local admin_name = GetPlayerName(admin)
    local player_id = ARMA.getUserId(id)
    local player_name = GetPlayerName(id)
    if ARMA.hasPermission(admin_id, 'admin.tp2player') then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(id)
        tARMA.sendWebhook('tp-to-admin-zone', 'ARMA Teleport Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..player_name.."**\n> Player TempID: **"..id.."**\n> Player PermID: **"..player_id.."**")
        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped2, 3490.0769042969,2585.4392089844,14.149716377258)
        ARMAclient.notify(ARMA.getUserSource(player_id),{'~g~You are now in an admin situation, do not leave the game.'})
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Teleport Someone to Admin Island')
    end
end)

RegisterServerEvent("ARMA:TeleportBackFromAdminZone")
AddEventHandler("ARMA:TeleportBackFromAdminZone",function(id, savedCoordsBeforeAdminZone)
    local admin = source
    local admin_id = ARMA.getUserId(admin)
    if ARMA.hasPermission(admin_id, 'admin.tp2player') then
        local ped = GetPlayerPed(id)
        SetEntityCoords(ped, savedCoordsBeforeAdminZone)
        tARMA.sendWebhook('tp-back-from-admin-zone', 'ARMA Teleport Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..GetPlayerName(id).."**\n> Player TempID: **"..id.."**\n> Player PermID: **"..ARMA.getUserId(id).."**")
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Teleport Someone Back from Admin Zone')
    end
end)

RegisterNetEvent('ARMA:AddCar')
AddEventHandler('ARMA:AddCar', function()
    local source = source
    local admin_id = ARMA.getUserId(source)
    local admin_name = GetPlayerName(source)
    if ARMA.hasPermission(admin_id, 'admin.addcar') then
        ARMA.prompt(source,"Add to Perm ID:","",function(source, permid)
            if permid == "" then return end
            local playerName = GetPlayerName(ARMA.getUserSource(permid))
            ARMA.prompt(source,"Car Spawncode:","",function(source, car) 
                if car == "" then return end
                local car = car
                ARMA.prompt(source,"Locked:","",function(source, locked) 
                if locked == '0' or locked == '1' then
                    if permid and car ~= "" then  
                        exports['ghmattimysql']:execute("INSERT IGNORE INTO arma_user_vehicles(user_id,vehicle,vehicle_plate,locked) VALUES(@user_id,@vehicle,@registration,@locked)", {user_id = permid, vehicle = car, registration = 'ARMA', locked = locked})
                        ARMAclient.notify(source,{'~g~Successfully added Player\'s car'})
                        tARMA.sendWebhook('add-car', 'ARMA Add Car To Player Logs', "> Admin Name: **"..admin_name.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..playerName.."**\n> Player TempID: **"..ARMA.getUserSource(permid).."**\n> Player PermID: **"..permid.."**\n> Spawncode: **"..car.."**")
                    else 
                        ARMAclient.notify(source,{'~r~Failed to add Player\'s car'})
                    end
                else
                    ARMAclient.notify(source,{'~g~Locked must be either 1 or 0'}) 
                end
                end)
            end)
        end)
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to Add Car')
    end
end)

RegisterNetEvent('ARMA:CleanAll')
AddEventHandler('ARMA:CleanAll', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.tickets') then
        for i,v in pairs(GetAllVehicles()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllPeds()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllObjects()) do
            DeleteEntity(v)
        end
        TriggerClientEvent('chatMessage', -1, 'ARMA^7 │ ', {255, 255, 255}, "Cleanup Completed by ^3" .. GetPlayerName(source) .. "^0!", "alert")
    end
end)

RegisterNetEvent('ARMA:noClip')
AddEventHandler('ARMA:noClip', function()
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.noclip') then 
        ARMAclient.toggleNoclip(source,{})
    end
end)


RegisterServerEvent('ARMA:CopyToClipBoard')
AddEventHandler('ARMA:CopyToClipBoard', function(id)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'group.remove') then
        ARMA.prompt(source,"Input text to copy to clipboard","",function(source,data) 
            ARMAclient.CopyToClipBoard(ARMA.getUserSource(id), {data})
        end)
    end
end)

RegisterServerEvent("ARMA:GetPlayerData")
AddEventHandler("ARMA:GetPlayerData",function()
    local source = source
    user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.tickets') then
        players = GetPlayers()
        players_table = {}
        useridz = {}
        for i, p in pairs(players) do
            if ARMA.getUserId(p) ~= nil then
                name = GetPlayerName(p)
                user_idz = ARMA.getUserId(p)
                data = ARMA.getUserDataTable(user_idz)
                playtime = data.PlayerTime or 0
                PlayerTimeInHours = playtime/60
                if PlayerTimeInHours < 1 then
                    PlayerTimeInHours = 0
                end
                players_table[user_idz] = {name, p, user_idz, math.ceil(PlayerTimeInHours)}
                table.insert(useridz, user_idz)
            else
                DropPlayer(p, "ARMA - The server was unable to cache your ID, please rejoin.")
            end
        end
        TriggerClientEvent("ARMA:getPlayersInfo", source, players_table, bans)
    end
end)


RegisterCommand("staffon", function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.tickets") then
        ARMAclient.staffMode(source, {true})
    end
end)

RegisterCommand("staffoff", function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.tickets") then
        ARMAclient.staffMode(source, {false})
    end
end)

RegisterServerEvent('ARMA:getAdminLevel')
AddEventHandler('ARMA:getAdminLevel', function()
    local source = source
    local user_id = ARMA.getUserId(source)

    if ARMA.hasGroup(user_id, 'Developer') then
        ARMAclient.setDev(source, {})
    end
        
    local adminlevel = 0
    if ARMA.hasGroup(user_id,"Developer") then
        adminlevel = 12
    elseif ARMA.hasGroup(user_id,"Founder") then
        adminlevel = 11
    elseif ARMA.hasGroup(user_id,"Staff Manager") then    
        adminlevel = 9
    elseif ARMA.hasGroup(user_id,"Community Manager") then
        adminlevel = 8
    elseif ARMA.hasGroup(user_id,"Head Admin") then
        adminlevel = 7
    elseif ARMA.hasGroup(user_id,"Senior Admin") then
        adminlevel = 6
    elseif ARMA.hasGroup(user_id,"Admin") then
        adminlevel = 5
    elseif ARMA.hasGroup(user_id,"Senior Mod") then
        adminlevel = 4
    elseif ARMA.hasGroup(user_id,"Moderator") then
        adminlevel = 3
    elseif ARMA.hasGroup(user_id,"Support Team") then
        adminlevel = 2
    elseif ARMA.hasGroup(user_id,"Trial Staff") then
        adminlevel = 1
    end
    ARMAclient.setStaffLevel(source, {adminlevel})
end)


RegisterNetEvent('ARMA:zapPlayer')
AddEventHandler('ARMA:zapPlayer', function(A)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'Founder') then
        TriggerClientEvent("ARMA:useTheForceTarget", A)
        for k,v in pairs(ARMA.getUsers()) do
            TriggerClientEvent("ARMA:useTheForceSync", v, GetEntityCoords(GetPlayerPed(A)), GetEntityCoords(GetPlayerPed(v)))
        end
    end
end)

RegisterNetEvent('ARMA:theForceSync')
AddEventHandler('ARMA:theForceSync', function(A, q, r, s)
    local source = source
    if ARMA.getUserId(source) == 1 then
        TriggerClientEvent("ARMA:useTheForceSync", A, q, r, s)
        TriggerClientEvent("ARMA:useTheForceTarget", A)
    end
end)

RegisterCommand("cleararea", function(source, args) -- these events are gonna be used for vehicle cleanup in future also
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.noclip') then
        TriggerClientEvent('ARMA:clearVehicles', -1)
        TriggerClientEvent('ARMA:clearBrokenVehicles', -1)
    end 
end)

Citizen.CreateThread(function()
	while true do
        local deleteTime = 600000
        TriggerClientEvent('chatMessage', -1, 'ARMA^7 │ ', {255, 255, 255}, "^3Vehicle cleanup in " .. math.floor((deleteTime/1000/60)) .. " minutes.", "alert")
        Citizen.Wait(deleteTime)
        TriggerClientEvent('chatMessage', -1, 'ARMA^7 │ ', {255, 255, 255}, "^3Vehicle cleanup completed.", "alert")
        TriggerClientEvent('ARMA:clearVehicles', -1)
        TriggerClientEvent('ARMA:clearBrokenVehicles', -1)
	end
end)

RegisterNetEvent("ARMA:devOutfitSave")
AddEventHandler("ARMA:devOutfitSave", function(outfitName)
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMA.getUData(user_id, "ARMA:dev:outfits", function(data)
        local sets = json.decode(data)
        if sets == nil then sets = {} end
        ARMAclient.getCustomization(source,{},function(custom)
            sets[outfitName] = custom
            ARMA.setUData(user_id,"ARMA:dev:outfits",json.encode(sets))
            ARMAclient.notify(source,{"~g~Saved outfit."})
            TriggerClientEvent("ARMA:getDevOutfits", source, sets)
        end)
    end)
end)

RegisterNetEvent("ARMA:devOutfitDelete")
AddEventHandler("ARMA:devOutfitDelete", function(outfitName)
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMA.getUData(user_id, "ARMA:dev:outfits", function(data)
        local sets = json.decode(data)
        if sets == nil then sets = {} end
        sets[outfitName] = nil
        ARMA.setUData(user_id,"ARMA:dev:outfits",json.encode(sets))
        ARMAclient.notify(source,{"~r~Removed outfit."})
        TriggerClientEvent("ARMA:getDevOutfits", source, sets)
    end)
end)

RegisterNetEvent("ARMA:devOutfitLoad")
AddEventHandler("ARMA:devOutfitLoad", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMA.getUData(user_id, "ARMA:dev:outfits", function(data)
        local sets = json.decode(data)
        if sets == nil then sets = {} end
        TriggerClientEvent("ARMA:getDevOutfits", source, sets)
    end)
end)

RegisterCommand("getbucket", function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMAclient.notify(source, {'~g~You are currently in Bucket: '..GetPlayerRoutingBucket(source)})
end)

RegisterCommand("setbucket", function(source, args)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.managecommunitypot') then
        SetPlayerRoutingBucket(source, tonumber(args[1]))
        TriggerClientEvent('ARMA:setBucket', source, tonumber(args[1]))
        ARMAclient.notify(source, {'~g~You are now in Bucket: '..GetPlayerRoutingBucket(source)})
    end 
end)
