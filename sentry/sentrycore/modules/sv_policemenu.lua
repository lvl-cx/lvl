local lang = Sentry.lang
local cfg = module("cfg/police")

RegisterServerEvent('Sentry:OpenPoliceMenu')
AddEventHandler('Sentry:OpenPoliceMenu', function()
    local source = source
    local user_id = Sentry.getUserId(source)
    if user_id ~= nil and Sentry.hasPermission(user_id, "police.menu") then
        TriggerClientEvent("Sentry:PoliceMenuOpened", source)
    elseif user_id ~= nil and Sentry.hasPermission(user_id, "clockon.menu") then
      Sentryclient.notify(source,{"You are not on duty"})
    else
      print("You are not a part of the MET Police")
    end
end)

RegisterServerEvent('Sentry:ActivateZone')
AddEventHandler('Sentry:ActivateZone', function(message, speed, radius, x, y, z)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(171, 7, 7, 0.6); border-radius: 7px;"><i class="fas fa-exclamation-triangle"></i> MET Police: {0}</div>',
        args = { message }
    })
    TriggerClientEvent('Sentry:ZoneCreated', -1, speed, radius, x, y, z)
end)

RegisterServerEvent('Sentry:RemoveZone')
AddEventHandler('Sentry:RemoveZone', function(blip)
    TriggerClientEvent('Sentry:RemovedBlip', -1)
end)

RegisterServerEvent('Sentry:Drag')
AddEventHandler('Sentry:Drag', function()
    player = source
    local user_id = Sentry.getUserId(player)
    if user_id ~= nil and Sentry.hasPermission(user_id, "police.menu") then
        Sentryclient.getNearestPlayer(player,{10},function(nplayer)
        if nplayer ~= nil then
            local nuser_id = Sentry.getUserId(nplayer)
            if nuser_id ~= nil then
            Sentryclient.isHandcuffed(nplayer,{},function(handcuffed)
                if handcuffed then
                    TriggerClientEvent("Sentry:DragPlayer", nplayer, player)
                else
                    Sentryclient.notify(player,{"~r~Player is not handcuffed."})
                end
            end)
            else
                Sentryclient.notify(player,{"~r~There is no player nearby"})
            end
            else
                Sentryclient.notify(player,{"~r~There is no player nearby"})
            end
        end)
    end
end)

RegisterServerEvent('Sentry:Seize')
AddEventHandler('Sentry:Seize', function()
  local source = source
    player = source
    local user_id = Sentry.getUserId(player)
    if user_id ~= nil and Sentry.hasPermission(user_id, "police.menu") then
            Sentryclient.getNearestPlayer(player,{10},function(nplayer)
              Sentryclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
                if handcuffed then 
            if nplayer ~= nil then
                local nuser_id = Sentry.getUserId(nplayer)
                if nuser_id ~= nil then
                  RemoveAllPedWeapons(nplayer, true)
                  Sentry.clearInventory(nuser_id) 
                  Sentryclient.notify(player, {'~b~Seized players weapons'})
                  Sentryclient.notify(nplayer, {'~r~Your weapons were seized'})
                else
                    Sentryclient.notify(player,{"~r~There is no player nearby"})
                end
                else
                    Sentryclient.notify(player,{"~r~There is no player nearby"})
                end
              else
                Sentryclient.notify(player, {'~r~Player has to be cuffed.'})
              end
            end)
            end)
    end
end)

local isHandcuffed = false
RegisterServerEvent('Sentry:Handcuff')
AddEventHandler('Sentry:Handcuff', function()
  local source = source
    player = source
    user_id = Sentry.getUserId(source)
    if Sentry.hasPermission(user_id, "police.menu") then
      Sentryclient.getNearestPlayer(player,{10},function(nplayer)
          local nuser_id = Sentry.getUserId(nplayer)
          if nuser_id ~= nil then
            if not isHandcuffed then 
              TriggerClientEvent("Sentry:PlaySound", source, "handcuff")
              TriggerClientEvent("Sentry:PlaySound", nplayer, "handcuff")
              TriggerClientEvent("Sentry:CuffAnim", source)
              TriggerClientEvent("Sentry:ArrestAnim", nplayer)
              TriggerClientEvent('Sentry:AttachPlayer', nplayer, source)
              isHandcuffed = true 
            else
                TriggerClientEvent("Sentry:UnCuffAnim", source)
                TriggerClientEvent('Sentry:AttachPlayer', nplayer, source)
                TriggerClientEvent("Sentry:PlaySound", source, "handcuff")
                TriggerClientEvent("Sentry:PlaySound", nplayer, "handcuff")
                isHandcuffed = false
            end
            Citizen.Wait(5000)
            Sentryclient.toggleHandcuff(nplayer,{})
        

          else
            Sentryclient.notify(player,{"~r~There is no player nearby"})
          end
      end)

    end
end)

