local a = 7
local b = {}
local c = true
local d = {}
Citizen.CreateThread(function()
    Wait(500)
    while true do
        if c then
            local e = tARMA.getPlayerPed()
            for f, g in ipairs(GetActivePlayers()) do
                local h = GetPlayerPed(g)
                if h ~= e then
                    if b[g] then
                        if b[g] < a then
                            local i = d[g]
                            if NetworkIsPlayerTalking(g) then
                                SetMpGamerTagAlpha(i, 4, 255)
                                SetMpGamerTagColour(i, 0, 9)
                                SetMpGamerTagColour(i, 4, 0)
                                SetMpGamerTagVisibility(i, 4, true)
                            else
                                SetMpGamerTagColour(i, 0, 0)
                                SetMpGamerTagColour(i, 4, 0)
                                SetMpGamerTagVisibility(i, 4, false)
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        b = {}
        local e = tARMA.getPlayerPed()
        local j = tARMA.getPlayerCoords()
        for f, g in ipairs(GetActivePlayers()) do
            local k = GetPlayerPed(g)
            local l = GetPlayerServerId(g)
            if k ~= e and (IsEntityVisible(k) or not tARMA.getIsStaff(tARMA.getPermIdFromTemp(l))) then
                local m = GetEntityCoords(k)
                b[g] = #(j - m)
            end
        end
        if not tARMA.isstaffedOn() then
            a = 7
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        for f, g in ipairs(GetActivePlayers()) do
            local n = b[g]
            if n and n < a and c then
                d[g] = CreateFakeMpGamerTag(GetPlayerPed(g), GetPlayerServerId(g), false, false, "", 0)
                SetMpGamerTagVisibility(d[g], 3, true)
            elseif d[g] then
                RemoveMpGamerTag(d[g])
                d[g] = nil
            end
            Citizen.Wait(0)
        end
        Citizen.Wait(0)
    end
end)

SetMpGamerTagsUseVehicleBehavior(false)
RegisterCommand("farids",function(o, p, q)
    if tARMA.getStaffLevel() > 2 then
        if tARMA.isstaffedOn() then
            local r = p[1]
            if r ~= nil and tonumber(r) then
                a = tonumber(r) + 000.1
                SetMpGamerTagsVisibleDistance(a)
            else
                tARMA.notify("~r~Please enter a valid range! (/farids [range])")
            end
        else
            tARMA.notify("~r~You must be staffed on to use this.")
        end
    end
end)

RegisterCommand("faridsreset",function(o, p, q)
    if tARMA.getStaffLevel() > 2 then
        a = 7
        SetMpGamerTagsVisibleDistance(100.0)
    end
end)

RegisterCommand("hideids",function()
    c = false
end)

RegisterCommand("showids",function()
    c = true
end)
