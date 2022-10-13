local tutorialBucket = 10
RegisterNetEvent('ARMA:checkTutorial')
AddEventHandler('ARMA:checkTutorial', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if not ARMA.hasGroup(user_id, 'TutorialDone') then
        tutorialBucket = tutorialBucket + 1
        TriggerClientEvent('ARMA:startTutorial', source)
        SetPlayerRoutingBucket(source, tutorialBucket)
    end
end)

RegisterNetEvent('ARMA:setCompletedTutorial')
AddEventHandler('ARMA:setCompletedTutorial', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if not ARMA.hasGroup(user_id, 'TutorialDone') then
        ARMA.addUserGroup(user_id, 'TutorialDone')
        SetPlayerRoutingBucket(source, 0)
    end
end)