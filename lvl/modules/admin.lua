
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

RegisterServerEvent('LVL:OpenSettings')
AddEventHandler('LVL:OpenSettings', function()
    local source = source
    local user_id = LVL.getUserId(source)
    if user_id ~= nil and LVL.hasPermission(user_id, "admin.menu") then
        TriggerClientEvent("LVL:OpenSettingsMenu", source, true)
    else
        TriggerClientEvent("LVL:OpenSettingsMenu", source, false)
    end
end)

RegisterServerEvent('LVL:OpenSettings')
AddEventHandler('LVL:OpenSettings', function()
    local source = source
    local user_id = LVL.getUserId(source)
    if user_id ~= nil and LVL.hasPermission(user_id, "admin.menu") then
        TriggerClientEvent("LVL:OpenSettingsMenu", source, true)
    else
        TriggerClientEvent("LVL:OpenSettingsMenu", source, false)
    end
end)

RegisterServerEvent("LVL:GetPlayerData")
AddEventHandler("LVL:GetPlayerData",function()
    local source = source
    user_id = LVL.getUserId(source)
    if LVL.hasPermission(user_id, admincfg.perm) then
        players = GetPlayers()
        players_table = {}
        menu_btns_table = {}
        useridz = {}
        for i, p in pairs(players) do
            if LVL.getUserId(p) ~= nil then
            name = GetPlayerName(p)
            user_idz = LVL.getUserId(p)
            players_table[user_idz] = {name, p, user_idz}
            table.insert (useridz, user_idz)
            else
                DropPlayer(p, "[LVL] You Were Kicked")
            end
         end
        if admincfg.IgnoreButtonPerms == false then
            for i, b in pairs(admincfg.buttonsEnabled) do
                if b[1] and LVL.hasPermission(user_id, b[2]) then
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
        TriggerClientEvent("LVL:SendPlayersInfo", source, players_table, menu_btns_table)
    end
end)

RegisterServerEvent("LVL:getGroups")
AddEventHandler("LVL:getGroups",function(temp, perm)
    local user_groups = LVL.getUserGroups(perm)
    TriggerClientEvent("LVL:gotgroups", source, user_groups)
end)

RegisterServerEvent("LVL:CheckPOV")
AddEventHandler("LVL:CheckPOV",function(userperm)
    local user_id = LVL.getUserId(source)
    if LVL.hasPermission(user_id, "admin.menu") then
        if LVL.hasGroup(userperm, 'pov') then
            TriggerClientEvent('LVL:ReturnPOV', source, true)
        elseif not LVL.hasGroup(userperm, 'pov') then
            TriggerClientEvent('LVL:ReturnPOV', source, false)
        end
    else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
    end
end)

local onesync = GetConvar('onesync', nil)
RegisterNetEvent('LVLAdmin:SpectatePlr')
AddEventHandler('LVLAdmin:SpectatePlr', function(id)
    local source = source 
    local SelectedPlrSource = LVL.getUserSource(id) 
    local userid = LVL.getUserId(source)
    if LVL.hasPermission(userid, 'admin.spectate') then
        if SelectedPlrSource then  
            if onesync ~= "off" then 
                local ped = GetPlayerPed(SelectedPlrSource)
                local pedCoords = GetEntityCoords(ped)
                print(pedCoords)
                TriggerClientEvent('LVLAdmin:Spectate', source, SelectedPlrSource, pedCoords)
            else 
                TriggerClientEvent('LVLAdmin:Spectate', source, SelectedPlrSource)  
            end
        else 
            LVLclient.notify(source,{"~r~This player may have left the game."})
        end
    end
end)

