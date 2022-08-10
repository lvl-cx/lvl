globalInRedzone=false
local a=false
local b=0
local c = {
    ["Rebel"] = {vector3(1468.5318603516, 6328.529296875, 18.894895553589), 100.0},
    ["Heroin"] = {vector3(3545.048828125, 3724.0776367188, 36.64262008667), 170.0},
    ["LargeArms"] = {vector3(-1118.4926757813, 4926.1889648438, 218.35691833496), 170.0},
    ["LargeArmsCayo"] = {vector3(5115.7465820312, -4623.2915039062, 2.642692565918), 85.0},
    ["RebelCayo"] = {vector3(4982.5634765625, -5175.1079101562, 2.4887988567352), 120.0},
    ["LSDNorth"] = {vector3(1317.0300292969, 4309.8359375, 38.005485534668), 90.0},
    ["LSDSouth"] = {vector3(2539.0964355469, -376.51586914063, 92.986785888672), 120.0}
}

local function d(e,f)
    return#(vector3(e.x,e.y,0.0)-vector3(f.x,f.y,0.0))
end

function tARMA.setRedzoneTimerDisabled(g)
    a=g 
end

function tARMA.isPlayerInRedZone()
    return globalInRedzone 
end
function tARMA.getPlayerCombatTimer()
    return b 
end

RegisterNetEvent("ARMA:SendLSDCoords")
AddEventHandler("ARMA:SendLSDCoords", function(A)
    c["LSD"] = {A[1],A[4]}
    while true do 
        if not a then 
            local h=GetEntityCoords(tARMA.getPlayerPed())
            globalInRedzone=false
            for i,j in pairs(c)do 
                local k=j[1]
                local l=j[2]
                if#(h-k)<=l then 
                    if not globalInRedzone then
                        TriggerServerEvent('ARMA:UpdateInRZ',true)
                    end 
                    globalInRedzone=true
                    local h=GetEntityCoords(tARMA.getPlayerPed())
                    b=30
                    local m
                    local n=false
                    while not n do 
                        h=GetEntityCoords(tARMA.getPlayerPed())
                        while d(h,k)<=l and not q() do 
                            h=GetEntityCoords(tARMA.getPlayerPed())
                            m=h
                            if IsPedShooting(tARMA.getPlayerPed())and GetSelectedPedWeapon(tARMA.getPlayerPed())~=`WEAPON_UNARMED`then 
                                b=30
                            end
                            if b==0 then 
                                DrawAdvancedText(0.931,0.914,0.005,0.0028,0.49,"Combat Timer ended, you may leave.",255,51,51,255,7,0)
                            else 
                                DrawAdvancedText(0.931,0.914,0.005,0.0028,0.49,"Combat Timer: "..b.." seconds",255,51,51,255,7,0)
                            end
                            Wait(0)
                        end
                        if b==0 then 
                            n=true 
                        else 
                            if tARMA.isstaffedOn() or inSpectatorAdminMode then
                                b = 0
                                n=true
                            else
                                local o=j[1]-GetEntityCoords(tARMA.getPlayerPed())
                                m=m+o*0.01
                                if GetVehiclePedIsIn(tARMA.getPlayerPed(),false)==0 then 
                                    TaskGoStraightToCoord(tARMA.getPlayerPed(),m.x,m.y,m.z,8.0,1000,GetEntityHeading(tARMA.getPlayerPed()),0.0)
                                    local p=GetSoundId()
                                    PlaySoundFrontend(p,"End_Zone_Flash","DLC_BTL_RB_Remix_Sounds",true)
                                    ReleaseSoundId(p)
                                    tARMA.announceMpBigMsg("~r~WARNING","Get back in the redzone!",2000)
                                else 
                                    SetEntityCoords(tARMA.getPlayerPed(),m.x,m.y,m.z)
                                end
                                SetTimeout(1000,function()
                                    ClearPedTasks(tARMA.getPlayerPed())
                                end)
                            end
                        end
                        Wait(0)
                    end 
                end 
            end 
        end
        Wait(500)
    end 
end)

Citizen.CreateThread(function()
    while true do 
        if b>0 then 
            b=b-1 
        end
        Wait(1000)
    end 
end)

local function q()
    return globalOnPoliceDuty or globalOnPrisonDuty or globalNHSOnDuty
end