
RegisterNetEvent('ATM:RefundLicense')
AddEventHandler('ATM:RefundLicense', function(group)
    local source = source
    user_id = ATM.getUserId(source)
    if group == 'LSD' then 
        if ATM.hasGroup(user_id, group) then
            ATM.removeUserGroup(user_id, group)
            ATM.giveBankMoney(user_id, 5000000)
            ATMclient.notify(source, {'~g~You have refunded ' .. group .. ' for £5,000,000 ~w~[25% of License Price]'})
        else
            ATMclient.notify(source, {'~r~Error, You do not have this License.'})
        end 
    elseif group == 'Rebel' then 
        if ATM.hasGroup(user_id, group) then
            ATM.removeUserGroup(user_id, group)
            ATM.giveBankMoney(user_id, 2500000)
            ATMclient.notify(source, {'~g~You have refunded ' .. group .. ' for £2,500,000 ~w~[25% of License Price]'})
        else
            ATMclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Gang' then 
        if ATM.hasGroup(user_id, group) then
            ATM.removeUserGroup(user_id, group)
            ATM.giveBankMoney(user_id, 125000)
            ATMclient.notify(source, {'~g~You have refunded ' .. group .. ' for £125,000 ~w~[25% of License Price]'})
        else
            ATMclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Heroin' then 
        if ATM.hasGroup(user_id, group) then
            ATM.removeUserGroup(user_id, group)
            ATM.giveBankMoney(user_id, 2500000)
            ATMclient.notify(source, {'~g~You have refunded ' .. group .. ' for £2,500,000 ~w~[25% of License Price]'})
        else
            ATMclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Diamond' then 
        if ATM.hasGroup(user_id, group) then
            ATM.removeUserGroup(user_id, group)
            ATM.giveBankMoney(user_id, 1250000)
            ATMclient.notify(source, {'~g~You have refunded ' .. group .. ' for £1,250,000 ~w~[25% of License Price]'})
        else
            ATMclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Gold' then 
        if ATM.hasGroup(user_id, group) then
            ATM.removeUserGroup(user_id, group)
            ATM.giveBankMoney(user_id, 250000)
            ATMclient.notify(source, {'~g~You have refunded ' .. group .. ' for £250,000 ~w~[25% of License Price]'})
        else
            ATMclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Cocaine' then 
        if ATM.hasGroup(user_id, group) then
            ATM.removeUserGroup(user_id, group)
            ATM.giveBankMoney(user_id, 125000)
            ATMclient.notify(source, {'~g~You have refunded ' .. group .. ' for £125,000 ~w~[25% of License Price]'})
        else
            ATMclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Weed' then 
        if ATM.hasGroup(user_id, group) then
            ATM.removeUserGroup(user_id, group)
            ATM.giveBankMoney(user_id, 50000)
            ATMclient.notify(source, {'~g~You have refunded ' .. group .. ' for £50,000 ~w~[25% of License Price]'})
        else
            ATMclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Scrap' then 
        if ATM.hasGroup(user_id, group) then
            ATM.removeUserGroup(user_id, group)
            ATM.giveBankMoney(user_id, 25000)
            ATMclient.notify(source, {'~g~You have refunded ' .. group .. ' for £25,000 ~w~[25% of License Price]'})
        else
            ATMclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    end

end)

RegisterNetEvent('ATM:SellLicense')
AddEventHandler('ATM:SellLicense', function(group)
    local source = source 
    user_id = ATM.getUserId(source)
    ATMclient.getNearestPlayers(source,{15},function(nplayers)
        usrList = ""
        for k,v in pairs(nplayers) do
            usrList = usrList .. "[" .. ATM.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
        end
        if ATM.hasGroup(user_id, group) then
            if usrList ~= "" then
                ATM.prompt(source,"Type the ID you want to sell this License too. " .. usrList,"",function(source,userid) 
                    ATM.prompt(source,"How much do you want to sell the License for?","",function(source,price) 
                        local target = ATM.getUserSource(tonumber(userid))
                        if price == tostring(tonumber(price)) then
                            if tonumber(price) >= 0 then 
                                ATMclient.notify(source, {'~g~Sent Request.'})
                                ATM.request(target,GetPlayerName(source).." wants to sell: " ..group.. " License for £"..price, 10, function(target,ok)
                                    if ok then
                                        
                                        if ATM.tryBankPayment(tonumber(userid), tonumber(price)) then
                                            ATM.giveBankMoney(user_id, tonumber(price))
                                            ATM.removeUserGroup(user_id, group)
                                            ATM.addUserGroup(tonumber(userid), group)

                                            ATMclient.notify(source, {'~g~Sold ' .. group .. ' License for £' .. price .. ' to ' .. GetPlayerName(target) .. ' ~w~[ID: ' .. userid .. ']'})
                                            TriggerClientEvent("ATM:PlaySound", source, 1)
                                            ATMclient.notify(target, {'~g~Bought ' .. group .. ' License for £' .. price .. ' from ' .. GetPlayerName(source) .. ' ~w~[ID: ' .. user_id .. ']'})
                                            TriggerClientEvent("ATM:PlaySound", target, 1)
                                        else
                                            ATMclient.notify(source, {'~r~User does not have enough money.'})
                                            ATMclient.notify(target, {'~r~You do not have enough money.'})
                                        end
                                    else
                                        ATMclient.notify(source, {'~r~User Denied.'})
                                        ATMclient.notify(target, {'~r~You Denied.'})
                                        TriggerClientEvent("ATM:PlaySound", source, 2)
                                    end
                                end)
                            else
                                
                                ATMclient.notify(source, {'~r~No negative numbers.'})
                            end
                        else
                            ATMclient.notify(source, {'~r~The value you entered is not a number!'})
                        end
                        
                    end)
                end)
            else
                ATMclient.notify(source, {'~r~No players nearby.'})
            end
        else
            ATMclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    end)
end)

RegisterNetEvent('GroupMenu:Groups')
AddEventHandler('GroupMenu:Groups', function()
    local source = source
    local user_id = ATM.getUserId(source)
    local GroupsL = {}
 
 
        if ATM.hasGroup(user_id, "Scrap") then
            GroupsL["Scrap"] = true;
        end
        if ATM.hasGroup(user_id, "Weed") then
            GroupsL["Weed"] = true;
        end
        if ATM.hasGroup(user_id, "Cocaine") then
            GroupsL["Cocaine"] = true;
        end
        if ATM.hasGroup(user_id, "Gold") then
            GroupsL["Gold"] = true;
        end
        if ATM.hasGroup(user_id, "Diamond") then
            GroupsL["Diamond"] = true;
        end
        if ATM.hasGroup(user_id, "Heroin") then
            GroupsL["Heroin"] = true;
        end
        if ATM.hasGroup(user_id, "Gang") then
            GroupsL["Gang"] = true;
        end
        if ATM.hasGroup(user_id, "Rebel") then
            GroupsL["Rebel"] = true;
        end
        if ATM.hasGroup(user_id, "LSD") then
            GroupsL["LSD"] = true;
        end


  
    TriggerClientEvent('GroupMenu:ReturnGroups', source, GroupsL)
end)


