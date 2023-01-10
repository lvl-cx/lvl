local flaggedVehicles = {}

AddEventHandler("ARMA:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if ARMA.hasPermission(user_id, 'police.onduty.permission') then
            TriggerClientEvent('ARMA:setFlagVehicles', source, flaggedVehicles)
        end
    end
end)

RegisterServerEvent("ARMA:flagVehicleAnpr")
AddEventHandler("ARMA:flagVehicleAnpr", function(plate, reason)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
        flaggedVehicles[plate] = reason
        TriggerClientEvent('ARMA:setFlagVehicles', -1, flaggedVehicles)
    end
end)