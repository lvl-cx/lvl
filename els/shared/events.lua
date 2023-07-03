local lookup = {
    ["OASISELS:changeStage"] = "OASISELS:1",
    ["OASISELS:toggleSiren"] = "OASISELS:2",
    ["OASISELS:toggleBullhorn"] = "OASISELS:3",
    ["OASISELS:patternChange"] = "OASISELS:4",
    ["OASISELS:vehicleRemoved"] = "OASISELS:5",
    ["OASISELS:indicatorChange"] = "OASISELS:6"
}

local origRegisterNetEvent = RegisterNetEvent
RegisterNetEvent = function(name, callback)
    origRegisterNetEvent(lookup[name], callback)
end

if IsDuplicityVersion() then
    local origTriggerClientEvent = TriggerClientEvent
    TriggerClientEvent = function(name, target, ...)
        origTriggerClientEvent(lookup[name], target, ...)
    end

    TriggerClientScopeEvent = function(name, target, ...)
        exports["oasis"]:TriggerClientScopeEvent(lookup[name], target, ...)
    end
else
    local origTriggerServerEvent = TriggerServerEvent
    TriggerServerEvent = function(name, ...)
        origTriggerServerEvent(lookup[name], ...)
    end
end