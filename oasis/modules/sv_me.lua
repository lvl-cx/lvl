RegisterCommand("me", function(source, args)
    local text = table.concat(args, " ")
    TriggerClientEvent('OASIS:sendLocalChat', -1, source, GetPlayerName(source), text)
end)