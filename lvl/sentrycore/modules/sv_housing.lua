local cfg = module("lvlcore/cfg/cfg_housing")

--SQL

MySQL.createCommand("LVL/get_address","SELECT home, number FROM lvl_user_homes WHERE user_id = @user_id")
MySQL.createCommand("LVL/get_home_owner","SELECT user_id FROM lvl_user_homes WHERE home = @home AND number = @number")
MySQL.createCommand("LVL/rm_address","DELETE FROM lvl_user_homes WHERE user_id = @user_id")
MySQL.createCommand("LVL/set_address","REPLACE INTO lvl_user_homes(user_id,home,number) VALUES(@user_id,@home,@number)")

--Functions (Thanks to DunkoLVL standard housing)

function LVL.getUserAddress(user_id, cbr)
    local task = Task(cbr)
  
    MySQL.query("LVL/get_address", {user_id = user_id}, function(rows, affected)
        task({rows[1]})
    end)
end
  
function LVL.setUserAddress(user_id, home, number)
    MySQL.execute("LVL/set_address", {user_id = user_id, home = home, number = number})
end
  
function LVL.removeUserAddress(user_id)
    MySQL.execute("LVL/rm_address", {user_id = user_id})
end

function LVL.getUserByAddress(home, number, cbr)
    local task = Task(cbr)
  
    MySQL.query("LVL/get_home_owner", {home = home, number = number}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].user_id})
        else
            task()
        end
    end)
end

function LVL.leaveHome(user_id, home, number, cbr)
    local task = Task(cbr)
  
    local player = LVL.getUserSource(user_id)

    TriggerClientEvent("JudHousing:UpdateInHome", player, false)
  
    for k, v in pairs(cfg.homes) do
        if k == home then
            local x,y,z = table.unpack(v.entry_point)
            LVLclient.teleport(player, {x,y,z})
            task({true})
        end
    end
end

function LVL.accessHome(user_id, home, number, cbr)
    local task = Task(cbr)
  
    local player = LVL.getUserSource(user_id)

    TriggerClientEvent("JudHousing:UpdateInHome", player, true)
  
    for k, v in pairs(cfg.homes) do
        if k == home then
            local x,y,z = table.unpack(v.leave_point)
            LVLclient.teleport(player, {x,y,z})
            task({true})
        end
    end
end

--Main Events

RegisterNetEvent("JudHousing:Buy")
AddEventHandler("JudHousing:Buy", function(house)
    local user_id = LVL.getUserId(source)
    local player = LVL.getUserSource(user_id)
    for k, v in pairs(cfg.homes) do
        if house == k then
            LVL.getUserByAddress(house,1,function(noowner) --check if house already has a owner
                if noowner == nil then
                    LVL.getUserAddress(user_id, function(address) -- check if user already has a home
                        if address == nil then --not already got a home
                            if LVL.tryFullPayment(user_id,v.buy_price) then --try payment
                                LVL.setUserAddress(user_id,house,1) --set address
                                LVLclient.notify(player,{"~b~You bought "..k.."!"}) --notify
                            else
                                LVLclient.notify(player,{"~r~You do not have enough money to buy "..k.."!"}) --not enough money
                            end
                        else
                            LVLclient.notify(player,{"~r~You already own a home!"}) --already has a home
                        end
                    end)
                else
                    LVLclient.notify(player,{"~r~Someone already owns "..k.."!"})
                end
            end)
        end
    end
end)


RegisterNetEvent('GrabHouseInfo')
AddEventHandler('GrabHouseInfo', function(house)
    local source = source
    LVL.getUserByAddress(house, 1, function(huser_id)
        TriggerClientEvent('ReceiveHouseInfo', source, tostring(huser_id))
    end)
end)


