local tacoDrivers = {}

RegisterNetEvent('ARMA:addTacoSeller')
AddEventHandler('ARMA:addTacoSeller', function(coords, price)
    local source = source
    local user_id = ARMA.getUserId(source)
    tacoDrivers[user_id] = {position = coords, amount = price}
    TriggerClientEvent('ARMA:sendClientTacoData', -1, tacoDrivers)
end)

RegisterNetEvent('ARMA:RemoveMeFromTacoPositions')
AddEventHandler('ARMA:RemoveMeFromTacoPositions', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    tacoDrivers[user_id] = nil
    TriggerClientEvent('ARMA:removeTacoSeller', -1, user_id)
end)

RegisterNetEvent('ARMA:payTacoSeller')
AddEventHandler('ARMA:payTacoSeller', function(id)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.tryFullPayment(user_id,15000) then
        ARMA.giveInventoryItem(user_id, 'taco', 1)
        ARMA.giveBankMoney(id, 15000)
        TriggerClientEvent("arma:PlaySound", source, "money")
    else
        ARMAclient.notify(source, {'~r~You do not have enough money.'})
    end
end)