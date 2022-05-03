-- this module describe the group/permission system
-- group functions are used on connected players only
-- multiple groups can be set to the same player, but the gtype config option can be used to set some groups as unique
-- api
local cfg = module("cfg/groups")
local groups = cfg.groups
local users = cfg.users
local selectors = cfg.selectors

-- get groups keys of a connected user
function LVL.getUserGroups(user_id)
    local data = LVL.getUserDataTable(user_id)
    if data then
        if data.groups == nil then
            data.groups = {} -- init groups
        end

        return data.groups
    else
        return {}
    end
end

-- add a group to a connected user
function LVL.addUserGroup(user_id, group)
    if not LVL.hasGroup(user_id, group) then
        local user_groups = LVL.getUserGroups(user_id)
        local ngroup = groups[group]
        if ngroup then
            if ngroup._config and ngroup._config.gtype ~= nil then
                -- copy group list to prevent iteration while removing
                local _user_groups = {}
                for k, v in pairs(user_groups) do
                    _user_groups[k] = v
                end

                for k, v in pairs(_user_groups) do -- remove all groups with the same gtype
                    local kgroup = groups[k]
                    if kgroup and kgroup._config and ngroup._config and kgroup._config.gtype == ngroup._config.gtype then
                        LVL.removeUserGroup(user_id, k)
                    end
                end
            end

            -- add group
            user_groups[group] = true
            local player = LVL.getUserSource(user_id)
            if ngroup._config and ngroup._config.onjoin and player ~= nil then
                ngroup._config.onjoin(player) -- call join callback
            end

            -- trigger join event
            local gtype = nil
            if ngroup._config then
                gtype = ngroup._config.gtype
            end
            TriggerEvent("LVL:playerJoinGroup", user_id, group, gtype)
        end
    end
end

-- get user group by type
-- return group name or an empty string
function LVL.getUserGroupByType(user_id, gtype)
    local user_groups = LVL.getUserGroups(user_id)
    for k, v in pairs(user_groups) do
        local kgroup = groups[k]
        if kgroup then
            if kgroup._config and kgroup._config.gtype and kgroup._config.gtype == gtype then
                return k
            end
        end
    end

    return ""
end

-- return list of connected users by group
function LVL.getUsersByGroup(group)
    local users = {}

    for k, v in pairs(LVL.rusers) do
        if LVL.hasGroup(tonumber(k), group) then
            table.insert(users, tonumber(k))
        end
    end

    return users
end

-- return list of connected users by permission
function LVL.getUsersByPermission(perm)
    local users = {}

    for k, v in pairs(LVL.rusers) do
        if LVL.hasPermission(tonumber(k), perm) then
            table.insert(users, tonumber(k))
        end
    end

    return users
end

-- remove a group from a connected user
function LVL.removeUserGroup(user_id, group)
    local user_groups = LVL.getUserGroups(user_id)
    local groupdef = groups[group]
    if groupdef and groupdef._config and groupdef._config.onleave then
        local source = LVL.getUserSource(user_id)
        if source ~= nil then
            groupdef._config.onleave(source) -- call leave callback
        end
    end

    -- trigger leave event
    local gtype = nil
    if groupdef._config then
        gtype = groupdef._config.gtype
    end
    TriggerEvent("LVL:playerLeaveGroup", user_id, group, gtype)

    user_groups[group] = nil -- remove reference
end

-- check if the user has a specific group
function LVL.hasGroup(user_id, group)
    local user_groups = LVL.getUserGroups(user_id)
    return (user_groups[group] ~= nil)
end

