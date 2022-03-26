-- -- a basic garage implementation
-- -- vehicle db
local lang = Sentry.lang
local cfg = module("cfg/garages")
local cfg_inventory = module("cfg/inventory")
local vehicle_groups = cfg.garage_types
local limit = cfg.limit or 100000000
MySQL.createCommand("Sentry/add_vehicle","INSERT IGNORE INTO sentry_user_vehicles(user_id,vehicle,vehicle_plate) VALUES(@user_id,@vehicle,@registration)")
MySQL.createCommand("Sentry/remove_vehicle","DELETE FROM sentry_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("Sentry/get_vehicles", "SELECT vehicle, rentedtime FROM sentry_user_vehicles WHERE user_id = @user_id AND rented = 0")
MySQL.createCommand("Sentry/get_rented_vehicles_in", "SELECT vehicle, rentedtime, user_id FROM sentry_user_vehicles WHERE user_id = @user_id AND rented = 1")
MySQL.createCommand("Sentry/get_rented_vehicles_out", "SELECT vehicle, rentedtime, user_id FROM sentry_user_vehicles WHERE rentedid = @user_id AND rented = 1")
MySQL.createCommand("Sentry/get_vehicle","SELECT vehicle FROM sentry_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("Sentry/check_rented","SELECT * FROM sentry_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle AND rented = 1")
MySQL.createCommand("Sentry/sell_vehicle_player","UPDATE sentry_user_vehicles SET user_id = @user_id, vehicle_plate = @registration WHERE user_id = @oldUser AND vehicle = @vehicle")
MySQL.createCommand("Sentry/rentedupdate", "UPDATE sentry_user_vehicles SET user_id = @id, rented = @rented, rentedid = @rentedid, rentedtime = @rentedunix WHERE user_id = @user_id AND vehicle = @veh")
MySQL.createCommand("Sentry/fetch_rented_vehs", "SELECT * FROM sentry_user_vehicles WHERE rented = 1")
--RageUI Implementation by JamesUK#6793.

--PHONE GARAGES ARE NOT SUPPORTED DO NOT EVEN ASK.
--PHONE GARAGES ARE NOT SUPPORTED DO NOT EVEN ASK.
--PHONE GARAGES ARE NOT SUPPORTED DO NOT EVEN ASK.
--PHONE GARAGES ARE NOT SUPPORTED DO NOT EVEN ASK.
--PHONE GARAGES ARE NOT SUPPORTED DO NOT EVEN ASK.


Citizen.CreateThread(function()
    while true do
        Wait(300000)
        MySQL.query('Sentry/fetch_rented_vehs', {}, function(pvehicles)
            for i,v in pairs(pvehicles) do 
               if os.time() > tonumber(v.rentedtime) then
                  MySQL.execute('Sentry/rentedupdate', {id = v.rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = v.user_id, veh = v.vehicle})
               end
            end
        end)
        print('Vehicle Rents checked.')
    end
end)

RegisterNetEvent('Sentry:FetchCars')
AddEventHandler('Sentry:FetchCars', function(owned, type)
    local source = source
    local user_id = Sentry.getUserId(source)
    local returned_table = {}
    if user_id then
        if not owned then
            for i, v in pairs(vehicle_groups) do
                local noperms = false;
                local config = vehicle_groups[i]._config
                if config.vtype == type then 
                    local perm = config.permissions or nil
                    if perm then
                        for i, v in pairs(perm) do
                            if not Sentry.hasPermission(user_id, v) then
                                noperms = true;
                            end
                        end
                    end
                    if not noperms then 
                        returned_table[i] = {
                            ["config"] = config
                        }
                        returned_table[i].vehicles = {}
                        for a, z in pairs(v) do
                            if a ~= "_config" then
                                returned_table[i].vehicles[a] = {z[1], z[2]}
                            end
                        end
                    end
                end 
            end
            TriggerClientEvent('Sentry:ReturnFetchedCars', source, returned_table)
        else
            MySQL.query("Sentry/get_vehicles", {
                user_id = user_id
            }, function(pvehicles, affected)
                for _, veh in pairs(pvehicles) do
                    for i, v in pairs(vehicle_groups) do
                        local noperms = false;
                        local config = vehicle_groups[i]._config
                        if config.vtype == type then 
                            local perm = config.permissions or nil
                            if perm then
                                for i, v in pairs(perm) do
                                    if not Sentry.hasPermission(user_id, v) then
                                        noperms = true;
                                    end
                                end
                            end
                            if not noperms then 
                                for a, z in pairs(v) do
                                    if a ~= "_config" and veh.vehicle == a then
                                        if not returned_table[i] then 
                                            returned_table[i] = {
                                                ["config"] = config
                                            }
                                        end
                                        if not returned_table[i].vehicles then 
                                            returned_table[i].vehicles = {}
                                        end
                                        returned_table[i].vehicles[a] = {z[1]}
                                    end
                                end
                            end
                        end
                    end
                end
                TriggerClientEvent('Sentry:ReturnFetchedCars', source, returned_table)
            end)
        end
    end
end)

RegisterNetEvent('Sentry:BuyVehicle')
AddEventHandler('Sentry:BuyVehicle', function(vehicle)
    local source = source
    local user_id = Sentry.getUserId(source)
    for i, v in pairs(vehicle_groups) do
        local config = vehicle_groups[i]._config
        local perm = config.permissions or nil
        if perm then
            for i, v in pairs(perm) do
                if not Sentry.hasPermission(user_id, v) then
                    break
                end
            end
        end
        for a, z in pairs(v) do
            if a ~= "_config" and a == vehicle then
                if Sentry.tryFullPayment(user_id,z[2]) then 
                    Sentryclient.notify(source,{'~g~You have purchased: ' .. z[1] .. ' for: $' .. z[2]})
                    Sentry.getUserIdentity(user_id, function(identity)					
                        MySQL.execute("Sentry/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = "P "..identity.registration})
                    end)
                    return 
                else 
                    Sentryclient.notify(source,{'~r~You do not have enough money to purchase this vehicle! It costs: $' .. z[2]})
                    TriggerClientEvent('Sentry:CloseGarage', source)
                    return 
                end
            end
        end
    end
    return Sentryclient.notify(source,{'~r~An error has occured please try again later.'})
end)

RegisterNetEvent('Sentry:ScrapVehicle')
AddEventHandler('Sentry:ScrapVehicle', function(vehicle)
    local source = source
    local user_id = Sentry.getUserId(source)
    if user_id then 
        MySQL.query("Sentry/check_rented", {user_id = user_id, vehicle = vehicle}, function(pvehicles)
            MySQL.query("Sentry/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pveh)
                if #pveh < 0 then 
                    Sentryclient.notify(source,{"~r~You cannot destroy a vehicle you do not own"})
                    return
                end
                if #pvehicles > 0 then 
                    Sentryclient.notify(source,{"~r~You cannot destroy a rented vehicle!"})
                    return
                end
                MySQL.execute('Sentry/remove_vehicle', {user_id = user_id, vehicle = vehicle})
                TriggerClientEvent('Sentry:CloseGarage', source)
            end)
        end)
    end
end)

RegisterNetEvent('Sentry:SellVehicle')
AddEventHandler('Sentry:SellVehicle', function(veh)
    local name = veh
    local player = source 
    local playerID = Sentry.getUserId(source)
    if playerID ~= nil then
		Sentryclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. Sentry.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
			end
			if usrList ~= "" then
				Sentry.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = Sentry.getUserSource(tonumber(user_id))
						if target ~= nil then
							Sentry.prompt(player,"Price $: ","",function(player,amount)
								if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
									MySQL.query("Sentry/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
										if #pvehicle > 0 then
											Sentryclient.notify(player,{"~r~The player already has this vehicle type."})
										else
											local tmpdata = Sentry.getUserTmpTable(playerID)
											MySQL.query("Sentry/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                if #pvehicles > 0 then 
                                                    Sentryclient.notify(player,{"~r~You cannot sell a rented vehicle!"})
                                                    return
                                                else
                                                    Sentry.request(target,GetPlayerName(player).." wants to sell: " ..name.. " Price: $"..amount, 10, function(target,ok)
                                                        if ok then
                                                            local pID = Sentry.getUserId(target)
                                                            amount = tonumber(amount)
                                                            if Sentry.tryFullPayment(pID,amount) then
                                                                Sentryclient.despawnGarageVehicle(player,{'car',15}) 
                                                                Sentry.getUserIdentity(pID, function(identity)
                                                                    MySQL.execute("Sentry/sell_vehicle_player", {user_id = user_id, registration = "P "..identity.registration, oldUser = playerID, vehicle = name}) 
                                                                end)
                                                                Sentry.giveBankMoney(playerID, amount)
                                                                Sentryclient.notify(player,{"~g~You have successfully sold the vehicle to ".. GetPlayerName(target).." for $"..amount.."!"})
                                                                Sentryclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully sold you the car for $"..amount.."!"})
                                                                TriggerClientEvent('Sentry:CloseGarage', player)
                                                            else
                                                                Sentryclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"})
                                                                Sentryclient.notify(target,{"~r~You don't have enough money!"})
                                                            end
                                                        else
                                                            Sentryclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to buy the car."})
                                                            Sentryclient.notify(target,{"~r~You have refused to buy "..GetPlayerName(player).."'s car."})
                                                        end
                                                    end)
                                                end
                                            end)
										end
									end) 
								else
									Sentryclient.notify(player,{"~r~The price of the car has to be a number."})
								end
							end)
						else
							Sentryclient.notify(player,{"~r~That ID seems invalid."})
						end
					else
						Sentryclient.notify(player,{"~r~No player ID selected."})
					end
				end)
			else
				Sentryclient.notify(player,{"~r~No players nearby."})
			end
		end)
    end
end)


RegisterNetEvent('Sentry:RentVehicle')
AddEventHandler('Sentry:RentVehicle', function(veh)
    local name = veh
    local player = source 
    local playerID = Sentry.getUserId(source)
    if playerID ~= nil then
		Sentryclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. Sentry.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
			end
			if usrList ~= "" then
				Sentry.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = Sentry.getUserSource(tonumber(user_id))
						if target ~= nil then
							Sentry.prompt(player,"Price $: ","",function(player,amount)
                                Sentry.prompt(player,"Rent time (in hours): ","",function(player,rent)
                                    if tonumber(rent) and tonumber(rent) >  0 then 
                                        if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
                                            MySQL.query("Sentry/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
                                                if #pvehicle > 0 then
                                                    Sentryclient.notify(player,{"~r~The player already has this vehicle type."})
                                                else
                                                    local tmpdata = Sentry.getUserTmpTable(playerID)
                                                    MySQL.query("Sentry/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                        if #pvehicles > 0 then 
                                                            Sentryclient.notify(player,{"~r~You cannot rent a rented vehicle!"})
                                                            return
                                                        else
                                                            Sentry.request(target,GetPlayerName(player).." wants to rent: " ..name.. " Price: $"..amount .. ' | for: ' .. rent .. 'hours', 10, function(target,ok)
                                                                if ok then
                                                                    local pID = Sentry.getUserId(target)
                                                                    amount = tonumber(amount)
                                                                    if Sentry.tryFullPayment(pID,amount) then
                                                                        Sentryclient.despawnGarageVehicle(player,{'car',15}) 
                                                                        Sentry.getUserIdentity(pID, function(identity)
                                                                            local rentedTime = os.time()
                                                                            rentedTime = rentedTime  + (60 * 60 * tonumber(rent)) 
                                                                            MySQL.execute("Sentry/rentedupdate", {user_id = playerID, veh = name, id = pID, rented = 1, rentedid = playerID, rentedunix =  rentedTime }) 
                                                                        end)
                                                                        Sentry.giveBankMoney(playerID, amount)
                                                                        Sentryclient.notify(player,{"~g~You have successfully rented the vehicle to ".. GetPlayerName(target).." for $"..amount.."!" .. ' | for: ' .. rent .. 'hours'})
                                                                        Sentryclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully rented you the car for $"..amount.."!" .. ' | for: ' .. rent .. 'hours'})
                                                                        TriggerClientEvent('Sentry:CloseGarage', player)
                                                                    else
                                                                        Sentryclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"})
                                                                        Sentryclient.notify(target,{"~r~You don't have enough money!"})
                                                                    end
                                                                else
                                                                    Sentryclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to rent the car."})
                                                                    Sentryclient.notify(target,{"~r~You have refused to rent "..GetPlayerName(player).."'s car."})
                                                                end
                                                            end)
                                                        end
                                                    end)
                                                end
                                            end) 
                                        else
                                            Sentryclient.notify(player,{"~r~The price of the car has to be a number."})
                                        end
                                    else 
                                        Sentryclient.notify(player,{"~r~The rent time of the car has to be in hours and a number."})
                                    end
                                end)
							end)
						else
							Sentryclient.notify(player,{"~r~That ID seems invalid."})
						end
					else
						Sentryclient.notify(player,{"~r~No player ID selected."})
					end
				end)
			else
				Sentryclient.notify(player,{"~r~No players nearby."})
			end
		end)
    end
