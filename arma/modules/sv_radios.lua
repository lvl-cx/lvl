local cfg = module("cfg/cfg_radios")

local function getRadioType(user_id)
    if ARMA.hasPermission(user_id, "police.onduty.permission") then
        return "Police"
    elseif ARMA.hasPermission(user_id, "nhs.onduty.permission") then
        return "NHS"
    elseif ARMA.hasPermission(user_id, "prisonguard.onduty.permission") then
        return "HMP"
    elseif ARMA.hasPermission(user_id, "lfb.onduty.permission") then
        return "LFB"
    end
    return false
end

local radioChannels = {
    ['Police'] = {
        name = 'Police',
        players = {},
        channel = 1,
    },
    ['NHS'] = {
        name = 'NHS',
        players = {},
        channel = 2,
    },
    ['HMP'] = {
        name = 'HMP',
        players = {},
        channel = 3,
    },
    ['LFB'] = {
        name = 'LFB',
        players = {},
        channel = 4,
    },
}

AddEventHandler("ARMA:playerSpawn", function(user_id, source, first_spawn)
    local source = source
    local user_id = ARMA.getUserId(source)
    local radioType = getRadioType(user_id)
    if radioType then
        for k,v in pairs(cfg.sortOrder.police) do
            if ARMA.hasPermission(user_id, v) then
                local sortOrder = k
                table.insert(radioChannels[radioType]['players'], {name = GetPlayerName(source), sortOrder = sortOrder})
                TriggerClientEvent('ARMA:radiosCreateChannel', source, radioChannels[radioType].channel, radioChannels[radioType].name, radioChannels[radioType].players, first_spawn)
                TriggerClientEvent('ARMA:radiosAddPlayer', -1, radioType, user_id, {name = GetPlayerName(source), sortOrder = sortOrder})
            end
        end
    end
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    local user_id = ARMA.getUserId(source)
    local radioType = getRadioType(user_id)
    if radioType then
        for k,v in pairs(radioChannels[radioType]['players']) do
            if v.name == GetPlayerName(source) then
                table.remove(radioChannels[radioType]['players'], k)
                TriggerClientEvent('ARMA:radiosRemovePlayer', -1, radioChannels[radioType].channel, user_id)
            end
        end
    end
end)

RegisterServerEvent("ARMA:radiosSetIsMuted")
AddEventHandler("ARMA:radiosSetIsMuted", function(mutedState)
    local source = source
    local user_id = ARMA.getUserId(source)
    local radioType = getRadioType(user_id)
    if radioType then
        TriggerClientEvent('ARMA:radiosSetPlayerIsMuted', -1, radioChannels[radioType].channel, user_id, mutedState)
    end
end)