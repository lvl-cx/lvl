local jackpotChairs = {
    [0] = false,
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = false,
    [10] = false,
    [11] = false,
    [12] = false,
    [13] = false,
    [14] = false,
    [15] = false,
}
local currentJackpotTotal = 0
local currentJackpotBets = {}

RegisterNetEvent("ARMA:requestJackpotChairData")
AddEventHandler("ARMA:requestJackpotChairData", function()   
    local source = source
    TriggerClientEvent('ARMA:sendJackpotChairData', source, jackpotChairs)
end)

RegisterNetEvent("ARMA:requestSitAtJackpot")
AddEventHandler("ARMA:requestSitAtJackpot", function(chair)   
    local source = source
    local user_id = ARMA.getUserId(source)
    if jackpotChairs[chair] == false then
        jackpotChairs[chair] = user_id
        TriggerClientEvent("ARMA:sitAtJackpotChair", source, chair)
    end
end)

RegisterNetEvent("ARMA:leaveJackpotChair")
AddEventHandler("ARMA:leaveJackpotChair", function()   
    local source = source
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(jackpotChairs) do
        if v == user_id then
            jackpotChairs[k] = false
        end
    end
end)

RegisterNetEvent("ARMA:setJackpotBet")
AddEventHandler("ARMA:setJackpotBet", function(betAmount)   
    local source = source
    local user_id = ARMA.getUserId(source)
    -- trigger ARMA:newJackpotBet on -1 source with bet info like 
    -- info: centerXPos, rectLength, tickets_end, tickets_start, .colour.r, .colour.g, .colour.b, .colour.a, user_id 
end)

-- triggerclient ARMA:updatePlayerWinChance(winChance) (loop through all people in current jackpot and send them their win chance)
-- triggerclient ARMA:updateTotalPot(currentJackpotTotal) on -1 source

-- when jackpot ends
-- trigger ARMA:cleanupJackpot on -1 source for all