end)



RegisterNetEvent('Sentry:FetchVehiclesIn')
AddEventHandler('Sentry:FetchVehiclesIn', function()
    local returned_table = {}
    local source = source
    local user_id = Sentry.getUserId(source)
    MySQL.query("Sentry/get_rented_vehicles_in", {
        user_id = user_id
    }, function(pvehicles, affected)
        for _, veh in pairs(pvehicles) do
            for i, v in pairs(vehicle_groups) do
                local config = vehicle_groups[i]._config
                local perm = config.permissions or nil
                if perm then
                    for i, v in pairs(perm) do
                        if not Sentry.hasPermission(user_id, v) then
                            break
                        end
                    end
                end
                for a, z in pairs(v) do
                    if a ~= "_config" and veh.vehicle == a then
                        if not returned_table[i] then 
                            returned_table[i] = {
                                ["config"] = config
                            }
                        end
                        if not returned_table[i].vehicles then 
                            returned_table[i].vehicles = {}
                        end
                        local time = tonumber(veh.rentedtime) - os.time()
                        local datetime = ""
                        local date = os.date("!*t", time)
                        if date.hour >= 1 and date.min >= 1 then 
                            datetime = date.hour .. " hours and " .. date.min .. " minutes left"
                        elseif date.hour <= 1 and date.min >= 1 then 
                            datetime = date.min .. " minutes left"
                        elseif date.hour >= 1 and date.min <= 1 then 
                            datetime = date.hour .. " hours left"
                        end
                        returned_table[i].vehicles[a] = {z[1], datetime}
                    end
                end
            end
        end
        TriggerClientEvent('Sentry:ReturnFetchedCars', source, returned_table)
    end)
end)

