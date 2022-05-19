
admincfg = {}

admincfg.perm = "admin.tickets"
admincfg.IgnoreButtonPerms = false
admincfg.admins_cant_ban_admins = false


--[[ {enabled -- true or false}, permission required ]]
admincfg.buttonsEnabled = {

    --[[ admin Menu ]]
    ["adminMenu"] = {true, "admin.tickets"},
    ["warn"] = {true, "admin.warn"},      
    ["showwarn"] = {true, "admin.showwarn"},
    ["ban"] = {true, "admin.ban"},
    ["kick"] = {true, "admin.kick"},
    ["nof10kick"] = {true, "admin.nof10kick"},
    ["revive"] = {true, "admin.revive"},
    ["TP2"] = {true, "admin.tp2player"},
    ["TP2ME"] = {true, "admin.summon"},
    ["TPLoc"] = {true, "admin.teleport"},
    ["FREEZE"] = {true, "admin.freeze"},
    ["spectate"] = {true, "admin.spectate"}, 
    ["SS"] = {true, "admin.screenshot"},
    ["slap"] = {true, "admin.slap"},
    ["giveMoney"] = {true, "admin.givemoney"},
    ["addcar"] = {true, "admin.addcar"},

    --[[ Functions ]]
    ["tp2waypoint"] = {true, "admin.tp2waypoint"},
    ["tp2coords"] = {true, "admin.tp2coords"},
    ["removewarn"] = {true, "admin.removewarn"},
    ["spawnBmx"] = {true, "admin.spawnBmx"},
    ["spawnGun"] = {true, "admin.spawnGun"},

    --[[ Add Groups ]]
    ["getgroups"] = {true, "group.add"},
    ["staffGroups"] = {true, "admin.staffAddGroups"},
    ["mpdGroups"] = {true, "admin.mpdAddGroups"},
    ["povGroups"] = {true, "admin.povAddGroups"},
    ["licenseGroups"] = {true, "admin.licenseAddGroups"},
    ["donoGroups"] = {true, "admin.donoAddGroups"},
    ["nhsGroups"] = {true, "admin.nhsAddGroups"},

    --[[ Vehicle Functions ]]
    ["vehFunctions"] = {true, "admin.vehmenu"},
    ["noClip"] = {true, "admin.noclip"},

    -- [[ Developer Functions ]]
    ["devMenu"] = {true, "dev.menu"},
}

RegisterServerEvent('ARMA:OpenSettings')
AddEventHandler('ARMA:OpenSettings', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil and ARMA.hasPermission(user_id, "admin.menu") then
        TriggerClientEvent("ARMA:OpenSettingsMenu", source, true)
    else
        TriggerClientEvent("ARMA:OpenSettingsMenu", source, false)
    end
end)

RegisterServerEvent('ARMA:OpenSettings')
AddEventHandler('ARMA:OpenSettings', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil and ARMA.hasPermission(user_id, "admin.menu") then
        TriggerClientEvent("ARMA:OpenSettingsMenu", source, true)
    else
        TriggerClientEvent("ARMA:OpenSettingsMenu", source, false)
    end
end)

RegisterServerEvent("ARMA:GetPlayerData")
AddEventHandler("ARMA:GetPlayerData",function()
    local source = source
    user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, admincfg.perm) then
        players = GetPlayers()
        players_table = {}
        menu_btns_table = {}
        useridz = {}
        for i, p in pairs(players) do
            if ARMA.getUserId(p) ~= nil then
            name = GetPlayerName(p)
            user_idz = ARMA.getUserId(p)
            players_table[user_idz] = {name, p, user_idz}
            table.insert (useridz, user_idz)
            else
                DropPlayer(p, "[ARMA] You Were Kicked")
            end
         end
        if admincfg.IgnoreButtonPerms == false then
            for i, b in pairs(admincfg.buttonsEnabled) do
                if b[1] and ARMA.hasPermission(user_id, b[2]) then
                    menu_btns_table[i] = true
                else
                    menu_btns_table[i] = false
                end
            end
        else
            for j, t in pairs(admincfg.buttonsEnabled) do
                menu_btns_table[j] = true
            end
        end
        TriggerClientEvent("ARMA:SendPlayersInfo", source, players_table, menu_btns_table)
    end
