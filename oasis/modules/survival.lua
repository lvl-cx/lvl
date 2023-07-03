local cfg = module("cfg/survival")
local lang = OASIS.lang


-- handlers

-- init values
AddEventHandler("OASIS:playerJoin", function(user_id, source, name, last_login)
    local data = OASIS.getUserDataTable(user_id)
end)


---- revive
local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

local choice_revive = {function(player, choice)
    local user_id = OASIS.getUserId(player)
    if user_id ~= nil then
        OASISclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = OASIS.getUserId(nplayer)
            if nuser_id ~= nil then
                OASISclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        if OASIS.tryGetInventoryItem(user_id, "medkit", 1, true) then
                            OASISclient.playAnim(player, {false, revive_seq, false}) -- anim
                            SetTimeout(15000, function()
                                OASISclient.varyHealth(nplayer, {50}) -- heal 50
                            end)
                        end
                    else
                        OASISclient.notify(player, {lang.emergency.menu.revive.not_in_coma()})
                    end
                end)
            else
                OASISclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, lang.emergency.menu.revive.description()}

RegisterNetEvent('OASIS:SearchForPlayer')
AddEventHandler('OASIS:SearchForPlayer', function()
    TriggerClientEvent('OASIS:ReceiveSearch', -1, source)
end)


