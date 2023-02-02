MySQL.createCommand("subscription/set_plushours","UPDATE arma_subscriptions SET plushours = @plushours WHERE user_id = @user_id")
MySQL.createCommand("subscription/set_plathours","UPDATE arma_subscriptions SET plathours = @plathours WHERE user_id = @user_id")
MySQL.createCommand("subscription/set_lastused","UPDATE arma_subscriptions SET last_used = @last_used WHERE user_id = @user_id")
MySQL.createCommand("subscription/get_subscription","SELECT * FROM arma_subscriptions WHERE user_id = @user_id")
MySQL.createCommand("subscription/get_all_subscriptions","SELECT * FROM arma_subscriptions")
MySQL.createCommand("subscription/add_id", "INSERT IGNORE INTO arma_subscriptions SET user_id = @user_id, plushours = 0, plathours = 0, last_used = ''")

AddEventHandler("playerJoining", function()
    local user_id = ARMA.getUserId(source)
    MySQL.execute("subscription/add_id", {user_id = user_id})
end)

function tARMA.getSubscriptions(user_id,cb)
    MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
           cb(true, rows[1].plushours, rows[1].plathours, rows[1].last_used)
        else
            cb(false)
        end
    end)
end

RegisterNetEvent("ARMA:setPlayerSubscription")
AddEventHandler("ARMA:setPlayerSubscription", function(playerid, subtype)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)
    if ARMA.hasGroup(user_id, 'Founder') then
        ARMA.prompt(player,"Number of days ","",function(player, hours)
            if tonumber(hours) and tonumber(hours) >= 0 then
                hours = hours * 24
                if subtype == "Plus" then
                    MySQL.execute("subscription/set_plushours", {user_id = playerid, plushours = hours})
                elseif subtype == "Platinum" then
                    MySQL.execute("subscription/set_plathours", {user_id = playerid, plathours = hours})
                end
                TriggerClientEvent('ARMA:userSubscriptionUpdated', player)
            else
                ARMAclient.notify(player,{"~r~Number of days must be a number."})
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
        tARMA.getSubscriptions(playerid, function(cb, plushours, plathours)
            if cb then
                TriggerClientEvent('ARMA:getUsersSubscription', player, playerid, plushours, plathours)
            else
                ARMAclient.notify(player, {"~r~Player not found."})
            end
        end)
    else
        tARMA.getSubscriptions(user_id, function(cb, plushours, plathours)
            if cb then
                TriggerClientEvent('ARMA:setVIPClubData', player, plushours, plathours)
            end
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
                        ARMA.prompt(player,"Number of days ","",function(player, hours) -- ask for number of hours
                            if tonumber(hours) and tonumber(hours) > 0 then
                                MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
                                    sellerplushours = rows[1].plushours
                                    sellerplathours = rows[1].plathours
                                    if (subtype == 'Plus' and sellerplushours >= tonumber(hours)*24) or (subtype == 'Platinum' and sellerplathours >= tonumber(hours)*24) then
                                        ARMA.prompt(player,"Price £: ","",function(player, amount) --ask for price
                                            if tonumber(amount) and tonumber(amount) > 0 then
                                                ARMA.request(target,GetPlayerName(player).." wants to sell: " ..hours.. " days of "..subtype.." subscription for £"..getMoneyStringFormatted(amount), 30, function(target,ok) --request player if they want to buy sub
                                                    if ok then --bought
                                                        MySQL.query("subscription/get_subscription", {user_id = ARMA.getUserId(target)}, function(rows, affected)
                                                            if subtype == "Plus" then
                                                                if ARMA.tryFullPayment(ARMA.getUserId(target),tonumber(amount)) then
                                                                    MySQL.execute("subscription/set_plushours", {user_id = ARMA.getUserId(target), plushours = rows[1].plushours + tonumber(hours)*24})
                                                                    MySQL.execute("subscription/set_plushours", {user_id = user_id, plushours = sellerplushours - tonumber(hours)*24})
                                                                    ARMAclient.notify(player,{'~g~You have sold '..hours..' days of '..subtype..' subscription to '..GetPlayerName(target)..' for £'..amount})
                                                                    ARMAclient.notify(target, {'~g~'..GetPlayerName(player)..' has sold '..hours..' days of '..subtype..' subscription to you for £'..amount})
                                                                    ARMA.giveBankMoney(user_id,tonumber(amount))
                                                                    ARMA.updateInvCap(ARMA.getUserId(target), 40)
                                                                else
                                                                    ARMAclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                                    ARMAclient.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                                end
                                                            elseif subtype == "Platinum" then
                                                                if ARMA.tryFullPayment(ARMA.getUserId(target),tonumber(amount)) then
                                                                    MySQL.execute("subscription/set_plathours", {user_id = ARMA.getUserId(target), plathours = rows[1].plathours + tonumber(hours)*24})
                                                                    MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = sellerplathours - tonumber(hours)*24})
                                                                    ARMAclient.notify(player,{'~g~You have sold '..hours..' days of '..subtype..' subscription to '..GetPlayerName(target)..' for £'..amount})
                                                                    ARMAclient.notify(target, {'~g~'..GetPlayerName(player)..' has sold '..hours..' days of '..subtype..' subscription to you for £'..amount})
                                                                    ARMA.giveBankMoney(user_id,tonumber(amount))
                                                                    ARMA.updateInvCap(ARMA.getUserId(target), 50)
                                                                else
                                                                    ARMAclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                                    ARMAclient.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                                end
                                                            end
                                                        end)
                                                    else
                                                        ARMAclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to buy " ..hours.. " days of "..subtype.." subscription for £"..amount}) --notify owner that refused
                                                        ARMAclient.notify(target,{"~r~You have refused to buy " ..hours.. " days of "..subtype.." subscription for £"..amount}) --notify new owner that refused
                                                    end
                                                end)
                                            else
                                                ARMAclient.notify(player,{"~r~Price of subscription must be a number."})
                                            end
                                        end)
                                    else
                                        ARMAclient.notify(player,{"~r~You do not have "..hours.." days of "..subtype.."."})
                                    end
                                end)
                            else
                                ARMAclient.notify(player,{"~r~Number of days must be a number."})
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        MySQL.query("subscription/get_all_subscriptions", {}, function(rows, affected)
            if #rows > 0 then
                for k,v in pairs(rows) do
                    local plushours = v.plushours
                    local plathours = v.plathours
                    local user_id = v.user_id
                    local user = ARMA.getUserSource(user_id)
                    if plushours >= 1/60 then
                        MySQL.execute("subscription/set_plushours", {user_id = user_id, plushours = plushours-1/60})
                    else
                        MySQL.execute("subscription/set_plushours", {user_id = user_id, plushours = 0})
                    end
                    if plathours >= 1/60 then
                        MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = plathours-1/60})
                    else
                        MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = 0})
                    end
                    if user ~= nil then
                        TriggerClientEvent('ARMA:setVIPClubData', user, plushours, plathours)
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent("ARMA:claimWeeklyKit") -- need to add a thing for restricting the kit to actually being weekly
AddEventHandler("ARMA:claimWeeklyKit", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    tARMA.getSubscriptions(user_id, function(cb, plushours, plathours, last_used)
        if cb then
            if plathours >= 168 or plushours >= 168 then
                if last_used == '' or (os.time() >= tonumber(last_used+24*60*60*7)) then
                    if plathours >= 168 then
                        ARMA.giveInventoryItem(user_id, "Morphine", 5, true)
                        ARMA.giveInventoryItem(user_id, "Taco", 5, true)
                        ARMAclient.giveWeapons(source, {{['WEAPON_M1911'] = {ammo = 250}}, false})
                        ARMAclient.giveWeapons(source, {{['WEAPON_OLYMPIA'] = {ammo = 250}}, false})
                        ARMAclient.giveWeapons(source, {{['WEAPON_UMP45'] = {ammo = 250}}, false})
                        ARMAclient.giveWeapons(source, {{['WEAPON_AK200'] = {ammo = 250}}, false})
                        ARMAclient.setArmour(source, {100, true})
                        MySQL.execute("subscription/set_lastused", {user_id = user_id, last_used = os.time()})
                    elseif plushours >= 168 then
                        ARMA.giveInventoryItem(user_id, "Morphine", 5, true)
                        ARMA.giveInventoryItem(user_id, "Taco", 5, true)
                        ARMAclient.giveWeapons(source, {{['WEAPON_M1911'] = {ammo = 250}}, false})
                        ARMAclient.giveWeapons(source, {{['WEAPON_UMP45'] = {ammo = 250}}, false})
                        ARMAclient.setArmour(source, {100, true})
                        MySQL.execute("subscription/set_lastused", {user_id = user_id, last_used = os.time()})
                    else
                        ARMAclient.notify(source,{"~r~You need at least 1 week of subscription to redeem the kit."})
                    end
                else
                    ARMAclient.notify(source,{"~r~You can only claim your weekly kit once a week."})
                end
            end
        end
    end)
end)