end)

RegisterServerEvent("ARMA:getGroups")
AddEventHandler("ARMA:getGroups",function(temp, perm)
    local user_groups = ARMA.getUserGroups(perm)
    TriggerClientEvent("ARMA:gotgroups", source, user_groups)
end)

RegisterServerEvent("ARMA:CheckPOV")
AddEventHandler("ARMA:CheckPOV",function(userperm)
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.menu") then
        if ARMA.hasGroup(userperm, 'pov') then
            TriggerClientEvent('ARMA:ReturnPOV', source, true)
        elseif not ARMA.hasGroup(userperm, 'pov') then
            TriggerClientEvent('ARMA:ReturnPOV', source, false)
        end
    else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
    end
end)

local onesync = GetConvar('onesync', nil)
RegisterNetEvent('ARMAAdmin:SpectatePlr')
AddEventHandler('ARMAAdmin:SpectatePlr', function(id)
    local source = source 
    local SelectedPlrSource = ARMA.getUserSource(id) 
    local userid = ARMA.getUserId(source)
    if ARMA.hasPermission(userid, 'admin.spectate') then
        if SelectedPlrSource then  
            if onesync ~= "off" then 
                local ped = GetPlayerPed(SelectedPlrSource)
                local pedCoords = GetEntityCoords(ped)
                print(pedCoords)
                TriggerClientEvent('ARMAAdmin:Spectate', source, SelectedPlrSource, pedCoords)
            else 
                TriggerClientEvent('ARMAAdmin:Spectate', source, SelectedPlrSource)  
            end
        else 
            ARMAclient.notify(source,{"~r~This player may have left the game."})
        end
    end
end)

RegisterServerEvent("ARMA:addGroup")
AddEventHandler("ARMA:addGroup",function(perm, selgroup)
    local admin_temp = source
    local admin_perm = ARMA.getUserId(admin_temp)
    local user_id = ARMA.getUserId(source)
    local permsource = ARMA.getUserSource(perm)
    local playerName = GetPlayerName(source)
    local povName = GetPlayerName(permsource)
    if ARMA.hasPermission(user_id, "group.add") then
        if selgroup == "founder" and not ARMA.hasPermission(admin_perm, "group.add.founder") then
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
        elseif selgroup == "moderator" and not ARMA.hasPermission(admin_perm, "group.add.moderator") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "trialstaff" and not ARMA.hasPermission(admin_perm, "group.add.trial") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "vip" and not ARMA.hasPermission(admin_perm, "group.add.vip") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "pov" and not ARMA.hasGroup(perm, "pov") then
            webhook = "https://discord.com/api/webhooks/972459362603905064/WYpnUCMoTsB1n1QLwbkcLP4Hj5WCrbjlCAN5SFj2x4F7sv8MnZHGq9gqzKg4JE0obfm5"
            PerformHttpRequest(webhook, function(err, text, headers) 
            end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
                {
                    ["color"] = "15158332",
                    ["title"] = playerName.." put "..povName.." onto the POV List.",
                    ["description"] = "Admin Name: **"..playerName.."** \nAdmin ID: **"..admin_perm.."** \nPlayer ID: **"..perm.."** \nPlayer Name: **"..povName.."**",
                    ["footer"] = {
                        ["text"] = "Time - "..os.date("%x %X %p"),
                    }
            }
            }}), { ["Content-Type"] = "application/json" })
            ARMA.addUserGroup(perm, "pov")
            ARMAclient.notify(source,{'~g~Added group to POV List'})
            ARMAclient.notify(permsource,{'~r~You were added to POV List ~w~[ID: ' .. admin_perm .. ' ]'})
        else
            ARMA.addUserGroup(perm, selgroup)
            ARMAclient.notify(source,{'~g~Added group to user'})
            ARMAclient.notify(permsource,{'~g~You have been given: ~w~' .. selgroup .. ' ~g~group ~w~[ID: ' .. admin_perm .. ' ]'})
        end
    else
        print("Stop trying to add a group u fucking cheater")
    end
