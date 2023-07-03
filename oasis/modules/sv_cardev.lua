RegisterServerEvent('OASIS:setCarDevMode')
AddEventHandler('OASIS:setCarDevMode', function(status)
    local source = source
    local user_id = OASIS.getUserId(source)
    if user_id ~= nil and OASIS.hasPermission(user_id, "cardev.menu") then 
      if status then
        tOASIS.setBucket(source, 333)
      else
        tOASIS.setBucket(source, 0)
      end
    else
      TriggerEvent("OASIS:acBan", user_id, 11, GetPlayerName(source), source, 'Attempted to Teleport to Car Dev Universe')
    end
end)