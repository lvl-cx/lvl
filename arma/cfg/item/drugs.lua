
local items = {}

local function play_drink(player)
  local seq = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",1},
    {"mp_player_intdrink","outro_bottle",1}
  }

  ARMAclient.playAnim(player,{true,seq,false})
end

local pills_choices = {}
pills_choices["Take"] = {function(player,choice)
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    ARMAclient.isInComa(player,{}, function(in_coma)    
        if not in_coma then
          if ARMA.tryGetInventoryItem(user_id,"pills",1) then
            ARMAclient.varyHealth(player,{25})
            ARMAclient.notify(player,{"~g~ Taking pills."})
            play_drink(player)
            ARMA.closeMenu(player)
          end
        end    
    end)
  end
end}

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
      ARMA.closeMenu(player)
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
      ARMA.closeMenu(player)
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
	  ARMA.varyThirst(user_id,(20))
      ARMAclient.notify(player,{"~g~ Taking lsd."})
      play_lsd(player)
      ARMA.closeMenu(player)
    end
  end
end}

local morphine_choices = {}
morphine_choices["Take"] = {function(player,choice)
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    if ARMA.tryGetInventoryItem(user_id,"morphine",1) then
      TriggerClientEvent('morphine', player)
      TriggerEvent('ARMA:RefreshInventory', player)
      ARMA.closeMenu({player})
    end
  end
end}

items["weed"] = {"Weed","A some weed.",function(args) return smoke_choices end,0.10}
items["cocaine"] = {"Cocaine","Some cocaine.",function(args) return smell_choices end,0.5}
items["lsd"] = {"Lsd","Some LSD.",function(args) return lsd_choices end,0.1}
items["morphine"] = {"Morphine","Some Morphine.",function(args) return morphine_choices end,0.1}

return items
