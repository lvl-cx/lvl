local currentEvents = {}
local currentEvent = {
    players = {},
    isActive = false,
    data = {},
    eventId = 0,
    eventName = "",
    drawPlayersTimeBar = true,
    musicString = "",
    playMusic = false
}

RegisterServerEvent('ARMA:requestIsAnyEventActive')
AddEventHandler('ARMA:requestIsAnyEventActive', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(currentEvents) do
        if v.isActive then
            TriggerClientEvent('ARMA:setIsAnyEventActive', source, true)
        end
    end
end)

RegisterCommand('joinevent', function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(currentEvents) do
        for a,b in pairs(v.players) do
            if a == source then
                return
            end
        end
        TriggerClientEvent('ARMA:addEventPlayer', -1, source)
        -- add player to event on server side, done client side
        -- also add to event bucket
    end
end)

RegisterCommand('leaveevent', function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(currentEvents) do
        for a,b in pairs(v.players) do
            if a == source then
                -- remove player from event
                -- also remove from event bucket
            end
        end
    end
end)

RegisterServerEvent('ARMA:kickPlayerFromEvent')
AddEventHandler('ARMA:kickPlayerFromEvent', function(player, eventId)
    local source = source
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(currentEvents) do
        if v.eventId == eventId then
            -- remove player from event using player variable
            TriggerClientEvent('ARMA:removeEventPlayer', -1, player)
        end
    end
end)

-- when event ends use ARMA:eventCleanup to -1 source

-- when event starts, ARMA:announceEventJoinable params: event type, max players