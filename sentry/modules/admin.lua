
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

RegisterServerEvent('Sentry:OpenSettings')
AddEventHandler('Sentry:OpenSettings', function()
    local source = source
    local user_id = Sentry.getUserId(source)
    if user_id ~= nil and Sentry.hasPermission(user_id, "admin.menu") then
        TriggerClientEvent("Sentry:OpenSettingsMenu", source, true)
    else
        TriggerClientEvent("Sentry:OpenSettingsMenu", source, false)
    end
end)

RegisterServerEvent("Sentry:GetPlayerData")
AddEventHandler("Sentry:GetPlayerData",function()
    local source = source
    user_id = Sentry.getUserId(source)
    if Sentry.hasPermission(user_id, admincfg.perm) then
        players = GetPlayers()
        players_table = {}
        menu_btns_table = {}
        useridz = {}
        for i, p in pairs(players) do
            if Sentry.getUserId(p) ~= nil then
            name = GetPlayerName(p)
            user_idz = Sentry.getUserId(p)
            players_table[user_idz] = {name, p, user_idz}
            table.insert (useridz, user_idz)
            else
                DropPlayer(p, "[Sentry] You Were Kicked")
            end
         end
        if admincfg.IgnoreButtonPerms == false then
            for i, b in pairs(admincfg.buttonsEnabled) do
                if b[1] and Sentry.hasPermission(user_id, b[2]) then
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
        TriggerClientEvent("Sentry:SendPlayersInfo", source, players_table, menu_btns_table)
    end
end)

RegisterServerEvent("Sentry:getGroups")
AddEventHandler("Sentry:getGroups",function(temp, perm)
    local user_groups = Sentry.getUserGroups(perm)
    TriggerClientEvent("Sentry:gotgroups", source, user_groups)
end)

RegisterServerEvent("Sentry:CheckPOV")
AddEventHandler("Sentry:CheckPOV",function(userperm)
    local user_id = Sentry.getUserId(source)
    if Sentry.hasPermission(user_id, "admin.menu") then
        if Sentry.hasGroup(userperm, 'pov') then
            TriggerClientEvent('Sentry:ReturnPOV', source, true)
        elseif not Sentry.hasGroup(userperm, 'pov') then
            TriggerClientEvent('Sentry:ReturnPOV', source, false)
        end
    else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
    end
end)

local onesync = GetConvar('onesync', nil)
RegisterNetEvent('SentryAdmin:SpectatePlr')
AddEventHandler('SentryAdmin:SpectatePlr', function(id)
    local source = source 
    local SelectedPlrSource = Sentry.getUserSource(id) 
    local userid = Sentry.getUserId(source)
 
        if SelectedPlrSource then  
            if onesync ~= "off" then 
                local ped = GetPlayerPed(SelectedPlrSource)
                local pedCoords = GetEntityCoords(ped)
                print(pedCoords)
                TriggerClientEvent('SentryAdmin:Spectate', source, SelectedPlrSource, pedCoords)
            else 
                TriggerClientEvent('SentryAdmin:Spectate', source, SelectedPlrSource)  
            end
        else 
            Sentryclient.notify(source,{"~r~This player may have left the game."})
        end

end)

