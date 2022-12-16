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
RegisterNetEvent('ARMA:requestStartCooking')
AddEventHandler('ARMA:requestStartCooking', function(recipe)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'Burger Shot Cook') then
        for k,v in pairs(a) do
            if k == recipe then
                cookingStages[user_id] = 1
                TriggerClientEvent('ARMA:beginCooking', source, recipe)
                TriggerClientEvent('ARMA:cookingInstruction', source, v[cookingStages[user_id]])
            end
        end
    else
        ARMAclient.notify(source, {"~r~You aren't clocked on as a Burger Shot Cook, head to cityhall to sign up."})
    end
end)

RegisterNetEvent('ARMA:pickupCookingIngredient')
AddEventHandler('ARMA:pickupCookingIngredient', function(recipe, ingredient)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'Burger Shot Cook') then
        if ingredient == 'bbq' and cookingStages[user_id] == 7 then
            cookingStages[user_id] = nil
            TriggerClientEvent('ARMA:finishedCooking', source)
            ARMA.giveBankMoney(user_id, 4000)
        else
            for k,v in pairs(a) do
                if k == recipe then
                    cookingStages[user_id] = cookingStages[user_id] + 1
                    TriggerClientEvent('ARMA:cookingInstruction', source, v[cookingStages[user_id]])
                end
            end
        end
    else
        ARMAclient.notify(source, {"~r~You aren't clocked on as a Burger Shot Cook, head to cityhall to sign up."})
    end
end)