RegisterNetEvent('Sentry:FetchVehiclesOut')
AddEventHandler('Sentry:FetchVehiclesOut', function()
    local returned_table = {}
    local source = source
    local user_id = Sentry.getUserId(source)
    MySQL.query("Sentry/get_rented_vehicles_out", {
        user_id = user_id
    }, function(pvehicles, affected)
        for _, veh in pairs(pvehicles) do
            for i, v in pairs(vehicle_groups) do
                local config = vehicle_groups[i]._config
                local perm = config.permissions or nil
                if perm then
                    for i, v in pairs(perm) do
                        if not Sentry.hasPermission(user_id, v) then
                            break
                        end
                    end
                end
                for a, z in pairs(v) do
                    if a ~= "_config" and veh.vehicle == a then
                        if not returned_table[i] then 
                            returned_table[i] = {
                                ["config"] = config
                            }
                        end
                        if not returned_table[i].vehicles then 
                            returned_table[i].vehicles = {}
                        end
                        local time = tonumber(veh.rentedtime) - os.time()
                        local datetime = ""
                        local date = os.date("!*t", time)
                        if date.hour >= 1 and date.min >= 1 then 
                            datetime = date.hour .. " hours and " .. date.min .. " minutes left."
                        elseif date.hour <= 1 and date.min >= 1 then 
                            datetime = date.min .. " minutes left"
                        elseif date.hour >= 1 and date.min <= 1 then 
                            datetime = date.hour .. " hours left"
                        end
                        returned_table[i].vehicles[a .. ':' .. veh.user_id] = {z[1], datetime, veh.user_id, a}
                    end
                end
            end
        end
        TriggerClientEvent('Sentry:ReturnFetchedCars', source, returned_table)
    end)
end)


