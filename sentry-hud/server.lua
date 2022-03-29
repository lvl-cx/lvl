local Tunnel = module("sentry", "lib/Tunnel")
local Proxy = module("sentry", "lib/Proxy")

Sentry = Proxy.getInterface("Sentry")
Sentryclient = Tunnel.getInterface("Sentry","Sentry_fuel")

RegisterServerEvent('update:bank')
AddEventHandler('update:bank', function()
    local user_id = Sentry.getUserId({source})
    local bank = Sentry.getBankMoney({user_id})
    TriggerClientEvent('bank:setDisplayBankMoney', source, bank)
end)

RegisterServerEvent('update:cash')
AddEventHandler('update:cash', function()
    local user_id = Sentry.getUserId({source})
    local wallet = Sentry.getMoney({user_id})
    TriggerClientEvent('cash:setDisplayMoney', source, wallet)
end)