local cfg = module("cfg/player_state")
local a = module("cfg/weapons")
local lang = ARMA.lang

baseplayers = {}

AddEventHandler("ARMA:playerSpawn", function(user_id, source, first_spawn)
    Debug.pbegin("playerSpawned_player_state")
    local player = source
    local data = ARMA.getUserDataTable(user_id)
    local tmpdata = ARMA.getUserTmpTable(user_id)
    local playername = GetPlayerName(player)
    exports["discordroles"]:isRolePresent(source, {'975490533344559161'}, function(hasRole, roles)
        if hasRole then
            if first_spawn then -- first spawn
                if data.customization == nil then
                    data.customization = cfg.default_customization
                end
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
                    ARMAclient.spawnAnim(source, {data.position})
                    if data.weapons ~= nil then
                        ARMAclient.giveWeapons(source, {data.weapons, true})
                    end
                    ARMAclient.setUserID(source, {user_id})
        
                    if ARMA.hasGroup(user_id, 'Developer') then
                        ARMAclient.setDev(source, {})
                    end
                    if ARMA.hasGroup(user_id, 'cardev') then
                        ARMAclient.setCarDev(source, {})
                    end
                    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
                        ARMAclient.setPolice(source, {true})
                        TriggerClientEvent('ARMAUI5:globalOnPoliceDuty', source, true)
                    end
                    if ARMA.hasPermission(user_id, 'nhs.onduty.permission') then
                        ARMAclient.setNHS(source, {true})
                        TriggerClientEvent('ARMAUI5:globalNHSOnDuty', source, true)
                    end
                    if ARMA.hasGroup(user_id, 'Taco Seller') then
                        TriggerClientEvent('ARMA:toggleTacoJob', source, true)
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
        
                    TriggerClientEvent('ARMA:sendGarageSettings', source)
                    players = ARMA.getUsers({})
                    for k,v in pairs(players) do
                        baseplayers[v] = ARMA.getUserId(v)
                    end
                    ARMAclient.setBasePlayers(source, {baseplayers})
                    -- this is for the new inventory system
                   --[[  if data.inventory ~= nil then
                        MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
                            if #rows > 0 then
                                local FormattedInventoryData = {}
                                for i,v in pairs(data.inventory) do
                                    table.insert(FormattedInventoryData, {title = ARMA.getItemName(i), value = {i, ARMA.getItemWeight(i), v.amount}})
                                end
                                print(json.encode(FormattedInventoryData))
                                local plushours = rows[1].plushours
                                local plathours = rows[1].plathours
                                if plathours > 0 then
                                    TriggerClientEvent('ARMA:sendInventoryData', source, FormattedInventoryData, 50)
                                elseif plushours > 0 then
                                    TriggerClientEvent('ARMA:sendInventoryData', source, FormattedInventoryData, 40)
                                else
                                    TriggerClientEvent('ARMA:sendInventoryData', source, FormattedInventoryData, 30)
                                end
                            end
                        end)
                    end ]]
                else
                    if data.weapons ~= nil then -- load saved weapons
                        ARMAclient.giveWeapons(source, {data.weapons, true})
                    end
        
                    if data.health ~= nil then
                        ARMAclient.setHealth(source, {data.health})
                    end
                end
        
            else -- not first spawn (player died), don't load weapons, empty wallet, empty inventory
                ARMA.clearInventory(user_id) 
                ARMA.setMoney(user_id, 0)
                ARMAclient.setHandcuffed(player, {false})
        
                if cfg.spawn_enabled then -- respawn (CREATED SPAWN_DEATH)
                    local x = cfg.spawn_death[1] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
                    local y = cfg.spawn_death[2] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
                    local z = cfg.spawn_death[3] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
                    data.position = {
                        x = x,
                        y = y,
                        z = z
                    }
                    ARMAclient.teleport(source, {x, y, z})
                end
            end
        else
            DropPlayer(ARMA.getUserSource(user_id), 'You are required to be in discord.gg/armarp with the Verified role.')
            return
        end
        Debug.pend()
    end)
end)

function tARMA.updateWeapons(weapons)
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil then
        local data = ARMA.getUserDataTable(user_id)
        if data ~= nil then
            data.weapons = weapons
        end
    end
end

function tARMA.UpdatePlayTime()
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil then
        local data = ARMA.getUserDataTable(user_id)
        if data ~= nil then
            if data.PlayerTime ~= nil then
                data.PlayerTime = tonumber(data.PlayerTime) + 1
            else
                data.PlayerTime = 1
            end
        end
    end
end

function ARMA.updateInvCap(user_id, invcap)
    if user_id ~= nil then
        local data = ARMA.getUserDataTable(user_id)
        if data ~= nil then
            if data.invcap ~= nil then
                data.invcap = invcap
            else
                data.invcap = 30
            end
        end
    end
end

local isStoring = {}
AddEventHandler('ARMA:StoreWeaponsRequest', function(source)
    local player = source 
    local user_id = ARMA.getUserId(player)
	ARMAclient.getWeapons(player,{},function(weapons)
        if not isStoring[player] then
            isStoring[player] = true
            ARMAclient.giveWeapons(player,{{},true}, function(removedwep)
                for k,v in pairs(weapons) do
                    if k ~= 'GADGET_PARACHUTE' and k ~= 'WEAPON_STAFFGUN' and k~= 'WEAPON_FLAREGUN' and k~= 'WEAPON_SMOKEGRENADE' and k~= 'WEAPON_FLASHBANG' then
                        if v.ammo > 0 and k ~= 'WEAPON_STUNGUN' then
                            for i,c in pairs(a.weapons) do
                                if i == k then
                                    ARMA.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                                end   
                            end
                        end
                    end
                end
                ARMAclient.notify(player,{"~g~Weapons Stored"})
                SetTimeout(3000,function()
                      isStoring[player] = nil 
                end)
            end)
        else
            ARMAclient.notify(player,{"~o~Your weapons are already being stored hmm..."})
        end
    end)
end)