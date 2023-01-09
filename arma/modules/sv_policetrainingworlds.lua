local trainingWorlds = {}
local trainingWorldsCount = 0
RegisterCommand('trainingworlds', function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
        TriggerClientEvent('ARMA:trainingWorldSendAll', source, trainingWorlds)
        TriggerClientEvent('ARMA:trainingWorldOpen', source, ARMA.hasPermission(user_id, 'police.announce'))
    end
end)

RegisterNetEvent("ARMA:trainingWorldCreate")
AddEventHandler("ARMA:trainingWorldCreate", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    trainingWorldsCount = trainingWorldsCount + 1
    ARMA.prompt(source,"World Name:","",function(player,worldname) 
        if string.gsub(worldname, "%s+", "") ~= '' then
            if next(trainingWorlds) then
                for k,v in pairs(trainingWorlds) do
                    if v.name == worldname then
                        ARMAclient.notify(source, {"~r~This world name already exists."})
                        return
                    elseif v.ownerUserId == user_id then
                        ARMAclient.notify(source, {"~r~You already have a world, please delete it first."})
                        return
                    end
                end
            end
            ARMA.prompt(source,"World Password:","",function(player,password) 
                trainingWorlds[trainingWorldsCount] = {name = worldname, ownerName = GetPlayerName(source), ownerUserId = user_id, bucket = trainingWorldsCount, members = {}, password = password}
                table.insert(trainingWorlds[trainingWorldsCount].members, user_id)
                SetPlayerRoutingBucket(source, trainingWorldsCount)
                TriggerClientEvent('ARMA:setBucket', source, trainingWorldsCount)
                TriggerClientEvent('ARMA:trainingWorldSend', -1, trainingWorldsCount, trainingWorlds[trainingWorldsCount])
                ARMAclient.notify(source, {'~g~Training World Created!'})
            end)
        else
            ARMAclient.notify(source, {"~r~Invalid World Name."})
        end
    end)
end)

RegisterNetEvent("ARMA:trainingWorldRemove")
AddEventHandler("ARMA:trainingWorldRemove", function(world)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.announce') then
        if trainingWorlds[world] ~= nil then
            TriggerClientEvent('ARMA:trainingWorldRemove', -1, world)
            for k,v in pairs(trainingWorlds[world].members) do
                local memberSource = ARMA.getUserSource(v)
                if memberSource ~= nil then
                    SetPlayerRoutingBucket(memberSource, 0)
                    TriggerClientEvent('ARMA:setBucket', memberSource, 0)
                    ARMAclient.notify(memberSource, {"~b~The training world you were in was deleted, you have been returned to the main dimension."})
                end
            end
            trainingWorlds[world] = nil
        end
    end
end)

RegisterNetEvent("ARMA:trainingWorldJoin")
AddEventHandler("ARMA:trainingWorldJoin", function(world)
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMA.prompt(source,"Enter Password:","",function(player,password) 
        if password ~= trainingWorlds[world].password then
            ARMAclient.notify(source, {"~r~Invalid Password."})
            return
        else
            SetPlayerRoutingBucket(source, world)
            TriggerClientEvent('ARMA:setBucket', source, world)
            table.insert(trainingWorlds[world].members, user_id)
            ARMAclient.notify(source, {"~b~You have joined training world "..trainingWorlds[world].name..' owned by '..trainingWorlds[world].ownerName..'.'})
        end
    end)
end)

RegisterNetEvent("ARMA:trainingWorldLeave")
AddEventHandler("ARMA:trainingWorldLeave", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    SetPlayerRoutingBucket(source, 0)
    TriggerClientEvent('ARMA:setBucket', source, 0)
    ARMAclient.notify(source, {"~b~You have left the training world."})
end)

