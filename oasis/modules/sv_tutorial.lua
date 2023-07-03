RegisterNetEvent('OASIS:checkTutorial')
AddEventHandler('OASIS:checkTutorial', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if not OASIS.hasGroup(user_id, 'TutorialDone') then
        TriggerClientEvent('OASIS:playTutorial', source)
        tOASIS.setBucket(source, user_id)
        TriggerClientEvent('OASIS:setBucket', source, user_id)
    end
end)

RegisterNetEvent('OASIS:setCompletedTutorial')
AddEventHandler('OASIS:setCompletedTutorial', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if not OASIS.hasGroup(user_id, 'TutorialDone') then
        OASIS.addUserGroup(user_id, 'TutorialDone')
        tOASIS.setBucket(source, 0)
        TriggerClientEvent('OASIS:setBucket', source, 0)
    end
end)