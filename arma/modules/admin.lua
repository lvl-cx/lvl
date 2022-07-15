local htmlEntities = module("lib/htmlEntities")
local Tools = module("lib/Tools")

-- copy this table format with the reasons below @xonaa
punishmentreasons = {
    {
        name = "Cheating",
        desc = "1st Offense: 4380hr\n2nd Offense: Permanent",
        duration = {{'1st Offense: 4380hr','2nd Offense: Permanent'},{4380,9000}},
    },
    {
        name = "1.0 Trolling",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "1.0 Trolling (Minor)",
        desc = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",
        duration = {{'1st Offense: 2hr','2nd Offense: 12hr', '3rd Offense: 24hr'},{2,12,24}},
    },
    {
        name = "1.1 Metagaming",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "1.2 Power Gaming",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "1.3 Fail RP",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "1.4.1 Mass RDM",
        desc = "1st Offense: 4380hr\n2nd Offense: Permanent",
        duration = {{'1st Offense: 4380hr','2nd Offense: Permanent'},{4380,9000}},
    },
    {
        name = "1.5 No Reason to Initiate (NRTI)",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "1.6.1 Mass VDM",
        desc = "1st Offense: 4380hr\n2nd Offense: Permanent",
        duration = {{'1st Offense: 4380hr','2nd Offense: Permanent'},{4380,9000}},
    },
    {
        name = "1.7 Offensive Language/Toxicity (Minor)",
        desc = "1st Offense: 2hr\n2nd Offense: 24hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 2hr','2nd Offense: 24hr', '3rd Offense: 72hr'},{2,24,72}},
    },
    {
        name = "1.7 Offensive Language/Toxicity (Standard)",
        desc = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",
        duration = {{'1st Offense: 48hr','2nd Offense: 72hr', '3rd Offense: 168hr'},{48,72,168}},
    },
    {
        name = "1.7 Offensive Language/Toxicity (Severe)",
        desc = "1st Offense: 4380hr\n2nd Offense: Permanent",
        duration = {{'1st Offense: 4380hr','2nd Offense: Permanent'},{4380,9000}},
    },
    {
        name = "1.8 Breaking Character",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        duration = {{'1st Offense: 12hr','2nd Offense: 24hr', '3rd Offense: 48hr'},{12,24,48}},
    },
    {
        name = "1.9 Combat logging",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "1.10 Combat storing",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "1.11 Exploiting (Standard)",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 168hr'},{24,48,168}},
    },
    {
        name = "1.11 Exploiting (Severe)",
        desc = "1st Offense: 168hr\n2nd Offense: Permanent",
        duration = {{'1st Offense: 168hr','2nd Offense: Permanent'},{4380,9000}},
    },
    {
        name = "1.12 Out of game transactions (OOGT)",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.13 Spite Reports",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 168hr'},{24,48,168}},
    },
    {
        name = "1.14 Scamming",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.15 Loans",
        desc = "1st Offense: 48hr\n2nd Offense: 168hr\n3rd Offense: Permanent",
        duration = {{'1st Offense: 48hr','2nd Offense: 168hr', '3rd Offense: Permanent'},{48,168,9000}},
    },
    {
        name = "1.16 Wasting Admin Time",
        desc = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",
        duration = {{'1st Offense: 2hr','2nd Offense: 12hr', '3rd Offense: 24hr'},{2,12,24}},
    },
    {
        name = "2.1 Value of Life",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "2.2 Sexual RP",
        desc = "1st Offense: 168hr\n2nd Offense: Permanent",
        duration = {{'1st Offense: 168hr','2nd Offense: Permanent'},{168,9000}},
    },
    {
        name = "2.3 Terrorist RP",
        desc = "1st Offense: 168hr\n2nd Offense: Permanent",
        duration = {{'1st Offense: 168hr','2nd Offense: Permanent'},{168,9000}},
    },
    {
        name = "2.4 Impersonation of Whitelisted Factions",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        duration = {{'1st Offense: 12hr','2nd Offense: 24hr', '3rd Offense: 48hr'},{12,24,48}},
    },
    {
        name = "2.5 GTA Online Driving",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "2.6 NLR",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "2.7 Bad RP",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "2.8 Kidnapping (CIV)",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        duration = {{'1st Offense: 12hr','2nd Offense: 24hr', '3rd Offense: 48hr'},{12,24,48}},
    },
    {
        name = "3.0 Theft of Emergency Vehicles",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        duration = {{'1st Offense: 12hr','2nd Offense: 24hr', '3rd Offense: 48hr'},{12,24,48}},
    },
    {
        name = "3.1 Whitelist Abuse",
        desc = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 72hr', '3rd Offense: 168hr'},{24,72,168}},
    },
    {
        name = "3.1 Whitelist Abuse (Severe)",
        desc = "1st Offense: 168hr\n2nd Offense: Permanent",
        duration = {{'1st Offense: 168hr','2nd Offense: Permanent'},{168,9000}},
    },
    {
        name = "3.2 Cop Baiting",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        duration = {{'1st Offense: 12hr','2nd Offense: 24hr', '3rd Offense: 48hr'},{12,24,48}},
    },
    {
        name = "3.3 Kidnapping (PD)",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        duration = {{'1st Offense: 12hr','2nd Offense: 24hr', '3rd Offense: 48hr'},{12,24,48}},
    },
    {
        name = "3.4 Unrealistic Revival",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        duration = {{'1st Offense: 12hr','2nd Offense: 24hr', '3rd Offense: 48hr'},{12,24,48}},
    },
    {
        name = "Interjection of Robberies",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "Interjection of RP",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "3.5 Combat Reviving",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        duration = {{'1st Offense: 12hr','2nd Offense: 24hr', '3rd Offense: 48hr'},{12,24,48}},
    },
    {
        name = "3.6 Gang Cap",
        desc = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 72hr', '3rd Offense: 168hr'},{24,72,168}},
    },
    {
        name = "3.7 Max Gang Numbers",
        desc = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 72hr', '3rd Offense: 168hr'},{24,72,168}},
    },
    {
        name = "3.8 Gang Alliance",
        desc = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 72hr', '3rd Offense: 168hr'},{24,72,168}},
    },
    {
        name = "3.10 Impersonation of Gangs",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        duration = {{'1st Offense: 12hr','2nd Offense: 24hr', '3rd Offense: 48hr'},{12,24,48}},
    },
    {
        name = "4.1 Stealing Vehicles in Greenzone",
        desc = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",
        duration = {{'1st Offense: 2hr','2nd Offense: 12hr', '3rd Offense: 24hr'},{2,12,24}},
    },
    {
        name = "4.2 Selling Illegal Items in Greenzone",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        duration = {{'1st Offense: 12hr','2nd Offense: 24hr', '3rd Offense: 48hr'},{12,24,48}},
    },
    {
        name = "4.3 Greenzone Retreating",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "4.5 Taking Hostage into Redzone",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        duration = {{'1st Offense: 24hr','2nd Offense: 48hr', '3rd Offense: 72hr'},{24,48,72}},
    },
    {
        name = "1.1 Advertising",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.2 Bullying",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.3 Impersonation",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.4 Language",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.5 Discrimination",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.5 Discrimination",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.6 Malicious Attacks",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.7 PII (Personally Identifiable Information)(Standard)",
        desc = "1st Offense: 168hr\n2nd Offense: Permanent",
        duration = {{'1st Offense: 168hr','2nd Offense: Permanent'},{168,9000}},
    },
    {
        name = "1.7 PII (Personally Identifiable Information)(Severe)",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.8 Chargeback",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.9 Staff Discretion",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.10 Cheating",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.11 Ban Evading",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.12 Withholding/Storing FiveM Cheats",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.13 Multi-Accounting",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.14 Association with External Modifications",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.15 Failure to provide POV",
        desc = "1st Offense: 2hr\n2nd Offense: Permanent",
        duration = {{'1st Offense: 2hr','2nd Offense: Permanent'},{2,9000}},
    },
    {
        name = "1.16 Withholding Information From Staff (Standard)",
        desc = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",
        duration = {{'1st Offense: 48hr','2nd Offense: 72hr', '3rd Offense: 168hr'},{48,72,168}},
    },
    {
        name = "1.16 Withholding Information From Staff (Severe)",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    {
        name = "1.17 Blackmailing",
        desc = "1st Offense: Permanent",
        duration = {{'1st Offense: Permanent'},{9000}},
    },
    
}


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



RegisterNetEvent("Jud:GetNearbyPlayers")
AddEventHandler("Jud:GetNearbyPlayers", function(dist)
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
            TriggerClientEvent("Jud:ReturnNearbyPlayers", source, plrTable)
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
  
    if ARMA.hasPermission(user_id, "admin.menu") then
        if ARMA.hasPermission(userperm, 'pov.list') then
            TriggerClientEvent('ARMA:ReturnPov', source, true)
        elseif not ARMA.hasPermission(userperm, 'pov.list') then
            TriggerClientEvent('ARMA:ReturnPov', source, false)
        end
    else 
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

local onesync = GetConvar('onesync', nil)
RegisterNetEvent('ARMA:SpectatePlayer')
AddEventHandler('ARMA:SpectatePlayer', function(id)
    local source = source 
    local SelectedPlrSource = ARMA.getUserSource(id) 
    local userid = ARMA.getUserId(source)
    if ARMA.hasPermission(userid, "admin.spectate") then
        if SelectedPlrSource then  
            if onesync ~= "off" then 
                local ped = GetPlayerPed(SelectedPlrSource)
                local pedCoords = GetEntityCoords(ped)
                TriggerClientEvent('ARMA:Spectate', source, SelectedPlrSource, pedCoords)
            else 
                TriggerClientEvent('ARMA:Spectate', source, SelectedPlrSource)
            end
        else 
            ARMAclient.notify(source,{"~r~This player may have left the game."})
        end
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
                  ["value"] = "0 hours",
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
                          ["value"] = "0 hours",
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
    local player_name = GetPlayerName(player_temp)
    local table = {
        'Commissioner Clocked',
        'Deputy Commissioner Clocked',
        'Assistant Commissioner Clocked',
        'Deputy Assistant Commissioner Clocked',
        'Commander Clocked',
        'Chief Superintendent Clocked',
        'Superintendent Clocked',
        'Chief Inspector Clocked',
        'Inspector Clocked',
        'Sergeant Clocked',
        'Special Police Constable Clocked',
        'Senior Police Constable Clocked',
        'Police Constable Clocked',
        'PCSO Clocked',
        'Head Chief Medical Officer Clocked',
        'Assistant Chief Medical Officer Clocked',
        'Deputy Chief Medical Officer Clocked',
        'Captain Clocked',
        'Consultant Clocked',
        'Specialist Clocked',
        'Senior Doctor Clocked',
        'Junior Doctor Clocked',
        'Critical Care Paramedic Clocked',
        'Paramedic Clocked',
        'Trainee Paramedic Clocked',
        'Head Chief Medical Officer',
        'Assistant Chief Medical Officer',
        'Deputy Chief Medical Officer',
        'Captain',
        'Consultant',
        'Specialist',
        'Senior Doctor',
        'Junior Doctor',
        'Critical Care Paramedic',
        'Paramedic',
        'Trainee Paramedic'
    }
    if ARMA.hasPermission(user_id,"admin.tp2waypoint") then
        for k,v in pairs(table) do
            ARMA.removeUserGroup(player_perm, v)
            ARMAclient.notify(source,{'~g~User clocked off'})
            ARMAclient.notify(player_perm,{'~r~You have been force clocked off'})
        end
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
        if selgroup == "founder" and not ARMA.hasPermission(admin_perm, "group.add.founder") then
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
                            ["value"] = "0 hours",
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
        if selgroup == "founder" and not ARMA.hasPermission(user_id, "group.remove.founder") then
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
                            ["value"] = "0 hours",
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
                            ["value"] = "0 hours",
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


RegisterServerEvent('ARMA:CreateBanData')
AddEventHandler('ARMA:CreateBanData', function(admin, target)
    local source = source
    local user_id = ARMA.getUserId(source)
    local targetsource = ARMA.getUserSource(target)
    local name = GetPlayerName(targetsource)
    if ARMA.hasPermission(user_id, "admin.ban") then
        TriggerClientEvent('ARMA:openConfirmBan', source, target, name)
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", user_id, reason, name, player, 'Attempted to Create Ban Data')
    end
end)

RegisterServerEvent('ARMA:BanPlayerConfirm')
AddEventHandler('ARMA:BanPlayerConfirm', function(admin, target_id, targetname, reasons, duration)
    local source = source
    local user_id = ARMA.getUserId(source)
    local target = ARMA.getUserSource(target_id)
    local admin_id = ARMA.getUserId(admin)
    local adminName = GetPlayerName(source)
    local playerName = targetname
    warningDate = getCurrentDate()
    if ARMA.hasPermission(user_id, "admin.ban") then
        if tonumber(duration) >= 9000 then
            local webhook = "webhook"
            PerformHttpRequest(webhook, function(err, text, headers) 
            end, "POST", json.encode({username = "ARMA", embeds = {
                {
                    ["color"] = 16777215,
                    ["title"] = "User Permanently Banned",
                    ["description"] = "> Players Name: **"..playerName.."**\n> Players Perm ID: **"..target_id.."**\n> Admin's Perm ID: **"..admin_id.."**\n> Reason(s): **"..reasons.."**\n> Duration: **Permanent**",
                    ["footer"] = {
                        ["text"] = "ARMA - "..os.date("%c"),
                        ["icon_url"] = "",
                    }
            }
            }}), { ["Content-Type"] = "application/json" })
            ARMA.ban(source,target_id,"perm",reasons)
            saveBanLog(target_id, adminName, reasons, "-1")
        else
            local webhook = "webhook"
            PerformHttpRequest(webhook, function(err, text, headers) 
            end, "POST", json.encode({username = "ARMA", embeds = {
                {
                    ["color"] = 16777215,
                    ["title"] = "User Banned",
                    ["description"] = "> Players Name: **"..playerName.."**\n> Players Perm ID: **"..target_id.."**\n> Admin's Perm ID: **"..admin_id.."**\n> Reason(s): **"..reasons.."**\n> Duration: **"..duration.."**",
                    ["footer"] = {
                        ["text"] = "ARMA - "..os.date("%c"),
                        ["icon_url"] = "",
                    }
            }
            }}), { ["Content-Type"] = "application/json" })
            ARMA.ban(source,target_id,duration,reasons)
            f10Ban(target_id, adminName, reasons, duration)
        end
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to Ban Someone')
    end
end)
RegisterServerEvent('ARMA:offlineban')
AddEventHandler('ARMA:offlineban', function(admin)
    local source = source
    local user_id = ARMA.getUserId(source)
    local admin_id = ARMA.getUserId(admin)
    local adminName = GetPlayerName(admin)
    warningDate = getCurrentDate()
    if ARMA.hasPermission(user_id, "admin.ban") then
        ARMA.prompt(source,"Perm ID:","",function(source,permid)
            if permid == "" then return end
            permid = parseInt(permid)
            ARMA.prompt(source,"Duration:","",function(source,Duration) 
                if Duration == "" then return end
                Duration = parseInt(Duration)
                ARMA.prompt(source,"Reason:","",function(source,Reason) 
                    if Reason == "" then return end
                    ARMA.prompt(source,"Evidence:","",function(source,Evidence) 
                        if Evidence == "" then return end
                        videoclip = Evidence
                        local target = permid
                        local target_id = ARMA.getUserSource(target)
                        local command = {
                            {
                                ["color"] = "16448403",
                                ["title"] = "ARMA Offline Ban Logs",
                                ["description"] = "",
                                ["text"] = "ARMA Server #1",
                                ["fields"] = {
                                    {
                                        ["name"] = "Admin Name",
                                        ["value"] = adminName,
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
                                        ["value"] = GetPlayerName(target_id),
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
                                        ["value"] = "0 hours",
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Ban Reason(s)",
                                        ["value"] = Reason,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Ban Duration",
                                        ["value"] = Duration.." hours",
                                        ["inline"] = true
                                    }
                                }
                            }
                        }
                        local webhook = "https://discord.com/api/webhooks/991476652821454858/DyObLKDN6_KVAwUuh-V4NOprPijM-0xEyIgnmJF1C8MUdIwqaMea_H1vIYPsGWcSX4M_"
                        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
                        TriggerClientEvent('ARMA:NotifyPlayer', admin, 'You have offline banned '..permid..' for '..Reason)
                        if tonumber(Duration) == -1 then
                            ARMA.ban(source,target,"perm",Reason)
                            f10Ban(target, adminName, Reason, "-1")
                        else
                            ARMA.ban(source,target,Duration,Reason)
                            f10Ban(target, adminName, Reason, Duration)
                        end
                    end)
                end)
            end)
        end)
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", user_id, reason, name, player, 'Attempted to Ban Someone')
    end
end)


RegisterServerEvent('ARMA:RequestScreenshot')
AddEventHandler('ARMA:RequestScreenshot', function(admin,target)
    local target_id = ARMA.getUserId(target)
    local target_name = GetPlayerName(target)
    local admin_id = ARMA.getUserId(admin)
    local admin_name = GetPlayerName(source)
    if ARMA.hasPermission(admin_id, 'admin.screenshot') then
        exports["discord-screenshot"]:requestClientScreenshotUploadToDiscord(target,
        {
        username = "ARMA Screenshot Logs",
        avatar_url = "",
        embeds = {
            {
                color = 11111111,
                title = admin_name.."["..admin_id.."] Took a screenshot",
                description = "**Admin Name:** " ..admin_name.. "\n**Admin ID:** " ..admin_id.. "\n**Player Name:** " ..target_name.. "\n**Player ID:** " ..target_id,
                footer = {
                    text = ""..os.date("%x %X %p"),
                }
            }
        }
        },
        30000,
        function(error)
            if error then
                return print("^1ERROR: " .. error)
            end
            print("Sent screenshot successfully")
            TriggerClientEvent('ARMA:NotifyPlayer', admin, 'Successfully took a screenshot of ' ..target_name.. "'s screen.")
        end)
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", admin_id, reason, name, player, 'Attempted to Request Screenshot')
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
                                ["value"] = "0 hours",
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
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", admin_id, reason, name, player, 'Attempted to No F10 Kick Someone')
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
                            ["value"] = "0 hours",
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
            TriggerClientEvent('ARMA:NotifyPlayer', admin, 'Kicked Player')
        end)
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", admin_id, reason, name, player, 'Attempted to Kick Someone')
    end
end)

RegisterServerEvent('ARMA:RemoveWarning')
AddEventHandler('ARMA:RemoveWarning', function(admin, warningid)
    local admin_id = ARMA.getUserId(admin)
    if ARMA.hasPermission(admin_id, 'admin.removewarn') then     
        ARMA.prompt(source,"Warning ID:","",function(source,warningid) 
            if warningid == "" then return end
            exports['ghmattimysql']:execute("DELETE FROM arma_warnings WHERE warning_id = @uid", {uid = warningid})
            TriggerClientEvent('ARMA:NotifyPlayer', admin, 'Removed warning #'..warningid..'')
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
        end)
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", admin_id, reason, name, player, 'Attempted to Remove Warning')
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
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", admin_id, reason, name, player, 'Attempted to Unban Someone')
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
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", admin_id, reason, name, player, 'Attempted to Get Notes')
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
            TriggerClientEvent('ARMA:NotifyPlayer', source, '~g~You have added a note to '..playerName..'('..playerperm..') with the reason '..text)
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
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", admin_id, reason, name, player, 'Attempted to Add Note')
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
            TriggerClientEvent('ARMA:NotifyPlayer', admin, '~g~You have removed note #'..noteid..' from '..playerName..'('..playerperm..')')
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
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", admin_id, reason, name, player, 'Attempted to Remove Note')
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
        TriggerClientEvent('ARMA:NotifyPlayer', admin, 'Slapped Player')
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", admin_id, reason, name, player, 'Attempted to Slap Someone')
    end
end)

RegisterServerEvent('ARMA:RevivePlayer')
AddEventHandler('ARMA:RevivePlayer', function(admin, target)
    local admin_id = ARMA.getUserId(admin)
    local player_id = ARMA.getUserId(target)
    if ARMA.hasPermission(admin_id, "admin.revive") then
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
        TriggerClientEvent('ARMA:FixClient',target)
        TriggerClientEvent('ARMA:NotifyPlayer', admin, 'Revived Player')
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", admin_id, reason, name, player, 'Attempted to Revive Someone')
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
            TriggerClientEvent('ARMA:NotifyPlayer', admin, 'Froze Player.')
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
            TriggerClientEvent('ARMA:NotifyPlayer', admin, 'Unfroze Player.')
            ARMAclient.notify(newtarget, {'~g~You have been unfrozen.'})
            frozenplayers[user_id] = nil
        end
        TriggerClientEvent('ARMA:Freeze', newtarget, isFrozen)
    else
        local player = ARMA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", admin_id, reason, name, player, 'Attempted to Freeze Someone')
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
                        ["value"] = user_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player Name",
                        ["value"] = GetPlayerName(ARMA.getUserSource(player_id)),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player TempID",
                        ["value"] = ARMA.getUserSource(player_id),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player PermID",
                        ["value"] = player_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player Hours",
                        ["value"] = "0 hours",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Teleport Type",
                        ["value"] = "Teleport to Player",
                        ["inline"] = true
                    }
                }
            }
        }
        local webhook = "https://discord.com/api/webhooks/991476057393872966/TQBcjsriIZJIxdd4BCzC5mbL4uAfW7UKxA1sYJ8iWaFBQxymAtpxWpYmV1M_MsT4CwFn"
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent('ARMA:Teleport', source, coords)
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", user_id, reason, name, player, 'Attempted to Teleport TO Someone')
    end
