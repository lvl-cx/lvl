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

RegisterNetEvent("ARMA:setPlayerSubscription")
AddEventHandler("ARMA:setPlayerSubscription", function(playerid, subtype)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)

    if ARMA.hasGroup(user_id, 'Developer') then
        ARMA.prompt(player,"Number of hours ","",function(player, hours)
            if tonumber(hours) and tonumber(hours) >= 0 then
                if subtype == "Plus" then
                    MySQL.execute("subscription/set_plushours", {user_id = playerid, plushours = hours})
                elseif subtype == "Platinum" then
                    MySQL.execute("subscription/set_plathours", {user_id = playerid, plathours = hours})
                end
                TriggerClientEvent('ARMA:userSubscriptionUpdated', player)
            else
                ARMAclient.notify(player,{"~r~Number of hours must be a number."})
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
                local plushours = rows[1].plushours
                local plathours = rows[1].plathours
                TriggerClientEvent('ARMA:getUsersSubscription', player, playerid, plushours, plathours)
            else
                ARMAclient.notify(player, {"~r~Player not found."})
            end
        end)
    else
        MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
            local plushours = rows[1].plushours
            local plathours = rows[1].plathours
            TriggerClientEvent('ARMA:setVIPClubData', player, plushours, plathours)
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
                            if tonumber(hours) and tonumber(hours) > 0 then
                                MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
                                    sellerplushours = rows[1].plushours
                                    sellerplathours = rows[1].plathours
                                    if (subtype == 'Plus' and sellerplushours >= tonumber(hours)) or (subtype == 'Platinum' and sellerplathours >= tonumber(hours)) then
                                        ARMA.prompt(player,"Price £: ","",function(player, amount) --ask for price
                                            if tonumber(amount) and tonumber(amount) > 0 then
                                                ARMA.request(target,GetPlayerName(player).." wants to sell: " ..hours.. " hours of "..subtype.." subscription for £"..getMoneyStringFormatted(amount), 30, function(target,ok) --request player if they want to buy sub
                                                    if ok then --bought
                                                        MySQL.query("subscription/get_subscription", {user_id = ARMA.getUserId(target)}, function(rows, affected)
                                                            if subtype == "Plus" then
                                                                if ARMA.tryFullPayment(ARMA.getUserId(target),tonumber(amount)) then
                                                                    MySQL.execute("subscription/set_plushours", {user_id = ARMA.getUserId(target), plushours = rows[1].plushours + tonumber(hours)})
                                                                    MySQL.execute("subscription/set_plushours", {user_id = user_id, plushours = sellerplushours - tonumber(hours)})
                                                                    ARMAclient.notify(player,{'~g~You have sold '..hours..' hours of '..subtype..' subscription to '..GetPlayerName(target)..' for £'..amount})
                                                                    ARMAclient.notify(target, {'~g~'..GetPlayerName(player)..' has sold '..hours..' hours of '..subtype..' subscription to you for £'..amount})
                                                                    ARMA.giveBankMoney(user_id,tonumber(amount))
                                                                else
                                                                    ARMAclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                                    ARMAclient.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                                end
                                                            elseif subtype == "Platinum" then
                                                                if ARMA.tryFullPayment(ARMA.getUserId(target),tonumber(amount)) then
                                                                    MySQL.execute("subscription/set_plathours", {user_id = ARMA.getUserId(target), plathours = rows[1].plathours + tonumber(hours)})
                                                                    MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = sellerplathours - tonumber(hours)})
                                                                    ARMAclient.notify(player,{'~g~You have sold '..hours..' hours of '..subtype..' subscription to '..GetPlayerName(target)..' for £'..amount})
                                                                    ARMAclient.notify(target, {'~g~'..GetPlayerName(player)..' has sold '..hours..' hours of '..subtype..' subscription to you for £'..amount})
                                                                    ARMA.giveBankMoney(user_id,tonumber(amount))
                                                                else
                                                                    ARMAclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                                    ARMAclient.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                                end
                                                            end
                                                        end)
                                                    else
                                                        ARMAclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to buy " ..hours.. " of "..subtype.." subscription for £"..amount}) --notify owner that refused
                                                        ARMAclient.notify(target,{"~r~You have refused to buy " ..hours.. " of "..subtype.." subscription for £"..amount}) --notify new owner that refused
                                                    end
                                                end)
                                            else
                                                ARMAclient.notify(player,{"~r~Price of subscription must be a number."})
                                            end
                                        end)
                                    else
                                        ARMAclient.notify(player,{"~r~You do not have "..hours.." hours of "..subtype.."."})
                                    end
                                end)
                            else
                                ARMAclient.notify(player,{"~r~Number of hours must be a number."})
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
    MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            local plushours = rows[1].plushours
            local plathours = rows[1].plathours
            if plathours >= 168 or plushours >= 168 then
                if rows[1].last_used == '' or (os.time() >= tonumber(rows[1].last_used+24*60*60*7)) or user_id == 1 then
                    if plathours >= 168 then
                        ARMA.giveInventoryItem(user_id, "wbody|" .. 'WEAPON_M1911', 1, true)
                        -- Pistol, Shotgun, SMG, AR, full armour, tacos & morphine.
                        ARMAclient.setArmour(source, {100})
                        MySQL.execute("subscription/set_lastused", {user_id = user_id, last_used = os.time()})
                    elseif plushours >= 168 then
                        ARMA.giveInventoryItem(user_id, "wbody|" .. 'WEAPON_M1911', 1, true)
                        -- Pistol, SMG, full armour, tacos & morphine.
                        ARMAclient.setArmour(source, {100})
                        MySQL.execute("subscription/set_lastused", {user_id = user_id, last_used = os.time()})
                    else
                        ARMAclient.notify(source,{"~r~You need at least 1 week of subscription to redeem the kit."})
                    end
                else
                    ARMAclient.notify(source,{"~r~You can only claim your weekly kit once a week."})
                end
            end
        else
            ARMAclient.notify(player, {"~r~Player not found."})
        end
    end)
