

-- ['WORLD_HUMAN_CONST_DRILL'] = true, (gold, copper, limestone idk)
-- ['WORLD_HUMAN_CLIPBOARD'] = true, (lsd processing, frogs legs location)
-- ['CODE_HUMAN_MEDIC_KNEEL'] = true, (lsd grinding first location)
-- ['WORLD_HUMAN_HAMMERING'] = true, (hammering obviously)
-- ['WORLD_HUMAN_WELDING'] = true, (diamond location)

-- if diamond or some other grinding shit trigger ARMA:playGrindingPickaxe client event

local grindingData = {
    ['Copper'] = {license = 'Copper', miningScenario = '', hasFX = false, firstItem = '', secondItem = '', pickaxe = true},
    ['Limestone'] = {license = 'Limestone', miningScenario = '', hasFX = false, firstItem = '', secondItem = '', pickaxe = true},
    ['Gold'] = {license = 'Gold', miningScenario = '', hasFX = false, firstItem = '', secondItem = '', pickaxe = true},
    ['Weed'] = {license = 'Weed', miningScenario = '', hasFX = false, firstItem = '', secondItem = ''},
    ['Cocaine'] = {license = 'Cocaine', miningScenario = '', hasFX = false, firstItem = '', secondItem = ''},
    ['Meth'] = {license = 'Meth', miningScenario = '', hasFX = false, firstItem = '', secondItem = ''},
    ['Diamond'] = {license = 'Diamond', miningScenario = '', processingScenario = 'WORLD_HUMAN_WELDING', hasFX = false, firstItem = 'Uncut Diamond', secondItem = 'Diamond', pickaxe = true},
    ['Heroin'] = {license = 'Heroin', miningScenario = '', hasFX = false, firstItem = '', secondItem = ''},
    ['LSD'] = {license = 'LSD', miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', processingScenario = 'WORLD_HUMAN_CLIPBOARD', hasFX = false, firstItem = '', secondItem = '', thirdItem = ''},
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
                                    ARMA.tryGetInventoryItem(user_id, v.firstItem, 4, true)
                                    ARMA.giveInventoryItem(user_id, v.secondItem, 1, true)
                                end
                            else
                                ARMAclient.notify(source, {"~r~You do not have enough "..v.firstItem.."."})
                            end
                        elseif grindingtype == 'refinery' then
                            TriggerClientEvent('ARMA:playGrindingScenario', source, 'WORLD_HUMAN_CLIPBOARD', v.hasFX)
                        end
                    end
                end)
            end
        end
    end
end)