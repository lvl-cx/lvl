RegisterServerEvent("OASIS:getCommunityPotAmount")
AddEventHandler("OASIS:getCommunityPotAmount", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    exports['ghmattimysql']:execute("SELECT value FROM oasis_community_pot", function(potbalance)
        TriggerClientEvent('OASIS:gotCommunityPotAmount', source, parseInt(potbalance[1].value))
    end)
end)

RegisterServerEvent("OASIS:tryDepositCommunityPot")
AddEventHandler("OASIS:tryDepositCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['ghmattimysql']:execute("SELECT value FROM oasis_community_pot", function(potbalance)
            if OASIS.tryFullPayment(user_id,amount) then
                local newpotbalance = parseInt(potbalance[1].value) + amount
                exports['ghmattimysql']:execute("UPDATE oasis_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('OASIS:gotCommunityPotAmount', source, newpotbalance)
                tOASIS.sendWebhook('com-pot', 'OASIS Community Pot Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Deposit**\n> Amount: £**"..getMoneyStringFormatted(amount).."**")
            end
        end)
    end
end)

RegisterServerEvent("OASIS:tryWithdrawCommunityPot")
AddEventHandler("OASIS:tryWithdrawCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['ghmattimysql']:execute("SELECT value FROM oasis_community_pot", function(potbalance)
            if parseInt(potbalance[1].value) >= amount then
                local newpotbalance = parseInt(potbalance[1].value) - amount
                exports['ghmattimysql']:execute("UPDATE oasis_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('OASIS:gotCommunityPotAmount', source, newpotbalance)
                OASIS.giveMoney(user_id, amount)
                tOASIS.sendWebhook('com-pot', 'OASIS Community Pot Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Withdraw**\n> Amount: £**"..getMoneyStringFormatted(amount).."**")
            end
        end)
    end
end)

RegisterServerEvent("OASIS:addToCommunityPot")
AddEventHandler("OASIS:addToCommunityPot", function(amount)
    if source ~= '' then return end
    exports['ghmattimysql']:execute("SELECT value FROM oasis_community_pot", function(potbalance)
        local newpotbalance = parseInt(potbalance[1].value) + amount
        exports['ghmattimysql']:execute("UPDATE oasis_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
    end)
end)