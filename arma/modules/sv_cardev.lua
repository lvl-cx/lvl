RegisterServerEvent('ARMA:setCarDev')
AddEventHandler('ARMA:setCarDev', function(status)
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil and ARMA.hasPermission(user_id, "cardev.menu") then 
      if status then
        SetPlayerRoutingBucket(source, 10)
        TriggerClientEvent('ARMA:setBucket', source, 10)
      else
        SetPlayerRoutingBucket(source, 0)
        TriggerClientEvent('ARMA:setBucket', source, 0)
      end
    else
      TriggerEvent("ARMA:acBan", user_id, 11, GetPlayerName(source), source, 'Attempted to Teleport to Car Dev Universe')
    end
end)