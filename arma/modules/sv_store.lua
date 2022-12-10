local cfg = module("cfg/cfg_store")

local ranks = {
    [1] = 'Underboss',
    [2] = 'Godfather',
    [3] = 'Platinum',
    [4] = 'Supporter',
}

AddEventHandler("ARMA:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = ARMA.getUserId(source)
        for k,v in pairs(ranks) do
            if ARMA.hasGroup(user_id, v) then
                TriggerClientEvent('ARMA:setStoreRankName', source, v)
            end
        end
        -- sql to get store items owned
        local ownedItems = {}
        for k,v in pairs(cfg.items) do
            table.insert(ownedItems, k)
        end
        TriggerClientEvent('ARMA:sendStoreItems', source, ownedItems)
    end)
end)

-- need to do set locked vehicles checks for police, passes a table of categories
-- TriggerClientEvent('ARMA:setStoreLockedVehicleCategories', source)

-- on store purchase
-- TriggerClientEvent('ARMA:storeDrawEffects', source)