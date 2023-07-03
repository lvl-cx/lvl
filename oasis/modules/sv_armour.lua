RegisterNetEvent("OASIS:getArmour")
AddEventHandler("OASIS:getArmour",function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, "police.armoury") then
        if OASIS.hasPermission(user_id, "police.maxarmour") then
            OASISclient.setArmour(source, {100, true})
        elseif OASIS.hasGroup(user_id, "Inspector Clocked") then
            OASISclient.setArmour(source, {75, true})
        elseif OASIS.hasGroup(user_id, "Senior Constable Clocked") or OASIS.hasGroup(user_id, "Sergeant Clocked") then
            OASISclient.setArmour(source, {50, true})
        elseif OASIS.hasGroup(user_id, "PCSO Clocked") or OASIS.hasGroup(user_id, "PC Clocked") then
            OASISclient.setArmour(source, {25, true})
        end
        TriggerClientEvent("oasis:PlaySound", source, 1)
        OASISclient.notify(source, {"~g~You have received your armour."})
    else
        local player = OASIS.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("OASIS:acBan", user_id, 11, name, player, 'Attempted to use pd armour trigger')
    end
end)