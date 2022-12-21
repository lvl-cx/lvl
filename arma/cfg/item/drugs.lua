
local items = {}

local function play_smoke(player)
  local seq2 = {
    {"mp_player_int_uppersmoke","mp_player_int_smoke_enter",1},
    {"mp_player_int_uppersmoke","mp_player_int_smoke",1},
    {"mp_player_int_uppersmoke","mp_player_int_smoke_exit",1}
  }

  ARMAclient.playAnim(player,{true,seq2,false})
end

local smoke_choices = {}
smoke_choices["Take"] = {function(player,choice)
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    if ARMA.tryGetInventoryItem(user_id,"weed",1) then
      ARMAclient.notify(player,{"~g~ smoking weed."})
      play_smoke(player)
    end
  end
end}

local function play_smell(player)
  local seq3 = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",1},
    {"mp_player_intdrink","outro_bottle",1}
  }

  ARMAclient.playAnim(player,{true,seq3,false})
end

local smell_choices = {}
smell_choices["Take"] = {function(player,choice)
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    if ARMA.tryGetInventoryItem(user_id,"cocaine",1) then
      ARMAclient.notify(player,{"~g~ smell cocaine."})
      play_smell(player)
    end
  end
end}

local function play_lsd(player)
  local seq4 = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",1},
    {"mp_player_intdrink","outro_bottle",1}
  }

  ARMAclient.playAnim(player,{true,seq4,false})
end

local lsd_choices = {}
lsd_choices["Take"] = {function(player,choice)
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    if ARMA.tryGetInventoryItem(user_id,"lsd",1) then
      ARMAclient.notify(player,{"~g~ Taking lsd."})
      play_lsd(player)
    end
  end
end}

local morphine_choices = {}
morphine_choices["Take"] = {function(player,choice)
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    if ARMA.tryGetInventoryItem(user_id,"Morphine",1) then
      TriggerEvent('ARMA:RefreshInventory', player)
      TriggerClientEvent('ARMA:applyMorphine', player)
    end
  end
end}

local taco_choices = {}
taco_choices["Take"] = {function(player,choice)
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    if ARMA.tryGetInventoryItem(user_id,"Taco",1) then
      TriggerEvent('ARMA:RefreshInventory', player)
      TriggerClientEvent('ARMA:eatTaco', player)
    end
  end
end}

items["Weed"] = {"Weed","A some weed.",function(args) return smoke_choices end,0.10}
items["Cocaine"] = {"Cocaine","Some cocaine.",function(args) return smell_choices end,0.5}
items["LSD"] = {"Lsd","Some LSD.",function(args) return lsd_choices end,0.1}
items["Morphine"] = {"Morphine","Some Morphine.",function(args) return morphine_choices end,0.1}
items["Taco"] = {"Taco","A Taco.",function(args) return taco_choices end,0.1}

return items