local unjailed = {}
function jail_clock(target_id,timer)
  local target = Sentry.getUserSource(tonumber(target_id))
  local users = Sentry.getUsers()
  local online = false
  for k,v in pairs(users) do
	if tonumber(k) == tonumber(target_id) then
	  online = true
	end
  end
  if online then
    if timer>0 then
	  Sentryclient.notify(target, {"~r~Remaining time: " .. timer .. " minute(s)."})
      Sentry.setUData(tonumber(target_id),"Sentry:jail:time",json.encode(timer))
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
	  Sentryclient.teleport(target,{425.7607421875,-978.73425292969,30.709615707397}) -- teleport to outside jail
	  Sentryclient.setHandcuffed(target,{false})
      Sentryclient.notify(target,{"~b~You have been set free."})
	  Sentry.setUData({tonumber(target_id),"Sentry:jail:time",json.encode(-1)})
    end
  end
end

RegisterServerEvent('Sentry:JailPlayer')
AddEventHandler('Sentry:JailPlayer', function()
    player = source
    local user_id = Sentry.getUserId(player)
    if user_id ~= nil and Sentry.hasPermission(user_id, "police.menu") then
    Sentryclient.getNearestPlayers(player,{15},function(nplayers) 
      local user_list = ""
      for k,v in pairs(nplayers) do
        user_list = user_list .. "[" .. Sentry.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
      end 
      if user_list ~= "" then
        Sentry.prompt(player,"Players Nearby:" .. user_list,"",function(player,target_id) 
          if target_id ~= nil and target_id ~= "" then 
            Sentry.prompt(player,"Jail Time in minutes:","1",function(player,jail_time)
              if jail_time ~= nil and jail_time ~= "" then 
                local target = Sentry.getUserSource(tonumber(target_id))
                if target ~= nil then
                  if tonumber(jail_time) > 60 then
                      jail_time = 60
                  end
                  if tonumber(jail_time) < 1 then
                    jail_time = 1
                  end
            
                  Sentryclient.isHandcuffed(target,{}, function(handcuffed)  
                    if handcuffed then 
                        Sentryclient.loadFreeze(target,{false,true,true})
                      SetTimeout(15000,function()
                        Sentryclient.loadFreeze(target,{false,false,false})
                      end)
                      Sentryclient.teleport(target,{1709.5927734375,2571.8068847656,50.189060211182}) -- teleport to inside jail
                      Sentryclient.notify(target,{"~r~You have been sent to jail."})
                      Sentryclient.notify(player,{"~b~You sent a player to jail."})
                      jail_clock(tonumber(target_id),tonumber(jail_time))
                      local user_id = Sentry.getUserId(player)
                    else
                      Sentryclient.notify(player,{"~r~That player is not handcuffed."})
                    end
                  end)
                else
                  Sentryclient.notify(player,{"~r~That ID seems invalid."})
                end
              else
                Sentryclient.notify(player,{"~r~The jail time can't be empty."})
              end
            end)
          else
            Sentryclient.notify(player,{"~r~No player ID selected."})
          end 
        end)
      else
        Sentryclient.notify(player,{"~r~No player nearby."})
      end 
    end)
    else
        print(user_id.." could be modding")
    end
end)

