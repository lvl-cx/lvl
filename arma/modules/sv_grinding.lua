

-- ['WORLD_HUMAN_CONST_DRILL'] = true, (gold, copper, limestone idk)
-- ['WORLD_HUMAN_CLIPBOARD'] = true, (lsd processing, frogs legs location)
-- ['CODE_HUMAN_MEDIC_KNEEL'] = true, (lsd grinding first location)
-- ['WORLD_HUMAN_HAMMERING'] = true, (hammering obviously)
-- ['WORLD_HUMAN_WELDING'] = true, (diamond location)

-- if diamond or some other grinding shit trigger ARMA:playGrindingPickaxe client event

local grindingData = {
    ['copper'] = {license = 'Gold', scenario = '', hasFX = false, firstItem = '', secondItem = ''},
    ['limestone'] = {license = 'Limestone', scenario = '', hasFX = false, firstItem = '', secondItem = ''},
    ['gold'] = {license = 'Gold', scenario = '', hasFX = false, firstItem = '', secondItem = ''},
    ['weed'] = {license = 'Weed', scenario = '', hasFX = false, firstItem = '', secondItem = ''},
    ['cocaine'] = {license = 'Cocaine', scenario = '', hasFX = false, firstItem = '', secondItem = ''},
    ['meth'] = {license = 'Meth', scenario = '', hasFX = false, firstItem = '', secondItem = ''},
    ['diamond'] = {license = 'Diamond', scenario = '', hasFX = false, firstItem = '', secondItem = ''},
    ['heroin'] = {license = 'Heroin', scenario = '', hasFX = false, firstItem = '', secondItem = ''},
    ['lsd'] = {license = 'LSD', scenario = '', hasFX = false, firstItem = '', secondItem = '', thirdItem = ''},
}

RegisterNetEvent('ARMA:requestGrinding')
AddEventHandler('ARMA:requestGrinding', function(drug, grindingtype)
    local source = source
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(grindingData) do
        if k == drug then
            if ARMA.hasGroup(user_id, v.license) then
                if grindingtype == 'mining' then
                    TriggerClientEvent('ARMA:playGrindingScenario', source, v.scenario, v.hasFX)
                end
            end
        end
    end
end)