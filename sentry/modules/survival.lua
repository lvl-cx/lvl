local cfg = module("cfg/survival")
local lang = Sentry.lang

-- api

function Sentry.getHunger(user_id)
    local data = Sentry.getUserDataTable(user_id)
    if data then
        return data.hunger
    end

    return 0
end

function Sentry.getThirst(user_id)
    local data = Sentry.getUserDataTable(user_id)
    if data then
        return data.thirst
    end

    return 0
end

function Sentry.setHunger(user_id, value)
    local data = Sentry.getUserDataTable(user_id)
    if data then
        data.hunger = value
        if data.hunger < 0 then
            data.hunger = 0
        elseif data.hunger > 100 then
            data.hunger = 100
        end

        -- update bar
        local source = Sentry.getUserSource(user_id)
        Sentryclient.setProgressBarValue(source, {"Sentry:hunger", data.hunger})
        if data.hunger >= 100 then
            Sentryclient.setProgressBarText(source, {"Sentry:hunger", lang.survival.starving()})
        else
            Sentryclient.setProgressBarText(source, {"Sentry:hunger", ""})
        end
    end
end

function Sentry.setThirst(user_id, value)
    local data = Sentry.getUserDataTable(user_id)
    if data then
        data.thirst = value
        if data.thirst < 0 then
            data.thirst = 0
        elseif data.thirst > 100 then
            data.thirst = 100
        end

        -- update bar
        local source = Sentry.getUserSource(user_id)
        Sentryclient.setProgressBarValue(source, {"Sentry:thirst", data.thirst})
        if data.thirst >= 100 then
            Sentryclient.setProgressBarText(source, {"Sentry:thirst", lang.survival.thirsty()})
        else
            Sentryclient.setProgressBarText(source, {"Sentry:thirst", ""})
        end
    end
end

function Sentry.varyHunger(user_id, variation)

end

function Sentry.varyThirst(user_id, variation)

end

-- tunnel api (expose some functions to clients)

function tSentry.varyHunger(variation)

end

function tSentry.varyThirst(variation)

end

-- tasks

-- hunger/thirst increase
function task_update()
    for k, v in pairs(Sentry.users) do
        Sentry.varyHunger(v, cfg.hunger_per_minute)
        Sentry.varyThirst(v, cfg.thirst_per_minute)
    end

    SetTimeout(60000, task_update)
end


-- handlers

-- init values
AddEventHandler("Sentry:playerJoin", function(user_id, source, name, last_login)
    local data = Sentry.getUserDataTable(user_id)
    if data.hunger == nil then
        data.hunger = 0
        data.thirst = 0
    end
end)


---- revive
local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

local choice_revive = {function(player, choice)
    local user_id = Sentry.getUserId(player)
    if user_id ~= nil then
        Sentryclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = Sentry.getUserId(nplayer)
            if nuser_id ~= nil then
                Sentryclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        if Sentry.tryGetInventoryItem(user_id, "medkit", 1, true) then
                            Sentryclient.playAnim(player, {false, revive_seq, false}) -- anim
                            SetTimeout(15000, function()
                                Sentryclient.varyHealth(nplayer, {50}) -- heal 50
                            end)
                        end
                    else
                        Sentryclient.notify(player, {lang.emergency.menu.revive.not_in_coma()})
                    end
                end)
            else
                Sentryclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, lang.emergency.menu.revive.description()}


