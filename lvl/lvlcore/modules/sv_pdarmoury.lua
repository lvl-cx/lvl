
armoury = {}

armoury.location = vector3(451.34454345703,-980.09381103516,30.689605712891)

RegisterServerEvent("PD:BuyWeapon")
AddEventHandler('PD:BuyWeapon', function(hash)
    local source = source
    userid = LVL.getUserId(source)
    local coords = armoury.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if LVL.hasPermission(userid, 'cop.keycard') then
            GiveWeaponToPed(source, hash, 250, false, false)
            TriggerClientEvent("LVL:PlaySound", source, 1)
            LVLclient.notify(source, {"~b~Paid ".. '£0'})
        else
            LVLclient.notify(source,{'~r~You are not PD/ Clocked on!'})
            TriggerClientEvent("LVL:PlaySound", source, 2)
        end

    else 
        LVL.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)

RegisterServerEvent("PD:BuyArmour")
AddEventHandler('PD:BuyArmour', function()
    local source = source
    userid = LVL.getUserId(source)
    local coords = armoury.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if LVL.hasPermission(userid, 'cop.keycard') then
    
    
            SetPedArmour(source, 96)
            TriggerClientEvent("LVL:PlaySound", source, 1)
            LVLclient.notify(source, {"~b~Paid ".. '£0'})

        else
            LVLclient.notify(source,{'~r~You are not PD/ Clocked on!'})
            TriggerClientEvent("LVL:PlaySound", source, 2)
        end
    else 
        LVL.banConsole(userid,"perm","Cheating/ Triggering Events")
    end
end)


