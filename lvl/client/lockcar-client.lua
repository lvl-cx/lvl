RegisterCommand('lockcar', function()
    local veh, name, nveh = tLVL.getNearestOwnedVehicle(5)
    if veh then 
        tLVL.vc_toggleLock(name)
        tLVL.playSound("HUD_MINI_GAME_SOUNDSET", "5_SEC_WARNING")
    end
end)

RegisterKeyMapping('lockcar', 'Locks and unlocks your vehicle', 'KEYBOARD', 'F3')