local cfg = module("lvlcore/cfg/cfg_stores")

RegisterNetEvent("LVL:BuyStoreItem")
AddEventHandler("LVL:BuyStoreItem", function(item, price, amount, x)
    local user_id = LVL.getUserId(source)
    local coords = vector3(x)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - coords) <= 5.0 then 
        if LVL.getInventoryWeight(user_id) <= 25 then
            if LVL.tryPayment(user_id,price) then
                LVL.giveInventoryItem(user_id, item, amount, false)
                LVLclient.notify(source, {"~b~Paid ".. '£' ..tostring(price)})
                TriggerClientEvent("LVL:PlaySound", source, 1)
            else
                LVLclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("LVL:PlaySound", source, 2)
            end
        else
            LVLclient.notify(source,{'~r~Not enough Weight.'})
            TriggerClientEvent("LVL:PlaySound", source, 2)
        end
    else 
        LVL.banConsole(user_id,"perm","Cheating/ Triggering Events")
    end
end)