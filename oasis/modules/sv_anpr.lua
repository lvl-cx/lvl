local flaggedVehicles = {}

AddEventHandler("OASIS:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if OASIS.hasPermission(user_id, 'police.onduty.permission') then
            TriggerClientEvent('OASIS:setFlagVehicles', source, flaggedVehicles)
        end
    end
end)

RegisterServerEvent("OASIS:flagVehicleAnpr")
AddEventHandler("OASIS:flagVehicleAnpr", function(plate, reason)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') then
        flaggedVehicles[plate] = reason
        TriggerClientEvent('OASIS:setFlagVehicles', -1, flaggedVehicles)
    end
end)