local grindBoost = 1.0

local commissions = {
    ["Weed"] = 0,
    ["Cocaine"] = 0,
    ["Meth"] = 0,
    ["Heroin"] = 0,
    ["LSDNorth"] = 0,
    ["LSDSouth"] = 0,
}

local defaultPrices = {
    ["Weed"] = 1500*grindBoost,
    ["Cocaine"] = 2500*grindBoost,
    ["Meth"] = 3000*grindBoost,
    ["Heroin"] = 10000*grindBoost,
    ["LSDNorth"] = 18000*grindBoost,
    ["LSDSouth"] = 18000*grindBoost,
    ["Copper"] = 1000*grindBoost,
    ["Limestone"] = 2000*grindBoost,
    ["Gold"] = 4000*grindBoost,
    ["Diamond"] = 8000*grindBoost,
}

function ARMA.getCommissionPrice(drugtype)
    return defaultPrices[drugtype]-defaultPrices[drugtype]*commissions[drugtype]/100
end

function ARMA.updateCommission(type, amount)
    for k,v in pairs(commissions) do
        if k == type then
            commissions[k] = amount
            TriggerClientEvent('ARMA:updateTraderCommissions', -1, 
            commissions['Weed'], 
            commissions['Cocaine'], 
            commissions['Meth'], 
            commissions['Heroin'], 
            commissions['LSDNorth'], 
            commissions['LSDSouth'])
            TriggerClientEvent('ARMA:updateTraderPrices', -1, 
            ARMA.getCommissionPrice('Weed'), 
            ARMA.getCommissionPrice('Cocaine'),
            ARMA.getCommissionPrice('Meth'),
            ARMA.getCommissionPrice('Heroin'),
            ARMA.getCommissionPrice('LSDNorth'),
            ARMA.getCommissionPrice('LSDSouth'),
            defaultPrices['Copper'],
            defaultPrices['Limestone'],
            defaultPrices['Gold'],
            defaultPrices['Diamond'])
        end
    end
end

RegisterNetEvent('ARMA:requestDrugPriceUpdate')
AddEventHandler('ARMA:requestDrugPriceUpdate', function()
    local source = source
	local user_id = ARMA.getUserId(source)
    TriggerClientEvent('ARMA:updateTraderCommissions', source, 
    commissions['Weed'], 
    commissions['Cocaine'], 
    commissions['Meth'], 
    commissions['Heroin'], 
    commissions['LSDNorth'], 
    commissions['LSDSouth'])
    TriggerClientEvent('ARMA:updateTraderPrices', source, 
    ARMA.getCommissionPrice('Weed'), 
    ARMA.getCommissionPrice('Cocaine'),
    ARMA.getCommissionPrice('Meth'),
    ARMA.getCommissionPrice('Heroin'),
    ARMA.getCommissionPrice('LSDNorth'),
    ARMA.getCommissionPrice('LSDSouth'),
    defaultPrices['Copper'],
    defaultPrices['Limestone'],
    defaultPrices['Gold'],
    defaultPrices['Diamond'])
end)

RegisterNetEvent('ARMA:sellCopper')
AddEventHandler('ARMA:sellCopper', function()
    local source = source
	local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Copper') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Copper', 1)
        ARMAclient.notify(source, '~g~Sold Copper for £'..getMoneyStringFormatted(defaultPrices['Copper']))
        ARMA.giveBankMoney(user_id, defaultPrices['Copper'])
    else
        ARMAclient.notify(source, '~r~You do not have Copper.')
    end
end)

RegisterNetEvent('ARMA:sellLimestone')
AddEventHandler('ARMA:sellLimestone', function()
    local source = source
	local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Limestone') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Limestone', 1)
        ARMAclient.notify(source, '~g~Sold Limestone for £'..getMoneyStringFormatted(defaultPrices['Limestone']))
        ARMA.giveBankMoney(user_id, defaultPrices['Limestone'])
    else
        ARMAclient.notify(source, '~r~You do not have Limestone.')
    end