end)

RegisterNetEvent('ARMA:HasFounder')
AddEventHandler('ARMA:HasFounder', function()
    local source = source 
    user_id = ARMA.getUserId(source)

    if ARMA.hasGroup(user_id, 'founder') then 
        TriggerClientEvent('ARMA:ClothingPerms', source, true)
    else
        TriggerClientEvent('ARMA:ClothingPerms', source, false)
    end
end)

RegisterServerEvent("ARMA:removeGroup")
AddEventHandler("ARMA:removeGroup",function(perm, selgroup)
    local user_id = ARMA.getUserId(source)
    local admin_temp = source
    local admin_perm = ARMA.getUserId(admin_temp)
    local permsource = ARMA.getUserSource(perm)
    local playerName = GetPlayerName(source)
    local povName = GetPlayerName(permsource)
    if ARMA.hasPermission(user_id, "group.remove") then
        if selgroup == "founder" and not ARMA.hasPermission(user_id, "group.remove.founder") then
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
        elseif selgroup == "moderator" and not ARMA.hasPermission(user_id, "group.remove.moderator") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "trialstaff" and not ARMA.hasPermission(user_id, "group.remove.trial") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "vipgarage" and not ARMA.hasPermission(user_id, "group.remove.vipgarage") then
            ARMAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "pov" and ARMA.hasGroup(perm, "pov") then
            webhook = "https://discord.com/api/webhooks/972459449111412737/V6R-FlM_hb7Xxrx59WeZSwDkoGuJL82_KaawOKet_OcjJ3VG5Cqm83pq7ZzFWLzFYRPc"
            PerformHttpRequest(webhook, function(err, text, headers) 
            end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
                {
                    ["color"] = "15158332",
                    ["title"] = playerName.." removed "..povName.." from the POV List.",
                    ["description"] = "Admin Name: **"..playerName.."** \nAdmin ID: **"..user_id.."** \nPlayer ID: **"..perm.."** \nPlayer Name: **"..povName.."**",
                    ["footer"] = {
                        ["text"] = "Time - "..os.date("%x %X %p"),
                    }
            }
            }}), { ["Content-Type"] = "application/json" })
            ARMA.removeUserGroup(perm, "pov")
            ARMAclient.notify(source,{'~r~Removed POV List of user'})
            ARMAclient.notify(permsource,{'~r~Someone removed you of POV List'})
        else
            ARMA.removeUserGroup(perm, selgroup)
            ARMAclient.notify(source,{'~r~Removed group.'})
            ARMAclient.notify(permsource,{'~r~Your group has been removed: ~w~' .. selgroup .. ' ~r~group ~w~[ID: ' .. admin_perm .. ' ]'})
        end
    else 
        print("Stop trying to add a group u fucking cheater")
    end
end)

RegisterServerEvent('ARMA:BanPlayer')
AddEventHandler('ARMA:BanPlayer', function(admin, target, reason, duration)
    local target = target
    local target_id = ARMA.getUserSource(target)
    local admin_id = ARMA.getUserId(admin)
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.ban") then
        if tonumber(duration) then 
            local playerName = GetPlayerName(source)
            local playerOtherName = GetPlayerName(target)
            if tonumber(duration) == -1 then
                ARMA.ban(source,target,"perm",reason or "No reason given")
                saveBanLog(target_id, GetPlayerName(admin), reason, duration)
            else
                ARMA.ban(source,target,duration,reason or "No reason given")
                saveBanLog(target_id, GetPlayerName(admin), reason, duration)
                print(admin, target_id)
                TriggerEvent('ARMA:BanPlayerLog', target, GetPlayerName(admin), reason, duration)
                webhook = "https://discord.com/api/webhooks/972459521354129508/JcxZS3i86KRtw3XWKzp4Lrgg3D_MzKK5pzBmzGH9Hw-N6XEQyin-c--NIR_-KqUc-yHM"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "Banned ID: "..target .." out of the server. Reason: "..reason,
                        ["description"] = "Admin Name: **"..GetPlayerName(admin).."** \nAdmin ID: **"..ARMA.getUserId(admin).."** \nPlayer ID: **"..target.."** \nDescription: **Banned ID: "..target.." out of the server. Reason: "..reason.."**",
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                }
                }}), { ["Content-Type"] = "application/json" })
                TriggerClientEvent('ARMA:Notify', admin, 'Banned Player')
            end
        end
    end
