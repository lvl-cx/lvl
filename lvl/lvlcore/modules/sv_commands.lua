
local users = {}
RegisterNetEvent("PlayerJoined")
AddEventHandler(
    "PlayerJoined",
    function()
        local tempid = source
        local user_id = LVL.getUserId(source)
        if users[tempid] then
        else
            users[tempid] = user_id
            print("player source: ", source)
            print(json.encode(users))
        end
    end
)

RegisterCommand("getmyid", function(source)
    -- TriggerClientEvent('chatMessage', source, "^7[^1LVL^7]:", {255, 255, 255}, " Perm ID: " .. LVL.getUserId({source}) , "alert")
    TriggerClientEvent('chat:addMessage', source, {
        template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(0,0,0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> ^7[^2LVL^7]:^7' .. " Perm ID: " .. LVL.getUserId(source) .. '</div>',
        args = { playerName, msg }
      })
end)

RegisterCommand("getmytempid", function(source)
	--TriggerClientEvent('chatMessage', source, "^7[^1LVL^7]:", {255, 255, 255}, " Your Temp ID: " .. source, "alert")
    TriggerClientEvent('chat:addMessage', source, {
        template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(0,0,0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> ^7[^2LVL^7]:^7' .. " Your Temp ID: " .. source,
        args = { playerName, msg }
      })
end)

RegisterCommand('getid', function(source, args)
    if args and args[1] then 
        local userid = LVL.getUserId(args[1])
        if userid then 
            --TriggerClientEvent('chatMessage', source, '^7[^1LVL^7]:', {255, 0, 0}, "This Users Perm ID is: " .. userid, "alert")
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(0,0,0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> ^7[^2LVL^7]:^7' .. "This Users Perm ID is: " .. userid, "alert",
                args = { playerName, msg }
              })
        else 
            --TriggerClientEvent('chatMessage', source, '^7[^1LVL^7]:', {255, 0, 0}, "Temp ID cannot be found! This user is most likely offline.", "alert")
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(0,0,0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> ^7[^2LVL^7]:^7' .. "Temp ID cannot be found! This user is most likely offline.", "alert",
                args = { playerName, msg }
              })
            
        end
    else 
        --TriggerClientEvent('chatMessage', source, '^7[^1LVL^7]:', {255, 0, 0}, "Please specify a user eg: /getid [tempid]", "alert")
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(0,0,0, 0.6); border-radius: 4px;"><i class="fas fa-globe"></i> ^7[^2LVL^7]:^7' .. "Please specify a user eg: /getid [tempid]", "alert",
            args = { playerName, msg }
          })
    end
end)

RegisterCommand("s", function(source,args, rawCommand)
    user_id2 = LVL.getUserId(source)   
    if LVL.hasPermission(user_id2, "lvl.adminmenu") then
       
    else 
        local playerName = "Server "
        local msg = "Access denied."
        TriggerClientEvent('chatMessage', source, "^7Alert: " , { 128, 128, 128 }, msg, "alert")
        return 
    end
    local msg = rawCommand:sub(2)
    local playerName =  "^7[Announcement] " .. GetPlayerName(source)..": "
    local players = GetPlayers()
    for i,v in pairs(players) do 
        name = GetPlayerName(v)
        user_id = LVL.getUserId(v)   
            TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, msg, "alert")
    end
end)




