local lang = LVL.lang
local cfg = module("cfg/police")

RegisterServerEvent('LVL:OpenPoliceMenu')
AddEventHandler('LVL:OpenPoliceMenu', function()
    local source = source
    local user_id = LVL.getUserId(source)
    if user_id ~= nil and LVL.hasPermission(user_id, "police.menu") then
        TriggerClientEvent("LVL:PoliceMenuOpened", source)
    elseif user_id ~= nil and LVL.hasPermission(user_id, "clockon.menu") then
      LVLclient.notify(source,{"You are not on duty"})
    else
      print("You are not a part of the MET Police")
    end
end)

RegisterServerEvent('LVL:ActivateZone')
AddEventHandler('LVL:ActivateZone', function(message, speed, radius, x, y, z)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(171, 7, 7, 0.6); border-radius: 7px;"><i class="fas fa-exclamation-triangle"></i> MET Police: {0}</div>',
        args = { message }
    })
    TriggerClientEvent('LVL:ZoneCreated', -1, speed, radius, x, y, z)
end)

RegisterServerEvent('LVL:RemoveZone')
AddEventHandler('LVL:RemoveZone', function(blip)
    TriggerClientEvent('LVL:RemovedBlip', -1)
end)

RegisterServerEvent('LVL:Drag')
AddEventHandler('LVL:Drag', function()
    player = source
    local user_id = LVL.getUserId(player)
    if user_id ~= nil and LVL.hasPermission(user_id, "police.menu") then
        LVLclient.getNearestPlayer(player,{10},function(nplayer)
        if nplayer ~= nil then
            local nuser_id = LVL.getUserId(nplayer)
            if nuser_id ~= nil then
            LVLclient.isHandcuffed(nplayer,{},function(handcuffed)
                if handcuffed then
                    TriggerClientEvent("LVL:DragPlayer", nplayer, player)
                else
                    LVLclient.notify(player,{"~r~Player is not handcuffed."})
                end
            end)
            else
                LVLclient.notify(player,{"~r~There is no player nearby"})
            end
            else
                LVLclient.notify(player,{"~r~There is no player nearby"})
            end
        end)
    end
end)

RegisterServerEvent('LVL:Seize')
AddEventHandler('LVL:Seize', function()
  local source = source
    player = source
    local user_id = LVL.getUserId(player)
    if user_id ~= nil and LVL.hasPermission(user_id, "police.menu") then
            LVLclient.getNearestPlayer(player,{10},function(nplayer)
              LVLclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
                if handcuffed then 
            if nplayer ~= nil then
                local nuser_id = LVL.getUserId(nplayer)
                if nuser_id ~= nil then
                  RemoveAllPedWeapons(nplayer, true)
                  LVL.clearInventory(nuser_id) 
                  LVLclient.notify(player, {'~b~Seized players weapons'})
                  LVLclient.notify(nplayer, {'~r~Your weapons were seized'})
                else
                    LVLclient.notify(player,{"~r~There is no player nearby"})
                end
                else
                    LVLclient.notify(player,{"~r~There is no player nearby"})
                end
              else
                LVLclient.notify(player, {'~r~Player has to be cuffed.'})
              end
            end)
            end)
    end
end)

local isHandcuffed = false
RegisterServerEvent('LVL:Handcuff')
AddEventHandler('LVL:Handcuff', function()
  local source = source
    player = source
    user_id = LVL.getUserId(source)
    if LVL.hasPermission(user_id, "police.menu") then
      LVLclient.getNearestPlayer(player,{10},function(nplayer)
          local nuser_id = LVL.getUserId(nplayer)
          if nuser_id ~= nil then
            if not isHandcuffed then 
              TriggerClientEvent("LVL:PlaySound", source, "handcuff")
              TriggerClientEvent("LVL:PlaySound", nplayer, "handcuff")
              TriggerClientEvent("LVL:CuffAnim", source)
              TriggerClientEvent("LVL:ArrestAnim", nplayer)
              TriggerClientEvent('LVL:AttachPlayer', nplayer, source)
              isHandcuffed = true 
            else
                TriggerClientEvent("LVL:UnCuffAnim", source)
                TriggerClientEvent('LVL:AttachPlayer', nplayer, source)
                TriggerClientEvent("LVL:PlaySound", source, "handcuff")
                TriggerClientEvent("LVL:PlaySound", nplayer, "handcuff")
                isHandcuffed = false
            end
            Citizen.Wait(5000)
            LVLclient.toggleHandcuff(nplayer,{})
        

          else
            LVLclient.notify(player,{"~r~There is no player nearby"})
          end
      end)

    end
end)

