--[[
    FiveM Scripts
    Copyright C 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    at your option any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

local Tunnel = module("lvl", "lib/Tunnel")
local Proxy = module("lvl", "lib/Proxy")
local htmlEntities = module("lvl", "lib/htmlEntities")

LVLbm = {}
LVL = Proxy.getInterface("LVL")
LVLclient = Tunnel.getInterface("LVL","LVL_basic_menu")
BMclient = Tunnel.getInterface("LVL_basic_menu","LVL_basic_menu")
LVLbsC = Tunnel.getInterface("LVL_barbershop","LVL_basic_menu")
Tunnel.bindInterface("lvl_basic_menu",LVLbm)

local Lang = module("lvl", "lib/Lang")
local cfg = module("lvl", "cfg/base")
local lang = Lang.new(module("lvl", "cfg/lang/"..cfg.lang) or {})

-- LOG FUNCTION
function LVLbm.logInfoToFile(file,info)
  file = io.open(file, "a")
  if file then
    file:write(os.date("%c").." => "..info.."\n")
  end
  file:close()
end
-- MAKE CHOICES
--toggle service
local choice_service = {function(player,choice)
  local user_id = LVL.getUserId({player})
  local service = "onservice"
  if user_id ~= nil then
    if LVL.hasGroup({user_id,service}) then
	  LVL.removeUserGroup({user_id,service})
	  if LVL.hasMission({player}) then
		LVL.stopMission({player})
	  end
      LVLclient.notify(player,{"~r~Off service"})
	else
	  LVL.addUserGroup({user_id,service})
      LVLclient.notify(player,{"~g~On service"})
	end
  end
end, "Go on/off service"}

-- teleport waypoint
local choice_tptowaypoint = {function(player,choice)
  TriggerClientEvent("TpToWaypoint", player)
end, "Teleport to map blip."}

-- fix barbershop green hair for now
local ch_fixhair = {function(player,choice)
    local custom = {}
    local user_id = LVL.getUserId({player})
    LVL.getUData({user_id,"LVL:head:overlay",function(value)
	  if value ~= nil then
	    custom = json.decode(value)
        LVLbsC.setOverlay(player,{custom,true})
	  end
	end})
end, "Fix the barbershop bug for now."}

--toggle blips
local ch_blips = {function(player,choice)
  TriggerClientEvent("showBlips", player)
end, "Toggle blips."}

local spikes = {}
local ch_spikes = {function(player,choice)
	local user_id = LVL.getUserId({player})
	BMclient.isCloseToSpikes(player,{},function(closeby)
		if closeby and (spikes[player] or LVL.hasPermission({user_id,"admin.spikes"})) then
		  BMclient.removeSpikes(player,{})
		  spikes[player] = false
		elseif closeby and not spikes[player] and not LVL.hasPermission({user_id,"admin.spikes"}) then
		  LVLclient.notify(player,{"~r~You can carry only one set of spikes!"})
		elseif not closeby and spikes[player] and not LVL.hasPermission({user_id,"admin.spikes"}) then
		  LVLclient.notify(player,{"~r~You can deploy only one set of spikes!"})
		elseif not closeby and (not spikes[player] or LVL.hasPermission({user_id,"admin.spikes"})) then
		  BMclient.setSpikesOnGround(player,{})
		  spikes[player] = true
		end
	end)
end, "Toggle spikes."}

local ch_sprites = {function(player,choice)
  TriggerClientEvent("showSprites", player)
end, "Toggle sprites."}

local ch_deleteveh = {function(player,choice)
  BMclient.deleteVehicleInFrontOrInside(player,{5.0})
end, "Delete nearest car."}

--client function
local ch_crun = {function(player,choice)
  LVL.prompt({player,"Function:","",function(player,stringToRun) 
    stringToRun = stringToRun or ""
	TriggerClientEvent("RunCode:RunStringLocally", player, stringToRun)
  end})
end, "Run client function."}

--server function
local ch_srun = {function(player,choice)
  LVL.prompt({player,"Function:","",function(player,stringToRun) 
    stringToRun = stringToRun or ""
	TriggerEvent("RunCode:RunStringRemotelly", stringToRun)
  end})
end, "Run server function."}

--police weapons // comment out the weapons if you dont want to give weapons.
local police_weapons = {}
police_weapons["Equip"] = {function(player,choice)
    LVLclient.giveWeapons(player,{{
	  ["WEAPON_COMBATPISTOL"] = {ammo=200},
	  ["WEAPON_PUMPSHOTGUN"] = {ammo=200},
	  ["WEAPON_NIGHTSTICK"] = {ammo=200},
	  ["WEAPON_STUNGUN"] = {ammo=200}
	}, true})
	BMclient.setArmour(player,{100,true})
end}

--store money
local choice_store_money = {function(player, choice)
  local user_id = LVL.getUserId({player})
  if user_id ~= nil then
    local amount = LVL.getMoney({user_id})
    if LVL.tryPayment({user_id, amount}) then -- unpack the money
      LVL.giveInventoryItem({user_id, "money", amount, true})
    end
  end
end, "Store your money in your inventory."}

--medkit storage
local emergency_medkit = {}
emergency_medkit["Take"] = {function(player,choice)
	local user_id = LVL.getUserId({player}) 
	LVL.giveInventoryItem({user_id,"medkit",25,true})
	LVL.giveInventoryItem({user_id,"pills",25,true})
end}

--heal me
local emergency_heal = {}
emergency_heal["Heal"] = {function(player,choice)
	local user_id = LVL.getUserId({player}) 
	LVLclient.setHealth(player,{1000})
end}

--loot corpse
--loot corpse
local choice_loot = {function(player,choice)
  local user_id = LVL.getUserId({player})
  if user_id ~= nil then
    LVLclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = LVL.getUserId({nplayer})
      if nuser_id ~= nil then
        LVLclient.isInComa(nplayer,{}, function(in_coma)
          if in_coma then
            
  if LVL.hasPermission({user_id,"police.easy_fine"}) then
    return   LVLclient.notify(player,{"~r~You can't loot as a cop!"})
  end 
  if LVL.hasPermission({nuser_id,"police.easy_fine"}) then
    return   LVLclient.notify(player,{"~r~You cannot loot cops!"})
  end 
			local revive_seq = {
			  {"amb@medic@standing@kneel@enter","enter",1},
			  {"amb@medic@standing@kneel@idle_a","idle_a",1},
			  {"amb@medic@standing@kneel@exit","exit",1}
			}
  			LVLclient.playAnim(player,{false,revive_seq,false}) -- anim
            SetTimeout(1, function()
              local ndata = LVL.getUserDataTable({nuser_id})
              if ndata ~= nil then
			    if ndata.inventory ~= nil then -- gives inventory items
          -- LVL.clearInventory({nuser_id})
          
                  for k,v in pairs(ndata.inventory) do 
                    local weight = LVL.getInventoryWeight({user_id})
                    local itemweight = LVL.getItemWeight({k})*tonumber(v.amount)
                    local new_weight = tonumber(weight)+ itemweight
                    local maxweight = LVL.getInventoryMaxWeight({user_id})
                    print(weight,new_weight,maxweight,itemweight) 
                    if new_weight > maxweight then
                      LVLclient.notify(player,{"Darn your inventory is too full."})
                    else 
                      if LVL.tryGetInventoryItem({nuser_id, k, v.amount, true}) then 
                      LVL.giveInventoryItem({user_id,k,v.amount,true})
                      end 
                    end 
	              end
				end
			  end
			  local nmoney = LVL.getMoney({nuser_id})
			  if LVL.tryPayment({nuser_id,nmoney}) then
			    LVL.giveMoney({user_id,nmoney})
			  end
            end)
			LVLclient.stopAnim(player,{false})
          else
            LVLclient.notify(player,{lang.emergency.menu.revive.not_in_coma()})
          end
        end)
      else
        LVLclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end,"Loot nearby corpse"}

-- hack player
local ch_hack = {function(player,choice)
  -- get nearest player
  local user_id = LVL.getUserId({player})
  if user_id ~= nil then
    LVLclient.getNearestPlayer(player,{25},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = LVL.getUserId({nplayer})
        if nuser_id ~= nil then
          -- prompt number
		  local nbank = LVL.getBankMoney({nuser_id})
          local amount = math.floor(nbank*0.01)
		  local nvalue = nbank - amount
		  if math.random(1,100) == 1 then
			LVL.setBankMoney({nuser_id,nvalue})
            LVLclient.notify(nplayer,{"Hacked ~r~".. amount .."£."})
		    LVL.giveInventoryItem({user_id,"dirty_money",amount,true})
		  else
            LVLclient.notify(nplayer,{"~g~Hacking attempt failed."})
            LVLclient.notify(player,{"~r~Hacking attempt failed."})
		  end
        else
          LVLclient.notify(player,{lang.common.no_player_near()})
        end
      else
        LVLclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end,"Hack closest player."}

-- mug player
local ch_mug = {function(player,choice)
  -- get nearest player
  local user_id = LVL.getUserId({player})
  if user_id ~= nil then
    LVLclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = LVL.getUserId({nplayer})
        if nuser_id ~= nil then
          -- prompt number
		  local nmoney = LVL.getMoney({nuser_id})
          local amount = nmoney
		  if math.random(1,3) == 1 then
            if LVL.tryPayment({nuser_id,amount}) then
              LVLclient.notify(nplayer,{"Mugged ~r~"..amount.."£."})
		      LVL.giveInventoryItem({user_id,"dirty_money",amount,true})
            else
              LVLclient.notify(player,{lang.money.not_enough()})
            end
		  else
            LVLclient.notify(nplayer,{"~g~Mugging attempt failed."})
            LVLclient.notify(player,{"~r~Mugging attempt failed."})
		  end
        else
          LVLclient.notify(player,{lang.common.no_player_near()})
        end
      else
        LVLclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, "Mug closest player."}

-- drag player
local ch_drag = {function(player,choice)
  -- get nearest player
  local user_id = LVL.getUserId({player})
  if user_id ~= nil then
    LVLclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = LVL.getUserId({nplayer})
        if nuser_id ~= nil then
		  LVLclient.isHandcuffed(nplayer,{},function(handcuffed)
			if handcuffed then
				TriggerClientEvent("dr:drag", nplayer, player)
			else
				LVLclient.notify(player,{"Player is not handcuffed."})
			end
		  end)
        else
          LVLclient.notify(player,{lang.common.no_player_near()})
        end
      else
        LVLclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, "Drag closest player."}

-- player check
local choice_player_check = {function(player,choice)
  LVLclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = LVL.getUserId({nplayer})
    if nuser_id ~= nil then
      LVLclient.notify(nplayer,{lang.police.menu.check.checked()})
      LVLclient.getWeapons(nplayer,{},function(weapons)
        -- prepare display data (money, items, weapons)
        local money = LVL.getMoney({nuser_id})
        local items = ""
        local data = LVL.getUserDataTable({nuser_id})
        if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item_name = LVL.getItemName({k})
            if item_name then
              items = items.."<br />"..item_name.." ("..v.amount..")"
            end
          end
        end

        local weapons_info = ""
        for k,v in pairs(weapons) do
          weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
        end

        LVLclient.setDiv2(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
        -- request to hide div
        LVL.request({player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
          LVLclient.removeDiv(player,{"police_check"})
        end})
      end)
    else
      LVLclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, lang.police.menu.check.description()}

RegisterServerEvent("LVL:SearchNearest")
AddEventHandler("LVL:SearchNearest", function()
  local player = source
  LVLclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = LVL.getUserId({nplayer})
    if nuser_id ~= nil then
      LVLclient.notify(nplayer,{lang.police.menu.check.checked()})
      LVLclient.getWeapons(nplayer,{},function(weapons)
        -- prepare display data (money, items, weapons)
        local money = LVL.getMoney({nuser_id})
        local items = ""
        local data = LVL.getUserDataTable({nuser_id})
        if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item_name = LVL.getItemName({k})
            if item_name then
              items = items.."<br />"..item_name.." ("..v.amount..")"
            end
          end
        end

        local weapons_info = ""
        for k,v in pairs(weapons) do
          weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
        end

        LVLclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
        -- request to hide div
        LVL.request({player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
          LVLclient.removeDiv(player,{"police_check"})
        end})
      end)
    else
      LVLclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end)


-- armor item
LVL.defInventoryItem({"body_armor","Body Armor","Intact body armor.",
function(args)
  local choices = {}

  choices["Equip"] = {function(player,choice)
    local user_id = LVL.getUserId({player})
    if user_id ~= nil then
      if LVL.tryGetInventoryItem({user_id, "body_armor", 1, true}) then
		BMclient.setArmour(player,{100,true})
        LVL.closeMenu({player})
      end
    end
  end}

  return choices
end,
5.00})

-- store armor
local choice_store_armor = {function(player, choice)
  local user_id = LVL.getUserId({player})
  if user_id ~= nil then
    BMclient.getArmour(player,{},function(armour)
      if armour > 95 then
        LVL.giveInventoryItem({user_id, "body_armor", 1, true})
        -- clear armor
	    BMclient.setArmour(player,{0,false})
	  else
	    LVLclient.notify(player, {"~r~Damaged armor can't be stored!"})
      end
    end)
  end
end, "Store intact body armor in inventory."}

local unjailed = {}
function jail_clock(target_id,timer)
  local target = LVL.getUserSource({tonumber(target_id)})
  local users = LVL.getUsers({})
  local online = false
  for k,v in pairs(users) do
	if tonumber(k) == tonumber(target_id) then
	  online = true
	end
  end
  if online then
    if timer>0 then
	  LVLclient.notify(target, {"~r~Remaining time: " .. timer .. " minute(s)."})
      LVL.setUData({tonumber(target_id),"LVL:jail:time",json.encode(timer)})
	  SetTimeout(60*1000, function()
		for k,v in pairs(unjailed) do -- check if player has been unjailed by cop or admin
		  if v == tonumber(target_id) then
	        unjailed[v] = nil
		    timer = 0
		  end
		end
		LVL.setHunger({tonumber(target_id), 0})
		LVL.setThirst({tonumber(target_id), 0})
	    jail_clock(tonumber(target_id),timer-1)
	  end) 
    else 
	  BMclient.loadFreeze(target,{false,true,true})
	  SetTimeout(15000,function()
		BMclient.loadFreeze(target,{false,false,false})
	  end)
	  LVLclient.teleport(target,{425.7607421875,-978.73425292969,30.709615707397}) -- teleport to outside jail
	  LVLclient.setHandcuffed(target,{false})
      LVLclient.notify(target,{"~g~You have been set free."})
	  LVL.setUData({tonumber(target_id),"LVL:jail:time",json.encode(-1)})
    end
  end
end

-- dynamic jail
local ch_jail = {function(player,choice) 
  LVLclient.getNearestPlayers(player,{15},function(nplayers) 
	local user_list = ""
    for k,v in pairs(nplayers) do
	  user_list = user_list .. "[" .. LVL.getUserId({k}) .. "]" .. GetPlayerName(k) .. " | "
    end 
	if user_list ~= "" then
	  LVL.prompt({player,"Players Nearby:" .. user_list,"",function(player,target_id) 
	    if target_id ~= nil and target_id ~= "" then 
	      LVL.prompt({player,"Jail Time in minutes:","1",function(player,jail_time)
			if jail_time ~= nil and jail_time ~= "" then 
	          local target = LVL.getUserSource({tonumber(target_id)})
			  if target ~= nil then
		        if tonumber(jail_time) > 60 then
  			      jail_time = 60
		        end
		        if tonumber(jail_time) < 1 then
		          jail_time = 1
		        end
		  
                LVLclient.isHandcuffed(target,{}, function(handcuffed)  
                  if handcuffed then 
					BMclient.loadFreeze(target,{false,true,true})
					SetTimeout(15000,function()
					  BMclient.loadFreeze(target,{false,false,false})
					end)
				    LVLclient.teleport(target,{1641.5477294922,2570.4819335938,45.564788818359}) -- teleport to inside jail
				    LVLclient.notify(target,{"~r~You have been sent to jail."})
				    LVLclient.notify(player,{"~g~You sent a player to jail."})
				    LVL.setHunger({tonumber(target_id),0})
				    LVL.setThirst({tonumber(target_id),0})
				    jail_clock(tonumber(target_id),tonumber(jail_time))
					local user_id = LVL.getUserId({player})
					LVLbm.logInfoToFile("jailLog.txt",user_id .. " jailed "..target_id.." for " .. jail_time .. " minutes")
			      else
				    LVLclient.notify(player,{"~r~That player is not handcuffed."})
			      end
			    end)
			  else
				LVLclient.notify(player,{"~r~That ID seems invalid."})
			  end
			else
			  LVLclient.notify(player,{"~r~The jail time can't be empty."})
			end
	      end})
        else
          LVLclient.notify(player,{"~r~No player ID selected."})
        end 
	  end})
    else
      LVLclient.notify(player,{"~r~No player nearby."})
    end 
  end)
end,"Send a nearby player to jail."}

-- dynamic unjail
local ch_unjail = {function(player,choice) 
	LVL.prompt({player,"Player ID:","",function(player,target_id) 
	  if target_id ~= nil and target_id ~= "" then 
		LVL.getUData({tonumber(target_id),"LVL:jail:time",function(value)
		  if value ~= nil then
		  custom = json.decode(value)
			if custom ~= nil then
			  local user_id = LVL.getUserId({player})
			  if tonumber(custom) > 0 or LVL.hasPermission({user_id,"admin.easy_unjail"}) then
	            local target = LVL.getUserSource({tonumber(target_id)})
				if target ~= nil then
	              unjailed[target] = tonumber(target_id)
				  LVLclient.notify(player,{"~g~Target will be released soon."})
				  LVLclient.notify(target,{"~g~Someone lowered your sentence."})
				  LVLbm.logInfoToFile("jailLog.txt",user_id .. " freed "..target_id.." from a " .. custom .. " minutes sentence")
				else
				  LVLclient.notify(player,{"~r~That ID seems invalid."})
				end
			  else
				LVLclient.notify(player,{"~r~Target is not jailed."})
			  end
			end
		  end
		end})
      else
        LVLclient.notify(player,{"~r~No player ID selected."})
      end 
	end})
end,"Frees a jailed player."}

-- (server) called when a logged player spawn to check for LVL:jail in user_data
AddEventHandler("LVL:playerSpawn", function(user_id, source, first_spawn) 
  local target = LVL.getUserSource({user_id})
  SetTimeout(35000,function()
    local custom = {}
    LVL.getUData({user_id,"LVL:jail:time",function(value)
	  if value ~= nil then
	    custom = json.decode(value)
	    if custom ~= nil then
		  if tonumber(custom) > 0 then
			BMclient.loadFreeze(target,{false,false,false})
      TriggerClientEvent("LVL:UnFreezeRespawn", source)
			SetTimeout(1,function()
			  BMclient.loadFreeze(target,{false,false,false})
			end)
            LVLclient.setHandcuffed(target,{true})
            LVLclient.teleport(target,{1641.5477294922,2570.4819335938,45.564788818359}) -- teleport inside jail
            LVLclient.notify(target,{"~r~Finish your sentence."})
			LVL.setHunger({tonumber(user_id),0})
			LVL.setThirst({tonumber(user_id),0})
			LVLbm.logInfoToFile("jailLog.txt",user_id.." has been sent back to jail for " .. custom .. " minutes to complete his sentence")
		    jail_clock(tonumber(user_id),tonumber(custom))
		  end
	    end
	  end
	end})
  end)
end)

-- dynamic fine
local ch_fine = {function(player,choice) 
  LVLclient.getNearestPlayers(player,{15},function(nplayers) 
	local user_list = ""
    for k,v in pairs(nplayers) do
	  user_list = user_list .. "[" .. LVL.getUserId({k}) .. "]" .. GetPlayerName(k) .. " | "
    end 
	if user_list ~= "" then
	  LVL.prompt({player,"Players Nearby:" .. user_list,"",function(player,target_id) 
	    if target_id ~= nil and target_id ~= "" then 
	      LVL.prompt({player,"Fine amount:","100",function(player,fine)
			if fine ~= nil and fine ~= "" then 
	          LVL.prompt({player,"Fine reason:","",function(player,reason)
			    if reason ~= nil and reason ~= "" then 
	              local target = LVL.getUserSource({tonumber(target_id)})
				  if target ~= nil then
		            if tonumber(fine) > 100000 then
  			          fine = 100000
		            end
		            if tonumber(fine) < 100 then
		              fine = 100
		            end
			  
		            if LVL.tryFullPayment({tonumber(target_id), tonumber(fine)}) then
                      LVL.insertPoliceRecord({tonumber(target_id), lang.police.menu.fine.record({reason,fine})})
                      LVLclient.notify(player,{lang.police.menu.fine.fined({reason,fine})})
                      LVLclient.notify(target,{lang.police.menu.fine.notify_fined({reason,fine})})
					  local user_id = LVL.getUserId({player})
					  LVLbm.logInfoToFile("fineLog.txt",user_id .. " fined "..target_id.." the amount of " .. fine .. " for ".. reason)
                      LVL.closeMenu({player})
                    else
                      LVLclient.notify(player,{lang.money.not_enough()})
                    end
				  else
					LVLclient.notify(player,{"~r~That ID seems invalid."})
				  end
				else
				  LVLclient.notify(player,{"~r~You can't fine for no reason."})
				end
	          end})
			else
			  LVLclient.notify(player,{"~r~Your fine has to have a value."})
			end
	      end})
        else
          LVLclient.notify(player,{"~r~No player ID selected."})
        end 
	  end})
    else
      LVLclient.notify(player,{"~r~No player nearby."})
    end 
  end)
end,"Fines a nearby player."}

-- improved handcuff
local ch_handcuff = {function(player,choice)
  LVLclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = LVL.getUserId({nplayer})
    if nuser_id ~= nil then
      LVLclient.toggleHandcuff(nplayer,{})
	  local user_id = LVL.getUserId({player})
	  LVLbm.logInfoToFile("jailLog.txt",user_id .. " cuffed "..nuser_id)
      LVL.closeMenu({nplayer})
    else
      LVLclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.handcuff.description()}

-- admin god mode
local gods = {}
function task_god()
  SetTimeout(10000, task_god)

  for k,v in pairs(gods) do
    LVL.setHunger({v, 0})
    LVL.setThirst({v, 0})

    local player = LVL.getUserSource({v})
    if player ~= nil then
      LVLclient.setHealth(player, {200})
    end
  end
end
task_god()

local ch_godmode = {function(player,choice)
  local user_id = LVL.getUserId({player})
  if user_id ~= nil then
    if gods[player] then
	  gods[player] = nil
	  LVLclient.notify(player,{"~r~Godmode deactivated."})
	else
	  gods[player] = user_id
	  LVLclient.notify(player,{"~g~Godmode activated."})
	end
  end
end, "Toggles admin godmode."}

local player_lists = {}
local ch_userlist = {function(player,choice)
  local user_id = LVL.getUserId({player})
  if user_id ~= nil then
    if player_lists[player] then -- hide
      player_lists[player] = nil
      LVLclient.removeDiv(player,{"user_list"})
    else -- show
      local content = "<span class=\"id\">ID</span><span class=\"pseudo\">NICKNAME</span><span class=\"name\">ROLEPLAY NAME</span><span class=\"job\">PROFESSION</span>"
      local count = 0
	  local users = LVL.getUsers({})
      for k,v in pairs(users) do
        count = count+1
        local source = LVL.getUserSource({k})
        LVL.getUserIdentity({k, function(identity)
		  if source ~= nil then
            content = content.."<br /><span class=\"id\">"..k.."</span><span class=\"pseudo\">"..LVL.getPlayerName({source}).."</span>"
            if identity then
              content = content.."<span class=\"name\">"..htmlEntities.encode(identity.firstname).." "..htmlEntities.encode(identity.name).."</span><span class=\"job\">"..LVL.getUserGroupByType({k,"job"}).."</span>"
            end
          end
		  
          -- check end
          count = count-1
          if count == 0 then
            player_lists[player] = true
            local css = [[
              .div_user_list{ 
                margin: auto; 
				text-align: left;
                padding: 8px; 
                width: 650px; 
                margin-top: 100px; 
                background: rgba(50,50,50,0.0); 
                color: white; 
                font-weight: bold; 
                font-size: 1.1em;
              } 
              .div_user_list span{ 
				display: inline-block;
				text-align: center;
              } 
              .div_user_list .id{ 
                color: rgb(255, 255, 255);
                width: 45px; 
              }
              .div_user_list .pseudo{ 
                color: rgb(66, 244, 107);
                width: 145px; 
              }
              .div_user_list .name{ 
                color: rgb(92, 170, 249);
                width: 295px; 
              }
			  .div_user_list .job{ 
                color: rgb(247, 193, 93);
                width: 145px; 
			  }
            ]]
            LVLclient.setDiv(player,{"user_list", css, content})
          end
		end})
      end
    end
  end
end, "Toggles Userlist."}

function LVLbm.chargePhoneNumber(user_id,phone)
  local player = LVL.getUserSource({user_id})
  local directory_name = LVL.getPhoneDirectoryName({user_id, phone})
  if directory_name == "unknown" then
	directory_name = phone
  end
  LVL.prompt({player,"Amount to be charged to "..directory_name..":","0",function(player,charge)
	if charge ~= nil and charge ~= "" and tonumber(charge)>0 then 
	  LVL.getUserByPhone({phone, function(target_id)
		if target_id~=nil then
			if charge ~= nil and charge ~= "" then 
	          local target = LVL.getUserSource({target_id})
			  if target ~= nil then
				LVL.getUserIdentity({user_id, function(identity)
				  local my_directory_name = LVL.getPhoneDirectoryName({target_id, identity.phone})
				  if my_directory_name == "unknown" then
				    my_directory_name = identity.phone
				  end
			      local text = "~g~" .. my_directory_name .. "~w~ is charging you ~r~£" .. charge .. "~w~ for his services."
				  LVL.request({target,text,600,function(req_player,ok)
				    if ok then
					  local target_bank = LVL.getBankMoney({target_id}) - tonumber(charge)
					  local my_bank = LVL.getBankMoney({user_id}) + tonumber(charge)
		              if target_bank>0 then
					    LVL.setBankMoney({user_id,my_bank})
					    LVL.setBankMoney({target_id,target_bank})
					    LVLclient.notify(player,{"You charged ~y~£"..charge.." ~w~from ~g~"..directory_name .."~w~ for your services."})
						LVLclient.notify(target,{"~g~"..my_directory_name.."~w~ charged you ~r~£"..charge.."~w~ for his services."})
					    --LVLbm.logInfoToFile("mchargeLog.txt",user_id .. " mobile charged "..target_id.." the amount of " .. charge .. ", user bank post-payment for "..user_id.." equals £"..my_bank.." and for "..user_id.." equals £"..target_bank)
					    LVL.closeMenu({player})
                      else
                        LVLclient.notify(target,{lang.money.not_enough()})
                        LVLclient.notify(player,{"~g~" .. directory_name .. "~w~ tried to, but~r~ can't~w~ pay for your services."})
                      end
				    else
                      LVLclient.notify(player,{"~g~" .. directory_name .. "~r~ refused~w~ to pay for your services."})
				    end
				  end})
				end})
			  else
			    LVLclient.notify(player,{"~r~You can't make charges to offline players."})
			  end
			else
			  LVLclient.notify(player,{"~r~Your charge has to have a value."})
			end
		else
		  LVLclient.notify(player,{"~r~That phone number seems invalid."})
		end
	  end})
	else
	  LVLclient.notify(player,{"~r~The value has to be bigger than 0."})
	end
  end})
end

function LVLbm.payPhoneNumber(user_id,phone)
  local player = LVL.getUserSource({user_id})
  local directory_name = LVL.getPhoneDirectoryName({user_id, phone})
  if directory_name == "unknown" then
	directory_name = phone
  end
  LVL.prompt({player,"Amount to be sent to "..directory_name..":","0",function(player,transfer)
	if transfer ~= nil and transfer ~= "" and tonumber(transfer)>0 then 
	  LVL.getUserByPhone({phone, function(target_id)
	    local my_bank = LVL.getBankMoney({user_id}) - tonumber(transfer)
		if target_id~=nil then
          if my_bank >= 0 then
		    local target = LVL.getUserSource({target_id})
			if target ~= nil then
			  LVL.setBankMoney({user_id,my_bank})
              LVLclient.notify(player,{"~g~You tranfered ~r~£"..transfer.." ~g~to ~g~"..directory_name})
			  local target_bank = LVL.getBankMoney({target_id}) + tonumber(transfer)
			  LVL.setBankMoney({target_id,target_bank})
			  LVLbm.logInfoToFile("mpayLog.txt",user_id .. " mobile paid "..target_id.." the amount of " .. transfer .. ", user bank post-payment for "..user_id.." equals £"..my_bank.." and for "..user_id.." equals £"..target_bank)
			  LVL.getUserIdentity({user_id, function(identity)
		        local my_directory_name = LVL.getPhoneDirectoryName({target_id, identity.phone})
			    if my_directory_name == "unknown" then
		          my_directory_name = identity.phone
			    end
                LVLclient.notify(target,{"~g~You received ~y~£"..transfer.." ~g~from ~g~"..my_directory_name})
			  end})
              LVL.closeMenu({player})
			else
			  LVLclient.notify(player,{"~r~You can't make payments to offline players."})
			end
          else
            LVLclient.notify(player,{lang.money.not_enough()})
          end
		else
		  LVLclient.notify(player,{"~r~That phone number seems invalid."})
		end
	  end})
	else
	  LVLclient.notify(player,{"~r~The value has to be bigger than 0."})
	end
  end})
end

-- mobilepay
local ch_mobilepay = {function(player,choice) 
	local user_id = LVL.getUserId({player})
	local menu = {}
	menu.name = lang.phone.directory.title()
	menu.css = {top = "75px", header_color = "rgba(0,0,255,0.75)"}
    menu.onclose = function(player) LVL.openMainMenu({player}) end -- nest menu
	menu[">Type Number"] = {
	  -- payment function
	  function(player,choice) 
	    LVL.prompt({player,"Phone Number:","000-0000",function(player,phone)
	      if phone ~= nil and phone ~= "" then 
		    LVLbm.payPhoneNumber(user_id,phone)
		  else
		    LVLclient.notify(player,{"~r~You have to digit a phone number."})
		  end
	    end})
	  end,"Type the phone number manually."}
	local directory = LVL.getPhoneDirectory({user_id})
	for k,v in pairs(directory) do
	  menu[k] = {
	    -- payment function
	    function(player,choice) 
		  LVLbm.payPhoneNumber(user_id,v)
	    end
	  ,v} -- number as description
	end
	LVL.openMenu({player, menu})
end,"Transfer money trough phone."}

-- mobilecharge
local ch_mobilecharge = {function(player,choice) 
	local user_id = LVL.getUserId({player})
	local menu = {}
	menu.name = lang.phone.directory.title()
	menu.css = {top = "75px", header_color = "rgba(0,0,255,0.75)"}
    menu.onclose = function(player) LVL.openMainMenu({player}) end -- nest menu
	menu[">Type Number"] = {
	  -- payment function
	  function(player,choice) 
	    LVL.prompt({player,"Phone Number:","000-0000",function(player,phone)
	      if phone ~= nil and phone ~= "" then 
		    LVLbm.chargePhoneNumber(user_id,phone)
		  else
		    LVLclient.notify(player,{"~r~You have to digit a phone number."})
		  end
	    end})
	  end,"Type the phone number manually."}
	local directory = LVL.getPhoneDirectory({user_id})
	for k,v in pairs(directory) do
	  menu[k] = {
	    -- payment function
	    function(player,choice) 
		  LVLbm.chargePhoneNumber(user_id,v)
	    end
	  ,v} -- number as description
	end
	LVL.openMenu({player, menu})
end,"Charge money trough phone."}

-- spawn vehicle
local ch_spawnveh = {function(player,choice) 
	LVL.prompt({player,"Vehicle Model:","",function(player,model)
	  if model ~= nil and model ~= "" then 
	    BMclient.spawnVehicle(player,{model})
	  else
		LVLclient.notify(player,{"~r~You have to type a vehicle model."})
	  end
	end})
end,"Spawn a vehicle model."}

-- lockpick vehicle
local ch_lockpickveh = {function(player,choice) 
	BMclient.lockpickVehicle(player,{20,true}) -- 20s to lockpick, allow to carjack unlocked vehicles (has to be true for NoCarJack Compatibility)
end,"Lockpick closest vehicle."}

-- dynamic freeze
local ch_freeze = {function(player,choice) 
	local user_id = LVL.getUserId({player})
	if LVL.hasPermission({user_id,"admin.bm_freeze"}) then
	  LVL.prompt({player,"Player ID:","",function(player,target_id) 
	    if target_id ~= nil and target_id ~= "" then 
	      local target = LVL.getUserSource({tonumber(target_id)})
		  if target ~= nil then
		    LVLclient.notify(player,{"~g~You un/froze that player."})
		    BMclient.loadFreeze(target,{true,true,true})
		  else
		    LVLclient.notify(player,{"~r~That ID seems invalid."})
		  end
        else
          LVLclient.notify(player,{"~r~No player ID selected."})
        end 
	  end})
	else
	  LVLclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = LVL.getUserId({nplayer})
        if nuser_id ~= nil then
		  LVLclient.notify(player,{"~g~You un/froze that player."})
		  BMclient.loadFreeze(nplayer,{true,false,false})
        else
          LVLclient.notify(player,{lang.common.no_player_near()})
        end
      end)
	end
end,"Freezes a player."}

-- lockpicking item
LVL.defInventoryItem({"lockpicking_kit","Lockpicking Kit","Used to lockpick vehicles.", -- add it for sale to lvl/cfg/markets.lua if you want to use it
function(args)
  local choices = {}

  choices["Lockpick"] = {function(player,choice)
    local user_id = LVL.getUserId({player})
    if user_id ~= nil then
      if LVL.tryGetInventoryItem({user_id, "lockpicking_kit", 1, true}) then
		BMclient.lockpickVehicle(player,{20,true}) -- 20s to lockpick, allow to carjack unlocked vehicles (has to be true for NoCarJack Compatibility)
        LVL.closeMenu({player})
      end
    end
  end,"Lockpick closest vehicle."}

  return choices
end,
5.00})

-- ADD STATIC MENU CHOICES // STATIC MENUS NEED TO BE ADDED AT LVL/cfg/gui.lua
LVL.addStaticMenuChoices({"police_weapons", police_weapons}) -- police gear
LVL.addStaticMenuChoices({"emergency_medkit", emergency_medkit}) -- pills and medkits
LVL.addStaticMenuChoices({"emergency_heal", emergency_heal}) -- heal button

-- REMEMBER TO ADD THE PERMISSIONS FOR WHAT YOU WANT TO USE
-- CREATES PLAYER SUBMENU AND ADD CHOICES
local ch_player_menu = {function(player,choice)
	local user_id = LVL.getUserId({player})
	local menu = {}
	menu.name = "Player"
	menu.css = {top = "75px", header_color = "rgba(0,0,255,0.75)"}
    menu.onclose = function(player) LVL.openMainMenu({player}) end -- nest menu
		
    if LVL.hasPermission({user_id,"player.fix_haircut"}) then
      menu["Fix Haircut"] = ch_fixhair -- just a work around for barbershop green hair bug while I am busy
    end
	
    if LVL.hasPermission({user_id,"player.userlist"}) then
      menu["User List"] = ch_userlist -- a user list for players with LVL ids, player name and identity names only.
    end
	
    if LVL.hasPermission({user_id,"player.store_armor"}) then
      menu["Store armor"] = choice_store_armor -- store player armor
    end
	
    if LVL.hasPermission({user_id,"player.check"}) then
      menu["Inspect"] = choice_player_check -- checks nearest player inventory, like police check from lvl
    end
	
	LVL.openMenu({player, menu})
end}

-- REGISTER MAIN MENU CHOICES
LVL.registerMenuBuilder({"main", function(add, data)
  local user_id = LVL.getUserId({data.player})
  if user_id ~= nil then
    local choices = {}
	
    if LVL.hasPermission({user_id,"player.player_menu"}) then
      choices["Player"] = ch_player_menu -- opens player submenu
    end
	
    if LVL.hasPermission({user_id,"toggle.service"}) then
      choices["Service"] = choice_service -- toggle the receiving of missions
    end
	
    if LVL.hasPermission({user_id,"player.loot"}) then
      choices["Loot"] = choice_loot -- take the items of nearest player in coma
    end
	
    if LVL.hasPermission({user_id,"mugger.mug"}) then
      choices["Mug"] = ch_mug -- steal nearest player wallet
    end
	
    if LVL.hasPermission({user_id,"hacker.hack"}) then
      choices["Hack"] = ch_hack --  1 in 100 chance of stealing 1% of nearest player bank
    end
	
    if LVL.hasPermission({user_id,"carjacker.lockpick"}) then
      choices["Lockpick"] = ch_lockpickveh -- opens a locked vehicle
    end
	
    add(choices)
  end
end})

-- RESGISTER ADMIN MENU CHOICES
LVL.registerMenuBuilder({"admin", function(add, data)
  local user_id = LVL.getUserId({data.player})
  if user_id ~= nil then
    local choices = {}
	
	if LVL.hasPermission({user_id,"admin.deleteveh"}) then
      choices["DeleteVeh"] = ch_deleteveh -- Delete nearest vehicle (Fixed pull request https://github.com/Sighmir/lvl_basic_menu/pull/11/files/419405349ca0ad2a215df90cfcf656e7aa0f5e9c from benjatw)
	end
	
	if LVL.hasPermission({user_id,"admin.spawnveh"}) then
      choices["SpawnVeh"] = ch_spawnveh -- Spawn a vehicle model
	end
	
	if LVL.hasPermission({user_id,"admin.godmode"}) then
      choices["Godmode"] = ch_godmode -- Toggles admin godmode (Disable the default admin.god permission to use this!) 
	end
	
    if LVL.hasPermission({user_id,"player.blips"}) then
      choices["Blips"] = ch_blips -- turn on map blips and sprites
    end
	
    if LVL.hasPermission({user_id,"player.sprites"}) then
      choices["Sprites"] = ch_sprites -- turn on only name sprites
    end
	
    if LVL.hasPermission({user_id,"admin.crun"}) then
      choices["Crun"] = ch_crun -- run any client command, any GTA V client native http://www.dev-c.com/nativedb/
    end
	
    if LVL.hasPermission({user_id,"admin.srun"}) then
      choices["Srun"] = ch_srun -- run any server command, any GTA V server native http://www.dev-c.com/nativedb/
    end

	if LVL.hasPermission({user_id,"player.tptowaypoint"}) then
      choices["TpToWaypoint"] = choice_tptowaypoint -- teleport user to map blip
	end
	
	if LVL.hasPermission({user_id,"admin.easy_unjail"}) then
      choices["UnJail"] = ch_unjail -- Un jails chosen player if he is jailed (Use admin.easy_unjail as permission to have this in admin menu working in non jailed players)
    end
	
	if LVL.hasPermission({user_id,"admin.spikes"}) then
      choices["Spikes"] = ch_spikes -- Toggle spikes
    end
	
	if LVL.hasPermission({user_id,"admin.bm_freeze"}) then
      choices["Freeze"] = ch_freeze -- Toggle freeze
    end
	
    add(choices)
  end
end})

-- REGISTER POLICE MENU CHOICES
LVL.registerMenuBuilder({"police", function(add, data)
  local user_id = LVL.getUserId({data.player})
  if user_id ~= nil then
    local choices = {}
	
	if LVL.hasPermission({user_id,"police.easy_jail"}) then
      choices["Easy Jail"] = ch_jail -- Send a nearby handcuffed player to jail with prompt for choice and user_list
    end
	
	if LVL.hasPermission({user_id,"police.easy_unjail"}) then
      choices["Easy UnJail"] = ch_unjail -- Un jails chosen player if he is jailed (Use admin.easy_unjail as permission to have this in admin menu working in non jailed players)
    end
	
	if LVL.hasPermission({user_id,"police.easy_fine"}) then
      choices["Easy Fine"] = ch_fine -- Fines closeby player
    end
	
	if LVL.hasPermission({user_id,"police.easy_cuff"}) then
      choices["Easy Cuff"] = ch_handcuff -- Toggle cuffs AND CLOSE MENU for nearby player
    end
	
	if LVL.hasPermission({user_id,"police.spikes"}) then
      choices["Spikes"] = ch_spikes -- Toggle spikes
    end
	
    if LVL.hasPermission({user_id,"police.drag"}) then
      choices["Drag"] = ch_drag -- Drags closest handcuffed player
    end
	
	if LVL.hasPermission({user_id,"police.bm_freeze"}) then
      choices["Freeze"] = ch_freeze -- Toggle freeze
    end
	
    add(choices)
  end
end})

-- REGISTER PHONE MENU CHOICES
-- TO USE THIS FUNCTION YOU NEED TO HAVE THE ORIGINAL LVL UPDATED TO THE LASTEST VERSION
LVL.registerMenuBuilder({"phone", function(add) -- phone menu is created on server start, so it has no permissions.
    local choices = {} -- Comment the choices you want to disable by adding -- in front of them.
	
    choices["PayPal"] = ch_mobilepay -- transfer money through phone
    choices["PaypalReq"] = ch_mobilecharge -- charge money through phone
	
    add(choices)
end})
