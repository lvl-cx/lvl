local htmlEntities = module("lib/htmlEntities")
local Tools = module("lib/Tools")

RegisterServerEvent('ARMA:OpenSettings')
AddEventHandler('ARMA:OpenSettings', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil and not ARMA.hasPermission(user_id, "admin.tickets") then
        TriggerClientEvent("ARMA:OpenSettingsMenu", source, false)
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
            TriggerClientEvent("ARMA:ReturnNearbyPlayers", source, plrTable)
        end)
    end
end)

RegisterServerEvent("ARMA:requestAccountInfosv")
AddEventHandler("ARMA:requestAccountInfosv",function(status, permid)
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
AddEventHandler("ARMA:GetGroups",function(temp, perm)
    local user_groups = ARMA.getUserGroups(perm)
    TriggerClientEvent("ARMA:GotGroups", source, user_groups)
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


RegisterServerEvent("ARMA:stopSpectatePlayer")
AddEventHandler("ARMA:stopSpectatePlayer", function()
    local source = source
    TriggerClientEvent("ARMA:spectate", source,-1)
    TriggerClientEvent("ARMA:partThree",-1,source)
end)
RegisterServerEvent("ARMA:spectatePlayer")
AddEventHandler("ARMA:spectatePlayer", function(id)
    local playerssource = ARMA.getUserSource(id)
    local source = source
    if ARMA.hasPermission(ARMA.getUserId(source), "admin.spectate") then
        TriggerClientEvent("ARMA:spectate",source,playerssource,1000)
    end
end)

RegisterServerEvent("ARMA:spectatePlayerEsp")
AddEventHandler("ARMA:spectatePlayerEsp", function(id)
    local playerssource = ARMA.getUserSource(id)
    local source = source
    if ARMA.hasPermission(ARMA.getUserId(source), "admin.spectate") then
        TriggerClientEvent("ARMA:spectate",source,playerssource)
        TriggerClientEvent("ARMA:partTwo", playerssource,source)
    end
end)

RegisterServerEvent("ARMA:Giveweapon")
AddEventHandler("ARMA:Giveweapon",function()
    local source = source
    local userid = ARMA.getUserId(source)
    if ARMA.hasPermission(userid, "dev.menu") then
        ARMA.prompt(source,"Weapon Name:","",function(source,hash) 
        GiveWeaponToPed(source, 'weapon_'..hash, 250, false, true)
        local spawnweapon = {
            {
              ["color"] = "16448403",
              ["title"] = "ARMA Weapon Spawn Logs",
              ["description"] = "",
              ["text"] = "ARMA Server #1",
              ["fields"] = {
                {
                  ["name"] = "Player Name",
                  ["value"] = GetPlayerName(source),
                  ["inline"] = true
                },
                {
                  ["name"] = "Player TempID",
                  ["value"] = source,
                  ["inline"] = true
                },
                {
                  ["name"] = "Player PermID",
                  ["value"] = user_id,
                  ["inline"] = true
                },
                {
                  ["name"] = "Player Hours",
                  ["value"] = "do math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0",
                  ["inline"] = true
                },
                {
                  ["name"] = "Weapon Spawned",
                  ["value"] = "weapon_"..hash,
                  ["inline"] = true
                }
              }
            }
          }
          local webhook = "https://discord.com/api/webhooks/991456674038681680/2MLwDbdHTr_wOtJZHn5bZuO8ZK-C9LnigXBanDzSc-GnDEgfTWj_KYK8HWBOXzQU4wWn"
          PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = spawnweapon}), { ['Content-Type'] = 'application/json' })
        ARMAclient.notify(source,{"~g~Successfully spawned ~b~"..hash})
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
                GiveWeaponToPed(permsource, 'weapon_'..hash, 250, false, true)
                local giveweapon = {
                    {
                      ["color"] = "16448403",
                      ["title"] = "ARMA Give Weapon To Player Logs",
                      ["description"] = "",
                      ["text"] = "ARMA Server #1",
                      ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(admin),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                          ["name"] = "Player Name",
                          ["value"] = GetPlayerName(source),
                          ["inline"] = true
                        },
                        {
                          ["name"] = "Player TempID",
                          ["value"] = source,
                          ["inline"] = true
                        },
                        {
                          ["name"] = "Player PermID",
                          ["value"] = user_id,
                          ["inline"] = true
                        },
                        {
                          ["name"] = "Player Hours",
                          ["value"] = "do math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0",
                          ["inline"] = true
                        },
                        {
                          ["name"] = "Weapon Given To Player",
                          ["value"] = "weapon_"..hash,
                          ["inline"] = true
                        }
                      }
                    }
                  }
                  local webhook = "https://discord.com/api/webhooks/991456700362137620/OXE6qxXf2dUAAFFlNsVH716-LT4tP6bR6Xim3PWyyv5vKrJ50nlNTh0h5iM9qNDUfjDY"
                  PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = giveweapon}), { ['Content-Type'] = 'application/json' })
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
        local command = {
            {
                ["color"] = "16448403",
                ["title"] = "ARMA Faction Logs",
                ["description"] = "",
                ["text"] = "ARMA Server #1",
                ["fields"] = {
                    {
                        ["name"] = "Admin Name",
                        ["value"] = GetPlayerName(source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin TempID",
                        ["value"] = source,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin PermID",
                        ["value"] = user_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player Name",
                        ["value"] = player_name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player TempID",
                        ["value"] = player_temp,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player PermID",
                        ["value"] = player_perm,
                        ["inline"] = true
                    }
                }
            }
        }
        local webhook = "https://discord.com/api/webhooks/991476290496503818/vOqaK1KdoP1k3iK0aHRZlVBRBCXuOs4UOpK-sMcI7XTWnOFfT_7pnwhDoA_Bx-ccEub4"
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
    else
        --anticheat
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
            local command = {
                {
                    ["color"] = "16448403",
                    ["title"] = "ARMA Group Logs",
                    ["description"] = "",
                    ["text"] = "ARMA Server #1",
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = playerName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = user_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = GetPlayerName(permsource),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = permsource,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = perm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Hours",
                            ["value"] = math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60).." hours",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Group",
                            ["value"] = selgroup,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Added",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/991476392875274281/whNkj8tAOrjcODLqugXJEnyn6_Nd2rTLQ_ObAY3wXDljFarnwi-RCABeLJY9FXwPK2gB"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
            ARMA.addUserGroup(perm, "pov")
            local user_groups = ARMA.getUserGroups(perm)
            TriggerClientEvent("ARMA:GotGroups", source, user_groups)
        else
            ARMA.addUserGroup(perm, selgroup)
            local user_groups = ARMA.getUserGroups(perm)
            TriggerClientEvent("ARMA:GotGroups", source, user_groups)
            local command = {
                {
                    ["color"] = "16448403",
                    ["title"] = "ARMA Group Logs",
                    ["description"] = "",
                    ["text"] = "ARMA Server #1",
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = playerName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = user_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = GetPlayerName(permsource),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = permsource,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = perm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Hours",
                            ["value"] = "do math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Group",
                            ["value"] = selgroup,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Added",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/991476392875274281/whNkj8tAOrjcODLqugXJEnyn6_Nd2rTLQ_ObAY3wXDljFarnwi-RCABeLJY9FXwPK2gB"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
        end
    else
        --print("Stop trying to add a group u fucking cheater")
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
        elseif selgroup == "pov" and ARMA.hasGroup(perm, "group.remove.pov") then
            local command = {
                {
                    ["color"] = "16448403",
                    ["title"] = "ARMA Group Logs",
                    ["description"] = "",
                    ["text"] = "ARMA Server #1",
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = playerName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = user_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = GetPlayerName(permsource),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = permsource,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = perm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Hours",
                            ["value"] = "do math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Group Removed",
                            ["value"] = selgroup,
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/991476392875274281/whNkj8tAOrjcODLqugXJEnyn6_Nd2rTLQ_ObAY3wXDljFarnwi-RCABeLJY9FXwPK2gB"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
            ARMA.removeUserGroup(perm, "pov")
            local user_groups = ARMA.getUserGroups(perm)
            TriggerClientEvent("ARMA:GotGroups", source, user_groups)
        else
            ARMA.removeUserGroup(perm, selgroup)
            local user_groups = ARMA.getUserGroups(perm)
            TriggerClientEvent("ARMA:GotGroups", source, user_groups)
            local command = {
                {
                    ["color"] = "16448403",
                    ["title"] = "ARMA Group Logs",
                    ["description"] = "",
                    ["text"] = "ARMA Server #1",
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = playerName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = user_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = GetPlayerName(permsource),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = permsource,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = perm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Hours",
                            ["value"] = "do math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Group",
                            ["value"] = selgroup,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Removed",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/991476392875274281/whNkj8tAOrjcODLqugXJEnyn6_Nd2rTLQ_ObAY3wXDljFarnwi-RCABeLJY9FXwPK2gB"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
        end
    else 
        --print("Stop trying to add a group u fucking cheater")
    end
end)

local bans = {
    {id = "rdm", name = "RDM", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "vdm", name = "VDM", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "massrdm", name = "Mass RDM", durations = {-1, -1, -1, -1}, bandescription = "1st offense: Permanent\n2nd offense: N/A\n3rd offense: N/A", itemchecked = false},
    {id = "massvdm", name = "Mass VDM", durations = {-1, -1, -1, -1}, bandescription = "1st offense: Permanent\n2nd offense: N/A\n3rd offense: N/A", itemchecked = false},
    {id = "metagaming", name = "Metagaming", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "powergaming", name = "Powergaming", durations = {24, 48, 72, -1},  bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "combatlogging", name = "Combat Logging", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "combatstoring", name = "Combat Storing", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "badrp", name = "Bad-RP", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "failrp", name = "Fail-RP", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "invalidinitiation", name = "Invalid-Initiation", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "nlr", name = "NLR", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "trolling", name = "Trolling", durations = {48, 168, -1}, bandescription = "1st offense: 48 Hours\n2nd offense: 168 Hours\n3rd offense: Permanent", itemchecked = false},
    {id = "exploiting", name = "Exploiting", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "copbaiting", name = "NLR", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "gtadriving", name = "Cop Baiting", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "breakingchar", name = "GTA Driving", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "offensivelang", name = "Offensive Language", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "toxicity", name = "Toxicity", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "racism", name = "Racism", durations = {168, -1, -1, -1}, bandescription = "1st offense: Permanent\n2nd offense: N/A\n3rd offense: N/A", itemchecked = false},
    {id = "whitelistabuse", name = "Whitelist Abuse", durations = {168, -1, -1, -1}, bandescription = "1st offense: 168 Hours\n2nd offense: Permanent\n3rd offense: N/A", itemchecked = false},
    {id = "toev", name = "Theft Of An Emergancy Vehicle", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false,},
    {id = "oogt", name = "OOGT", durations = {-1, -1, -1, -1}, bandescription = "1st offense: Permanent\n2nd offense: N/A\n3rd offense: N/A", itemchecked = false},
    {id = "scamming", name = "Scamming", durations = {-1, -1, -1, -1}, bandescription = "1st offense: Permanent\n2nd offense: N/A\n3rd offense: N/A", itemchecked = false},
    {id = "cheating", name = "Cheating", durations = {-1, -1, -1, -1}, bandescription = "1st offense: Permanent\n2nd offense: N/A\n3rd offense: N/A", itemchecked = false},
    {id = "banevading", name = "Ban Evading", durations = {-1, -1, -1, -1}, bandescription = "1st offense: Permanent\n2nd offense: N/A\n3rd offense: N/A", itemchecked = false},
    {id = "homophobia", name = "Homophobia", durations = {168, -1, -1, -1}, bandescription = "1st offense: Permanent\n2nd offense: N/A\n3rd offense: N/A", itemchecked = false},
    {id = "doxing", name = "Doxing", durations = {-1, -1, -1, -1}, bandescription = "1st offense: Permanent\n2nd offense: N/A\n3rd offense: N/A", itemchecked = false},
    {id = "pii", name = "Personal Identification Information", durations = {-1, -1, -1, -1}, bandescription = "1st offense: 168 Hours\n2nd offense: Permanent\n3rd offense: N/A", itemchecked = false},
    {id = "externalmods", name = "External Modifications", durations = {168, -1, -1, -1}, bandescription = "1st offense: Permanent\n2nd offense: N/A\n3rd offense: N/A", itemchecked = false},
    {id = "cheataffiliation", name = "Affiliation With Cheats", durations = {-1, -1, -1, -1}, bandescription = "1st offense: Permanent\n2nd offense: N/A\n3rd offense: N/A", itemchecked = false},
    {id = "withholdingcheats", name = "Withholding/Storing FiveM Cheats", durations = {-1, -1, -1, -1}, bandescription = "1st offense: Permanent\n2nd offense: N/A\n3rd offense: N/A", itemchecked = false},
    {id = "nrti", name = "No Reason To Initiate", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "spitereporting", name = "Spite Reporting", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "wastingadmintime", name = "Wasting Admin Time", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "maliciousactivity", name = "Malicious Activity", durations = {168, -1, -1, -1}, bandescription = "1st offense: 168 Hours\n2nd offense: Permanent\n3rd offense: N/A", itemchecked = false},
    {id = "terroristrp", name = "Terrorist RP", durations = {168, -1, -1, -1}, bandescription = "1st offense: 168 Hours\n2nd offense: Permanent\n3rd offense: N/A", itemchecked = false},
    {id = "impersonationofwhitelistedfaction", name = "Impersonation Of A Whitelisted Faction", durations = {48, 72, 168, -1}, bandescription = "1st offense: 48 Hours\n2nd offense: 72 Hours\n3rd offense: 168 Hours", itemchecked = false},
    {id = "copbaiting", name = "Cop Baiting", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
    {id = "gangingimpersonation", name = "Gang Impersonation", durations = {48, 72, 168, -1}, bandescription = "1st offense: 48 Hours\n2nd offense: 72 Hours\n3rd offense: 168 Hours", itemchecked = false},
    {id = "gangalliance", name = "Gang Alliance", durations = {48, 72, 168, -1}, bandescription = "1st offense: 48 Hours\n2nd offense: 72 Hours\n3rd offense: 168 Hours", itemchecked = false},
    {id = "staffdiscreqtion", name = "Staff Discretion", durations = {-1, -1, -1, -1}, bandescription = "1st offense: 48 Hours\n2nd offense: 72 Hours\n3rd offense: 168 Hours", itemchecked = false},
    {id = "ftvl", name = "Failure To Value Life", durations = {24, 48, 72, -1}, bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours", itemchecked = false},
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
                                bans[a].durations[PlayerOffenses[PlayerID][k]] = -1
                            end
                            PlayerBanCachedDuration[PlayerID] = PlayerBanCachedDuration[PlayerID] + bans[a].durations[PlayerOffenses[PlayerID][k]]
                            if bans[a].durations[PlayerOffenses[PlayerID][k]] ~= -1 then
                                points = points + bans[a].durations[PlayerOffenses[PlayerID][k]]/24
                            else
                                points = 10
                            end
                            table.insert(PlayerCacheBanMessage, bans[a].name)
                            if bans[a].durations[PlayerOffenses[PlayerID][k]] == -1 or PlayerOffenses[PlayerID][k] > 3 then
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
                TriggerClientEvent("ARMA:RecieveBanPlayerData", source, PlayerBanCachedDuration[PlayerID], table.concat(PlayerCacheBanMessage, ", "), separatormsg, points)
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
end)

RegisterCommand('removepoints', function() -- proof of concept for removing points each month
    if os.date('%d') == '01' then
        print('first of month')
    else
        print(os.date('%d'))
        print('not first of month')
    end
end)

RegisterServerEvent("ARMA:BanPlayer")
AddEventHandler("ARMA:BanPlayer", function(PlayerID, Duration, BanMessage, BanPoints)
    local source = source
    local AdminPermID = ARMA.getUserId(source)
    local AdminName = GetPlayerName(source)
    local CurrentTime = os.time()
    local PlayerDiscordID = 0

    ARMA.prompt(source, "Ban Evidence","",function(player, Evidence)
        local Evidence = Evidence or ""
        if Evidence ~= nil and Evidence ~= "" then
            if ARMA.hasPermission(AdminPermID, "admin.tickets") then
                if Duration == -1 then
                    banDuration = "perm"
                else
                    banDuration = CurrentTime + (60 * 60 * tonumber(Duration))
                end

                local communityname = "vRP Staff Logs"
                local communtiylogo = "" --Must end with .png or .jpg
                local command = {
                    {
                        ["color"] = "15536128",
                        ["title"] = AdminName.. " banned "..PlayerID,
                        ["fields"] = {
                            {
                                ["name"] = "**Admin Name**",
                                ["value"] = "" ..AdminName,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Admin TempID**",
                                ["value"] = "" ..source,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Admin PermID**",
                                ["value"] = "" ..AdminPermID,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Player PermID**",
                                ["value"] = ""..PlayerID,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "**Ban Duration**",
                                ["value"] = "" ..Duration,
                                ["inline"] = true
                            },
                        },
                        ["description"] = "**Ban Evidence**\n```\n"..Evidence.."\n"..BanMessage.."```",
                        ["footer"] = {
                        ["text"] = communityname,
                        ["icon_url"] = communtiylogo,
                        },
                    }
                }
                PerformHttpRequest('webhook', function(err, text, headers) end, 'POST', json.encode({username = "Arma Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
                ARMAclient.notify(source, {"Banned ID: "..PlayerID})
                ARMA.ban(source,PlayerID,banDuration,BanMessage)
                f10Ban(PlayerID, AdminName, BanMessage, Duration)
                exports['ghmattimysql']:execute("UPDATE arma_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = BanPoints}, function() end)
                local a = exports['ghmattimysql']:executeSync("SELECT * FROM arma_bans_offenses WHERE UserID = @uid", {uid = PlayerID})
                for k,v in pairs(a) do
                    if v.UserID == PlayerID then
                        if v.points > 10 then
                            ARMA.banConsole(PlayerID,"perm","Excessive F10")
                        end
                    end
                end
            end
        else
            ARMAclient.notify(source, {"~r~Evidence field was left empty!"})
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
        TriggerClientEvent("ARMA:takeClientScreenshotAndUpload", target, "https://cmgstudios.net/upld/upload.php")
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
        TriggerClientEvent("ARMA:takeClientVideoAndUpload", target, "https://cmgstudios.net/upld/upload.php")
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Request Screenshot')
    end   
end)

RegisterServerEvent('ARMA:noF10Kick')
AddEventHandler('ARMA:noF10Kick', function()
    local admin_id = ARMA.getUserId(source)
    playerName = GetPlayerName(source)
    if ARMA.hasPermission(admin_id, 'admin.kick') then
        ARMA.prompt(source,"Perm ID:","",function(source,permid) 
            if permid == '' then return end
            permid = parseInt(permid)
            ARMA.prompt(source,"Reason:","",function(source,reason) 
                if reason == '' then return end
                local reason = reason
                ARMAclient.notify(source,{'~g~Kicked ID: ' .. permid})
                local command = {
                    {
                        ["color"] = "16448403",
                        ["title"] = "ARMA Kick Logs",
                        ["description"] = "",
                        ["text"] = "ARMA Server #1",
                        ["fields"] = {
                            {
                                ["name"] = "Admin Name",
                                ["value"] = GetPlayerName(source),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Admin TempID",
                                ["value"] = source,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Admin PermID",
                                ["value"] = admin_id,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player Name",
                                ["value"] = GetPlayerName(ARMA.getUserSource(permid)),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player TempID",
                                ["value"] = ARMA.getUserSource(permid),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player PermID",
                                ["value"] = permid,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player Hours",
                                ["value"] = "do math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0",
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Kick Reason(s)",
                                ["value"] = reason,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Kick Type",
                                ["value"] = "No F10",
                                ["inline"] = true
                            }
                        }
                    }
                }
                local webhook = "https://discord.com/api/webhooks/991476558818725960/wGi0MrLFj19RE_aG3QQkv4rCdywxs4EIunYJ_zmBey2sA0Rpus6Oe6vQBmakFrzIXh9h"
                PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
                DropPlayer(ARMA.getUserSource(permid), reason)
            end)
        end)
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to No F10 Kick Someone')
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
    local webhook = "https://discord.com/api/webhooks/991456860869775452/IWFxWlgQ3rC9ztzBgcRAoYaiAqfa9VP8jAyTq1HE8S2Whj4qVaG5dQDd2H9Hwwou-KJe"
    if ARMA.hasPermission(admin_id, 'admin.kick') then
        ARMA.prompt(source,"Reason:","",function(source,Reason) 
            if Reason == "" then return end
            local command = {
                {
                    ["color"] = "16448403",
                    ["title"] = "ARMA Kick Logs",
                    ["description"] = "",
                    ["text"] = "ARMA Server #1",
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = playerOtherName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = target_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = target,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Hours",
                            ["value"] = "do math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Kick Reason(s)",
                            ["value"] = Reason,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Kick Type",
                            ["value"] = "F10",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/991456860869775452/IWFxWlgQ3rC9ztzBgcRAoYaiAqfa9VP8jAyTq1HE8S2Whj4qVaG5dQDd2H9Hwwou-KJe"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
            ARMA.kick(target_id, "ARMA You have been kicked | Your ID is: "..target.." | Reason: " ..Reason.." | Kicked by "..GetPlayerName(admin) or "No reason specified")
            f10Kick(target_permid, adminName, Reason)
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
                            local command = {
                                {
                                    ["color"] = "16448403",
                                    ["title"] = "ARMA Remove Warning Logs",
                                    ["description"] = "",
                                    ["text"] = "ARMA Server #1",
                                    ["fields"] = {
                                        {
                                            ["name"] = "Admin Name",
                                            ["value"] = GetPlayerName(admin),
                                            ["inline"] = true
                                        },
                                        {
                                            ["name"] = "Admin TempID",
                                            ["value"] = admin,
                                            ["inline"] = true
                                        },
                                        {
                                            ["name"] = "Admin PermID",
                                            ["value"] = admin_id,
                                            ["inline"] = true
                                        },
                                        {
                                            ["name"] = "Warning ID",
                                            ["value"] = warningid,
                                            ["inline"] = true
                                        }
                                    }
                                }
                            }
                            local webhook = "https://discord.com/api/webhooks/991476754126475454/r_GpM5RUqss3v7-RSDLwaMMejgMhwB4BRvqGRRITWXUO5LRaUoiq6QBZJwlKtRUuAzjZ"
                            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
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
            local command = {
                {
                    ["color"] = "16448403",
                    ["title"] = "ARMA Unban Logs",
                    ["description"] = "",
                    ["text"] = "ARMA Server #1",
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = permid,
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/991476724363706418/m2aEhULB5NWG0NzS5FgGscLSeJvMDApibQ7oMmBHPctTrlXxfLCodlvFByoTCJoAmzdZ"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
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
AddEventHandler("ARMA:getNotes",function(admin, player)
    local source = source
    local admin_id = ARMA.getUserId(source)
    if ARMA.hasPermission(admin_id, 'admin.spectate') then
        exports['ghmattimysql']:execute("SELECT * FROM arma_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result ~= nil then
                TriggerClientEvent('ARMA:sendNotes', source, json.encode(result))
            end
        end)
    end
end)

RegisterServerEvent("ARMA:addNote")
AddEventHandler("ARMA:addNote",function(admin, player)
    local source = source
    local admin_id = ARMA.getUserId(source)
    local adminName = GetPlayerName(source)
    local playerName = GetPlayerName(player)
    local playerperm = ARMA.getUserId(player)
    if ARMA.hasPermission(admin_id, 'admin.spectate') then
        ARMA.prompt(source,"Reason:","",function(source,text) 
            if text == '' then return end
            exports['ghmattimysql']:execute("INSERT INTO arma_user_notes (`user_id`, `text`, `admin_name`, `admin_id`) VALUES (@user_id, @text, @admin_name, @admin_id);", {user_id = playerperm, text = text, admin_name = adminName, admin_id = admin_id}, function() end) 
            TriggerClientEvent(source, {'~g~You have added a note to '..playerName..'('..playerperm..') with the reason '..text})
            TriggerClientEvent('ARMA:updateNotes', -1, admin, playerperm)
            local command = {
                {
                    ["color"] = "16448403",
                    ["title"] = "ARMA Note Logs",
                    ["description"] = "",
                    ["text"] = "ARMA Server #1",
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = playerName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = player,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = playerperm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Note Message",
                            ["value"] = text,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Note Type",
                            ["value"] = "Add",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/991456823884398623/EqKL4NW4qvjjWQ46_exR-2l51CrkviiTqK959DoSJmbvfQGBdbFdYmodMoWLemwBpH_c"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
        end)
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Add Note')
    end
end)

RegisterServerEvent("ARMA:removeNote")
AddEventHandler("ARMA:removeNote",function(admin, player)
    local source = source
    local admin_id = ARMA.getUserId(source)
    local playerName = GetPlayerName(player)
    local playerperm = ARMA.getUserId(player)
    if ARMA.hasPermission(admin_id, 'admin.spectate') then
        ARMA.prompt(source,"Note ID:","",function(source,noteid) 
            if noteid == '' then return end
            exports['ghmattimysql']:execute("DELETE FROM arma_user_notes WHERE note_id = @noteid", {noteid = noteid}, function() end)
            ARMAclient.notify(admin, {'~g~You have removed note #'..noteid..' from '..playerName..'('..playerperm..')'})
            TriggerClientEvent('ARMA:updateNotes', -1, admin, playerperm)
            local command = {
                {
                    ["color"] = "16448403",
                    ["title"] = "ARMA Note Logs",
                    ["description"] = "",
                    ["text"] = "ARMA Server #1",
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = playerName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = player,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = playerperm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Note ID",
                            ["value"] = noteid,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Note Type",
                            ["value"] = "Remove",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/991456823884398623/EqKL4NW4qvjjWQ46_exR-2l51CrkviiTqK959DoSJmbvfQGBdbFdYmodMoWLemwBpH_c"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
        end)
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Remove Note')
    end
end)



RegisterServerEvent('ARMA:SlapPlayer')
AddEventHandler('ARMA:SlapPlayer', function(admin, target)
    local admin_id = ARMA.getUserId(admin)
    local player_id = ARMA.getUserId(target)
    if ARMA.hasPermission(admin_id, "admin.slap") then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        local command = {
            {
                ["color"] = "16448403",
                ["title"] = "ARMA Slap Logs",
                ["description"] = "",
                ["text"] = "ARMA Server #1",
                ["fields"] = {
                    {
                        ["name"] = "Admin Name",
                        ["value"] = GetPlayerName(source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin TempID",
                        ["value"] = admin,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin PermID",
                        ["value"] = admin_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player Name",
                        ["value"] = GetPlayerName(target),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player TempID",
                        ["value"] = target,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player PermID",
                        ["value"] = player_id,
                        ["inline"] = true
                    }
                }
            }
        }
        local webhook = "https://discord.com/api/webhooks/991476247660073040/XNH5g7OwPFDoCA4D1wqNo_HWrZD5EWNbb6QoYc2ducFjV2cPkryg8ACyFOj_ItKSOdSC"
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
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
    if ARMA.hasPermission(admin_id, "admin.revive") then
        ARMAclient.RevivePlayer(target, {})
        if not reviveall then
            local playerName = GetPlayerName(source)
            local playerOtherName = GetPlayerName(target)
            local command = {
                {
                    ["color"] = "16448403",
                    ["title"] = "ARMA Revive Logs",
                    ["description"] = "",
                    ["text"] = "ARMA Server #1",
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(admin),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = admin,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = GetPlayerName(target),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = target,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = player_id,
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/991476015660552252/iEMahT-rQyRIMbOjlFqyI_QpZDZ1XhnsPWUu5BtAm3BY0r1nuv-bfbhnMimmSQE7wAgQ"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
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
            local command = {
                {
                    ["color"] = "16448403",
                    ["title"] = "ARMA Freeze Logs",
                    ["description"] = "",
                    ["text"] = "ARMA Server #1",
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(admin),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = admin,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = GetPlayerName(newtarget),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = newtarget,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = player_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Frozen",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/991476216383148122/zz1KDN5VzkIQjTFOJ1hs1NAz-Nf7tFpo65ychqF8C7zZ8EL8Gl9guOqZHxhyI9omRtTN"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
            ARMAclient.notify(admin, {'~g~Froze Player.'})
            frozenplayers[user_id] = true
            ARMAclient.notify(newtarget, {'~g~You have been frozen.'})
        else
            local command = {
                {
                    ["color"] = "16448403",
                    ["title"] = "ARMA Freeze Logs",
                    ["description"] = "",
                    ["text"] = "ARMA Server #1",
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(admin),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = admin,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = GetPlayerName(newtarget),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = newtarget,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = player_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "UnFrozen",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://discord.com/api/webhooks/991476216383148122/zz1KDN5VzkIQjTFOJ1hs1NAz-Nf7tFpo65ychqF8C7zZ8EL8Gl9guOqZHxhyI9omRtTN"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
            ARMAclient.notify(admin, {'~g~Unfrozed Player.'})
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
            ARMAclient.notify(source, {'~g~Player was in another bucket, you have been set into their bucket.'})
        end
        ARMAclient.teleport(source, coords)
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to Teleport to Someone')
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
                ARMAclient.notify(source, {'~g~Player was in another bucket, they have been set into your bucket.'})
            end
        else 
            ARMAclient.notify(source,{"~r~This player may have left the game."})
        end
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("RDMAdmin:acBan", user_id, 11, name, player, 'Attempted to Teleport Someone to Them')
    end
end)

playersSpectating = {}
playersToSpectate = {}

RegisterNetEvent('ARMA:GetCoords')
AddEventHandler('ARMA:GetCoords', function()
    local source = source 
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.tickets") then
        ARMAclient.getPosition(source,{},function(coords)
            local x,y,z = table.unpack(coords)
            ARMA.prompt(source,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) 
                local command = {
                    {
                        ["color"] = "16448403",
                        ["title"] = "ARMA Admin Logs",
                        ["description"] = "",
                        ["text"] = "ARMA Server #1",
                        ["fields"] = {
                            {
                                ["name"] = "Admin Name",
                                ["value"] = GetPlayerName(source),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Admin TempID",
                                ["value"] = source,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Admin PermID",
                                ["value"] = user_id,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player Hours",
                                ["value"] = "do math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0",
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Coords",
                                ["value"] = choice,
                                ["inline"] = true
                            }
                        }
                    }
                }
                local webhook = "https://discord.com/api/webhooks/991476525515931698/EFvcicz4u-frkK-Y1tSfgHT_BhmE99xAyWTpvhdLxP8lm1sYIX66wmXIEvabFJh3_5VZ"
                PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
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
        local command = {
            {
                ["color"] = "16448403",
                ["title"] = "ARMA Teleport Logs",
                ["description"] = "",
                ["text"] = "ARMA Server #1",
                ["fields"] = {
                    {
                        ["name"] = "Admin Name",
                        ["value"] = GetPlayerName(source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin TempID",
                        ["value"] = source,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin PermID",
                        ["value"] = admin_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player Name",
                        ["value"] = player_name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player TempID",
                        ["value"] = id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player PermID",
                        ["value"] = player_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player Hours",
                        ["value"] = "do math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Teleport Type",
                        ["value"] = "Teleport to Admin Island",
                        ["inline"] = true
                    }
                }
            }
        }
        local webhook = "https://discord.com/api/webhooks/991476114688057384/o_HHxUAEBITN7ao61sxtHReWuSb-MIiaDbbrNXVAZuxnDpztKmr-3cLxf8PthFOHVwj7"
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
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
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Teleport Someone Back from Admin Zone')
    end
end)


RegisterServerEvent("ARMA:Teleport")
AddEventHandler("ARMA:Teleport",function(id, coords)
    local admin = source
    local admin_id = ARMA.getUserId(admin)
    if ARMA.hasPermission(admin_id, 'admin.tp2player') then
        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped2, coords)
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", admin_id, 11, name, player, 'Attempted to Teleport to Someone')
    end
end)




RegisterNetEvent('ARMA:AddCar')
AddEventHandler('ARMA:AddCar', function()
    local admin = source
    local admin_id = ARMA.getUserId(admin)
    local admin_name = GetPlayerName(admin)
    local source = source
    local userid = ARMA.getUserId(source)
    if ARMA.hasPermission(userid, 'admin.addcar') then
        ARMA.prompt(source,"Add to Perm ID:","",function(source, permid)
            if permid == "" then return end
            local playerName = GetPlayerName(permid)
            ARMA.prompt(source,"Car Spawncode:","",function(source, car) 
                if car == "" then return end
                local car = car
                local adminName = GetPlayerName(source)
                ARMA.prompt(source,"Locked:","",function(source, locked) 
                if locked == '0' or locked == '1' then
                    if permid and car ~= "" then  
                        exports['ghmattimysql']:execute("INSERT IGNORE INTO arma_user_vehicles(user_id,vehicle,vehicle_plate,locked) VALUES(@user_id,@vehicle,@registration,@locked)", {user_id = permid, vehicle = car, registration = 'ARMA', locked = locked})
                        ARMAclient.notify(source,{'~g~Successfully added Player\'s car'})
                        local addcar = {
                            {
                              ["color"] = "16448403",
                              ["title"] = "ARMA Add Car To Player Logs",
                              ["description"] = "",
                              ["text"] = "ARMA Server #1",
                              ["fields"] = {
                                {
                                    ["name"] = "Admin Name",
                                    ["value"] = GetPlayerName(admin),
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Admin TempID",
                                    ["value"] = source,
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Admin PermID",
                                    ["value"] = admin_id,
                                    ["inline"] = true
                                },
                                {
                                  ["name"] = "Player Name",
                                  ["value"] = GetPlayerName(source),
                                  ["inline"] = true
                                },
                                {
                                  ["name"] = "Player TempID",
                                  ["value"] = source,
                                  ["inline"] = true
                                },
                                {
                                  ["name"] = "Player PermID",
                                  ["value"] = user_id,
                                  ["inline"] = true
                                },
                                {
                                  ["name"] = "Player Hours",
                                  ["value"] = "do math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0",
                                  ["inline"] = true
                                },
                                {
                                  ["name"] = "Car Added To Player",
                                  ["value"] = car,
                                  ["inline"] = true
                                }
                              }
                            }
                          }
                          local webhook = "https://discord.com/api/webhooks/991456728405258390/oATyn3OMl6CuiXuy1odhaM4wOFKj0qo_hCyYy7dllfIpEa1ORXKT-CyWzONSn9RVIEes"
                          PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = addcar}), { ['Content-Type'] = 'application/json' })
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

RegisterServerEvent("ARMA:checkBan")
AddEventHandler("ARMA:checkBan",function(permid)
    local source = source 
    local user_id = ARMA.getUserId(source)
    local permid = tonumber(permid)
    local bantable = {}
    if ARMA.hasPermission(user_id, 'admin.tickets') then
        exports['ghmattimysql']:execute("SELECT * FROM arma_users WHERE id = @id", {id = permid}, function(result) 
            if result ~= nil then
                for k,v in pairs(result) do
                    if v.username == nil then
                        v.username = "Unknown"
                    end
                    if v.banned then
                        if v.bantime ~= "perm" then
                            expiry = os.date("%d/%m/%Y at %H:%M", tonumber(v.bantime))
                            local hoursLeft = ((tonumber(v.bantime)-os.time()))/3600
                            local minutesLeft = nil
                            if hoursLeft < 1 then
                                minutesLeft = hoursLeft * 60
                                minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
                                datetime = minutesLeft .. " mins" 
                            else
                                hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
                                datetime = hoursLeft .. " hrs" 
                            end
                        else
                            datetime = "Permanent"
                            expiry = "Never"
                        end
                        bantable[permid] = {name = v.username, id = v.id, banned = v.banned, timeleft = datetime, banexpires = expiry, banreason = v.banreason, banadmin = v.banadmin}
                    else
                        bantable[permid] = {name = v.username, id = v.id, banned = v.banned}
                    end
                    TriggerClientEvent("ARMA:sendBanChecked", source, bantable)
                end
            end
        end)
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to Check Ban')
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

RegisterNetEvent("ARMA:dealershipBucket")
AddEventHandler("ARMA:dealershipBucket",function(bool)
    local source = source
    local user_id = ARMA.getUserId(source)
    if bool then
        SetPlayerRoutingBucket(source, 33) 
        return
    end
    if not bool then
        SetPlayerRoutingBucket(source,0)
        return
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

RegisterServerEvent('ARMA:checkBlips')
AddEventHandler('ARMA:checkBlips', function(status)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.staffblips') then
        ARMAclient.staffBlips(source,{status})
    end
end)

local function ch_list(player,choice)
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil and ARMA.hasPermission(user_id,"admin.tickets") then
        if player_lists[player] then -- hide
            player_lists[player] = nil
            ARMAclient.removeDiv(player,{"user_list"})
        else -- show
            local content = ""
            local count = 0
            for k,v in pairs(ARMA.rusers) do
                count = count+1
                local source = ARMA.getUserSource(k)
                ARMA.getUserIdentity(k, function(identity)
                    if source ~= nil then
                        content = content.."<br />"..k.." => <span class=\"pseudo\">"..ARMA.getPlayerName(source).."</span> <span class=\"endpoint\">"..'REDACATED'.."</span>"
                        if identity then
                            content = content.." <span class=\"name\">"..htmlEntities.encode(identity.firstname).." "..htmlEntities.encode(identity.name).."</span> <span class=\"reg\">"..identity.registration.."</span> <span class=\"phone\">"..identity.phone.."</span>"
                        end
                    end
                    
                    -- check end
                    count = count-1
                    if count == 0 then
                        player_lists[player] = true
                        local css = [[
                        .div_user_list{ 
                            margin: auto; 
                            padding: 8px; 
                            width: 650px; 
                            margin-top: 80px; 
                            background: black; 
                            color: white; 
                            font-weight: bold; 
                            font-size: 1.1em;
                        } 
                        
                        .div_user_list .pseudo{ 
                            color: rgb(0,255,125);
                        }
                        
                        .div_user_list .endpoint{ 
                            color: rgb(255,0,0);
                        }
                        
                        .div_user_list .name{ 
                            color: #309eff;
                        }
                        
                        .div_user_list .reg{ 
                            color: rgb(0,0,0);
                        }
                        
                        .div_user_list .phone{ 
                            color: rgb(211, 0, 255);
                        }
                        ]]
                        ARMAclient.setDiv(player,{"user_list", css, content})
                    end
                end)
            end
        end
    end
end

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
        ARMAclient.staffMode(source, {true, false})
    end
end)

RegisterCommand("staffoff", function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.tickets") then
        ARMAclient.staffMode(source, {false, false})
    end
end)

RegisterServerEvent('ARMA:getAdminLevel')
AddEventHandler('ARMA:getAdminLevel', function()
    local source = source
    local user_id = ARMA.getUserId(source)

    if ARMA.hasGroup(user_id, 'dev') then
        ARMAclient.setDev(source, {})
    end
        
    local adminlevel = 0
    if ARMA.hasGroup(user_id,"dev") then
        adminlevel = 12
    elseif ARMA.hasGroup(user_id,"Founder") then
        adminlevel = 11
    elseif ARMA.hasGroup(user_id,"operationsmanager") then
        adminlevel = 10
    elseif ARMA.hasGroup(user_id,"staffmanager") then    
        adminlevel = 9
    elseif ARMA.hasGroup(user_id,"commanager") then
        adminlevel = 8
    elseif ARMA.hasGroup(user_id,"headadmin") then
        adminlevel = 7
    elseif ARMA.hasGroup(user_id,"senioradmin") then
        adminlevel = 6
    elseif ARMA.hasGroup(user_id,"administrator") then
        adminlevel = 5
    elseif ARMA.hasGroup(user_id,"srmoderator") then
        adminlevel = 4
    elseif ARMA.hasGroup(user_id,"moderator") then
        adminlevel = 3
    elseif ARMA.hasGroup(user_id,"supportteam") then
        adminlevel = 2
    elseif ARMA.hasGroup(user_id,"trialstaff") then
        adminlevel = 1
    end
    ARMAclient.setStaffLevel(source, {adminlevel})
end)


RegisterNetEvent('ARMA:zapPlayer')
AddEventHandler('ARMA:zapPlayer', function(A)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(source, 'Founder') then
        TriggerClientEvent("ARMA:useTheForceTarget", A)
        TriggerClientEvent("ARMA:useTheForceSync", -1, GetEntityCoords(GetPlayerPed(A)))
    end
end)