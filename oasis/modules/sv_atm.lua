local lang = OASIS.lang
RegisterNetEvent('OASIS:Withdraw')
AddEventHandler('OASIS:Withdraw', function(amount)
    local source = source
    local amount = parseInt(amount)
    if amount > 0 then
        local user_id = OASIS.getUserId(source)
        if user_id ~= nil then
            if OASIS.tryWithdraw(user_id, amount) then
                OASISclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
            else
                OASISclient.notify(source, {lang.atm.withdraw.not_enough()})
            end
        end
    else
        OASISclient.notify(source, {lang.common.invalid_value()})
    end
end)


RegisterNetEvent('OASIS:Deposit')
AddEventHandler('OASIS:Deposit', function(amount)
    local source = source
    local amount = parseInt(amount)
    if amount > 0 then
        local user_id = OASIS.getUserId(source)
        if user_id ~= nil then
            if OASIS.tryDeposit(user_id, amount) then
                OASISclient.notify(source, {lang.atm.deposit.deposited({amount})})
            else
                OASISclient.notify(source, {lang.money.not_enough()})
            end
        end
    else
        OASISclient.notify(source, {lang.common.invalid_value()})
    end
end)

RegisterNetEvent('OASIS:WithdrawAll')
AddEventHandler('OASIS:WithdrawAll', function()
    local source = source
    local amount = OASIS.getBankMoney(OASIS.getUserId(source))
    if amount > 0 then
        local user_id = OASIS.getUserId(source)
        if user_id ~= nil then
            if OASIS.tryWithdraw(user_id, amount) then
                OASISclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
            else
                OASISclient.notify(source, {lang.atm.withdraw.not_enough()})
            end
        end
    else
        OASISclient.notify(source, {lang.common.invalid_value()})
    end
end)


RegisterNetEvent('OASIS:DepositAll')
AddEventHandler('OASIS:DepositAll', function()
    local source = source
    local amount = OASIS.getMoney(OASIS.getUserId(source))
    if amount > 0 then
        local user_id = OASIS.getUserId(source)
        if user_id ~= nil then
            if OASIS.tryDeposit(user_id, amount) then
                OASISclient.notify(source, {lang.atm.deposit.deposited({amount})})
            else
                OASISclient.notify(source, {lang.money.not_enough()})
            end
        end
    else
        OASISclient.notify(source, {lang.common.invalid_value()})
    end
end)