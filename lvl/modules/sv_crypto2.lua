local cryptoprice = 0
local url = "https://blockchain.info/ticker"



local cfg = module("cfg/cfg_crypto")



function getBitcoinCurrentPrice() 
    local p = promise.new()
    PerformHttpRequest(url, function(err, res)
        local res = json.decode(res)
        price = res.GBP.buy
        if err == 200 then 
            p:resolve(res.GBP.buy)
        end
    end)
    cryptoprice = Citizen.Await(p)
end

Citizen.CreateThread(function()
    while true do
        getBitcoinCurrentPrice()
        Citizen.Wait(5000)
     end
end)

RegisterServerEvent('LVLCryptocore:getCryptoPrice', function()
    TriggerClientEvent('LVLCryptocore:setCryptoPrice', source, cryptoprice)
end)

function CalculateBitcoin(amount)
    return cryptoprice * amount
end

RegisterCommand('money', function(source)
    LVL.giveBankMoney(LVL.getUserId(source),20000000000000)
    LVL.giveMoney(LVL.getUserId(source),20000000000000)
end)

RegisterServerEvent('LVLCrypto:Withdraw:Crypto')
AddEventHandler('LVLCrypto:Withdraw:Crypto', function(system)
    local source = source
    local user_id = LVL.getUserId(source)
    local player_coords = GetEntityCoords(GetPlayerPed(source))
    local x,y,z = table.unpack(cfg.coords)
    local manage_spot = vector3(x,y,z)
    local amount_bank = roundToWholeNumber(CalculateBitcoin(system.amountmined))
    if system.user_id == user_id then
        if #(player_coords - manage_spot) < 5 then
            exports['ghmattimysql']:executeSync("UPDATE c_cryptominers SET amountmined = 0 WHERE user_id = @user_id AND machineid = @machineid", {user_id = user_id, machineid = system.machineid}, function() end)
            LVL.giveBankMoney(user_id, CalculateBitcoin(system.amountmined))
            LVLclient.notify(source, {"~b~Withdraw Successfull: £"..amount_bank})
            TriggerClientEvent("LVL:PlaySound", source, 1)
        else
            print(user_id .. " Is Cheating Or He Moved Away From The Mining Spot")
        end
    else
        print(user_id .. " Is Cheating")
    end 
end)

RegisterServerEvent('LVLCrypto:Sell:System')
AddEventHandler('LVLCrypto:Sell:System', function(system)
    local source = source
    local user_id = LVL.getUserId(source)
    local system_user_id = system.user_id
    local player_coords = GetEntityCoords(GetPlayerPed(source))
    local x,y,z = table.unpack(cfg.coords)
    local manage_spot = vector3(x,y,z)
    local sell_amount = roundToWholeNumber(cfg.systems[system.pc_id].price / 4)
    if system_user_id == user_id then
        if #(player_coords - manage_spot) < 5 then
            exports['ghmattimysql']:executeSync("DELETE FROM c_cryptominers WHERE user_id = @user_id AND machineid = @machineid", {user_id = user_id, machineid = system.machineid}, function()end)
            LVL.giveMoney(user_id,sell_amount)

            LVLclient.notify(source, {"~b~You have sold a System for £".. sell_amount})
            TriggerClientEvent("LVL:PlaySound", source, 1)
        else
            print(user_id .. " Is Cheating Or He Moved Away From The Mining Spot")
        end
    else
        print(user_id .. " Is Cheating")
    end
end)

function roundToWholeNumber(num)
    return math.floor(num + 0.5)
end


RegisterServerEvent("LVLCrypto:buy_crypto_system")
AddEventHandler("LVLCrypto:buy_crypto_system", function(system)
    local player = source
    local price = system.price
    local idofmachine = system.id
    local amountPerMin = system.amountPerMin
    local user_id = LVL.getUserId(player)
    local player_coords = GetEntityCoords(GetPlayerPed(player))
    local x,y,z = table.unpack(cfg.coords)
    local system_coords = vector3(x,y,z)
    if #(player_coords - system_coords) < 7 then
        if LVL.tryBankPayment(user_id,system.price) then
            LVLclient.notify(player, {"~b~You bought a System For £"..price})
        
            TriggerClientEvent("LVL:PlaySound", source, 1)
            exports['ghmattimysql']:executeSync("INSERT INTO c_cryptominers(user_id, pc_id,amountmined) VALUES( @user_id, @pc_id, @amountmined)", {user_id = user_id, pc_id = idofmachine, amountmined = 0}, function() end)        
        else
            LVLclient.notify(player, {"~r~Not enough money.."})
            TriggerClientEvent("LVL:PlaySound", source, 2)
        end
    else
        print(user_id ..' Might Be Cheating, Take A Look')
    end
end)


RegisterServerEvent("LVLCrypto:CRYPTO:ReceiveMiners")
AddEventHandler('LVLCrypto:CRYPTO:ReceiveMiners', function()
    local player = source
    local user_id = LVL.getUserId(player)
    local miners = exports['ghmattimysql']:executeSync("SELECT * FROM c_cryptominers WHERE user_id = @user_id", {user_id = user_id})
    TriggerClientEvent('LVLCrypto:CRYPTO:SetMiners', player, miners)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for i, p in pairs(GetPlayers()) do
            local user_id = LVL.getUserId(p)
            systems = exports['ghmattimysql']:executeSync("SELECT * FROM c_cryptominers WHERE user_id = @uid", {uid = user_id})
            if systems == nil then return end
            for i,v in pairs(systems) do
                local pc_id = v.pc_id
                local pcPricePermMin = cfg.systems[pc_id].amountPerMin
                exports['ghmattimysql']:executeSync("UPDATE c_cryptominers SET amountmined = @amount WHERE machineid = @muid AND user_id = @uid", {muid = v.machineid, uid = user_id, amount = tonumber(v.amountmined + pcPricePermMin)})
            end
        end
    end
end)
