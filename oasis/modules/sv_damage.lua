RegisterNetEvent("OASIS:syncEntityDamage")
AddEventHandler("OASIS:syncEntityDamage",function(u, v, t, s, m, n)
    local source=source
    local user_id=OASIS.getUserId(source)
    TriggerClientEvent('OASIS:onEntityHealthChange', t, GetPlayerPed(source), u, v, s)
end)