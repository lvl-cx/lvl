ownedGaffs = {}

--SQL

MySQL = module("arma_mysql", "MySQL")

MySQL.createCommand("ARMA/get_address","SELECT home, number FROM arma_user_homes WHERE user_id = @user_id")
MySQL.createCommand("ARMA/get_home_owner","SELECT user_id FROM arma_user_homes WHERE home = @home AND number = @number")
MySQL.createCommand("ARMA/rm_address","DELETE FROM arma_user_homes WHERE user_id = @user_id AND home = @home")
MySQL.createCommand("ARMA/set_address","REPLACE INTO arma_user_homes(user_id,home,number) VALUES(@user_id,@home,@number)")

function getUserAddress(user_id, cbr)
    local task = Task(cbr)
  
    MySQL.query("ARMA/get_address", {user_id = user_id}, function(rows, affected)
        task({rows[1]})
    end)
end
  
function setUserAddress(user_id, home, number)
    MySQL.execute("ARMA/set_address", {user_id = user_id, home = home, number = number})
end
  
function removeUserAddress(user_id, home)
    MySQL.execute("ARMA/rm_address", {user_id = user_id, home = home})
end

function getUserByAddress(home, number, cbr)
    local task = Task(cbr)
  
    MySQL.query("ARMA/get_home_owner", {home = home, number = number}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].user_id})
        else
            task()
        end
    end)
end

function leaveHome(user_id, home, number, cbr)
    local task = Task(cbr)
  
    local player = ARMA.getUserSource(user_id)

    TriggerClientEvent("ARMAHousing:UpdateInHome", player, false)
    SetPlayerRoutingBucket(player, 0)
  
    for k, v in pairs(cfghomes.homes) do
        if k == home then
            local x,y,z = table.unpack(v.entry_point)
            ARMAclient.teleport(player, {x,y,z})
            task({true})
        end
    end
end

function accessHome(user_id, home, number, cbr)
    local task = Task(cbr)
  
    local player = ARMA.getUserSource(user_id)

    TriggerClientEvent("ARMAHousing:UpdateInHome", player, true)
    local count = 0
    for k, v in pairs(cfghomes.homes) do
        count = count+1
        if k == home then
            SetPlayerRoutingBucket(player, count)
            local x,y,z = table.unpack(v.leave_point)
            ARMAclient.teleport(player, {x,y,z})
            task({true})
        end
    end
end

--Main Events

RegisterNetEvent("ARMAHousing:Buy")
AddEventHandler("ARMAHousing:Buy", function(house)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)

    for k, v in pairs(cfghomes.homes) do
        if house == k then
            getUserByAddress(house,1,function(noowner) --check if house already has a owner
                if noowner == nil then
                    getUserAddress(user_id, function(address) -- check if user already has a home
                            if ARMA.tryFullPayment(user_id,v.buy_price) then --try payment
                                local price = v.buy_price
                                setUserAddress(user_id,house,1) --set address
                                ARMAclient.notify(player,{"~g~You bought "..k.."!"}) --notify
                                local webhook = 'webhook'
                                local embed = {
                                    {
                                        ["color"] = "16777215",
                                        ["title"] = "House Logs",
                                        ["description"] = "**User Name:** "..GetPlayerName(source).."\n**User ID:** "..ARMA.getUserId(source).."\n**Price: **".. price.. "\n **House Name: **" ..k,
                                        ["footer"] = {
                                            ["text"] = os.date("%X"),
                                        },
                                    }
                                }
                                PerformHttpRequest(webhook, function (err, text, headers) end, 'POST', json.encode({username = 'ARMA', embeds = embed}), { ['Content-Type'] = 'application/json' })
                            else
                                ARMAclient.notify(player,{"~r~You do not have enough money to buy "..k}) --not enough money
                            end
                    end)
                else
                    ARMAclient.notify(player,{"~r~Someone already owns "..k})
                end
                if noowner ~= nil then
                    TriggerClientEvent('HouseOwned', player)
                end
            end)
        end
    end
end)