RegisterNetEvent("JudHousing:Enter")
AddEventHandler("JudHousing:Enter", function(house)
    local user_id = LVL.getUserId(source)
    local player = LVL.getUserSource(user_id)
    local name = GetPlayerName(source)

    LVL.getUserByAddress(house, 1, function(huser_id) --check if player owns home
        local hplayer = LVL.getUserSource(huser_id) --temp id of home owner

        if huser_id ~= nil then
            if huser_id == user_id then
                LVL.accessHome(user_id, house, 1, function(ok) --enter home
                    if not ok then
                        LVLclient.notify(player,{"~r~Unable to enter home"}) --notify unable to enter home for whatever reason
                    end
                end)
            else
                if hplayer ~= nil then --check if home owner is online
                    LVLclient.notify(player,{"~r~You do not own this home, Knocked on door!"})
                    LVL.request(hplayer,name.." knocked on your door!", 30, function(v,ok) --knock on door
                        if ok then
                            LVLclient.notify(player,{"~b~Doorbell Accepted!"}) --doorbell accepted
                            LVL.accessHome(user_id, house, 1, function(ok) --enter home
                                if not ok then
                                    LVLclient.notify(player,{"~r~Unable to enter home!"}) --notify unable to enter home for whatever reason
                                end
                            end)
                        end
                        if not ok then
                            LVLclient.notify(player,{"~r~Doorbell Refused!"}) -- doorbell refused
                        end
                    end)
                else
                    LVLclient.notify(player,{"~r~Home owner not online!"}) -- home owner not online
                end
            end
        else
            LVL.getUserAddress(user_id, function(address) -- check if user already has a home
                if address == nil then
                    LVLclient.notify(player,{"~r~Nobody owns this "..house..", why dont you buy it?"}) --no home owner & user_id already doesn't have a house
                else
                    LVLclient.notify(player,{"~r~Nobody owns "..house.."!"}) --already has a home, notify nobody owns it
                end
            end)
        end
    end)
end)

RegisterNetEvent("JudHousing:Leave")
AddEventHandler("JudHousing:Leave", function(house)
    local user_id = LVL.getUserId(source)
    local player = LVL.getUserSource(user_id)

    LVL.leaveHome(user_id, house, 1, function(ok) --leave home
        if not ok then
            LVLclient.notify(player,{"~r~Unable to leave home!"}) --notify if some error
        end
    end)
end)

RegisterNetEvent("JudHousing:Sell")
AddEventHandler("JudHousing:Sell", function(house)
    local user_id = LVL.getUserId(source)
    local player = LVL.getUserSource(user_id)

    LVL.getUserByAddress(house, 1, function(huser_id)
        if huser_id == user_id then
            LVLclient.getNearestPlayers(player,{15},function(nplayers) --get nearest players
                usrList = ""
                for k, v in pairs(nplayers) do
                    usrList = usrList .. "[" .. LVL.getUserId(k) .. "]" .. GetPlayerName(k) .. " | " --add ids to usrList
                end
                if usrList ~= "" then
                    LVL.prompt(player,"Players Nearby: " .. usrList .. "","",function(player, target_id) --ask for id
                        target_id = target_id
                        if target_id ~= nil and target_id ~= "" then --validation
                            local target = LVL.getUserSource(tonumber(target_id)) --get source of the new owner id
                            if target ~= nil then
                                LVL.prompt(player,"Price £: ","",function(player, amount) --ask for price
                                    if tonumber(amount) and tonumber(amount) > 0 then
                                        LVL.request(target,GetPlayerName(player).." wants to sell: " ..house.. " Price: £"..amount, 30, function(target,ok) --request new owner if they want to buy
                                            if ok then --bought
                                                local buyer_id = LVL.getUserId(target) --get perm id of new owner
                                                amount = tonumber(amount) --convert amount str to int
                                                if LVL.tryFullPayment(buyer_id,amount) then
                                                    LVL.setUserAddress(buyer_id, house, 1) --give house
                                                    LVL.removeUserAddress(user_id) -- remove house
                                                    LVL.giveBankMoney(user_id, amount) --give money to original owner
                                                    LVLclient.notify(player,{"~b~You have successfully sold "..house.." to ".. GetPlayerName(target).." for £"..amount.."!"}) --notify original owner
                                                    LVLclient.notify(target,{"~b~"..GetPlayerName(player).." has successfully sold you "..house.." for £"..amount.."!"}) --notify new owner
                                                else
                                                    LVLclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                    LVLclient.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                end
                                            else
                                                LVLclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to buy "..house.."!"}) --notify owner that refused
                                                LVLclient.notify(target,{"~r~You have refused to buy "..house.."!"}) --notify new owner that refused
                                            end
                                        end)
                                    else
                                        LVLclient.notify(player,{"~r~Price of home needs to be a number!"}) -- if price of home is a string not a int
                                    end
                                end)
                            else
                                LVLclient.notify(player,{"~r~That Perm ID seems to be invalid!"}) --couldnt find perm id
                            end
                        else
                            LVLclient.notify(player,{"~r~No Perm ID selected!"}) --no perm id selected
                        end
                    end)
                else
                    LVLclient.notify(player,{"~r~No players nearby!"}) --no players nearby
                end
            end)
        else
            LVLclient.notify(player,{"~r~You do not own "..house.."!"})
        end
    end)
end)

