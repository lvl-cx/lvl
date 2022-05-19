local cfg = module("armacore/cfg/cfg_stores")

RegisterNetEvent("ARMA:BuyStoreItem")
AddEventHandler("ARMA:BuyStoreItem", function(item, price, amount, x)
    local user_id = ARMA.getUserId(source)
    local coords = vector3(x)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - coords) <= 5.0 then 
        if ARMA.getInventoryWeight(user_id) <= 25 then
            if ARMA.tryPayment(user_id,price) then
                ARMA.giveInventoryItem(user_id, item, amount, false)
                ARMAclient.notify(source, {"~g~Paid ".. '£' ..tostring(price)})
                TriggerClientEvent("ARMA:PlaySound", source, 1)
            else
                ARMAclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("ARMA:PlaySound", source, 2)
            end
        else
            ARMAclient.notify(source,{'~r~Not enough Weight.'})
            TriggerClientEvent("ARMA:PlaySound", source, 2)
        end
    else 
        ARMA.banConsole(user_id,"perm","Cheating/ Triggering Events")
    end
end)