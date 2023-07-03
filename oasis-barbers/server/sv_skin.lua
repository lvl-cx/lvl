local Tunnel = module("oasis", "lib/Tunnel")
local Proxy = module("oasis", "lib/Proxy")

OASIS = Proxy.getInterface("OASIS")
OASISclient = Tunnel.getInterface("OASIS","OASIS")

RegisterNetEvent("OASIS:saveFaceData")
AddEventHandler("OASIS:saveFaceData", function(faceSaveData)
    local source = source
    local user_id = OASIS.getUserId({source})
    OASIS.setUData({user_id, "OASIS:Face:Data", json.encode(faceSaveData)})
end)

RegisterNetEvent("OASIS:saveClothingHairData") -- this updates hair from clothing stores
AddEventHandler("OASIS:saveClothingHairData", function(hairtype, haircolour)
    local source = source
    local user_id = OASIS.getUserId({source})
    local facesavedata = {}
    OASIS.getUData({user_id, "OASIS:Face:Data", function(data)
        if data ~= nil and data ~= 0 and hairtype ~= nil and haircolour ~= nil then
            facesavedata = json.decode(data)
            if facesavedata == nil then
                facesavedata = {}
            end
            facesavedata["hair"] = hairtype
            facesavedata["haircolor"] = haircolour
            OASIS.setUData({user_id, "OASIS:Face:Data", json.encode(facesavedata)})
        end
    end})
end)

RegisterNetEvent("OASIS:changeHairstyle")
AddEventHandler("OASIS:changeHairstyle", function()
    local source = source
    local user_id = OASIS.getUserId({source})
    OASIS.getUData({user_id, "OASIS:Face:Data", function(data)
        if data ~= nil and data ~= 0 then
            TriggerClientEvent("OASIS:setHairstyle", source, json.decode(data))
        end
    end})
end)

AddEventHandler("OASIS:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = OASIS.getUserId({source})
        OASIS.getUData({user_id, "OASIS:Face:Data", function(data)
            if data ~= nil and data ~= 0 then
                TriggerClientEvent("OASIS:setHairstyle", source, json.decode(data))
            end
        end})
    end)
end)