local veh_actions = {}

-- open trunk
veh_actions[lang.vehicle.trunk.title()] = {function(user_id,player,vtype,name)
  local chestname = "u"..user_id.."veh_"..string.lower(name)
  local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

  -- open chest
  Sentryclient.vc_openDoor(player, {vtype,5})
  Sentry.openChest(player, chestname, max_weight, function()
    Sentryclient.vc_closeDoor(player, {vtype,5})
  end)
end, lang.vehicle.trunk.description()}

-- detach trailer
veh_actions[lang.vehicle.detach_trailer.title()] = {function(user_id,player,vtype,name)
  Sentryclient.vc_detachTrailer(player, {vtype})
end, lang.vehicle.detach_trailer.description()}

-- detach towtruck
veh_actions[lang.vehicle.detach_towtruck.title()] = {function(user_id,player,vtype,name)
  Sentryclient.vc_detachTowTruck(player, {vtype})
end, lang.vehicle.detach_towtruck.description()}

-- detach cargobob
veh_actions[lang.vehicle.detach_cargobob.title()] = {function(user_id,player,vtype,name)
  Sentryclient.vc_detachCargobob(player, {vtype})
end, lang.vehicle.detach_cargobob.description()}

-- lock/unlock
veh_actions[lang.vehicle.lock.title()] = {function(user_id,player,vtype,name)
  Sentryclient.vc_toggleLock(player, {vtype})
end, lang.vehicle.lock.description()}

