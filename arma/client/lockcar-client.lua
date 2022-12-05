RegisterCommand('lockcar', function()
    local veh, name, nveh = tARMA.getNearestOwnedVehicle(5)
    if GetEntityHealth(tARMA.getPlayerPed()) > 102 then
        if veh then 
            tARMA.vc_toggleLock(name)
            tARMA.playSound("HUD_MINI_GAME_SOUNDSET", "5_SEC_WARNING")
        end
    else
        tARMA.notify("~r~You cannot lock a vehicle whilst you are dead.")
    end
end)

RegisterKeyMapping('lockcar', 'Locks and unlocks your vehicle', 'KEYBOARD', 'COMMA')