end)

RegisterServerEvent('ARMA:KickPlayer')
AddEventHandler('ARMA:KickPlayer', function(admin, target, reason, tempid)
    local target_id = ARMA.getUserSource(target)
    local target_permid = target
    local playerName = GetPlayerName(source)
    local playerOtherName = GetPlayerName(tempid)
    local perm = admincfg.buttonsEnabled["kick"][2]
    local admin_id = ARMA.getUserId(admin)
    if ARMA.hasPermission(admin_id, perm) then
        webhook = "https://discord.com/api/webhooks/972459583564046356/1UzhnvoG90OcTkrB7uxuWn4o-z5D1z_t2Y31k2HPvnEA-Pmq0rst5vEro2PHDrqP6UIN"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Kicked "..playerOtherName.." out of the server. Reason: "..reason,
                ["description"] = "Admin Name: **"..playerName.."** \nAdmin ID: **"..admin_id.."** \nPlayer ID: **"..target_permid.."** \nReason:" ..reason,
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        ARMA.kick(target_id, "[ARMA] You have been kicked | Your ID is: "..target.." | Reason: "..reason.." | Kicked by "..GetPlayerName(admin) or "No reason specified")
        TriggerEvent("ARMA:saveKickLog",target,GetPlayerName(admin),reason)
        TriggerClientEvent('ARMA:Notify', admin, 'Kicked Player')
    end
end)

RegisterServerEvent('ARMA:KickPlayerNoF10')
AddEventHandler('ARMA:KickPlayerNoF10', function(admin, target, reason)
    local target_id = ARMA.getUserSource(target)
    local target_permid = ARMA.getUserId(target)
    local perm = admincfg.buttonsEnabled["kick"][2]
    local admin_id = ARMA.getUserId(admin)
    if ARMA.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        webhook = "https://discord.com/api/webhooks/972459583564046356/1UzhnvoG90OcTkrB7uxuWn4o-z5D1z_t2Y31k2HPvnEA-Pmq0rst5vEro2PHDrqP6UIN"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "No F10 Kicked "..playerOtherName.." out of the server. Reason: "..reason,
                ["description"] = "Admin Name: **"..playerName.."** \nAdmin ID: **"..admin_id.."** \nPlayer ID: **"..target_permid.."** \nDescription: **No F10 Kicked "..playerOtherName.." out of the server. Reason: "..reason.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        ARMA.kick(target_id, "[ARMA] You have been kicked | Your ID is: "..target.." | Reason: "..reason.." | Kicked by "..GetPlayerName(admin) or "No reason specified")
        TriggerClientEvent('ARMA:Notify', admin, 'Kicked Player')
    end
end)

RegisterServerEvent('ARMA:RemoveWarning')
AddEventHandler('ARMA:RemoveWarning', function(admin, warningid)
    local admin_id = ARMA.getUserId(admin)
    local perm = admincfg.buttonsEnabled["removewarn"][2]
    if ARMA.hasPermission(admin_id, perm) then
        exports['ghmattimysql']:execute("DELETE FROM arma_warnings WHERE warning_id = @uid", {uid = warningid})
        TriggerClientEvent('ARMA:Notify', admin, 'Removed #'..warningid..' Warning ID')
    end
end)

