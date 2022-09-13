

RegisterCommand("getmyid", function(source)
    TriggerClientEvent('chatMessage', source, "^1[ARMA]^1", {255, 255, 255}, " Perm ID: " .. ARMA.getUserId(source) , "alert")
end)

RegisterCommand("getmytempid", function(source)
	TriggerClientEvent('chatMessage', source, "^1[ARMA]^1", {255, 255, 255}, " Your Temp ID: " .. source, "alert")
end)


RegisterCommand("a", function(source,args, rawCommand)
    user_id = ARMA.getUserId(source)   
    if not ARMA.hasPermission(user_id, "admin.tickets") then
        local playerName = "Server "
        local msg = "Access denied."
        TriggerClientEvent('chatMessage', source, "^7Alert: " , { 128, 128, 128 }, msg, "alert")
        return 
    end
    local msg = rawCommand:sub(2)
    local playerName =  "^3Admin Chat | " .. GetPlayerName(source)..": "
    local players = GetPlayers()
    for i,v in pairs(ARMA.getUsersByPermission('admin.tickets')) do 
        name = GetPlayerName(v)
        user_id = ARMA.getUserId(v)   
        TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, msg, "ooc")
    end
end)

RegisterCommand("p", function(source,args, rawCommand)
    user_id = ARMA.getUserId(source)   
    if not ARMA.hasPermission(user_id, "police.onduty.permission") then
        local playerName = "Server "
        local msg = "Access denied."
        TriggerClientEvent('chatMessage', source, "^7Alert: " , { 128, 128, 128 }, msg, "alert")
        return 
    end
    local msg = rawCommand:sub(2)
    local playerName =  "^7[Police Chat] " .. GetPlayerName(source)..": "
    local players = GetPlayers()
    for i,v in pairs(ARMA.getUsersByPermission('police.onduty.permission')) do 
        name = GetPlayerName(v)
        user_id = ARMA.getUserId(v)   
        TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, msg, "police")
    end
end)

--[[ RegisterCommand("f", function(source,args, rawCommand)
    user_id = ARMA.getUserId(source)   
    if not ARMA.hasPermission(user_id, "police.onduty.permission") and not ARMA.hasPermission(user_id, "prisonguard.onduty.permission") then
        local playerName = "Server "
        local msg = "Access denied."
        TriggerClientEvent('chatMessage', source, "^7Alert: " , { 128, 128, 128 }, msg, "alert")
        return 
    end
    local msg = rawCommand:sub(2)
    local playerName =  "^7[Faction Chat] " .. GetPlayerName(source)..": "
    local players = GetPlayers()
    for i,v in pairs(players) do 
        name = GetPlayerName(v)
        user_id = ARMA.getUserId(v)   
        TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, msg, "faction")
    end
end) ]]






