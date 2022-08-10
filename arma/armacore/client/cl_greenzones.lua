local a=module("arma-vehicles","cfg_vehiclemaxspeeds")
isInGreenzone=false
local b=false
local c=false
local d=false
local e=false
local f=0
local g=false
local h=false
local i=false
local j={
    {colour=2,id=1,pos=vector3(333.91488647461,-597.16156005859,29.292747497559),dist=40,nonRP=false,setBit=false},
    {colour=2,id=1,pos=vector3(150.11642456055,-1039.6853027344,29.367973327637),dist=25,nonRP=false,setBit=false},
    {colour=2,id=1,pos=vector3(-110.09871673584,6464.6030273438,31.62672996521),dist=20,nonRP=false,setBit=false},
    {colour=2,id=1,pos=vector3(-1079.5734863281,-843.14739990234,4.8841333389282),dist=45,nonRP=false,setBit=false},
    {colour=2,id=1,pos=vector3(-2181.7966308594,5189.8286132813,17.64377784729),dist=150,nonRP=true,setBit=false},
    {colour=2,id=1,pos=vector3(-540.54748535156,-216.42681884766,37.64966583252),dist=50,nonRP=false,setBit=false},
    {colour=2,id=1,pos=vector3(246.30143737793,-782.50170898438,30.573167800903),dist=40,nonRP=false,setBit=false},
    {colour=2,id=1,pos=vector3(3463.3479003906,2589.4458007813,17.442699432373),dist=40,nonRP=true,setBit=false},
    {colour=2,id=1,pos=vector3(1133.0970458984,250.78565979004,-51.035778045654),dist=100,nonRP=false,setBit=false,interior=true},
    {colour=2,id=1,pos=vector3(13.929432868958,6711.216796875,-105.85443878174),dist=100,nonRP=false,setBit=false,interior=true},
    {colour=2,id=1,pos=vector3(-335.19680786133,-699.10406494141,33.036075592041),dist=30,nonRP=false,setBit=false},
    {colour=2,id=1,pos=vector3(-1671.5692138672,-912.63940429688,8.2297477722168),dist=50,nonRP=false,setBit=false},
    {colour=2,id=1,pos=vector3(337.64172363281,-1393.6368408203,32.509204864502),dist=50,nonRP=false,setBit=false},
    {colour=2,id=1,pos=vector3(-2335.1215820313,266.88153076172,169.60194396973),dist=50,nonRP=false,setBit=false}
}
local k={
    {vector3(333.91488647461,-597.16156005859,29.292747497559),40.0,2,180},
    {vector3(150.11642456055,-1039.6853027344,29.367973327637),25.0,2,180},
    {vector3(-110.09871673584,6464.6030273438,31.62672996521),20.0,2,180},
    {vector3(-1079.5734863281,-843.14739990234,4.8841333389282),45.0,2,180},
    {vector3(-2181.7966308594,5189.8286132813,17.64377784729),150.0,2,180},
    {vector3(-540.54748535156,-216.42681884766,37.64966583252),50.0,2,180},
    {vector3(246.30143737793,-782.50170898438,30.573167800903),40.0,2,180},
    {vector3(-335.19680786133,-699.10406494141,33.036075592041),30.0,2,180},
    {vector3(-1671.5692138672,-912.63940429688,8.2297477722168),50.0,2,180},
    {vector3(1468.5318603516,6328.529296875,18.894895553589),100.0,1,180},
    {vector3(4982.5634765625,-5175.1079101562,2.4887988567352),120.0,1,180},
    {vector3(5115.7465820312,-4623.2915039062,2.642692565918),85.0,1,180},
    {vector3(337.64172363281,-1393.6368408203,32.509204864502),50.0,2,180},
    {vector3(-2335.1215820313,266.88153076172,169.60194396973),50.0,2,180}
}
local l=Citizen.CreateThread
local m=Citizen.Wait
local SetEntityInvincible=SetEntityInvincible
local SetPlayerInvincible=SetPlayerInvincible
local ClearPedBloodDamage=ClearPedBloodDamage
local ResetPedVisibleDamage=ResetPedVisibleDamage
local ClearPedLastWeaponDamage=ClearPedLastWeaponDamage
local SetEntityProofs=SetEntityProofs
local SetEntityCanBeDamaged=SetEntityCanBeDamaged
local NetworkSetFriendlyFireOption=NetworkSetFriendlyFireOption
local GetEntityCoords=GetEntityCoords
local SetEntityNoCollisionEntity=SetEntityNoCollisionEntity
local SetPedCanRagdoll=SetPedCanRagdoll
local SetPedCanRagdollFromPlayerImpact=SetPedCanRagdollFromPlayerImpact
local SetEntityMaxSpeed=SetEntityMaxSpeed
local GetEntityModel=GetEntityModel
local SetEntityCollision=SetEntityCollision
local DisableControlAction=DisableControlAction
local GetVehiclePedIsIn=GetVehiclePedIsIn
function tARMA.areGreenzonesDisabled()
    return i 
end
function tARMA.setGreenzonesDisabled(n)
    i=n 
