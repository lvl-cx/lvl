local a = false
TargetSpectate = nil
local b = 0
local c = 90
local d = -3.5
local e = nil
local f = 25
function polar3DToWorld3D(g, d, b, c)
    local h = b * math.pi / 180.0
    local i = c * math.pi / 180.0
    local j = {
        x = g.x + d * math.sin(i) * math.cos(h),
        y = g.y - d * math.sin(i) * math.sin(h),
        z = g.z - d * math.cos(i)
    }
    return j
end
function spectate(k)
    local l = tARMA.getPlayerPed()
    SetEntityCollision(l, false, false)
    SetEntityVisible(l, false)
    if not DoesCamExist(e) then
        e = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    end
    SetCamActive(e, true)
    RenderScriptCams(true, false, 0, true, true)
    a = true
    TargetSpectate = k
end
function resetNormalCamera()
    a = false
    TargetSpectate = nil
    local l = tARMA.getPlayerPed()
    SetCamActive(e, false)
    RenderScriptCams(false, false, 0, true, true)
    SetEntityCollision(l, true, true)
    SetEntityVisible(l, true)
    FreezeEntityPosition(l, false)
end
RegisterNetEvent("ARMA:spectate",function(k, m, n)
    if m then
        f = m
    end
    local l = tARMA.getPlayerPed()
    if k == -1 then
        resetNormalCamera()
    else
        FreezeEntityPosition(l, true)
        spectate(k)
    end
end)
RegisterNetEvent("ARMA:partTwo",function(o)
    if GetPlayerFromServerId(o) ~= -1 then
        NetworkConcealPlayer(GetPlayerFromServerId(o), true, 0)
    end
end)
RegisterNetEvent("ARMA:partThree",function(o)
    if GetPlayerFromServerId(o) ~= -1 then
        NetworkConcealPlayer(GetPlayerFromServerId(o), false, 0)
    end
end)
function draw2dText(p, q, r, s, t, u, v, w, x, y, z)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(t, t)
    SetTextColour(v, w, x, y)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if z then
        SetTextOutline()
    end
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(u)
    EndTextCommandDisplayText(p - r / 2, q - s / 2 + 0.005)
end
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if a then
            local A = GetPlayerFromServerId(TargetSpectate)
            if A ~= -1 then
                local l = tARMA.getPlayerPed()
                local B=GetPlayerPed(A)
                local C=GetEntityCoords(B)
                local D=GetEntityHealth(B)
                local E=GetEntityMaxHealth(B)
                local F=GetSelectedPedWeapon(B)
                local G=GetPedArmour(B)
                local H=GetAmmoInPedWeapon(B,F)
                draw2dText(0.76,1.415+(GetVehiclePedIsIn(B, false)~=0 and 0 or 0.025),1.0,1.0,0.4,"Health: "..D.."/"..E,51,153,255,200)
                draw2dText(0.76,1.39+(GetVehiclePedIsIn(B, false)~=0 and 0 or 0.025),1.0,1.0,0.4,"Armor: "..G,51,153,255,200)
                local I=tostring(WeaponNames[F])
                draw2dText(0.76,1.365+(GetVehiclePedIsIn(B, false)~=0 and 0 or 0.025),1.0,1.0,0.4,"Weapon: "..(I or"N/A"),51,153,255,200)
                draw2dText(0.76,1.340+(GetVehiclePedIsIn(B, false)~=0 and 0 or 0.025),1.0,1.0,0.4,"Ammo: "..(H or"N/A"),51,153,255,200)
                if GetVehiclePedIsIn(B, false)~=0 then
                    draw2dText(0.76,1.465,1.0,1.0,0.4,"Vehicle Health: "..GetEntityHealth(GetVehiclePedIsIn(B,false)),51,153,255,200)
                    draw2dText(0.76,1.44,1.0,1.0,0.4,"Vehicle Speed: ".. math.ceil(GetEntitySpeed( GetVehiclePedIsIn(B, false))*2.2369),51,153,255,200)
                end
                HideHudComponentThisFrame(19)
                HideHudComponentThisFrame(20)
                local J=GetActivePlayers()
                for K,L in pairs(J)do 
                    local M=GetPlayerPed(L)
                    SetEntityNoCollisionEntity(l,M,true)
                end
                if IsControlPressed(2,241)then 
                    d=d+0.5 
                end
                if IsControlPressed(2,242)then 
                    d=d-0.5 
                end
                if d>-1 then 
                    d=-1 
                end
                local N=GetDisabledControlNormal(0,1)
                local O=GetDisabledControlNormal(0,2)
                b=b+N*10
                if b>=360 then 
                    b=0 
                end
                c=c+O*10
                if c>=360 then 
                    c=0 
                end
                local P=polar3DToWorld3D(C,d,b,c)
                SetCamCoord(e,P.x,P.y,P.z)
                PointCamAtEntity(e,B)
                SetEntityCoordsNoOffset(l,C.x,C.y,C.z-f)
            else
                tARMA.notify("~r~Couldn't spectate, person not in your zone")
            end
        end
    end
end)

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