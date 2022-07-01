RegisterNetEvent('ARMA:IDsAboveHead')
AddEventHandler('ARMA:IDsAboveHead', function(status)
    local status = status
    local user_id = ARMA.getUserId({source})
    if ARMA.hasPermission(user_id, 'admin.noclip') then
        TriggerClientEvent('ARMA:ChangeIDs', source, status)
    end
end)