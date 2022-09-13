local weatherVotes = {}


-- cba doing a weather vote system, there's some public one ill put that shit in here later

RegisterNetEvent('ARMA:vote')
AddEventHandler('ARMA:vote', function(weathertype)
    local source = source
    local user_id = ARMA.getUserId(source)
    if weatherVotes[user_id] == nil then
        weatherVotes[user_id] = weathertype
        TriggerClientEvent('chat:addMessage', -1, { args = { '^1[ARMA] ^0' .. GetPlayerName(source) .. ' voted for ' .. weathertype } })
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '^1[ARMA] ^0You have already voted for ' .. weatherVotes[user_id] } })
    end
end)