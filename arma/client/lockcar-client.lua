RegisterCommand('lockcar', function()
    local veh, name, nveh = tARMA.getNearestOwnedVehicle(5)
    if veh then 
        tARMA.vc_toggleLock(name)
        tARMA.playSound("HUD_MINI_GAME_SOUNDSET", "5_SEC_WARNING")
    end
end)

RegisterKeyMapping('lockcar', 'Locks and unlocks your vehicle', 'KEYBOARD', 'COMMA')