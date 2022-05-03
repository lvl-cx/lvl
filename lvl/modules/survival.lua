local cfg = module("cfg/survival")
local lang = LVL.lang

-- api

function LVL.getHunger(user_id)
    local data = LVL.getUserDataTable(user_id)
    if data then
        return data.hunger
    end

    return 0
end

function LVL.getThirst(user_id)
    local data = LVL.getUserDataTable(user_id)
    if data then
        return data.thirst
    end

    return 0
end

function LVL.setHunger(user_id, value)
    local data = LVL.getUserDataTable(user_id)
    if data then
        data.hunger = value
        if data.hunger < 0 then
            data.hunger = 0
        elseif data.hunger > 100 then
            data.hunger = 100
        end

        -- update bar
        local source = LVL.getUserSource(user_id)
        LVLclient.setProgressBarValue(source, {"LVL:hunger", data.hunger})
        if data.hunger >= 100 then
            LVLclient.setProgressBarText(source, {"LVL:hunger", lang.survival.starving()})
        else
            LVLclient.setProgressBarText(source, {"LVL:hunger", ""})
        end
    end
end

function LVL.setThirst(user_id, value)
    local data = LVL.getUserDataTable(user_id)
    if data then
        data.thirst = value
        if data.thirst < 0 then
            data.thirst = 0
        elseif data.thirst > 100 then
            data.thirst = 100
        end

        -- update bar
        local source = LVL.getUserSource(user_id)
        LVLclient.setProgressBarValue(source, {"LVL:thirst", data.thirst})
        if data.thirst >= 100 then
            LVLclient.setProgressBarText(source, {"LVL:thirst", lang.survival.thirsty()})
        else
            LVLclient.setProgressBarText(source, {"LVL:thirst", ""})
        end
    end
end

function LVL.varyHunger(user_id, variation)

end

function LVL.varyThirst(user_id, variation)

end

-- tunnel api (expose some functions to clients)

function tLVL.varyHunger(variation)

end

function tLVL.varyThirst(variation)

end

-- tasks

-- hunger/thirst increase
function task_update()
    for k, v in pairs(LVL.users) do
        LVL.varyHunger(v, cfg.hunger_per_minute)
        LVL.varyThirst(v, cfg.thirst_per_minute)
    end

    SetTimeout(60000, task_update)
end


-- handlers

-- init values
AddEventHandler("LVL:playerJoin", function(user_id, source, name, last_login)
    local data = LVL.getUserDataTable(user_id)
    if data.hunger == nil then
        data.hunger = 0
        data.thirst = 0
    end
end)


---- revive
local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

local choice_revive = {function(player, choice)
    local user_id = LVL.getUserId(player)
    if user_id ~= nil then
        LVLclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = LVL.getUserId(nplayer)
            if nuser_id ~= nil then
                LVLclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        if LVL.tryGetInventoryItem(user_id, "medkit", 1, true) then
                            LVLclient.playAnim(player, {false, revive_seq, false}) -- anim
                            SetTimeout(15000, function()
                                LVLclient.varyHealth(nplayer, {50}) -- heal 50
                            end)
                        end
                    else
                        LVLclient.notify(player, {lang.emergency.menu.revive.not_in_coma()})
                    end
                end)
            else
                LVLclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, lang.emergency.menu.revive.description()}

RegisterNetEvent('LVL:SearchForPlayer')
AddEventHandler('LVL:SearchForPlayer', function()
    TriggerClientEvent('LVL:ReceiveSearch', -1, source)
end)

RegisterNetEvent('TeleportThem')
AddEventHandler('TeleportThem', function(one, two)
    Wait(500)
    LVLclient.teleport(one, {-934.38214111328,-782.61444091797,15.921166419983})
    LVLclient.notify(one, {'Number One'})
    LVLclient.teleport(two, {-948.12878417969,-801.18139648438,15.921133995056})
    LVLclient.notify(two, {'Number Two'})
end)



