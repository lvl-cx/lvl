RegisterNetEvent("ARMA:flashbangThrown")
AddEventHandler("ARMA:flashbangThrown", function(coords)   
    TriggerClientEvent("ARMA:flashbangExplode", -1, coords)
end)