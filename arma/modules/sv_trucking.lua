local cfg=module("cfg/cfg_trucking")


RegisterNetEvent("ARMA:truckerJobBuyAllTrucks")
AddEventHandler("ARMA:truckerJobBuyAllTrucks",function()
    local source=source
    local user_id=ARMA.getUserId(source)
    local ownedTrucks = {}
    local rentedTrucks = {}
    for k,v in pairs(cfg.trucks) do
        -- check if user has vehicle then add to owned trucks table
    end
    -- might need to do a check if the truck is rented
    TriggerClientEvent('ARMA:updateOwnedTrucks', source, ownedTrucks, rentedTrucks)
end)

RegisterNetEvent("ARMA:rentTruck")
AddEventHandler("ARMA:rentTruck",function(a,b)
    local source=source
    local user_id=ARMA.getUserId(source)
end)

RegisterNetEvent("ARMA:spawnTruck")
AddEventHandler("ARMA:spawnTruck",function(truck)
    local source=source
    local user_id=ARMA.getUserId(source)
    -- check if user owns truck then
    TriggerClientEvent('ARMA:spawnTruckCl', source, truck)
end)