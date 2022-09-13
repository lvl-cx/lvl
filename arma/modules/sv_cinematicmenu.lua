RegisterCommand('cinematicmenu', function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'Cinematic') then
        TriggerClientEvent('ARMA:openCinematicMenu', source)
    end
end)