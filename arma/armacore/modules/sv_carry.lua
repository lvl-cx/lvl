carrying = {}
--carrying[source] = targetSource, source is carrying targetSource
carried = {}
--carried[targetSource] = source, targetSource is being carried by source

RegisterServerEvent("CarryPeople:sync")
AddEventHandler("CarryPeople:sync", function(targetSrc)
    local targetSrc = targetSrc
    local sourcePed = GetPlayerPed(source)
    local sourceCoords = GetEntityCoords(sourcePed)
    local targetPed = GetPlayerPed(targetSrc)
    local targetCoords = GetEntityCoords(targetPed)
    if #(sourceCoords - targetCoords) <= 3.0 then 
        TriggerClientEvent("CarryPeople:syncTarget", targetSrc, source)
        carrying[source] = targetSrc
        carried[targetSrc] = source
    end
end)

RegisterServerEvent("CarryPeople:stop")
AddEventHandler("CarryPeople:stop", function(targetSrc)
    local source = source

    if carrying[source] then
        TriggerClientEvent("CarryPeople:cl_stop", targetSrc)
        carrying[source] = nil
        carried[targetSrc] = nil
    elseif carried[source] then
        TriggerClientEvent("CarryPeople:cl_stop", carried[source])            
        carrying[carried[source]] = nil
        carried[source] = nil
    end
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    
    if carrying[source] then
        TriggerClientEvent("CarryPeople:cl_stop", carrying[source])
        carried[carrying[source]] = nil
        carrying[source] = nil
    end

    if carried[source] then
        TriggerClientEvent("CarryPeople:cl_stop", carried[source])
        carrying[carried[source]] = nil
        carried[source] = nil
    end
end)

RegisterServerEvent("ARMAEXTRAS:CarryAccepted")
AddEventHandler("ARMAEXTRAS:CarryAccepted", function(senderSrc)
    local senderSrc = senderSrc
    local targetSrc = source
    local targetSrcName = GetPlayerName(targetSrc)
    ARMAclient.notify(targetSrc,{"~g~Carry request accepted."})
    ARMAclient.notify(senderSrc,{"~g~Your carry request to "..targetSrcName.." has been accepted."})
    TriggerClientEvent("ARMAEXTRAS:StartCarry", senderSrc, targetSrc)
end)

RegisterServerEvent("ARMAEXTRAS:CarryDeclined")
AddEventHandler("ARMAEXTRAS:CarryDeclined", function(senderSrc)
    local senderSrc = senderSrc
    local targetSrc = source
    local targetSrcName = GetPlayerName(targetSrc)
    ARMAclient.notify(senderSrc,{"~r~Your carry request to "..targetSrcName.." has been declined."})
    ARMAclient.notify(targetSrc,{"~r~Carry request denied."})
end)

RegisterServerEvent("ARMA:CarryRequest")
AddEventHandler("ARMA:CarryRequest", function(targetSrc, staffMode)
    local targetSrc = targetSrc
    local senderSrc = source
    user_id = ARMA.getUserId(senderSrc)
    local senderSrcName = GetPlayerName(senderSrc)
    if staffMode and ARMA.hasPermission(user_id, "admin.tickets") then
        TriggerClientEvent("ARMAEXTRAS:StartCarry", senderSrc, targetSrc)
    else
        ARMAclient.notify(targetSrc,{"Player: ~b~"..senderSrcName.."~w~ is trying to carry you, press ~g~Y~w~ to accept or ~r~L~w~ to refuse"})
        ARMAclient.notify(senderSrc,{"Sent carry request to Temp ID: "..targetSrc})
        TriggerClientEvent('ARMAEXTRAS:CarryTargetAsk', targetSrc, senderSrc)
    end
end)