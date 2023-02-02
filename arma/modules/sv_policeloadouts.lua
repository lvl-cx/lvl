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


RegisterNetEvent('ARMA:getPoliceLoadouts')
AddEventHandler('ARMA:getPoliceLoadouts', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local loadoutsTable = {}
    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
        for k,v in pairs(loadouts) do
            v.hasPermission = ARMA.hasPermission(user_id, v.permission) 
            loadoutsTable[k] = v
        end
        TriggerClientEvent('ARMA:gotLoadouts', source, loadoutsTable)
    end
end)

RegisterNetEvent('ARMA:selectLoadout')
AddEventHandler('ARMA:selectLoadout', function(loadout)
    local source = source
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(loadouts) do
        if k == loadout then
            if ARMA.hasPermission(user_id, 'police.onduty.permission') and ARMA.hasPermission(user_id, v.permission) then
                for a,b in pairs(v.weapons) do
                    ARMAclient.giveWeapons(source, {{[b] = {ammo = 250}}, false})
                end
                ARMAclient.notify(source, {"~g~Received "..loadout.." loadout."})
            else
                ARMAclient.notify(source, {"You do not have permission to select this loadout"})
            end
        end
    end
end)