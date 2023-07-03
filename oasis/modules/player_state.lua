local cfg = module("cfg/player_state")
local a = module("oasis-weapons", "cfg/weapons")
local lang = OASIS.lang

baseplayers = {}

AddEventHandler("OASIS:playerSpawn", function(user_id, source, first_spawn)
    Debug.pbegin("playerSpawned_player_state")
    local player = source
    tOASIS.getFactionGroups(source)
    local data = OASIS.getUserDataTable(user_id)
    local tmpdata = OASIS.getUserTmpTable(user_id)
    local playername = GetPlayerName(player)
    if first_spawn then -- first spawn
        if data.customization == nil then
            data.customization = cfg.default_customization
        end
        if data.invcap == nil then
            data.invcap = 30
        end
        tOASIS.getSubscriptions(user_id, function(cb, plushours, plathours)
            if cb then
                if plathours > 0 and data.invcap < 50 then
                    data.invcap = 50
                elseif plushours > 0 and data.invcap < 40 then
                    data.invcap = 40
                else
                    data.invcap = 30
                end
            end
        end)  
        if data.position == nil and cfg.spawn_enabled then
            local x = cfg.spawn_position[1] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local y = cfg.spawn_position[2] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local z = cfg.spawn_position[3] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            data.position = {
                x = x,
                y = y,
                z = z
            }
        end
        if data.customization ~= nil then
            OASISclient.spawnAnim(source, {data.position})
            if data.weapons ~= nil then
                OASISclient.giveWeapons(source, {data.weapons, true})
            end
            OASISclient.setUserID(source, {user_id})

            if OASIS.hasGroup(user_id, 'Founder') or OASIS.hasGroup(user_id, 'Developer') then
                OASISclient.setDev(source, {})
            end
            if OASIS.hasPermission(user_id, 'cardev.menu') then
                TriggerClientEvent('OASIS:setCarDev', source)
            end
            if OASIS.hasPermission(user_id, 'police.onduty.permission') then
                OASISclient.setPolice(source, {true})
                TriggerClientEvent('OASISUI5:globalOnPoliceDuty', source, true)
            end
            if OASIS.hasPermission(user_id, 'nhs.onduty.permission') then
                OASISclient.setNHS(source, {true})
                TriggerClientEvent('OASISUI5:globalOnNHSDuty', source, true)
            end
            if OASIS.hasPermission(user_id, 'prisonguard.onduty.permission') then
                OASISclient.setHMP(source, {true})
                TriggerClientEvent('OASISUI5:globalOnPrisonDuty', source, true)
            end
            if OASIS.hasGroup(user_id, 'Taco Seller') then
                TriggerClientEvent('OASIS:toggleTacoJob', source, true)
            end
            if OASIS.hasGroup(user_id, 'Police Horse Trained') then
                OASISclient.setglobalHorseTrained(source, {})
            end
                
            local adminlevel = 0
            if OASIS.hasGroup(user_id,"Founder") then
                adminlevel = 12
            elseif OASIS.hasGroup(user_id,"Developer") then
                adminlevel = 11
            elseif OASIS.hasGroup(user_id,"Community Manager") then
                adminlevel = 9
            elseif OASIS.hasGroup(user_id,"Staff Manager") then    
                adminlevel = 8
            elseif OASIS.hasGroup(user_id,"Head Admin") then
                adminlevel = 7
            elseif OASIS.hasGroup(user_id,"Senior Admin") then
                adminlevel = 6
            elseif OASIS.hasGroup(user_id,"Admin") then
                adminlevel = 5
            elseif OASIS.hasGroup(user_id,"Senior Mod") then
                adminlevel = 4
            elseif OASIS.hasGroup(user_id,"Moderator") then
                adminlevel = 3
            elseif OASIS.hasGroup(user_id,"Support Team") then
                adminlevel = 2
            elseif OASIS.hasGroup(user_id,"Trial Staff") then
                adminlevel = 1
            end
            OASISclient.setStaffLevel(source, {adminlevel})

            TriggerClientEvent('OASIS:sendGarageSettings', source)
            players = OASIS.getUsers({})
            for k,v in pairs(players) do
                baseplayers[v] = OASIS.getUserId(v)
            end
            OASISclient.setBasePlayers(source, {baseplayers})
        else
            if data.weapons ~= nil then -- load saved weapons
                OASISclient.giveWeapons(source, {data.weapons, true})
            end

            if data.health ~= nil then
                OASISclient.setHealth(source, {data.health})
            end
        end

    else -- not first spawn (player died), don't load weapons, empty wallet, empty inventory
        OASIS.clearInventory(user_id) 
        OASIS.setMoney(user_id, 0)
        OASISclient.setHandcuffed(player, {false})

        if cfg.spawn_enabled then -- respawn (CREATED SPAWN_DEATH)
            local x = cfg.spawn_death[1] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local y = cfg.spawn_death[2] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local z = cfg.spawn_death[3] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            data.position = {
                x = x,
                y = y,
                z = z
            }
            OASISclient.teleport(source, {x, y, z})
        end
    end
    Debug.pend()
end)