RegisterServerEvent("ARMA:Unban")
AddEventHandler("ARMA:Unban",function(perm1)
    local admin_id = ARMA.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["ban"][2]
    playerName = GetPlayerName(source)
    if ARMA.hasPermission(admin_id, perm2) then

        ExecuteCommand('unban ' .. perm1)
        ARMAclient.notify(source,{'~g~Unbanned ID: ' .. perm1})
        webhook = "https://discord.com/api/webhooks/972459719228801094/eE-TzQnM5ZNvxF79NiAHZACVt8JE4fXhXoIDhGQ9SedwQIuraTOz45pPYk5vBmniswtB"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Unbanned ID: "..perm1,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..admin_id.."** \nDescription: **Unbanned ID: "..perm1.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
    else
        print("Cheater tried fucking unbanning, the nerd")
    end
end)

RegisterServerEvent('ARMA:SlapPlayer')
AddEventHandler('ARMA:SlapPlayer', function(admin, target)
    local admin_id = ARMA.getUserId(admin)
    if ARMA.hasPermission(admin_id, "admin.slap") then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        webhook = "https://discord.com/api/webhooks/972459782298562560/QEOx3l8eOC0R0gm_migPDX0awEJpExBudkHsmVcG8JQ41BLWqWvIVntyE-zQfp9rnDR6"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Slapped "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Slapped "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        TriggerClientEvent('ARMA:SlapPlayer', target)
        TriggerClientEvent('ARMA:Notify', admin, 'Slapped Player')
    end
end)

RegisterServerEvent('ARMA:RevivePlayer')
AddEventHandler('ARMA:RevivePlayer', function(admin, target)
    local admin_id = ARMA.getUserId(admin)
    if ARMA.hasPermission(admin_id, "admin.revive") then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        webhook = "https://discord.com/api/webhooks/972459842348384266/jSpDOLulfADM_FH5y-JAsjrV29FMI_k5hJGZUD8XJhtRToSkJEhkqdngVp6J4PCq-hoV"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Revived "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Revived "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        ARMAclient.notify(target,{'~g~' .. GetPlayerName(admin) .. ' revived you ~w~[ID: ' .. user_id .. ']'})
        TriggerClientEvent('ARMA:FixClient',target)
        TriggerClientEvent('ARMA:Notify', admin, 'Revived Player')
    end
end)

RegisterServerEvent('ARMA:FreezeSV')
AddEventHandler('ARMA:FreezeSV', function(admin, newtarget, isFrozen)
    local admin_id = ARMA.getUserId(admin)
    local perm = admincfg.buttonsEnabled["FREEZE"][2]
    if ARMA.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        if isFrozen then
            webhook = "https://discord.com/api/webhooks/972459950490153010/jZ9oxG1k09vuLZgrkMfkvcZDz5qSUTCT83ajvWTjt0x0_0MuiWqOvLTU5Tur9E96Obm5"
            PerformHttpRequest(webhook, function(err, text, headers) 
            end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
                {
                    ["color"] = "15158332",
                    ["title"] = "Froze "..playerOtherName,
                    ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Froze "..playerOtherName.."**",
                    ["footer"] = {
                        ["text"] = "Time - "..os.date("%x %X %p"),
                    }
            }
            }}), { ["Content-Type"] = "application/json" })
        else
            webhook = "https://discord.com/api/webhooks/972459950490153010/jZ9oxG1k09vuLZgrkMfkvcZDz5qSUTCT83ajvWTjt0x0_0MuiWqOvLTU5Tur9E96Obm5"
            PerformHttpRequest(webhook, function(err, text, headers) 
            end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
                {
                    ["color"] = "15158332",
                    ["title"] = "Unfroze "..playerOtherName,
                    ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Unfroze "..playerOtherName.."**",
                    ["footer"] = {
                        ["text"] = "Time - "..os.date("%x %X %p"),
                    }
            }
            }}), { ["Content-Type"] = "application/json" })
        end
        TriggerClientEvent('ARMA:Freeze', newtarget, isFrozen)
        TriggerClientEvent('ARMA:Notify', admin, 'Froze Player')
    end
end)

