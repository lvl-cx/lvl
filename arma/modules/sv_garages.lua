local lang = ARMA.lang
local cfg = module("arma-vehicles", "garages")
local cfg_inventory = module("cfg/inventory")
local vehicle_groups = cfg.garages
local limit = cfg.limit or 100000000
MySQL.createCommand("ARMA/add_vehicle","INSERT IGNORE INTO arma_user_vehicles(user_id,vehicle,vehicle_plate,locked) VALUES(@user_id,@vehicle,@registration,@locked)")
MySQL.createCommand("ARMA/remove_vehicle","DELETE FROM arma_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("ARMA/get_vehicles", "SELECT vehicle, rentedtime, vehicle_plate, fuel_level, impounded FROM arma_user_vehicles WHERE user_id = @user_id")
MySQL.createCommand("ARMA/get_rented_vehicles_in", "SELECT vehicle, rentedtime, user_id FROM arma_user_vehicles WHERE user_id = @user_id AND rented = 1")
MySQL.createCommand("ARMA/get_rented_vehicles_out", "SELECT vehicle, rentedtime, user_id FROM arma_user_vehicles WHERE rentedid = @user_id AND rented = 1")
MySQL.createCommand("ARMA/get_vehicle","SELECT vehicle FROM arma_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("ARMA/get_vehicle_fuellevel","SELECT fuel_level FROM arma_user_vehicles WHERE vehicle = @vehicle")
MySQL.createCommand("ARMA/check_rented","SELECT * FROM arma_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle AND rented = 1")
MySQL.createCommand("ARMA/sell_vehicle_player","UPDATE arma_user_vehicles SET user_id = @user_id, vehicle_plate = @registration WHERE user_id = @oldUser AND vehicle = @vehicle")
MySQL.createCommand("ARMA/rentedupdate", "UPDATE arma_user_vehicles SET user_id = @id, rented = @rented, rentedid = @rentedid, rentedtime = @rentedunix WHERE user_id = @user_id AND vehicle = @veh")
MySQL.createCommand("ARMA/fetch_rented_vehs", "SELECT * FROM arma_user_vehicles WHERE rented = 1")
MySQL.createCommand("ARMA/get_vehicle_count","SELECT vehicle FROM arma_user_vehicles WHERE vehicle = @vehicle")

RegisterServerEvent("ARMA:spawnPersonalVehicle")
AddEventHandler('ARMA:spawnPersonalVehicle', function(vehicle)
    local source = source
    local user_id = ARMA.getUserId(source)
    MySQL.query("ARMA/get_vehicles", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                if v.vehicle == vehicle then
                    if v.impounded then
                        ARMAclient.notify(source, {'~r~This vehicle is currently impounded.'})
                        return
                    else
                        TriggerClientEvent('ARMA:spawnPersonalVehicle', source, v.vehicle, user_id, false, GetEntityCoords(GetPlayerPed(source)), v.vehicle_plate, v.fuel_level)
                        return
                    end
                end
            end
        end
    end)
end)

valetCooldown = {}
RegisterServerEvent("ARMA:valetSpawnVehicle")
AddEventHandler('ARMA:valetSpawnVehicle', function(spawncode)
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMAclient.isPlusClub(source,{},function(plusclub)
        ARMAclient.isPlatClub(source,{},function(platclub)
            if plusclub or platclub then
                if valetCooldown[source] and not (os.time() > valetCooldown[source]) then
                    return ARMAclient.notify(source,{"~r~Please wait before using this again."})
                else
                    valetCooldown[source] = nil
                end
                MySQL.query("ARMA/get_vehicles", {user_id = user_id}, function(result)
                    if result ~= nil then 
                        for k,v in pairs(result) do
                            if v.vehicle == spawncode then
                                TriggerClientEvent('ARMA:spawnPersonalVehicle', source, v.vehicle, user_id, true, GetEntityCoords(GetPlayerPed(source)), v.vehicle_plate, v.fuel_level)
                                valetCooldown[source] = os.time() + 60
                                return
                            end
                        end
                    end
                end)
            else
                ARMAclient.notify(source, {"~y~You need to be a subscriber of ARMA Plus or ARMA Platinum to use this feature."})
                ARMAclient.notify(source, {"~y~Available @ store.armarp.co.uk"})
            end
        end)
    end)
end)

RegisterServerEvent("ARMA:getVehicleRarity")
AddEventHandler('ARMA:getVehicleRarity', function(spawncode)
    local source = source
    local user_id = ARMA.getUserId(source)
    MySQL.query("ARMA/get_vehicle_count", {vehicle = spawncode}, function(result)
        if result ~= nil then 
            TriggerClientEvent('ARMA:setVehicleRarity', source, spawncode, #result)
        end
    end)
end)

RegisterServerEvent("ARMA:displayVehicleBlip")
AddEventHandler('ARMA:displayVehicleBlip', function(spawncode)
    local source = source
    local user_id = ARMA.getUserId(source)
    -- do some check for if the player has bought display blip for this specific vehicle
    ARMAclient.getOwnedVehiclePosition(source, {spawncode}, function(x,y,z)
        local position = {}
        position.x, position.y, position.z = x,y,z
        if next(position) then
            TriggerClientEvent('ARMA:displayVehicleBlip', source, position)
        end
    end)
end)


RegisterServerEvent("ARMA:updateFuel")
AddEventHandler('ARMA:updateFuel', function(vehicle, fuel_level)
    local source = source
    local user_id = ARMA.getUserId(source)
    exports["ghmattimysql"]:execute("UPDATE arma_user_vehicles SET fuel_level = @fuel_level WHERE user_id = @user_id AND vehicle = @vehicle", {fuel_level = fuel_level, user_id = user_id, vehicle = vehicle}, function() end)
end)

RegisterServerEvent("ARMA:getCustomFolders")
AddEventHandler('ARMA:getCustomFolders', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    exports["ghmattimysql"]:execute("SELECT * from `arma_custom_garages` WHERE user_id = @user_id", {user_id = user_id}, function(Result)
        if #Result > 0 then
            TriggerClientEvent("ARMA:sendFolders", source, json.decode(Result[1].folder))
        end
    end)
end)


RegisterServerEvent("ARMA:updateFolders")
AddEventHandler('ARMA:updateFolders', function(FolderUpdated)
    local source = source
    local user_id = ARMA.getUserId(source)
    exports["ghmattimysql"]:execute("SELECT * from `arma_custom_garages` WHERE user_id = @user_id", {user_id = user_id}, function(Result)
        if #Result > 0 then
            exports['ghmattimysql']:execute("UPDATE arma_custom_garages SET folder = @folder WHERE user_id = @user_id", {folder = json.encode(FolderUpdated), user_id = user_id}, function() end)
        else
            exports['ghmattimysql']:execute("INSERT INTO arma_custom_garages (`user_id`, `folder`) VALUES (@user_id, @folder);", {user_id = user_id, folder = json.encode(FolderUpdated)}, function() end)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(300000)
        MySQL.query('ARMA/fetch_rented_vehs', {}, function(pvehicles)
            for i,v in pairs(pvehicles) do 
               if os.time() > tonumber(v.rentedtime) then
                  MySQL.execute('ARMA/rentedupdate', {id = v.rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = v.user_id, veh = v.vehicle})
                  if ARMA.getUserSource(v.rentedid) ~= nil then
                    ARMAclient.notify(ARMA.getUserSource(v.rentedid), {"~r~Your rented vehicle has been returned."})
                  end
               end
            end
        end)
    end
end)

RegisterNetEvent('ARMA:FetchCars')
AddEventHandler('ARMA:FetchCars', function(type)
    local source = source
    local user_id = ARMA.getUserId(source)
    local returned_table = {}
    local fuellevels = {}
    if user_id then
        MySQL.query("ARMA/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
            for _, veh in pairs(pvehicles) do
                for i, v in pairs(vehicle_groups) do
                    local perms = false
                    local config = vehicle_groups[i]._config
                    if config.type == vehicle_groups[type]._config.type then 
                        local perm = config.permissions or nil
                        if next(perm) then
                            for i, v in pairs(perm) do
                                if ARMA.hasPermission(user_id, v) then
                                    perms = true
                                end
                            end
                        else
                            perms = true
                        end
                        if perms then 
                            for a, z in pairs(v) do
                                if a ~= "_config" and veh.vehicle == a then
                                    if not returned_table[i] then 
                                        returned_table[i] = {["_config"] = config}
                                    end
                                    if not returned_table[i].vehicles then 
                                        returned_table[i].vehicles = {}
                                    end
                                    returned_table[i].vehicles[a] = {z[1], z[2], veh.vehicle_plate, veh.fuel_level}
                                    fuellevels[a] = veh.fuel_level
                                end
                            end
                        end
                    end
                end
            end
            TriggerClientEvent('ARMA:ReturnFetchedCars', source, returned_table, fuellevels)
        end)
    end
end)

RegisterNetEvent('ARMA:BuyVehicle')
AddEventHandler('ARMA:BuyVehicle', function(vehicle)
    local source = source
    local user_id = ARMA.getUserId(source)
    for i, v in pairs(vehicle_groups) do
        local config = vehicle_groups[i]._config
        local perm = config.permissions or nil
        if perm then
            for i, v in pairs(perm) do
                if not ARMA.hasPermission(user_id, v) then
                    break
                end
            end
        end
        for a, z in pairs(v) do
            if a ~= "_config" and a == vehicle then
                if ARMA.tryFullPayment(user_id,z[2]) then 
                    ARMAclient.notify(source,{'~g~You have purchased: ' .. z[1] .. ' for: £' .. z[2]})
                    ARMA.getUserIdentity(user_id, function(identity)					
                        MySQL.execute("ARMA/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = "P "..identity.registration})
                    end)
                    return 
                else 
                    ARMAclient.notify(source,{'~r~You do not have enough money to purchase this vehicle! It costs: £' .. z[2]})
                    TriggerClientEvent('ARMA:CloseGarage', source)
                    return 
                end
            end
        end
    end
    return ARMAclient.notify(source,{'~r~An error has occured please try again later.'})
end)

RegisterNetEvent('ARMA:ScrapVehicle')
AddEventHandler('ARMA:ScrapVehicle', function(vehicle)
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id then 
        MySQL.query("ARMA/check_rented", {user_id = user_id, vehicle = vehicle}, function(pvehicles)
            MySQL.query("ARMA/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pveh)
                if #pveh < 0 then 
                    ARMAclient.notify(source,{"~r~You cannot destroy a vehicle you do not own"})
                    return
                end
                if #pvehicles > 0 then 
                    ARMAclient.notify(source,{"~r~You cannot destroy a rented vehicle!"})
                    return
                end
                MySQL.execute('ARMA/remove_vehicle', {user_id = user_id, vehicle = vehicle})
                TriggerClientEvent('ARMA:CloseGarage', source)
            end)
        end)
    end
end)

RegisterNetEvent('ARMA:SellVehicle')
AddEventHandler('ARMA:SellVehicle', function(veh)
    local name = veh
    local player = source 
    local playerID = ARMA.getUserId(source)
    if playerID ~= nil then
		ARMAclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. ARMA.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
			end
			if usrList ~= "" then
				ARMA.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = ARMA.getUserSource(tonumber(user_id))
						if target ~= nil then
							ARMA.prompt(player,"Price £: ","",function(player,amount)
								if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
									MySQL.query("ARMA/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
										if #pvehicle > 0 then
											ARMAclient.notify(player,{"~r~The player already has this vehicle type."})
										else
											local tmpdata = ARMA.getUserTmpTable(playerID)
											MySQL.query("ARMA/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                if #pvehicles > 0 then 
                                                    ARMAclient.notify(player,{"~r~You cannot sell a rented vehicle!"})
                                                    return
                                                else
                                                    ARMA.request(target,GetPlayerName(player).." wants to sell: " ..name.. " Price: £"..amount, 10, function(target,ok)
                                                        if ok then
                                                            local pID = ARMA.getUserId(target)
                                                            amount = tonumber(amount)
                                                            if ARMA.tryFullPayment(pID,amount) then
                                                                ARMAclient.despawnGarageVehicle(player,{'car',15}) 
                                                                ARMA.getUserIdentity(pID, function(identity)
                                                                    MySQL.execute("ARMA/sell_vehicle_player", {user_id = user_id, registration = "P "..identity.registration, oldUser = playerID, vehicle = name}) 
                                                                end)
                                                                ARMA.giveBankMoney(playerID, amount)
                                                                ARMAclient.notify(player,{"~g~You have successfully sold the vehicle to ".. GetPlayerName(target).." for £"..amount.."!"})
                                                                ARMAclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully sold you the car for £"..amount.."!"})
                                                                TriggerClientEvent('ARMA:CloseGarage', player)
                                                            else
                                                                ARMAclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"})
                                                                ARMAclient.notify(target,{"~r~You don't have enough money!"})
                                                            end
                                                        else
                                                            ARMAclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to buy the car."})
                                                            ARMAclient.notify(target,{"~r~You have refused to buy "..GetPlayerName(player).."'s car."})
                                                        end
                                                    end)
                                                end
                                            end)
										end
									end) 
								else
									ARMAclient.notify(player,{"~r~The price of the car has to be a number."})
								end
							end)
						else
							ARMAclient.notify(player,{"~r~That ID seems invalid."})
						end
					else
						ARMAclient.notify(player,{"~r~No player ID selected."})
					end
				end)
			else
				ARMAclient.notify(player,{"~r~No players nearby."})
			end
		end)
    end
end)


RegisterNetEvent('ARMA:RentVehicle')
AddEventHandler('ARMA:RentVehicle', function(veh)
    local name = veh
    local player = source 
    local playerID = ARMA.getUserId(source)
    if playerID ~= nil then
		ARMAclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. ARMA.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
			end
			if usrList ~= "" then
				ARMA.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = ARMA.getUserSource(tonumber(user_id))
						if target ~= nil then
							ARMA.prompt(player,"Price £: ","",function(player,amount)
                                ARMA.prompt(player,"Rent time (in hours): ","",function(player,rent)
                                    if tonumber(rent) and tonumber(rent) >  0 then 
                                        if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
                                            MySQL.query("ARMA/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
                                                if #pvehicle > 0 then
                                                    ARMAclient.notify(player,{"~r~The player already has this vehicle."})
                                                else
                                                    local tmpdata = ARMA.getUserTmpTable(playerID)
                                                    MySQL.query("ARMA/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                        if #pvehicles > 0 then 
                                                            return
                                                        else
                                                            ARMA.prompt(player, "Please replace text with YES or NO to confirm", "Rent Details:\nVehicle: "..name.."\nRent Cost: "..amount.."\nDuration: "..rent.." hours\nRenting to player: "..GetPlayerName(target).."("..ARMA.getUserId(target)..")",function(player,details)
                                                                if string.upper(details) == 'YES' then
                                                                    ARMAclient.notify(player, {'~g~Rent offer sent!'})
                                                                    ARMA.request(target,GetPlayerName(player).." wants to rent: " ..name.. " Price: £"..amount .. ' | for: ' .. rent .. 'hours', 10, function(target,ok)
                                                                        if ok then
                                                                            local pID = ARMA.getUserId(target)
                                                                            amount = tonumber(amount)
                                                                            if ARMA.tryFullPayment(pID,amount) then
                                                                                ARMAclient.despawnGarageVehicle(player,{'car',15}) 
                                                                                ARMA.getUserIdentity(pID, function(identity)
                                                                                    local rentedTime = os.time()
                                                                                    rentedTime = rentedTime  + (60 * 60 * tonumber(rent)) 
                                                                                    MySQL.execute("ARMA/rentedupdate", {user_id = playerID, veh = name, id = pID, rented = 1, rentedid = playerID, rentedunix =  rentedTime }) 
                                                                                end)
                                                                                ARMA.giveBankMoney(playerID, amount)
                                                                                ARMAclient.notify(player,{"~g~You have successfully rented the vehicle to ".. GetPlayerName(target).." for £"..amount.."!" .. ' | for: ' .. rent .. 'hours'})
                                                                                ARMAclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully rented you the car for £"..amount.."!" .. ' | for: ' .. rent .. 'hours'})
                                                                                TriggerClientEvent('ARMA:CloseGarage', player)
                                                                            else
                                                                                ARMAclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"})
                                                                                ARMAclient.notify(target,{"~r~You don't have enough money!"})
                                                                            end
                                                                        else
                                                                            ARMAclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to rent the car."})
                                                                            ARMAclient.notify(target,{"~r~You have refused to rent "..GetPlayerName(player).."'s car."})
                                                                        end
                                                                    end)
                                                                end
                                                            end)
                                                        end
                                                    end)
                                                end
                                            end) 
                                        else
                                            ARMAclient.notify(player,{"~r~The price of the car has to be a number."})
                                        end
                                    else 
                                        ARMAclient.notify(player,{"~r~The rent time of the car has to be in hours and a number."})
                                    end
                                end)
							end)
						else
							ARMAclient.notify(player,{"~r~That ID seems invalid."})
						end
					else
						ARMAclient.notify(player,{"~r~No player ID selected."})
					end
				end)
			else
				ARMAclient.notify(player,{"~r~No players nearby."})
			end
		end)
    end
end)



RegisterNetEvent('ARMA:FetchRented')
AddEventHandler('ARMA:FetchRented', function()
    local rentedin = {}
    local rentedout = {}
    local source = source
    local user_id = ARMA.getUserId(source)
    MySQL.query("ARMA/get_rented_vehicles_in", {user_id = user_id}, function(pvehicles, affected)
        for _, veh in pairs(pvehicles) do
            for i, v in pairs(vehicle_groups) do
                local config = vehicle_groups[i]._config
                local perm = config.permissions or nil
                if perm then
                    for i, v in pairs(perm) do
                        if not ARMA.hasPermission(user_id, v) then
                            break
                        end
                    end
                end
                for a, z in pairs(v) do
                    if a ~= "_config" and veh.vehicle == a then
                        if not rentedin.vehicles then 
                            rentedin.vehicles = {}
                        end
                        local hoursLeft = ((tonumber(veh.rentedtime)-os.time()))/3600
                        local minutesLeft = nil
                        if hoursLeft < 1 then
                            minutesLeft = hoursLeft * 60
                            minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
                            datetime = minutesLeft .. " mins" 
                        else
                            hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
                            datetime = hoursLeft .. " hours" 
                        end
                        rentedin.vehicles[a] = {z[1], datetime, veh.user_id, a}
                    end
                end
            end
        end
        MySQL.query("ARMA/get_rented_vehicles_out", {user_id = user_id}, function(pvehicles, affected)
            for _, veh in pairs(pvehicles) do
                for i, v in pairs(vehicle_groups) do
                    local config = vehicle_groups[i]._config
                    local perm = config.permissions or nil
                    if perm then
                        for i, v in pairs(perm) do
                            if not ARMA.hasPermission(user_id, v) then
                                break
                            end
                        end
                    end
                    for a, z in pairs(v) do
                        if a ~= "_config" and veh.vehicle == a then
                            if not rentedout.vehicles then 
                                rentedout.vehicles = {}
                            end
                            local hoursLeft = ((tonumber(veh.rentedtime)-os.time()))/3600
                            local minutesLeft = nil
                            if hoursLeft < 1 then
                                minutesLeft = hoursLeft * 60
                                minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
                                datetime = minutesLeft .. " mins" 
                            else
                                hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
                                datetime = hoursLeft .. " hours" 
                            end
                            rentedout.vehicles[a] = {z[1], datetime, veh.user_id, a}
                        end
                    end
                end
            end
            print(json.encode(rentedin), json.encode(rentedout))
            TriggerClientEvent('ARMA:ReturnedRentedCars', source, rentedin, rentedout)
        end)
    end)
end)

RegisterNetEvent('ARMA:CancelRent')
AddEventHandler('ARMA:CancelRent', function(spawncode, VehicleName, a)
    local source = source
    local user_id = ARMA.getUserId(source)
    if a == 'owner' then
        exports['ghmattimysql']:execute("SELECT * FROM arma_user_vehicles WHERE rentedid = @id", {id = user_id}, function(result)
            if #result > 0 then 
                for i = 1, #result do 
                    if result[i].vehicle == spawncode and result[i].rented then
                        local target = ARMA.getUserSource(result[i].user_id)
                        if target ~= nil then
                            ARMA.request(target,GetPlayerName(source).." would like to cancel the rent on the vehicle: ", 10, function(target,ok)
                                if ok then
                                    MySQL.execute('ARMA/rentedupdate', {id = user_id, rented = 0, rentedid = "", rentedunix = "", user_id = result[i].user_id, veh = spawncode})
                                    ARMAclient.notify(target, {"~r~" ..VehicleName.." has been returned to the vehicle owner."})
                                    ARMAclient.notify(source, {"~r~" ..VehicleName.." has been returned to your garage."})
                                else
                                    ARMAclient.notify(source, {"~r~User has declined the request to cancel the rental of vehicle: " ..VehicleName})
                                end
                            end)
                        else
                            ARMAclient.notify(source, {"~r~The player is not online."})
                        end
                    end
                end
            end
        end)
    elseif a == 'renter' then
        exports['ghmattimysql']:execute("SELECT * FROM arma_user_vehicles WHERE user_id = @id", {id = user_id}, function(result)
            if #result > 0 then 
                for i = 1, #result do 
                    if result[i].vehicle == spawncode and result[i].rented then
                        local rentedid = tonumber(result[i].rentedid)
                        local target = ARMA.getUserSource(rentedid)
                        if target ~= nil then
                            ARMA.request(target,GetPlayerName(source).." would like to cancel the rent on the vehicle: ", 10, function(target,ok)
                                if ok then
                                    MySQL.execute('ARMA/rentedupdate', {id = rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = user_id, veh = spawncode})
                                    ARMAclient.notify(source, {"~r~" ..VehicleName.." has been returned to the vehicle owner."})
                                    ARMAclient.notify(target, {"~r~" ..VehicleName.." has been returned to your garage."})
                                else
                                    ARMAclient.notify(source, {"~r~User has declined the request to cancel the rental of vehicle: " ..VehicleName})
                                end
                            end)
                        else
                            ARMAclient.notify(source, {"~r~The player is not online."})
                        end
                    end
                end
            end
        end)
    end
end)

-- repair nearest vehicle
local function ch_repair(player,choice)
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    -- anim and repair
    if ARMA.tryGetInventoryItem(user_id,"repairkit",1,true) then
      ARMAclient.playAnim(player,{false,{task="WORLD_HUMAN_WELDING"},false})
      SetTimeout(15000, function()
        ARMAclient.fixeNearestVehicle(player,{7})
        ARMAclient.stopAnim(player,{false})
      end)
    end
  end
end

RegisterNetEvent("ARMA:PayVehicleTax")
AddEventHandler("ARMA:PayVehicleTax", function()
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil then
        local bank = ARMA.getBankMoney(user_id)
        local payment = bank / 10000
        if ARMA.tryBankPayment(user_id, payment) then
            ARMAclient.notify(source,{"~g~Paid £"..math.floor(payment).." vehicle tax."})
            TriggerEvent('ARMA:addToCommunityPot', math.floor(payment))
        else
            ARMAclient.notify(source,{"~r~Its fine... Tax payers will pay your vehicle tax instead."})
        end
    end
end)

RegisterNetEvent("ARMA:refreshGaragePermissions")
AddEventHandler("ARMA:refreshGaragePermissions",function()
    local source=source
    local garageTable={}
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(cfg.garages) do
        for a,b in pairs(v) do
            if a == "_config" then
                if b.permissions[1] ~= nil then
                    if ARMA.hasPermission(ARMA.getUserId(source),b.permissions[1])then
                        table.insert(garageTable, k)
                    end
                else
                    table.insert(garageTable, k)
                end
            end
        end
    end
    TriggerClientEvent("ARMA:recieveRefreshedGaragePermissions",source,garageTable)
end)


RegisterNetEvent("ARMA:getGarageFolders")
AddEventHandler("ARMA:getGarageFolders",function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local garageFolders = {}
    MySQL.query("ARMA/get_vehicles", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                local spawncode = v.vehicle 
                for a,b in pairs(vehicle_groups) do
                    local hasPerm = true
                    if next(b._config.permissions) then
                        if not ARMA.hasPermission(user_id, b._config.permissions[1]) then
                            hasPerm = false
                        end
                    end
                    if hasPerm then
                        for c,d in pairs(b) do
                            if c == spawncode and not v.impounded then
                                table.insert(garageFolders, {display = a})
                                for e,f in pairs (garageFolders) do
                                    if f.display == a then
                                        if f.vehicles == nil then
                                            f.vehicles = {}
                                        end
                                        table.insert(f.vehicles, {display = d[1], spawncode = spawncode})
                                    end
                                end
                            end
                        end
                    end
                end
            end
            TriggerClientEvent('ARMA:setVehicleFolders', source, garageFolders)
        end
    end)
end)

Citizen.CreateThread(function()
    Wait(1500)
    exports['ghmattimysql']:execute([[
        CREATE TABLE IF NOT EXISTS `arma_custom_garages` (
            `user_id` INT(11) NOT NULL AUTO_INCREMENT,
            `folder` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            PRIMARY KEY (`user_id`) USING BTREE
        );
    ]])
end)
