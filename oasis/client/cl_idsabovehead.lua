local a = 7
local b = {}
local c = {}
local d = true
local e = {}
Citizen.CreateThread(function()
    Wait(500)
    while true do
        if not globalHideUi then
            if d then
                local f = tOASIS.getPlayerPed()
                for g, h in ipairs(GetActivePlayers()) do
                    local i = GetPlayerPed(h)
                    if i ~= f then
                        if b[h] then
                            if b[h] < a then
                                local j = e[h]
                                if NetworkIsPlayerTalking(h) then
                                    SetMpGamerTagAlpha(j, 4, 255)
                                    SetMpGamerTagColour(j, 0, 9)
                                    SetMpGamerTagColour(j, 4, 0)
                                    SetMpGamerTagVisibility(j, 4, true)
                                else
                                    SetMpGamerTagColour(j, 0, 0)
                                    SetMpGamerTagColour(j, 4, 0)
                                    SetMpGamerTagVisibility(j, 4, false)
                                end
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
        c = {}
        local f = tOASIS.getPlayerPed()
        local k = tOASIS.getPlayerCoords()
        if tOASIS.isInSpectate() then
            k = GetFinalRenderedCamCoord()
        end
        for g, h in ipairs(GetActivePlayers()) do
            local l = GetPlayerPed(h)
            local m = GetPlayerServerId(h)
            if l ~= f and (IsEntityVisible(l) or not tOASIS.clientGetPlayerIsStaff(tOASIS.clientGetUserIdFromSource(m))) then
                local n = GetEntityCoords(l)
                b[h] = #(k - n)
                if DecorGetBool(l, "cinematicMode") then
                    c[h] = true
                end
            end
        end
        if not tOASIS.isStaffedOn() then
            a = 7
        end
        Citizen.Wait(1000)
    end
end)
Citizen.CreateThread(function()
    while true do
        for g, h in ipairs(GetActivePlayers()) do
            local o = b[h]
            if o and o < a and d then
                local p = tostring(GetPlayerServerId(h))
                if c[h] then
                    p = p .. " [cinematic mode]"
                end
                e[h] = CreateFakeMpGamerTag(GetPlayerPed(h), p, false, false, "", 0)
                SetMpGamerTagVisibility(e[h], 3, true)
            elseif e[h] then
                RemoveMpGamerTag(e[h])
                e[h] = nil
            end
            Wait(0)
        end
        Wait(0)
    end
end)
SetMpGamerTagsUseVehicleBehavior(false)
function tOASIS.setPlayerNameDistance(o)
    if o == -1 then
        SetMpGamerTagsVisibleDistance(100.0)
        a = 7.0
    else
        SetMpGamerTagsVisibleDistance(o)
        a = o
    end
end
function tOASIS.getPlayerNameDistance()
    return a
end
RegisterCommand("farids",function(q, r, s)
    if tOASIS.getStaffLevel() > 2 and (tOASIS.isStaffedOn() or tOASIS.isInSpectate()) then
        local t = r[1]
        if t ~= nil and tonumber(t) then
            a = tonumber(t) + 000.1
            tOASIS.setPlayerNameDistance(a)
        else
            tOASIS.notify("~r~Please enter a valid range! (/farids [range])")
        end
    end
end,false)
RegisterCommand("faridsreset",function(q, r, s)
    if tOASIS.getStaffLevel() > 2 then
        tOASIS.setPlayerNameDistance(-1)
    end
end,false)
RegisterCommand("hideids",function()
    d = false
end)
RegisterCommand("showids",function()
    d = true
end)