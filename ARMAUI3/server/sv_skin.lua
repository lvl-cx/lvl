local Tunnel = module("arma", "lib/Tunnel")
local Proxy = module("arma", "lib/Proxy")

ARMA = Proxy.getInterface("ARMA")
ARMAclient = Tunnel.getInterface("ARMA","ARMA")

RegisterNetEvent("ARMA:saveFaceData")
AddEventHandler("ARMA:saveFaceData", function(faceSaveData)
    local source = source
    local user_id = ARMA.getUserId({source})
    ARMA.setUData({user_id, "ARMA:Face:Data", json.encode(faceSaveData)})
end)

RegisterNetEvent("ARMA:saveClothingHairData") -- this updates hair from clothing stores
AddEventHandler("ARMA:saveClothingHairData", function(hairtype, haircolour)
    local source = source
    local user_id = ARMA.getUserId({source})
    facesavedata = {}
    ARMA.getUData({user_id, "ARMA:Face:Data", function(data)
        if data ~= nil and hairtype ~= nil and haircolour ~= nil then
            facesavedata = json.decode(data)
            facesavedata["hair"] = hairtype
            facesavedata["haircolor"] = haircolour
            ARMA.setUData({user_id, "ARMA:Face:Data", json.encode(facesavedata)})
        end
    end})
end)

RegisterNetEvent("ARMA:changeHairStyle")
AddEventHandler("ARMA:changeHairStyle", function()
    local source = source
    local user_id = ARMA.getUserId({source})

    ARMA.getUData({user_id, "ARMA:Face:Data", function(data)
        if data ~= nil then
            TriggerClientEvent("ARMA:setHairstyle", source, json.decode(data))
        end
    end})
end)

AddEventHandler("ARMA:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = ARMA.getUserId({source})
        ARMA.getUData({user_id, "ARMA:Face:Data", function(data)
            if data ~= nil then
                TriggerClientEvent("ARMA:setHairstyle", source, json.decode(data))
            end
        end})
    end)
end)