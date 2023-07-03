local a = false
local b = true
RegisterCommand("togglekillfeed",function()
    if not a then
        b = not b
        if b then
            tOASIS.notify("~g~Killfeed is now enabled")
            SendNUIMessage({type = "killFeedEnable"})
        else
            tOASIS.notify("~r~Killfeed is now disabled")
            SendNUIMessage({type = "killFeedDisable"})
        end
    end
end)
RegisterNetEvent("OASIS:showHUD",function(c)
    a = not c
    if b then
        if c then
            SendNUIMessage({type = "killFeedEnable"})
        else
            SendNUIMessage({type = "killFeedDisable"})
        end
    end
end)

RegisterNetEvent("OASIS:newKillFeed",function(d, e, f, g, h, i, j)
    if GetIsLoadingScreenActive() then
        return
    end
    local k = "other"
    local l = GetPlayerName(tOASIS.getPlayerId())
    if e == l or d == l then
        k = "self"
    end
    SendNUIMessage({type = "addKill",victim = e,killer = d,weapon = f,suicide = g,victimGroup = i,killerGroup = j,range = h,uuid = tOASIS.generateUUID("kill", 10, "alphabet"),category = k})
end)