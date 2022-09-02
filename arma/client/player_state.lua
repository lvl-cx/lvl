
-- periodic player state update

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
      ARMAserver.updateCustomization({tARMA.getCustomization()})
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(60000)
    ARMAserver.UpdatePlayTime()
  end
end)

function tARMA.spawnAnim(a, b)
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
    TriggerScreenblurFadeOut(2000.0)
    SetEntityVisible(PlayerPedId(), true, false)
    FreezeEntityPosition(PlayerPedId(), false)
    ExecuteCommand("showui")
    tARMA.setCustomization(a)
  end
  spawning = false
end


--[[
function tARMA.dropWeapon()
  SetPedDropsWeapon(PlayerPedId())
end
--]]

-- PLAYER CUSTOMIZATION

-- parse part key (a ped part or a prop part)
-- return is_proppart, index
local function parse_part(key)
  if type(key) == "string" and string.sub(key,1,1) == "p" then
    return true,tonumber(string.sub(key,2))
  else
    return false,tonumber(key)
  end
end

local function a(b)
  if type(b)=="string"and string.sub(b,1,1)=="p"then 
      return true,tonumber(string.sub(b,2))
  else 
      return false,tonumber(b)
  end 
end
function tARMA.getDrawables(c)
  local d,e=a(c)
  if d then 
      return GetNumberOfPedPropDrawableVariations(PlayerPedId(),e)
  else 
      return GetNumberOfPedDrawableVariations(PlayerPedId(),e)
  end 
end
function tARMA.getDrawableTextures(c,f)
  local d,e=a(c)
  if d then 
      return GetNumberOfPedPropTextureVariations(PlayerPedId(),e,f)
  else 
      return GetNumberOfPedTextureVariations(PlayerPedId(),e,f)
  end 
end

function tARMA.getCustomization()
  local g=PlayerPedId()
  local h={}h.modelhash=GetEntityModel(g)
  for i=0,20 do 
      h[i]={GetPedDrawableVariation(g,i),GetPedTextureVariation(g,i),GetPedPaletteVariation(g,i)}
  end
  for i=0,10 do 
      h["p"..i]={GetPedPropIndex(g,i),math.max(GetPedPropTextureIndex(g,i),0)}
  end
  return h
end

function tARMA.setCustomization(h,j,k)
  if h then 
      local g=PlayerPedId()
      local l=nil
      if h.modelhash~=nil then 
          l=h.modelhash 
      elseif h.model~=nil then 
          l=GetHashKey(h.model)
      end
      local m=tARMA.loadModel(l)
      local n=GetEntityModel(g)
      if m then 
          if n~=m or j then
              local o=tARMA.getWeapons()
              local p=GetEntityHealth(g)
              local q=GetPedArmour(g)
              SetPlayerModel(PlayerId(),l)
              Wait(0)
              tARMA.giveWeapons(o,true)
              tARMA.setArmour(q)
              if k==nil or k==false then 
                print("[ARMA] Customisation change, setting health to ",p)
                tARMA.setHealth(p)
              end
              SetModelAsNoLongerNeeded(l)
              TriggerServerEvent('ARMA:changeHairStyle')
              TriggerServerEvent('ARMA:changeTattoos')
              g=PlayerPedId()
          end
          for r,s in pairs(h)do 
              if r~="model"and r~="modelhash"then 
                  if tonumber(r)then 
                      r=tonumber(r)
                  end
                  local d,e=a(r)
                  if d then 
                      if s[1]<0 then 
                          ClearPedProp(g,e)
                      else 
                          SetPedPropIndex(g,e,s[1],s[2],s[3]or 2)
                      end 
                  else 
                      SetPedComponentVariation(g,e,s[1],s[2],s[3]or 2)
                  end 
              end 
          end 
      else 
          print("[ARMA] Failed to load model",l)
      end 
  end 
end