local cfg = module("cfg/cfg_stores")


RegisterNetEvent("OASIS:BuyStoreItem")
AddEventHandler("OASIS:BuyStoreItem", function(item, amount)
    local user_id = OASIS.getUserId(source)
    local ped = GetPlayerPed(source)
    for k,v in pairs(cfg.shopItems) do
        if item == v.itemID then
            if OASIS.getInventoryWeight(user_id) <= 25 then
                if OASIS.tryPayment(user_id,v.price*amount) then
                    OASIS.giveInventoryItem(user_id, item, amount, false)
                    OASISclient.notify(source, {"~g~Paid ".. '£' ..getMoneyStringFormatted(v.price*amount)..'.'})
                    TriggerClientEvent("oasis:PlaySound", source, 1)
                else
                    OASISclient.notify(source, {"~r~Not enough money."})
                    TriggerClientEvent("oasis:PlaySound", source, 2)
                end
            else
                OASISclient.notify(source,{'~r~Not enough inventory space.'})
                TriggerClientEvent("oasis:PlaySound", source, 2)
            end
        end
    end
end)