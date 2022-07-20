
ammo = {}

ammo.location = vector3(-458.36862182617,-2274.5075683594,8.5158195495605)

RegisterServerEvent("Ammo:BuyAmmo")
AddEventHandler('Ammo:BuyAmmo', function(price, hash, amount)
    local source = source
    local userid = ARMA.getUserId(source)
    local coords = ammo.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        
        
        if ARMA.tryPayment(userid, price) then
           -- GiveWeaponToPed(source, hash, 250, false, false)
            ARMA.giveInventoryItem(userid, hash, amount, false)
            TriggerClientEvent("ARMA:PlaySound", source, 1)
            ARMAclient.notify(source, {"~g~Paid ".. '£' ..tostring(price)})
        else 
            ARMAclient.notify(source, {"~r~Not enough money."})
            TriggerClientEvent("ARMA:PlaySound", source, 2)
        end


    else 
        TriggerEvent("ARMA:acBan", userid, 11, GetPlayerName(source), source, 'Trigger Ammo purchase')
    end
end)





