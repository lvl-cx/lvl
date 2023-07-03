RegisterNetEvent('OASIS:sendSharedEmoteRequest')
AddEventHandler('OASIS:sendSharedEmoteRequest', function(playersrc, emote)
    local source = source
    TriggerClientEvent('OASIS:sendSharedEmoteRequest', playersrc, source, emote)
end)

RegisterNetEvent('OASIS:receiveSharedEmoteRequest')
AddEventHandler('OASIS:receiveSharedEmoteRequest', function(i, a)
    local source = source
    TriggerClientEvent('OASIS:receiveSharedEmoteRequestSource', i)
    TriggerClientEvent('OASIS:receiveSharedEmoteRequest', source, a)
end)

local shavedPlayers = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(shavedPlayers) do
            if shavedPlayers[k] then
                if shavedPlayers[k].cooldown > 0 then
                    shavedPlayers[k].cooldown = shavedPlayers[k].cooldown - 1
                else
                    shavedPlayers[k] = nil
                end
            end
        end
    end
end)

AddEventHandler("OASIS:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = OASIS.getUserId(source)
        if first_spawn and shavedPlayers[user_id] then
            TriggerClientEvent('OASIS:setAsShaved', source, (shavedPlayers[user_id].cooldown*60*1000))
        end
    end)
end)

function OASIS.ShaveHead(source)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.getInventoryItemAmount(user_id, 'Shaver') >= 1 then
        OASISclient.getNearestPlayer(source,{4},function(nplayer)
            if nplayer then
                OASISclient.globalSurrenderring(nplayer,{},function(surrendering)
                    if surrendering then
                        OASIS.tryGetInventoryItem(user_id, 'Shaver', 1)
                        TriggerClientEvent('OASIS:startShavingPlayer', source, nplayer)
                        TriggerClientEvent('OASIS:startBeingShaved', nplayer, source)
                        TriggerClientEvent('OASIS:playDelayedShave', -1, source)
                        shavedPlayers[OASIS.getUserId(nplayer)] = {
                            cooldown = 30,
                        }
                    else
                        OASISclient.notify(source,{'~r~This player is not on their knees.'})
                    end
                end)
            else
                OASISclient.notify(source, {"~r~No one nearby."})
            end
        end)
    end
end
