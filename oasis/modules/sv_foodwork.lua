local a = {
    ["burger"] = {
        [1] = 'bun',
        [2] = 'lettuce',
        [3] = 'tomato',
        [4] = 'onion',
        [5] = 'cheese',
        [6] = 'beef_patty',
        [7] = 'bbq',
    }
}

local cookingStages = {}
RegisterNetEvent('OASIS:requestStartCooking')
AddEventHandler('OASIS:requestStartCooking', function(recipe)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasGroup(user_id, 'Burger Shot Cook') then
        for k,v in pairs(a) do
            if k == recipe then
                cookingStages[user_id] = 1
                TriggerClientEvent('OASIS:beginCooking', source, recipe)
                TriggerClientEvent('OASIS:cookingInstruction', source, v[cookingStages[user_id]])
            end
        end
    else
        OASISclient.notify(source, {"~r~You aren't clocked on as a Burger Shot Cook, head to cityhall to sign up."})
    end
end)

RegisterNetEvent('OASIS:pickupCookingIngredient')
AddEventHandler('OASIS:pickupCookingIngredient', function(recipe, ingredient)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasGroup(user_id, 'Burger Shot Cook') then
        if ingredient == 'bbq' and cookingStages[user_id] == 7 then
            cookingStages[user_id] = nil
            TriggerClientEvent('OASIS:finishedCooking', source)
            OASIS.giveBankMoney(user_id, grindBoost*4000)
        else
            for k,v in pairs(a) do
                if k == recipe then
                    cookingStages[user_id] = cookingStages[user_id] + 1
                    TriggerClientEvent('OASIS:cookingInstruction', source, v[cookingStages[user_id]])
                end
            end
        end
    else
        OASISclient.notify(source, {"~r~You aren't clocked on as a Burger Shot Cook, head to cityhall to sign up."})
    end
end)