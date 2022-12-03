
local state_ready = false

AddEventHandler("playerSpawned",function() -- delay state recording
  Citizen.CreateThread(function()
    Citizen.Wait(2000)
    state_ready = true
  end)
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500)
    if IsPlayerPlaying(PlayerId()) and state_ready then
      local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
      if not tARMA.isInHouse() and not tARMA.isPlayerInRedZone() and not tARMA.isInSpectate() then
        ARMAserver.updatePos({x,y,z})
      end
      ARMAserver.updateHealth({tARMA.getHealth()})
      ARMAserver.updateArmour({GetPedArmour(PlayerPedId())})
      ARMAserver.updateWeapons({tARMA.getWeapons()})
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(60000)
    ARMAserver.UpdatePlayTime()
  end
end)

function tARMA.spawnAnim(a, b, c)
  if a ~= nil and b ~= nil then
    DoScreenFadeOut(250)
    ExecuteCommand("hideui")
    TriggerServerEvent('ARMA:changeHairstyle')
    TriggerServerEvent('ARMA:changeTattoos')
    local g = b
    Wait(500)
    TriggerScreenblurFadeIn(100.0)
    RequestCollisionAtCoord(g.x, g.y, g.z)
    NewLoadSceneStartSphere(g.x, g.y, g.z, 100.0, 2)
    SetEntityCoordsNoOffset(PlayerPedId(), g.x, g.y, g.z, true, false, false)
    SetEntityVisible(PlayerPedId(), false, false)
    FreezeEntityPosition(PlayerPedId(), true)
    local h = GetGameTimer()
    while (not HaveAllStreamingRequestsCompleted(PlayerPedId()) or GetNumberOfStreamingRequests() > 0) and
        GetGameTimer() - h < 10000 do
        Wait(0)
        print("Waiting for streaming requests to complete!")
    end
    NewLoadSceneStop()
    tARMA.checkCustomization()
    TriggerEvent("ARMA:playGTAIntro")
    DoScreenFadeIn(1000)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    if not tARMA.isDevMode() then
      SetFocusPosAndVel(g.x, g.y, g.z+1000)
      local spawnCam3 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", g.x, g.y, g.z+1000, 0.0, 0.0, 0.0, 65.0, 0, 2)
      SetCamActive(spawnCam3, true)
      RenderScriptCams(true, true, 0, 1, 0)
      local spawnCam4 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", g.x, g.y, g.z, 0.0, 0.0, 0.0, 65.0, 0, 2)
      SetCamActiveWithInterp(spawnCam4, spawnCam3, 5000, 0, 0)
      Wait(2500)
      ClearFocus()
      TriggerScreenblurFadeOut(2000.0)
      Wait(2000)
      DestroyCam(spawnCam3)
      DestroyCam(spawnCam4)
      RenderScriptCams(false, true, 2000, 0, 0)
    else
      TriggerScreenblurFadeOut(500.0)
    end
    print("[ARMA] cachedUserData.health", c)
    SetEntityHealth(PlayerPedId(), c or 200)
    SetEntityVisible(PlayerPedId(), true, false)
    FreezeEntityPosition(PlayerPedId(), false)
    if not tARMA.isDevMode() then
      Citizen.Wait(2000)
    end
    ExecuteCommand("showui")
  end
  spawning = false
end