end
l(function()
    for o,p in pairs(k)do 
        local q=AddBlipForRadius(p[1].x,p[1].y,p[1].z,p[2])
        SetBlipColour(q,p[3])
        SetBlipAlpha(q,p[4])
    end 
end)
l(function()
    while true do 
        local r=tARMA.getPlayerPed()
        local s=tARMA.getPlayerCoords()
        for t,u in pairs(j)do 
            local v=#(s-u.pos)while v<u.dist do 
                local s=tARMA.getPlayerCoords()
                v=#(s-u.pos)
                if u.nonRP then 
                    c=true 
                else 
                    if not u.setBit then 
                        b=true
                        d=true
                        e=false
                        f=5
                        u.setBit=true 
                    end
                    if u.interior then 
                        setDrawGreenInterior=true 
                    end 
                end
                m(100)
            end
            if u.setBit then 
                d=false
                e=true
                f=5
                u.setBit=false 
            end
            c=false
            b=false
            d=false
            setDrawGreenInterior=false
            SetEntityInvincible(r,false)
            SetPlayerInvincible(tARMA.getPlayerId(),false)
            ClearPedBloodDamage(r)
            ResetPedVisibleDamage(r)
            ClearPedLastWeaponDamage(r)
            SetEntityProofs(r,false,false,false,false,false,false,false,false)
            SetEntityCanBeDamaged(r,true)
            Citizen.InvokeNative(0x5FFE9B4144F9712F,false)
            SetNetworkVehicleAsGhost(tARMA.getPlayerVehicle(),false)
        end
        m(250)
    end 
end)
Citizen.CreateThread(function()
	local y=function(z)
		inCityZone=true 
	end
	local A=function(z)
		inCityZone=false 
	end
	local B=function(z)
	end
	tARMA.createArea("cityzone",vector3(-225.30703735352,-916.74755859375,31.216938018799),750.0,100,y,A,B,{})
end)
l(function()
    while true do 
        local r=PlayerPedId()
        local C=GetVehiclePedIsIn(r,false)
        SetVehicleAutoRepairDisabled(C,true)
        local Sped = tARMA.GetRPZoneInfo()
        if not tARMA.areGreenzonesDisabled()then 
            isInGreenzone=b or c
            local D=GetActivePlayers()
            if b or c then 
                local playerId=tARMA.getPlayerId()
                if Sped~=nil then
                    SetEntityMaxSpeed(C,Sped.vehicles.speed/2.236936)
                else
                    SetEntityMaxSpeed(C,a.maxSpeeds["50"])
                end
                Citizen.InvokeNative(0x5FFE9B4144F9712F,true)
                SetNetworkVehicleAsGhost(C,true)
                SetEntityAlpha(tARMA.getPlayerVehicle(),255)
                SetEntityAlpha(r,255)
                for E,F in pairs(D)do 
                    local G=GetPlayerPed(F)
                    local H=GetVehiclePedIsIn(G,true)
                    SetEntityAlpha(G,255)
                    SetEntityAlpha(H,255)
                end
                SetEntityInvincible(r,true)
                SetPlayerInvincible(playerId,true)
                ClearPedBloodDamage(r)
                if usingDelgun then 
                    tARMA.setWeapon(r,`WEAPON_SPEEDGUNBW`,true)
                else 
                    tARMA.setWeapon(r,`WEAPON_UNARMED`,true)
                end
                ResetPedVisibleDamage(r)
                ClearPedLastWeaponDamage(r)
                SetEntityProofs(r,true,true,true,true,true,true,true,true)
                SetEntityCanBeDamaged(r,false)
                SetPedCanRagdoll(r,false)
                SetPedCanRagdollFromPlayerImpact(r,false)
            else 
                SetPedCanRagdoll(r,true)
                SetPedCanRagdollFromPlayerImpact(r,true)
                if C~=0 then 
                    SetEntityCollision(C,true,true)
                    local I=GetEntityModel(C)
                    if Sped~=nil then
                        SetEntityMaxSpeed(C,Sped.vehicles.speed/2.236936)
                    else
                        if not inCityZone then 
                            if a.vehicleMaxSpeeds[I]~=nil then 
                                SetEntityMaxSpeed(C,a.maxSpeeds[a.vehicleMaxSpeeds[I]])
                            else 
                                SetEntityMaxSpeed(C,a.maxSpeeds["250"])
                            end 
                        else 
                            SetEntityMaxSpeed(C,a.maxSpeeds["100"])
                        end 
                    end
                end 
            end
            if d and g==false then 
				exports['arma-notify']:DoHudText('success', "You have entered the greenzone")
                g=true
                h=false 
            end
            if e and h==false then 
				exports['arma-notify']:DoHudText('error', "You have left the greenzone")
                h=true
                g=false 
            end
            if b then 
                DisableControlAction(2,37,true)
                DisablePlayerFiring(playerId,true)
                DisableControlAction(0,106,true)
                DisableControlAction(0,45,true)
                DisableControlAction(0,24,true)
                DisableControlAction(0,263,true)
                DisableControlAction(0,140,true)
            end
            if c then 
                drawNativeText("You have entered a non-RP greenzone, you may talk out of character here")
                DisableControlAction(2,37,true)
                DisablePlayerFiring(playerId,true)
                DisableControlAction(0,45,true)
                DisableControlAction(0,24,true)
                DisableControlAction(0,263,true)
                DisableControlAction(0,140,true)
            end
            if setDrawGreenInterior then 
                DisableControlAction(0,106,true)
                DisableControlAction(0,45,true)
                DisableControlAction(0,24,true)
                DisableControlAction(0,263,true)
                DisableControlAction(0,140,true)
                DisableControlAction(0,22,true)
            end 
        end
        m(0)
    end 
end)