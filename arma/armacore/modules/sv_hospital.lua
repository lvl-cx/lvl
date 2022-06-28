RegisterNetEvent('ARMA:reviveRadial')
AddEventHandler('ARMA:reviveRadial', function()
    local player = source
    ARMAclient.getNearestPlayer(player,{4},function(nplayer)
        TriggerClientEvent('ARMA:cprAnim', player, nplayer)
    end)
end)

RegisterNetEvent("ARMA:SendFixClient")
AddEventHandler("ARMA:SendFixClient", function(player)
    TriggerClientEvent("ARMA:FixClient", player)
end)