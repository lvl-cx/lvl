local a = false
local b = nil
local c = 0
local d = 90
local e = -3.5
local f = nil
local function g(h, e, c, d)
    local i = math.rad(c)
    local j = math.rad(d)
    return vector3(h.x + e * math.sin(j) * math.cos(i), h.y - e * math.sin(j) * math.sin(i), h.z - e * math.cos(j))
end
RegisterNetEvent("ARMA:spectatePlayer",function(k, l)
    local m = PlayerPedId()
    FreezeEntityPosition(m, true)
    SetEntityCollision(m, false, false)
    SetEntityVisible(m, false, 0)
    SetEntityInvincible(m, true)
    local n = math.random(7500, 8900)
    local o = math.random(7500, 8900)
    local p = math.random(1, 2) == 2
    if p then
        n = -n
        o = -o
    end
    SetEntityCoordsNoOffset(m, n + 0.0, o + 0.0, 1000.0, false, false, false)
    f = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", l.x, l.y, l.z, 0.0, 0.0, 0.0, GetGameplayCamFov(), false, 2)
    SetCamActive(f, true)
    RenderScriptCams(true, false, 0, true, true)
    b = k
    while true do
        if not b then
            return
        end
        SetFocusPosAndVel(l.x, l.y, l.z, 0.0, 0.0, 0.0)
        LockMinimapPosition(l.x, l.y)
        SetPlayerBlipPositionThisFrame(l.x, l.y)
        if GetPlayerFromServerId(k) ~= -1 then
            break
        end
        Citizen.Wait(0)
    end
    a = true
end)
RegisterNetEvent("ARMA:stopSpectatePlayer",function()
    a = false
    ClearFocus()
    b = nil
    UnlockMinimapPosition()
    SetCamActive(f, false)
    RenderScriptCams(false, false, 0, false, false)
    DestroyCam(f, false)
    local m = PlayerPedId()
    SetEntityInvincible(m, false)
    SetEntityVisible(m, true, 0)
    SetEntityCollision(m, true, true)
    FreezeEntityPosition(m, false)
end)

function draw2dText(q, r, s, t, u, v, w, x, y, z, A)
SetTextFont(0)
SetTextProportional(0)
SetTextScale(u, u)
SetTextColour(w, x, y, z)
SetTextDropshadow(0, 0, 0, 0, 255)
SetTextEdge(1, 0, 0, 0, 255)
SetTextDropShadow()
if A then
    SetTextOutline()
end
BeginTextCommandDisplayText("STRING")
AddTextComponentSubstringPlayerName(v)
EndTextCommandDisplayText(q - s / 2, r - t / 2 + 0.005)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if a then
            local B = GetPlayerFromServerId(b)
            if B ~= -1 then
                local m = tARMA.getPlayerPed()
                local C = GetPlayerPed(B)
                if C ~= 0 then
                    local D = GetEntityCoords(C)
                    local E = GetEntityHealth(C)
                    local F = GetEntityMaxHealth(C)
                    local G = GetSelectedPedWeapon(C)
                    local H = GetPedArmour(C)
                    local I = GetAmmoInPedWeapon(C, G)
                    draw2dText(0.76, 1.44, 1.0, 1.0, 0.4, "Health: " .. E .. "/" .. F, 51, 153, 255, 200)
                    draw2dText(0.76, 1.415, 1.0, 1.0, 0.4, "Armor: " .. H, 51, 153, 255, 200)
                    draw2dText(0.76,1.39,1.0,1.0,0.4,"Vehicle Health: " .. GetEntityHealth(GetVehiclePedIsIn(C, false)),51,153,255,200)
                    local J = tostring(WeaponNames[G])
                    draw2dText(0.76, 1.365, 1.0, 1.0, 0.4, "Weapon: " .. (J or "N/A"), 51, 153, 255, 200)
                    draw2dText(0.76, 1.340, 1.0, 1.0, 0.4, "Ammo: " .. (I or "N/A"), 51, 153, 255, 200)
                    local K = GetActivePlayers()
                    for L, M in pairs(K) do
                        local N = GetPlayerPed(M)
                        SetEntityNoCollisionEntity(m, N, true)
                    end
                    DisableControlAction(2, 15, true)
                    DisableControlAction(2, 17, true)
                    if IsControlPressed(2, 241) then
                        e = e + 0.5
                    end
                    DisableControlAction(2, 14, true)
                    DisableControlAction(2, 16, true)
                    if IsControlPressed(2, 242) then
                        e = e - 0.5
                    end
                    if e > -1 then
                        e = -1
                    end
                    local O = GetDisabledControlNormal(0, 1)
                    local P = GetDisabledControlNormal(0, 2)
                    c = c + O * 10
                    if c >= 360 then
                        c = 0
                    end
                    d = d + P * 10
                    if d >= 360 then
                        d = 0
                    end
                    local Q = g(D, e, c, d)
                    SetCamCoord(f, Q.x, Q.y, Q.z)
                    PointCamAtEntity(f, C, 0.0, 0.0, 0.0, false)
                    SetFocusPosAndVel(D.x, D.y, D.z, 0.0, 0.0, 0.0)
                    LockMinimapPosition(D.x, D.y)
                    SetPlayerBlipPositionThisFrame(D.x, D.y)
                end
            else
                tARMA.notify("~r~Couldn't spectate, person not in your zone")
            end
        end
    end
end)
local R = {}
AddStateBagChangeHandler("conceal",nil,function(S, T, U)
    local V = tonumber(stringsplit(S, ":")[2])
    if U then
        R[V] = true
    else
        local W = GetPlayerFromServerId(V)
        if W ~= -1 and W ~= PlayerId() then
            NetworkConcealPlayer(W, false, false)
        end
        R[V] = nil
    end
end)
RegisterNetEvent("onPlayerDropped",function(V)
    R[V] = nil
end)

local function X()
    for V in pairs(R) do
        local W = GetPlayerFromServerId(V)
        if W ~= -1 and W ~= PlayerId() then
            NetworkConcealPlayer(W, true, true)
        end
    end
end
tARMA.createThreadOnTick(X)
function tARMA.isInSpectate()
    return a
end

function tARMA.getIsStaff(j)
    currentStaff = tARMA.getCurrentPlayerInfo('currentStaff')
    if currentStaff then
        for a,b in pairs(currentStaff) do
            if b == j then
                return true
            end
        end
        return false
    end
end