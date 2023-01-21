local lang = ARMA.lang
local cfg = module("arma-vehicles", "inventory")

-- this module define the player inventory (lost after respawn, as wallet)

ARMA.items = {}

function ARMA.defInventoryItem(idname,name,description,choices,weight)
  if weight == nil then
    weight = 0
  end

  local item = {name=name,description=description,choices=choices,weight=weight}
  ARMA.items[idname] = item

  -- build give action
  item.ch_give = function(player,choice)
  end

  -- build trash action
  item.ch_trash = function(player,choice)
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil then
      -- prompt number
      ARMA.prompt(player,lang.inventory.trash.prompt({ARMA.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if ARMA.tryGetInventoryItem(user_id,idname,amount,false) then
          ARMAclient.notify(player,{lang.inventory.trash.done({ARMA.getItemName(idname),amount})})
          ARMAclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          ARMAclient.notify(player,{lang.common.invalid_value()})
        end
      end)
    end
  end
end

-- give action
function ch_give(idname, player, choice)
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    ARMAclient.getNearestPlayers(player,{15},function(nplayers) --get nearest players
      usrList = ""
      for k, v in pairs(nplayers) do
          usrList = usrList .. "[" .. k .. "]" .. GetPlayerName(k) .. " | " --add ids to usrList
      end
      if #nplayers > 1 then
        if usrList ~= "" then
            ARMA.prompt(player,"Players Nearby: " .. usrList .. "","",function(player, nplayer) --ask for id
              nplayer = nplayer
              if nplayer ~= nil and nplayer ~= "" then
                if nplayers[tonumber(nplayer)] then
                  local nuser_id = ARMA.getUserId(nplayer)
                  if nuser_id ~= nil then
                    ARMA.prompt(player,lang.inventory.give.prompt({ARMA.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
                      local amount = parseInt(amount)
                      -- weight check
                      local new_weight = ARMA.getInventoryWeight(nuser_id)+ARMA.getItemWeight(idname)*amount
                      if new_weight <= ARMA.getInventoryMaxWeight(nuser_id) then
                        if ARMA.tryGetInventoryItem(user_id,idname,amount,true) then
                          ARMA.giveInventoryItem(nuser_id,idname,amount,true)
                          TriggerEvent('ARMA:RefreshInventory', player)
                          TriggerEvent('ARMA:RefreshInventory', nplayer)
                          ARMAclient.playAnim(player,{true,{{"mp_common","givetake1_a",1}},false})
                          ARMAclient.playAnim(nplayer,{true,{{"mp_common","givetake2_a",1}},false})
                        else
                          ARMAclient.notify(player,{lang.common.invalid_value()})
                        end
                      else
                        ARMAclient.notify(player,{lang.inventory.full()})
                      end
                    end)
                  else
                      ARMAclient.notify(player,{'~r~Invalid Temp ID.'})
                  end
                else
                    ARMAclient.notify(player,{'~r~Invalid Temp ID.'})
                end
              else
                ARMAclient.notify(player,{lang.common.no_player_near()})
              end
            end)
        else
          ARMAclient.notify(player,{"~r~No players nearby!"}) --no players nearby
        end
      else
        ARMAclient.getNearestPlayer(player,{15},function(nplayer)
          if nplayer then
              ARMA.prompt(player,lang.inventory.give.prompt({ARMA.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
                local amount = parseInt(amount)
                -- weight check
                local new_weight = ARMA.getInventoryWeight(nuser_id)+ARMA.getItemWeight(idname)*amount
                if new_weight <= ARMA.getInventoryMaxWeight(nuser_id) then
                  if ARMA.tryGetInventoryItem(user_id,idname,amount,true) then
                    ARMA.giveInventoryItem(nuser_id,idname,amount,true)
                    TriggerEvent('ARMA:RefreshInventory', player)
                    TriggerEvent('ARMA:RefreshInventory', nplayer)
                    ARMAclient.playAnim(player,{true,{{"mp_common","givetake1_a",1}},false})
                    ARMAclient.playAnim(nplayer,{true,{{"mp_common","givetake2_a",1}},false})
                  else
                    ARMAclient.notify(player,{lang.common.invalid_value()})
                  end
                else
                  ARMAclient.notify(player,{lang.inventory.full()})
                end
              end)
          else
              ARMAclient.notify(source, {"~r~No one nearby."})
          end
        end)
      end
    end)
  end
end

-- trash action
function ch_trash(idname, player, choice)
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    -- prompt number
    if ARMA.getInventoryItemAmount(user_id,idname) > 1 then 
      ARMA.prompt(player,lang.inventory.trash.prompt({ARMA.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if ARMA.tryGetInventoryItem(user_id,idname,amount,false) then
          TriggerEvent('ARMA:RefreshInventory', player)
          ARMAclient.notify(player,{lang.inventory.trash.done({ARMA.getItemName(idname),amount})})
          ARMAclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          ARMAclient.notify(player,{lang.common.invalid_value()})
        end
      end)
    else
      if ARMA.tryGetInventoryItem(user_id,idname,1,false) then
        TriggerEvent('ARMA:RefreshInventory', player)
        ARMAclient.notify(player,{lang.inventory.trash.done({ARMA.getItemName(idname),1})})
        ARMAclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
      else
        ARMAclient.notify(player,{lang.common.invalid_value()})
      end
    end
  end
end

function ARMA.computeItemName(item,args)
  if type(item.name) == "string" then return item.name
  else return item.name(args) end
end

function ARMA.computeItemDescription(item,args)
  if type(item.description) == "string" then return item.description
  else return item.description(args) end
end

function ARMA.computeItemChoices(item,args)
  if item.choices ~= nil then
    return item.choices(args)
  else
    return {}
  end
end

function ARMA.computeItemWeight(item,args)
  if type(item.weight) == "number" then return item.weight
  else return item.weight(args) end
end


function ARMA.parseItem(idname)
  return splitString(idname,"|")
end

-- return name, description, weight
function ARMA.getItemDefinition(idname)
  local args = ARMA.parseItem(idname)
  local item = ARMA.items[args[1]]
  if item ~= nil then
    return ARMA.computeItemName(item,args), ARMA.computeItemDescription(item,args), ARMA.computeItemWeight(item,args)
  end

  return nil,nil,nil
end

function ARMA.getItemName(idname)
  local args = ARMA.parseItem(idname)
  local item = ARMA.items[args[1]]
  if item ~= nil then return ARMA.computeItemName(item,args) end
  return args[1]
end

function ARMA.getItemDescription(idname)
  local args = ARMA.parseItem(idname)
  local item = ARMA.items[args[1]]
  if item ~= nil then return ARMA.computeItemDescription(item,args) end
  return ""
end

function ARMA.getItemChoices(idname)
  local args = ARMA.parseItem(idname)
  local item = ARMA.items[args[1]]
  local choices = {}
  if item ~= nil then
    -- compute choices
    local cchoices = ARMA.computeItemChoices(item,args)
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

function ARMA.getItemWeight(idname)
  local args = ARMA.parseItem(idname)
  local item = ARMA.items[args[1]]
  if item ~= nil then return ARMA.computeItemWeight(item,args) end
  return 1
end

-- compute weight of a list of items (in inventory/chest format)
function ARMA.computeItemsWeight(items)
  local weight = 0

  for k,v in pairs(items) do
    local iweight = ARMA.getItemWeight(k)
    if iweight ~= nil then
      weight = weight+iweight*v.amount
    end
  end

  return weight
end

-- add item to a connected user inventory
function ARMA.giveInventoryItem(user_id,idname,amount,notify)
  local player = ARMA.getUserSource(user_id)
  if notify == nil then notify = true end -- notify by default

  local data = ARMA.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry then -- add to entry
      entry.amount = entry.amount+amount
    else -- new entry
      data.inventory[idname] = {amount=amount}
    end

    -- notify
    if notify then
      local player = ARMA.getUserSource(user_id)
      if player ~= nil then
        ARMAclient.notify(player,{lang.inventory.give.received({ARMA.getItemName(idname),amount})})
      end
    end
  end
  TriggerEvent('ARMA:RefreshInventory', player)
end


function ARMA.RunTrashTask(source, itemName)
    local choices = ARMA.getItemChoices(itemName)
    if choices['Trash'] then
        choices['Trash'][1](source)
    else 
        local user_id = ARMA.getUserId(source)
        local data = ARMA.getUserDataTable(user_id)
        data.inventory[itemName] = nil;
    end
    TriggerEvent('ARMA:RefreshInventory', source)
end


function ARMA.RunGiveTask(source, itemName)
    local choices = ARMA.getItemChoices(itemName)
    if choices['Give'] then
        choices['Give'][1](source)
    end
    TriggerEvent('ARMA:RefreshInventory', source)
end

function ARMA.RunInventoryTask(source, itemName)
    local choices = ARMA.getItemChoices(itemName)
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
    elseif choices['Take'] then 
        choices['Take'][1](source)
    end
    TriggerEvent('ARMA:RefreshInventory', source)
end

function ARMA.LoadAllTask(source, itemName)
  local choices = ARMA.getItemChoices(itemName)
  choices['LoadAll'][1](source)
  TriggerEvent('ARMA:RefreshInventory', source)
end

-- try to get item from a connected user inventory
function ARMA.tryGetInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default
  local player = ARMA.getUserSource(user_id)

  local data = ARMA.getUserDataTable(user_id)
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
        local player = ARMA.getUserSource(user_id)
        if player ~= nil then
          ARMAclient.notify(player,{lang.inventory.give.given({ARMA.getItemName(idname),amount})})
      
        end
      end
      TriggerEvent('ARMA:RefreshInventory', player)
      return true
    else
      -- notify
      if notify then
        local player = ARMA.getUserSource(user_id)
        if player ~= nil then
          local entry_amount = 0
          if entry then entry_amount = entry.amount end
          ARMAclient.notify(player,{lang.inventory.missing({ARMA.getItemName(idname),amount-entry_amount})})
        end
      end
    end
  end

  return false
end

-- get user inventory amount of item
function ARMA.getInventoryItemAmount(user_id,idname)
  local data = ARMA.getUserDataTable(user_id)
  if data and data.inventory then
    local entry = data.inventory[idname]
    if entry then
      return entry.amount
    end
  end

  return 0
end

-- return user inventory total weight
function ARMA.getInventoryWeight(user_id)
  local data = ARMA.getUserDataTable(user_id)
  if data and data.inventory then
    return ARMA.computeItemsWeight(data.inventory)
  end
  return 0
end

function ARMA.getInventoryMaxWeight(user_id)
  local data = ARMA.getUserDataTable(user_id)
  if data.invcap ~= nil then
    return data.invcap
  end
  return 30
end


-- clear connected user inventory
function ARMA.clearInventory(user_id)
  local data = ARMA.getUserDataTable(user_id)
  if data then
    data.inventory = {}
  end
end


AddEventHandler("ARMA:playerJoin", function(user_id,source,name,last_login)
  local data = ARMA.getUserDataTable(user_id)
  if data.inventory == nil then
    data.inventory = {}
  end
end)


RegisterCommand("storebackpack", function(source, args)
  local source = source
  local user_id = ARMA.getUserId(source)
  local data = ARMA.getUserDataTable(user_id)
  tARMA.getSubscriptions(user_id, function(cb, plushours, plathours)
    if cb then
      local invcap = 30
      if plathours > 0 then
          invcap = invcap + 20
      elseif plushours > 0 then
          invcap = invcap + 10
      end
      if invcap == 30 then
        ARMAclient.notify(source,{"~r~You do not have a backpack equipped."})
        return
      end
      if data.invcap - 15 == invcap then
        ARMA.giveInventoryItem(user_id, "offwhitebag", 1, false)
      elseif data.invcap - 20 == invcap then
        ARMA.giveInventoryItem(user_id, "guccibag", 1, false)
      elseif data.invcap - 30 == invcap  then
        ARMA.giveInventoryItem(user_id, "nikebag", 1, false)
      elseif data.invcap - 35 == invcap  then
        ARMA.giveInventoryItem(user_id, "huntingbackpack", 1, false)
      elseif data.invcap - 40 == invcap  then
        ARMA.giveInventoryItem(user_id, "greenhikingbackpack", 1, false)
      elseif data.invcap - 70 == invcap  then
        ARMA.giveInventoryItem(user_id, "rebelbackpack", 1, false)
      end
      ARMA.updateInvCap(user_id, invcap)
      ARMAclient.notify(source,{"~g~Backpack Stored"})
      TriggerClientEvent('ARMA:removeBackpack', source)
    else
      if ARMA.getInventoryWeight(user_id) + 5 > ARMA.getInventoryMaxWeight(user_id) then
        ARMAclient.notify(source,{"~r~You do not have enough room to store your backpack"})
      end
    end
  end)
end)