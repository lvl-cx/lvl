grindBoost = 2.0

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
    ["Diamond"] = math.floor(7000*grindBoost),
}

function OASIS.getCommissionPrice(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            if v.commission == nil then
                v.commission = 0
            end
            if v.commission == 0 then
                return defaultPrices[drugtype]
            else
                return defaultPrices[drugtype]-defaultPrices[drugtype]*v.commission/100
            end
        end
    end
end

function OASIS.getCommission(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            return v.commission
        end
    end
end

function OASIS.updateTraderInfo()
    TriggerClientEvent('OASIS:updateTraderCommissions', -1, 
    OASIS.getCommission('Weed'),
    OASIS.getCommission('Cocaine'),
    OASIS.getCommission('Meth'),
    OASIS.getCommission('Heroin'),
    OASIS.getCommission('LargeArms'),
    OASIS.getCommission('LSDNorth'),
    OASIS.getCommission('LSDSouth'))
    TriggerClientEvent('OASIS:updateTraderPrices', -1, 
    OASIS.getCommissionPrice('Weed'), 
    OASIS.getCommissionPrice('Cocaine'),
    OASIS.getCommissionPrice('Meth'),
    OASIS.getCommissionPrice('Heroin'),
    OASIS.getCommissionPrice('LSDNorth'),
    OASIS.getCommissionPrice('LSDSouth'),
    defaultPrices['Copper'],
    defaultPrices['Limestone'],
    defaultPrices['Gold'],
    defaultPrices['Diamond'])
end

RegisterNetEvent('OASIS:requestDrugPriceUpdate')
AddEventHandler('OASIS:requestDrugPriceUpdate', function()
    local source = source
	local user_id = OASIS.getUserId(source)
    OASIS.updateTraderInfo()
end)

local function checkTraderBucket(source)
    if GetPlayerRoutingBucket(source) ~= 0 then
        OASISclient.notify(source, {'~r~You cannot sell drugs in this dimension.'})
        return false
    end
    return true
end

RegisterNetEvent('OASIS:sellCopper')
AddEventHandler('OASIS:sellCopper', function()
    local source = source
	local user_id = OASIS.getUserId(source)
    if checkTraderBucket(source) then
        if OASIS.getInventoryItemAmount(user_id, 'Copper') > 0 then
            OASIS.tryGetInventoryItem(user_id, 'Copper', 1, false)
            OASISclient.notify(source, {'~g~Sold Copper for £'..getMoneyStringFormatted(defaultPrices['Copper'])})
            OASIS.giveBankMoney(user_id, defaultPrices['Copper'])
        else
            OASISclient.notify(source, {'~r~You do not have Copper.'})
        end
    end
end)

RegisterNetEvent('OASIS:sellLimestone')
AddEventHandler('OASIS:sellLimestone', function()
    local source = source
	local user_id = OASIS.getUserId(source)
    if checkTraderBucket(source) then
        if OASIS.getInventoryItemAmount(user_id, 'Limestone') > 0 then
            OASIS.tryGetInventoryItem(user_id, 'Limestone', 1, false)
            OASISclient.notify(source, {'~g~Sold Limestone for £'..getMoneyStringFormatted(defaultPrices['Limestone'])})
            OASIS.giveBankMoney(user_id, defaultPrices['Limestone'])
        else
            OASISclient.notify(source, {'~r~You do not have Limestone.'})
        end
    end
end)

RegisterNetEvent('OASIS:sellGold')
AddEventHandler('OASIS:sellGold', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if checkTraderBucket(source) then
        if OASIS.getInventoryItemAmount(user_id, 'Gold') > 0 then
            OASIS.tryGetInventoryItem(user_id, 'Gold', 1, false)
            OASISclient.notify(source, {'~g~Sold Gold for £'..getMoneyStringFormatted(defaultPrices['Gold'])})
            OASIS.giveBankMoney(user_id, defaultPrices['Gold'])
        else
            OASISclient.notify(source, {'~r~You do not have Gold.'})
        end
    end
end)

RegisterNetEvent('OASIS:sellDiamond')
AddEventHandler('OASIS:sellDiamond', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if checkTraderBucket(source) then
        if OASIS.getInventoryItemAmount(user_id, 'Processed Diamond') > 0 then
            OASIS.tryGetInventoryItem(user_id, 'Processed Diamond', 1, false)
            OASISclient.notify(source, {'~g~Sold Processed Diamond for £'..getMoneyStringFormatted(defaultPrices['Diamond'])})
            OASIS.giveBankMoney(user_id, defaultPrices['Diamond'])
        else
            OASISclient.notify(source, {'~r~You do not have Diamond.'})
        end
    end
end)

RegisterNetEvent('OASIS:sellWeed')
AddEventHandler('OASIS:sellWeed', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if checkTraderBucket(source) then
        if OASIS.getInventoryItemAmount(user_id, 'Weed') > 0 then
            OASIS.tryGetInventoryItem(user_id, 'Weed', 1, false)
            OASISclient.notify(source, {'~g~Sold Weed for £'..getMoneyStringFormatted(OASIS.getCommissionPrice('Weed'))})
            OASIS.giveMoney(user_id, OASIS.getCommissionPrice('Weed'))
            OASIS.turfSaleToGangFunds(OASIS.getCommissionPrice('Weed'), 'Weed')
        else
            OASISclient.notify(source, {'~r~You do not have Weed.'})
        end
    end
end)

RegisterNetEvent('OASIS:sellCocaine')
AddEventHandler('OASIS:sellCocaine', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if checkTraderBucket(source) then
        if OASIS.getInventoryItemAmount(user_id, 'Cocaine') > 0 then
            OASIS.tryGetInventoryItem(user_id, 'Cocaine', 1, false)
            OASISclient.notify(source, {'~g~Sold Cocaine for £'..getMoneyStringFormatted(OASIS.getCommissionPrice('Cocaine'))})
            OASIS.giveMoney(user_id, OASIS.getCommissionPrice('Cocaine'))
            OASIS.turfSaleToGangFunds(OASIS.getCommissionPrice('Cocaine'), 'Cocaine')
        else
            OASISclient.notify(source, {'~r~You do not have Cocaine.'})
        end
    end
end)

RegisterNetEvent('OASIS:sellMeth')
AddEventHandler('OASIS:sellMeth', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if checkTraderBucket(source) then
        if OASIS.getInventoryItemAmount(user_id, 'Meth') > 0 then
            OASIS.tryGetInventoryItem(user_id, 'Meth', 1, false)
            OASISclient.notify(source, {'~g~Sold Meth for £'..getMoneyStringFormatted(OASIS.getCommissionPrice('Meth'))})
            OASIS.giveMoney(user_id, OASIS.getCommissionPrice('Meth'))
            OASIS.turfSaleToGangFunds(OASIS.getCommissionPrice('Meth'), 'Meth')
        else
            OASISclient.notify(source, {'~r~You do not have Meth.'})
        end
    end
end)

RegisterNetEvent('OASIS:sellHeroin')
AddEventHandler('OASIS:sellHeroin', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if checkTraderBucket(source) then
        if OASIS.getInventoryItemAmount(user_id, 'Heroin') > 0 then
            OASIS.tryGetInventoryItem(user_id, 'Heroin', 1, false)
            OASISclient.notify(source, {'~g~Sold Heroin for £'..getMoneyStringFormatted(OASIS.getCommissionPrice('Heroin'))})
            OASIS.giveMoney(user_id, OASIS.getCommissionPrice('Heroin'))
            OASIS.turfSaleToGangFunds(OASIS.getCommissionPrice('Heroin'), 'Heroin')
        else
            OASISclient.notify(source, {'~r~You do not have Heroin.'})
        end
    end
end)

RegisterNetEvent('OASIS:sellLSDNorth')
AddEventHandler('OASIS:sellLSDNorth', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if checkTraderBucket(source) then
        if OASIS.getInventoryItemAmount(user_id, 'LSD') > 0 then
            OASIS.tryGetInventoryItem(user_id, 'LSD', 1, false)
            OASISclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(OASIS.getCommissionPrice('LSDNorth'))})
            OASIS.giveMoney(user_id, OASIS.getCommissionPrice('LSDNorth'))
            OASIS.turfSaleToGangFunds(OASIS.getCommissionPrice('LSDNorth'), 'LSDNorth')
        else
            OASISclient.notify(source, {'~r~You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('OASIS:sellLSDSouth')
AddEventHandler('OASIS:sellLSDSouth', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if checkTraderBucket(source) then
        if OASIS.getInventoryItemAmount(user_id, 'LSD') > 0 then
            OASIS.tryGetInventoryItem(user_id, 'LSD', 1, false)
            OASISclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(OASIS.getCommissionPrice('LSDSouth'))})
            OASIS.giveMoney(user_id, OASIS.getCommissionPrice('LSDSouth'))
            OASIS.turfSaleToGangFunds(OASIS.getCommissionPrice('LSDSouth'), 'LSDSouth')
        else
            OASISclient.notify(source, {'~r~You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('OASIS:sellAll')
AddEventHandler('OASIS:sellAll', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if checkTraderBucket(source) then
        for k,v in pairs(defaultPrices) do
            if k == 'Copper' or k == 'Limestone' or k == 'Gold' then
                if OASIS.getInventoryItemAmount(user_id, k) > 0 then
                    local amount = OASIS.getInventoryItemAmount(user_id, k)
                    OASIS.tryGetInventoryItem(user_id, k, amount, false)
                    OASISclient.notify(source, {'~g~Sold '..k..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
                    OASIS.giveBankMoney(user_id, defaultPrices[k]*amount)
                end
            elseif k == 'Diamond' then
                if OASIS.getInventoryItemAmount(user_id, 'Processed Diamond') > 0 then
                    local amount = OASIS.getInventoryItemAmount(user_id, 'Processed Diamond')
                    OASIS.tryGetInventoryItem(user_id, 'Processed Diamond', amount, false)
                    OASISclient.notify(source, {'~g~Sold '..'Processed Diamond'..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
                    OASIS.giveBankMoney(user_id, defaultPrices[k]*amount)
                end
            end
        end
    end
end)

RegisterCommand('testitem', function(source,args)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasGroup(user_id, 'Founder') then
        OASIS.giveInventoryItem(user_id, args[1], 1, true)
    end
end)