RegisterServerEvent("Sentry:addGroup")
AddEventHandler("Sentry:addGroup",function(perm, selgroup)
    local admin_temp = source
    local admin_perm = Sentry.getUserId(admin_temp)
    local user_id = Sentry.getUserId(source)
    local permsource = Sentry.getUserSource(perm)
    local playerName = GetPlayerName(source)
    local povName = GetPlayerName(permsource)
    if Sentry.hasPermission(user_id, "group.add") then
        if selgroup == "founder" and not Sentry.hasPermission(admin_perm, "group.add.founder") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "staffmanager" and not Sentry.hasPermission(admin_perm, "group.add.staffmanager") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "commanager" and not Sentry.hasPermission(admin_perm, "group.add.commanager") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "headadmin" and not Sentry.hasPermission(admin_perm, "group.add.headadmin") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "senioradmin" and not Sentry.hasPermission(admin_perm, "group.add.senioradmin") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "administrator" and not Sentry.hasPermission(admin_perm, "group.add.administrator") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "moderator" and not Sentry.hasPermission(admin_perm, "group.add.moderator") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "trialstaff" and not Sentry.hasPermission(admin_perm, "group.add.trial") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "vip" and not Sentry.hasPermission(admin_perm, "group.add.vip") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "pov" and not Sentry.hasGroup(perm, "pov") then
            webhook = "https://discord.com/api/webhooks/934896508036321302/QImWOhrrQixTQoaeEw3FD_gjpdDXf3buT-l_hLNFitI1ej9lJxfr4D8200y98CbD3Ivw"
            PerformHttpRequest(webhook, function(err, text, headers) 
            end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
                {
                    ["color"] = "15158332",
                    ["title"] = playerName.." put "..povName.." onto the POV List.",
                    ["description"] = "Admin Name: **"..playerName.."** \nAdmin ID: **"..admin_perm.."** \nPlayer ID: **"..perm.."** \nPlayer Name: **"..povName.."**",
                    ["footer"] = {
                        ["text"] = "Time - "..os.date("%x %X %p"),
                    }
            }
            }}), { ["Content-Type"] = "application/json" })
            Sentry.addUserGroup(perm, "pov")
            Sentryclient.notify(source,{'~g~Added group to POV List'})
            Sentryclient.notify(permsource,{'~r~You were added to POV List ~w~[ID: ' .. admin_perm .. ' ]'})
        else
            Sentry.addUserGroup(perm, selgroup)
            Sentryclient.notify(source,{'~g~Added group to user'})
            Sentryclient.notify(permsource,{'~g~You have been given: ~w~' .. selgroup .. ' ~g~group ~w~[ID: ' .. admin_perm .. ' ]'})
        end
    else
        print("Stop trying to add a group u fucking cheater")
    end
end)

RegisterServerEvent("Sentry:removeGroup")
AddEventHandler("Sentry:removeGroup",function(perm, selgroup)
    local user_id = Sentry.getUserId(source)
    local admin_temp = source
    local admin_perm = Sentry.getUserId(admin_temp)
    local permsource = Sentry.getUserSource(perm)
    local playerName = GetPlayerName(source)
    local povName = GetPlayerName(permsource)
    if Sentry.hasPermission(user_id, "group.remove") then
        if selgroup == "founder" and not Sentry.hasPermission(user_id, "group.remove.founder") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "staffmanager" and not Sentry.hasPermission(user_id, "group.remove.staffmanager") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "commanager" and not Sentry.hasPermission(user_id, "group.remove.commanager") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "headadmin" and not Sentry.hasPermission(user_id, "group.remove.headadmin") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "senioradmin" and not Sentry.hasPermission(user_id, "group.remove.senioradmin") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "administrator" and not Sentry.hasPermission(user_id, "group.remove.administrator") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "moderator" and not Sentry.hasPermission(user_id, "group.remove.moderator") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "trialstaff" and not Sentry.hasPermission(user_id, "group.remove.trial") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "vipgarage" and not Sentry.hasPermission(user_id, "group.remove.vipgarage") then
            Sentryclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "pov" and Sentry.hasGroup(perm, "pov") then
            webhook = "https://discord.com/api/webhooks/930515250690809936/3uENxi2b7yzVXBixV74Ll2Lt9mRmv6YKdhHDQVjwyoSzmKOk6Qad0lxDcGpe791o5iAj"
            PerformHttpRequest(webhook, function(err, text, headers) 
            end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
                {
                    ["color"] = "15158332",
                    ["title"] = playerName.." removed "..povName.." from the POV List.",
                    ["description"] = "Admin Name: **"..playerName.."** \nAdmin ID: **"..user_id.."** \nPlayer ID: **"..perm.."** \nPlayer Name: **"..povName.."**",
                    ["footer"] = {
                        ["text"] = "Time - "..os.date("%x %X %p"),
                    }
            }
            }}), { ["Content-Type"] = "application/json" })
            Sentry.removeUserGroup(perm, "pov")
            Sentryclient.notify(source,{'~r~Removed POV List of user'})
            Sentryclient.notify(permsource,{'~r~Someone removed you of POV List'})
        else
            Sentry.removeUserGroup(perm, selgroup)
            Sentryclient.notify(source,{'~r~Removed group.'})
            Sentryclient.notify(permsource,{'~r~Your group has been removed: ~w~' .. selgroup .. ' ~r~group ~w~[ID: ' .. admin_perm .. ' ]'})
        end
    else 
        print("Stop trying to add a group u fucking cheater")
    end
