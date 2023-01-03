

-- ['WORLD_HUMAN_CONST_DRILL'] = true, (gold, copper, limestone idk)
-- ['WORLD_HUMAN_CLIPBOARD'] = true, (lsd processing, Frogs legs location)
-- ['CODE_HUMAN_MEDIC_KNEEL'] = true, (lsd grinding first location)
-- ['WORLD_HUMAN_HAMMERING'] = true, (hammering obviously)
-- ['WORLD_HUMAN_WELDING'] = true, (diamond location)

-- if diamond or some other grinding shit trigger ARMA:playGrindingPickaxe client event

local grindingData = {
    ['Copper'] = {
        license = 'Copper', 
        processingScenario = 'WORLD_HUMAN_WELDING', 
        hasFX = true, 
        firstItem = 'Uncut Copper', 
        secondItem = 'Copper', 
        pickaxe = true
    },
    ['Limestone'] = {
        license = 'Limestone', 
        processingScenario = 'WORLD_HUMAN_WELDING', 
        hasFX = true, 
        firstItem = 'Uncut Limestone', 
        secondItem = 'Limestone', 
        pickaxe = true
    },
    ['Gold'] = {
        license = 'Gold', 
        processingScenario = 'WORLD_HUMAN_WELDING', 
        hasFX = true, 
        firstItem = 'Uncut Gold', 
        secondItem = 'Gold', 
        pickaxe = true
    },
    ['Weed'] = {
        license = 'Weed', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = '', 
        hasFX = false, 
        firstItem = '', 
        secondItem = ''
    },
    ['Cocaine'] = {
        license = 'Cocaine', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = 'WORLD_HUMAN_CLIPBOARD', 
        hasFX = false, 
        firstItem = 'Coca leaf', 
        secondItem = 'Cocaine'
    },
    ['Meth'] = {
        license = 'Meth', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = 'WORLD_HUMAN_CLIPBOARD', 
        hasFX = false, 
        firstItem = 'Ephedra', 
        secondItem = 'Meth'
    },
    ['Diamond'] = {
        license = 'Diamond', 
        processingScenario = 'WORLD_HUMAN_WELDING', 
        hasFX = false, 
        firstItem = 'Uncut Diamond', 
        secondItem = 'Diamond', 
        pickaxe = true
    },
    ['Heroin'] = {
        license = 'Heroin', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = 'WORLD_HUMAN_CLIPBOARD', 
        hasFX = false, 
        firstItem = 'Opium Poppy', 
        secondItem = 'Heroin'
    },
    ['LSD'] = {
        license = 'LSD', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = 'WORLD_HUMAN_CLIPBOARD', 
        hasFX = false, 
        firstItem = 'Frogs legs', 
        secondItem = 'Lysergic Acid Amide', 
        thirdItem = 'LSD'
    },
}

RegisterNetEvent('ARMA:requestGrinding')
AddEventHandler('ARMA:requestGrinding', function(drug, grindingtype)
    local source = source
    local user_id = ARMA.getUserId(source)
    local delay = 10000
    for k,v in pairs(grindingData) do
        if k == drug then
            if ARMA.hasGroup(user_id, v.license) then
                MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
                    if #rows > 0 then
                        if rows[1].plathours > 0 then
                           delay = 7500
                        end
                        if grindingtype == 'mining' then
                            if v.pickaxe then
                                TriggerClientEvent('ARMA:playGrindingPickaxe', source)  
                            else
                                TriggerClientEvent('ARMA:playGrindingScenario', source, v.miningScenario, v.hasFX) 
                            end
                            Citizen.Wait(delay)
                            if ARMA.getInventoryWeight(user_id)+(1*4) > ARMA.getInventoryMaxWeight(user_id) then
                                ARMAclient.notify(source,{"~r~Not enough space in inventory."})
                            else    
                                ARMA.giveInventoryItem(user_id, v.firstItem, 4, true)
                            end
                        elseif grindingtype == 'processing' then
                            if ARMA.getInventoryItemAmount(user_id, v.firstItem) >= 4 then
                                TriggerClientEvent('ARMA:playGrindingScenario', source, v.processingScenario, v.hasFX)
                                Citizen.Wait(delay)
                                if ARMA.getInventoryWeight(user_id)+(4*1) > ARMA.getInventoryMaxWeight(user_id) then
                                    ARMAclient.notify(source,{"~r~Not enough space in inventory."})
                                else   
                                    if drug == 'LSD' then 
                                        ARMA.tryGetInventoryItem(user_id, v.firstItem, 4, true)
                                        ARMA.giveInventoryItem(user_id, v.secondItem, 4, true)
                                    else
                                        ARMA.tryGetInventoryItem(user_id, v.firstItem, 4, true)
                                        ARMA.giveInventoryItem(user_id, v.secondItem, 1, true)
                                    end
                                end
                            else
                                ARMAclient.notify(source, {"~r~You do not have enough "..v.firstItem.."."})
                            end
                        elseif grindingtype == 'refinery' then
                            if ARMA.getInventoryItemAmount(user_id, v.secondItem) >= 4 then
                                TriggerClientEvent('ARMA:playGrindingScenario', source, 'WORLD_HUMAN_CLIPBOARD', v.hasFX)
                                Citizen.Wait(delay)
                                if ARMA.getInventoryWeight(user_id)+(4*1) > ARMA.getInventoryMaxWeight(user_id) then
                                    ARMAclient.notify(source,{"~r~Not enough space in inventory."})
                                else    
                                    ARMA.tryGetInventoryItem(user_id, v.secondItem, 4, true)
                                    ARMA.giveInventoryItem(user_id, v.thirdItem, 1, true)
                                end
                            else
                                ARMAclient.notify(source, {"~r~You do not have enough "..v.secondItem.."."})
                            end
                        end
                    end
                end)
            end
        end
    end
end)