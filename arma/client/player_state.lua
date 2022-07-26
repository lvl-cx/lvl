
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
      ARMAserver.updatePos({x,y,z})
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

-- def
local weapon_types = {
-- Small Arms
"WEAPON_M1911",
"WEAPON_BERETTA",
"WEAPON_REVOLVERS",
"WEAPON_MAC11",

-- Rebel Trader
"WEAPON_VANDALG",
"WEAPON_ar15",
"WEAPON_M16A1",
"WEAPON_DEAGLE",

-- LARGE ARMS
"WEAPON_PPSH",
"WEAPON_UMP45",
"WEAPON_ITACHA",
"WEAPON_LR300",

-- SHANK
"WEAPON_KITCHENKNIFE",
"WEAPON_FIREAXE",
"WEAPON_RAMBO",
"WEAPON_SHOVEL",
"WEAPON_BASEBALLBAT",
}

function tARMA.spawnAnim(a)
  local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
  TriggerEvent("arma:PlaySound", "gtaloadin")
  SetFocusPosAndVel(x,y,z+1000)
  local spawnCam3 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", x,y,z+1000, 0.0, 0.0, 0.0, 65.0, 0, 2)
  SetCamActive(spawnCam3, true)
  DestroyCam(spawnCam, 0)
  DestroyCam(spawnCam2, 0)
  RenderScriptCams(true, true, 0, 1, 0, 0)
  local spawnCam4 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", x,y,z, 0.0, 0.0, 0.0, 65.0, 0, 2)
  SetCamActiveWithInterp(spawnCam4, spawnCam3, 5000, 0, 0)
  Wait(2500)
  ClearFocus()
  Wait(2000)
  FreezeEntityPosition(PlayerPedId(),false)
  DestroyCam(spawnCam3)
  DestroyCam(spawnCam4)
  RenderScriptCams(false, true, 2000, 0, 0)
  TriggerScreenblurFadeOut(2000.0)
  ExecuteCommand("showui")
  tARMA.setCustomization(a)
end

function tARMA.getWeaponTypes()
  return weapon_types
end

function tARMA.getWeapons()
  local player = PlayerPedId()

  local ammo_types = {} -- remember ammo type to not duplicate ammo amount

  local weapons = {}
  for k,v in pairs(weapon_types) do
    local hash = GetHashKey(v)
    if HasPedGotWeapon(player,hash) then
      local weapon = {}
      weapons[v] = weapon

      local atype = Citizen.InvokeNative(0x7FEAD38B326B9F74, player, hash)
      if ammo_types[atype] == nil then
        ammo_types[atype] = true
        weapon.ammo = GetAmmoInPedWeapon(player,hash)
      else
        weapon.ammo = 0
      end
    end
  end

  return weapons
end

function tARMA.giveWeapons(weapons,clear_before)
  local player = PlayerPedId()

  -- give weapons to player

  if clear_before then
    RemoveAllPedWeapons(player,true)
  end

  for k,weapon in pairs(weapons) do
    local hash = GetHashKey(k)
    local ammo = weapon.ammo or 0

    GiveWeaponToPed(player, hash, ammo, false)
  end
  return true
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

function tARMA.getDrawables(part)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropDrawableVariations(PlayerPedId(),index)
  else
    return GetNumberOfPedDrawableVariations(PlayerPedId(),index)
  end
end

function tARMA.getDrawableTextures(part,drawable)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropTextureVariations(PlayerPedId(),index,drawable)
  else
    return GetNumberOfPedTextureVariations(PlayerPedId(),index,drawable)
  end
end

function tARMA.getCustomization()
  local ped = PlayerPedId()

  local custom = {}

  custom.modelhash = GetEntityModel(ped)

  -- ped parts
  for i=0,20 do -- index limit to 20
    custom[i] = {GetPedDrawableVariation(ped,i), GetPedTextureVariation(ped,i), GetPedPaletteVariation(ped,i)}
  end

  -- props
  for i=0,10 do -- index limit to 10
    custom["p"..i] = {GetPedPropIndex(ped,i), math.max(GetPedPropTextureIndex(ped,i),0)}
  end

  return custom
end

function tARMA.getCustomization2()
  local ped = PlayerPedId()

  local custom = {}

  custom.modelhash = GetEntityModel(ped)

  -- ped parts


  for i=0,6 do -- index limit to 20
    custom[i] = {GetPedDrawableVariation(ped,i), GetPedTextureVariation(ped,i), GetPedPaletteVariation(ped,i)}
  end


    custom[8] = {GetPedDrawableVariation(ped,8), GetPedTextureVariation(ped,8), GetPedPaletteVariation(ped,8)}
    for i=10,20 do -- index limit to 20
      custom[i] = {GetPedDrawableVariation(ped,i), GetPedTextureVariation(ped,i), GetPedPaletteVariation(ped,i)}
    end

  -- props
  for i=0,5 do -- index limit to 10
    custom["p"..i] = {GetPedPropIndex(ped,i), math.max(GetPedPropTextureIndex(ped,i),0)}
  end
  for i=7,10 do -- index limit to 10
    custom["p"..i] = {GetPedPropIndex(ped,i), math.max(GetPedPropTextureIndex(ped,i),0)}
  end

  return custom
end

-- partial customization (only what is set is changed)
function tARMA.setCustomization(custom) -- indexed [drawable,texture,palette] components or props (p0...) plus .modelhash or .model
  local exit = TUNNEL_DELAYED() -- delay the return values

  Citizen.CreateThread(function() -- new thread
    if custom then
      local ped = PlayerPedId()
      local mhash = nil

      -- model
      if custom.modelhash ~= nil then
        mhash = custom.modelhash
      elseif custom.model ~= nil then
        mhash = GetHashKey(custom.model)
      end

      if mhash ~= nil then
        local i = 0
        while not HasModelLoaded(mhash) and i < 10000 do
          RequestModel(mhash)
          Citizen.Wait(10)
        end

        if HasModelLoaded(mhash) then
          -- changing player model remove weapons, so save it
          local weapons = tARMA.getWeapons()
          if GetEntityModel(PlayerPedId()) ~= GetHashKey("mp_m_freemode_01") then
            SetPlayerModel(PlayerId(), mhash)
          end
          tARMA.giveWeapons(weapons,true)
          SetModelAsNoLongerNeeded(mhash)
        end
      end

      ped = PlayerPedId()

      -- parts
      for k,v in pairs(custom) do
        if k ~= "model" and k ~= "modelhash" then
          local isprop, index = parse_part(k)
          if isprop then
            if v[1] < 0 then
              ClearPedProp(ped,index)
            else
              SetPedPropIndex(ped,index,v[1],v[2],v[3] or 2)
            end
          else
            SetPedComponentVariation(ped,index,v[1],v[2],v[3] or 2)
          end
        end
      end
    end

    exit({})
  end)
end