end)

RegisterServerEvent('Sentry:BanPlayer')
AddEventHandler('Sentry:BanPlayer', function(admin, target, reason, duration)
    local target = target
    local target_id = Sentry.getUserSource(target)
    local admin_id = Sentry.getUserId(admin)
    if Sentry.hasPermission(user_id, "admin.ban") then
        if tonumber(duration) then 
            local playerName = GetPlayerName(source)
            local playerOtherName = GetPlayerName(target)
            if tonumber(duration) == -1 then
                Sentry.ban(source,target,"perm",reason or "No reason given")
                saveBanLog(target_id, GetPlayerName(admin), reason, duration)
            else
                Sentry.ban(source,target,duration,reason or "No reason given")
                saveBanLog(target_id, GetPlayerName(admin), reason, duration)
                print(admin, target_id)
                TriggerEvent('Sentry:BanPlayerLog', target, GetPlayerName(admin), reason, duration)
                webhook = "https://discord.com/api/webhooks/931165102240047135/JvE9_fXK0m9Jy0YnylbralzY27Fnc_NHzibpX4V-cCiUXaWhZydiBnZcpbRVQJWN0mKe"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "Banned ID: "..target .." out of the server. Reason: "..reason,
                        ["description"] = "Admin Name: **"..GetPlayerName(admin).."** \nAdmin ID: **"..Sentry.getUserId(admin).."** \nPlayer ID: **"..target.."** \nDescription: **Banned ID: "..target.." out of the server. Reason: "..reason.."**",
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                }
                }}), { ["Content-Type"] = "application/json" })
                TriggerClientEvent('Sentry:Notify', admin, 'Banned Player')
            end
        end
    end
end)

RegisterServerEvent('Sentry:KickPlayer')
AddEventHandler('Sentry:KickPlayer', function(admin, target, reason, tempid)
    local target_id = Sentry.getUserSource(target)
    local target_permid = target
    local playerName = GetPlayerName(source)
    local playerOtherName = GetPlayerName(tempid)
    local perm = admincfg.buttonsEnabled["kick"][2]
    local admin_id = Sentry.getUserId(admin)
    if Sentry.hasPermission(admin_id, perm) then
        webhook = "https://discord.com/api/webhooks/930515850123960380/I5YU8Z1MA6rQ0SLCsqJ30-94jjJ4ZEYZWuxKckAcBNZmQ0b66OBLp3LMrfSIrnXUc9OO"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Kicked "..playerOtherName.." out of the server. Reason: "..reason,
                ["description"] = "Admin Name: **"..playerName.."** \nAdmin ID: **"..admin_id.."** \nPlayer ID: **"..target_permid.."** \nReason:" ..reason,
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        Sentry.kick(target_id, "[Sentry] You have been kicked | Your ID is: "..target.." | Reason: "..reason.." | Kicked by "..GetPlayerName(admin) or "No reason specified")
        TriggerEvent("Sentry:saveKickLog",target,GetPlayerName(admin),reason)
        TriggerClientEvent('Sentry:Notify', admin, 'Kicked Player')
    end
end)

RegisterServerEvent('Sentry:KickPlayerNoF10')
AddEventHandler('Sentry:KickPlayerNoF10', function(admin, target, reason)
    local target_id = Sentry.getUserSource(target)
    local target_permid = Sentry.getUserId(target)
    local perm = admincfg.buttonsEnabled["kick"][2]
    local admin_id = Sentry.getUserId(admin)
    if Sentry.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        webhook = "https://discord.com/api/webhooks/930515850123960380/I5YU8Z1MA6rQ0SLCsqJ30-94jjJ4ZEYZWuxKckAcBNZmQ0b66OBLp3LMrfSIrnXUc9OO"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "No F10 Kicked "..playerOtherName.." out of the server. Reason: "..reason,
                ["description"] = "Admin Name: **"..playerName.."** \nAdmin ID: **"..admin_id.."** \nPlayer ID: **"..target_permid.."** \nDescription: **No F10 Kicked "..playerOtherName.." out of the server. Reason: "..reason.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        Sentry.kick(target_id, "[Sentry] You have been kicked | Your ID is: "..target.." | Reason: "..reason.." | Kicked by "..GetPlayerName(admin) or "No reason specified")
        TriggerClientEvent('Sentry:Notify', admin, 'Kicked Player')
    end
end)