local unjailed = {}
function jail_clock(target_id,timer)
  local target = LVL.getUserSource(tonumber(target_id))
  local users = LVL.getUsers()
  local online = false
  for k,v in pairs(users) do
	if tonumber(k) == tonumber(target_id) then
	  online = true
	end
  end
  if online then
    if timer>0 then
	  LVLclient.notify(target, {"~r~Remaining time: " .. timer .. " minute(s)."})
      LVL.setUData(tonumber(target_id),"LVL:jail:time",json.encode(timer))
	  SetTimeout(60*1000, function()
		for k,v in pairs(unjailed) do -- check if player has been unjailed by cop or admin
		  if v == tonumber(target_id) then
	        unjailed[v] = nil
		    timer = 0
		  end
		end
	    jail_clock(tonumber(target_id),timer-1)
	  end) 
    else 
	  BMclient.loadFreeze(target,{false,true,true})
	  SetTimeout(15000,function()
		BMclient.loadFreeze(target,{false,false,false})
	  end)
	  LVLclient.teleport(target,{425.7607421875,-978.73425292969,30.709615707397}) -- teleport to outside jail
	  LVLclient.setHandcuffed(target,{false})
      LVLclient.notify(target,{"~b~You have been set free."})
	  LVL.setUData({tonumber(target_id),"LVL:jail:time",json.encode(-1)})
    end
  end
end

