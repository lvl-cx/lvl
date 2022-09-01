local cfg=module("armacore/cfg/cfg_respawn")

RegisterNetEvent("ARMA:OpenSpawnMenu")
AddEventHandler("ARMA:OpenSpawnMenu", function(location_table)
    DoScreenFadeIn(1000)
    TriggerScreenblurFadeIn(100.0)
    ExecuteCommand('hideui')
    SetPlayerControl(PlayerId(), 0, 0)
    FreezeEntityPosition(PlayerPedId(),true)
    SetFocusPosAndVel(675.57568359375,1107.1724853516,375.29666137695)
    spawnCam = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", 675.57568359375,1107.1724853516,375.29666137695, 0.0, 0.0, 0.0, 65.0, 0, 2)
    SetCamActive(spawnCam, true)
    RenderScriptCams(true, true, 0, 1, 0, 0)

    spawnCam2 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", -1024.6506347656,-2712.0234375,79.889106750488, 0.0, 0.0, 0.0, 65.0, 0, 2)

    SetCamActiveWithInterp(spawnCam2, spawnCam, 250000, 5, 5)
    local locations = {}
    for _, homeName in pairs(location_table) do
        table.insert(locations, cfg.spawnLocations[homeName[1]])
    end
    SendNUIMessage({
        type = "SET_SPAWN_LOCATIONS",
        info = {
            locations = locations
        }
    })
    SendNUIMessage({
        app = "spawn",
        type = "APP_TOGGLE",
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("respawnButtonClicked", function(data, cb)
    local name = data.location.name
    local price = tonumber(data.location.price)
    local spawnCoords =  cfg.spawnLocations[name].coords
    if price and price > 0 then
        TriggerServerEvent('ARMA:TakeAmount', price)
    end
    TriggerEvent("arma:PlaySound", "gtaloadin")
    SetEntityCoords(PlayerPedId(), spawnCoords)
    SendNUIMessage({
        app = "",
        type = "APP_TOGGLE",
    })
    SetNuiFocus(false, false)
    SetPlayerControl(PlayerId(), 1, 0)

    SetFocusPosAndVel(spawnCoords.x,spawnCoords.y,spawnCoords.z+1000)
    local spawnCam3 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", spawnCoords.x,spawnCoords.y,spawnCoords.z+1000, 0.0, 0.0, 0.0, 65.0, 0, 2)
    SetCamActive(spawnCam3, true)
    DestroyCam(spawnCam, 0)
    DestroyCam(spawnCam2, 0)
    RenderScriptCams(true, true, 0, 1, 0, 0)
    local spawnCam4 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", spawnCoords.x,spawnCoords.y,spawnCoords.z, 0.0, 0.0, 0.0, 65.0, 0, 2)
    SetCamActiveWithInterp(spawnCam4, spawnCam3, 5000, 0, 0)
    Wait(2500)
    ClearFocus()
    Wait(2000)
    FreezeEntityPosition(PlayerPedId(),false)
    DestroyCam(spawnCam3)
    DestroyCam(spawnCam4)
    RenderScriptCams(false, true, 2000, 0, 0)
    TriggerScreenblurFadeOut(2000.0)
    ExecuteCommand('showui')
    ClearFocus()
    cb()
end)

RegisterCommand("spawn", function()
    TriggerServerEvent('ARMA:SendSpawnMenu')
end)