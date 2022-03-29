
local items = {}

items["medkit"] = {"Medical Kit","Used to reanimate unconscious people.",nil,0.5}
items["dirty_money"] = {"Dirty money","Illegally earned money.",nil,0}
items["parcels"] = {"Parcels","Parcels to deliver",nil,0.10}
items["repairkit"] = {"Repair Kit","Used to repair vehicles.",nil,0.5}


-- money
items["money"] = {"Money","Packed money.",function(args)
  local choices = {}
  local idname = args[1]

  choices["Unpack"] = {function(player,choice,mod)
    local user_id = Sentry.getUserId(player)
    if user_id ~= nil then
      local amount = Sentry.getInventoryItemAmount(user_id, idname)
      Sentry.prompt(player, "How much to unpack ? (max "..amount..")", "", function(player,ramount)
        ramount = parseInt(ramount)
        if Sentry.tryGetInventoryItem(user_id, idname, ramount, true) then -- unpack the money
          Sentry.giveMoney(user_id, ramount)
          Sentry.closeMenu(player)
        end
      end)
    end
  end}

  return choices
end,0}

-- money binder
items["money_binder"] = {"Money binder","Used to bind 1000$ of money.",function(args)
  local choices = {}
  local idname = args[1]

  choices["Bind money"] = {function(player,choice,mod) -- bind the money
    local user_id = Sentry.getUserId(player)
    if user_id ~= nil then
      local money = Sentry.getMoney(user_id)
      if money >= 1000 then
        if Sentry.tryGetInventoryItem(user_id, idname, 1, true) and Sentry.tryPayment(user_id,1000) then
          Sentry.giveInventoryItem(user_id, "money", 1000, true)
          Sentry.closeMenu(player)
        end
      else
        Sentryclient.notify(player,{Sentry.lang.money.not_enough()})
      end
    end
  end}

  return choices
end,0}

-- parametric weapon items
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
    local user_id = Sentry.getUserId(player)
    if user_id ~= nil then
      if Sentry.tryGetInventoryItem(user_id, fullidname, 1, true) then -- give weapon body
        local weapons = {}
        weapons[args[2]] = {ammo = 0}
        Sentryclient.giveWeapons(player, {weapons})

        Sentry.closeMenu(player)
      end
    end
  end}

  return choices
end

local wbody_weight = function(args)
  return 0.75
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
    local user_id = Sentry.getUserId(player)
    if user_id ~= nil then
      local amount = Sentry.getInventoryItemAmount(user_id, fullidname)
      TriggerClientEvent('checkAmmo', player)
      Sentry.prompt(player, "Amount to load ? (max "..amount..")", "", function(player,ramount)
        ramount = parseInt(ramount)

        Sentryclient.getWeapons(player, {}, function(uweapons)
            for i,v in pairs(SentryAmmoTypes[ammotype]) do
                if uweapons[v] ~= nil then -- check if the weapon is equiped
                
                      if Sentry.tryGetInventoryItem(user_id, fullidname, ramount, true) then -- give weapon ammo
                        local weapons = {}
                        weapons[v] = {ammo = ramount}
                        Sentryclient.giveWeapons(player, {weapons,false})
                        Sentry.closeMenu(player)
                        TriggerEvent('Sentry:RefreshInventory', player)
                        return
                      end
      
                    end
         
            end
            --Sentryclient.notify(player,{'~r~You do not have any guns that fit this ammo type.'})
        end)
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


for i,v in pairs(SentryAmmoTypes) do
  print(i)
  
  items[i] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}
  
end

--local wammo_name = function(args)
--  for i,v in pairs(SentryAmmoTypes) do
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