RegisterServerEvent('ARMA:TeleportToPlayer')
AddEventHandler('ARMA:TeleportToPlayer', function(source, newtarget)
    local coords = GetEntityCoords(GetPlayerPed(newtarget))
    local user_id = ARMA.getUserId(source)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if ARMA.hasPermission(user_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        webhook = "https://discord.com/api/webhooks/972460044199292948/0Bptqphabn93ZnlwvEjlmABlROR0fkMxMwM4Pm8WgiiblmAnjNgXMt8iNnk2tIFoAl2O"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Teleported to "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Teleported to "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        TriggerClientEvent('ARMA:Teleport', source, coords)
    end
end)

RegisterServerEvent('ARMA:TeleportToMe')
AddEventHandler('ARMA:TeleportToMe', function(source, newtarget)
    local user_id = ARMA.getUserId(source)
    local perm = admincfg.buttonsEnabled["TP2ME"][2]
    if ARMA.hasPermission(user_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        webhook = "https://discord.com/api/webhooks/972460165477572618/79b2T4aal8wXAckeByMSQ34LoeiocehSBq9t3AkLtB7ribxU7fZeeVddBt3hohnN6Bb5"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Brang "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Brang "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })
        TriggerClientEvent('ARMA:Teleport2Me2', newtarget, source)
    end
end)


RegisterNetEvent('ARMAAdmin:Bring')
AddEventHandler('ARMAAdmin:Bring', function(id)
    local source = source 
    local SelectedPlrSource = ARMA.getUserSource(id) 
    local userid = ARMA.getUserId(source)
    if ARMA.hasPermission(userid, 'admin.teleport') then
        if SelectedPlrSource then  
            if onesync ~= "off" then 
                local ped = GetPlayerPed(source)
                local otherPlr = GetPlayerPed(SelectedPlrSource)
                local pedCoords = GetEntityCoords(ped)
                local playerOtherName = GetPlayerName(SelectedPlrSource)
                SetEntityCoords(otherPlr, pedCoords)

                webhook = "https://discord.com/api/webhooks/972460236919164928/XPomsqyHRpDMHx3dZSeQmcz1KnjSEb7ZGCp_5zAAlUWUaBlEsZrL8bWg8u4qYO1qhVew"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "Brang "..playerOtherName,
                        ["description"] = "Admin Name: **"..GetPlayerName(source).."** \nPermID: **"..userid.."** \nDescription: **Brang "..playerOtherName.."**",
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                }
            }}), { ["Content-Type"] = "application/json" })
            else 
                TriggerClientEvent('ARMAAdmin:Bring', SelectedPlrSource, false, id)  
            end
        else 
            ARMAclient.notify(source,{"~r~This player may have left the game."})
        end
    end
end)

playersSpectating = {}
playersToSpectate = {}

RegisterServerEvent('ARMA:SpectateCheck')
AddEventHandler('ARMA:SpectateCheck', function(newtarget)
    local admin_id = source
    local user_id = ARMA.getUserId(source)
    local perm = admincfg.buttonsEnabled["spectate"][2]
    if ARMA.hasPermission(user_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        webhook = "https://discord.com/api/webhooks/972460295740092426/aS_D3qgtBVcAra7oSHkZqAArMTEn9ZqBB7r9SDyFvsmL_9lZ7Acxx1zfnQ4MuJF-0NTY"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Started spectating "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Started spectating "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })

        TriggerClientEvent('ARMA:SpectateClient', source, newtarget)
        
    end
end)

RegisterServerEvent('ARMA:Prompt')
AddEventHandler('ARMA:Prompt', function(shit)
    local admin_id = source
    local user_id = ARMA.getUserId(admin)
    ARMA.prompt(source, "Clothing:", shit, function(player, PermID)
    end)
end)

RegisterNetEvent('ARMADEV:GetCoords')
AddEventHandler('ARMADEV:GetCoords', function()
    local source = source 
    local userid = ARMA.getUserId(source)
    if ARMA.hasGroup(userid, "dev") then
        ARMAclient.getPosition(source,{},function(x,y,z)
            ARMA.prompt(source,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) end)
        end)
    end
end)

