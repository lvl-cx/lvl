SMALL = {}


SMALL.whitelist = { 
 
    --{name = "", gunhash = "", permid = permid, price = 0},
    {name = "USPS Kill Confirmed", gunhash = "WEAPON_USPSKILLCONFIRMED", permid = 1, price = 120000},
    {name = "Hush Ghost", gunhash = "WEAPON_HG", permid = 2, permid, price = 120000},

}



function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

RegisterServerEvent("SMALLARMS:BuyWeapon")
AddEventHandler('SMALLARMS:BuyWeapon', function(hash)
    local source = source
    local user_id = ARMA.getUserId(source)

    if user_id ~= nil then
            for k, v in pairs(smallarms.guns) do
                if v.hash == hash  then
                if ARMA.tryPayment(user_id, v.price) then
                    ARMAclient.giveWeapons(source,{[v.hash] = {ammo=250}})
                    TriggerClientEvent("ARMA:PlaySound", source, 1)
                    ARMAclient.notify(source, {"~g~Paid £"..tostring(getMoneyStringFormatted(v.price))})
                else 
                    ARMAclient.notify(source, {"~r~Insufficient funds"})
                    TriggerClientEvent("ARMA:PlaySound", source, 2)
                
                end
            end
        end
    end
end)


RegisterServerEvent("SMALLARMS:BuyWeapon2")
AddEventHandler('SMALLARMS:BuyWeapon2', function(hash)
    local source = source
    local user_id = ARMA.getUserId(source)

    if user_id ~= nil then
        for k, v in pairs(SMALL.whitelist) do
            if v.gunhash == hash  then
                if ARMA.tryPayment({user_id, v.price}) then
                    ARMAclient.giveWeapons(source,{[v.gunhash] = {ammo=250}})
                    TriggerClientEvent("ARMA:PlaySound", source, 1)
                    ARMAclient.notify(source, {"~g~Paid £"..tostring(getMoneyStringFormatted(v.price))})
                else 
                    ARMAclient.notify(source, {"~r~Insufficient funds"})
                    TriggerClientEvent("ARMA:PlaySound", source, 2)
                end
            end
        end
    end
end)

RegisterNetEvent("SMALLARMS:BuyWeaponAmmo")
AddEventHandler("SMALLARMS:BuyWeaponAmmo", function(hash)
    local source = source
    local user_id = ARMA.getUserId(source)

    if user_id ~= nil then
        for k, v in pairs(smallarms.guns) do
             if v.hash == hash then
                if ARMA.tryPayment(user_id, v.price / 2) then
                    ARMAclient.giveWeaponAmmo(source,{v.hash, 250})
                    ARMAclient.notify(source, {"~g~Paid £"..tostring(getMoneyStringFormatted(v.price/2))})
                    TriggerClientEvent("ARMA:PlaySound", source, 1)
                else 
                    TriggerClientEvent("SmallArms:Error", source, false)
                    ARMAclient.notify(source, {"~r~Insufficient funds"})
                    TriggerClientEvent("ARMA:PlaySound", source, 2)
                 end
            end
        end
    end
end)

RegisterNetEvent("SMALLARMS:BuyWeaponAmmo2")
AddEventHandler("SMALLARMS:BuyWeaponAmmo2", function(hash)
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil then
        for k, v in pairs(SMALL.whitelist) do
             if v.gunhash == hash then
                if ARMA.tryPayment(user_id, v.price / 2) then
                    ARMAclient.giveWeaponAmmo(source,{v.gunhash, 250})
                    ARMAclient.notify(source, {"~g~Paid £"..tostring(getMoneyStringFormatted(v.price/2))})
                    TriggerClientEvent("ARMA:PlaySound", source, 1)
                else 
                    TriggerClientEvent("SmallArms:Error", source, false)
                    ARMAclient.notify(source, {"~r~Insufficient funds"})
                    TriggerClientEvent("ARMA:PlaySound", source, 2)
                 end
            end
        end
    end
end)

RegisterServerEvent("SmallArms:BuyArmour")
AddEventHandler('SmallArms:BuyArmour', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local currentArmour = GetPedArmour(GetPlayerPed(source))

    if user_id ~= nil then
        if currentArmour < 25 then
            if ARMA.tryPayment(user_id, smallarms.armourprice) then
                ARMAclient.setArmour(source,{25})
                ARMAclient.notify(source, {"~g~Paid £"..tostring(getMoneyStringFormatted(smallarms.armourprice))})
                TriggerClientEvent("ARMA:PlaySound", source, 1)
            else 
                TriggerClientEvent("SmallArms:Error", source, false)
                ARMAclient.notify(source, {"~r~Insufficient funds"})
                TriggerClientEvent("ARMA:PlaySound", source, 2)
            end
        else
            ARMAclient.notify(source,{"~r~You already have 25% armour."})
        end
    end
end)



RegisterServerEvent("SMALL:PULLWHITELISTEDWEAPONS")
AddEventHandler("SMALL:PULLWHITELISTEDWEAPONS", function()
    local source = source
    local table = {}
    local user_id = ARMA.getUserId(source)
    for i,v in pairs(SMALL.whitelist) do
        if v.permid == user_id then 
       table[i] = {name = v.name, gunhash = v.gunhash, price = v.price}
        end 
    end 
    Wait(1)
    TriggerClientEvent("SMALL:GUNSRETURNED", source,table)
end)


