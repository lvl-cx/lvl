local b = true
RegisterCommand("togglekillfeed",function()
    b = not b
    if b then
        tARMA.notify("~g~Killfeed is now enabled")
    else
        tARMA.notify("~r~Killfeed is now disabled")
    end
    SendNUIMessage({type = "toggleKillFeed"})
end)

RegisterNetEvent("ARMA:toggleKillfeed",function(c)
    if b ~= c then
        b = c
        SendNUIMessage({type = "toggleKillFeed"})
    end
end)

RegisterNetEvent("ARMA:newKillFeed",function(d, e, f, g, h, i, j)
    local k = "other"
    local l = GetPlayerName(tARMA.getPlayerId())
    if e == l or d == l then
        k = "self"
    end
    SendNUIMessage({type = "addKill",victim = e,killer = d,weapon = f,suicide = g,victimGroup = i,killerGroup = j,range = h,uuid = tARMA.generateUUID("kill", 10, "alphabet"),category = k})
end)