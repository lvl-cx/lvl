local outfitCodes = {}

RegisterNetEvent("OASIS:saveWardrobeOutfit")
AddEventHandler("OASIS:saveWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = OASIS.getUserId(source)
    OASIS.getUData(user_id, "OASIS:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        OASISclient.getCustomization(source,{},function(custom)
            sets[outfitName] = custom
            OASIS.setUData(user_id,"OASIS:home:wardrobe",json.encode(sets))
            OASISclient.notify(source,{"~g~Saved outfit "..outfitName.." to wardrobe!"})
            TriggerClientEvent("OASIS:refreshOutfitMenu", source, sets)
        end)
    end)
end)

RegisterNetEvent("OASIS:deleteWardrobeOutfit")
AddEventHandler("OASIS:deleteWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = OASIS.getUserId(source)
    OASIS.getUData(user_id, "OASIS:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        sets[outfitName] = nil
        OASIS.setUData(user_id,"OASIS:home:wardrobe",json.encode(sets))
        OASISclient.notify(source,{"~r~Remove outfit "..outfitName.." from wardrobe!"})
        TriggerClientEvent("OASIS:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("OASIS:equipWardrobeOutfit")
AddEventHandler("OASIS:equipWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = OASIS.getUserId(source)
    OASIS.getUData(user_id, "OASIS:home:wardrobe", function(data)
        local sets = json.decode(data)
        OASISclient.setCustomization(source, {sets[outfitName]})
        OASISclient.getHairAndTats(source, {})
    end)
end)

RegisterNetEvent("OASIS:initWardrobe")
AddEventHandler("OASIS:initWardrobe", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    OASIS.getUData(user_id, "OASIS:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        TriggerClientEvent("OASIS:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("OASIS:getCurrentOutfitCode")
AddEventHandler("OASIS:getCurrentOutfitCode", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    OASISclient.getCustomization(source,{},function(custom)
        OASISclient.generateUUID(source, {"outfitcode", 5, "alphanumeric"}, function(uuid)
            local uuid = string.upper(uuid)
            outfitCodes[uuid] = custom
            OASISclient.CopyToClipBoard(source, {uuid})
            OASISclient.notify(source, {"~g~Outfit code copied to clipboard."})
            OASISclient.notify(source, {"The code ~y~"..uuid.."~w~ will persist until restart."})
        end)
    end)
end)

RegisterNetEvent("OASIS:applyOutfitCode")
AddEventHandler("OASIS:applyOutfitCode", function(outfitCode)
    local source = source
    local user_id = OASIS.getUserId(source)
    if outfitCodes[outfitCode] ~= nil then
        OASISclient.setCustomization(source, {outfitCodes[outfitCode]})
        OASISclient.notify(source, {"~g~Outfit code applied."})
        OASISclient.getHairAndTats(source, {})
    else
        OASISclient.notify(source, {"~r~Outfit code not found."})
    end
end)

RegisterCommand('wardrobe', function(source)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasGroup(user_id, 'Founder') then
        TriggerClientEvent("OASIS:openOutfitMenu", source)
    end
end)

RegisterCommand('copyfit', function(source, args)
    local source = source
    local user_id = OASIS.getUserId(source)
    local permid = tonumber(args[1])
    if OASIS.hasGroup(user_id, 'Founder') then
        OASISclient.getCustomization(OASIS.getUserSource(permid),{},function(custom)
            OASISclient.setCustomization(source, {custom})
        end)
    end
end)