--Chest

RegisterNetEvent("JudHousing:OpenChest")
AddEventHandler("JudHousing:OpenChest", function(house)
    local user_id = LVL.getUserId(source)
    local player = LVL.getUserSource(user_id)

    LVL.getUserByAddress(house, 1, function(huser_id)
        if huser_id == user_id then --check if homeowner is user
            TriggerClientEvent("Jud:OpenHomeStorage", player, true) --JamesUK inventory modified by me
        else
            LVLclient.notify(player,{"~r~You do not own this house!"})
        end
    end)
end)

--Wardrobe

RegisterNetEvent("JudHousing:SaveOutfit")
AddEventHandler("JudHousing:SaveOutfit", function(outfitName)
    local user_id = LVL.getUserId(source)
    local player = LVL.getUserSource(user_id)

    LVL.getUData(user_id, "LVL:home:wardrobe", function(data)
        local sets = json.decode(data)
                                                                                                            
        if sets == nil then --check if user has no current wardrobe data and creates empty table
            sets = {}
        end

        LVLclient.getCustomization2(player,{},function(custom)
            sets[outfitName] = custom --add outfit to table
            LVL.setUData(user_id,"LVL:home:wardrobe",json.encode(sets)) --add outfit to database
            LVLclient.notify(player,{"~b~Saved outfit "..outfitName.." to wardrobe!"})
            TriggerClientEvent("JudHousing:UpdateWardrobe", player, sets) --update wardrobe for client
        end)
    end)
end)

RegisterNetEvent("JudHousing:RemoveOutfit")
AddEventHandler("JudHousing:RemoveOutfit", function(outfitName)
    local user_id = LVL.getUserId(source)
    local player = LVL.getUserSource(user_id)

    LVL.getUData(user_id, "LVL:home:wardrobe", function(data)
        local sets = json.decode(data)

        if sets == nil then --check if user has no current wardrobe data and creates empty table
            sets = {}
        end

        sets[outfitName] = nil --replaces outfit in table with nil

        LVL.setUData(user_id,"LVL:home:wardrobe",json.encode(sets)) --add new table to db
        LVLclient.notify(player,{"~r~Remove outfit "..outfitName.." from wardrobe!"})
        TriggerClientEvent("JudHousing:UpdateWardrobe", player, sets) --update wardrobe for client
    end)
end)

RegisterNetEvent("JudHousing:LoadWardrobe")
AddEventHandler("JudHousing:LoadWardrobe", function()
    local user_id = LVL.getUserId(source)
    local player = LVL.getUserSource(user_id)

    LVL.getUData(user_id, "LVL:home:wardrobe", function(data) --get data 
        local sets = json.decode(data)

        if sets == nil then --check if user has no current wardrobe data and creates empty table
            sets = {}
        end

        TriggerClientEvent("JudHousing:UpdateWardrobe", player, sets) --update wardrobe for client
    end)
end)

--Blips

AddEventHandler("LVL:playerSpawn",function(user_id, source, first_spawn)
    if first_spawn then
        for k, v in pairs(cfg.homes) do
            local x,y,z = table.unpack(v.entry_point)
            LVL.getUserByAddress(k,1,function(owner)
                if owner == nil then -- check if house is avaliable to be bought aka no owner of home
                    LVLclient.addBlip(source,{x,y,z,374,2,k}) -- add blip, 374,2 green house symbol
                end

                if owner == user_id then -- check if owner is user
                    LVLclient.addBlip(source,{x,y,z,374,1,k}) -- add blip for owner of home, 374,1 red house symbol
               
                    TriggerClientEvent('HouseRespawn',source,k,v.entry_point)
                end
            end)
        end
    end
end)