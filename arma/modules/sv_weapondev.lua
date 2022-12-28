RegisterServerEvent('ARMA:setWeaponDev')
AddEventHandler('ARMA:setWeaponDev', function(status)
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil and user_id == 1 or user_id == 163 then 
      if status then
        SetPlayerRoutingBucket(source, 69)
        TriggerClientEvent('ARMA:setBucket', source, 69)
      else
        SetPlayerRoutingBucket(source, 0)
        TriggerClientEvent('ARMA:setBucket', source, 0)
      end
    end
end)
