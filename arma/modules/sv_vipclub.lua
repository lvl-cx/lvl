MySQL.createCommand("subscription/set_plushours","UPDATE arma_subscriptions SET plusdays = @plusdays WHERE user_id = @user_id")
MySQL.createCommand("subscription/set_plathours","UPDATE arma_subscriptions SET platdays = @platdays WHERE user_id = @user_id")
MySQL.createCommand("subscription/get_subscription","SELECT * FROM arma_subscriptions WHERE user_id = @user_id")
MySQL.createCommand("subscription/add_id", "INSERT IGNORE INTO arma_subscriptions SET user_id = @user_id, plusdays = 0, platdays = 0")

AddEventHandler("playerJoining", function()
    local user_id = ARMA.getUserId(source)
    MySQL.execute("subscription/add_id", {user_id = user_id})
end)

RegisterNetEvent("ARMA:setPlayerSubscription")
AddEventHandler("ARMA:setPlayerSubscription", function(playerid, subtype)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)

    if ARMA.hasGroup(user_id, 'dev') then
        ARMA.prompt(player,"Number of hours ","",function(player, hours) -- ask for number of hours
            if tonumber(hours) and tonumber(hours) > 0 then
                if subtype == "Plus" then
                    MySQL.execute("subscription/set_plushours", {user_id = playerid, plusdays = hours})
                elseif subtype == "Platinum" then
                    MySQL.execute("subscription/set_plathours", {user_id = playerid, platdays = hours})
                end
                TriggerClientEvent('ARMA:userSubscriptionUpdated', player)
            else
                ARMAclient.notify(player,{"~r~Number of hours must be a number."}) -- if price of home is a string not a int
            end
        end)
    else
        TriggerEvent("ARMA:acBan", user_id, 11, GetPlayerName(player), player, 'Trigger Set Player Subscription')
    end
end)

RegisterNetEvent("ARMA:getPlayerSubscription")
AddEventHandler("ARMA:getPlayerSubscription", function(playerid)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)
    if playerid ~= nil then
        MySQL.query("subscription/get_subscription", {user_id = playerid}, function(rows, affected)
            if #rows > 0 then
                local plusdays = rows[1].plusdays
                local platdays = rows[1].platdays
                TriggerClientEvent('ARMA:getUsersSubscription', player, playerid, plusdays, platdays)
            else
                ARMAclient.notify(player, {"~r~Player not found."})
            end
        end)
    else
        MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
            local plusdays = rows[1].plusdays
            local platdays = rows[1].platdays
            TriggerClientEvent('ARMA:setVIPClubData', player, plusdays, platdays)
        end)
    end
end)

RegisterNetEvent("ARMA:beginSellSubscriptionToPlayer")
AddEventHandler("ARMA:beginSellSubscriptionToPlayer", function(subtype)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)

    ARMAclient.getNearestPlayers(player,{15},function(nplayers) --get nearest players
        usrList = ""
        for k, v in pairs(nplayers) do
            usrList = usrList .. "[" .. ARMA.getUserId(k) .. "]" .. GetPlayerName(k) .. " | " --add ids to usrList
        end
        if usrList ~= "" then
            ARMA.prompt(player,"Players Nearby: " .. usrList .. "","",function(player, target_id) --ask for id
                target_id = target_id
                if target_id ~= nil and target_id ~= "" then --validation
                    local target = ARMA.getUserSource(tonumber(target_id)) --get source of the new owner id
                    if target ~= nil then
                        ARMA.prompt(player,"Number of hours ","",function(player, hours) -- ask for number of hours
                            if tonumber(amount) and tonumber(amount) > 0 then
                                ARMA.prompt(player,"Price £: ","",function(player, amount) -- ask for price of request
                                    if tonumber(amount) and tonumber(amount) > 0 then
                                        ARMA.request(target,GetPlayerName(player).." wants to sell: " ..hours.. " of "..subtype.." subscription for £"..amount, 30, function(target,ok) --request player if they want to buy sub
                                            if ok then --bought

                                                local buyer_id = ARMA.getUserId(target)
                                                amount = tonumber(amount) 
                                                if ARMA.tryFullPayment(buyer_id,amount) then
                                                    -- add code to add subscription amount to player buying
                                                    -- also add code to remove subscription amount from player selling
                                                
                                                else
                                                    ARMAclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                    ARMAclient.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                end
                                            else
                                                ARMAclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to buy " ..hours.. " of "..subtype.." subscription for £"..amount}) --notify owner that refused
                                                ARMAclient.notify(target,{"~r~You have refused to buy " ..hours.. " of "..subtype.." subscription for £"..amount}) --notify new owner that refused
                                            end
                                        end)
                                    else
                                        ARMAclient.notify(player,{"~r~Price of subscription must be a number."}) -- if price of home is a string not a int
                                    end
                                end)
                            else
                                ARMAclient.notify(player,{"~r~Number of hours must be a number."}) -- if price of home is a string not a int
                            end
                        end)
                    else
                        ARMAclient.notify(player,{"~r~That Perm ID seems to be invalid!"}) --couldnt find perm id
                    end
                else
                    ARMAclient.notify(player,{"~r~No Perm ID selected!"}) --no perm id selected
                end
            end)
        else
            ARMAclient.notify(player,{"~r~No players nearby!"}) --no players nearby
        end
    end)
end)
