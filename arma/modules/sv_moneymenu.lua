MySQL.createCommand("casinochips/add_chips", "UPDATE arma_casino_chips SET chips = (chips + @amount) WHERE user_id = @user_id")
MySQL.createCommand("casinochips/remove_chips", "UPDATE arma_casino_chips SET chips = (chips - @amount) WHERE user_id = @user_id")


RegisterServerEvent("ARMA:getUserinformation")
AddEventHandler("ARMA:getUserinformation",function(id)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.moneymenu') then
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('ARMA:receivedUserInformation', source, ARMA.getUserSource(id), GetPlayerName(ARMA.getUserSource(id)), ARMA.getBankMoney(id), ARMA.getMoney(id), chips)
            end
        end)
    end
end)

RegisterServerEvent("ARMA:ManagePlayerBank")
AddEventHandler("ARMA:ManagePlayerBank",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = ARMA.getUserId(source)
    local userstemp = ARMA.getUserSource(id)
    if ARMA.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            ARMA.giveBankMoney(id, amount)
        elseif cashtype == 'Decrease' then
            ARMA.tryBankPayment(id, amount)
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('ARMA:receivedUserInformation', source, ARMA.getUserSource(id), GetPlayerName(ARMA.getUserSource(id)), ARMA.getBankMoney(id), ARMA.getMoney(id), chips)
            end
        end)
    end
end)

RegisterServerEvent("ARMA:ManagePlayerCash")
AddEventHandler("ARMA:ManagePlayerCash",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = ARMA.getUserId(source)
    local userstemp = ARMA.getUserSource(id)
    if ARMA.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            ARMA.giveMoney(id, amount)
        elseif cashtype == 'Decrease' then
            ARMA.tryPayment(id, amount)
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('ARMA:receivedUserInformation', source, ARMA.getUserSource(id), GetPlayerName(ARMA.getUserSource(id)), ARMA.getBankMoney(id), ARMA.getMoney(id), chips)
            end
        end)
    end
end)

RegisterServerEvent("ARMA:ManagePlayerChips")
AddEventHandler("ARMA:ManagePlayerChips",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = ARMA.getUserId(source)
    local userstemp = ARMA.getUserSource(id)
    if ARMA.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            MySQL.execute("casinochips/add_chips", {user_id = id, amount = amount})
        elseif cashtype == 'Decrease' then
            MySQL.execute("casinochips/remove_chips", {user_id = id, amount = amount})
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('ARMA:receivedUserInformation', source, ARMA.getUserSource(id), GetPlayerName(ARMA.getUserSource(id)), ARMA.getBankMoney(id), ARMA.getMoney(id), chips)
            end
        end)
    end
end)