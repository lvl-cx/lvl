RegisterNetEvent("ARMA:CLOSE_DEATH_SCREEN", function()
    TriggerServerEvent('ARMA:DeathScreenClosed')
    SendNUIMessage({
        app = "",
        type = "APP_TOGGLE",
    })
    SetNuiFocus(false, false)
end)

RegisterNetEvent("ARMA:respawnKeyPressed", function()
    SendNUIMessage({
        page = "deathscreen",
        type = "RESPAWN_KEY_PRESSED",
    })
end)

RegisterNetEvent("ARMA:SHOW_DEATH_SCREEN", function(timer, killer, killerPermId, killedByWeapon,suicide)
    SendNUIMessage({
        page = "deathscreen",
        type = "SHOW_DEATH_SCREEN",
        info = {
            timer = timer,
            killer = killer,
            killerPermId = killerPermId,
            killedByWeapon = killedByWeapon,
            suicide = suicide,
        }
    })
    -- SetNuiFocus(true, true)
end)

RegisterNetEvent("ARMA:DEATH_SCREEN_NHS_CALLED", function()
    SendNUIMessage({
        page = "deathscreen",
        type = "DEATH_SCREEN_NHS_CALLED",
    })
end)

RegisterNUICallback('countdownEnded', function()
    TriggerEvent("ARMA:countdownEnded")
end)