end)


RegisterNetEvent('ARMA:BringPlayer')
AddEventHandler('ARMA:BringPlayer', function(id)
    local source = source 
    local SelectedPlrSource = ARMA.getUserSource(id) 
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.summon') then
        if SelectedPlrSource then  
            if onesync ~= "off" then 
                local ped = GetPlayerPed(source)
                local otherPlr = GetPlayerPed(SelectedPlrSource)
                local otherPlrC = GetEntityCoords(otherPlr)
                local pedCoords = GetEntityCoords(ped)
                local playerOtherName = GetPlayerName(SelectedPlrSource)

                local player_id = ARMA.getUserId(SelectedPlrSource)
                local playerName = GetPlayerName(source)
                
                SetEntityCoords(otherPlr, pedCoords)
                local otherPlrCN = GetEntityCoords(otherPlr)
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
                                ["value"] = user_id,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player Name",
                                ["value"] = GetPlayerName(ARMA.getUserSource(id)),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player TempID",
                                ["value"] = ARMA.getUserSource(id),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player PermID",
                                ["value"] = id,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player Hours",
                                ["value"] = "0 hours",
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Teleport Type",
                                ["value"] = "Teleport to me",
                                ["inline"] = true
                            }
                        }
                    }
                }
                local webhook = "https://discord.com/api/webhooks/991476085248237659/YByx_T6sIDT2OUrNS9ZrHnsQ84tkqyxhClp6f-Dni3zi4U--lIuTssKLibN9L59XdlXh"
                PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
            else 
                TriggerClientEvent('ARMA:BringPlayer', SelectedPlrSource, false, id)  
            end
        else 
            ARMAclient.notify(source,{"~r~This player may have left the game."})
        end
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", user_id, reason, name, player, 'Attempted to Teleport Someone to Them')
    end