end)

RegisterNetEvent("ARMA:fuelAllVehicles")
AddEventHandler("ARMA:fuelAllVehicles", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
        if rows[1].plushours > 0 or rows[1].plathours > 0 then
            if ARMA.tryFullPayment(user_id,25000) then
                exports["ghmattimysql"]:execute("UPDATE arma_user_vehicles SET fuel_level = 100 WHERE user_id = @user_id", {user_id = user_id}, function() end)
                TriggerClientEvent("arma:PlaySound", source, "money")
                ARMAclient.notify(source,{"~g~Vehicles Refueled."})
            end
        end
    end)
end)

RegisterCommand('redeem', function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    exports["discordroles"]:isRolePresent(source, {'975543463808487465'}, function(hasRole, roles)
        if (not roles) then 
            ARMAclient.notify(source,{"~r~It seems you don't have discord running or installed try restart fivem if this issue persists /calladmin."})
        end
        if hasRole then
            MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
                if #rows > 0 then
                    local redeemed = rows[1].redeemed
                    if not redeemed then
                        exports["ghmattimysql"]:execute("UPDATE arma_subscriptions SET redeemed = 1 WHERE user_id = @user_id", {user_id = user_id}, function() end)
                        ARMAclient.allowWeapon(source,{'WEAPON_UMP45'})
                        GiveWeaponToPed(source, 'WEAPON_UMP45', 250, false, true)
                        ARMAclient.allowWeapon(source,{'WEAPON_MOSIN'})
                        GiveWeaponToPed(source, 'WEAPON_MOSIN', 250, false, true)
                        ARMA.giveBankMoney(user_id, 250000)
                        ARMAclient.notify(source, {'~g~You have redeemed your booster perks containing 1x UMP45, 1x Mosin Nagant,'})
                        ARMAclient.notify(source, {'~g~£250,000 and 1 Week of Platinum Subscription.'})
                        MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = rows[1].plathours + 168})
                    else
                        ARMAclient.notify(source, {'~r~You have already redeemed your subscription.'})
                    end
                end
            end)
        end
    end)
end)