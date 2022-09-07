
-- periodic player state update
local a = module("cfg/cfg_clothing")
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
      if not tARMA.isInHome() then
        ARMAserver.updatePos({x,y,z})
      end
      ARMAserver.updateHealth({tARMA.getHealth()})
      ARMAserver.updateArmour({GetPedArmour(PlayerPedId())})
      ARMAserver.updateWeapons({tARMA.getWeapons()})
      if not customizationSaveDisabled then
        ARMAserver.updateCustomization({tARMA.getCustomization()})
      end
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
    ExecuteCommand("hideui")
    TriggerServerEvent('ARMA:changeHairstyle')
    TriggerServerEvent('ARMA:changeTattoos')
    local g = b
    RequestCollisionAtCoord(g.x, g.y, g.z)
    SetEntityCoordsNoOffset(PlayerPedId(), g.x, g.y, g.z, true, false, false)
    SetEntityVisible(PlayerPedId(), false, false)
    FreezeEntityPosition(PlayerPedId(), true)
    local h = GetGameTimer()
    while (not HaveAllStreamingRequestsCompleted(PlayerPedId()) or GetNumberOfStreamingRequests() > 0) and
        GetGameTimer() - h < 10000 do
        Wait(0)
        --print("Waiting for streaming requests to complete!")
    end
    if not tARMA.isDevMode() then
      TriggerEvent("arma:PlaySound", "gtaloadin")
      SetFocusPosAndVel(g.x, g.y, g.z+1000)
      local spawnCam3 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", g.x, g.y, g.z+1000, 0.0, 0.0, 0.0, 65.0, 0, 2)
      SetCamActive(spawnCam3, true)
      DestroyCam(spawnCam, 0)
      DestroyCam(spawnCam2, 0)
      RenderScriptCams(true, true, 0, 1, 0, 0)
      local spawnCam4 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", g.x, g.y, g.z, 0.0, 0.0, 0.0, 65.0, 0, 2)
      SetCamActiveWithInterp(spawnCam4, spawnCam3, 5000, 0, 0)
      Wait(2500)
      ClearFocus()
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
    tARMA.setCustomization(a, true, true)
  end
  spawning = false
end

local a = module("cfg/cfg_clothing")
local function b(c)
    if type(c) == "string" and string.sub(c, 1, 1) == "p" then
        return true, tonumber(string.sub(c, 2))
    else
        return false, tonumber(c)
    end
end
function tARMA.getDrawables(d)
    local e, f = b(d)
    if e then
        return GetNumberOfPedPropDrawableVariations(PlayerPedId(), f)
    else
        return GetNumberOfPedDrawableVariations(PlayerPedId(), f)
    end
end
function tARMA.getDrawableTextures(d, g)
    local e, f = b(d)
    if e then
        return GetNumberOfPedPropTextureVariations(PlayerPedId(), f, g)
    else
        return GetNumberOfPedTextureVariations(PlayerPedId(), f, g)
    end
end
function tARMA.getCustomization()
    local h = PlayerPedId()
    local i = {}
    i.modelhash = GetEntityModel(h)
    for j = 0, 20 do
        i[j] = {GetPedDrawableVariation(h, j), GetPedTextureVariation(h, j), GetPedPaletteVariation(h, j)}
    end
    for j = 0, 10 do
        i["p" .. j] = {GetPedPropIndex(h, j), math.max(GetPedPropTextureIndex(h, j), 0)}
    end
    return i
end
function tARMA.setCustomization(i, k, l)
    if i then
      changingPed = true
        local h = PlayerPedId()
        local m = nil
        if i.modelhash ~= nil then
            m = i.modelhash
        elseif i.model ~= nil then
            m = GetHashKey(i.model)
        end
        local n = tARMA.loadModel(m)
        local o = GetEntityModel(h)
        if n then
            if o ~= n or k then
                local p = tARMA.getWeapons()
                local q = GetEntityHealth(h)
                SetPlayerModel(PlayerId(), m)
                Wait(0)
                tARMA.giveWeapons(p, true)
                if l == nil or l == false then
                    print("[ARMA] Customisation, setting health to ", q)
                    tARMA.setHealth(q)
                end
                TriggerServerEvent('ARMA:changeHairStyle')
                TriggerServerEvent('ARMA:changeTattoos')
                h = PlayerPedId()
            else
                print("[ARMA] Same model detected, not changing model.")
            end
            SetModelAsNoLongerNeeded(m)
            for r, s in pairs(i) do
                if r ~= "model" and r ~= "modelhash" then
                    if tonumber(r) then
                        r = tonumber(r)
                    end
                    local e, f = b(r)
                    if e then
                        if s[1] < 0 then
                            ClearPedProp(h, f)
                        else
                            SetPedPropIndex(h, f, s[1], s[2], s[3] or 2)
                        end
                    else
                        SetPedComponentVariation(h, f, s[1], s[2], s[3] or 2)
                    end
                end
            end
        else
            print("[ARMA] Failed to load model", m)
        end
        changingPed = false
    end
end

function tARMA.loadCustomisationPreset(t)
  local u = a.presets[t]
  assert(u, string.format("Preset %s does not exist.", t))
  if u.model then
      tARMA.setCustomization({modelhash = u.model})
      Citizen.Wait(100)
  end
  local v = PlayerPedId()
  if u.components then
      for w, x in pairs(u.components) do
          SetPedComponentVariation(v, w, x[1], x[2], x[3])
      end
  end
  if u.props then
      for y, z in pairs(u.props) do
          SetPedPropIndex(v, y, z[1], z[2], z[3])
      end
  end
end
SetVisualSettingFloat("ped.lod.distance.high", 200.0)
SetVisualSettingFloat("ped.lod.distance.medium", 400.0)
SetVisualSettingFloat("ped.lod.distance.low", 700.0)