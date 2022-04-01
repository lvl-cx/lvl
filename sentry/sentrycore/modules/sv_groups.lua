
RegisterNetEvent('Sentry:RefundLicense')
AddEventHandler('Sentry:RefundLicense', function(group)
    local source = source
    user_id = Sentry.getUserId(source)
    if group == 'LSD' then 
        if Sentry.hasGroup(user_id, group) then
            Sentry.removeUserGroup(user_id, group)
            Sentry.giveBankMoney(user_id, 5000000)
            Sentryclient.notify(source, {'~g~You have refunded ' .. group .. ' for £5,000,000 ~w~[25% of License Price]'})
        else
            Sentryclient.notify(source, {'~r~Error, You do not have this License.'})
        end 
    elseif group == 'Rebel' then 
        if Sentry.hasGroup(user_id, group) then
            Sentry.removeUserGroup(user_id, group)
            Sentry.giveBankMoney(user_id, 2500000)
            Sentryclient.notify(source, {'~g~You have refunded ' .. group .. ' for £2,500,000 ~w~[25% of License Price]'})
        else
            Sentryclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Gang' then 
        if Sentry.hasGroup(user_id, group) then
            Sentry.removeUserGroup(user_id, group)
            Sentry.giveBankMoney(user_id, 125000)
            Sentryclient.notify(source, {'~g~You have refunded ' .. group .. ' for £125,000 ~w~[25% of License Price]'})
        else
            Sentryclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Heroin' then 
        if Sentry.hasGroup(user_id, group) then
            Sentry.removeUserGroup(user_id, group)
            Sentry.giveBankMoney(user_id, 2500000)
            Sentryclient.notify(source, {'~g~You have refunded ' .. group .. ' for £2,500,000 ~w~[25% of License Price]'})
        else
            Sentryclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Diamond' then 
        if Sentry.hasGroup(user_id, group) then
            Sentry.removeUserGroup(user_id, group)
            Sentry.giveBankMoney(user_id, 1250000)
            Sentryclient.notify(source, {'~g~You have refunded ' .. group .. ' for £1,250,000 ~w~[25% of License Price]'})
        else
            Sentryclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Gold' then 
        if Sentry.hasGroup(user_id, group) then
            Sentry.removeUserGroup(user_id, group)
            Sentry.giveBankMoney(user_id, 250000)
            Sentryclient.notify(source, {'~g~You have refunded ' .. group .. ' for £250,000 ~w~[25% of License Price]'})
        else
            Sentryclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Cocaine' then 
        if Sentry.hasGroup(user_id, group) then
            Sentry.removeUserGroup(user_id, group)
            Sentry.giveBankMoney(user_id, 125000)
            Sentryclient.notify(source, {'~g~You have refunded ' .. group .. ' for £125,000 ~w~[25% of License Price]'})
        else
            Sentryclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Weed' then 
        if Sentry.hasGroup(user_id, group) then
            Sentry.removeUserGroup(user_id, group)
            Sentry.giveBankMoney(user_id, 50000)
            Sentryclient.notify(source, {'~g~You have refunded ' .. group .. ' for £50,000 ~w~[25% of License Price]'})
        else
            Sentryclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Scrap' then 
        if Sentry.hasGroup(user_id, group) then
            Sentry.removeUserGroup(user_id, group)
            Sentry.giveBankMoney(user_id, 25000)
            Sentryclient.notify(source, {'~g~You have refunded ' .. group .. ' for £25,000 ~w~[25% of License Price]'})
        else
            Sentryclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    end

end)

RegisterNetEvent('Sentry:SellLicense')
AddEventHandler('Sentry:SellLicense', function(group)
    local source = source 
    user_id = Sentry.getUserId(source)
    Sentryclient.getNearestPlayers(source,{15},function(nplayers)
        usrList = ""
        for k,v in pairs(nplayers) do
            usrList = usrList .. "[" .. Sentry.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
        end
        if Sentry.hasGroup(user_id, group) then
            if usrList ~= "" then
                Sentry.prompt(source,"Type the ID you want to sell this License too. " .. usrList,"",function(source,userid) 
                    Sentry.prompt(source,"How much do you want to sell the License for?","",function(source,price) 
                        local target = Sentry.getUserSource(tonumber(userid))
                        if price == tostring(tonumber(price)) then
                            if tonumber(price) >= 0 then 
                                Sentryclient.notify(source, {'~g~Sent Request.'})
                                Sentry.request(target,GetPlayerName(source).." wants to sell: " ..group.. " License for £"..price, 10, function(target,ok)
                                    if ok then
                                        
                                        if Sentry.tryBankPayment(tonumber(userid), tonumber(price)) then
                                            Sentry.giveBankMoney(user_id, tonumber(price))
                                            Sentry.removeUserGroup(user_id, group)
                                            Sentry.addUserGroup(tonumber(userid), group)

                                            Sentryclient.notify(source, {'~g~Sold ' .. group .. ' License for £' .. price .. ' to ' .. GetPlayerName(target) .. ' ~w~[ID: ' .. userid .. ']'})
                                            TriggerClientEvent("Sentry:PlaySound", source, 1)
                                            Sentryclient.notify(target, {'~g~Bought ' .. group .. ' License for £' .. price .. ' from ' .. GetPlayerName(source) .. ' ~w~[ID: ' .. user_id .. ']'})
                                            TriggerClientEvent("Sentry:PlaySound", target, 1)
                                        else
                                            Sentryclient.notify(source, {'~r~User does not have enough money.'})
                                            Sentryclient.notify(target, {'~r~You do not have enough money.'})
                                        end
                                    else
                                        Sentryclient.notify(source, {'~r~User Denied.'})
                                        Sentryclient.notify(target, {'~r~You Denied.'})
                                        TriggerClientEvent("Sentry:PlaySound", source, 2)
                                    end
                                end)
                            else
                                
                                Sentryclient.notify(source, {'~r~No negative numbers.'})
                            end
                        else
                            Sentryclient.notify(source, {'~r~The value you entered is not a number!'})
                        end
                        
                    end)
                end)
            else
                Sentryclient.notify(source, {'~r~No players nearby.'})
            end
        else
            Sentryclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    end)
end)

RegisterNetEvent('GroupMenu:Groups')
AddEventHandler('GroupMenu:Groups', function()
    local source = source
    local user_id = Sentry.getUserId(source)
    local GroupsL = {}
 
 
        if Sentry.hasGroup(user_id, "Scrap") then
            GroupsL["Scrap"] = true;
        end
        if Sentry.hasGroup(user_id, "Weed") then
            GroupsL["Weed"] = true;
        end
        if Sentry.hasGroup(user_id, "Cocaine") then
            GroupsL["Cocaine"] = true;
        end
        if Sentry.hasGroup(user_id, "Gold") then
            GroupsL["Gold"] = true;
        end
        if Sentry.hasGroup(user_id, "Diamond") then
            GroupsL["Diamond"] = true;
        end
        if Sentry.hasGroup(user_id, "Heroin") then
            GroupsL["Heroin"] = true;
        end
        if Sentry.hasGroup(user_id, "Gang") then
            GroupsL["Gang"] = true;
        end
        if Sentry.hasGroup(user_id, "Rebel") then
            GroupsL["Rebel"] = true;
        end
        if Sentry.hasGroup(user_id, "LSD") then
            GroupsL["LSD"] = true;
        end


  
    TriggerClientEvent('GroupMenu:ReturnGroups', source, GroupsL)
end)

