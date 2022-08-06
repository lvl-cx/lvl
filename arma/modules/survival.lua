local cfg = module("cfg/survival")
local lang = ARMA.lang


-- handlers

-- init values
AddEventHandler("ARMA:playerJoin", function(user_id, source, name, last_login)
    local data = ARMA.getUserDataTable(user_id)
end)


---- revive
local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

local choice_revive = {function(player, choice)
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil then
        ARMAclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = ARMA.getUserId(nplayer)
            if nuser_id ~= nil then
                ARMAclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        if ARMA.tryGetInventoryItem(user_id, "medkit", 1, true) then
                            ARMAclient.playAnim(player, {false, revive_seq, false}) -- anim
                            SetTimeout(15000, function()
                                ARMAclient.varyHealth(nplayer, {50}) -- heal 50
                            end)
                        end
                    else
                        ARMAclient.notify(player, {lang.emergency.menu.revive.not_in_coma()})
                    end
                end)
            else
                ARMAclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, lang.emergency.menu.revive.description()}

RegisterNetEvent('ARMA:SearchForPlayer')
AddEventHandler('ARMA:SearchForPlayer', function()
    TriggerClientEvent('ARMA:ReceiveSearch', -1, source)
end)


