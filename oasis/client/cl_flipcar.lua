local a=false
RegisterCommand("flipcar",function()
    local b,c=tOASIS.getPlayerVehicle()
    if b==0 then 
        tOASIS.notify("You are not in a vehicle")
        return 
    end
    if not c then 
        tOASIS.notify("You are not the driver of this vehicle")
        return 
    end
    if GetIsVehicleEngineRunning(b)then 
        tOASIS.notify("You must have the engine off to flip the vehicle")
        return 
    end
    if IsVehicleOnAllWheels(b)then 
        tOASIS.notify("Your vehicle does not require flipping")
        return 
    end
    if a then 
        tOASIS.notify("Your vehicle is already waiting to be flipped")
        return 
    end
    a=true
    tOASIS.notify("Flipping your vehicle in 30 seconds. Please remain stationary")
    local d=tOASIS.getPlayerPed()
    local e=GetEntityHealth(d)
    local f=GetGameTimer()
    while GetGameTimer()-f<30000 do 
        if tOASIS.getPlayerVehicle()~=b then 
            tOASIS.notify("Cancelling flip as you left the vehicle")
            a=false
            return 
        end
        if GetEntityHealth(d)~=e then 
            tOASIS.notify("Cancelling flip as you recieved damage")
            a=false
            return 
        end
        if GetEntitySpeed(b)>=4.4704 then 
            tOASIS.notify("Cancelling flip as you are not stationary")
            a=false
            return 
        end
        if GetIsVehicleEngineRunning(b)then 
            tOASIS.notify("Cancelling flip as you turned the engine on")
            a=false
            return 
        end
        Citizen.Wait(0)
    end
    SetVehicleOnGroundProperly(b)
    tOASIS.notify("Your vehicle has been flipped")
    a=false 
end)