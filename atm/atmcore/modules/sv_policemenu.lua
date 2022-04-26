local lang = ATM.lang
local cfg = module("cfg/police")

RegisterServerEvent('ATM:OpenPoliceMenu')
AddEventHandler('ATM:OpenPoliceMenu', function()
    local source = source
    local user_id = ATM.getUserId(source)
    if user_id ~= nil and ATM.hasPermission(user_id, "police.menu") then
        TriggerClientEvent("ATM:PoliceMenuOpened", source)
    elseif user_id ~= nil and ATM.hasPermission(user_id, "clockon.menu") then
      ATMclient.notify(source,{"You are not on duty"})
    else
      print("You are not a part of the MET Police")
    end
end)

RegisterServerEvent('ATM:ActivateZone')
AddEventHandler('ATM:ActivateZone', function(message, speed, radius, x, y, z)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(171, 7, 7, 0.6); border-radius: 7px;"><i class="fas fa-exclamation-triangle"></i> MET Police: {0}</div>',
        args = { message }
    })
    TriggerClientEvent('ATM:ZoneCreated', -1, speed, radius, x, y, z)
end)

RegisterServerEvent('ATM:RemoveZone')
AddEventHandler('ATM:RemoveZone', function(blip)
    TriggerClientEvent('ATM:RemovedBlip', -1)
end)

RegisterServerEvent('ATM:Drag')
AddEventHandler('ATM:Drag', function()
    player = source
    local user_id = ATM.getUserId(player)
    if user_id ~= nil and ATM.hasPermission(user_id, "police.menu") then
        ATMclient.getNearestPlayer(player,{10},function(nplayer)
        if nplayer ~= nil then
            local nuser_id = ATM.getUserId(nplayer)
            if nuser_id ~= nil then
            ATMclient.isHandcuffed(nplayer,{},function(handcuffed)
                if handcuffed then
                    TriggerClientEvent("ATM:DragPlayer", nplayer, player)
                else
                    ATMclient.notify(player,{"~r~Player is not handcuffed."})
                end
            end)
            else
                ATMclient.notify(player,{"~r~There is no player nearby"})
            end
            else
                ATMclient.notify(player,{"~r~There is no player nearby"})
            end
        end)
    end
end)

RegisterServerEvent('ATM:Seize')
AddEventHandler('ATM:Seize', function()
  local source = source
    player = source
    local user_id = ATM.getUserId(player)
    if user_id ~= nil and ATM.hasPermission(user_id, "police.menu") then
            ATMclient.getNearestPlayer(player,{10},function(nplayer)
              ATMclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
                if handcuffed then 
            if nplayer ~= nil then
                local nuser_id = ATM.getUserId(nplayer)
                if nuser_id ~= nil then
                  RemoveAllPedWeapons(nplayer, true)
                  ATM.clearInventory(nuser_id) 
                  ATMclient.notify(player, {'~b~Seized players weapons'})
                  ATMclient.notify(nplayer, {'~r~Your weapons were seized'})
                else
                    ATMclient.notify(player,{"~r~There is no player nearby"})
                end
                else
                    ATMclient.notify(player,{"~r~There is no player nearby"})
                end
              else
                ATMclient.notify(player, {'~r~Player has to be cuffed.'})
              end
            end)
            end)
    end
end)

local isHandcuffed = false
RegisterServerEvent('ATM:Handcuff')
AddEventHandler('ATM:Handcuff', function()
  local source = source
    player = source
    user_id = ATM.getUserId(source)
    if ATM.hasPermission(user_id, "police.menu") then
      ATMclient.getNearestPlayer(player,{10},function(nplayer)
          local nuser_id = ATM.getUserId(nplayer)
          if nuser_id ~= nil then
            if not isHandcuffed then 
              TriggerClientEvent("ATM:PlaySound", source, "handcuff")
              TriggerClientEvent("ATM:PlaySound", nplayer, "handcuff")
              TriggerClientEvent("ATM:CuffAnim", source)
              TriggerClientEvent("ATM:ArrestAnim", nplayer)
              TriggerClientEvent('ATM:AttachPlayer', nplayer, source)
              isHandcuffed = true 
            else
                TriggerClientEvent("ATM:UnCuffAnim", source)
                TriggerClientEvent('ATM:AttachPlayer', nplayer, source)
                TriggerClientEvent("ATM:PlaySound", source, "handcuff")
                TriggerClientEvent("ATM:PlaySound", nplayer, "handcuff")
                isHandcuffed = false
            end
            Citizen.Wait(5000)
            ATMclient.toggleHandcuff(nplayer,{})
        

          else
            ATMclient.notify(player,{"~r~There is no player nearby"})
          end
      end)

    end
end)

