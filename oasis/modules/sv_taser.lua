RegisterServerEvent('OASIS:playTaserSound')
AddEventHandler('OASIS:playTaserSound', function(coords, sound)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') or OASIS.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent('playTaserSoundClient', -1, coords, sound)
    end
end)

RegisterServerEvent('OASIS:reactivatePed')
AddEventHandler('OASIS:reactivatePed', function(id)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') or OASIS.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('OASIS:receiveActivation', id)
      TriggerClientEvent('TriggerTazer', id)
    end
end)

RegisterServerEvent('OASIS:arcTaser')
AddEventHandler('OASIS:arcTaser', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') or OASIS.hasPermission(user_id, 'prisonguard.onduty.permission') then
      OASISclient.getNearestPlayer(source, {3}, function(nplayer)
        local nuser_id = OASIS.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('OASIS:receiveBarbs', nplayer, source)
            TriggerClientEvent('TriggerTazer', id)
        end
      end)
    end
end)

RegisterServerEvent('OASIS:barbsNoLongerServer')
AddEventHandler('OASIS:barbsNoLongerServer', function(id)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') or OASIS.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('OASIS:barbsNoLonger', id)
    end
end)

RegisterServerEvent('OASIS:barbsRippedOutServer')
AddEventHandler('OASIS:barbsRippedOutServer', function(id)
    local source = source
    local user_id = OASIS.getUserId(source)
    TriggerClientEvent('OASIS:barbsRippedOut', id)
end)

RegisterCommand('rt', function(source, args)
  local source = source
  local user_id = OASIS.getUserId(source)
  if OASIS.hasPermission(user_id, 'police.onduty.permission') or OASIS.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('OASIS:reloadTaser', source)
  end
end)