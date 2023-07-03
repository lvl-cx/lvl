local c = {}
RegisterCommand("djmenu", function(source, args, rawCommand)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasGroup(user_id,"DJ") then
        TriggerClientEvent('OASIS:toggleDjMenu', source)
    end
end)
RegisterCommand("djadmin", function(source, args, rawCommand)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id,"admin.noclip") then
        TriggerClientEvent('OASIS:toggleDjAdminMenu', source, c)
    end
end)
RegisterCommand("play",function(source,args,rawCommand)
    local source = source
    local user_id = OASIS.getUserId(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local name = GetPlayerName(source)
    if OASIS.hasGroup(user_id,"DJ") then
        if #args > 0 then
            TriggerClientEvent('OASIS:finaliseSong', source,args[1])
        end
    end
end)
RegisterServerEvent("OASIS:adminStopSong")
AddEventHandler("OASIS:adminStopSong", function(PARAM)
    local source = source
    for k,v in pairs(c) do
        if v[1] == PARAM then
            TriggerClientEvent('OASIS:stopSong', -1,v[2])
            c[tostring(k)] = nil
            TriggerClientEvent('OASIS:toggleDjAdminMenu', source, c)
        end
    end
end)
RegisterServerEvent("OASIS:playDjSongServer")
AddEventHandler("OASIS:playDjSongServer", function(PARAM,coords)
    local source = source
    local user_id = OASIS.getUserId(source)
    local name = GetPlayerName(source)
    c[tostring(source)] = {PARAM,coords,user_id,name,"true"}
    TriggerClientEvent('OASIS:playDjSong', -1,PARAM,coords,user_id,name)
end)
RegisterServerEvent("OASIS:skipServer")
AddEventHandler("OASIS:skipServer", function(coords,param)
    local source = source
    TriggerClientEvent('OASIS:skipDj', -1,coords,param)
end)
RegisterServerEvent("OASIS:stopSongServer")
AddEventHandler("OASIS:stopSongServer", function(coords)
    local source = source
    c[tostring(source)] = nil
    TriggerClientEvent('OASIS:stopSong', -1,coords)
end)
RegisterServerEvent("OASIS:updateVolumeServer")
AddEventHandler("OASIS:updateVolumeServer", function(coords,volume)
    local source = source
    TriggerClientEvent('OASIS:updateDjVolume', -1,coords,volume)
end)


RegisterServerEvent("OASIS:requestCurrentProgressServer") -- doing this will fix the issue of the song not playing when you leave and re enter the area
AddEventHandler("OASIS:requestCurrentProgressServer", function(a,b)
    TriggerClientEvent('OASIS:requestCurrentProgress', -1, a, b)
end)

RegisterServerEvent("OASIS:returnProgressServer") -- doing this will fix the issue of the song not playing when you leave and re enter the area
AddEventHandler("OASIS:returnProgressServer", function(x,y,z)
    for k,v in pairs(c) do
        if tonumber(k) == OASIS.getUserSource(x) then
            TriggerClientEvent('OASIS:returnProgress', -1, x, y, z, v[1])
        end
    end
end)
