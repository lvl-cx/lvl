local cfg = module("cfg/survival")
local lang = ATM.lang

-- api

function ATM.getHunger(user_id)
    local data = ATM.getUserDataTable(user_id)
    if data then
        return data.hunger
    end

    return 0
end

function ATM.getThirst(user_id)
    local data = ATM.getUserDataTable(user_id)
    if data then
        return data.thirst
    end

    return 0
end

function ATM.setHunger(user_id, value)
    local data = ATM.getUserDataTable(user_id)
    if data then
        data.hunger = value
        if data.hunger < 0 then
            data.hunger = 0
        elseif data.hunger > 100 then
            data.hunger = 100
        end

        -- update bar
        local source = ATM.getUserSource(user_id)
        ATMclient.setProgressBarValue(source, {"ATM:hunger", data.hunger})
        if data.hunger >= 100 then
            ATMclient.setProgressBarText(source, {"ATM:hunger", lang.survival.starving()})
        else
            ATMclient.setProgressBarText(source, {"ATM:hunger", ""})
        end
    end
end

function ATM.setThirst(user_id, value)
    local data = ATM.getUserDataTable(user_id)
    if data then
        data.thirst = value
        if data.thirst < 0 then
            data.thirst = 0
        elseif data.thirst > 100 then
            data.thirst = 100
        end

        -- update bar
        local source = ATM.getUserSource(user_id)
        ATMclient.setProgressBarValue(source, {"ATM:thirst", data.thirst})
        if data.thirst >= 100 then
            ATMclient.setProgressBarText(source, {"ATM:thirst", lang.survival.thirsty()})
        else
            ATMclient.setProgressBarText(source, {"ATM:thirst", ""})
        end
    end
end

function ATM.varyHunger(user_id, variation)

end

function ATM.varyThirst(user_id, variation)

end

-- tunnel api (expose some functions to clients)

function tATM.varyHunger(variation)

end

function tATM.varyThirst(variation)

end

-- tasks

-- hunger/thirst increase
function task_update()
    for k, v in pairs(ATM.users) do
        ATM.varyHunger(v, cfg.hunger_per_minute)
        ATM.varyThirst(v, cfg.thirst_per_minute)
    end

    SetTimeout(60000, task_update)
end


-- handlers

-- init values
AddEventHandler("ATM:playerJoin", function(user_id, source, name, last_login)
    local data = ATM.getUserDataTable(user_id)
    if data.hunger == nil then
        data.hunger = 0
        data.thirst = 0
    end
end)


---- revive
local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

local choice_revive = {function(player, choice)
    local user_id = ATM.getUserId(player)
    if user_id ~= nil then
        ATMclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = ATM.getUserId(nplayer)
            if nuser_id ~= nil then
                ATMclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        if ATM.tryGetInventoryItem(user_id, "medkit", 1, true) then
                            ATMclient.playAnim(player, {false, revive_seq, false}) -- anim
                            SetTimeout(15000, function()
                                ATMclient.varyHealth(nplayer, {50}) -- heal 50
                            end)
                        end
                    else
                        ATMclient.notify(player, {lang.emergency.menu.revive.not_in_coma()})
                    end
                end)
            else
                ATMclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, lang.emergency.menu.revive.description()}

RegisterNetEvent('ATM:SearchForPlayer')
AddEventHandler('ATM:SearchForPlayer', function()
    TriggerClientEvent('ATM:ReceiveSearch', -1, source)
end)

RegisterNetEvent('TeleportThem')
AddEventHandler('TeleportThem', function(one, two)
    Wait(500)
    ATMclient.teleport(one, {-934.38214111328,-782.61444091797,15.921166419983})
    ATMclient.notify(one, {'Number One'})
    ATMclient.teleport(two, {-948.12878417969,-801.18139648438,15.921133995056})
    ATMclient.notify(two, {'Number Two'})
end)



