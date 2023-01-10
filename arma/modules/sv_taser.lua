RegisterServerEvent('ARMA:playTaserSound')
AddEventHandler('ARMA:playTaserSound', function(coords, sound)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') then
        TriggerClientEvent('playTaserSoundClient', -1, coords, sound)
    end
end)

RegisterServerEvent('ARMA:reactivatePed')
AddEventHandler('ARMA:reactivatePed', function(id)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('ARMA:receiveActivation', id)
    end
end)

RegisterServerEvent('ARMA:arcTaser')
AddEventHandler('ARMA:arcTaser', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') then
      ARMAclient.getNearestPlayer(source, {3}, function(nplayer)
        local nuser_id = ARMA.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('ARMA:receiveBarbs', nplayer, source)
        end
      end)
    end
end)

RegisterServerEvent('ARMA:barbsNoLongerServer')
AddEventHandler('ARMA:barbsNoLongerServer', function(id)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('ARMA:barbsNoLonger', id)
    end
end)

RegisterServerEvent('ARMA:barbsRippedOutServer')
AddEventHandler('ARMA:barbsRippedOutServer', function(id)
    local source = source
    local user_id = ARMA.getUserId(source)
    TriggerClientEvent('ARMA:barbsRippedOut', id)
end)

RegisterCommand('rt', function(source, args)
  local source = source
  local user_id = ARMA.getUserId(source)
  if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('ARMA:reloadTaser', source)
  end
end)