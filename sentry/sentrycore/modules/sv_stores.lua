local cfg = module("sentrycore/cfg/cfg_stores")

RegisterNetEvent("Sentry:BuyStoreItem")
AddEventHandler("Sentry:BuyStoreItem", function(item)
    local user_id = Sentry.getUserId(source)

    for k, v in pairs(cfg.shopItems) do
        if v.itemID == item then
            if Sentry.tryPayment(user_id,v.price) then
                Sentry.giveInventoryItem(user_id, v.itemID, 1, true)
                Sentryclient.playFrontendSound(source,{"Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"})
            else
                Sentryclient.notify(source,{"~r~You don't have enough money."})
            end
        end
    end
end)