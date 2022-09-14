AddEventHandler("ARMA:playerSpawn", function(user_id,player,first_spawn)
    local user_id = user_id
    local source = ARMA.getUserSource(user_id)
    petsTable = {}
    petsTable.shop = {}
    petsTable.shop.coords = vector3(562.29833984375, 2738.9926757812, 42.443759918213)
    disabledAbilities = {}
    disabledAbilities.attack = true
    petsTable.pets = {}
    TriggerClientEvent('ARMA:buildPetCFG', source, something, disabledAbilities, petsTable)
end)

RegisterCommand('pet', function(source, args)
    local source = source
    local user_id = ARMA.getUserId(source)
    TriggerClientEvent('ARMA:togglePetMenu', source)
end)