RegisterServerEvent("LVL:addGroup")
AddEventHandler("LVL:addGroup",function(perm, selgroup)
    local admin_temp = source
    local admin_perm = LVL.getUserId(admin_temp)
    local user_id = LVL.getUserId(source)
    local permsource = LVL.getUserSource(perm)
    local playerName = GetPlayerName(source)
    local povName = GetPlayerName(permsource)
    if LVL.hasPermission(user_id, "group.add") then
        if selgroup == "founder" and not LVL.hasPermission(admin_perm, "group.add.founder") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "staffmanager" and not LVL.hasPermission(admin_perm, "group.add.staffmanager") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "commanager" and not LVL.hasPermission(admin_perm, "group.add.commanager") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "headadmin" and not LVL.hasPermission(admin_perm, "group.add.headadmin") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "senioradmin" and not LVL.hasPermission(admin_perm, "group.add.senioradmin") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "administrator" and not LVL.hasPermission(admin_perm, "group.add.administrator") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "moderator" and not LVL.hasPermission(admin_perm, "group.add.moderator") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "trialstaff" and not LVL.hasPermission(admin_perm, "group.add.trial") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "vip" and not LVL.hasPermission(admin_perm, "group.add.vip") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "pov" and not LVL.hasGroup(perm, "pov") then
            webhook = "https://discord.com/api/webhooks/934896508036321302/QImWOhrrQixTQoaeEw3FD_gjpdDXf3buT-l_hLNFitI1ej9lJxfr4D8200y98CbD3Ivw"
            PerformHttpRequest(webhook, function(err, text, headers) 
            end, "POST", json.encode({username = "LVL Roleplay", embeds = {
                {
                    ["color"] = "15158332",
                    ["title"] = playerName.." put "..povName.." onto the POV List.",
                    ["description"] = "Admin Name: **"..playerName.."** \nAdmin ID: **"..admin_perm.."** \nPlayer ID: **"..perm.."** \nPlayer Name: **"..povName.."**",
                    ["footer"] = {
                        ["text"] = "Time - "..os.date("%x %X %p"),
                    }
            }
            }}), { ["Content-Type"] = "application/json" })
            LVL.addUserGroup(perm, "pov")
            LVLclient.notify(source,{'~b~Added group to POV List'})
            LVLclient.notify(permsource,{'~r~You were added to POV List ~w~[ID: ' .. admin_perm .. ' ]'})
        else
            LVL.addUserGroup(perm, selgroup)
            LVLclient.notify(source,{'~b~Added group to user'})
            LVLclient.notify(permsource,{'~b~You have been given: ~w~' .. selgroup .. ' ~b~group ~w~[ID: ' .. admin_perm .. ' ]'})
        end
    else
        print("Stop trying to add a group u fucking cheater")
    end
end)

RegisterNetEvent('LVL:HasFounder')
AddEventHandler('LVL:HasFounder', function()
    local source = source 
    user_id = LVL.getUserId(source)

    if LVL.hasGroup(user_id, 'founder') then 
        TriggerClientEvent('LVL:ClothingPerms', source, true)
    else
        TriggerClientEvent('LVL:ClothingPerms', source, false)
    end
end)

RegisterServerEvent("LVL:removeGroup")
AddEventHandler("LVL:removeGroup",function(perm, selgroup)
    local user_id = LVL.getUserId(source)
    local admin_temp = source
    local admin_perm = LVL.getUserId(admin_temp)
    local permsource = LVL.getUserSource(perm)
    local playerName = GetPlayerName(source)
    local povName = GetPlayerName(permsource)
    if LVL.hasPermission(user_id, "group.remove") then
        if selgroup == "founder" and not LVL.hasPermission(user_id, "group.remove.founder") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "staffmanager" and not LVL.hasPermission(user_id, "group.remove.staffmanager") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "commanager" and not LVL.hasPermission(user_id, "group.remove.commanager") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "headadmin" and not LVL.hasPermission(user_id, "group.remove.headadmin") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "senioradmin" and not LVL.hasPermission(user_id, "group.remove.senioradmin") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "administrator" and not LVL.hasPermission(user_id, "group.remove.administrator") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "moderator" and not LVL.hasPermission(user_id, "group.remove.moderator") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "trialstaff" and not LVL.hasPermission(user_id, "group.remove.trial") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "vipgarage" and not LVL.hasPermission(user_id, "group.remove.vipgarage") then
            LVLclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "pov" and LVL.hasGroup(perm, "pov") then
            webhook = "https://discord.com/api/webhooks/930515250690809936/3uENxi2b7yzVXBixV74Ll2Lt9mRmv6YKdhHDQVjwyoSzmKOk6Qad0lxDcGpe791o5iAj"
            PerformHttpRequest(webhook, function(err, text, headers) 
            end, "POST", json.encode({username = "LVL Roleplay", embeds = {
                {
                    ["color"] = "15158332",
                    ["title"] = playerName.." removed "..povName.." from the POV List.",
                    ["description"] = "Admin Name: **"..playerName.."** \nAdmin ID: **"..user_id.."** \nPlayer ID: **"..perm.."** \nPlayer Name: **"..povName.."**",
                    ["footer"] = {
                        ["text"] = "Time - "..os.date("%x %X %p"),
                    }
            }
            }}), { ["Content-Type"] = "application/json" })
            LVL.removeUserGroup(perm, "pov")
            LVLclient.notify(source,{'~r~Removed POV List of user'})
            LVLclient.notify(permsource,{'~r~Someone removed you of POV List'})
        else
            LVL.removeUserGroup(perm, selgroup)
            LVLclient.notify(source,{'~r~Removed group.'})
            LVLclient.notify(permsource,{'~r~Your group has been removed: ~w~' .. selgroup .. ' ~r~group ~w~[ID: ' .. admin_perm .. ' ]'})
        end
    else 
        print("Stop trying to add a group u fucking cheater")
    end
end)

