local outfitCodes = {}

RegisterNetEvent("ARMA:saveWardrobeOutfit")
AddEventHandler("ARMA:saveWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMA.getUData(user_id, "ARMA:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        ARMAclient.getCustomization(source,{},function(custom)
            sets[outfitName] = custom
            ARMA.setUData(user_id,"ARMA:home:wardrobe",json.encode(sets))
            ARMAclient.notify(source,{"~g~Saved outfit "..outfitName.." to wardrobe!"})
            TriggerClientEvent("ARMA:refreshOutfitMenu", source, sets)
        end)
    end)
end)

RegisterNetEvent("ARMA:deleteWardrobeOutfit")
AddEventHandler("ARMA:deleteWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMA.getUData(user_id, "ARMA:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        sets[outfitName] = nil
        ARMA.setUData(user_id,"ARMA:home:wardrobe",json.encode(sets))
        ARMAclient.notify(source,{"~r~Remove outfit "..outfitName.." from wardrobe!"})
        TriggerClientEvent("ARMA:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("ARMA:equipWardrobeOutfit")
AddEventHandler("ARMA:equipWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMA.getUData(user_id, "ARMA:home:wardrobe", function(data)
        local sets = json.decode(data)
        ARMAclient.setCustomization(source, {sets[outfitName]})
        ARMAclient.getHairAndTats(source, {})
    end)
end)

RegisterNetEvent("ARMA:initWardrobe")
AddEventHandler("ARMA:initWardrobe", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMA.getUData(user_id, "ARMA:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        TriggerClientEvent("ARMA:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("ARMA:getCurrentOutfitCode")
AddEventHandler("ARMA:getCurrentOutfitCode", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMAclient.getCustomization(source,{},function(custom)
        ARMAclient.generateUUID(source, {"outfitcode", 5, "alphanumeric"}, function(uuid)
            local uuid = string.upper(uuid)
            outfitCodes[uuid] = custom
            ARMAclient.CopyToClipBoard(source, {uuid})
            ARMAclient.notify(source, {"~g~Outfit code copied to clipboard."})
            ARMAclient.notify(source, {"The code ~y~"..uuid.."~w~ will persist until restart."})
        end)
    end)
end)

RegisterNetEvent("ARMA:applyOutfitCode")
AddEventHandler("ARMA:applyOutfitCode", function(outfitCode)
    local source = source
    local user_id = ARMA.getUserId(source)
    if outfitCodes[outfitCode] ~= nil then
        ARMAclient.setCustomization(source, {outfitCodes[outfitCode]})
        ARMAclient.notify(source, {"~g~Outfit code applied."})
        ARMAclient.getHairAndTats(source, {})
    else
        ARMAclient.notify(source, {"~r~Outfit code not found."})
    end
end)

RegisterCommand('wardrobe', function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id == 1 then
        TriggerClientEvent("ARMA:openOutfitMenu", source)
    end
end)

RegisterCommand('copyfit', function(source, args)
    local source = source
    local user_id = ARMA.getUserId(source)
    local permid = tonumber(args[1])
    if user_id == 1 then
        ARMAclient.getCustomization(ARMA.getUserSource(permid),{},function(custom)
            ARMAclient.setCustomization(source, {custom})
        end)
    end
end)