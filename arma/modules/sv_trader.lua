local grindBoost = 1.0

local defaultPrices = {
    ["Weed"] = math.floor(1500*grindBoost),
    ["Cocaine"] = math.floor(2500*grindBoost),
    ["Meth"] = math.floor(3000*grindBoost),
    ["Heroin"] = math.floor(10000*grindBoost),
    ["LSDNorth"] = math.floor(18000*grindBoost),
    ["LSDSouth"] = math.floor(18000*grindBoost),
    ["Copper"] = math.floor(1000*grindBoost),
    ["Limestone"] = math.floor(2000*grindBoost),
    ["Gold"] = math.floor(4000*grindBoost),
    ["Diamond"] = math.floor(8000*grindBoost),
}

function ARMA.getCommissionPrice(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            if v.commission == 0 then
                return defaultPrices[drugtype]
            else
                return defaultPrices[drugtype]-defaultPrices[drugtype]*v.commission/100
            end
        end
    end
end

function ARMA.getCommission(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            return v.commission
        end
    end
end

function ARMA.updateTraderInfo()
    TriggerClientEvent('ARMA:updateTraderCommissions', -1, 
    ARMA.getCommission('Weed'),
    ARMA.getCommission('Cocaine'),
    ARMA.getCommission('Meth'),
    ARMA.getCommission('Heroin'),
    ARMA.getCommission('LargeArms'),
    ARMA.getCommission('LSDNorth'),
    ARMA.getCommission('LSDSouth'))
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

RegisterNetEvent('ARMA:requestDrugPriceUpdate')
AddEventHandler('ARMA:requestDrugPriceUpdate', function()
    local source = source
	local user_id = ARMA.getUserId(source)
    TriggerClientEvent('ARMA:updateTraderCommissions', source, 
    ARMA.getCommission('Weed'),
    ARMA.getCommission('Cocaine'),
    ARMA.getCommission('Meth'),
    ARMA.getCommission('Heroin'),
    ARMA.getCommission('LSDNorth'),
    ARMA.getCommission('LSDSouth'))
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
        ARMA.tryGetInventoryItem(user_id, 'Copper', 1, false)
        ARMAclient.notify(source, {'~g~Sold Copper for £'..getMoneyStringFormatted(defaultPrices['Copper'])})
        ARMA.giveBankMoney(user_id, defaultPrices['Copper'])
    else
        ARMAclient.notify(source, {'~r~You do not have Copper.'})
    end
end)

RegisterNetEvent('ARMA:sellLimestone')
AddEventHandler('ARMA:sellLimestone', function()
    local source = source
	local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Limestone') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Limestone', 1, false)
        ARMAclient.notify(source, {'~g~Sold Limestone for £'..getMoneyStringFormatted(defaultPrices['Limestone'])})
        ARMA.giveBankMoney(user_id, defaultPrices['Limestone'])
    else
        ARMAclient.notify(source, {'~r~You do not have Limestone.'})
    end
end)

RegisterNetEvent('ARMA:sellGold')
AddEventHandler('ARMA:sellGold', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Gold') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Gold', 1, false)
        ARMAclient.notify(source, {'~g~Sold Gold for £'..getMoneyStringFormatted(defaultPrices['Gold'])})
        ARMA.giveBankMoney(user_id, defaultPrices['Gold'])
    else
        ARMAclient.notify(source, {'~r~You do not have Gold.'})
    end
end)

RegisterNetEvent('ARMA:sellDiamond')
AddEventHandler('ARMA:sellDiamond', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Diamond') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Diamond', 1, false)
        ARMAclient.notify(source, {'~g~Sold Diamond for £'..getMoneyStringFormatted(defaultPrices['Diamond'])})
        ARMA.giveBankMoney(user_id, defaultPrices['Diamond'])
    else
        ARMAclient.notify(source, {'~r~You do not have Diamond.'})
    end
end)

