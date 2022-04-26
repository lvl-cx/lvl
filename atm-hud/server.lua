local Tunnel = module("atm", "lib/Tunnel")
local Proxy = module("atm", "lib/Proxy")

ATM = Proxy.getInterface("ATM")
ATMclient = Tunnel.getInterface("ATM","ATM_fuel")

RegisterServerEvent('update:bank')
AddEventHandler('update:bank', function()
    local user_id = ATM.getUserId({source})
    local bank = ATM.getBankMoney({user_id})
    TriggerClientEvent('bank:setDisplayBankMoney', source, bank)
end)

RegisterServerEvent('update:cash')
AddEventHandler('update:cash', function()
    local user_id = ATM.getUserId({source})
    local wallet = ATM.getMoney({user_id})
    TriggerClientEvent('cash:setDisplayMoney', source, wallet)
end)