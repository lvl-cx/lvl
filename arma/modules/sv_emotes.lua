RegisterNetEvent('ARMA:sendSharedEmoteRequest')
AddEventHandler('ARMA:sendSharedEmoteRequest', function(playersrc, emote)
    local source = source
    TriggerClientEvent('ARMA:sendSharedEmoteRequest', playersrc, source, emote)
end)

RegisterNetEvent('ARMA:receiveSharedEmoteRequest')
AddEventHandler('ARMA:receiveSharedEmoteRequest', function(i, a)
    local source = source
    TriggerClientEvent('ARMA:receiveSharedEmoteRequestSource', i)
    TriggerClientEvent('ARMA:receiveSharedEmoteRequest', source, a)
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

AddEventHandler("ARMA:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = ARMA.getUserId(source)
        if first_spawn and shavedPlayers[user_id] then
            TriggerClientEvent('ARMA:setAsShaved', source, (shavedPlayers[user_id].cooldown*60*1000))
        end
    end)
end)

function ARMA.ShaveHead(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Shaver') >= 1 then
        ARMAclient.getNearestPlayer(source,{4},function(nplayer)
            if nplayer then
                ARMAclient.globalSurrenderring(nplayer,{},function(surrendering)
                    if surrendering then
                        ARMA.tryGetInventoryItem(user_id, 'Shaver', 1)
                        TriggerClientEvent('ARMA:startShavingPlayer', source, nplayer)
                        TriggerClientEvent('ARMA:startBeingShaved', nplayer, source)
                        TriggerClientEvent('ARMA:playDelayedShave', -1, source)
                        shavedPlayers[ARMA.getUserId(nplayer)] = {
                            cooldown = 30,
                        }
                    else
                        ARMAclient.notify(source,{'~r~This player is not on their knees.'})
                    end
                end)
            else
                ARMAclient.notify(source, {"~r~No one nearby."})
            end
        end)
    end
end
