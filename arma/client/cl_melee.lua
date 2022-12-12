local b=true
local c=false
RegisterCommand("togglemelee",function()
    if tARMA.getUserId()==1 or tARMA.getUserId()==2 then 
        c = not c
        tARMA.notify('Melee Combat: '..(c and "~g~Enabled" or "~r~Disabled"))
    end 
end)
function tARMA.enablePunching(d)
    c=d 
end
Citizen.CreateThread(function()
    tARMA.enablePunching(false)
    while true do 
        local e=PlayerPedId()
        local f=tARMA.getPlayerVehicle()
        local g=PlayerId()
        if not c then 
            if GetSelectedPedWeapon(e)==GetHashKey('WEAPON_UNARMED')then 
                DisableControlAction(0,263,true)
                DisableControlAction(0,264,true)
                DisableControlAction(0,257,true)
                DisableControlAction(0,140,true)
                DisableControlAction(0,141,true)
                DisableControlAction(0,142,true)
                DisableControlAction(0,143,true)
                DisableControlAction(0,24,true)
                DisableControlAction(0,25,true)
            end 
        end
        SetPlayerHealthRechargeMultiplier(e, 0.0)
        SetPedCanBeDraggedOut(e,false)
        SetPedConfigFlag(e,149,true)
        SetPedConfigFlag(e,438,true)
        SetPlayerTargetingMode(3)
        RestorePlayerStamina(g,1.0)
        if f~=0 and b then 
            if GetPedInVehicleSeat(f,0)==e then 
                if GetIsTaskActive(e,165)then 
                    SetPedIntoVehicle(e,f,0)
                end 
            end 
        end
        Wait(0)
    end 
end)
function disableSeatShuffle(d)
    b=d 
end
RegisterCommand("shuff",function(o,p,q)
    if IsPedInAnyVehicle(tARMA.getPlayerPed(),false) then 
        disableSeatShuffle(false)
        Citizen.Wait(5000)
        disableSeatShuffle(true)
    else 
        CancelEvent()
    end 
end,false)