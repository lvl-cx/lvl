

RegisterCommand("getmyid", function(source)
    TriggerClientEvent('chatMessage', source, "^1[ARMA]^1", {255, 255, 255}, " Perm ID: " .. ARMA.getUserId(source) , "alert")
end)

RegisterCommand("getmytempid", function(source)
	TriggerClientEvent('chatMessage', source, "^1[ARMA]^1", {255, 255, 255}, " Your Temp ID: " .. source, "alert")
end)


RegisterCommand("checkverified", function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    local discord_id = exports['ghmattimysql']:executeSync("SELECT discord_id FROM `arma_verification` WHERE user_id = @user_id", {user_id = user_id})[1].discord_id
    TriggerClientEvent('chatMessage', source, "^1[ARMA]^1", {255, 255, 255}, " Your Perm ID is connected to Discord ID: " .. discord_id, "alert")
end)


RegisterCommand("a", function(source,args, rawCommand)
    if #args <= 0 then return end
	local name = GetPlayerName(source)
    local message = table.concat(args, " ")
    local user_id = ARMA.getUserId(source)

    if ARMA.hasPermission(user_id, "admin.tickets") then
        tARMA.sendWebhook('staff', "ARMA Chat Logs", "```"..message.."```".."\n> Admin Name: **"..name.."**\n> Admin PermID: **"..user_id.."**\n> Admin TempID: **"..source.."**")
        for k, v in pairs(ARMA.getUsers({})) do
            if ARMA.hasPermission(k, 'admin.tickets') then
                TriggerClientEvent('chatMessage', v, "^3Admin Chat | " .. name..": " , { 128, 128, 128 }, message, "ooc")
            end
        end
    end
end)

RegisterCommand("p", function(source,args, rawCommand)
    local source = source
    local user_id = ARMA.getUserId(source)   
    if not ARMA.hasPermission(user_id, "police.onduty.permission") then
        return 
    end
    local msg = rawCommand:sub(2)
    local callsign = ""
    local discord_id = exports['arma']:Get_Client_Discord_ID(source)
    if discord_id then
        local guilds_info = exports['arma']:Get_Guilds()
        for guild_name, guild_id in pairs(guilds_info) do
            if guild_name == guildType then
                local nick_name = exports['arma']:Get_Guild_Nickname(guild_id, discord_id)
                if nick_name then
                    local open_bracket = string.find(nick_name, '[', nil, true) -- Extra Params to toggle pattern matching
                    local closed_bracket = string.find(nick_name, ']', nil, true) -- Extra Params to toggle pattern matching
                    if open_bracket and closed_bracket then
                        local callsign_value = string.sub(nick_name, open_bracket + 1, closed_bracket - 1)
                        callsign = callsign_value
                    end
                end
            end
        end
    end
    local playerName =  "^5Police Chat | "..callsign.." "..GetPlayerName(source)..": "
    local players = GetPlayers()
    for i,v in pairs(ARMA.getUsersByPermission('police.onduty.permission')) do 
        name = GetPlayerName(v)
        user_id = ARMA.getUserId(v)   
        TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, msg, "ooc")
    end
end)

RegisterCommand("g", function(source,args, rawCommand)
    local source = source
    local user_id = ARMA.getUserId(source)   
    local peoplesids = {}
    local gangmembers = {}
    local msg = rawCommand:sub(2)
    local playerName =  "^2[Gang Chat] " .. GetPlayerName(source)..": "
    exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    isingang = true
                    for U,D in pairs(array) do
                        peoplesids[tostring(U)] = tostring(D.gangPermission)
                    end
                    exports['ghmattimysql']:execute('SELECT * FROM arma_users', function(gotUser)
                        for J,G in pairs(gotUser) do
                            if peoplesids[tostring(G.id)] ~= nil then
                                local player = ARMA.getUserSource(tonumber(G.id))
                                if player ~= nil then
                                    TriggerClientEvent('chatMessage', player, playerName , { 128, 128, 128 }, msg, "ooc")
                                    tARMA.sendWebhook('gang', "ARMA Chat Logs", "```"..msg.."```".."\n> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
                                end
                            end
                        end
                    end)
                    break
                end
            end
        end
    end)
end)



