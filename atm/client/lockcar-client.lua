RegisterCommand('lockcar', function()
    local veh, name, nveh = tATM.getNearestOwnedVehicle(5)
    if veh then 
        tATM.vc_toggleLock(name)
        tATM.playSound("HUD_MINI_GAME_SOUNDSET", "5_SEC_WARNING")
    end
end)

RegisterKeyMapping('lockcar', 'Locks and unlocks your vehicle', 'KEYBOARD', 'F3')