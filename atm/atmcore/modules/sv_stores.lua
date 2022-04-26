local cfg = module("atmcore/cfg/cfg_stores")

RegisterNetEvent("ATM:BuyStoreItem")
AddEventHandler("ATM:BuyStoreItem", function(item, price, amount, x)
    local user_id = ATM.getUserId(source)
    local coords = vector3(x)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - coords) <= 5.0 then 
        if ATM.getInventoryWeight(user_id) <= 25 then
            if ATM.tryPayment(user_id,price) then
                ATM.giveInventoryItem(user_id, item, amount, false)
                ATMclient.notify(source, {"~g~Paid ".. '£' ..tostring(price)})
                TriggerClientEvent("ATM:PlaySound", source, 1)
            else
                ATMclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("ATM:PlaySound", source, 2)
            end
        else
            ATMclient.notify(source,{'~r~Not enough Weight.'})
            TriggerClientEvent("ATM:PlaySound", source, 2)
        end
    else 
        ATM.banConsole(user_id,"perm","Cheating/ Triggering Events")
    end
end)