RegisterServerEvent('Sentry:RemoveWarning')
AddEventHandler('Sentry:RemoveWarning', function(admin, warningid)
    local admin_id = Sentry.getUserId(admin)
    local perm = admincfg.buttonsEnabled["removewarn"][2]
    if Sentry.hasPermission(admin_id, perm) then
        exports['ghmattimysql']:execute("DELETE FROM sentry_warnings WHERE warning_id = @uid", {uid = warningid})
        TriggerClientEvent('Sentry:Notify', admin, 'Removed #'..warningid..' Warning ID')
    end
end)

RegisterServerEvent("Sentry:Unban")
AddEventHandler("Sentry:Unban",function(perm1)
    local admin_id = Sentry.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["ban"][2]
    playerName = GetPlayerName(source)
    if Sentry.hasPermission(admin_id, perm2) then

        ExecuteCommand('unban ' .. perm1)
        Sentryclient.notify(source,{'~g~Unbanned ID: ' .. perm1})
        webhook = "https://discord.com/api/webhooks/934896907703189544/vye_gVk3G5bbBSkOXDQ0BmjKiQv4XLhpdd5HJjD5NfePDQ-qalaHd27l_i38xGVWLy11"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
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

RegisterServerEvent('Sentry:SlapPlayer')
AddEventHandler('Sentry:SlapPlayer', function(admin, target)
    local admin_id = Sentry.getUserId(admin)
    if Sentry.hasPermission(admin_id, "admin.slap") then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        webhook = "https://discord.com/api/webhooks/930515984723378177/wklMHwU-Pv4YDDXymMApwVLplEwfunEXclpgMFV3RL5aN5pBSzcOiJXw5dEeDbL8us5l"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Slapped "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Slapped "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        TriggerClientEvent('Sentry:SlapPlayer', target)
        TriggerClientEvent('Sentry:Notify', admin, 'Slapped Player')
    end
end)

RegisterServerEvent('Sentry:RevivePlayer')
AddEventHandler('Sentry:RevivePlayer', function(admin, target)
    local admin_id = Sentry.getUserId(admin)
    if Sentry.hasPermission(admin_id, "admin.revive") then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        webhook = "https://discord.com/api/webhooks/930516091451629588/CfBWLbFYvryiWHoDko6cvh4avRMXvE9JKxGyrPGVnytV8EiUSBiz63BzfnGmakPPAiwZ"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Revived "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Revived "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        Sentryclient.notify(target,{'~g~' .. GetPlayerName(admin) .. ' revived you ~w~[ID: ' .. user_id .. ']'})
        TriggerClientEvent('IFN:FixClient',target)
        TriggerClientEvent('Sentry:Notify', admin, 'Revived Player')
    end
end)

RegisterServerEvent('Sentry:FreezeSV')
AddEventHandler('Sentry:FreezeSV', function(admin, newtarget, isFrozen)
    local admin_id = Sentry.getUserId(admin)
    local perm = admincfg.buttonsEnabled["FREEZE"][2]
    if Sentry.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        if isFrozen then
            webhook = "https://discord.com/api/webhooks/916729659704635393/Dw4uZkCu-NpiaggBLtrI64_1vFIzFf9oMHLlHvou05zsXmbSnSomvm49Wa-zYu768gSC"
            PerformHttpRequest(webhook, function(err, text, headers) 
            end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
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
            end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
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
        TriggerClientEvent('Sentry:Freeze', newtarget, isFrozen)
        TriggerClientEvent('Sentry:Notify', admin, 'Froze Player')
    end
end)

RegisterServerEvent('Sentry:TeleportToPlayer')
AddEventHandler('Sentry:TeleportToPlayer', function(source, newtarget)
    local coords = GetEntityCoords(GetPlayerPed(newtarget))
    local user_id = Sentry.getUserId(source)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if Sentry.hasPermission(user_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        webhook = "https://discord.com/api/webhooks/930518910271381554/tXeSuSe5-Yy1OfT9DcDHQ449QlmOD6zmNZ-qs-EEf0kTe2eKnR_w7UGFL9rtyXoJSwkS"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Teleported to "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Teleported to "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        TriggerClientEvent('Sentry:Teleport', source, coords)
    end
end)

RegisterServerEvent('Sentry:TeleportToMe')
AddEventHandler('Sentry:TeleportToMe', function(source, newtarget)
    local user_id = Sentry.getUserId(source)
    local perm = admincfg.buttonsEnabled["TP2ME"][2]
    if Sentry.hasPermission(user_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        webhook = "https://discord.com/api/webhooks/930519041989279814/GkyW8iKAmqxi_Fclpf7b4t-jxcbF10M9vI5UtryojcriuU6S9y2kzret9zQSLl-Ae0u2"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Brang "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Brang "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })
        TriggerClientEvent('Sentry:Teleport2Me2', newtarget, source)
    end
end)


RegisterNetEvent('SentryAdmin:Bring')
AddEventHandler('SentryAdmin:Bring', function(id)
    local source = source 
    local SelectedPlrSource = Sentry.getUserSource(id) 
    local userid = Sentry.getUserId(source)
  
        if SelectedPlrSource then  
            if onesync ~= "off" then 
                local ped = GetPlayerPed(source)
                local otherPlr = GetPlayerPed(SelectedPlrSource)
                local pedCoords = GetEntityCoords(ped)
                local playerOtherName = GetPlayerName(SelectedPlrSource)
                SetEntityCoords(otherPlr, pedCoords)

                webhook = "https://discord.com/api/webhooks/930519041989279814/GkyW8iKAmqxi_Fclpf7b4t-jxcbF10M9vI5UtryojcriuU6S9y2kzret9zQSLl-Ae0u2"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
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
                TriggerClientEvent('SentryAdmin:Bring', SelectedPlrSource, false, id)  
            end
        else 
            Sentryclient.notify(source,{"~r~This player may have left the game."})
        end
 
end)

playersSpectating = {}
playersToSpectate = {}

RegisterServerEvent('Sentry:SpectateCheck')
AddEventHandler('Sentry:SpectateCheck', function(newtarget)
    local admin_id = source
    local user_id = Sentry.getUserId(source)
    local perm = admincfg.buttonsEnabled["spectate"][2]
    if Sentry.hasPermission(user_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        webhook = "https://discord.com/api/webhooks/930519177054281818/_KuFaoWpYWOnha6Z-DPFj1XgiutVBXY2KqpylFZAoykCgZ5a2Ep3xl9EJuWZwbiiU7U3"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Started spectating "..playerOtherName,
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Started spectating "..playerOtherName.."**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })

        TriggerClientEvent('Sentry:SpectateClient', source, newtarget)
        
    end
end)

RegisterServerEvent('Sentry:Prompt')
AddEventHandler('Sentry:Prompt', function(shit)
    local admin_id = source
    local user_id = Sentry.getUserId(admin)
    Sentry.prompt(source, "Clothing:", shit, function(player, PermID)
    end)
end)

RegisterNetEvent('VRPDEV:GetCoords')
AddEventHandler('VRPDEV:GetCoords', function()
    local source = source 
    local userid = Sentry.getUserId(source)
    if Sentry.hasGroup(userid, "dev") then
        Sentryclient.getPosition(source,{},function(x,y,z)
            Sentry.prompt(source,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) end)
        end)
    end
end)

