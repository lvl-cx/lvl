local tickets = {}
local callID = 0
--table.insert(adminTickets, {name = 'Test', permID = 1, tempID = 1}) test case

-- local o, p, q, v, s, t, u = table.unpack(n)
-- o = coords
-- p = name
-- q = perm id
-- v = distance blah blah
-- s = reason
-- t = ticket type
-- u = time since

-- RegisterNetEvent("ARMA:addEmergencyCall",function(o, p, q, r, s, t)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(tickets) do
            if tickets[k].type == 'admin' and tickets[k].cooldown > 0 then
                tickets[k].cooldown = tickets[k].cooldown - 1
            end
        end
    end
end)



RegisterCommand("calladmin", function(source)
    local user_id = ARMA.getUserId(source)
    local user_source = ARMA.getUserSource(user_id)
    local cooldown = false
    for k,v in pairs(tickets) do
        if tickets[k].permID == user_id and tickets[k].type == 'admin' then
            if tickets[k].cooldown > 0 then
                ARMAclient.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
                return
            end
        end
    end
    ARMA.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = GetPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'admin',
                cooldown = 5,
            }
            for k, v in pairs(ARMA.getUsers({})) do
                TriggerClientEvent("ARMA:addEmergencyCall", v, callID, GetPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
            end
            ARMAclient.notify(user_source,{"~b~Your request has been sent."})
            ARMAclient.notify(user_source,{"~y~If you are reporting a player you can also create a report at www.armarp.co.uk/forums"})
        else
            ARMAclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("999", function(source)
    local user_id = ARMA.getUserId(source)
    local user_source = ARMA.getUserSource(user_id)
    ARMA.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = GetPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'met'
            }
            for k, v in pairs(ARMA.getUsers({})) do
                TriggerClientEvent("ARMA:addEmergencyCall", v, callID, GetPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'met')
            end
            ARMAclient.notify(user_source,{"~b~Sent Police Call."})
        else
            ARMAclient.notify(user_source,{"Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("111", function(source)
    local user_id = ARMA.getUserId(source)
    local user_source = ARMA.getUserSource(user_id)
    ARMA.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = GetPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'nhs'
            }
            for k, v in pairs(ARMA.getUsers({})) do
                TriggerClientEvent("ARMA:addEmergencyCall", v, callID, GetPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'nhs')
            end
            ARMAclient.notify(user_source,{"~g~Sent NHS Call."})
        else
            ARMAclient.notify(user_source,{"Please enter a valid reason."})
        end
    end)
end)

local savedPositions = {}
RegisterCommand("return", function(source)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.tickets') then
        if savedPositions[user_id] then
            SetPlayerRoutingBucket(source, savedPositions[user_id].bucket)
            ARMAclient.teleport(source, {savedPositions[user_id].coords})
            ARMAclient.notify(source, {'~g~Returned to position.'})
        else
            ARMAclient.notify(source, {"~r~Unable to find last location."})
        end
        ARMAclient.staffMode(source, {false})
    end
end)


RegisterNetEvent("ARMA:TakeTicket")
AddEventHandler("ARMA:TakeTicket", function(ticketID)
    local user_id = ARMA.getUserId(source)
    local admin_source = ARMA.getUserSource(user_id)
    if tickets[ticketID] ~= nil then
        for k, v in pairs(tickets) do
            if ticketID == k then
                if tickets[ticketID].type == 'admin' and ARMA.hasPermission(user_id, "admin.tickets") then
                    if ARMA.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            local adminbucket = GetPlayerRoutingBucket(admin_source)
                            local playerbucket = GetPlayerRoutingBucket(v.tempID)
                            if adminbucket ~= playerbucket then
                                SetPlayerRoutingBucket(admin_source, playerbucket)
                                TriggerClientEvent('ARMA:setBucket', admin_source, playerbucket)
                                ARMAclient.notify(admin_source, {'~g~Player was in another bucket, you have been set into their bucket.'})
                            end
                            ARMAclient.getPosition(v.tempID, {}, function(coords)
                                ARMAclient.staffMode(admin_source, {true})
                                savedPositions[user_id] = {bucket = GetPlayerRoutingBucket(admin_source), coords = GetEntityCoords(GetPlayerPed(admin_source))}
                                TriggerClientEvent('ARMA:sendTicketInfo', admin_source, v.permID, v.name)
                                local ticketPay = 0
                                if os.date('%A') == 'Saturday' or 'Sunday' then
                                    ticketPay = 20000
                                else
                                    ticketPay = 10000
                                end
                                ARMA.giveBankMoney(user_id, ticketPay)
                                ARMAclient.notify(admin_source,{"~g~£"..getMoneyStringFormatted(ticketPay).." earned for being cute. ❤️"})
                                ARMAclient.notify(v.tempID,{"~g~An admin has taken your ticket."})
                                TriggerClientEvent('ARMA:smallAnnouncement', v.tempID, 'ticket accepted', "Your admin ticket has been accepted by "..GetPlayerName(admin_source), 33, 10000)
                                ARMAclient.teleport(admin_source, {table.unpack(coords)})
                                tickets[ticketID] = nil
                                TriggerClientEvent("ARMA:removeEmergencyCall", -1, ticketID)
                            end)
                        else
                            ARMAclient.notify(admin_source,{"~r~You can't take your own ticket!"})
                        end
                    else
                        ARMAclient.notify(admin_source,{"~r~You cannot take a ticket from an offline player."})
                        TriggerClientEvent("ARMA:removeEmergencyCall", -1, ticketID)
                    end
                elseif tickets[ticketID].type == 'met' and ARMA.hasPermission(user_id, "police.onduty.permission") then
                    if ARMA.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            ARMAclient.notify(v.tempID,{"~b~Your MET Police call has been accepted!"})
                            tickets[ticketID] = nil
                            TriggerClientEvent("ARMA:removeEmergencyCall", -1, ticketID)
                        else
                            ARMAclient.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        TriggerClientEvent("ARMA:removeEmergencyCall", -1, ticketID)
                    end
                elseif tickets[ticketID].type == 'nhs' and ARMA.hasPermission(user_id, "nhs.onduty.permission") then
                    if ARMA.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            ARMAclient.notify(v.tempID,{"~g~Your NHS call has been accepted!"})
                            tickets[ticketID] = nil
                            TriggerClientEvent("ARMA:removeEmergencyCall", -1, ticketID)
                        else
                            ARMAclient.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        TriggerClientEvent("ARMA:removeEmergencyCall", -1, ticketID)
                    end
                end
            end
        end
    end         
end)


RegisterNetEvent("ARMA:NHSComaCall")
AddEventHandler("ARMA:NHSComaCall", function()
    local user_id = ARMA.getUserId(source)
    local user_source = ARMA.getUserSource(user_id)
    reason = 'Immediate Attention'
    callID = callID + 1
    tickets[callID] = {
        name = GetPlayerName(user_source),
        permID = user_id,
        tempID = user_source,
        reason = reason,
        type = 'nhs'
    }
    for k, v in pairs(ARMA.getUsers({})) do
        TriggerClientEvent("ARMA:addEmergencyCall", v, callID, GetPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'nhs')
    end
end)

RegisterNetEvent("ARMA:getNumOfNHSOnline")
AddEventHandler("ARMA:getNumOfNHSOnline", function()
    local source = source
    TriggerClientEvent('ARMA:getNumberOfDocsOnline', source, #ARMA.getUsersByPermission('nhs.onduty.permission'))
end)