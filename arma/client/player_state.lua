
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

local userdata = {}
Citizen.CreateThread(function()
    print("[ARMA] Loading cached user data.")
    userdata = json.decode(GetResourceKvpString("arma_userdata") or "{}")
    if type(userdata) ~= "table" then
      userdata = {}
        print("[ARMA] Loading cached user data - failed to load setting to default.")
    else
        print("[ARMA] Loading cached user data - loaded.")
    end
end)
function tARMA.updateCustomization(b)
    local c = tARMA.getCustomization()
    if c.modelhash ~= 0 and IsModelValid(c.modelhash) then
      userdata.customisation = c
      if b then
        SetResourceKvp("arma_userdata", json.encode(userdata))
      end
    end
end
Citizen.CreateThread(function()
    Wait(30000)
    while true do
        Wait(5000)
        --if not globalInPrison and not tARMA.isStaffedOn() and not tARMA.isPlayerInAnimalForm() and not tARMA.isInPaintball()
        if not tARMA.isStaffedOn() and not customizationSaveDisabled and not spawning then
            tARMA.updateCustomization(true)
        end
        SetResourceKvp("arma_userdata", json.encode(userdata))
    end
end)

function tARMA.checkCustomization()
    local c = userdata.customisation
    if c == nil or c.modelhash == 0 or not IsModelValid(c.modelhash) then
        tARMA.setCustomization(getDefaultCustomization())
    else
        tARMA.setCustomization(c)
    end
end

function getDefaultCustomization()
  local s = {}
  s = {}
  s.model = "mp_m_freemode_01"
  for t = 0, 19 do
      s[t] = {0, 0}
  end
  s[0] = {0, 0}
  s[1] = {0, 0}
  s[2] = {47, 0}
  s[3] = {5, 0}
  s[4] = {4, 0}
  s[5] = {0, 0}
  s[6] = {7, 0}
  s[7] = {51, 0}
  s[8] = {0, 240}
  s[9] = {0, 1}
  s[10] = {0, 0}
  s[11] = {5, 0}
  s[12] = {4, 0}
  s[15] = {0, 2}
  return s
end
AddEventHandler("ARMA:playGTAIntro",function()
  if not tARMA.isDevMode() then
      SendNUIMessage({transactionType = "gtaloadin"})
  end
end)