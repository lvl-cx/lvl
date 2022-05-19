local lang = ARMA.lang
local cfg = module("cfg/police")

RegisterServerEvent('ARMA:OpenPoliceMenu')
AddEventHandler('ARMA:OpenPoliceMenu', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil and ARMA.hasPermission(user_id, "police.menu") then
        TriggerClientEvent("ARMA:PoliceMenuOpened", source)
    elseif user_id ~= nil and ARMA.hasPermission(user_id, "clockon.menu") then
      ARMAclient.notify(source,{"You are not on duty"})
    else
      print("You are not a part of the MET Police")
    end
end)

RegisterServerEvent('ARMA:ActivateZone')
AddEventHandler('ARMA:ActivateZone', function(message, speed, radius, x, y, z)
    TriggerClientEvent('chat:addMessage', -1, {
        template = 'MET Police: {0}</div>',
        args = { message }
    })
    TriggerClientEvent('ARMA:ZoneCreated', -1, speed, radius, x, y, z)
end)

RegisterServerEvent('ARMA:RemoveZone')
AddEventHandler('ARMA:RemoveZone', function(blip)
    TriggerClientEvent('ARMA:RemovedBlip', -1)
end)

RegisterServerEvent('ARMA:Drag')
AddEventHandler('ARMA:Drag', function()
    player = source
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil and ARMA.hasPermission(user_id, "police.menu") then
        ARMAclient.getNearestPlayer(player,{10},function(nplayer)
        if nplayer ~= nil then
            local nuser_id = ARMA.getUserId(nplayer)
            if nuser_id ~= nil then
            ARMAclient.isHandcuffed(nplayer,{},function(handcuffed)
                if handcuffed then
                    TriggerClientEvent("ARMA:DragPlayer", nplayer, player)
                else
                    ARMAclient.notify(player,{"~r~Player is not handcuffed."})
                end
            end)
            else
                ARMAclient.notify(player,{"~r~There is no player nearby"})
            end
            else
                ARMAclient.notify(player,{"~r~There is no player nearby"})
            end
        end)
    end
end)

RegisterServerEvent('ARMA:Seize')
AddEventHandler('ARMA:Seize', function()
  local source = source
    player = source
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil and ARMA.hasPermission(user_id, "police.menu") then
            ARMAclient.getNearestPlayer(player,{10},function(nplayer)
              ARMAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
                if handcuffed then 
            if nplayer ~= nil then
                local nuser_id = ARMA.getUserId(nplayer)
                if nuser_id ~= nil then
                  RemoveAllPedWeapons(nplayer, true)
                  ARMA.clearInventory(nuser_id) 
                  ARMAclient.notify(player, {'~g~Seized players weapons'})
                  ARMAclient.notify(nplayer, {'~r~Your weapons were seized'})
                else
                    ARMAclient.notify(player,{"~r~There is no player nearby"})
                end
                else
                    ARMAclient.notify(player,{"~r~There is no player nearby"})
                end
              else
                ARMAclient.notify(player, {'~r~Player has to be cuffed.'})
              end
            end)
            end)
    end
end)

local isHandcuffed = false
RegisterServerEvent('ARMA:Handcuff')
AddEventHandler('ARMA:Handcuff', function()
  local source = source
    player = source
    user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "police.menu") then
      ARMAclient.getNearestPlayer(player,{10},function(nplayer)
          local nuser_id = ARMA.getUserId(nplayer)
          if nuser_id ~= nil then
            if not isHandcuffed then 
              TriggerClientEvent("ARMA:PlaySound", source, "handcuff")
              TriggerClientEvent("ARMA:PlaySound", nplayer, "handcuff")
              TriggerClientEvent("ARMA:CuffAnim", source)
              TriggerClientEvent("ARMA:ArrestAnim", nplayer)
              TriggerClientEvent('ARMA:AttachPlayer', nplayer, source)
              isHandcuffed = true 
            else
                TriggerClientEvent("ARMA:UnCuffAnim", source)
                TriggerClientEvent('ARMA:AttachPlayer', nplayer, source)
                TriggerClientEvent("ARMA:PlaySound", source, "handcuff")
                TriggerClientEvent("ARMA:PlaySound", nplayer, "handcuff")
                isHandcuffed = false
            end
            Citizen.Wait(5000)
            ARMAclient.toggleHandcuff(nplayer,{})
        

          else
            ARMAclient.notify(player,{"~r~There is no player nearby"})
          end
      end)

    end
end)