end)

playersSpectating = {}
playersToSpectate = {}

RegisterNetEvent('ARMA:GetCoords')
AddEventHandler('ARMA:GetCoords', function()
    local source = source 
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "dev.getcoords") then
        ARMAclient.getPosition(source,{},function(x,y,z)
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
                                ["value"] = "0 hours",
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
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", user_id, reason, name, player, 'Attempted to Get Coords')
    end
end)

RegisterServerEvent('ARMA:Tp2Coords')
AddEventHandler('ARMA:Tp2Coords', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "dev.tp2coords") then
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
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", user_id, reason, name, player, 'Attempted to Teleport to Coords')
    end
end)

RegisterServerEvent('ARMA:GiveMoneyMenu')
AddEventHandler('ARMA:GiveMoneyMenu', function()
    local admin = source
    local admin_id = ARMA.getUserId(admin)
    local admin_name = GetPlayerName(admin)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "dev.givemoney") then
        ARMA.prompt(source,"Perm ID:","",function(source,playerid) 
            if playerid == '' then return end
            if playerid ~= nil then
                ARMA.prompt(source,"Amount:","",function(source,amount) 
                    if amount == '' then return end
                    amount = parseInt(amount)
                    local player_source = ARMA.getUserSource(playerid)
                    if player_source == nil then return end
                    ARMA.giveBankMoney(tonumber(playerid), amount)
                    ARMAclient.notify(source, {"~g~You have gave ID: "..playerid.." ~y~£"..amount.." ~g~"})
                    local givemoney = {
                        {
                            ["color"] = "16448403",
                            ["title"] = "ARMA Give Money Logs",
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
                                    ["value"] = GetPlayerName(player_source),
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
                                    ["value"] = "0 hours",
                                    ["inline"] = true
                                },
                                {
                                    ["name"] = "Amount Given",
                                    ["value"] = amount,
                                    ["inline"] = true
                                }
                            }
                        }
                    }
                    local webhook = "https://discord.com/api/webhooks/991456757740212336/ACWBj05Gz2nU8Nb8znkJphEn7xVLu2OjExlvfR7gaeait2gElyKxQzbkPAWWQZ_Ynhu9"
                    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = givemoney}), { ['Content-Type'] = 'application/json' })
                end)
            end
        end)
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", user_id, reason, name, player, 'Give Money Menu')
    end