RegisterServerEvent('ARMA:Tp2Coords')
AddEventHandler('ARMA:Tp2Coords', function()
    local source = source
    local userid = ARMA.getUserId(source)
    if ARMA.hasGroup(userid, "dev") then
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
    end
end)

RegisterServerEvent('ARMA:GiveMoney2')
AddEventHandler('ARMA:GiveMoney2', function()
    local source = source
    local userid = ARMA.getUserId(source)
    if ARMA.hasGroup(userid, "dev") then
        if user_id ~= nil then
            ARMA.prompt(source,"Amount:","",function(source,amount) 
                amount = parseInt(amount)
                ARMA.giveMoney(user_id, amount)
                ARMAclient.notify(source,{"You have gave youself ~g~£" .. amount})
            end)
        end

    end
end)

RegisterServerEvent("ARMA:Teleport2AdminIsland")
AddEventHandler("ARMA:Teleport2AdminIsland",function(id)
    local admin = source
    local admin_id = ARMA.getUserId(admin)
    local admin_name = GetPlayerName(admin)
    local player_id = ARMA.getUserId(id)
    local player_name = GetPlayerName(id)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if ARMA.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(id)
        webhook = "https://discord.com/api/webhooks/972460369564008519/t4rA6hQvMQcmhOhT8t8SQhPfSz_c6rtX4fvnvQsMjWiDZTGUrfj-3gO-819oTBVTKi5h"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Teleported "..playerOtherName.." to admin island",
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Teleported "..playerOtherName.." to admin island**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })
        ARMAclient.getPosition(id, {}, function(x,y,z)
            local location = tostring(x)..','..tostring(y)..','..tostring(z)
            exports['ghmattimysql']:execute("INSERT INTO arma_tp_data (user_id, last_location) VALUES( @user_id, @location ) ON DUPLICATE KEY UPDATE `last_location` = @location", {user_id = id, location = location}, function() end)
        end)
        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped2, 3490.0769042969,2585.4392089844,14.149716377258)
    end
end)

RegisterServerEvent("ARMA:Teleport")
AddEventHandler("ARMA:Teleport",function(id, coords)
    local admin = source
    local admin_id = ARMA.getUserId(admin)

    local perm = admincfg.buttonsEnabled["TP2"][2]
    if ARMA.hasPermission(admin_id, perm) then

        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped2, coords)
    end
end)


RegisterServerEvent("ARMA:Telepor2")
AddEventHandler("ARMA:Telepor2",function(id)

    local ped2 = GetPlayerPed(id)
    SetEntityCoords(ped2, 3490.0769042969,2585.4392089844,14.149716377258)
   
end)

RegisterServerEvent("ARMA:returnplayer")
AddEventHandler("ARMA:returnplayer",function(id)
    local admin = source
    local admin_id = ARMA.getUserId(admin)
    local admin_name = GetPlayerName(admin)
    local player_id = ARMA.getUserId(id)
    local player_name = GetPlayerName(id)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if ARMA.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(id)
        webhook = "https://discord.com/api/webhooks/972460428317851648/GQlChr2DzuCuVUnq-Nb_IuY-AmxYVKpqqG3yASMt-_vEn_5qhZ6HJldYP-3mgxOrnNCy"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Returned "..playerOtherName.." to previous location",
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Returned "..playerOtherName.." to previous location**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })
        exports['ghmattimysql']:execute("SELECT last_location FROM arma_tp_data WHERE user_id = @user_id", {user_id = id}, function(result)
            local t = {}
    
            for i in result[1].last_location:gmatch("([^,%s]+)") do  
                t[#t + 1] = i
            end 
    
            local x = tonumber(t[1])
            local y = tonumber(t[2])
            local z = tonumber(t[3])
            local coords = vector3(x,y,z)
            TriggerClientEvent("ARMA:TPCoords", id, coords)
        end)
        exports['ghmattimysql']:execute("DELETE FROM arma_tp_data WHERE `user_id` = @user_id", {user_id = id}, function() end)        
    end
end)