RegisterServerEvent('Sentry:UnJailPlayer')
AddEventHandler('Sentry:UnJailPlayer', function()
    player = source
    local user_id = Sentry.getUserId(player)
    if user_id ~= nil and Sentry.hasPermission(user_id, "police.menu") then
	Sentry.prompt(player,"Player ID:","",function(player,target_id) 
	  if target_id ~= nil and target_id ~= "" then 
		Sentry.getUData(tonumber(target_id),"Sentry:jail:time",function(value)
		  if value ~= nil then
		  custom = json.decode(value)
			if custom ~= nil then
			  local user_id = Sentry.getUserId(player)
			  if tonumber(custom) > 0 or Sentry.hasPermission(user_id,"admin.easy_unjail") then
	            local target = Sentry.getUserSource(tonumber(target_id))
				if target ~= nil then
	              unjailed[target] = tonumber(target_id)
				  Sentryclient.notify(player,{"~g~Target will be released soon."})
				  Sentryclient.notify(target,{"~g~Someone lowered your sentence."})
				else
				  Sentryclient.notify(player,{"~r~That ID seems invalid."})
				end
			  else
				Sentryclient.notify(player,{"~r~Target is not jailed."})
			  end
			end
		  end
		end)
      else
        Sentryclient.notify(player,{"~r~No player ID selected."})
      end 
  end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterServerEvent('Sentry:Fine')
AddEventHandler('Sentry:Fine', function()
    player = source
    local user_id = Sentry.getUserId(player)
    if user_id ~= nil and Sentry.hasPermission(user_id, "police.menu") then
    Sentryclient.getNearestPlayers(player,{15},function(nplayers) 
      local user_list = ""
      for k,v in pairs(nplayers) do
        user_list = user_list .. "[" .. Sentry.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
      end 
      if user_list ~= "" then
        Sentry.prompt(player,"Players Nearby:" .. user_list,"",function(player,target_id) 
          if target_id ~= nil and target_id ~= "" then 
            Sentry.prompt(player,"Fine amount:","100",function(player,fine)
              if fine ~= nil and fine ~= "" then 
                Sentry.prompt(player,"Fine reason:","",function(player,reason)
                  if reason ~= nil and reason ~= "" then 
                    local target = Sentry.getUserSource(tonumber(target_id))
                    if target ~= nil then
                      if tonumber(fine) > 100000 then
                          fine = 100000
                      end
                      if tonumber(fine) < 100 then
                        fine = 100
                      end
                
                      if Sentry.tryFullPayment(tonumber(target_id), tonumber(fine)) then
                        Sentry.insertPoliceRecord(tonumber(target_id), lang.police.menu.fine.record({reason,fine}))
                        Sentryclient.notify(player,{lang.police.menu.fine.fined({reason,fine})})
                        Sentryclient.notify(target,{lang.police.menu.fine.notify_fined({reason,fine})})
                        local user_id = Sentry.getUserId(player)
                        Sentry.closeMenu(player)
                      else
                        Sentryclient.notify(player,{lang.money.not_enough()})
                      end
                    else
                      Sentryclient.notify(player,{"~r~That ID seems invalid."})
                    end
                  else
                    Sentryclient.notify(player,{"~r~You can't fine for no reason."})
                  end
                end)
              else
                Sentryclient.notify(player,{"~r~Your fine has to have a value."})
              end
            end)
          else
            Sentryclient.notify(player,{"~r~No player ID selected."})
          end 
        end)
      else
        Sentryclient.notify(player,{"~r~No player nearby."})
      end 
    end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterNetEvent("Sentry:PutPlrInVeh")
AddEventHandler("Sentry:PutPlrInVeh", function()
    player = source
    local user_id = Sentry.getUserId(player)
    if user_id ~= nil and Sentry.hasPermission(user_id, "police.menu") then
    Sentryclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = Sentry.getUserId(nplayer)
      if nuser_id ~= nil then
        Sentryclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            Sentryclient.putInNearestVehicleAsPassenger(nplayer, {5})
          else
            Sentryclient.notify(player,{"person not cuffed"})
          end
        end)
      else
        Sentryclient.notify(player,{"no one near"})
      end
    end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterNetEvent("Sentry:TakeOutOfVehicle")
AddEventHandler("Sentry:TakeOutOfVehicle", function()
    player = source
    local user_id = Sentry.getUserId(player)
    if user_id ~= nil and Sentry.hasPermission(user_id, "police.menu") then
    Sentryclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = Sentry.getUserId(nplayer)
        if nuser_id ~= nil then
        Sentryclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
            if handcuffed then
            Sentryclient.ejectVehicle(nplayer, {})
            else
            Sentryclient.notify(player,{"person not cuffed"})
            end
        end)
        else
        Sentryclient.notify(player,{"no one near"})
        end
    end)
    else
        print(user_id.." Could be modder")
    end
end)

RegisterNetEvent("Sentry:SearchPlayer")
AddEventHandler("Sentry:SearchPlayer", function()
    player = source
    if user_id ~= nil and Sentry.hasPermission(user_id, "police.menu") then
      Sentryclient.getNearestPlayer(player,{5},function(nplayer)
          local nuser_id = Sentry.getUserId(nplayer)
          if nuser_id ~= nil then
            Sentryclient.notify(nplayer,{lang.police.menu.check.checked()})
            Sentryclient.getWeapons(nplayer,{},function(weapons)
              -- prepare display data (money, items, weapons)
              local money = Sentry.getMoney(nuser_id)
              local items = ""
              local data = Sentry.getUserDataTable(nuser_id)
              if data and data.inventory then
                for k,v in pairs(data.inventory) do
                  local item = Sentry.items[k]
                  if item then
                    items = items.."<br />"..item.name.." ("..v.amount..")"
                  end
                end
              end
      
              local weapons_info = ""
              for k,v in pairs(weapons) do
                weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
              end
      
              Sentryclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
              -- request to hide div
              Sentry.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
                Sentryclient.removeDiv(player,{"police_check"})
              end)
            end)
          else
            Sentryclient.notify(player,{lang.common.no_player_near()})
          end
        end)
      end
end)