local unjailed = {}
function jail_clock(target_id,timer)
  local target = ARMA.getUserSource(tonumber(target_id))
  local users = ARMA.getUsers()
  local online = false
  for k,v in pairs(users) do
	if tonumber(k) == tonumber(target_id) then
	  online = true
	end
  end
  if online then
    if timer>0 then
	  ARMAclient.notify(target, {"~r~Remaining time: " .. timer .. " minute(s)."})
      ARMA.setUData(tonumber(target_id),"ARMA:jail:time",json.encode(timer))
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
	  ARMAclient.teleport(target,{425.7607421875,-978.73425292969,30.709615707397}) -- teleport to outside jail
	  ARMAclient.setHandcuffed(target,{false})
      ARMAclient.notify(target,{"~g~You have been set free."})
	  ARMA.setUData({tonumber(target_id),"ARMA:jail:time",json.encode(-1)})
    end
  end
end

RegisterServerEvent('ARMA:JailPlayer')
AddEventHandler('ARMA:JailPlayer', function()
    player = source
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil and ARMA.hasPermission(user_id, "police.menu") then
    ARMAclient.getNearestPlayers(player,{15},function(nplayers) 
      local user_list = ""
      for k,v in pairs(nplayers) do
        user_list = user_list .. "[" .. ARMA.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
      end 
      if user_list ~= "" then
        ARMA.prompt(player,"Players Nearby:" .. user_list,"",function(player,target_id) 
          if target_id ~= nil and target_id ~= "" then 
            ARMA.prompt(player,"Jail Time in minutes:","1",function(player,jail_time)
              if jail_time ~= nil and jail_time ~= "" then 
                local target = ARMA.getUserSource(tonumber(target_id))
                if target ~= nil then
                  if tonumber(jail_time) > 60 then
                      jail_time = 60
                  end
                  if tonumber(jail_time) < 1 then
                    jail_time = 1
                  end
            
                  ARMAclient.isHandcuffed(target,{}, function(handcuffed)  
                    if handcuffed then 
                        ARMAclient.loadFreeze(target,{false,true,true})
                      SetTimeout(15000,function()
                        ARMAclient.loadFreeze(target,{false,false,false})
                      end)
                      ARMAclient.teleport(target,{1709.5927734375,2571.8068847656,50.189060211182}) -- teleport to inside jail
                      ARMAclient.notify(target,{"~r~You have been sent to jail."})
                      ARMAclient.notify(player,{"~g~You sent a player to jail."})
                      jail_clock(tonumber(target_id),tonumber(jail_time))
                      local user_id = ARMA.getUserId(player)
                    else
                      ARMAclient.notify(player,{"~r~That player is not handcuffed."})
                    end
                  end)
                else
                  ARMAclient.notify(player,{"~r~That ID seems invalid."})
                end
              else
                ARMAclient.notify(player,{"~r~The jail time can't be empty."})
              end
            end)
          else
            ARMAclient.notify(player,{"~r~No player ID selected."})
          end 
        end)
      else
        ARMAclient.notify(player,{"~r~No player nearby."})
      end 
    end)
    else
        print(user_id.." could be modding")
    end
end)