RegisterServerEvent('Sentry:Tp2Coords')
AddEventHandler('Sentry:Tp2Coords', function()
    local source = source
    local userid = Sentry.getUserId(source)
    if Sentry.hasGroup(userid, "dev") then
        Sentry.prompt(source,"Coords x,y,z:","",function(player,fcoords) 
            local coords = {}
            for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
            table.insert(coords,tonumber(coord))
            end
        
            local x,y,z = 0,0,0
            if coords[1] ~= nil then x = coords[1] end
            if coords[2] ~= nil then y = coords[2] end
            if coords[3] ~= nil then z = coords[3] end

            if x and y and z == 0 then
                Sentryclient.notify(source, {"~r~We couldn't find those coords, try again!"})
            else
                Sentryclient.teleport(player,{x,y,z})
            end 
        end)
    end
end)

RegisterServerEvent('Sentry:GiveMoney2')
AddEventHandler('Sentry:GiveMoney2', function()
    local source = source
    local userid = Sentry.getUserId(source)
    if Sentry.hasGroup(userid, "dev") then
        if user_id ~= nil then
            Sentry.prompt(source,"Amount:","",function(source,amount) 
                amount = parseInt(amount)
                Sentry.giveMoney(user_id, amount)
                Sentryclient.notify(source,{"You have gave youself ~g~£" .. amount})
            end)
        end

    end
end)

