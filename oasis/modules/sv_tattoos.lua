RegisterServerEvent('OASIS:saveTattoos')
AddEventHandler('OASIS:saveTattoos', function(tattooData, price)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.tryFullPayment(user_id, price) then
        OASIS.setUData(user_id, "OASIS:Tattoo:Data", json.encode(tattooData))
    end
end)

RegisterServerEvent('OASIS:getPlayerTattoos')
AddEventHandler('OASIS:getPlayerTattoos', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    OASIS.getUData(user_id, "OASIS:Tattoo:Data", function(data)
        if data ~= nil then
            TriggerClientEvent('OASIS:setTattoos', source, json.decode(data))
        end
    end)
end)
