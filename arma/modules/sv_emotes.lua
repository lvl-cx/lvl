RegisterNetEvent('ARMA:sendSharedEmoteRequest')
AddEventHandler('ARMA:sendSharedEmoteRequest', function(playersrc, emote)
    local source = source
    TriggerClientEvent('ARMA:sendSharedEmoteRequest', playersrc, source, emote)
end)

RegisterNetEvent('ARMA:receiveSharedEmoteRequest')
AddEventHandler('ARMA:receiveSharedEmoteRequest', function(i, a)
    local source = source
    TriggerClientEvent('ARMA:receiveSharedEmoteRequestSource', i)
    TriggerClientEvent('ARMA:receiveSharedEmoteRequest', source, a)
end)