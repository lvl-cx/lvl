RegisterServerEvent("OASIS:getUserinformation")
AddEventHandler("OASIS:getUserinformation",function(id)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'admin.moneymenu') then
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('OASIS:receivedUserInformation', source, OASIS.getUserSource(id), GetPlayerName(OASIS.getUserSource(id)), math.floor(OASIS.getBankMoney(id)), math.floor(OASIS.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("OASIS:ManagePlayerBank")
AddEventHandler("OASIS:ManagePlayerBank",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = OASIS.getUserId(source)
    local userstemp = OASIS.getUserSource(id)
    if OASIS.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            OASIS.giveBankMoney(id, amount)
            OASISclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Bank Balance.'})
            tOASIS.sendWebhook('manage-balance',"OASIS Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Bank**\n> Type: **"..cashtype.."**")
        elseif cashtype == 'Decrease' then
            OASIS.tryBankPayment(id, amount)
            OASISclient.notify(source, {'~r~Removed £'..getMoneyStringFormatted(amount)..' from players Bank Balance.'})
            tOASIS.sendWebhook('manage-balance',"OASIS Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Bank**\n> Type: **"..cashtype.."**")
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('OASIS:receivedUserInformation', source, OASIS.getUserSource(id), GetPlayerName(OASIS.getUserSource(id)), math.floor(OASIS.getBankMoney(id)), math.floor(OASIS.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("OASIS:ManagePlayerCash")
AddEventHandler("OASIS:ManagePlayerCash",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = OASIS.getUserId(source)
    local userstemp = OASIS.getUserSource(id)
    if OASIS.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            OASIS.giveMoney(id, amount)
            OASISclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Cash Balance.'})
            tOASIS.sendWebhook('manage-balance',"OASIS Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Cash**\n> Type: **"..cashtype.."**")
        elseif cashtype == 'Decrease' then
            OASIS.tryPayment(id, amount)
            OASISclient.notify(source, {'~r~Removed £'..getMoneyStringFormatted(amount)..' from players Cash Balance.'})
            tOASIS.sendWebhook('manage-balance',"OASIS Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Cash**\n> Type: **"..cashtype.."**")
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('OASIS:receivedUserInformation', source, OASIS.getUserSource(id), GetPlayerName(OASIS.getUserSource(id)), math.floor(OASIS.getBankMoney(id)), math.floor(OASIS.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("OASIS:ManagePlayerChips")
AddEventHandler("OASIS:ManagePlayerChips",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = OASIS.getUserId(source)
    local userstemp = OASIS.getUserSource(id)
    if OASIS.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            MySQL.execute("casinochips/add_chips", {user_id = id, amount = amount})
            OASISclient.notify(source, {'~g~Added '..getMoneyStringFormatted(amount)..' to players Casino Chips.'})
            tOASIS.sendWebhook('manage-balance',"OASIS Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **"..amount.." Chips**\n> Type: **"..cashtype.."**")
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('OASIS:receivedUserInformation', source, OASIS.getUserSource(id), GetPlayerName(OASIS.getUserSource(id)), math.floor(OASIS.getBankMoney(id)), math.floor(OASIS.getMoney(id)), chips)
                end
            end)
        elseif cashtype == 'Decrease' then
            MySQL.execute("casinochips/remove_chips", {user_id = id, amount = amount})
            OASISclient.notify(source, {'~r~Removed '..getMoneyStringFormatted(amount)..' from players Casino Chips.'})
            tOASIS.sendWebhook('manage-balance',"OASIS Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **"..amount.." Chips**\n> Type: **"..cashtype.."**")
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('OASIS:receivedUserInformation', source, OASIS.getUserSource(id), GetPlayerName(OASIS.getUserSource(id)), math.floor(OASIS.getBankMoney(id)), math.floor(OASIS.getMoney(id)), chips)
                end
            end)
        end
    end
end)