local unjailed = {}
function jail_clock(target_id,timer)
  local target = ATM.getUserSource(tonumber(target_id))
  local users = ATM.getUsers()
  local online = false
  for k,v in pairs(users) do
	if tonumber(k) == tonumber(target_id) then
	  online = true
	end
  end
  if online then
    if timer>0 then
	  ATMclient.notify(target, {"~r~Remaining time: " .. timer .. " minute(s)."})
      ATM.setUData(tonumber(target_id),"ATM:jail:time",json.encode(timer))
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
	  ATMclient.teleport(target,{425.7607421875,-978.73425292969,30.709615707397}) -- teleport to outside jail
	  ATMclient.setHandcuffed(target,{false})
      ATMclient.notify(target,{"~b~You have been set free."})
	  ATM.setUData({tonumber(target_id),"ATM:jail:time",json.encode(-1)})
    end
  end
end

RegisterServerEvent('ATM:JailPlayer')
AddEventHandler('ATM:JailPlayer', function()
    player = source
    local user_id = ATM.getUserId(player)
    if user_id ~= nil and ATM.hasPermission(user_id, "police.menu") then
    ATMclient.getNearestPlayers(player,{15},function(nplayers) 
      local user_list = ""
      for k,v in pairs(nplayers) do
        user_list = user_list .. "[" .. ATM.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
      end 
      if user_list ~= "" then
        ATM.prompt(player,"Players Nearby:" .. user_list,"",function(player,target_id) 
          if target_id ~= nil and target_id ~= "" then 
            ATM.prompt(player,"Jail Time in minutes:","1",function(player,jail_time)
              if jail_time ~= nil and jail_time ~= "" then 
                local target = ATM.getUserSource(tonumber(target_id))
                if target ~= nil then
                  if tonumber(jail_time) > 60 then
                      jail_time = 60
                  end
                  if tonumber(jail_time) < 1 then
                    jail_time = 1
                  end
            
                  ATMclient.isHandcuffed(target,{}, function(handcuffed)  
                    if handcuffed then 
                        ATMclient.loadFreeze(target,{false,true,true})
                      SetTimeout(15000,function()
                        ATMclient.loadFreeze(target,{false,false,false})
                      end)
                      ATMclient.teleport(target,{1709.5927734375,2571.8068847656,50.189060211182}) -- teleport to inside jail
                      ATMclient.notify(target,{"~r~You have been sent to jail."})
                      ATMclient.notify(player,{"~b~You sent a player to jail."})
                      jail_clock(tonumber(target_id),tonumber(jail_time))
                      local user_id = ATM.getUserId(player)
                    else
                      ATMclient.notify(player,{"~r~That player is not handcuffed."})
                    end
                  end)
                else
                  ATMclient.notify(player,{"~r~That ID seems invalid."})
                end
              else
                ATMclient.notify(player,{"~r~The jail time can't be empty."})
              end
            end)
          else
            ATMclient.notify(player,{"~r~No player ID selected."})
          end 
        end)
      else
        ATMclient.notify(player,{"~r~No player nearby."})
      end 
    end)
    else
        print(user_id.." could be modding")
    end
end)

