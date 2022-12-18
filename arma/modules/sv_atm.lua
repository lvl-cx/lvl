local lang = ARMA.lang
local atms = {
    vector3(89.577018737793,2.16031360626221,68.322021484375),
    vector3(-526.497131347656,-1222.79455566406,18.4549674987793),
    vector3(-2072.48413085938,-317.190521240234,13.315972328186),
    vector3(-821.565551757813,-1081.90270996094,11.1324348449707),
    vector3(1686.74694824219,4815.8828125,42.0085678100586),
    vector3(-386.899444580078,6045.78466796875,31.5001239776611),
    vector3(1171.52319335938,2702.44897460938,38.1754684448242),
    vector3(1968.11157226563,3743.56860351563,32.3437271118164),
    vector3(2558.85815429688,351.045166015625,108.621520996094),
    vector3(1153.75634765625,-326.805023193359,69.2050704956055),
    vector3(-56.9172439575195,-1752.17590332031,29.4210166931152),
    vector3(-3241.02856445313,997.587158203125,12.5503988265991),
    vector3(-1827.1884765625,784.907104492188,138.302581787109),
    vector3(-1091.54748535156,2708.55786132813,18.9437484741211),
    vector3(112.45637512207,-819.25048828125,31.3392715454102),
    vector3(-256.173187255859,-716.031921386719,33.5202751159668),
    vector3(174.227737426758,6637.88623046875,31.5730476379395),
    vector3(-660.727661132813,-853.970336914063,24.484073638916),
    vector3(147.72689819336,-1035.3897705078,29.342636108398),
    vector3(-906.779296875,-2031.4281005859,9.4023332595825),
    vector3(1095.2824707031,244.13655090332,-50.440773010254),
    vector3(-1073.9733886719,-827.63989257812,19.036619186401),
    vector3(1735.4162597656,6410.650390625,35.037200927734),
    vector3(33.325065612793,-1348.1293945312,29.497016906738),
    vector3(-2153.775390625,5236.8115234375,18.772468566895),
}
local organheist = module('cfg/cfg_organheist') 

AddEventHandler("ARMA:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
       TriggerClientEvent('ARMA:setupAtms', source, atms)
    end
end)

local function coordsCheck(coords)
    for i, v in pairs(atms) do
        local atmCoords = vec3(v[1], v[2], v[3])
        for j,k in pairs(organheist.locations) do
            if #(coords - atmCoords) <= 5.0 or #(coords - k.atmLocation) <= 5.0 then
                return true
            end
        end
    end
    return false
end

RegisterNetEvent('ARMA:Withdraw')
AddEventHandler('ARMA:Withdraw', function(amount)
    local source = source
    local amount = parseInt(amount)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if coordsCheck(playerCoords) then
        if amount > 0 then
            local user_id = ARMA.getUserId(source)
            if user_id ~= nil then
                if ARMA.tryWithdraw(user_id, amount) then
                    ARMAclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
                else
                    ARMAclient.notify(source, {lang.atm.withdraw.not_enough()})
                end
            end
        else
            ARMAclient.notify(source, {lang.common.invalid_value()})
        end
    else
        TriggerEvent("ARMA:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Atm Function outside radius')
    end
end)


RegisterNetEvent('ARMA:Deposit')
AddEventHandler('ARMA:Deposit', function(amount)
    local source = source
    local amount = parseInt(amount)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if coordsCheck(playerCoords) then
        if amount > 0 then
            local user_id = ARMA.getUserId(source)
            if user_id ~= nil then
                if ARMA.tryDeposit(user_id, amount) then
                    ARMAclient.notify(source, {lang.atm.deposit.deposited({amount})})
                else
                    ARMAclient.notify(source, {lang.money.not_enough()})
                end
            end
        else
            ARMAclient.notify(source, {lang.common.invalid_value()})
        end
    else
        TriggerEvent("ARMA:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Atm Function outside radius')
    end
end)

RegisterNetEvent('ARMA:WithdrawAll')
AddEventHandler('ARMA:WithdrawAll', function()
    local source = source
    local amount = ARMA.getBankMoney(ARMA.getUserId(source))
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if coordsCheck(playerCoords) then
        if amount > 0 then
            local user_id = ARMA.getUserId(source)
            if user_id ~= nil then
                if ARMA.tryWithdraw(user_id, amount) then
                    ARMAclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
                else
                    ARMAclient.notify(source, {lang.atm.withdraw.not_enough()})
                end
            end
        else
            ARMAclient.notify(source, {lang.common.invalid_value()})
        end
    else
        TriggerEvent("ARMA:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Atm Function outside radius')
    end
end)


RegisterNetEvent('ARMA:DepositAll')
AddEventHandler('ARMA:DepositAll', function()
    local source = source
    local amount = ARMA.getMoney(ARMA.getUserId(source))
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if coordsCheck(playerCoords) then
        if amount > 0 then
            local user_id = ARMA.getUserId(source)
            if user_id ~= nil then
                if ARMA.tryDeposit(user_id, amount) then
                    ARMAclient.notify(source, {lang.atm.deposit.deposited({amount})})
                else
                    ARMAclient.notify(source, {lang.money.not_enough()})
                end
            end
        else
            ARMAclient.notify(source, {lang.common.invalid_value()})
        end
    else
        TriggerEvent("ARMA:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Atm Function outside radius')
    end
end)