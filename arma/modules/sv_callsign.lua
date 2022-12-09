RegisterServerEvent("ARMA:getCallsign")
AddEventHandler("ARMA:getCallsign", function(type)
    local source = source
    local user_id = ARMA.getUserId(source)
    if type == 'police' and ARMA.hasPermission(user_id, 'police.onduty.permission') then
        -- add callsign, rank and name check from google sheets
        TriggerClientEvent("ARMA:receivePoliceCallsign", source, 'GC-1', 'Comissioner', 'cnr')
    elseif type == 'prison' and ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') then
        -- add callsign, rank and name check from google sheets
        TriggerClientEvent("ARMA:receivePoliceCallsign", source, 'PA-1', 'Governor', 'cnr')
    end
end)