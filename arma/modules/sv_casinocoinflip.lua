local coinflipTables = {
    [0] = false,
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
    [7] = false,
}

local coinflipGameInProgress = {}
local coinflipGameData = {}

local betId = 0

function giveChips(source,amount)
    local user_id = ARMA.getUserId(source)
    MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
    TriggerClientEvent('ARMA:chipsUpdated', source)
end

AddEventHandler('playerDropped', function (reason)
    local source = source
    for k,v in pairs(coinflipTables) do
        if v == source then
            coinflipTables[k] = false
        end
    end
end)

RegisterNetEvent("ARMA:requestCoinflipTableData")
AddEventHandler("ARMA:requestCoinflipTableData", function()   
    local source = source
    TriggerClientEvent("ARMA:sendCoinflipTableData",source,coinflipTables)
end)

RegisterNetEvent("ARMA:requestSitAtCoinflipTable")
AddEventHandler("ARMA:requestSitAtCoinflipTable", function(chairId)
    local source = source
    if source ~= nil then
        for k,v in pairs(coinflipTables) do
            if v == source then
                coinflipTables[k] = false
                return
            end
        end
        coinflipTables[chairId] = source
        currentBetForThatTable = coinflipGameData[chairId]
        TriggerClientEvent("ARMA:sendCoinflipTableData",-1,coinflipTables)
        TriggerClientEvent("ARMA:sitAtCoinflipTable",source,chairId,currentBetForThatTable)
    end
end)

RegisterNetEvent("ARMA:leaveCoinflipTable")
AddEventHandler("ARMA:leaveCoinflipTable", function(chairId)
    local source = source
    if source ~= nil then 
        for k,v in pairs(coinflipTables) do 
            if v == source then 
                coinflipTables[k] = false
            end
        end
        TriggerClientEvent("ARMA:sendCoinflipTableData",-1,coinflipTables)
    end
end)

RegisterNetEvent("ARMA:proposeCoinflip")
AddEventHandler("ARMA:proposeCoinflip",function(betAmount)
    local source = source
    local user_id = ARMA.getUserId(source)
    betId = betId+1
    if betAmount ~= nil then 
        if coinflipGameData[betId] == nil then
            coinflipGameData[betId] = {}
        end
        if not coinflipGameInProgress[betId] then
            if tonumber(betAmount) then
                betAmount = tonumber(betAmount)
                if betAmount >= 100000 then
                    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
                        chips = rows[1].chips
                        if chips >= betAmount then
                            --MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = betAmount})
                            TriggerClientEvent('ARMA:chipsUpdated', source)
                            if coinflipGameData[betId][source] == nil then
                                coinflipGameData[betId][source] = {}
                            end
                            coinflipGameData[betId] = {betId = betId, betAmount = betAmount, user_id = user_id}
                            TriggerClientEvent('ARMA:addCoinflipProposal', -1, betId, {betId = betId, betAmount = betAmount, user_id = user_id})
                            ARMAclient.notify(source,{"~g~Bet placed: " .. tostring(betAmount) .. " chips."})
                        else 
                            ARMAclient.notify(source,{"~r~Not enough chips!"})
                        end
                    end)
                else
                    ARMAclient.notify(source,{'~r~Minimum bet at this table is £100,000.'})
                    return
                end
            end
        end
    else
       ARMAclient.notify(source,{"~r~Error betting!"})
    end
end)

RegisterNetEvent("ARMA:requestCoinflipTableData")
AddEventHandler("ARMA:requestCoinflipTableData", function()   
    local source = source
    TriggerClientEvent("ARMA:sendCoinflipTableData",source,coinflipTables)
end)

RegisterNetEvent("ARMA:cancelCoinflip")
AddEventHandler("ARMA:cancelCoinflip", function()   
    local source = source
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(coinflipGameData) do
        if v.user_id == user_id then
            coinflipGameData[k] = nil
            TriggerClientEvent("ARMA:cancelCoinflipBet",-1,k)
        end
    end
end)
