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
                tARMA.sendWebhook('com-pot', 'ARMA Community Pot Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Deposit**\n> Amount: £**"..getMoneyStringFormatted(amount).."**")
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
                tARMA.sendWebhook('com-pot', 'ARMA Community Pot Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Withdraw**\n> Amount: £**"..getMoneyStringFormatted(amount).."**")
            end
        end)
    end
end)

RegisterServerEvent("ARMA:addToCommunityPot")
AddEventHandler("ARMA:addToCommunityPot", function(amount)
    if source ~= '' then return end
    exports['ghmattimysql']:execute("SELECT value FROM arma_community_pot", function(potbalance)
        local newpotbalance = parseInt(potbalance[1].value) + amount
        exports['ghmattimysql']:execute("UPDATE arma_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
    end)
end)