RegisterCommand('k9', function(source)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('OASIS:policeDogMenu', source)
    end
end)

RegisterCommand('k9attack', function(source)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('OASIS:policeDogAttack', source)
    end
end)

RegisterNetEvent("OASIS:serverDogAttack")
AddEventHandler("OASIS:serverDogAttack", function(player)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('OASIS:sendClientRagdoll', player)
    end
end)

RegisterNetEvent("OASIS:policeDogSniffPlayer")
AddEventHandler("OASIS:policeDogSniffPlayer", function(playerSrc)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasGroup(user_id, 'K9 Trained') then
       -- check for drugs
        local player_id = OASIS.getUserId(playerSrc)
        local cdata = OASIS.getUserDataTable(player_id)
        for a,b in pairs(cdata.inventory) do
            for c,d in pairs(seizeDrugs) do
                if a == c then
                    TriggerClientEvent('OASIS:policeDogIndicate', source, playerSrc)
                end
            end
        end
    end
end)

RegisterNetEvent("OASIS:performDogLog")
AddEventHandler("OASIS:performDogLog", function(text)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasGroup(user_id, 'K9 Trained') then
        tOASIS.sendWebhook('police-k9', 'OASIS Police Dog Logs',"> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)