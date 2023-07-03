RegisterNetEvent("OASISELS:changeStage", function(stage)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('OASISELS:changeStage', -1, vehicleNetId, stage)
end)

RegisterNetEvent("OASISELS:toggleSiren", function(tone)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('OASISELS:toggleSiren', -1, vehicleNetId, tone)
end)

RegisterNetEvent("OASISELS:toggleBullhorn", function(enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('OASISELS:toggleBullhorn', -1, vehicleNetId, enabled)
end)

RegisterNetEvent("OASISELS:patternChange", function(patternIndex, enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('OASISELS:patternChange', -1, vehicleNetId, patternIndex, enabled)
end)

RegisterNetEvent("OASISELS:vehicleRemoved", function(stage)
	TriggerClientEvent('OASISELS:vehicleRemoved', -1, stage)
end)

RegisterNetEvent("OASISELS:indicatorChange", function(indicator, enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('OASISELS:indicatorChange', -1, vehicleNetId, indicator, enabled)
end)