RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price)
    local user_id = ARMA.getUserId(source)
    local fuelAmount = math.floor(price)
    if ARMA.tryFullPayment(user_id ,fuelAmount) then
    end
end)