RegisterNetEvent('ARMA:AddCar')
AddEventHandler('ARMA:AddCar', function(id, car)
    local source = source 
    local SelectedPlrSource = ARMA.getUserSource(id) 
    local userid = ARMA.getUserId(source)
    local perm = admincfg.buttonsEnabled["addcar"][2]
    if ARMA.hasPermission(userid, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(SelectedPlrSource)
        webhook = "https://discord.com/api/webhooks/972460494604607508/z1bbH0pbI7dGEy9oLG8vxf9R66Rzi6d5gDcoT2E3njkZ91mAupdOrNML_z6K1ACK9Qlj"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "ARMA Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Gave "..playerOtherName.." a vehicle: "..car,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..userid.."** \nDescription: **Gave "..playerOtherName.." a vehicle: "..car.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })
        if SelectedPlrSource and car ~= "" then  
            ARMA.getUserIdentity(userid, function(identity)					
                exports['ghmattimysql']:execute("INSERT IGNORE INTO arma_user_vehicles(user_id,vehicle,vehicle_plate) VALUES(@user_id,@vehicle,@registration)", {user_id = id, vehicle = car, registration = "P "..identity.registration})
            end)
            ARMAclient.notify(source,{'~g~Successfully added Player\'s car'})
        else 
            ARMAclient.notify(source,{'~r~Failed to add Player\'s car'})
        end
    end
end)

RegisterNetEvent('ARMA:PropCleanup')
AddEventHandler('ARMA:PropCleanup', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.menu') then
        TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[ARMA]", 'A Entity cleanup has been triggered!'}
          })
          Wait(0)
          for i,v in pairs(GetAllObjects()) do 
             DeleteEntity(v)
          end
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[ARMA]", "Entity Cleanup Completed! ^1( " .. GetPlayerName(source) .. " )"}
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        ARMAclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('ARMA:DeAttachEntity')
AddEventHandler('ARMA:DeAttachEntity', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.menu') then
        TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[ARMA]", 'A Deattach cleanup has been triggered!'}
          })
          TriggerClientEvent("ARMAAdmin:EntityWipe", -1)
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[ARMA]", " Deattach Cleanup Completed ^1( " .. GetPlayerName(source) .. " )"}
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        ARMAclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('ARMA:PedCleanup')
AddEventHandler('ARMA:PedCleanup', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.menu') then
          for i,v in pairs(GetAllPeds()) do 
             DeleteEntity(v)
          end
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[ARMA]", "Ped Cleanup Completed ^1( " .. GetPlayerName(source) .. " )"  }
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        ARMAclient.notify(source,{"~r~You can not perform this action!"})
    end
end)


RegisterNetEvent('ARMA:VehCleanup')
AddEventHandler('ARMA:VehCleanup', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.menu') then
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[ARMA]", "A Vehicle Cleanup has been Triggered, please wait 30 seconds!"}
          })
          Wait(30000)
          for i,v in pairs(GetAllVehicles()) do 
             DeleteEntity(v)
          end
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[ARMA]", "Vehicle Cleanup Completed! ^1(" .. GetPlayerName(source) .. " )"}
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        ARMAclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('ARMA:CleanAll')
AddEventHandler('ARMA:CleanAll', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.menu') then
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[ARMA]", "A Vehicle, Ped, Enitity cleanup has been triggered!"}
          })
          Wait(0)
          for i,v in pairs(GetAllVehicles()) do 
            DeleteEntity(v)
         end
         for i,v in pairs(GetAllPeds()) do 
           DeleteEntity(v)
        end
        for i,v in pairs(GetAllObjects()) do
           DeleteEntity(v)
        end
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[ARMA]", "Vehicle, Ped, Entity Cleanup Completed ^1( " .. GetPlayerName(source) .. " )"}
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        ARMAclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('hello')
AddEventHandler('hello', function(bool)
    local source = source
    userid = ARMA.getUserId(source)
    if bool then
        ARMA.addUserGroup(userid,'staffon')
    else
        ARMA.removeUserGroup(userid,'staffon')
    end
end)