RegisterServerEvent('ARMA:saveTattoos')
AddEventHandler('ARMA:saveTattoos', function(tattooData, price)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.tryFullPayment(user_id, price) then
        ARMA.setUData(user_id, "ARMA:Tattoo:Data", json.encode(tattooData))
    end
end)

RegisterServerEvent('ARMA:getPlayerTattoos')
AddEventHandler('ARMA:getPlayerTattoos', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMA.getUData(user_id, "ARMA:Tattoo:Data", function(data)
        if data ~= nil then
            TriggerClientEvent('ARMA:setTattoos', source, json.decode(data))
        end
    end)
end)
