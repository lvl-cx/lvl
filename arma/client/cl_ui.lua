local function a()
    local b = {}
    local c, d = GetActiveScreenResolution()
    local e = GetAspectRatio()
    local f = 1 / c
    local g = 1 / d
    local h, i
    SetScriptGfxAlign(string.byte("L"), string.byte("B"))
    if IsBigmapActive() then
        h, i = GetScriptGfxPosition(-0.003975, 0.022 + -0.460416666)
        b.width = f * c / (2.52 * e)
        b.height = g * d / 2.3374
    else
        h, i = GetScriptGfxPosition(-0.0045, 0.002 + -0.188888)
        b.width = f * c / (4 * e)
        b.height = g * d / 5.674
    end
    ResetScriptGfxAlign()
    b.resX = c
    b.resY = d
    b.leftX = h
    b.rightX = h + b.width
    b.topY = i
    b.bottomY = i + b.height
    b.X = h + b.width / 2
    b.Y = i + b.height / 2
    b.Width = b.rightX - b.leftX
    return b
end
local j, k = GetActiveScreenResolution()
local l = a()
local m = 10.0
function tARMA.setMaxUnderWaterUITimenewTime(n)
    m = n
end
local function o(p, q, r, s, t, u, v, w)
    DrawRect(p + r / 2, q + s / 2, r, s, t, u, v, w)
end
function tARMA.getCachedMinimapAnchor()
    return l
end
function tARMA.getCachedResolution()
    return {w = l.resX, h = l.resY}
end
Citizen.CreateThread(function()
    while true do
        if not globalHideUi then
            if not globalHideEmergencyCallUI then
                local x = tARMA.getPlayerPed()
                local y, z = GetActiveScreenResolution()
                if y ~= j or z ~= k then
                    j, k = GetActiveScreenResolution()
                    l = a()
                end
                local A = l
                local B = (GetEntityHealth(x) - 100) / 100.0
                if B < 0 then
                    B = 0.0
                end
                if B == 0.98 then
                    B = 1.0
                end
                local C = GetPedArmour(x) / 100.0
                local D = GetPlayerUnderwaterTimeRemaining(PlayerId()) / m
                if C > 1.0 then
                    C = 1.0
                end
                o(A.leftX + 0.0045, A.bottomY - 0.004, A.Width, 0.009, 88, 88, 88, 200)
                o(A.leftX + 0.0045, A.bottomY - 0.004, A.Width * B, 0.009, 86, 215, 64, 200)
                o(A.leftX + 0.0045, A.bottomY + 0.009, A.Width, 0.009, 88, 88, 88, 200)
                if IsPedSwimmingUnderWater(x) and D >= 0.0 then
                    o(A.leftX + 0.0045, A.bottomY + 0.009, A.Width * D, 0.009, 243, 214, 102, 200)
                elseif C > 0.0 then
                    o(A.leftX + 0.0045, A.bottomY + 0.009, A.Width * C, 0.009, 60, 79, 255, 200)
                end
            end
        end
        Wait(0)
    end
end)



-- old ui as a backup if the issue keeps happening w/ the health moving

-- local function a()
--     local b = {}
--     local c, d = GetActiveScreenResolution()
--     local e = GetAspectRatio()
--     local f = 1 / c
--     local g = 1 / d
--     local h, i
--     SetScriptGfxAlign(string.byte("L"), string.byte("B"))
--     if IsBigmapActive() then
--         h, i = GetScriptGfxPosition(-0.003975, 0.022 + -0.460416666)
--         b.width = f * c / (2.52 * e)
--         b.height = g * d / 2.3374
--     else
--         h, i = GetScriptGfxPosition(-0.0045, 0.002 + -0.188888)
--         b.width = f * c / (4 * e)
--         b.height = g * d / 5.674
--     end
--     ResetScriptGfxAlign()
--     b.resX = c
--     b.resY = d
--     b.leftX = h
--     b.rightX = h + b.width
--     b.topY = i
--     b.bottomY = i + b.height
--     b.X = h + b.width / 2
--     b.Y = i + b.height / 2
--     b.Width = b.rightX - b.leftX
--     return b
-- end
-- local j, k = GetActiveScreenResolution()
-- local l = a()
-- local m = 10.0
-- function tARMA.setMaxUnderWaterUITimenewTime(n)
--     m = n
-- end
-- local function o(p, q, r, s, t, u, v, w)
--     DrawRect(p + r / 2, q + s / 2, r, s, t, u, v, w)
-- end
-- function tARMA.getCachedMinimapAnchor()
--     return l
-- end
-- function tARMA.getCachedResolution()
--     return {w = l.resX, h = l.resY}
-- end
-- Citizen.CreateThread(function()
--     while true do
--         if not globalHideUi then
--             if not globalHideEmergencyCallUI then
--                 local x = tARMA.getPlayerPed()
--                 local y, z = GetActiveScreenResolution()
--                 if y ~= j or z ~= k then
--                     j, k = GetActiveScreenResolution()
--                     l = a()
--                 end
--                 local A = l
--                 local B = (GetEntityHealth(x) - 100) / 100.0
--                 if B < 0 then
--                     B = 0.0
--                 end
--                 if B == 0.98 then
--                     B = 1.0
--                 end
--                 local C = GetPedArmour(x) / 100.0
--                 local D = GetPlayerUnderwaterTimeRemaining(PlayerId()) / m
--                 if C > 1.0 then
--                     C = 1.0
--                 end
                
--                 o(A.leftX + 0.001, A.bottomY - 0.015, A.Width - 0.002, 0.009, 88, 88, 88, 200)
--                 o(A.leftX + 0.001, A.bottomY - 0.015, (A.Width - 0.002) * B, 0.009, 86, 215, 64, 200)
--                 o(A.leftX + 0.001, A.bottomY - 0.002, A.Width - 0.002, 0.009, 88, 88, 88, 200)
--                 if IsPedSwimmingUnderWater(x) and D >= 0.0 then
--                     o(A.leftX + 0.001, A.bottomY - 0.002, (A.Width - 0.002) * D, 0.009, 243, 214, 102, 200)
--                 elseif C > 0.0 then
--                     o(A.leftX + 0.001, A.bottomY - 0.002, (A.Width - 0.002) * D, 0.009, 60, 79, 255, 200)
--                 end
--             end
--         end
--         Wait(0)
--     end
-- end)
