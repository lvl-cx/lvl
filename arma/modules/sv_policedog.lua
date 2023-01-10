RegisterCommand('k9', function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('ARMA:policeDogMenu', source)
    end
end)

RegisterCommand('k9attack', function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('ARMA:policeDogAttack', source)
    end
end)

RegisterNetEvent("ARMA:serverDogAttack")
AddEventHandler("ARMA:serverDogAttack", function(player)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('ARMA:sendClientRagdoll', player)
    end
end)

RegisterNetEvent("ARMA:policeDogSniffPlayer")
AddEventHandler("ARMA:policeDogSniffPlayer", function(playerSrc)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'K9 Trained') then
       -- check for drugs
        local player_id = ARMA.getUserId(playerSrc)
        local cdata = ARMA.getUserDataTable(player_id)
        for a,b in pairs(cdata.inventory) do
            for c,d in pairs(seizeDrugs) do
                if a == c then
                    TriggerClientEvent('ARMA:policeDogIndicate', source, playerSrc)
                end
            end
        end
    end
end)