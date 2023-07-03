MySQL.createCommand("casinochips/add_id", "INSERT IGNORE INTO oasis_casino_chips SET user_id = @user_id")
MySQL.createCommand("casinochips/get_chips","SELECT * FROM oasis_casino_chips WHERE user_id = @user_id")
MySQL.createCommand("casinochips/add_chips", "UPDATE oasis_casino_chips SET chips = (chips + @amount) WHERE user_id = @user_id")
MySQL.createCommand("casinochips/remove_chips", "UPDATE oasis_casino_chips SET chips = CASE WHEN ((chips - @amount)>0) THEN (chips - @amount) ELSE 0 END WHERE user_id = @user_id")


AddEventHandler("playerJoining", function()
    local user_id = OASIS.getUserId(source)
    MySQL.execute("casinochips/add_id", {user_id = user_id})
end)

RegisterNetEvent("OASIS:enterDiamondCasino")
AddEventHandler("OASIS:enterDiamondCasino", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    tOASIS.setBucket(source, 777)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('OASIS:setDisplayChips', source, rows[1].chips)
            return
        end
    end)
end)

RegisterNetEvent("OASIS:exitDiamondCasino")
AddEventHandler("OASIS:exitDiamondCasino", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    tOASIS.setBucket(source, 0)
end)

RegisterNetEvent("OASIS:getChips")
AddEventHandler("OASIS:getChips", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('OASIS:setDisplayChips', source, rows[1].chips)
            return
        end
    end)
end)

RegisterNetEvent("OASIS:buyChips")
AddEventHandler("OASIS:buyChips", function(amount)
    local source = source
    local user_id = OASIS.getUserId(source)
    if not amount then amount = OASIS.getMoney(user_id) end
    if OASIS.tryPayment(user_id, amount) then
        MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
        TriggerClientEvent('OASIS:chipsUpdated', source)
        tOASIS.sendWebhook('purchase-chips',"OASIS Chip Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(amount).."**")
        return
    else
        OASISclient.notify(source,{"~r~You don't have enough money."})
        return
    end
end)

local sellingChips = {}
RegisterNetEvent("OASIS:sellChips")
AddEventHandler("OASIS:sellChips", function(amount)
    local source = source
    local user_id = OASIS.getUserId(source)
    local chips = nil
    if not sellingChips[source] then
        sellingChips[source] = true
        MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                if not amount then amount = chips end
                if amount > 0 and chips > 0 and chips >= amount then
                    MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = amount})
                    TriggerClientEvent('OASIS:chipsUpdated', source)
                    tOASIS.sendWebhook('sell-chips',"OASIS Chip Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(amount).."**")
                    OASIS.giveMoney(user_id, amount)
                else
                    OASISclient.notify(source,{"~r~You don't have enough chips."})
                end
                sellingChips[source] = nil
            end
        end)
    end
end)