RegisterNetEvent("ARMAHousing:Enter")
AddEventHandler("ARMAHousing:Enter", function(house)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)
    local name = GetPlayerName(source)

    getUserByAddress(house, 1, function(huser_id) --check if player owns home
        local hplayer = ARMA.getUserSource(huser_id) --temp id of home owner

        if huser_id ~= nil then
            if huser_id == user_id then
                accessHome(user_id, house, 1, function(ok) --enter home
                    if not ok then
                        ARMAclient.notify(player,{"~r~Unable to enter home"}) --notify unable to enter home for whatever reason
                    end
                end)
            else
                if hplayer ~= nil then --check if home owner is online
                    ARMAclient.notify(player,{"~r~You do not own this home, Knocked on door!"})
                    ARMA.request(hplayer,name.." knocked on your door!", 30, function(v,ok) --knock on door
                        if ok then
                            ARMAclient.notify(player,{"~g~Doorbell Accepted"}) --doorbell accepted
                            accessHome(user_id, house, 1, function(ok) --enter home
                                if not ok then
                                    ARMAclient.notify(player,{"~r~Unable to enter home!"}) --notify unable to enter home for whatever reason
                                end
                            end)
                        end
                        if not ok then
                            ARMAclient.notify(player,{"~r~Doorbell Refused "}) -- doorbell refused
                        end
                    end)
                else
                    ARMAclient.notify(player,{"~r~Home owner not online!"}) -- home owner not online
                end
            end
        else
            ARMAclient.notify(player,{"~r~Nobody owns "..house..""}) --no home owner & user_id already doesn't have a house
        end
    end)
end)

RegisterNetEvent("ARMAHousing:Leave")
AddEventHandler("ARMAHousing:Leave", function(house)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)

    leaveHome(user_id, house, 1, function(ok) --leave home
        if not ok then
            ARMAclient.notify(player,{"~r~Unable to leave home!"}) --notify if some error
        end
    end)
end)

RegisterNetEvent("ARMAHousing:Sell")
AddEventHandler("ARMAHousing:Sell", function(house)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)

    getUserByAddress(house, 1, function(huser_id)
        if huser_id == user_id then
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
                                ARMA.prompt(player,"Price £: ","",function(player, amount) --ask for price
                                    if tonumber(amount) and tonumber(amount) > 0 then
                                        ARMA.request(target,GetPlayerName(player).." wants to sell: " ..house.. " Price: £"..amount, 30, function(target,ok) --request new owner if they want to buy
                                            if ok then --bought
                                                local buyer_id = ARMA.getUserId(target) --get perm id of new owner
                                                amount = tonumber(amount) --convert amount str to int
                                                if ARMA.tryFullPayment(buyer_id,amount) then
                                                    setUserAddress(buyer_id, house, 1) --give house
                                                    removeUserAddress(user_id, house) -- remove house
                                                    ARMA.giveBankMoney(user_id, amount) --give money to original owner
                                                    ARMAclient.notify(player,{"~g~You have successfully sold "..house.." to ".. GetPlayerName(target).." for £"..amount.."!"}) --notify original owner
                                                    ARMAclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully sold you "..house.." for £"..amount.."!"}) --notify new owner
                                                    local webhook = 'https://discord.com/api/webhooks/973347553280135198/dnkc8GYV2hOIe6oi0Nl6YXo-ymdP2OgV6zhCOG6e_SJGuPL9SawLHLCag8bvx5GbsEe6'
                                                    local embed = {
                                                        {
                                                            ["color"] = "16777215",
                                                            ["title"] = "House Logs",
                                                            ["description"] = "**User Name:** "..GetPlayerName(source).."\n**User ID:** "..ARMA.getUserId(source).."\n**Buyer Name: **"..GetPlayerName(source).. "\n**Buyer ID: **" ..ARMA.getUserId(source).. "\n**Price: **".. amount.. "\n**House Name: **" ..house,
                                                            ["footer"] = {
                                                                ["text"] = os.date("%X"),
                                                            },
                                                        }
                                                    }
                                                    PerformHttpRequest(webhook, function (err, text, headers) end, 'POST', json.encode({username = 'ARMA', embeds = embed}), { ['Content-Type'] = 'application/json' })
                                    
                                               
                                                else
                                                    ARMAclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                    ARMAclient.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                end
                                            else
                                                ARMAclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to buy "..house.."!"}) --notify owner that refused
                                                ARMAclient.notify(target,{"~r~You have refused to buy "..house.."!"}) --notify new owner that refused
                                            end
                                        end)
                                    else
                                        ARMAclient.notify(player,{"~r~Price of home needs to be a number!"}) -- if price of home is a string not a int
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
        else
            ARMAclient.notify(player,{"~r~You do not own "..house.."!"})
        end
    end)
end)