-- engine on/off
veh_actions[lang.vehicle.engine.title()] = {function(user_id,player,vtype,name)
  Sentryclient.vc_toggleEngine(player, {vtype})
end, lang.vehicle.engine.description()}
--sell2
MySQL.createCommand("Sentry/sell_vehicle_player","UPDATE sentry_user_vehicles SET user_id = @user_id, vehicle_plate = @registration WHERE user_id = @oldUser AND vehicle = @vehicle")




local function ch_vehicle(player,choice)
  local user_id = Sentry.getUserId(player)
  if user_id ~= nil then
    -- check vehicle
    Sentryclient.getNearestOwnedVehicle(player,{7},function(ok,vtype,name)
      if ok then
        -- build vehicle menu
        Sentry.buildMenu("vehicle", {user_id = user_id, player = player, vtype = vtype, vname = name}, function(menu)
          menu.name=lang.vehicle.title()
          menu.css={top="75px",header_color="rgba(255,125,0,0.75)"}

          for k,v in pairs(veh_actions) do
            menu[k] = {function(player,choice) v[1](user_id,player,vtype,name) end, v[2]}
          end

          Sentry.openMenu(player,menu)
        end)
      else
        Sentryclient.notify(player,{lang.vehicle.no_owned_near()})
      end
    end)
  end
end

-- ask trunk (open other user car chest)
local function ch_asktrunk(player,choice)
  Sentryclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = Sentry.getUserId(nplayer)
    if nuser_id ~= nil then
      Sentryclient.notify(player,{lang.vehicle.asktrunk.asked()})
      Sentry.request(nplayer,lang.vehicle.asktrunk.request(),15,function(nplayer,ok)
        if ok then -- request accepted, open trunk
          Sentryclient.getNearestOwnedVehicle(nplayer,{7},function(ok,vtype,name)
            if ok then
              local chestname = "u"..nuser_id.."veh_"..string.lower(name)
              local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

              -- open chest
              local cb_out = function(idname,amount)
                Sentryclient.notify(nplayer,{lang.inventory.give.given({Sentry.getItemName(idname),amount})})
              end

              local cb_in = function(idname,amount)
                Sentryclient.notify(nplayer,{lang.inventory.give.received({Sentry.getItemName(idname),amount})})
              end

              Sentryclient.vc_openDoor(nplayer, {vtype,5})
              Sentry.openChest(player, chestname, max_weight, function()
                Sentryclient.vc_closeDoor(nplayer, {vtype,5})
              end,cb_in,cb_out)
            else
              Sentryclient.notify(player,{lang.vehicle.no_owned_near()})
              Sentryclient.notify(nplayer,{lang.vehicle.no_owned_near()})
            end
          end)
        else
          Sentryclient.notify(player,{lang.common.request_refused()})
        end
      end)
    else
      Sentryclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end

-- repair nearest vehicle
local function ch_repair(player,choice)
  local user_id = Sentry.getUserId(player)
  if user_id ~= nil then
    -- anim and repair
    if Sentry.tryGetInventoryItem(user_id,"repairkit",1,true) then
      Sentryclient.playAnim(player,{false,{task="WORLD_HUMAN_WELDING"},false})
      SetTimeout(15000, function()
        Sentryclient.fixeNearestVehicle(player,{7})
        Sentryclient.stopAnim(player,{false})
      end)
    end
  end
end

-- replace nearest vehicle
local function ch_replace(player,choice)
  Sentryclient.replaceNearestVehicle(player,{7})
end

