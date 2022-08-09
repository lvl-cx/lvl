RegisterServerEvent("ARMA:getUserinformation")
AddEventHandler("ARMA:getUserinformation",function(id)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.moneymenu') then
        TriggerClientEvent('ARMA:receivedUserInformation', source, ARMA.getUserSource(id), GetPlayerName(ARMA.getUserSource(id)), ARMA.getBankMoney(id), ARMA.getMoney(id), '10')
    end
end)

RegisterServerEvent("ARMA:AddPlayerBank")
AddEventHandler("ARMA:AddPlayerBank",function(id, amount, cashtype)
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
        TriggerClientEvent('ARMA:receivedUserInformation', source, ARMA.getUserSource(id), GetPlayerName(ARMA.getUserSource(id)), ARMA.getBankMoney(id), ARMA.getMoney(id), '10')
    end
end)