RegisterServerEvent("ARMA:getUserinformation")
AddEventHandler("ARMA:getUserinformation",function(id)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.moneymenu') then
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('ARMA:receivedUserInformation', source, ARMA.getUserSource(id), GetPlayerName(ARMA.getUserSource(id)), math.floor(ARMA.getBankMoney(id)), math.floor(ARMA.getMoney(id)), chips)
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
            ARMAclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Bank Balance.'})
        elseif cashtype == 'Decrease' then
            ARMA.tryBankPayment(id, amount)
            ARMAclient.notify(source, {'~r~Removed £'..getMoneyStringFormatted(amount)..' from players Bank Balance.'})
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('ARMA:receivedUserInformation', source, ARMA.getUserSource(id), GetPlayerName(ARMA.getUserSource(id)), math.floor(ARMA.getBankMoney(id)), math.floor(ARMA.getMoney(id)), chips)
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
            ARMAclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Cash Balance.'})
        elseif cashtype == 'Decrease' then
            ARMA.tryPayment(id, amount)
            ARMAclient.notify(source, {'~r~Removed £'..getMoneyStringFormatted(amount)..' from players Cash Balance.'})
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('ARMA:receivedUserInformation', source, ARMA.getUserSource(id), GetPlayerName(ARMA.getUserSource(id)), math.floor(ARMA.getBankMoney(id)), math.floor(ARMA.getMoney(id)), chips)
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
            ARMAclient.notify(source, {'~g~Added '..getMoneyStringFormatted(amount)..' to players Casino Chips.'})
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('ARMA:receivedUserInformation', source, ARMA.getUserSource(id), GetPlayerName(ARMA.getUserSource(id)), math.floor(ARMA.getBankMoney(id)), math.floor(ARMA.getMoney(id)), chips)
                end
            end)
        elseif cashtype == 'Decrease' then
            MySQL.execute("casinochips/remove_chips", {user_id = id, amount = amount})
            ARMAclient.notify(source, {'~r~Removed '..getMoneyStringFormatted(amount)..' from players Casino Chips.'})
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('ARMA:receivedUserInformation', source, ARMA.getUserSource(id), GetPlayerName(ARMA.getUserSource(id)), math.floor(ARMA.getBankMoney(id)), math.floor(ARMA.getMoney(id)), chips)
                end
            end)
        end
    end
end)