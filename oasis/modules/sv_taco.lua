local tacoDrivers = {}

RegisterNetEvent('OASIS:addTacoSeller')
AddEventHandler('OASIS:addTacoSeller', function(coords, price)
    local source = source
    local user_id = OASIS.getUserId(source)
    tacoDrivers[user_id] = {position = coords, amount = price}
    TriggerClientEvent('OASIS:sendClientTacoData', -1, tacoDrivers)
end)

RegisterNetEvent('OASIS:RemoveMeFromTacoPositions')
AddEventHandler('OASIS:RemoveMeFromTacoPositions', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    tacoDrivers[user_id] = nil
    TriggerClientEvent('OASIS:removeTacoSeller', -1, user_id)
end)

RegisterNetEvent('OASIS:payTacoSeller')
AddEventHandler('OASIS:payTacoSeller', function(id)
    local source = source
    local user_id = OASIS.getUserId(source)
    if tacoDrivers[id] then
        if OASIS.getInventoryWeight(user_id)+1 <= OASIS.getInventoryMaxWeight(user_id) then
            if OASIS.tryFullPayment(user_id,15000) then
                OASIS.giveInventoryItem(user_id, 'Taco', 1)
                OASIS.giveBankMoney(id, 15000)
                TriggerClientEvent("oasis:PlaySound", source, "money")
            else
                OASISclient.notify(source, {'~r~You do not have enough money.'})
            end
        else
            OASISclient.notify(source, {'~r~Not enough inventory space.'})
        end
    end
end)