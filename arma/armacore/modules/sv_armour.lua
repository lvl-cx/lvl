RegisterNetEvent("ARMA:getArmour")
AddEventHandler("ARMA:getArmour",function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "police.armoury") then
        if ARMA.hasPermission(user_id, "police.maxarmour") then
            ARMAclient.setArmour(source, {100})
        elseif ARMA.hasGroup(user_id, "Inspector Clocked") then
            ARMAclient.setArmour(source, {75})
        elseif ARMA.hasGroup(user_id, "Senior Constable Clocked") or ARMA.hasGroup(user_id, "Sergeant Clocked") then
            ARMAclient.setArmour(source, {50})
        elseif ARMA.hasGroup(user_id, "PCSO Clocked") or ARMA.hasGroup(user_id, "Police Constable Clocked") then
            ARMAclient.setArmour(source, {25})
        end
        TriggerClientEvent("arma:PlaySound", source, 1)
        ARMAclient.notify(source, {"~g~You have received your armour."})
    else
        local player = ARMA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("ARMA:acBan", user_id, 11, name, player, 'Attempted to use pd armour trigger')
    end
end)