RegisterNetEvent("ARMA:fuelAllVehicles")
AddEventHandler("ARMA:fuelAllVehicles", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    tARMA.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            if plushours > 0 or plathours > 0 then
                if ARMA.tryFullPayment(user_id,25000) then
                    exports["ghmattimysql"]:execute("UPDATE arma_user_vehicles SET fuel_level = 100 WHERE user_id = @user_id", {user_id = user_id}, function() end)
                    TriggerClientEvent("arma:PlaySound", source, "money")
                    ARMAclient.notify(source,{"~g~Vehicles Refueled."})
                end
            end
        end
    end)
end)

RegisterCommand('redeem', function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    if tARMA.checkForRole(user_id, '975543463808487465') then
        MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                local redeemed = rows[1].redeemed
                if not redeemed then
                    exports["ghmattimysql"]:execute("UPDATE arma_subscriptions SET redeemed = 1 WHERE user_id = @user_id", {user_id = user_id}, function() end)
                    ARMA.giveBankMoney(user_id, 150000)
                    ARMAclient.notify(source, {'~g~You have redeemed your perks of £150,000 and 1 Week of Platinum Subscription.'})
                    MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = rows[1].plathours + 168})
                else
                    ARMAclient.notify(source, {'~r~You have already redeemed your subscription.'})
                end
            end
        end)
    end
end)