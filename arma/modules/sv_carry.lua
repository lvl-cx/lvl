carrying = {}
carried = {}
requests = {}

RegisterCommand('carryaccept', function(source)
    if requests[source] then
        TriggerClientEvent('CarryPeople:syncMe', source, 'nm', 'firemans_carry', 10000, 33)
        local coords = table.unpack(GetEntityCoords(GetPlayerPed(requests[source])))
        TriggerClientEvent('CarryPeople:syncTarget', requests[source], 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', coords.y, coords.x, coords.z, 10000, GetEntityHeading(GetPlayerPed(requests[source])), 49)
        carrying[source] = requests[source]
        carried[requests[source]] = source
        request[source] = nil
    end
end)

RegisterCommand('carryrefuse', function(source)
    if requests[source] then
        ARMAclient.notify(requests[source], "~r~Carry Request Refused")
        requests[source] = nil
    end
end)

RegisterServerEvent("CarryPeople:sync")
AddEventHandler("CarryPeople:sync", function(senderSrc, targetSrc)
    local sourcePed = GetPlayerPed(senderSrc)
    local sourceCoords = GetEntityCoords(sourcePed)
    local targetPed = GetPlayerPed(targetSrc)
    local targetCoords = GetEntityCoords(targetPed)
    if #(sourceCoords - targetCoords) <= 3.0 then 
        TriggerClientEvent("CarryPeople:syncTarget", targetSrc, senderSrc)
        TriggerClientEvent('CarryPeople:syncMe', senderSrc, )
        carrying[senderSrc] = targetSrc
        carried[targetSrc] = senderSrc
    end
end)

RegisterServerEvent("CarryPeople:requestCarry")
AddEventHandler("CarryPeople:requestCarry", function(targetSrc)
    local source = source
    requests[targetSrc] = source
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