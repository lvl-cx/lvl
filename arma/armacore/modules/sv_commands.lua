
local users = {}
RegisterNetEvent("PlayerJoined")
AddEventHandler(
    "PlayerJoined",
    function()
        local tempid = source
        local user_id = ARMA.getUserId(source)
        if users[tempid] then
        else
            users[tempid] = user_id
            print("player source: ", source)
            print(json.encode(users))
        end
    end
)

RegisterCommand("getmyid", function(source)
    TriggerClientEvent('chatMessage', source, "^7[^1ARMA^7]:", {255, 255, 255}, " Perm ID: " .. ARMA.getUserId(source) , "alert")
    --TriggerClientEvent('chat:addMessage', source, {
    --    template = '^7[ARMA^7]:^7' .. " Perm ID: " .. ARMA.getUserId(source) .. '</div>',
    --    args = { playerName, msg }
    --  })
end)

RegisterCommand("getmytempid", function(source)
	TriggerClientEvent('chatMessage', source, "^7[^1ARMA^7]:", {255, 255, 255}, " Your Temp ID: " .. source, "alert")
    --TriggerClientEvent('chat:addMessage', source, {
    --    template = '^7[ARMA^7]:^7' .. " Your Temp ID: " .. source,
    --    args = { playerName, msg }
    --  })
end)

RegisterCommand('getid', function(source, args)
    if args and args[1] then 
        local userid = ARMA.getUserId(args[1])
        if userid then 
            TriggerClientEvent('chatMessage', source, '^7[^1ARMA^7]:', {255, 0, 0}, "This Users Perm ID is: " .. userid, "alert")
            --TriggerClientEvent('chat:addMessage', source, {
            --    template = '^7[ARMA^7]:^7' .. "This Users Perm ID is: " .. userid, "alert",
            --    args = { playerName, msg }
            --  })
        else 
            TriggerClientEvent('chatMessage', source, '^7[^1ARMA^7]:', {255, 0, 0}, "Temp ID cannot be found! This user is most likely offline.", "alert")
            --TriggerClientEvent('chat:addMessage', source, {
            --    template = '^7[ARMA^7]:^7' .. "Temp ID cannot be found! This user is most likely offline.", "alert",
            --    args = { playerName, msg }
            --  })
            
        end
    else 
        TriggerClientEvent('chatMessage', source, '^7[^1ARMA^7]:', {255, 0, 0}, "Please specify a user eg: /getid [tempid]", "alert")
        --TriggerClientEvent('chat:addMessage', source, {
        --    template = '^7[ARMA^7]:^7' .. "Please specify a user eg: /getid [tempid]", "alert",
        --    args = { playerName, msg }
        --  })
    end
end)

RegisterCommand("s", function(source,args, rawCommand)
    user_id2 = ARMA.getUserId(source)   
    if ARMA.hasPermission(user_id2, "admin.whitelisted") then
       
    else 
        local playerName = "Server "
        local msg = "Access denied."
        TriggerClientEvent('chatMessage', source, "^7Alert: " , { 128, 128, 128 }, msg, "alert")
        return 
    end
    local msg = rawCommand:sub(2)
    local playerName =  "^7[Staff Chat] " .. GetPlayerName(source)..": "
    local players = GetPlayers()
    for i,v in pairs(players) do 
        name = GetPlayerName(v)
        user_id = ARMA.getUserId(v)   
            TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, msg, "staff")
    end
end)