RegisterServerEvent('LVL:BanPlayer')
AddEventHandler('LVL:BanPlayer', function(admin, target, reason, duration)
    local target = target
    local target_id = LVL.getUserSource(target)
    local admin_id = LVL.getUserId(admin)
    local user_id = LVL.getUserId(source)
    if LVL.hasPermission(user_id, "admin.ban") then
        if tonumber(duration) then 
            local playerName = GetPlayerName(source)
            local playerOtherName = GetPlayerName(target)
            if tonumber(duration) == -1 then
                LVL.ban(source,target,"perm",reason or "No reason given")
                saveBanLog(target_id, GetPlayerName(admin), reason, duration)
            else
                LVL.ban(source,target,duration,reason or "No reason given")
                saveBanLog(target_id, GetPlayerName(admin), reason, duration)
                print(admin, target_id)
                TriggerEvent('LVL:BanPlayerLog', target, GetPlayerName(admin), reason, duration)
                webhook = "https://discord.com/api/webhooks/931165102240047135/JvE9_fXK0m9Jy0YnylbralzY27Fnc_NHzibpX4V-cCiUXaWhZydiBnZcpbRVQJWN0mKe"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "LVL Roleplay", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "Banned ID: "..target .." out of the server. Reason: "..reason,
                        ["description"] = "Admin Name: **"..GetPlayerName(admin).."** \nAdmin ID: **"..LVL.getUserId(admin).."** \nPlayer ID: **"..target.."** \nDescription: **Banned ID: "..target.." out of the server. Reason: "..reason.."**",
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                }
                }}), { ["Content-Type"] = "application/json" })
                TriggerClientEvent('LVL:Notify', admin, 'Banned Player')
            end
        end
    end
end)

RegisterServerEvent('LVL:KickPlayer')
AddEventHandler('LVL:KickPlayer', function(admin, target, reason, tempid)
    local target_id = LVL.getUserSource(target)
    local target_permid = target
    local playerName = GetPlayerName(source)
    local playerOtherName = GetPlayerName(tempid)
    local perm = admincfg.buttonsEnabled["kick"][2]
    local admin_id = LVL.getUserId(admin)
    if LVL.hasPermission(admin_id, perm) then
        webhook = "https://discord.com/api/webhooks/930515850123960380/I5YU8Z1MA6rQ0SLCsqJ30-94jjJ4ZEYZWuxKckAcBNZmQ0b66OBLp3LMrfSIrnXUc9OO"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LVL Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Kicked "..playerOtherName.." out of the server. Reason: "..reason,
                ["description"] = "Admin Name: **"..playerName.."** \nAdmin ID: **"..admin_id.."** \nPlayer ID: **"..target_permid.."** \nReason:" ..reason,
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        LVL.kick(target_id, "[LVL] You have been kicked | Your ID is: "..target.." | Reason: "..reason.." | Kicked by "..GetPlayerName(admin) or "No reason specified")
        TriggerEvent("LVL:saveKickLog",target,GetPlayerName(admin),reason)
        TriggerClientEvent('LVL:Notify', admin, 'Kicked Player')
    end
end)

