local killlogs = 'webhook here'
local damagelogs = 'webhook here'

local f = module("cfg/weapons")
f=f.weapons

local function getWeaponName(weapon)
    for k,v in pairs(f) do
        if v.name == weapon then
            if v.class == 'AR' then
                return 'Assault-Rifle'
            elseif v.class == 'Heavy' then
                return 'Sniper'
            else
                return v.class
            end
        end
    end
    return "Unknown"
end

RegisterNetEvent('ARMA:onPlayerKilled')
AddEventHandler('ARMA:onPlayerKilled', function(killtype, killer, weaponhash, suicide, distance)
    local source = source
    local killergroup = 'none'
    local killedgroup = 'none'
    if distance ~= nil then
        distance = math.floor(distance) 
    end
    if killtype == 'killed' then
        if ARMA.hasPermission(ARMA.getUserId(source), 'police.onduty.permission') then
            killedgroup = 'police'
        elseif ARMA.hasPermission(ARMA.getUserId(source), 'nhs.onduty.permission') then
            killedgroup = 'nhs'
        end
        if ARMA.hasPermission(ARMA.getUserId(killer), 'police.onduty.permission') then
            killergroup = 'police'
        elseif ARMA.hasPermission(ARMA.getUserId(killer), 'nhs.onduty.permission') then
            killergroup = 'nhs'
        end
        if killer ~= nil then
            weaponhash = getWeaponName(weaponhash)
            TriggerClientEvent('ARMA:newKillFeed', -1, GetPlayerName(killer), GetPlayerName(source), weaponhash, suicide, distance, killedgroup, killergroup)
            TriggerEvent('ARMA:checkOrganHeistKill', source, killer)
            local embed = {
                {
                  ["color"] = "16448403",
                  ["title"] = "Kill Logs",
                  ["description"] = "",
                  ["text"] = "ARMA Server #1",
                  ["fields"] = {
                    {
                        ["name"] = "Killer Name",
                        ["value"] = GetPlayerName(killer),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Victim Name",
                        ["value"] = GetPlayerName(source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Weapon Used",
                        ["value"] = weaponhash,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Distance",
                        ["value"] = distance..'m',
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Killer Group",
                        ["value"] = killergroup,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Victim Group",
                        ["value"] = killedgroup,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Kill Type",
                        ["value"] = killtype,
                        ["inline"] = true
                    },
                  }
                }
              }
              PerformHttpRequest(killlogs, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = embed}), { ['Content-Type'] = 'application/json' })
        else
            TriggerEvent('ARMA:checkOrganHeistKill', source)
            TriggerClientEvent('ARMA:newKillFeed', -1, GetPlayerName(source), GetPlayerName(source), 'suicide', suicide, distance, killedgroup, killergroup)
        end
    elseif killtype == 'finished off' and killer ~= nil then
        weaponhash = getWeaponName(weaponhash)
        local embed = {
            {
              ["color"] = "16448403",
              ["title"] = "Finished Off Logs",
              ["description"] = "",
              ["text"] = "ARMA Server #1",
              ["fields"] = {
                {
                    ["name"] = "Killer Name",
                    ["value"] = GetPlayerName(killer),
                    ["inline"] = true
                },
                {
                    ["name"] = "Victim Name",
                    ["value"] = GetPlayerName(source),
                    ["inline"] = true
                },
                {
                    ["name"] = "Weapon Used",
                    ["value"] = weaponhash,
                    ["inline"] = true
                },
                {
                    ["name"] = "Distance",
                    ["value"] = distance..'m',
                    ["inline"] = true
                },
                {
                    ["name"] = "Killer Group",
                    ["value"] = killergroup,
                    ["inline"] = true
                },
                {
                    ["name"] = "Victim Group",
                    ["value"] = killedgroup,
                    ["inline"] = true
                },
                {
                    ["name"] = "Kill Type",
                    ["value"] = killtype,
                    ["inline"] = true
                },
              }
            }
          }
          PerformHttpRequest(killlogs, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = embed}), { ['Content-Type'] = 'application/json' })
    end
    TriggerClientEvent('ARMA:deathSound', -1, GetEntityCoords(GetPlayerPed(source)))
end)

AddEventHandler('weaponDamageEvent', function(sender, ev)
	if ev.weaponDamage ~= 0 then
        local embed = {
            {
              ["color"] = "16448403",
              ["title"] = "Damage Logs",
              ["description"] = "",
              ["text"] = "ARMA Server #1",
              ["fields"] = {
                {
                    ["name"] = "Player Name",
                    ["value"] = GetPlayerName(sender),
                    ["inline"] = true
                },
                {
                    ["name"] = "Player Temp ID",
                    ["value"] = sender,
                    ["inline"] = true
                },
                {
                    ["name"] = "Player Perm ID",
                    ["value"] = ARMA.getUserId(sender),
                    ["inline"] = true
                },
                {
                    ["name"] = "Damage",
                    ["value"] = ev.weaponDamage,
                    ["inline"] = true
                },
                {
                    ["name"] = "Weapon Hash",
                    ["value"] = ev.weaponType,
                    ["inline"] = true
                },
              }
            }
          }        
        PerformHttpRequest(damagelogs, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = embed}), { ['Content-Type'] = 'application/json' })
	end
end)
