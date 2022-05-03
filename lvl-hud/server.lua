local Tunnel = module("lvl", "lib/Tunnel")
local Proxy = module("lvl", "lib/Proxy")

LVL = Proxy.getInterface("LVL")
LVLclient = Tunnel.getInterface("LVL","LVL_fuel")

RegisterServerEvent('update:bank')
AddEventHandler('update:bank', function()
    local user_id = LVL.getUserId({source})
    local bank = LVL.getBankMoney({user_id})
    TriggerClientEvent('bank:setDisplayBankMoney', source, bank)
end)

RegisterServerEvent('update:cash')
AddEventHandler('update:cash', function()
    local user_id = LVL.getUserId({source})
    local wallet = LVL.getMoney({user_id})
    TriggerClientEvent('cash:setDisplayMoney', source, wallet)
end)