RegisterServerEvent('LVL:KickPlayerNoF10')
AddEventHandler('LVL:KickPlayerNoF10', function(admin, target, reason)
    local target_id = LVL.getUserSource(target)
    local target_permid = LVL.getUserId(target)
    local perm = admincfg.buttonsEnabled["kick"][2]
    local admin_id = LVL.getUserId(admin)
    if LVL.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        webhook = "https://discord.com/api/webhooks/930515850123960380/I5YU8Z1MA6rQ0SLCsqJ30-94jjJ4ZEYZWuxKckAcBNZmQ0b66OBLp3LMrfSIrnXUc9OO"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LVL Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "No F10 Kicked "..playerOtherName.." out of the server. Reason: "..reason,
                ["description"] = "Admin Name: **"..playerName.."** \nAdmin ID: **"..admin_id.."** \nPlayer ID: **"..target_permid.."** \nDescription: **No F10 Kicked "..playerOtherName.." out of the server. Reason: "..reason.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        LVL.kick(target_id, "[LVL] You have been kicked | Your ID is: "..target.." | Reason: "..reason.." | Kicked by "..GetPlayerName(admin) or "No reason specified")
        TriggerClientEvent('LVL:Notify', admin, 'Kicked Player')
    end
end)

RegisterServerEvent('LVL:RemoveWarning')
AddEventHandler('LVL:RemoveWarning', function(admin, warningid)
    local admin_id = LVL.getUserId(admin)
    local perm = admincfg.buttonsEnabled["removewarn"][2]
    if LVL.hasPermission(admin_id, perm) then
        exports['ghmattimysql']:execute("DELETE FROM lvl_warnings WHERE warning_id = @uid", {uid = warningid})
        TriggerClientEvent('LVL:Notify', admin, 'Removed #'..warningid..' Warning ID')
    end
end)

