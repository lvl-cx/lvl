local cfg = module("sentrycore/cfg/cfg_stores")

RegisterNetEvent("Sentry:BuyStoreItem")
AddEventHandler("Sentry:BuyStoreItem", function(item, price, amount, x)
    local user_id = Sentry.getUserId(source)
    local coords = vector3(x)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 5.0 then 
        if Sentry.getInventoryWeight(userid) <= 25 then
            if Sentry.tryPayment(user_id,price) then
                Sentry.giveInventoryItem(user_id, item, amount, false)
                Sentryclient.notify(source, {"~g~Paid ".. '£' ..tostring(price)})
                TriggerClientEvent("Sentry:PlaySound", source, 1)
            else
                Sentryclient.notify(source, {"~r~Not enough money."})
                TriggerClientEvent("Sentry:PlaySound", source, 2)
            end
        else
            Sentryclient.notify(source,{'~r~Not enough Weight.'})
            TriggerClientEvent("Sentry:PlaySound", source, 2)
        end
    else 
        Sentry.banConsole(user_id,"perm","Cheating/ Triggering Events")
    end
end)