-- check if the user has a specific permission
-- check if the user has a specific permission
function LVL.hasPermission(user_id, perm)
    local user_groups = LVL.getUserGroups(user_id)
    local fchar = string.sub(perm, 1, 1)

    if fchar == "@" then -- special aptitude permission
        local _perm = string.sub(perm, 2, string.len(perm))
        local parts = splitString(_perm, ".")
        if #parts == 3 then -- decompose group.aptitude.operator
            local group = parts[1]
            local aptitude = parts[2]
            local op = parts[3]

            local alvl = math.floor(LVL.expToLevel(LVL.getExp(user_id, group, aptitude)))

            local fop = string.sub(op, 1, 1)
            if fop == "<" then -- less (group.aptitude.<x)
                local lvl = parseInt(string.sub(op, 2, string.len(op)))
                if alvl < lvl then
                    return true
                end
            elseif fop == ">" then -- greater (group.aptitude.>x)
                local lvl = parseInt(string.sub(op, 2, string.len(op)))
                if alvl > lvl then
                    return true
                end
            else -- equal (group.aptitude.x)
                local lvl = parseInt(string.sub(op, 1, string.len(op)))
                if alvl == lvl then
                    return true
                end
            end
        end
    elseif fchar == "#" then -- special item permission
        local _perm = string.sub(perm, 2, string.len(perm))
        local parts = splitString(_perm, ".")
        if #parts == 2 then -- decompose item.operator
            local item = parts[1]
            local op = parts[2]

            local amount = LVL.getInventoryItemAmount(user_id, item)

            local fop = string.sub(op, 1, 1)
            if fop == "<" then -- less (item.<x)
                local n = parseInt(string.sub(op, 2, string.len(op)))
                if amount < n then
                    return true
                end
            elseif fop == ">" then -- greater (item.>x)
                local n = parseInt(string.sub(op, 2, string.len(op)))
                if amount > n then
                    return true
                end
            else -- equal (item.x)
                local n = parseInt(string.sub(op, 1, string.len(op)))
                if amount == n then
                    return true
                end
            end
        end
    else -- regular plain permission
        -- precheck negative permission
        local nperm = "-" .. perm
        for k, v in pairs(user_groups) do
            if v then -- prevent issues with deleted entry
                local group = groups[k]
                if group then
                    for l, w in pairs(group) do -- for each group permission
                        if l ~= "_config" and w == nperm then
                            return false
                        end
                    end
                end
            end
        end

        -- check if the permission exists
        for k, v in pairs(user_groups) do
            if v then -- prevent issues with deleted entry
                local group = groups[k]
                if group then
                    for l, w in pairs(group) do -- for each group permission
                        if l ~= "_config" and w == perm then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

-- check if the user has a specific list of permissions (all of them)
function LVL.hasPermissions(user_id, perms)
    for k, v in pairs(perms) do
        if not LVL.hasPermission(user_id, v) then
            return false
        end
    end

    return true
end

-- GROUP SELECTORS

local function ch_select(player, choice)
    local user_id = LVL.getUserId(player)
    if user_id ~= nil then
        LVL.addUserGroup(user_id, choice)
        LVL.closeMenu(player)
    end
end

-- build menus
local selector_menus = {}
for k, v in pairs(selectors) do
    local menu = {
        name = k,
        css = {
            top = "75px",
            header_color = "rgba(255,154,24,0.75)"
        }
    }
    for l, w in pairs(v) do
        if l ~= "_config" then
            menu[w] = {ch_select}
        end
    end

    selector_menus[k] = menu
end

local function build_client_selectors(source)
    local user_id = LVL.getUserId(source)
    if user_id ~= nil then
        for k, v in pairs(selectors) do
            local gcfg = v._config
            local menu = selector_menus[k]

            if gcfg and menu then
                local x = gcfg.x
                local y = gcfg.y
                local z = gcfg.z

                local function selector_enter()
                    local user_id = LVL.getUserId(source)
                    if user_id ~= nil and LVL.hasPermissions(user_id, gcfg.permissions or {}) then
                        LVL.openMenu(source, menu)
                    end
                end

                local function selector_leave()
                    LVL.closeMenu(source)
                end

                LVLclient.addBlip(source, {x, y, z, gcfg.blipid, gcfg.blipcolor, k})
                LVLclient.addMarker(source, {x, y, z - 1, 0.7, 0.7, 0.5, 255, 154, 24, 125, 150})

                LVL.setArea(source, "LVL:gselector:" .. k, x, y, z, 1, 1.5, selector_enter, selector_leave)
            end
        end
    end
end

-- events

-- player spawn
AddEventHandler("LVL:playerSpawn", function(user_id, source, first_spawn)
    -- first spawn
    if first_spawn then
        -- add selectors 
        build_client_selectors(source)

        -- add groups on user join 
        local user = users[user_id]
        if user ~= nil then
            for k, v in pairs(user) do
                LVL.addUserGroup(user_id, v)
            end
        end

        -- add default group user
        LVL.addUserGroup(user_id, "user")
    end

    -- call group onspawn callback at spawn
    local user_groups = LVL.getUserGroups(user_id)
    for k, v in pairs(user_groups) do
        local group = groups[k]
        if group and group._config and group._config.onspawn then
            group._config.onspawn(source)
        end
    end
end)