RegisterServerEvent("LVL:Unban")
AddEventHandler("LVL:Unban",function(perm1)
    local admin_id = LVL.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["ban"][2]
    playerName = GetPlayerName(source)
    if LVL.hasPermission(admin_id, perm2) then

        ExecuteCommand('unban ' .. perm1)
        LVLclient.notify(source,{'~b~Unbanned ID: ' .. perm1})
        webhook = "https://discord.com/api/webhooks/934896907703189544/vye_gVk3G5bbBSkOXDQ0BmjKiQv4XLhpdd5HJjD5NfePDQ-qalaHd27l_i38xGVWLy11"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LVL Roleplay", embeds = {
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

RegisterServerEvent('LVL:SlapPlayer')
AddEventHandler('LVL:SlapPlayer', function(admin, target)
    local admin_id = LVL.getUserId(admin)
    if LVL.hasPermission(admin_id, "admin.slap") then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        webhook = "https://discord.com/api/webhooks/930515984723378177/wklMHwU-Pv4YDDXymMApwVLplEwfunEXclpgMFV3RL5aN5pBSzcOiJXw5dEeDbL8us5l"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LVL Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Slapped "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Slapped "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        TriggerClientEvent('LVL:SlapPlayer', target)
        TriggerClientEvent('LVL:Notify', admin, 'Slapped Player')
    end
end)

RegisterServerEvent('LVL:RevivePlayer')
AddEventHandler('LVL:RevivePlayer', function(admin, target)
    local admin_id = LVL.getUserId(admin)
    if LVL.hasPermission(admin_id, "admin.revive") then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        webhook = "https://discord.com/api/webhooks/930516091451629588/CfBWLbFYvryiWHoDko6cvh4avRMXvE9JKxGyrPGVnytV8EiUSBiz63BzfnGmakPPAiwZ"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LVL Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Revived "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Revived "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        LVLclient.notify(target,{'~b~' .. GetPlayerName(admin) .. ' revived you ~w~[ID: ' .. user_id .. ']'})
        TriggerClientEvent('LVL:FixClient',target)
        TriggerClientEvent('LVL:Notify', admin, 'Revived Player')
    end
end)

RegisterServerEvent('LVL:FreezeSV')
AddEventHandler('LVL:FreezeSV', function(admin, newtarget, isFrozen)
    local admin_id = LVL.getUserId(admin)
    local perm = admincfg.buttonsEnabled["FREEZE"][2]
    if LVL.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        if isFrozen then
            webhook = "https://discord.com/api/webhooks/916729659704635393/Dw4uZkCu-NpiaggBLtrI64_1vFIzFf9oMHLlHvou05zsXmbSnSomvm49Wa-zYu768gSC"
            PerformHttpRequest(webhook, function(err, text, headers) 
            end, "POST", json.encode({username = "LVL Roleplay", embeds = {
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
            webhook = "https://discord.com/api/webhooks/906655854739210250/xGDY3OXAQBhDFkCAJ4CT1rlNqkqJoaJh8-HGrMiAjqvp4KiNdtplkJNlsbgYcDXfBeHC"
            PerformHttpRequest(webhook, function(err, text, headers) 
            end, "POST", json.encode({username = "LVL Roleplay", embeds = {
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
        TriggerClientEvent('LVL:Freeze', newtarget, isFrozen)
        TriggerClientEvent('LVL:Notify', admin, 'Froze Player')
    end
end)

RegisterServerEvent('LVL:TeleportToPlayer')
AddEventHandler('LVL:TeleportToPlayer', function(source, newtarget)
    local coords = GetEntityCoords(GetPlayerPed(newtarget))
    local user_id = LVL.getUserId(source)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if LVL.hasPermission(user_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        webhook = "https://discord.com/api/webhooks/930518910271381554/tXeSuSe5-Yy1OfT9DcDHQ449QlmOD6zmNZ-qs-EEf0kTe2eKnR_w7UGFL9rtyXoJSwkS"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LVL Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Teleported to "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Teleported to "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        TriggerClientEvent('LVL:Teleport', source, coords)
    end
end)

RegisterServerEvent('LVL:TeleportToMe')
AddEventHandler('LVL:TeleportToMe', function(source, newtarget)
    local user_id = LVL.getUserId(source)
    local perm = admincfg.buttonsEnabled["TP2ME"][2]
    if LVL.hasPermission(user_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        webhook = "https://discord.com/api/webhooks/930519041989279814/GkyW8iKAmqxi_Fclpf7b4t-jxcbF10M9vI5UtryojcriuU6S9y2kzret9zQSLl-Ae0u2"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LVL Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Brang "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Brang "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })
        TriggerClientEvent('LVL:Teleport2Me2', newtarget, source)
    end
end)


RegisterNetEvent('LVLAdmin:Bring')
AddEventHandler('LVLAdmin:Bring', function(id)
    local source = source 
    local SelectedPlrSource = LVL.getUserSource(id) 
    local userid = LVL.getUserId(source)
    if LVL.hasPermission(userid, 'admin.teleport') then
        if SelectedPlrSource then  
            if onesync ~= "off" then 
                local ped = GetPlayerPed(source)
                local otherPlr = GetPlayerPed(SelectedPlrSource)
                local pedCoords = GetEntityCoords(ped)
                local playerOtherName = GetPlayerName(SelectedPlrSource)
                SetEntityCoords(otherPlr, pedCoords)

                webhook = "https://discord.com/api/webhooks/930519041989279814/GkyW8iKAmqxi_Fclpf7b4t-jxcbF10M9vI5UtryojcriuU6S9y2kzret9zQSLl-Ae0u2"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "LVL Roleplay", embeds = {
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
                TriggerClientEvent('LVLAdmin:Bring', SelectedPlrSource, false, id)  
            end
        else 
            LVLclient.notify(source,{"~r~This player may have left the game."})
        end
    end
end)

playersSpectating = {}
playersToSpectate = {}

RegisterServerEvent('LVL:SpectateCheck')
AddEventHandler('LVL:SpectateCheck', function(newtarget)
    local admin_id = source
    local user_id = LVL.getUserId(source)
    local perm = admincfg.buttonsEnabled["spectate"][2]
    if LVL.hasPermission(user_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        webhook = "https://discord.com/api/webhooks/930519177054281818/_KuFaoWpYWOnha6Z-DPFj1XgiutVBXY2KqpylFZAoykCgZ5a2Ep3xl9EJuWZwbiiU7U3"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LVL Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Started spectating "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Started spectating "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })

        TriggerClientEvent('LVL:SpectateClient', source, newtarget)
        
    end
end)

RegisterServerEvent('LVL:Prompt')
AddEventHandler('LVL:Prompt', function(shit)
    local admin_id = source
    local user_id = LVL.getUserId(admin)
    LVL.prompt(source, "Clothing:", shit, function(player, PermID)
    end)
end)

RegisterNetEvent('LVLDEV:GetCoords')
AddEventHandler('LVLDEV:GetCoords', function()
    local source = source 
    local userid = LVL.getUserId(source)
    if LVL.hasGroup(userid, "dev") then
        LVLclient.getPosition(source,{},function(x,y,z)
            LVL.prompt(source,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) end)
        end)
    end
end)

RegisterServerEvent('LVL:Tp2Coords')
AddEventHandler('LVL:Tp2Coords', function()
    local source = source
    local userid = LVL.getUserId(source)
    if LVL.hasGroup(userid, "dev") then
        LVL.prompt(source,"Coords x,y,z:","",function(player,fcoords) 
            local coords = {}
            for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
            table.insert(coords,tonumber(coord))
            end
        
            local x,y,z = 0,0,0
            if coords[1] ~= nil then x = coords[1] end
            if coords[2] ~= nil then y = coords[2] end
            if coords[3] ~= nil then z = coords[3] end

            if x and y and z == 0 then
                LVLclient.notify(source, {"~r~We couldn't find those coords, try again!"})
            else
                LVLclient.teleport(player,{x,y,z})
            end 
        end)
    end
end)

RegisterServerEvent('LVL:GiveMoney2')
AddEventHandler('LVL:GiveMoney2', function()
    local source = source
    local userid = LVL.getUserId(source)
    if LVL.hasGroup(userid, "dev") then
        if user_id ~= nil then
            LVL.prompt(source,"Amount:","",function(source,amount) 
                amount = parseInt(amount)
                LVL.giveMoney(user_id, amount)
                LVLclient.notify(source,{"You have gave youself ~b~£" .. amount})
            end)
        end

    end
end)

RegisterServerEvent("LVL:Teleport2AdminIsland")
AddEventHandler("LVL:Teleport2AdminIsland",function(id)
    local admin = source
    local admin_id = LVL.getUserId(admin)
    local admin_name = GetPlayerName(admin)
    local player_id = LVL.getUserId(id)
    local player_name = GetPlayerName(id)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if LVL.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(id)
        webhook = "https://discord.com/api/webhooks/930519622598418432/4oFqM6dfybFGjqshX056PsBERieRxivEoDGdjGuG8-OrytpQE3cfEAfT1zrH8mCLcKV8"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LVL Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Teleported "..playerOtherName.." to admin island",
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Teleported "..playerOtherName.." to admin island**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })
        LVLclient.getPosition(id, {}, function(x,y,z)
            local location = tostring(x)..','..tostring(y)..','..tostring(z)
            exports['ghmattimysql']:execute("INSERT INTO lvl_tp_data (user_id, last_location) VALUES( @user_id, @location ) ON DUPLICATE KEY UPDATE `last_location` = @location", {user_id = id, location = location}, function() end)
        end)
        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped2, 3490.0769042969,2585.4392089844,14.149716377258)
    end
end)

RegisterServerEvent("LVL:Teleport")
AddEventHandler("LVL:Teleport",function(id, coords)
    local admin = source
    local admin_id = LVL.getUserId(admin)

    local perm = admincfg.buttonsEnabled["TP2"][2]
    if LVL.hasPermission(admin_id, perm) then

        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped2, coords)
    end
end)


RegisterServerEvent("LVL:Telepor2")
AddEventHandler("LVL:Telepor2",function(id)

    local ped2 = GetPlayerPed(id)
    SetEntityCoords(ped2, 3490.0769042969,2585.4392089844,14.149716377258)
   
end)

RegisterServerEvent("LVL:returnplayer")
AddEventHandler("LVL:returnplayer",function(id)
    local admin = source
    local admin_id = LVL.getUserId(admin)
    local admin_name = GetPlayerName(admin)
    local player_id = LVL.getUserId(id)
    local player_name = GetPlayerName(id)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if LVL.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(id)
        webhook = "https://discord.com/api/webhooks/930519734783467570/znozZqv4Rmzfia47r6RV-S8-4-ycfk_geYe2W1720znvWxVNT9LAMvSHVXZuRyPnEaHJ"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LVL Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Returned "..playerOtherName.." to previous location",
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Returned "..playerOtherName.." to previous location**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })
        exports['ghmattimysql']:execute("SELECT last_location FROM lvl_tp_data WHERE user_id = @user_id", {user_id = id}, function(result)
            local t = {}
    
            for i in result[1].last_location:gmatch("([^,%s]+)") do  
                t[#t + 1] = i
            end 
    
            local x = tonumber(t[1])
            local y = tonumber(t[2])
            local z = tonumber(t[3])
            local coords = vector3(x,y,z)
            TriggerClientEvent("LVL:TPCoords", id, coords)
        end)
        exports['ghmattimysql']:execute("DELETE FROM lvl_tp_data WHERE `user_id` = @user_id", {user_id = id}, function() end)        
    end
end)

RegisterNetEvent('LVL:AddCar')
AddEventHandler('LVL:AddCar', function(id, car)
    local source = source 
    local SelectedPlrSource = LVL.getUserSource(id) 
    local userid = LVL.getUserId(source)
    local perm = admincfg.buttonsEnabled["addcar"][2]
    if LVL.hasPermission(userid, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(SelectedPlrSource)
        webhook = "https://discord.com/api/webhooks/930520128750252094/RRn7n7uqgP7_Zd8Z82NnfelvcUrik4Q5KHuRW9DvOSWmyOnCXL1-TSA69Wa9RQLju2P_"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LVL Roleplay", embeds = {
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
            LVL.getUserIdentity(userid, function(identity)					
                exports['ghmattimysql']:execute("INSERT IGNORE INTO lvl_user_vehicles(user_id,vehicle,vehicle_plate) VALUES(@user_id,@vehicle,@registration)", {user_id = id, vehicle = car, registration = "P "..identity.registration})
            end)
            LVLclient.notify(source,{'~b~Successfully added Player\'s car'})
        else 
            LVLclient.notify(source,{'~r~Failed to add Player\'s car'})
        end
    end
end)

RegisterNetEvent('LVL:PropCleanup')
AddEventHandler('LVL:PropCleanup', function()
    local source = source
    local user_id = LVL.getUserId(source)
    if LVL.hasPermission(user_id, 'admin.menu') then
        TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[LVL]", 'A Entity cleanup has been triggered!'}
          })
          Wait(0)
          for i,v in pairs(GetAllObjects()) do 
             DeleteEntity(v)
          end
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[LVL]", "Entity Cleanup Completed! ^1( " .. GetPlayerName(source) .. " )"}
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        LVLclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('LVL:DeAttachEntity')
AddEventHandler('LVL:DeAttachEntity', function()
    local source = source
    local user_id = LVL.getUserId(source)
    if LVL.hasPermission(user_id, 'admin.menu') then
        TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[LVL]", 'A Deattach cleanup has been triggered!'}
          })
          TriggerClientEvent("LVLAdmin:EntityWipe", -1)
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[LVL]", " Deattach Cleanup Completed ^1( " .. GetPlayerName(source) .. " )"}
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        LVLclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('LVL:PedCleanup')
AddEventHandler('LVL:PedCleanup', function()
    local source = source
    local user_id = LVL.getUserId(source)
    if LVL.hasPermission(user_id, 'admin.menu') then
          for i,v in pairs(GetAllPeds()) do 
             DeleteEntity(v)
          end
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[LVL]", "Ped Cleanup Completed ^1( " .. GetPlayerName(source) .. " )"  }
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        LVLclient.notify(source,{"~r~You can not perform this action!"})
    end
end)


RegisterNetEvent('LVL:VehCleanup')
AddEventHandler('LVL:VehCleanup', function()
    local source = source
    local user_id = LVL.getUserId(source)
    if LVL.hasPermission(user_id, 'admin.menu') then
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[LVL]", "A Vehicle Cleanup has been Triggered, please wait 30 seconds!"}
          })
          Wait(30000)
          for i,v in pairs(GetAllVehicles()) do 
             DeleteEntity(v)
          end
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[LVL]", "Vehicle Cleanup Completed! ^1(" .. GetPlayerName(source) .. " )"}
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        LVLclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('LVL:CleanAll')
AddEventHandler('LVL:CleanAll', function()
    local source = source
    local user_id = LVL.getUserId(source)
    if LVL.hasPermission(user_id, 'admin.menu') then
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[LVL]", "A Vehicle, Ped, Enitity cleanup has been triggered!"}
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
            args = {"[LVL]", "Vehicle, Ped, Entity Cleanup Completed ^1( " .. GetPlayerName(source) .. " )"}
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        LVLclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('hello')
AddEventHandler('hello', function(bool)
    local source = source
    userid = LVL.getUserId(source)
    if bool then
        LVL.addUserGroup(userid,'staffon')
    else
        LVL.removeUserGroup(userid,'staffon')
    end
end)