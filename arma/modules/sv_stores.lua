local cfg = module("cfg/cfg_stores")


RegisterNetEvent("ARMA:BuyStoreItem")
AddEventHandler("ARMA:BuyStoreItem", function(item, amount)
    local user_id = ARMA.getUserId(source)
    local ped = GetPlayerPed(source)
    for k,v in pairs(cfg.shopItems) do
        if item == v.itemID then
            if ARMA.getInventoryWeight(user_id) <= 25 then
                if ARMA.tryPayment(user_id,v.price*amount) then
                    ARMA.giveInventoryItem(user_id, item, amount, false)
                    ARMAclient.notify(source, {"~g~Paid ".. '£' ..getMoneyStringFormatted(v.price*amount)..'.'})
                    TriggerClientEvent("arma:PlaySound", source, 1)
                else
                    ARMAclient.notify(source, {"~r~Not enough money."})
                    TriggerClientEvent("arma:PlaySound", source, 2)
                end
            else
                ARMAclient.notify(source,{'~r~Not enough inventory space.'})
                TriggerClientEvent("arma:PlaySound", source, 2)
            end
        end
    end
end)