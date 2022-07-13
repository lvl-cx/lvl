AddEventHandler("playerJoining", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMAclient.setUserID(source, {user_id})

    if vRP.hasGroup(user_id, 'Developer') then
        ARMAclient.setDev(source, {})
    end
    if vRP.hasGroup(user_id, 'cardev') then
        ARMAclient.setCarDev(source, {})
    end
        
    local adminlevel = 0
    if ARMA.hasGroup(user_id,"dev") then
        adminlevel = 12
    elseif ARMA.hasGroup(user_id,"founder") then
        adminlevel = 11
    elseif ARMA.hasGroup(user_id,"operationsmanager") then
        adminlevel = 10
    elseif ARMA.hasGroup(user_id,"staffmanager") then    
        adminlevel = 9
    elseif ARMA.hasGroup(user_id,"commanager") then
        adminlevel = 8
    elseif ARMA.hasGroup(user_id,"headadmin") then
        adminlevel = 7
    elseif ARMA.hasGroup(user_id,"senioradmin") then
        adminlevel = 6
    elseif ARMA.hasGroup(user_id,"administrator") then
        adminlevel = 5
    elseif ARMA.hasGroup(user_id,"srmoderator") then
        adminlevel = 4
    elseif ARMA.hasGroup(user_id,"moderator") then
        adminlevel = 3
    elseif ARMA.hasGroup(user_id,"supportteam") then
        adminlevel = 2
    elseif ARMA.hasGroup(user_id,"trialstaff") then
        adminlevel = 1
    end
    ARMAclient.setStaffLevel(source, {adminlevel})
end)
