local lang = ARMA.lang
RegisterNetEvent('ARMA:Withdraw')
AddEventHandler('ARMA:Withdraw', function(amount)
    local source = source
    local amount = parseInt(amount)
    if amount > 0 then
        local user_id = ARMA.getUserId(source)
        if user_id ~= nil then
            if ARMA.tryWithdraw(user_id, amount) then
                ARMAclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
            else
                ARMAclient.notify(source, {lang.atm.withdraw.not_enough()})
            end
        end
    else
        ARMAclient.notify(source, {lang.common.invalid_value()})
    end
end)


RegisterNetEvent('ARMA:Deposit')
AddEventHandler('ARMA:Deposit', function(amount)
    local source = source
    local amount = parseInt(amount)
    if amount > 0 then
        local user_id = ARMA.getUserId(source)
        if user_id ~= nil then
            if ARMA.tryDeposit(user_id, amount) then
                ARMAclient.notify(source, {lang.atm.deposit.deposited({amount})})
            else
                ARMAclient.notify(source, {lang.money.not_enough()})
            end
        end
    else
        ARMAclient.notify(source, {lang.common.invalid_value()})
    end
end)

RegisterNetEvent('ARMA:WithdrawAll')
AddEventHandler('ARMA:WithdrawAll', function()
    local source = source
    local amount = ARMA.getBankMoney(ARMA.getUserId(source))
    if amount > 0 then
        local user_id = ARMA.getUserId(source)
        if user_id ~= nil then
            if ARMA.tryWithdraw(user_id, amount) then
                ARMAclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
            else
                ARMAclient.notify(source, {lang.atm.withdraw.not_enough()})
            end
        end
    else
        ARMAclient.notify(source, {lang.common.invalid_value()})
    end
end)


RegisterNetEvent('ARMA:DepositAll')
AddEventHandler('ARMA:DepositAll', function()
    local source = source
    local amount = ARMA.getMoney(ARMA.getUserId(source))
    if amount > 0 then
        local user_id = ARMA.getUserId(source)
        if user_id ~= nil then
            if ARMA.tryDeposit(user_id, amount) then
                ARMAclient.notify(source, {lang.atm.deposit.deposited({amount})})
            else
                ARMAclient.notify(source, {lang.money.not_enough()})
            end
        end
    else
        ARMAclient.notify(source, {lang.common.invalid_value()})
    end
end)