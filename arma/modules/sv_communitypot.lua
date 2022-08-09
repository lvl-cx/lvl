RegisterServerEvent("ARMA:getCommunityPotAmount")
AddEventHandler("ARMA:getCommunityPotAmount", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    exports['ghmattimysql']:execute("SELECT value FROM arma_community_pot", function(potbalance)
        TriggerClientEvent('ARMA:gotCommunityPotAmount', source, parseInt(potbalance[1].value))
    end)
end)

RegisterServerEvent("ARMA:tryDepositCommunityPot")
AddEventHandler("ARMA:tryDepositCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['ghmattimysql']:execute("SELECT value FROM arma_community_pot", function(potbalance)
            if ARMA.tryFullPayment(user_id,amount) then
                local newpotbalance = parseInt(potbalance[1].value) + amount
                exports['ghmattimysql']:execute("UPDATE arma_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('ARMA:gotCommunityPotAmount', source, newpotbalance)
            end
        end)
    end
end)

RegisterServerEvent("ARMA:tryWithdrawCommunityPot")
AddEventHandler("ARMA:tryWithdrawCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['ghmattimysql']:execute("SELECT value FROM arma_community_pot", function(potbalance)
            if parseInt(potbalance[1].value) >= amount then
                local newpotbalance = parseInt(potbalance[1].value) - amount
                exports['ghmattimysql']:execute("UPDATE arma_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('ARMA:gotCommunityPotAmount', source, newpotbalance)
                ARMA.giveMoney(user_id, amount)
            end
        end)
    end
end)