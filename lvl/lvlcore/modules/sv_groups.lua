
RegisterNetEvent('LVL:RefundLicense')
AddEventHandler('LVL:RefundLicense', function(group)
    local source = source
    user_id = LVL.getUserId(source)
    if group == 'LSD' then 
        if LVL.hasGroup(user_id, group) then
            LVL.removeUserGroup(user_id, group)
            LVL.giveBankMoney(user_id, 5000000)
            LVLclient.notify(source, {'~g~You have refunded ' .. group .. ' for £5,000,000 ~w~[25% of License Price]'})
        else
            LVLclient.notify(source, {'~r~Error, You do not have this License.'})
        end 
    elseif group == 'Rebel' then 
        if LVL.hasGroup(user_id, group) then
            LVL.removeUserGroup(user_id, group)
            LVL.giveBankMoney(user_id, 2500000)
            LVLclient.notify(source, {'~g~You have refunded ' .. group .. ' for £2,500,000 ~w~[25% of License Price]'})
        else
            LVLclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Gang' then 
        if LVL.hasGroup(user_id, group) then
            LVL.removeUserGroup(user_id, group)
            LVL.giveBankMoney(user_id, 125000)
            LVLclient.notify(source, {'~g~You have refunded ' .. group .. ' for £125,000 ~w~[25% of License Price]'})
        else
            LVLclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Heroin' then 
        if LVL.hasGroup(user_id, group) then
            LVL.removeUserGroup(user_id, group)
            LVL.giveBankMoney(user_id, 2500000)
            LVLclient.notify(source, {'~g~You have refunded ' .. group .. ' for £2,500,000 ~w~[25% of License Price]'})
        else
            LVLclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Diamond' then 
        if LVL.hasGroup(user_id, group) then
            LVL.removeUserGroup(user_id, group)
            LVL.giveBankMoney(user_id, 1250000)
            LVLclient.notify(source, {'~g~You have refunded ' .. group .. ' for £1,250,000 ~w~[25% of License Price]'})
        else
            LVLclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Gold' then 
        if LVL.hasGroup(user_id, group) then
            LVL.removeUserGroup(user_id, group)
            LVL.giveBankMoney(user_id, 250000)
            LVLclient.notify(source, {'~g~You have refunded ' .. group .. ' for £250,000 ~w~[25% of License Price]'})
        else
            LVLclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Cocaine' then 
        if LVL.hasGroup(user_id, group) then
            LVL.removeUserGroup(user_id, group)
            LVL.giveBankMoney(user_id, 125000)
            LVLclient.notify(source, {'~g~You have refunded ' .. group .. ' for £125,000 ~w~[25% of License Price]'})
        else
            LVLclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Weed' then 
        if LVL.hasGroup(user_id, group) then
            LVL.removeUserGroup(user_id, group)
            LVL.giveBankMoney(user_id, 50000)
            LVLclient.notify(source, {'~g~You have refunded ' .. group .. ' for £50,000 ~w~[25% of License Price]'})
        else
            LVLclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Scrap' then 
        if LVL.hasGroup(user_id, group) then
            LVL.removeUserGroup(user_id, group)
            LVL.giveBankMoney(user_id, 25000)
            LVLclient.notify(source, {'~g~You have refunded ' .. group .. ' for £25,000 ~w~[25% of License Price]'})
        else
            LVLclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    end

end)

RegisterNetEvent('LVL:SellLicense')
AddEventHandler('LVL:SellLicense', function(group)
    local source = source 
    user_id = LVL.getUserId(source)
    LVLclient.getNearestPlayers(source,{15},function(nplayers)
        usrList = ""
        for k,v in pairs(nplayers) do
            usrList = usrList .. "[" .. LVL.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
        end
        if LVL.hasGroup(user_id, group) then
            if usrList ~= "" then
                LVL.prompt(source,"Type the ID you want to sell this License too. " .. usrList,"",function(source,userid) 
                    LVL.prompt(source,"How much do you want to sell the License for?","",function(source,price) 
                        local target = LVL.getUserSource(tonumber(userid))
                        if price == tostring(tonumber(price)) then
                            if tonumber(price) >= 0 then 
                                LVLclient.notify(source, {'~g~Sent Request.'})
                                LVL.request(target,GetPlayerName(source).." wants to sell: " ..group.. " License for £"..price, 10, function(target,ok)
                                    if ok then
                                        
                                        if LVL.tryBankPayment(tonumber(userid), tonumber(price)) then
                                            LVL.giveBankMoney(user_id, tonumber(price))
                                            LVL.removeUserGroup(user_id, group)
                                            LVL.addUserGroup(tonumber(userid), group)

                                            LVLclient.notify(source, {'~g~Sold ' .. group .. ' License for £' .. price .. ' to ' .. GetPlayerName(target) .. ' ~w~[ID: ' .. userid .. ']'})
                                            TriggerClientEvent("LVL:PlaySound", source, 1)
                                            LVLclient.notify(target, {'~g~Bought ' .. group .. ' License for £' .. price .. ' from ' .. GetPlayerName(source) .. ' ~w~[ID: ' .. user_id .. ']'})
                                            TriggerClientEvent("LVL:PlaySound", target, 1)
                                        else
                                            LVLclient.notify(source, {'~r~User does not have enough money.'})
                                            LVLclient.notify(target, {'~r~You do not have enough money.'})
                                        end
                                    else
                                        LVLclient.notify(source, {'~r~User Denied.'})
                                        LVLclient.notify(target, {'~r~You Denied.'})
                                        TriggerClientEvent("LVL:PlaySound", source, 2)
                                    end
                                end)
                            else
                                
                                LVLclient.notify(source, {'~r~No negative numbers.'})
                            end
                        else
                            LVLclient.notify(source, {'~r~The value you entered is not a number!'})
                        end
                        
                    end)
                end)
            else
                LVLclient.notify(source, {'~r~No players nearby.'})
            end
        else
            LVLclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    end)
end)

RegisterNetEvent('GroupMenu:Groups')
AddEventHandler('GroupMenu:Groups', function()
    local source = source
    local user_id = LVL.getUserId(source)
    local GroupsL = {}
 
 
        if LVL.hasGroup(user_id, "Scrap") then
            GroupsL["Scrap"] = true;
        end
        if LVL.hasGroup(user_id, "Weed") then
            GroupsL["Weed"] = true;
        end
        if LVL.hasGroup(user_id, "Cocaine") then
            GroupsL["Cocaine"] = true;
        end
        if LVL.hasGroup(user_id, "Gold") then
            GroupsL["Gold"] = true;
        end
        if LVL.hasGroup(user_id, "Diamond") then
            GroupsL["Diamond"] = true;
        end
        if LVL.hasGroup(user_id, "Heroin") then
            GroupsL["Heroin"] = true;
        end
        if LVL.hasGroup(user_id, "Gang") then
            GroupsL["Gang"] = true;
        end
        if LVL.hasGroup(user_id, "Rebel") then
            GroupsL["Rebel"] = true;
        end
        if LVL.hasGroup(user_id, "LSD") then
            GroupsL["LSD"] = true;
        end


  
    TriggerClientEvent('GroupMenu:ReturnGroups', source, GroupsL)
end)


