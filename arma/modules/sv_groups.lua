
RegisterNetEvent('ARMA:RefundLicense')
AddEventHandler('ARMA:RefundLicense', function(group)
    local source = source
    user_id = ARMA.getUserId(source)
    if group == 'LSD' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 5000000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £5,000,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end 
    elseif group == 'Rebel' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 2500000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £2,500,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'AdvancedRebel' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 5000000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £5,000,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Gang' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 125000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £125,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Heroin' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 2500000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £2,500,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Diamond' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 1250000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £1,250,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Gold' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 250000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £250,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Cocaine' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 125000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £125,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Weed' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 50000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £50,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Scrap' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 25000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £25,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    end
end)

RegisterNetEvent('ARMA:SellLicense')
AddEventHandler('ARMA:SellLicense', function(group)
    local source = source 
    user_id = ARMA.getUserId(source)
    ARMAclient.getNearestPlayers(source,{15},function(nplayers)
        usrList = ""
        for k,v in pairs(nplayers) do
            usrList = usrList .. "[" .. ARMA.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
        end
        if ARMA.hasGroup(user_id, group) then
            if usrList ~= "" then
                ARMA.prompt(source,"Type the ID you want to sell this License too. " .. usrList,"",function(source,userid) 
                    ARMA.prompt(source,"How much do you want to sell the License for?","",function(source,price) 
                        local target = ARMA.getUserSource(tonumber(userid))
                        if price == tostring(tonumber(price)) then
                            if tonumber(price) >= 0 then 
                                ARMAclient.notify(source, {'~g~Sent Request.'})
                                ARMA.request(target,GetPlayerName(source).." wants to sell: " ..group.. " License for £"..price, 10, function(target,ok)
                                    if ok then
                                        if ARMA.tryBankPayment(tonumber(userid), tonumber(price)) then
                                            ARMA.giveBankMoney(user_id, tonumber(price))
                                            ARMA.removeUserGroup(user_id, group)
                                            ARMA.addUserGroup(tonumber(userid), group)

                                            ARMAclient.notify(source, {'~g~Sold ' .. group .. ' License for £' .. price .. ' to ' .. GetPlayerName(target) .. ' [ID: ' .. userid .. ']'})
                                            TriggerClientEvent("arma:PlaySound", source, 1)
                                            ARMAclient.notify(target, {'~g~Bought ' .. group .. ' License for £' .. price .. ' from ' .. GetPlayerName(source) .. ' [ID: ' .. user_id .. ']'})
                                            TriggerClientEvent("arma:PlaySound", target, 1)
                                        else
                                            ARMAclient.notify(source, {'~r~User does not have enough money.'})
                                            ARMAclient.notify(target, {'~r~You do not have enough money.'})
                                        end
                                    else
                                        ARMAclient.notify(source, {'~r~User Denied.'})
                                        ARMAclient.notify(target, {'~r~You Denied.'})
                                        TriggerClientEvent("arma:PlaySound", source, 2)
                                    end
                                end)
                            else
                                
                                ARMAclient.notify(source, {'~r~No negative numbers.'})
                            end
                        else
                            ARMAclient.notify(source, {'~r~The value you entered is not a number!'})
                        end
                        
                    end)
                end)
            else
                ARMAclient.notify(source, {'~r~No players nearby.'})
            end
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    end)
end)

RegisterNetEvent('GroupMenu:Groups')
AddEventHandler('GroupMenu:Groups', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local GroupsL = {}
 
 
        if ARMA.hasGroup(user_id, "Scrap") then
            table.insert(GroupsL, {name = 'Scrap License', group = 'Scrap'})
        end
        if ARMA.hasGroup(user_id, "Weed") then
            table.insert(GroupsL, {name = 'Weed License', group = 'Weed'})
        end
        if ARMA.hasGroup(user_id, "Cocaine") then
            table.insert(GroupsL, {name = 'Cocaine License', group = 'Cocaine'})
        end
        if ARMA.hasGroup(user_id, "Gold") then
            table.insert(GroupsL, {name = 'Gold License', group = 'Gold'})
        end
        if ARMA.hasGroup(user_id, "Diamond") then
            table.insert(GroupsL, {name = 'Diamond License', group = 'Diamond'})
        end
        if ARMA.hasGroup(user_id, "Heroin") then
            table.insert(GroupsL, {name = 'Heroin License', group = 'Heroin'})
        end
        if ARMA.hasGroup(user_id, "Gang") then
            table.insert(GroupsL, {name = 'Gang License', group = 'Gang'})
        end
        if ARMA.hasGroup(user_id, "Rebel") then
            table.insert(GroupsL, {name = 'Rebel License', group = 'Rebel'})
        end
        if ARMA.hasGroup(user_id, "AdvancedRebel") then
            table.insert(GroupsL, {name = 'Advanced Rebel', group = 'AdvancedRebel'})
        end
        if ARMA.hasGroup(user_id, "LSD") then
            table.insert(GroupsL, {name = 'LSD License', group = 'LSD'})
        end
        if ARMA.hasGroup(user_id, "DJ") then
            table.insert(GroupsL, {name = 'DJ License', group = 'DJ'})
        end
        if ARMA.hasGroup(user_id, "polblips") then
            table.insert(GroupsL, {name = 'Long Range Emergency Blips', group = 'polblips'})
        end
        if ARMA.hasGroup(user_id, "PilotLicense") then
            table.insert(GroupsL, {name = 'Pilot License', group = 'PilotLicense'})
        end


  
    TriggerClientEvent('GroupMenu:ReturnGroups', source, GroupsL)
end)