end)

RegisterServerEvent('ARMA:GiveCratesMenu')
AddEventHandler('ARMA:GiveCratesMenu', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "dev.givemoney") then
        ARMA.prompt(source,"Perm ID:","",function(source,playerid) 
            if playerid == '' then return end
            if playerid ~= nil then
                ARMA.prompt(source,"Amount:","",function(source,amount) 
                    if amount == '' then return end
                    amount = parseInt(amount)
                    ARMAclient.notify(source, {"~g~You have given ID: "..playerid.." ~y~"..amount.." ~g~crates."})
                    exports['ghmattimysql']:execute("SELECT * FROM `user_crates` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                        if result ~= nil then 
                            for k,v in pairs(result) do
                                if v.user_id == user_id then
                                    crates = v.crates+amount
                                    exports['ghmattimysql']:execute("UPDATE user_crates SET crates = @crates WHERE user_id = @user_id", {user_id = user_id, crates = crates}, function() end)
                                end
                            end
                        end
                    end)
                    webhook = "https://discord.com/api/webhooks/991456793379221564/7lJUj2h_apXDdiKB43_go8bLj6TnaaAyrbgwH1R9REpScBesVsnMtaA2x-rVm8USB2hH"
                    PerformHttpRequest(webhook, function(err, text, headers) 
                    end, "POST", json.encode({username = "ARMA", embeds = {
                        {
                            ["color"] = "16448403",
                            ["title"] = "Crate Logs",
                            ["description"] = "**Admin ID: **"..user_id.."\n**Player ID:**"..playerid.."\n**Amount: **"..amount,
                            ["footer"] = {
                                ["text"] = "Time - "..os.date("%x %X %p"),
                            }
                    }
                }}), { ["Content-Type"] = "application/json" })
                end)
            end
        end)
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", user_id, reason, name, player, 'Give Money Menu')
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
                        ["value"] = "0 hours",
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
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", admin_id, reason, name, player, 'Attempted to Teleport Someone to Admin Island')
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
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", admin_id, reason, name, player, 'Attempted to Teleport Someone Back from Admin Zone')
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
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", admin_id, reason, name, player, 'Attempted to Teleport to Someone')
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
                                  ["value"] = "0 hours",
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
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", user_id, reason, name, player, 'Attempted to Add Car')
    end
