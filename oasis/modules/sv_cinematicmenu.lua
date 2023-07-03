RegisterCommand('cinematicmenu', function(source)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasGroup(user_id, 'Cinematic') then
        TriggerClientEvent('OASIS:openCinematicMenu', source)
    end
end)