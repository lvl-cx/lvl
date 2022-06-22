RegisterServerEvent('ARMA:hoursReward')
AddEventHandler('ARMA:hoursReward', function(reward)
    local source = source
    local user_id = ARMA.getUserId(source)
    local hours = math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0

    if hours < reward then ARMAclient.notify(source,{'~r~You do not have enough hours to claim this reward.'}) return end
    if not ARMA.hasGroup(user_id, reward..'hrs') then
        if hours >= reward then
            ARMA.giveBankMoney(user_id,reward*100)
        end
        ARMA.addUserGroup(user_id, reward..'hrs')
        ARMAclient.notify(source,{'~g~You have received your ~b~'..reward..' ~g~hours reward.'})
    else
        ARMAclient.notify(source,{'~r~You have already claimed the ~b~'..reward..' ~r~hours reward.'})
    end
end)


RegisterServerEvent('ARMA:getHoursReward')
AddEventHandler('ARMA:getHoursReward', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local hours = math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0
    TriggerClientEvent('ARMA:sendHoursReward', source, hours)
end)