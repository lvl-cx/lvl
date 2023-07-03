local a = module("cfg/cfg_clothing")
local function b(c)
    if type(c) == "string" and string.sub(c, 1, 1) == "p" then
        return true, tonumber(string.sub(c, 2))
    else
        return false, tonumber(c)
    end
end
function tOASIS.getDrawables(d)
    local e, f = b(d)
    if e then
        return GetNumberOfPedPropDrawableVariations(PlayerPedId(), f)
    else
        return GetNumberOfPedDrawableVariations(PlayerPedId(), f)
    end
end
function tOASIS.getDrawableTextures(d, g)
    local e, f = b(d)
    if e then
        return GetNumberOfPedPropTextureVariations(PlayerPedId(), f, g)
    else
        return GetNumberOfPedTextureVariations(PlayerPedId(), f, g)
    end
end
function tOASIS.getCustomization()
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
function tOASIS.setCustomization(i, k, l)
    if i then
      changingPed = true
        local h = PlayerPedId()
        local m = nil
        if i.modelhash ~= nil then
            m = i.modelhash
        elseif i.model ~= nil then
            m = GetHashKey(i.model)
        end
        local n = tOASIS.loadModel(m)
        local o = GetEntityModel(h)
        if n then
            if o ~= n or k then
                local p = tOASIS.getWeapons()
                local q = GetEntityHealth(h)
                SetPlayerModel(PlayerId(), m)
                Wait(0)
                tOASIS.giveWeapons(p, true)
                if l == nil or l == false then
                    print("[OASIS] Customisation, setting health to ", q)
                    tOASIS.setHealth(q)
                end
                TriggerServerEvent('OASIS:changeHairstyle')
                TriggerServerEvent('OASIS:getPlayerTattoos')
                h = PlayerPedId()
            else
                print("[OASIS] Same model detected, not changing model.")
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
            print("[OASIS] Failed to load model", m)
        end
        changingPed = false
    end
end

function tOASIS.loadCustomisationPreset(t)
  local u = a.presets[t]
  assert(u, string.format("Preset %s does not exist.", t))
  if u.model then
      tOASIS.setCustomization({modelhash = u.model})
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