end)

RegisterNetEvent('ARMA:CleanAll')
AddEventHandler('ARMA:CleanAll', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.menu') then
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
    else 
        ARMAclient.notify(source,{"~r~You cannot perform this action."})
    end
end)

RegisterNetEvent('ARMA:noClip')
AddEventHandler('ARMA:noClip', function()
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.noclip') then 
        ARMAclient.toggleNoclip(source,{})
    end
end)

RegisterNetEvent("ARMA:checkBlips")
AddEventHandler("ARMA:checkBlips",function(status)
    local source = source
    if ARMA.hasPermission(user_id, 'group.add') then 
        TriggerClientEvent('ARMA:showBlips', source)
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

local function ch_list(player,choice)
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil and ARMA.hasPermission(user_id,"admin.menu") then
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
        TriggerClientEvent("ARMA:getPlayersInfo", source, players_table, punishmentreasons)
    end
end)


RegisterCommand("staffon", function(source)
    local user_id = ARMA.getUserId(source)
    local user_source = ARMA.getUserSource(user_id)
    if ARMA.hasPermission(user_id, "admin.tickets") then
        ARMAclient.staffMode(user_source, {true, false})
    end
end)

RegisterCommand("staffoff", function(source)
    local user_id = ARMA.getUserId(source)
    local user_source = ARMA.getUserSource(user_id)
    if ARMA.hasPermission(user_id, "admin.tickets") then
        ARMAclient.staffMode(user_source, {false, false})
    end
end)

RegisterServerEvent('ARMA:getAdminLevel')
AddEventHandler('ARMA:getAdminLevel', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local adminlevel = 0
    if ARMA.hasGroup(user_id,"dev") then
        adminlevel = 12
    elseif ARMA.hasGroup(user_id,"founder") then
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