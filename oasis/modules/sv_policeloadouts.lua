loadouts = {
    ['Basic'] = {
        permission = "police.onduty.permission",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
        },
    },
    ['SCO-19'] = {
        permission = "police.loadshop2",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
            "WEAPON_G36K",
        },
    },
    ['CTSFO'] = {
        permission = "police.maxarmour",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
            "WEAPON_SPAR17",
            "WEAPON_REMINGTON700",
            "WEAPON_FLASHBANG",
        },
    },
    ['MP5 Tazer'] = {
        permission = "police.announce",
        weapons = {
            "WEAPON_NONMP5",
        },
    },
}


RegisterNetEvent('OASIS:getPoliceLoadouts')
AddEventHandler('OASIS:getPoliceLoadouts', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    local loadoutsTable = {}
    if OASIS.hasPermission(user_id, 'police.onduty.permission') then
        for k,v in pairs(loadouts) do
            v.hasPermission = OASIS.hasPermission(user_id, v.permission) 
            loadoutsTable[k] = v
        end
        TriggerClientEvent('OASIS:gotLoadouts', source, loadoutsTable)
    end
end)

RegisterNetEvent('OASIS:selectLoadout')
AddEventHandler('OASIS:selectLoadout', function(loadout)
    local source = source
    local user_id = OASIS.getUserId(source)
    for k,v in pairs(loadouts) do
        if k == loadout then
            if OASIS.hasPermission(user_id, 'police.onduty.permission') and OASIS.hasPermission(user_id, v.permission) then
                for a,b in pairs(v.weapons) do
                    OASISclient.giveWeapons(source, {{[b] = {ammo = 250}}, false})
                end
                OASISclient.notify(source, {"~g~Received "..loadout.." loadout."})
            else
                OASISclient.notify(source, {"You do not have permission to select this loadout"})
            end
        end
    end
end)