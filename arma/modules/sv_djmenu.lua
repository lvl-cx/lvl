local c = {}
RegisterCommand("djmenu", function(source, args, rawCommand)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id,"DJ") then
        TriggerClientEvent('ARMA:toggleDjMenu', source)
    end
end)
RegisterCommand("djadmin", function(source, args, rawCommand)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id,"admin.menu") then
        TriggerClientEvent('ARMA:toggleDjAdminMenu', source,c)
    end
end)
RegisterCommand("play",function(source,args,rawCommand)
    local source = source
    local user_id = ARMA.getUserId(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local name = GetPlayerName(source)
    if ARMA.hasGroup(user_id,"DJ") then
        if #args > 0 then
            TriggerClientEvent('ARMA:finaliseSong', source,args[1])
        end
    end
end)
RegisterServerEvent("ARMA:adminStopSong")
AddEventHandler("ARMA:adminStopSong", function(PARAM)
    local source = source
    for k,v in pairs(c) do
        if v[1] == PARAM then
            TriggerClientEvent('ARMA:stopSong', -1,v[2])
            c[tostring(k)] = nil
            TriggerClientEvent('ARMA:toggleDjAdminMenu', source,c)
        end
    end
end)
RegisterServerEvent("ARMA:playDjSongServer")
AddEventHandler("ARMA:playDjSongServer", function(PARAM,coords)
    local source = source
    local user_id = ARMA.getUserId(source)
    local name = GetPlayerName(source)
    c[tostring(source)] = {PARAM,coords,user_id,name,"true"}
    TriggerClientEvent('ARMA:playDjSong', -1,PARAM,coords,user_id,name)
end)
RegisterServerEvent("ARMA:skipServer")
AddEventHandler("ARMA:skipServer", function(coords,param)
    local source = source
    TriggerClientEvent('ARMA:skipDj', -1,coords,param)
end)
RegisterServerEvent("ARMA:stopSongServer")
AddEventHandler("ARMA:stopSongServer", function(coords)
    local source = source
    TriggerClientEvent('ARMA:stopSong', -1,coords)
end)
RegisterServerEvent("ARMA:updateVolumeServer")
AddEventHandler("ARMA:updateVolumeServer", function(coords,volume)
    local source = source
    TriggerClientEvent('ARMA:updateDjVolume', -1,coords,volume)
end)