RegisterServerEvent('ATM:UnJailPlayer')
AddEventHandler('ATM:UnJailPlayer', function()
    player = source
    local user_id = ATM.getUserId(player)
    if user_id ~= nil and ATM.hasPermission(user_id, "police.menu") then
	ATM.prompt(player,"Player ID:","",function(player,target_id) 
	  if target_id ~= nil and target_id ~= "" then 
		ATM.getUData(tonumber(target_id),"ATM:jail:time",function(value)
		  if value ~= nil then
		  custom = json.decode(value)
			if custom ~= nil then
			  local user_id = ATM.getUserId(player)
			  if tonumber(custom) > 0 or ATM.hasPermission(user_id,"admin.easy_unjail") then
	            local target = ATM.getUserSource(tonumber(target_id))
				if target ~= nil then
	              unjailed[target] = tonumber(target_id)
				  ATMclient.notify(player,{"~g~Target will be released soon."})
				  ATMclient.notify(target,{"~g~Someone lowered your sentence."})
				else
				  ATMclient.notify(player,{"~r~That ID seems invalid."})
				end
			  else
				ATMclient.notify(player,{"~r~Target is not jailed."})
			  end
			end
		  end
		end)
      else
        ATMclient.notify(player,{"~r~No player ID selected."})
      end 
  end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterServerEvent('ATM:Fine')
AddEventHandler('ATM:Fine', function()
    player = source
    local user_id = ATM.getUserId(player)
    if user_id ~= nil and ATM.hasPermission(user_id, "police.menu") then
    ATMclient.getNearestPlayers(player,{15},function(nplayers) 
      local user_list = ""
      for k,v in pairs(nplayers) do
        user_list = user_list .. "[" .. ATM.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
      end 
      if user_list ~= "" then
        ATM.prompt(player,"Players Nearby:" .. user_list,"",function(player,target_id) 
          if target_id ~= nil and target_id ~= "" then 
            ATM.prompt(player,"Fine amount:","100",function(player,fine)
              if fine ~= nil and fine ~= "" then 
                ATM.prompt(player,"Fine reason:","",function(player,reason)
                  if reason ~= nil and reason ~= "" then 
                    local target = ATM.getUserSource(tonumber(target_id))
                    if target ~= nil then
                      if tonumber(fine) > 100000 then
                          fine = 100000
                      end
                      if tonumber(fine) < 100 then
                        fine = 100
                      end
                
                      if ATM.tryFullPayment(tonumber(target_id), tonumber(fine)) then
                        ATM.insertPoliceRecord(tonumber(target_id), lang.police.menu.fine.record({reason,fine}))
                        ATMclient.notify(player,{lang.police.menu.fine.fined({reason,fine})})
                        ATMclient.notify(target,{lang.police.menu.fine.notify_fined({reason,fine})})
                        local user_id = ATM.getUserId(player)
                        ATM.closeMenu(player)
                      else
                        ATMclient.notify(player,{lang.money.not_enough()})
                      end
                    else
                      ATMclient.notify(player,{"~r~That ID seems invalid."})
                    end
                  else
                    ATMclient.notify(player,{"~r~You can't fine for no reason."})
                  end
                end)
              else
                ATMclient.notify(player,{"~r~Your fine has to have a value."})
              end
            end)
          else
            ATMclient.notify(player,{"~r~No player ID selected."})
          end 
        end)
      else
        ATMclient.notify(player,{"~r~No player nearby."})
      end 
    end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterNetEvent("ATM:PutPlrInVeh")
AddEventHandler("ATM:PutPlrInVeh", function()
    player = source
    local user_id = ATM.getUserId(player)
    if user_id ~= nil and ATM.hasPermission(user_id, "police.menu") then
    ATMclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = ATM.getUserId(nplayer)
      if nuser_id ~= nil then
        ATMclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            ATMclient.putInNearestVehicleAsPassenger(nplayer, {5})
          else
            ATMclient.notify(player,{"person not cuffed"})
          end
        end)
      else
        ATMclient.notify(player,{"no one near"})
      end
    end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterNetEvent("ATM:TakeOutOfVehicle")
AddEventHandler("ATM:TakeOutOfVehicle", function()
    player = source
    local user_id = ATM.getUserId(player)
    if user_id ~= nil and ATM.hasPermission(user_id, "police.menu") then
    ATMclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = ATM.getUserId(nplayer)
        if nuser_id ~= nil then
        ATMclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
            if handcuffed then
            ATMclient.ejectVehicle(nplayer, {})
            else
            ATMclient.notify(player,{"person not cuffed"})
            end
        end)
        else
        ATMclient.notify(player,{"no one near"})
        end
    end)
    else
        print(user_id.." Could be modder")
    end
end)

RegisterNetEvent("ATM:SearchPlayer")
AddEventHandler("ATM:SearchPlayer", function()
    player = source
    if user_id ~= nil and ATM.hasPermission(user_id, "police.menu") then
      ATMclient.getNearestPlayer(player,{5},function(nplayer)
          local nuser_id = ATM.getUserId(nplayer)
          if nuser_id ~= nil then
            ATMclient.notify(nplayer,{lang.police.menu.check.checked()})
            ATMclient.getWeapons(nplayer,{},function(weapons)
              -- prepare display data (money, items, weapons)
              local money = ATM.getMoney(nuser_id)
              local items = ""
              local data = ATM.getUserDataTable(nuser_id)
              if data and data.inventory then
                for k,v in pairs(data.inventory) do
                  local item = ATM.items[k]
                  if item then
                    items = items.."<br />"..item.name.." ("..v.amount..")"
                  end
                end
              end
      
              local weapons_info = ""
              for k,v in pairs(weapons) do
                weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
              end
      
              ATMclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
              -- request to hide div
              ATM.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
                ATMclient.removeDiv(player,{"police_check"})
              end)
            end)
          else
            ATMclient.notify(player,{lang.common.no_player_near()})
          end
        end)
      end
end)