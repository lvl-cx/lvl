local trainingWorlds = {}
local trainingWorldsCount = 0
RegisterCommand('trainingworlds', function(source)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') then
        TriggerClientEvent('OASIS:trainingWorldSendAll', source, trainingWorlds)
        TriggerClientEvent('OASIS:trainingWorldOpen', source, OASIS.hasPermission(user_id, 'police.announce'))
    end
end)

RegisterNetEvent("OASIS:trainingWorldCreate")
AddEventHandler("OASIS:trainingWorldCreate", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    trainingWorldsCount = trainingWorldsCount + 1
    OASIS.prompt(source,"World Name:","",function(player,worldname) 
        if string.gsub(worldname, "%s+", "") ~= '' then
            if next(trainingWorlds) then
                for k,v in pairs(trainingWorlds) do
                    if v.name == worldname then
                        OASISclient.notify(source, {"~r~This world name already exists."})
                        return
                    elseif v.ownerUserId == user_id then
                        OASISclient.notify(source, {"~r~You already have a world, please delete it first."})
                        return
                    end
                end
            end
            OASIS.prompt(source,"World Password:","",function(player,password) 
                trainingWorlds[trainingWorldsCount] = {name = worldname, ownerName = GetPlayerName(source), ownerUserId = user_id, bucket = trainingWorldsCount, members = {}, password = password}
                table.insert(trainingWorlds[trainingWorldsCount].members, user_id)
                tOASIS.setBucket(source, trainingWorldsCount)
                TriggerClientEvent('OASIS:trainingWorldSend', -1, trainingWorldsCount, trainingWorlds[trainingWorldsCount])
                OASISclient.notify(source, {'~g~Training World Created!'})
            end)
        else
            OASISclient.notify(source, {"~r~Invalid World Name."})
        end
    end)
end)

RegisterNetEvent("OASIS:trainingWorldRemove")
AddEventHandler("OASIS:trainingWorldRemove", function(world)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.announce') then
        if trainingWorlds[world] ~= nil then
            TriggerClientEvent('OASIS:trainingWorldRemove', -1, world)
            for k,v in pairs(trainingWorlds[world].members) do
                local memberSource = OASIS.getUserSource(v)
                if memberSource ~= nil then
                    tOASIS.setBucket(memberSource, 0)
                    OASISclient.notify(memberSource, {"~b~The training world you were in was deleted, you have been returned to the main dimension."})
                end
            end
            trainingWorlds[world] = nil
        end
    end
end)

RegisterNetEvent("OASIS:trainingWorldJoin")
AddEventHandler("OASIS:trainingWorldJoin", function(world)
    local source = source
    local user_id = OASIS.getUserId(source)
    OASIS.prompt(source,"Enter Password:","",function(player,password) 
        if password ~= trainingWorlds[world].password then
            OASISclient.notify(source, {"~r~Invalid Password."})
            return
        else
            tOASIS.setBucket(source, world)
            table.insert(trainingWorlds[world].members, user_id)
            OASISclient.notify(source, {"~b~You have joined training world "..trainingWorlds[world].name..' owned by '..trainingWorlds[world].ownerName..'.'})
        end
    end)
end)

RegisterNetEvent("OASIS:trainingWorldLeave")
AddEventHandler("OASIS:trainingWorldLeave", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    tOASIS.setBucket(source, 0)
    OASISclient.notify(source, {"~b~You have left the training world."})
end)