RegisterServerEvent('LVL:JailPlayer')
AddEventHandler('LVL:JailPlayer', function()
    player = source
    local user_id = LVL.getUserId(player)
    if user_id ~= nil and LVL.hasPermission(user_id, "police.menu") then
    LVLclient.getNearestPlayers(player,{15},function(nplayers) 
      local user_list = ""
      for k,v in pairs(nplayers) do
        user_list = user_list .. "[" .. LVL.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
      end 
      if user_list ~= "" then
        LVL.prompt(player,"Players Nearby:" .. user_list,"",function(player,target_id) 
          if target_id ~= nil and target_id ~= "" then 
            LVL.prompt(player,"Jail Time in minutes:","1",function(player,jail_time)
              if jail_time ~= nil and jail_time ~= "" then 
                local target = LVL.getUserSource(tonumber(target_id))
                if target ~= nil then
                  if tonumber(jail_time) > 60 then
                      jail_time = 60
                  end
                  if tonumber(jail_time) < 1 then
                    jail_time = 1
                  end
            
                  LVLclient.isHandcuffed(target,{}, function(handcuffed)  
                    if handcuffed then 
                        LVLclient.loadFreeze(target,{false,true,true})
                      SetTimeout(15000,function()
                        LVLclient.loadFreeze(target,{false,false,false})
                      end)
                      LVLclient.teleport(target,{1709.5927734375,2571.8068847656,50.189060211182}) -- teleport to inside jail
                      LVLclient.notify(target,{"~r~You have been sent to jail."})
                      LVLclient.notify(player,{"~b~You sent a player to jail."})
                      jail_clock(tonumber(target_id),tonumber(jail_time))
                      local user_id = LVL.getUserId(player)
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
            end)
          else
            LVLclient.notify(player,{"~r~No player ID selected."})
          end 
        end)
      else
        LVLclient.notify(player,{"~r~No player nearby."})
      end 
    end)
    else
        print(user_id.." could be modding")
    end
end)

RegisterServerEvent('LVL:UnJailPlayer')
AddEventHandler('LVL:UnJailPlayer', function()
    player = source
    local user_id = LVL.getUserId(player)
    if user_id ~= nil and LVL.hasPermission(user_id, "police.menu") then
	LVL.prompt(player,"Player ID:","",function(player,target_id) 
	  if target_id ~= nil and target_id ~= "" then 
		LVL.getUData(tonumber(target_id),"LVL:jail:time",function(value)
		  if value ~= nil then
		  custom = json.decode(value)
			if custom ~= nil then
			  local user_id = LVL.getUserId(player)
			  if tonumber(custom) > 0 or LVL.hasPermission(user_id,"admin.easy_unjail") then
	            local target = LVL.getUserSource(tonumber(target_id))
				if target ~= nil then
	              unjailed[target] = tonumber(target_id)
				  LVLclient.notify(player,{"~b~Target will be released soon."})
				  LVLclient.notify(target,{"~b~Someone lowered your sentence."})
				else
				  LVLclient.notify(player,{"~r~That ID seems invalid."})
				end
			  else
				LVLclient.notify(player,{"~r~Target is not jailed."})
			  end
			end
		  end
		end)
      else
        LVLclient.notify(player,{"~r~No player ID selected."})
      end 
  end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterServerEvent('LVL:Fine')
AddEventHandler('LVL:Fine', function()
    player = source
    local user_id = LVL.getUserId(player)
    if user_id ~= nil and LVL.hasPermission(user_id, "police.menu") then
    LVLclient.getNearestPlayers(player,{15},function(nplayers) 
      local user_list = ""
      for k,v in pairs(nplayers) do
        user_list = user_list .. "[" .. LVL.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
      end 
      if user_list ~= "" then
        LVL.prompt(player,"Players Nearby:" .. user_list,"",function(player,target_id) 
          if target_id ~= nil and target_id ~= "" then 
            LVL.prompt(player,"Fine amount:","100",function(player,fine)
              if fine ~= nil and fine ~= "" then 
                LVL.prompt(player,"Fine reason:","",function(player,reason)
                  if reason ~= nil and reason ~= "" then 
                    local target = LVL.getUserSource(tonumber(target_id))
                    if target ~= nil then
                      if tonumber(fine) > 100000 then
                          fine = 100000
                      end
                      if tonumber(fine) < 100 then
                        fine = 100
                      end
                
                      if LVL.tryFullPayment(tonumber(target_id), tonumber(fine)) then
                        LVL.insertPoliceRecord(tonumber(target_id), lang.police.menu.fine.record({reason,fine}))
                        LVLclient.notify(player,{lang.police.menu.fine.fined({reason,fine})})
                        LVLclient.notify(target,{lang.police.menu.fine.notify_fined({reason,fine})})
                        local user_id = LVL.getUserId(player)
                        LVL.closeMenu(player)
                      else
                        LVLclient.notify(player,{lang.money.not_enough()})
                      end
                    else
                      LVLclient.notify(player,{"~r~That ID seems invalid."})
                    end
                  else
                    LVLclient.notify(player,{"~r~You can't fine for no reason."})
                  end
                end)
              else
                LVLclient.notify(player,{"~r~Your fine has to have a value."})
              end
            end)
          else
            LVLclient.notify(player,{"~r~No player ID selected."})
          end 
        end)
      else
        LVLclient.notify(player,{"~r~No player nearby."})
      end 
    end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterNetEvent("LVL:PutPlrInVeh")
AddEventHandler("LVL:PutPlrInVeh", function()
    player = source
    local user_id = LVL.getUserId(player)
    if user_id ~= nil and LVL.hasPermission(user_id, "police.menu") then
    LVLclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = LVL.getUserId(nplayer)
      if nuser_id ~= nil then
        LVLclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            LVLclient.putInNearestVehicleAsPassenger(nplayer, {5})
          else
            LVLclient.notify(player,{"person not cuffed"})
          end
        end)
      else
        LVLclient.notify(player,{"no one near"})
      end
    end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterNetEvent("LVL:TakeOutOfVehicle")
AddEventHandler("LVL:TakeOutOfVehicle", function()
    player = source
    local user_id = LVL.getUserId(player)
    if user_id ~= nil and LVL.hasPermission(user_id, "police.menu") then
    LVLclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = LVL.getUserId(nplayer)
        if nuser_id ~= nil then
        LVLclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
            if handcuffed then
            LVLclient.ejectVehicle(nplayer, {})
            else
            LVLclient.notify(player,{"person not cuffed"})
            end
        end)
        else
        LVLclient.notify(player,{"no one near"})
        end
    end)
    else
        print(user_id.." Could be modder")
    end
end)

RegisterNetEvent("LVL:SearchPlayer")
AddEventHandler("LVL:SearchPlayer", function()
    player = source
    if user_id ~= nil and LVL.hasPermission(user_id, "police.menu") then
      LVLclient.getNearestPlayer(player,{5},function(nplayer)
          local nuser_id = LVL.getUserId(nplayer)
          if nuser_id ~= nil then
            LVLclient.notify(nplayer,{lang.police.menu.check.checked()})
            LVLclient.getWeapons(nplayer,{},function(weapons)
              -- prepare display data (money, items, weapons)
              local money = LVL.getMoney(nuser_id)
              local items = ""
              local data = LVL.getUserDataTable(nuser_id)
              if data and data.inventory then
                for k,v in pairs(data.inventory) do
                  local item = LVL.items[k]
                  if item then
                    items = items.."<br />"..item.name.." ("..v.amount..")"
                  end
                end
              end
      
              local weapons_info = ""
              for k,v in pairs(weapons) do
                weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
              end
      
              LVLclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
              -- request to hide div
              LVL.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
                LVLclient.removeDiv(player,{"police_check"})
              end)
            end)
          else
            LVLclient.notify(player,{lang.common.no_player_near()})
          end
        end)
      end
end)