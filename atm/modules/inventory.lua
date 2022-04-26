local lang = ATM.lang
local cfg = module("cfg/inventory")

-- this module define the player inventory (lost after respawn, as wallet)

ATM.items = {}

-- define an inventory item (call this at server start) (parametric or plain text data)
-- idname: unique item name
-- name: display name or genfunction
-- description: item description (html) or genfunction
-- choices: menudata choices (see gui api) only as genfunction or nil
-- weight: weight or genfunction
--
-- genfunction are functions returning a correct value as: function(args) return value end
-- where args is a list of {base_idname,arg,arg,arg,...}
function ATM.defInventoryItem(idname,name,description,choices,weight)
  if weight == nil then
    weight = 0
  end

  local item = {name=name,description=description,choices=choices,weight=weight}
  ATM.items[idname] = item

  -- build give action
  item.ch_give = function(player,choice)
  end

  -- build trash action
  item.ch_trash = function(player,choice)
    local user_id = ATM.getUserId(player)
    if user_id ~= nil then
      -- prompt number
    --   TriggerClientEvent('ATM:ToggleNUIFocus', player, false)
      ATM.prompt(player,lang.inventory.trash.prompt({ATM.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if ATM.tryGetInventoryItem(user_id,idname,amount,false) then
        --   TriggerClientEvent('ATM:ToggleNUIFocus', player, true)
          TriggerEvent('ATM:RefreshInventory', ATM.getUserSource(user_id))
          ATMclient.notify(player,{lang.inventory.trash.done({ATM.getItemName(idname),amount})})
          ATMclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          ATMclient.notify(player,{lang.common.invalid_value()})
        end
      end)
    end
  end
end

-- give action
function ch_give(idname, player, choice)
  local user_id = ATM.getUserId(player)
  if user_id ~= nil then
    -- get nearest player
    ATMclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = ATM.getUserId(nplayer)
        if nuser_id ~= nil then
          -- prompt number
          TriggerClientEvent('ATM:ToggleNUIFocus', player, false)
          ATM.prompt(player,lang.inventory.give.prompt({ATM.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
            local amount = parseInt(amount)
            -- weight check
            TriggerClientEvent('ATM:ToggleNUIFocus', player, true)
            local new_weight = ATM.getInventoryWeight(nuser_id)+ATM.getItemWeight(idname)*amount
            if new_weight <= ATM.getInventoryMaxWeight(nuser_id) then
              if ATM.tryGetInventoryItem(user_id,idname,amount,true) then
                ATM.giveInventoryItem(nuser_id,idname,amount,true)
                TriggerEvent('ATM:RefreshInventory', player)
                TriggerEvent('ATM:RefreshInventory', nplayer)
                ATMclient.playAnim(player,{true,{{"mp_common","givetake1_a",1}},false})
                ATMclient.playAnim(nplayer,{true,{{"mp_common","givetake2_a",1}},false})
              else
                TriggerClientEvent('ATM:ToggleNUIFocus', player, true)
                ATMclient.notify(player,{lang.common.invalid_value()})
              end
            else
                TriggerClientEvent('ATM:ToggleNUIFocus', player, true)
              ATMclient.notify(player,{lang.inventory.full()})
            end
          end)
        else
            TriggerClientEvent('ATM:ToggleNUIFocus', player, true)
          ATMclient.notify(player,{lang.common.no_player_near()})
        end
      else
        TriggerClientEvent('ATM:ToggleNUIFocus', player, true)
        ATMclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end

-- trash action
function ch_trash(idname, player, choice)
  local user_id = ATM.getUserId(player)
  if user_id ~= nil then
    -- prompt number
    TriggerClientEvent('ATM:ToggleNUIFocus', player, false)
    ATM.prompt(player,lang.inventory.trash.prompt({ATM.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
      local amount = parseInt(amount)
      if ATM.tryGetInventoryItem(user_id,idname,amount,false) then
        TriggerClientEvent('ATM:ToggleNUIFocus', player, true)
        TriggerEvent('ATM:RefreshInventory', player)
        ATMclient.notify(player,{lang.inventory.trash.done({ATM.getItemName(idname),amount})})
        ATMclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
      else
        TriggerClientEvent('ATM:ToggleNUIFocus', player, true)
        ATMclient.notify(player,{lang.common.invalid_value()})
      end
    end)
  end
end

function ATM.computeItemName(item,args)
  if type(item.name) == "string" then return item.name
  else return item.name(args) end
end

function ATM.computeItemDescription(item,args)
  if type(item.description) == "string" then return item.description
  else return item.description(args) end
end

function ATM.computeItemChoices(item,args)
  if item.choices ~= nil then
    return item.choices(args)
  else
    return {}
  end
end

function ATM.computeItemWeight(item,args)
  if type(item.weight) == "number" then return item.weight
  else return item.weight(args) end
end


function ATM.parseItem(idname)
  return splitString(idname,"|")
end

-- return name, description, weight
function ATM.getItemDefinition(idname)
  local args = ATM.parseItem(idname)
  local item = ATM.items[args[1]]
  if item ~= nil then
    return ATM.computeItemName(item,args), ATM.computeItemDescription(item,args), ATM.computeItemWeight(item,args)
  end

  return nil,nil,nil
end

function ATM.getItemName(idname)
  local args = ATM.parseItem(idname)
  local item = ATM.items[args[1]]
  if item ~= nil then return ATM.computeItemName(item,args) end
  return args[1]
end

function ATM.getItemDescription(idname)
  local args = ATM.parseItem(idname)
  local item = ATM.items[args[1]]
  if item ~= nil then return ATM.computeItemDescription(item,args) end
  return ""
end

function ATM.getItemChoices(idname)
  local args = ATM.parseItem(idname)
  local item = ATM.items[args[1]]
  local choices = {}
  if item ~= nil then
    -- compute choices
    local cchoices = ATM.computeItemChoices(item,args)
    if cchoices then -- copy computed choices
      for k,v in pairs(cchoices) do
        choices[k] = v
      end
    end

    -- add give/trash choices
    choices[lang.inventory.give.title()] = {function(player,choice) ch_give(idname, player, choice) end, lang.inventory.give.description()}
    choices[lang.inventory.trash.title()] = {function(player, choice) ch_trash(idname, player, choice) end, lang.inventory.trash.description()}
  end

  return choices
end

function ATM.getItemWeight(idname)
  local args = ATM.parseItem(idname)
  local item = ATM.items[args[1]]
  if item ~= nil then return ATM.computeItemWeight(item,args) end
  return 0
end

-- compute weight of a list of items (in inventory/chest format)
function ATM.computeItemsWeight(items)
  local weight = 0

  for k,v in pairs(items) do
    local iweight = ATM.getItemWeight(k)
    weight = weight+iweight*v.amount
  end

  return weight
end

-- add item to a connected user inventory
function ATM.giveInventoryItem(user_id,idname,amount,notify)
  local player = ATM.getUserSource(user_id)
  if notify == nil then notify = true end -- notify by default

  local data = ATM.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry then -- add to entry
      entry.amount = entry.amount+amount
    else -- new entry
      data.inventory[idname] = {amount=amount}
    end


    -- notify
    if notify then
      local player = ATM.getUserSource(user_id)
      if player ~= nil then
        ATMclient.notify(player,{lang.inventory.give.received({ATM.getItemName(idname),amount})})
      end
    end
  end
  TriggerEvent('ATM:RefreshInventory', player)
end


function ATM.RunTrashTask(source, itemName)
    local choices = ATM.getItemChoices(itemName)
    if choices['Trash'] then
        choices['Trash'][1](source)
    else 
        local user_id = ATM.getUserId(source)
        local data = ATM.getUserDataTable(user_id)
        data.inventory[itemName] = nil;
        print('[^7JamesUKInventory]^1: Invalid item removed from inventory space. Usually caused by spawned in staff items. User item from: ' .. user_id .. ' Item Name: ' .. itemName)
    end
    TriggerEvent('ATM:RefreshInventory', source)
end


function ATM.RunGiveTask(source, itemName)
    local choices = ATM.getItemChoices(itemName)
    if choices['Give'] then
        choices['Give'][1](source)
    end
    TriggerEvent('ATM:RefreshInventory', source)
end

function ATM.RunInventoryTask(source, itemName)
    local choices = ATM.getItemChoices(itemName)
    if choices['Use'] then 
        choices['Use'][1](source)
    elseif choices['Drink'] then
        choices['Drink'][1](source)
    elseif choices['Load'] then
        choices['Load'][1](source)
    elseif choices['Eat'] then
        choices['Eat'][1](source)
    elseif choices['Equip'] then 
        choices['Equip'][1](source)
    end
    TriggerEvent('ATM:RefreshInventory', source)
end

-- try to get item from a connected user inventory
function ATM.tryGetInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default
  local player = ATM.getUserSource(user_id)

  local data = ATM.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry and entry.amount >= amount then -- add to entry
      entry.amount = entry.amount-amount

      -- remove entry if <= 0
      if entry.amount <= 0 then
        data.inventory[idname] = nil 
      end

      -- notify
      if notify then
        local player = ATM.getUserSource(user_id)
        if player ~= nil then
          ATMclient.notify(player,{lang.inventory.give.given({ATM.getItemName(idname),amount})})
      
        end
      end
      TriggerEvent('ATM:RefreshInventory', player)
      return true
    else
      -- notify
      if notify then
        local player = ATM.getUserSource(user_id)
        if player ~= nil then
          local entry_amount = 0
          if entry then entry_amount = entry.amount end
          ATMclient.notify(player,{lang.inventory.missing({ATM.getItemName(idname),amount-entry_amount})})
        end
      end
    end
  end

  return false
end

-- get user inventory amount of item
function ATM.getInventoryItemAmount(user_id,idname)
  local data = ATM.getUserDataTable(user_id)
  if data and data.inventory then
    local entry = data.inventory[idname]
    if entry then
      return entry.amount
    end
  end

  return 0
end

-- return user inventory total weight
function ATM.getInventoryWeight(user_id)
  local data = ATM.getUserDataTable(user_id)
  if data and data.inventory then
    return ATM.computeItemsWeight(data.inventory)
  end

  if ATM.computeItemsWeight(data.inventory) > 15 then
    TriggerClientEvent("equipBackpack", source)
  else
    TriggerClientEvent("removeBackpack", source)
  end

  return 0
end

-- return maximum weight of the user inventory
function ATM.getInventoryMaxWeight(user_id)
  return cfg.inventory_weight
end

-- clear connected user inventory
function ATM.clearInventory(user_id)
  local data = ATM.getUserDataTable(user_id)
  if data then
    data.inventory = {}
  end
end

-- INVENTORY MENU

-- open player inventory
function ATM.openInventory(source)
  local user_id = ATM.getUserId(source)

  if user_id ~= nil then
    local data = ATM.getUserDataTable(user_id)
    if data then
      -- build inventory menu
      local menudata = {name=lang.inventory.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}
      -- add inventory info
      local weight = ATM.getInventoryWeight(user_id)
      local max_weight = ATM.getInventoryMaxWeight(user_id)
      local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
      menudata["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}
      local kitems = {}

      if ATM.computeItemsWeight(data.inventory) > 15 then
        TriggerClientEvent("equipBackpack", source)
      else
        TriggerClientEvent("removeBackpack", source)
      end

      -- choose callback, nested menu, create the item menu
      local choose = function(player,choice)
        if string.sub(choice,1,1) ~= "@" then -- ignore info choices
        local choices = ATM.getItemChoices(kitems[choice])
          -- build item menu
          local submenudata = {name=choice,css={top="75px",header_color="rgba(0,125,255,0.75)"}}

          -- add computed choices
          for k,v in pairs(choices) do
            submenudata[k] = v
          end

          -- nest menu
          submenudata.onclose = function()
            ATM.openInventory(source) -- reopen inventory when submenu closed
          end

          -- open menu
          ATM.openMenu(source,submenudata)
        end
      end

      -- add each item to the menu
      for k,v in pairs(data.inventory) do 
        local name,description,weight = ATM.getItemDefinition(k)
        if name ~= nil then
          kitems[name] = k -- reference item by display name
          menudata[name] = {choose,lang.inventory.iteminfo({v.amount,description,string.format("%.2f",weight)})}
        end
      end

      -- open menu
      ATM.openMenu(source,menudata)
    end
  end
end

-- init inventory
AddEventHandler("ATM:playerJoin", function(user_id,source,name,last_login)
  local data = ATM.getUserDataTable(user_id)
  if data.inventory == nil then
    data.inventory = {}

    if ATM.computeItemsWeight(data.inventory) > 15 then
      TriggerClientEvent("equipBackpack", source)
    else
      TriggerClientEvent("removeBackpack", source)
    end
  end
end)


-- add open inventory to main menu
local choices = {}
choices[lang.inventory.title()] = {function(player, choice) ATM.openInventory(player) end, lang.inventory.description()}

ATM.registerMenuBuilder("main", function(add, data)
  add(choices)
end)

-- CHEST SYSTEM

local chests = {}

-- build a menu from a list of items and bind a callback(idname)
local function build_itemlist_menu(name, items, cb)
  local menu = {name=name, css={top="75px",header_color="rgba(0,255,125,0.75)"}}

  local kitems = {}

  -- choice callback
  local choose = function(player,choice)
    local idname = kitems[choice]
    if idname then
      cb(idname)
    end
  end

  -- add each item to the menu
  for k,v in pairs(items) do 
    local name,description,weight = ATM.getItemDefinition(k)
    if name ~= nil then
      kitems[name] = k -- reference item by display name
      menu[name] = {choose,lang.inventory.iteminfo({v.amount,description,string.format("%.2f", weight)})}
    end
  end

  return menu
end

-- open a chest by name
-- cb_close(): called when the chest is closed (optional)
-- cb_in(idname, amount): called when an item is added (optional)
-- cb_out(idname, amount): called when an item is taken (optional)
function ATM.openChest(source, name, max_weight, cb_close, cb_in, cb_out)
  local user_id = ATM.getUserId(source)
  if user_id ~= nil then
    local data = ATM.getUserDataTable(user_id)
    if data.inventory ~= nil then
      if not chests[name] then
        local close_count = 0 -- used to know when the chest is closed (unlocked)

        -- load chest
        local chest = {max_weight = max_weight}
        chests[name] = chest 
        ATM.getSData("chest:"..name, function(cdata)
          chest.items = json.decode(cdata) or {} -- load items

          -- open menu
          local menu = {name=lang.inventory.chest.title(), css={top="75px",header_color="rgba(0,255,125,0.75)"}}
          -- take
          local cb_take = function(idname)
            local citem = chest.items[idname]
            ATM.prompt(source, lang.inventory.chest.take.prompt({citem.amount}), "", function(player, amount)
              amount = parseInt(amount)
              if amount >= 0 and amount <= citem.amount then
                -- take item
                
                -- weight check
                local new_weight = ATM.getInventoryWeight(user_id)+ATM.getItemWeight(idname)*amount
                if new_weight <= ATM.getInventoryMaxWeight(user_id) then
                  ATM.giveInventoryItem(user_id, idname, amount, true)
                  citem.amount = citem.amount-amount

                  if citem.amount <= 0 then
                    chest.items[idname] = nil -- remove item entry
                  end

                  if cb_out then cb_out(idname,amount) end

                  -- actualize by closing
                  ATM.closeMenu(player)
                else
                  ATMclient.notify(source,{lang.inventory.full()})
                end
              else
                ATMclient.notify(source,{lang.common.invalid_value()})
              end
            end)
          end

          local ch_take = function(player, choice)
            local submenu = build_itemlist_menu(lang.inventory.chest.take.title(), chest.items, cb_take)
            -- add weight info
            local weight = ATM.computeItemsWeight(chest.items)
            local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
            submenu["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}


            submenu.onclose = function()
              close_count = close_count-1
              ATM.openMenu(player, menu)
            end
            close_count = close_count+1
            ATM.openMenu(player, submenu)
          end


          -- put
          local cb_put = function(idname)
            ATM.prompt(source, lang.inventory.chest.put.prompt({ATM.getInventoryItemAmount(user_id, idname)}), "", function(player, amount)
              amount = parseInt(amount)

              -- weight check
              local new_weight = ATM.computeItemsWeight(chest.items)+ATM.getItemWeight(idname)*amount
              if new_weight <= max_weight then
                if amount >= 0 and ATM.tryGetInventoryItem(user_id, idname, amount, true) then
                  local citem = chest.items[idname]

                  if citem ~= nil then
                    citem.amount = citem.amount+amount
                  else -- create item entry
                    chest.items[idname] = {amount=amount}
                  end

                  -- callback
                  if cb_in then cb_in(idname,amount) end

                  -- actualize by closing
                  ATM.closeMenu(player)
                end
              else
                ATMclient.notify(source,{lang.inventory.chest.full()})
              end
            end)
          end

          local ch_put = function(player, choice)
            local submenu = build_itemlist_menu(lang.inventory.chest.put.title(), data.inventory, cb_put)
            -- add weight info
            local weight = ATM.computeItemsWeight(data.inventory)
            local max_weight = ATM.getInventoryMaxWeight(user_id)
            local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
            submenu["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}

            submenu.onclose = function() 
              close_count = close_count-1
              ATM.openMenu(player, menu) 
            end
            close_count = close_count+1
            ATM.openMenu(player, submenu)
          end


          -- choices
          menu[lang.inventory.chest.take.title()] = {ch_take}
          menu[lang.inventory.chest.put.title()] = {ch_put}

          menu.onclose = function()
            if close_count == 0 then -- close chest
              -- save chest items
              ATM.setSData("chest:"..name, json.encode(chest.items))
              chests[name] = nil
              if cb_close then cb_close() end -- close callback
            end
          end

          -- Ugly patch to close the "already opened" chest. 
			    SetTimeout(300000, function()
            if not close_count == 0 then
			        close_count = 0
              ATM.setSData("chest:"..name, json.encode(chest.items))
              chests[name] = nil
			      end
          end)
          -- Ugly patch to close the "already opened" chest.

          -- open menu
          ATM.openMenu(source, menu)
        end)
      else
        ATMclient.notify(source,{lang.inventory.chest.already_opened()})
      end
    end
  end
end
