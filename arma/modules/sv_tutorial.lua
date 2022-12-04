RegisterNetEvent('ARMA:checkTutorial')
AddEventHandler('ARMA:checkTutorial', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if not ARMA.hasGroup(user_id, 'TutorialDone') then
        TriggerClientEvent('ARMA:startTutorial', source)
        SetPlayerRoutingBucket(source, user_id)
        TriggerClientEvent('ARMA:setBucket', source, user_id)
    end
end)

RegisterNetEvent('ARMA:setCompletedTutorial')
AddEventHandler('ARMA:setCompletedTutorial', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if not ARMA.hasGroup(user_id, 'TutorialDone') then
        ARMA.addUserGroup(user_id, 'TutorialDone')
        SetPlayerRoutingBucket(source, 0)
        TriggerClientEvent('ARMA:setBucket', source, 0)
    end
end)