end)

RegisterNetEvent('ARMA:sellGold')
AddEventHandler('ARMA:sellGold', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Gold') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Gold', 1)
        ARMAclient.notify(source, '~g~Sold Gold for £'..getMoneyStringFormatted(defaultPrices['Gold']))
        ARMA.giveBankMoney(user_id, defaultPrices['Gold'])
    else
        ARMAclient.notify(source, '~r~You do not have Gold.')
    end
end)

RegisterNetEvent('ARMA:sellDiamond')
AddEventHandler('ARMA:sellDiamond', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Diamond') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Diamond', 1)
        ARMAclient.notify(source, '~g~Sold Diamond for £'..getMoneyStringFormatted(defaultPrices['Diamond']))
        ARMA.giveBankMoney(user_id, defaultPrices['Diamond'])
    else
        ARMAclient.notify(source, '~r~You do not have Diamond.')
    end
end)

RegisterNetEvent('ARMA:sellWeed')
AddEventHandler('ARMA:sellWeed', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Weed') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Weed', 1)
        ARMAclient.notify(source, '~g~Sold Weed for £'..getMoneyStringFormatted(ARMA.getCommissionPrice('Weed')))
        ARMA.giveMoney(user_id, ARMA.getCommissionPrice('Weed'))
    else
        ARMAclient.notify(source, '~r~You do not have Weed.')
    end
end)

RegisterNetEvent('ARMA:sellCocaine')
AddEventHandler('ARMA:sellCocaine', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Cocaine') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Cocaine', 1)
        ARMAclient.notify(source, '~g~Sold Cocaine for £'..getMoneyStringFormatted(ARMA.getCommissionPrice('Cocaine')))
        ARMA.giveMoney(user_id, ARMA.getCommissionPrice('Cocaine'))
    else
        ARMAclient.notify(source, '~r~You do not have Cocaine.')
    end
end)

RegisterNetEvent('ARMA:sellMeth')
AddEventHandler('ARMA:sellMeth', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Meth') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Meth', 1)
        ARMAclient.notify(source, '~g~Sold Meth for £'..getMoneyStringFormatted(ARMA.getCommissionPrice('Meth')))
        ARMA.giveMoney(user_id, ARMA.getCommissionPrice('Meth'))
    else
        ARMAclient.notify(source, '~r~You do not have Meth.')
    end
end)

RegisterNetEvent('ARMA:sellHeroin')
AddEventHandler('ARMA:sellHeroin', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Heroin') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Heroin', 1)
        ARMAclient.notify(source, '~g~Sold Heroin for £'..getMoneyStringFormatted(ARMA.getCommissionPrice('Heroin')))
        ARMA.giveMoney(user_id, ARMA.getCommissionPrice('Heroin'))
    else
        ARMAclient.notify(source, '~r~You do not have Heroin.')
    end
end)

RegisterNetEvent('ARMA:sellLSDNorth')
AddEventHandler('ARMA:sellLSDNorth', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'LSDNorth') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'LSDNorth', 1)
        ARMAclient.notify(source, '~g~Sold LSDNorth for £'..getMoneyStringFormatted(ARMA.getCommissionPrice('LSDNorth')))
        ARMA.giveMoney(user_id, ARMA.getCommissionPrice('LSDNorth'))
    else
        ARMAclient.notify(source, '~r~You do not have LSD.')
    end
end)

RegisterNetEvent('ARMA:sellLSDSouth')
AddEventHandler('ARMA:sellLSDSouth', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'LSDSouth') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'LSDSouth', 1)
        ARMAclient.notify(source, '~g~Sold LSDSouth for £'..getMoneyStringFormatted(ARMA.getCommissionPrice('LSDSouth')))
        ARMA.giveMoney(user_id, ARMA.getCommissionPrice('LSDSouth'))
    else
        ARMAclient.notify(source, '~r~You do not have LSD.')
    end
end)