
local items = {}
local a = module("cfg/weapons")

items["repairkit"] = {"Repair Kit","Used to repair vehicles.",nil,0.5}
items["headbag"] = {"Head Bag","Used to cover someone's head.",nil,0.5}
items["shaver"] = {"Shaver","Used to shave someone's head.",nil,0.5}

-- give "wbody|WEAPON_PISTOL" and "wammo|WEAPON_PISTOL" to have pistol body and pistol bullets

local get_wname = function(weapon_id)
  local name = string.gsub(weapon_id,"WEAPON_","")
  name = string.upper(string.sub(name,1,1))..string.lower(string.sub(name,2))
  return name
end

--- weapon body
local wbody_name = function(args)
  return get_wname(args[2]).." body"
end

local wbody_desc = function(args)
  return ""
end

local wbody_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")

  choices["Equip"] = {function(player,choice)
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil then
      if ARMA.tryGetInventoryItem(user_id, fullidname, 1, true) then -- give weapon body
        local weapons = {}
        weapons[args[2]] = {ammo = 0}
        ARMAclient.giveWeapons(player, {weapons})
        SetPedAmmo(GetPlayerPed(player), args[2], 0)
        ARMA.closeMenu(player)
      end
    end
  end}

  return choices
end

local wbody_weight = function(args)
  return 5.00
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
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil then
      local amount = ARMA.getInventoryItemAmount(user_id, fullidname)
      ARMA.prompt(player, "Amount to load ? (max "..amount..")", "", function(player,ramount)
        ramount = parseInt(ramount)
        ARMAclient.getWeapons(player, {}, function(uweapons) -- gets current weapons
          for k,v in pairs(a.weapons) do -- goes through new weapons cfg
            for c,d in pairs(uweapons) do -- goes through current weapons
              if k == c then  -- if weapon in new cfg is the same as in current weapons
                if fullidname == v.ammo then -- check if ammo being loaded is the same as the ammo for that gun
                  if ARMA.tryGetInventoryItem(user_id, fullidname, ramount, true) then -- take ammo from inv
                    local weapons = {}
                    weapons[k] = {ammo = ramount}
                    ARMAclient.giveWeapons(player, {weapons,false})
                    ARMA.closeMenu(player)
                    TriggerEvent('ARMA:RefreshInventory', player)
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
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil then
      ramount = parseInt(ARMA.getInventoryItemAmount(user_id, fullidname))
      ARMAclient.getWeapons(player, {}, function(uweapons) -- gets current weapons
        for k,v in pairs(a.weapons) do -- goes through new weapons cfg
          for c,d in pairs(uweapons) do -- goes through current weapons
            if k == c then  -- if weapon in new cfg is the same as in current weapons
              if fullidname == v.ammo then -- check if ammo being loaded is the same as the ammo for that gun
                if ARMA.tryGetInventoryItem(user_id, fullidname, ramount, true) then -- take ammo from inv
                  local weapons = {}
                  weapons[k] = {ammo = ramount}
                  ARMAclient.giveWeapons(player, {weapons,false})
                  ARMA.closeMenu(player)
                  TriggerEvent('ARMA:RefreshInventory', player)
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

RegisterNetEvent('sendAmmo')
AddEventHandler('sendAmmo', function(bool)
  hasWep = bool 
end)

local wammo_weight = function(args)
  return 0.01
end


for i,v in pairs(ARMAAmmoTypes) do
  
  items[i] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}
  
end

--local wammo_name = function(args)
--  for i,v in pairs(ARMAAmmoTypes) do
--     for a,d in pairs(v) do 
--        if d == args[2] then
--          return i
--        end
--     end
--  end
--  return args[1]
--end

items["wammo"] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}

return items