function tOASIS.updateWeapons(weapons)
    local user_id = OASIS.getUserId(source)
    if user_id ~= nil then
        local data = OASIS.getUserDataTable(user_id)
        if data ~= nil then
            data.weapons = weapons
        end
    end
end

function tOASIS.UpdatePlayTime()
    local user_id = OASIS.getUserId(source)
    if user_id ~= nil then
        local data = OASIS.getUserDataTable(user_id)
        if data ~= nil then
            if data.PlayerTime ~= nil then
                data.PlayerTime = tonumber(data.PlayerTime) + 1
            else
                data.PlayerTime = 1
            end
        end
        if OASIS.hasPermission(user_id, 'police.onduty.permission') then
            local lastClockedRank = string.gsub(getGroupInGroups(user_id, 'Police'), ' Clocked', '')
            exports['ghmattimysql']:execute("INSERT INTO oasis_police_hours (user_id, username, weekly_hours, total_hours, last_clocked_rank, last_clocked_date, total_players_fined, total_players_jailed) VALUES (@user_id, @username, @weekly_hours, @total_hours, @last_clocked_rank, @last_clocked_date, @total_players_fined, @total_players_jailed) ON DUPLICATE KEY UPDATE weekly_hours = weekly_hours + 1/60, total_hours = total_hours + 1/60, username = @username, last_clocked_rank = @last_clocked_rank, last_clocked_date = @last_clocked_date, total_players_fined = @total_players_fined, total_players_jailed = @total_players_jailed", {user_id = user_id, username = GetPlayerName(source), weekly_hours = 1/60, total_hours = 1/60, last_clocked_rank = lastClockedRank, last_clocked_date = os.date("%d/%m/%Y"), total_players_fined = 0, total_players_jailed = 0})
        end
    end
end

function OASIS.updateInvCap(user_id, invcap)
    if user_id ~= nil then
        local data = OASIS.getUserDataTable(user_id)
        if data ~= nil then
            if data.invcap ~= nil then
                data.invcap = invcap
            else
                data.invcap = 30
            end
        end
    end
end

function tOASIS.setBucket(source, bucket)
    local source = source
    local user_id = OASIS.getUserId(source)
    SetPlayerRoutingBucket(source, bucket)
    TriggerClientEvent('OASIS:setBucket', source, bucket)
end

local isStoring = {}
AddEventHandler('OASIS:StoreWeaponsRequest', function(source)
    local player = source 
    local user_id = OASIS.getUserId(player)
	OASISclient.getWeapons(player,{},function(weapons)
        if not isStoring[player] then
            isStoring[player] = true
            OASISclient.giveWeapons(player,{{},true}, function(removedwep)
                for k,v in pairs(weapons) do
                    if k ~= 'GADGET_PARACHUTE' and k ~= 'WEAPON_STAFFGUN' and k~= 'WEAPON_SMOKEGRENADE' and k~= 'WEAPON_FLASHBANG' then
                        if v.ammo > 0 and k ~= 'WEAPON_STUNGUN' then
                            for i,c in pairs(a.weapons) do
                                if i == k then
                                    OASIS.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                                end   
                            end
                        end
                    end
                end
                OASISclient.notify(player,{"~g~Weapons Stored"})
                SetTimeout(3000,function()
                      isStoring[player] = nil 
                end)
            end)
        else
            OASISclient.notify(player,{"~o~Your weapons are already being stored hmm..."})
        end
    end)
end)

RegisterNetEvent('OASIS:forceStoreWeapons')
AddEventHandler('OASIS:forceStoreWeapons', function()
    local source = source 
    local user_id = OASIS.getUserId(source)
    local data = OASIS.getUserDataTable(user_id)
    Wait(3000)
    if data ~= nil then
        data.inventory = {}
    end
    tOASIS.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            local invcap = 30
            if plathours > 0 then
                invcap = invcap + 20
            elseif plushours > 0 then
                invcap = invcap + 10
            end
            if invcap == 30 then
            return
            end
            if data.invcap - 15 == invcap then
            OASIS.giveInventoryItem(user_id, "offwhitebag", 1, false)
            elseif data.invcap - 20 == invcap then
            OASIS.giveInventoryItem(user_id, "guccibag", 1, false)
            elseif data.invcap - 30 == invcap  then
            OASIS.giveInventoryItem(user_id, "nikebag", 1, false)
            elseif data.invcap - 35 == invcap  then
            OASIS.giveInventoryItem(user_id, "huntingbackpack", 1, false)
            elseif data.invcap - 40 == invcap  then
            OASIS.giveInventoryItem(user_id, "greenhikingbackpack", 1, false)
            elseif data.invcap - 70 == invcap  then
            OASIS.giveInventoryItem(user_id, "rebelbackpack", 1, false)
            end
            OASIS.updateInvCap(user_id, invcap)
        end
    end)
end)
