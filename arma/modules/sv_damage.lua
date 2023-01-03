RegisterNetEvent("ARMA:syncEntityDamage")
AddEventHandler("ARMA:syncEntityDamage",function(u, v, t, s, m, n)
    local source=source
    local user_id=ARMA.getUserId(source)
    TriggerClientEvent("ARMA:syncEntityDamage", t, GetPlayerPed(source), GetPlayerPed(t))
    if s then
        TriggerClientEvent('ARMA:onEntityHealthChange', t, GetPlayerPed(source), u, v, s)
    elseif not s then
        TriggerClientEvent('ARMA:onEntityHealthChange', t, GetPlayerPed(source), u, v)
    end
end)