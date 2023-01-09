MySQL.createCommand("casinochips/add_id", "INSERT IGNORE INTO arma_casino_chips SET user_id = @user_id")
MySQL.createCommand("casinochips/get_chips","SELECT * FROM arma_casino_chips WHERE user_id = @user_id")
MySQL.createCommand("casinochips/add_chips", "UPDATE arma_casino_chips SET chips = (chips + @amount) WHERE user_id = @user_id")
MySQL.createCommand("casinochips/remove_chips", "UPDATE arma_casino_chips SET chips = CASE WHEN ((chips - @amount)>0) THEN (chips - @amount) ELSE 0 END WHERE user_id = @user_id")


AddEventHandler("playerJoining", function()
    local user_id = ARMA.getUserId(source)
    MySQL.execute("casinochips/add_id", {user_id = user_id})
end)

RegisterNetEvent("ARMA:enterDiamondCasino")
AddEventHandler("ARMA:enterDiamondCasino", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('ARMA:setDisplayChips', source, rows[1].chips)
        end
    end)
end)

RegisterNetEvent("ARMA:getChips")
AddEventHandler("ARMA:getChips", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('ARMA:setDisplayChips', source, rows[1].chips)
        end
    end)
end)

RegisterNetEvent("ARMA:buyChips")
AddEventHandler("ARMA:buyChips", function(amount)
    local source = source
    local user_id = ARMA.getUserId(source)
    if not amount then amount = ARMA.getMoney(user_id) end
    if ARMA.tryPayment(user_id, amount) then
        MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
        TriggerClientEvent('ARMA:chipsUpdated', source)
        tARMA.sendWebhook('purchase-chips',"ARMA Chip Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(amount).."**")
    else
        ARMAclient.notify(source,{"~r~You don't have enough money."})
    end
end)

RegisterNetEvent("ARMA:sellChips")
AddEventHandler("ARMA:sellChips", function(amount)
    local source = source
    local user_id = ARMA.getUserId(source)
    local chips = nil
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            local chips = rows[1].chips
            if not amount then amount = chips end
            if amount > chips then
                ARMAclient.notify(source,{"~r~You don't have enough chips."})
            else
                MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = amount})
                TriggerClientEvent('ARMA:chipsUpdated', source)
                tARMA.sendWebhook('sell-chips',"ARMA Chip Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(amount).."**")
                ARMA.giveMoney(user_id, amount)
            end
        end
    end)
end)