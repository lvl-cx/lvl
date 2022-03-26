RegisterCommand('lockcar', function()
    local veh, name, nveh = tSentry.getNearestOwnedVehicle(5)
    if veh then 
        tSentry.vc_toggleLock(name)
        tSentry.playSound("HUD_MINI_GAME_SOUNDSET", "5_SEC_WARNING")
    end
end)

RegisterKeyMapping('lockcar', 'Locks and unlocks your vehicle', 'KEYBOARD', 'F3')