RegisterServerEvent("Sentry:Teleport2AdminIsland")
AddEventHandler("Sentry:Teleport2AdminIsland",function(id)
    local admin = source
    local admin_id = Sentry.getUserId(admin)
    local admin_name = GetPlayerName(admin)
    local player_id = Sentry.getUserId(id)
    local player_name = GetPlayerName(id)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if Sentry.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(id)
        webhook = "https://discord.com/api/webhooks/930519622598418432/4oFqM6dfybFGjqshX056PsBERieRxivEoDGdjGuG8-OrytpQE3cfEAfT1zrH8mCLcKV8"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Teleported "..playerOtherName.." to admin island",
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Teleported "..playerOtherName.." to admin island**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })
        Sentryclient.getPosition(id, {}, function(x,y,z)
            local location = tostring(x)..','..tostring(y)..','..tostring(z)
            exports['ghmattimysql']:execute("INSERT INTO sentry_tp_data (user_id, last_location) VALUES( @user_id, @location ) ON DUPLICATE KEY UPDATE `last_location` = @location", {user_id = id, location = location}, function() end)
        end)
        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped2, 3490.0769042969,2585.4392089844,14.149716377258)
    end
end)

RegisterServerEvent("Sentry:Teleport")
AddEventHandler("Sentry:Teleport",function(id, coords)
    local admin = source
    local admin_id = Sentry.getUserId(admin)

    local perm = admincfg.buttonsEnabled["TP2"][2]
    if Sentry.hasPermission(admin_id, perm) then

        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped2, coords)
    end
end)


RegisterServerEvent("Sentry:Telepor2")
AddEventHandler("Sentry:Telepor2",function(id)

    local ped2 = GetPlayerPed(id)
    SetEntityCoords(ped2, 3490.0769042969,2585.4392089844,14.149716377258)
   
end)

RegisterServerEvent("Sentry:returnplayer")
AddEventHandler("Sentry:returnplayer",function(id)
    local admin = source
    local admin_id = Sentry.getUserId(admin)
    local admin_name = GetPlayerName(admin)
    local player_id = Sentry.getUserId(id)
    local player_name = GetPlayerName(id)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if Sentry.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(id)
        webhook = "https://discord.com/api/webhooks/930519734783467570/znozZqv4Rmzfia47r6RV-S8-4-ycfk_geYe2W1720znvWxVNT9LAMvSHVXZuRyPnEaHJ"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Returned "..playerOtherName.." to previous location",
                ["description"] = "Admin Name: **"..playerName.."** \nPermID: **"..user_id.."** \nDescription: **Returned "..playerOtherName.." to previous location**",
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })
        exports['ghmattimysql']:execute("SELECT last_location FROM sentry_tp_data WHERE user_id = @user_id", {user_id = id}, function(result)
            local t = {}
    
            for i in result[1].last_location:gmatch("([^,%s]+)") do  
                t[#t + 1] = i
            end 
    
            local x = tonumber(t[1])
            local y = tonumber(t[2])
            local z = tonumber(t[3])
            local coords = vector3(x,y,z)
            TriggerClientEvent("Sentry:TPCoords", id, coords)
        end)
        exports['ghmattimysql']:execute("DELETE FROM sentry_tp_data WHERE `user_id` = @user_id", {user_id = id}, function() end)        
    end
end)

