local Tunnel = module("arma", "lib/Tunnel")
local Proxy = module("arma", "lib/Proxy")
local ARMA = Proxy.getInterface("ARMA")
local ARMAclient = Tunnel.getInterface("ARMA","ARMA")

RegisterNetEvent("ARMA:saveTattoos")
AddEventHandler("ARMA:saveTattoos", function(TattooSaveddata)
    local source = source
    local user_id = ARMA.getUserId({source})
    print(json.encode(TattooSaveddata))
    ARMA.setUData({user_id, "ARMA:Tattoo:Data", json.encode(TattooSaveddata)})
end)

RegisterNetEvent("ARMA:changeTattoos")
AddEventHandler("ARMA:changeTattoos", function()
    local source = source
    local user_id = ARMA.getUserId({source})
    ARMA.getUData({user_id, "ARMA:Tattoo:Data", function(data)
        if data ~= nil then
            TriggerClientEvent("ARMA:setTattoos", source, json.decode(data))
        end
    end})
end)
AddEventHandler("ARMA:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = ARMA.getUserId({source})
        ARMA.getUData({user_id, "ARMA:Tattoo:Data", function(data)
            if data ~= nil then
                TriggerClientEvent("ARMA:setTattoos", source, json.decode(data))
            end
        end})
    end)
end)

