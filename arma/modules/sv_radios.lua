local cfg = module("cfg/cfg_radios")

local function getRadioType(userid)
    if ARMA.hasPermission(userid, "police.onduty.permission") then
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

local radioChannels = {}

AddEventHandler("ARMA:playerSpawn", function(user_id, source, first_spawn)
    local source = source
    local user_id = ARMA.getUserId(source)
    local radioType = getRadioType(user_id)
    if radioType then
        TriggerClientEvent('ARMA:radiosAddPlayer', -1, radioType, source)
        TriggerClientEvent('ARMA:radiosCreateChannel', source, name, players, first_spawn)
    end
end)

RegisterServerEvent("ARMA:radiosSetIsMuted")
AddEventHandler("ARMA:radiosSetIsMuted", function(mutedState)
    local source = source
    local user_id = ARMA.getUserId(source)
    local radioType = getRadioType(user_id)
    if radioType then
        TriggerClientEvent('ARMA:radiosSetPlayerIsMuted', -1, radioType, source, mutedState)
    end
end)