RegisterNetEvent('Sentry:AddCar')
AddEventHandler('Sentry:AddCar', function(id, car)
    local source = source 
    local SelectedPlrSource = Sentry.getUserSource(id) 
    local userid = Sentry.getUserId(source)
    local perm = admincfg.buttonsEnabled["addcar"][2]
    if Sentry.hasPermission(userid, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(SelectedPlrSource)
        webhook = "https://discord.com/api/webhooks/930520128750252094/RRn7n7uqgP7_Zd8Z82NnfelvcUrik4Q5KHuRW9DvOSWmyOnCXL1-TSA69Wa9RQLju2P_"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "Sentry Roleplay", embeds = {
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
            Sentry.getUserIdentity(userid, function(identity)					
                exports['ghmattimysql']:execute("INSERT IGNORE INTO sentry_user_vehicles(user_id,vehicle,vehicle_plate) VALUES(@user_id,@vehicle,@registration)", {user_id = id, vehicle = car, registration = "P "..identity.registration})
            end)
            Sentryclient.notify(source,{'~g~Successfully added Player\'s car'})
        else 
            Sentryclient.notify(source,{'~r~Failed to add Player\'s car'})
        end
    end
end)

RegisterNetEvent('Sentry:PropCleanup')
AddEventHandler('Sentry:PropCleanup', function()
    local source = source
    local user_id = Sentry.getUserId(source)
    if Sentry.hasPermission(user_id, 'admin.menu') then
        TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[Sentry]", 'A Entity cleanup has been triggered!'}
          })
          Wait(0)
          for i,v in pairs(GetAllObjects()) do 
             DeleteEntity(v)
          end
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[Sentry]", "Entity Cleanup Completed! ^1( " .. GetPlayerName(source) .. " )"}
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        Sentryclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('Sentry:DeAttachEntity')
AddEventHandler('Sentry:DeAttachEntity', function()
    local source = source
    local user_id = Sentry.getUserId(source)
    if Sentry.hasPermission(user_id, 'admin.menu') then
        TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[Sentry]", 'A Deattach cleanup has been triggered!'}
          })
          TriggerClientEvent("SentryAdmin:EntityWipe", -1)
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[Sentry]", " Deattach Cleanup Completed ^1( " .. GetPlayerName(source) .. " )"}
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        Sentryclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('Sentry:PedCleanup')
AddEventHandler('Sentry:PedCleanup', function()
    local source = source
    local user_id = Sentry.getUserId(source)
    if Sentry.hasPermission(user_id, 'admin.menu') then
          for i,v in pairs(GetAllPeds()) do 
             DeleteEntity(v)
          end
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[Sentry]", "Ped Cleanup Completed ^1( " .. GetPlayerName(source) .. " )"  }
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        Sentryclient.notify(source,{"~r~You can not perform this action!"})
    end
end)


RegisterNetEvent('Sentry:VehCleanup')
AddEventHandler('Sentry:VehCleanup', function()
    local source = source
    local user_id = Sentry.getUserId(source)
    if Sentry.hasPermission(user_id, 'admin.menu') then
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[Sentry]", "A Vehicle Cleanup has been Triggered, please wait 30 seconds!"}
          })
          Wait(30000)
          for i,v in pairs(GetAllVehicles()) do 
             DeleteEntity(v)
          end
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[Sentry]", "Vehicle Cleanup Completed! ^1(" .. GetPlayerName(source) .. " )"}
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        Sentryclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('Sentry:CleanAll')
AddEventHandler('Sentry:CleanAll', function()
    local source = source
    local user_id = Sentry.getUserId(source)
    if Sentry.hasPermission(user_id, 'admin.menu') then
          TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[Sentry]", "A Vehicle, Ped, Enitity cleanup has been triggered!"}
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
            args = {"[Sentry]", "Vehicle, Ped, Entity Cleanup Completed ^1( " .. GetPlayerName(source) .. " )"}
          })
        else 
        print(GetPlayerName(source) .. ' is cheating! He\'s triggering events without permission')
        Sentryclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('hello')
AddEventHandler('hello', function(bool)
    userid = Sentry.getUserId(source)
    if bool then
        Sentry.addUserGroup(userid,'staffon')
    else
        Sentry.removeUserGroup(userid,'staffon')
    end
end)