RegisterServerEvent('ARMA:UnJailPlayer')
AddEventHandler('ARMA:UnJailPlayer', function()
    player = source
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil and ARMA.hasPermission(user_id, "police.menu") then
	ARMA.prompt(player,"Player ID:","",function(player,target_id) 
	  if target_id ~= nil and target_id ~= "" then 
		ARMA.getUData(tonumber(target_id),"ARMA:jail:time",function(value)
		  if value ~= nil then
		  custom = json.decode(value)
			if custom ~= nil then
			  local user_id = ARMA.getUserId(player)
			  if tonumber(custom) > 0 or ARMA.hasPermission(user_id,"admin.easy_unjail") then
	            local target = ARMA.getUserSource(tonumber(target_id))
				if target ~= nil then
	              unjailed[target] = tonumber(target_id)
				  ARMAclient.notify(player,{"~g~Target will be released soon."})
				  ARMAclient.notify(target,{"~g~Someone lowered your sentence."})
				else
				  ARMAclient.notify(player,{"~r~That ID seems invalid."})
				end
			  else
				ARMAclient.notify(player,{"~r~Target is not jailed."})
			  end
			end
		  end
		end)
      else
        ARMAclient.notify(player,{"~r~No player ID selected."})
      end 
  end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterServerEvent('ARMA:Fine')
AddEventHandler('ARMA:Fine', function()
    player = source
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil and ARMA.hasPermission(user_id, "police.menu") then
    ARMAclient.getNearestPlayers(player,{15},function(nplayers) 
      local user_list = ""
      for k,v in pairs(nplayers) do
        user_list = user_list .. "[" .. ARMA.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
      end 
      if user_list ~= "" then
        ARMA.prompt(player,"Players Nearby:" .. user_list,"",function(player,target_id) 
          if target_id ~= nil and target_id ~= "" then 
            ARMA.prompt(player,"Fine amount:","100",function(player,fine)
              if fine ~= nil and fine ~= "" then 
                ARMA.prompt(player,"Fine reason:","",function(player,reason)
                  if reason ~= nil and reason ~= "" then 
                    local target = ARMA.getUserSource(tonumber(target_id))
                    if target ~= nil then
                      if tonumber(fine) > 100000 then
                          fine = 100000
                      end
                      if tonumber(fine) < 100 then
                        fine = 100
                      end
                
                      if ARMA.tryFullPayment(tonumber(target_id), tonumber(fine)) then
                        ARMA.insertPoliceRecord(tonumber(target_id), lang.police.menu.fine.record({reason,fine}))
                        ARMAclient.notify(player,{lang.police.menu.fine.fined({reason,fine})})
                        ARMAclient.notify(target,{lang.police.menu.fine.notify_fined({reason,fine})})
                        local user_id = ARMA.getUserId(player)
                        ARMA.closeMenu(player)
                      else
                        ARMAclient.notify(player,{lang.money.not_enough()})
                      end
                    else
                      ARMAclient.notify(player,{"~r~That ID seems invalid."})
                    end
                  else
                    ARMAclient.notify(player,{"~r~You can't fine for no reason."})
                  end
                end)
              else
                ARMAclient.notify(player,{"~r~Your fine has to have a value."})
              end
            end)
          else
            ARMAclient.notify(player,{"~r~No player ID selected."})
          end 
        end)
      else
        ARMAclient.notify(player,{"~r~No player nearby."})
      end 
    end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterNetEvent("ARMA:PutPlrInVeh")
AddEventHandler("ARMA:PutPlrInVeh", function()
    player = source
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil and ARMA.hasPermission(user_id, "police.menu") then
    ARMAclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = ARMA.getUserId(nplayer)
      if nuser_id ~= nil then
        ARMAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            ARMAclient.putInNearestVehicleAsPassenger(nplayer, {5})
          else
            ARMAclient.notify(player,{"person not cuffed"})
          end
        end)
      else
        ARMAclient.notify(player,{"no one near"})
      end
    end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterNetEvent("ARMA:TakeOutOfVehicle")
AddEventHandler("ARMA:TakeOutOfVehicle", function()
    player = source
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil and ARMA.hasPermission(user_id, "police.menu") then
    ARMAclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = ARMA.getUserId(nplayer)
        if nuser_id ~= nil then
        ARMAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
            if handcuffed then
            ARMAclient.ejectVehicle(nplayer, {})
            else
            ARMAclient.notify(player,{"person not cuffed"})
            end
        end)
        else
        ARMAclient.notify(player,{"no one near"})
        end
    end)
    else
        print(user_id.." Could be modder")
    end
end)

RegisterNetEvent("ARMA:SearchPlayer")
AddEventHandler("ARMA:SearchPlayer", function()
    player = source
    if user_id ~= nil and ARMA.hasPermission(user_id, "police.menu") then
      ARMAclient.getNearestPlayer(player,{5},function(nplayer)
          local nuser_id = ARMA.getUserId(nplayer)
          if nuser_id ~= nil then
            ARMAclient.notify(nplayer,{lang.police.menu.check.checked()})
            ARMAclient.getWeapons(nplayer,{},function(weapons)
              -- prepare display data (money, items, weapons)
              local money = ARMA.getMoney(nuser_id)
              local items = ""
              local data = ARMA.getUserDataTable(nuser_id)
              if data and data.inventory then
                for k,v in pairs(data.inventory) do
                  local item = ARMA.items[k]
                  if item then
                    items = items.."<br />"..item.name.." ("..v.amount..")"
                  end
                end
              end
      
              local weapons_info = ""
              for k,v in pairs(weapons) do
                weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
              end
      
              ARMAclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
              -- request to hide div
              ARMA.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
                ARMAclient.removeDiv(player,{"police_check"})
              end)
            end)
          else
            ARMAclient.notify(player,{lang.common.no_player_near()})
          end
        end)
      end
end)