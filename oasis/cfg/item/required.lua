
local items = {}
local a = module("oasis-weapons", "cfg/weapons")

items["repairkit"] = {"Repair Kit","Used to repair vehicles.",nil,0.5}
items["Headbag"] = {"Head Bag","Used to cover someone's head.",nil,0.5}
items["Shaver"] = {"Shaver","Used to shave someone's head.",nil,0.5}
items["handcuffkeys"] = {"Handcuff Keys","Used to uncuff someone.",nil,0.5}

-- give "wbody|WEAPON_PISTOL" and "wammo|WEAPON_PISTOL" to have pistol body and pistol bullets

local get_wname = function(weapon_id)
  for k,v in pairs(a.weapons) do
    if k == weapon_id then
      return v.name
    end
  end
end

--- weapon body
local wbody_name = function(args)
  return get_wname(args[2])
end

local wbody_desc = function(args)
  return ""
end

local wbody_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")

  choices["Equip"] = {function(player,choice)
    local user_id = OASIS.getUserId(player)
    if user_id ~= nil then
      if OASIS.tryGetInventoryItem(user_id, fullidname, 1, true) then
        local weapons = {}
        weapons[args[2]] = {ammo = 0}
        for k,v in pairs(a.weapons) do
          if k == args[2] then
            if v.policeWeapon then
              if OASIS.hasPermission(user_id, 'police.onduty.permission') then
                OASISclient.giveWeapons(player, {weapons, false})
              else
                OASISclient.notify(player, {'~r~You cannot equip this weapon.'})
              end
            else
              OASISclient.giveWeapons(player, {weapons, false})
            end
          end
        end
      end
    end
  end}

  return choices
end

local wbody_weight = function(args)
  for k,v in pairs(a.weapons) do
    for c,d in pairs(args) do
      if k == d then
        if v.class == "Melee" then
          return 1.00
        elseif v.class == "Pistol" then
          return 5.00
        elseif v.class == "SMG" or v.class == "Shotgun" then
          return 7.50
        elseif v.class == "AR" then
          return 10.00
        elseif v.class == "Heavy" or v.class == "LMG" then
          return 15.00
        else
          return 1.00
        end
      end
    end
  end
end

items["wbody"] = {wbody_name,wbody_desc,wbody_choices,wbody_weight}

--- weapon ammo
local wammo_name = function(args)
  --print('helloo', json.encode(args))
  return args[1]
end

local wammo_desc = function(args)
  return ""
end

local wammo_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")
  local ammotype = nil;
  ammotype = args[1]

  choices["Load"] = {function(player,choice)
    local user_id = OASIS.getUserId(player)
    if user_id ~= nil then
      local amount = OASIS.getInventoryItemAmount(user_id, fullidname)
      if string.find(fullidname, "Police") and not OASIS.hasPermission(user_id, 'police.onduty.permission') then
        OASISclient.notify(player, {'~r~You cannot load this ammo.'})
        local bulletAmount = OASIS.getInventoryItemAmount(user_id, fullidname)
        OASIS.tryGetInventoryItem(user_id, fullidname, bulletAmount, false)
        return
      end
      OASIS.prompt(player, "Amount to load ? (max "..amount..")", "", function(player,ramount)
        ramount = parseInt(ramount)
        OASISclient.getWeapons(player, {}, function(uweapons) -- gets current weapons
          for k,v in pairs(a.weapons) do -- goes through new weapons cfg
            for c,d in pairs(uweapons) do -- goes through current weapons
              if k == c then  -- if weapon in new cfg is the same as in current weapons
                if fullidname == v.ammo then -- check if ammo being loaded is the same as the ammo for that gun
                  if OASIS.tryGetInventoryItem(user_id, fullidname, ramount, true) then -- take ammo from inv
                    local weapons = {}
                    weapons[k] = {ammo = ramount}
                    OASISclient.giveWeapons(player, {weapons,false})
                    TriggerEvent('OASIS:RefreshInventory', player)
                    return
                  end
                end
              end
            end
          end
        end)
      end)
    end
  end}
  choices["LoadAll"] = {function(player,choice)
    local user_id = OASIS.getUserId(player)
    if user_id ~= nil then
      ramount = parseInt(OASIS.getInventoryItemAmount(user_id, fullidname))
      if ramount > 250 then ramount = 250 end
      if string.find(fullidname, "Police") and not OASIS.hasPermission(user_id, 'police.onduty.permission') then
        OASISclient.notify(player, {'~r~You cannot load this ammo.'})
        local bulletAmount = OASIS.getInventoryItemAmount(user_id, fullidname)
        OASIS.tryGetInventoryItem(user_id, fullidname, bulletAmount, false)
        return
      end
      OASISclient.getWeapons(player, {}, function(uweapons) -- gets current weapons
        for k,v in pairs(a.weapons) do -- goes through new weapons cfg
          for c,d in pairs(uweapons) do -- goes through current weapons
            if k == c then  -- if weapon in new cfg is the same as in current weapons
              if fullidname == v.ammo then -- check if ammo being loaded is the same as the ammo for that gun
                if OASIS.tryGetInventoryItem(user_id, fullidname, ramount, true) then -- take ammo from inv
                  local weapons = {}
                  weapons[k] = {ammo = ramount}
                  OASISclient.giveWeapons(player, {weapons,false})
                  TriggerEvent('OASIS:RefreshInventory', player)
                  return
                end
              end
            end
          end
        end
      end)
    end
  end}

  return choices
end

local wammo_weight = function(args)
  return 0.01
end

for i,v in pairs(OASISAmmoTypes) do
  items[i] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}
end

items["wammo"] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}

return items
