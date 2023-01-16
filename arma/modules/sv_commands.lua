

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
    if #args <= 0 then return end
    local source = source
    local user_id = ARMA.getUserId(source)   
    local message = table.concat(args, " ")
    if ARMA.hasPermission(user_id, "police.onduty.permission") then
        local callsign = ""
        if getCallsign('Police', source, user_id, 'Police') then
            callsign = "["..getCallsign('Police', source, user_id, 'Police').."]"
        end
        local playerName =  "^4Police Chat | "..callsign.." "..GetPlayerName(source)..": "
        for k, v in pairs(ARMA.getUsers({})) do
            if ARMA.hasPermission(k, 'police.onduty.permission') then
                TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, message, "ooc")
            end
        end
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



