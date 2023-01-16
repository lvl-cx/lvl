RegisterNetEvent("ARMAELS:changeStage", function(stage)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('ARMAELS:changeStage', -1, vehicleNetId, stage)
end)

RegisterNetEvent("ARMAELS:toggleSiren", function(tone)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('ARMAELS:toggleSiren', -1, vehicleNetId, tone)
end)

RegisterNetEvent("ARMAELS:toggleBullhorn", function(enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('ARMAELS:toggleBullhorn', -1, vehicleNetId, enabled)
end)

RegisterNetEvent("ARMAELS:patternChange", function(patternIndex, enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('ARMAELS:patternChange', -1, vehicleNetId, patternIndex, enabled)
end)

RegisterNetEvent("ARMAELS:vehicleRemoved", function(stage)
	TriggerClientEvent('ARMAELS:vehicleRemoved', -1, stage)
end)

RegisterNetEvent("ARMAELS:indicatorChange", function(indicator, enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('ARMAELS:indicatorChange', -1, vehicleNetId, indicator, enabled)
end)