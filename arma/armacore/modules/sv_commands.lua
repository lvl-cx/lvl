

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
        return 
    end
    local msg = rawCommand:sub(2)
    local playerName =  "^5[Police Chat] " .. GetPlayerName(source)..": "
    local players = GetPlayers()
    for i,v in pairs(ARMA.getUsersByPermission('police.onduty.permission')) do 
        name = GetPlayerName(v)
        user_id = ARMA.getUserId(v)   
        TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, msg, "ooc")
    end
end)

RegisterCommand("g", function(source,args, rawCommand)
    user_id = ARMA.getUserId(source)   
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