RegisterNetEvent('ARMA:sellWeed')
AddEventHandler('ARMA:sellWeed', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Weed') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Weed', 1, false)
        ARMAclient.notify(source, {'~g~Sold Weed for £'..getMoneyStringFormatted(ARMA.getCommissionPrice('Weed'))})
        ARMA.giveMoney(user_id, ARMA.getCommissionPrice('Weed'))
        ARMA.turfSaleToGangFunds(ARMA.getCommissionPrice('Weed'), 'Weed')
    else
        ARMAclient.notify(source, {'~r~You do not have Weed.'})
    end
end)

RegisterNetEvent('ARMA:sellCocaine')
AddEventHandler('ARMA:sellCocaine', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Cocaine') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Cocaine', 1, false)
        ARMAclient.notify(source, {'~g~Sold Cocaine for £'..getMoneyStringFormatted(ARMA.getCommissionPrice('Cocaine'))})
        ARMA.giveMoney(user_id, ARMA.getCommissionPrice('Cocaine'))
        ARMA.turfSaleToGangFunds(ARMA.getCommissionPrice('Cocaine'), 'Cocaine')
    else
        ARMAclient.notify(source, {'~r~You do not have Cocaine.'})
    end
end)

RegisterNetEvent('ARMA:sellMeth')
AddEventHandler('ARMA:sellMeth', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Meth') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Meth', 1, false)
        ARMAclient.notify(source, {'~g~Sold Meth for £'..getMoneyStringFormatted(ARMA.getCommissionPrice('Meth'))})
        ARMA.giveMoney(user_id, ARMA.getCommissionPrice('Meth'))
        ARMA.turfSaleToGangFunds(ARMA.getCommissionPrice('Meth'), 'Meth')
    else
        ARMAclient.notify(source, {'~r~You do not have Meth.'})
    end
end)

RegisterNetEvent('ARMA:sellHeroin')
AddEventHandler('ARMA:sellHeroin', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Heroin') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'Heroin', 1, false)
        ARMAclient.notify(source, {'~g~Sold Heroin for £'..getMoneyStringFormatted(ARMA.getCommissionPrice('Heroin'))})
        ARMA.giveMoney(user_id, ARMA.getCommissionPrice('Heroin'))
        ARMA.turfSaleToGangFunds(ARMA.getCommissionPrice('Heroin'), 'Heroin')
    else
        ARMAclient.notify(source, {'~r~You do not have Heroin.'})
    end
end)

RegisterNetEvent('ARMA:sellLSDNorth')
AddEventHandler('ARMA:sellLSDNorth', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'LSD') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'LSD', 1, false)
        ARMAclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(ARMA.getCommissionPrice('LSDNorth'))})
        ARMA.giveMoney(user_id, ARMA.getCommissionPrice('LSDNorth'))
        ARMA.turfSaleToGangFunds(ARMA.getCommissionPrice('LSDNorth'), 'LSDNorth')
    else
        ARMAclient.notify(source, {'~r~You do not have LSD.'})
    end
end)

RegisterNetEvent('ARMA:sellLSDSouth')
AddEventHandler('ARMA:sellLSDSouth', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'LSD') > 0 then
        ARMA.tryGetInventoryItem(user_id, 'LSD', 1, false)
        ARMAclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(ARMA.getCommissionPrice('LSDSouth'))})
        ARMA.giveMoney(user_id, ARMA.getCommissionPrice('LSDSouth'))
        ARMA.turfSaleToGangFunds(ARMA.getCommissionPrice('LSDSouth'), 'LSDSouth')
    else
        ARMAclient.notify(source, {'~r~You do not have LSD.'})
    end
end)

RegisterNetEvent('ARMA:sellAll')
AddEventHandler('ARMA:sellAll', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(defaultPrices) do
        if ARMA.getInventoryItemAmount(user_id, k) > 0 then
            local amount = ARMA.getInventoryItemAmount(user_id, k)
            ARMA.tryGetInventoryItem(user_id, k, amount, false)
            ARMAclient.notify(source, {'~g~Sold '..k..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
            ARMA.giveMoney(user_id, defaultPrices[k]*amount)
        end
    end
end)

RegisterCommand('testitem', function(source,args)
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id == 1 then
        ARMA.giveInventoryItem(user_id, args[1], 1, true)
    end
end)