--Chest

RegisterNetEvent("ARMAHousing:OpenChest")
AddEventHandler("ARMAHousing:OpenChest", function(house)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)

    getUserByAddress(house, 1, function(huser_id)
        if huser_id == user_id then --check if homeowner is user
            TriggerClientEvent("ARMA:OpenHomeStorage", player, true , house) --JamesUK inventory modified by me
        --print(house)
        else
            ARMAclient.notify(player,{"~r~You do not own this house!"})
        end
    end)
end)

--Wardrobe

RegisterNetEvent("ARMAHousing:SaveOutfit")
AddEventHandler("ARMAHousing:SaveOutfit", function(outfitName)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)

    ARMA.getUData(user_id, "ARMA:home:wardrobe", function(data)
        local sets = json.decode(data)

        if sets == nil then --check if user has no current wardrobe data and creates empty table
            sets = {}
        end

        ARMAclient.getCustomization(player,{},function(custom)
            sets[outfitName] = custom --add outfit to table
            ARMA.setUData(user_id,"ARMA:home:wardrobe",json.encode(sets)) --add outfit to database
            ARMAclient.notify(player,{"~g~Saved outfit "..outfitName.." to wardrobe!"})
            TriggerClientEvent("ARMAHousing:UpdateWardrobe", player, sets) --update wardrobe for client
        end)
    end)
end)

RegisterNetEvent("ARMAHousing:RemoveOutfit")
AddEventHandler("ARMAHousing:RemoveOutfit", function(outfitName)
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)

    ARMA.getUData(user_id, "ARMA:home:wardrobe", function(data)
        local sets = json.decode(data)

        if sets == nil then --check if user has no current wardrobe data and creates empty table
            sets = {}
        end

        sets[outfitName] = nil --replaces outfit in table with nil

        ARMA.setUData(user_id,"ARMA:home:wardrobe",json.encode(sets)) --add new table to db
        ARMAclient.notify(player,{"~r~Remove outfit "..outfitName.." from wardrobe!"})
        TriggerClientEvent("ARMAHousing:UpdateWardrobe", player, sets) --update wardrobe for client
    end)
end)

RegisterNetEvent("ARMAHousing:LoadWardrobe")
AddEventHandler("ARMAHousing:LoadWardrobe", function()
    local user_id = ARMA.getUserId(source)
    local player = ARMA.getUserSource(user_id)

    ARMA.getUData(user_id, "ARMA:home:wardrobe", function(data) --get data 
        local sets = json.decode(data)

        if sets == nil then --check if user has no current wardrobe data and creates empty table
            sets = {}
        end

        TriggerClientEvent("ARMAHousing:UpdateWardrobe", player, sets) --update wardrobe for client
        if ARMA.hasGroup(user_id, 'VIP') then
            TriggerClientEvent("clothingMenu:UpdateWardrobe", player, sets) --update wardrobe for client
        else
            TriggerClientEvent('clothingMenu:closeWardrobe', player)
        end
    end)
end)


--Blips

AddEventHandler("ARMA:playerSpawn",function(user_id, source, first_spawn)
    for k, v in pairs(cfghomes.homes) do
        local x,y,z = table.unpack(v.entry_point)
        getUserByAddress(k,1,function(owner)
            if owner == nil then -- check if house is avaliable to be bought aka no owner of home
                ARMAclient.addBlip(source,{x,y,z,374,2,k}) -- add blip, 374,2 green house symbol
            end

            if owner == user_id then -- check if owner is user
                ARMAclient.addBlip(source,{x,y,z,374,1,k}) -- add blip for owner of home, 374,2 green house symbol
            end
        end)
    end
end)
