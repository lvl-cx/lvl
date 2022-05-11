
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
      local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
      LVLserver.updatePos({x,y,z})
      LVLserver.updateHealth({tLVL.getHealth()})
      LVLserver.updateArmour({GetPedArmour(PlayerPedId())})
      LVLserver.updateWeapons({tLVL.getWeapons()})
      LVLserver.updateCustomization({tLVL.getCustomization()})
    end
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

function tLVL.getWeaponTypes()
  return weapon_types
end

function tLVL.getWeapons()
  local player = GetPlayerPed(-1)

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

function tLVL.giveWeapons(weapons,clear_before)
  local player = GetPlayerPed(-1)

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
function tLVL.dropWeapon()
  SetPedDropsWeapon(GetPlayerPed(-1))
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

function tLVL.getDrawables(part)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1),index)
  else
    return GetNumberOfPedDrawableVariations(GetPlayerPed(-1),index)
  end
end

function tLVL.getDrawableTextures(part,drawable)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropTextureVariations(GetPlayerPed(-1),index,drawable)
  else
    return GetNumberOfPedTextureVariations(GetPlayerPed(-1),index,drawable)
  end
end

function tLVL.getCustomization()
  local ped = GetPlayerPed(-1)

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

function tLVL.getCustomization2()
  local ped = GetPlayerPed(-1)

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
function tLVL.setCustomization(custom) -- indexed [drawable,texture,palette] components or props (p0...) plus .modelhash or .model
  local exit = TUNNEL_DELAYED() -- delay the return values

  Citizen.CreateThread(function() -- new thread
    if custom then
      local ped = GetPlayerPed(-1)
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
          local weapons = tLVL.getWeapons()
          if GetEntityModel(PlayerPedId()) ~= GetHashKey("mp_m_freemode_01") then
            SetPlayerModel(PlayerId(), mhash)
          end
          tLVL.giveWeapons(weapons,true)
          SetModelAsNoLongerNeeded(mhash)
        end
      end

      ped = GetPlayerPed(-1)

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

-- fix invisible players by resetting customization every minutes
--[[
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(60000)
    if state_ready then
      local custom = tLVL.getCustomization()
      custom.model = nil
      custom.modelhash = nil
      tLVL.setCustomization(custom)
    end
  end
end)
--]]
