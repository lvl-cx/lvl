RegisterCommand("betawipe", function(source, args)
    if source == 0 then
        exports["ghmattimysql"]:execute("SELECT * FROM arma_user_data WHERE dkey = @data", {data = "ARMA:datatable"}, function(rows, affected)
            if #rows > 0 then
                for i,v in pairs(rows) do
                    if v.user_id ~= 1 and v.user_id ~= 2 and v.user_id ~= 3 then
                        print('Wiped PermID: ' .. v.user_id..'.')
                        local jsoninv = json.decode(rows[i].dvalue)
                        if jsoninv then
                            if type(jsoninv["inventory"]) == "table" and jsoninv["inventory"] then
                                jsoninv["inventory"] = {}
                            end
                            if jsoninv["weapons"] then 
                                jsoninv["weapons"] = {}
                            end
                            if jsoninv["invcap"] then 
                                jsoninv["invcap"] = 30
                            end
                            jsoninv["health"] = 200
                            jsoninv["armour"] = 0
                            print('Reset Inventory, Weapons, Invcap, Health and Armour for PermID: ' .. rows[i].user_id..'.')
                            exports["ghmattimysql"]:execute("UPDATE arma_user_data SET dvalue = @jsoninv WHERE user_id = @id", {id = rows[i].user_id, jsoninv = json.encode(jsoninv)}, nil)
                        end
                    end
                end
            end
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * arma_srv_data", {}, function(rows) 
            print('Wiped ' .. #rows .. ' boots.')
            exports['ghmattimysql']:execute("DELETE FROM arma_srv_data", {})
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * arma_anticheat", {}, function(rows) 
            print('Wiped ' .. #rows .. ' anticheat bans.')
            exports['ghmattimysql']:execute("DELETE FROM arma_anticheat", {})
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * arma_subscriptions", {}, function(rows)
            print('Wiped ' .. #rows .. ' subscriptions.')
            exports['ghmattimysql']:execute("DELETE FROM arma_subscriptions", {})
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * arma_casino_chips", {}, function(rows)
            print('Wiped ' .. #rows .. ' user\'s chips.')
            exports['ghmattimysql']:execute("DELETE FROM arma_casino_chips", {})
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * FROM arma_users WHERE banned = 1", {}, function(rows)
            for k,v in pairs(rows) do
                ARMA.setBanned(v.id, false)
            end
            print('Unbanned ' .. #rows .. ' users.')
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * arma_bans_offenses", {}, function(rows)
            exports['ghmattimysql']:execute("DELETE FROM arma_bans_offenses", {})
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * FROM arma_gangs", {}, function(rows)
            print('Deleted ' .. #rows .. ' gangs.')
            exports['ghmattimysql']:execute("DELETE FROM arma_gangs", {})
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * FROM arma_quests", {}, function(rows)
            print('Deleted ' .. #rows .. ' user\'s quest progress.')
            exports['ghmattimysql']:execute("DELETE FROM arma_quests", {})
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * arma_daily_rewards", {}, function(rows)
            exports['ghmattimysql']:execute("DELETE FROM arma_daily_rewards", {})
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * arma_staff_tickets", {}, function(rows)
            exports['ghmattimysql']:execute("DELETE FROM arma_staff_tickets", {})
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * arma_user_moneys", {}, function(rows)
            print('Wiped the money of '..#rows..' money.')
            exports['ghmattimysql']:execute("DELETE FROM arma_user_moneys", {})
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * arma_user_notes", {}, function(rows)
            print('Wiped ' .. #rows .. ' user\'s notes.')
            exports['ghmattimysql']:execute("DELETE FROM arma_user_notes", {})
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * arma_verification", {}, function(rows)
            exports['ghmattimysql']:execute("DELETE FROM arma_verification", {})
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * arma_warnings", {}, function(rows)
            print('Wiped ' .. #rows .. ' warnings.')
            exports['ghmattimysql']:execute("DELETE FROM arma_warnings", {})
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * arma_weapon_codes", {}, function(rows)
            exports['ghmattimysql']:execute("DELETE FROM arma_weapon_codes", {})
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * FROM arma_user_vehicles", {}, function(rows, affected)
            if #rows > 0 then
                for k,v in pairs(rows) do
                    if v.user_id ~= 1 and v.user_id ~= 2 and v.user_id ~= 3 then
                        print('Deleted vehicle: ' .. v.vehicle .. ' from PermID: ' .. v.user_id)
                        exports["ghmattimysql"]:execute("DELETE FROM arma_user_vehicles WHERE user_id = @user_id and vehicle = @vehicle", {user_id = v.user_id, vehicle = v.vehicle})
                    end
                end
            end
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * FROM arma_weapon_whitelists", {}, function(rows, affected)
            if #rows > 0 then
                for k,v in pairs(rows) do
                    if v.id ~= 1 then
                        exports["ghmattimysql"]:execute("DELETE FROM arma_weapon_whitelists WHERE user_id = @user_id", {user_id = v.user_id})
                    end
                end
            end
        end)
        Wait(5000)
        exports["ghmattimysql"]:execute("SELECT * arma_user_homes", {}, function(rows)
            print('Wiped ' .. #rows .. ' user\'s homes.')
            exports['ghmattimysql']:execute("DELETE FROM arma_user_homes", {})
        end)
    end  
end)