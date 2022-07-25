local adminTickets = {}
local pdCalls = {}
local NHSCalls = {}
--table.insert(adminTickets, {name = 'Test', permID = 1, tempID = 1}) test case

RegisterNetEvent("ARMA:RequestTickets")
AddEventHandler("ARMA:RequestTickets", function()
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.tickets") then
        TriggerClientEvent("ARMA:RecieveTickets", source, adminTickets)
    end
    if ARMA.hasPermission(user_id, "police.perms") then
        TriggerClientEvent("ARMA:ReceivePDCalls", source, pdCalls)
    end
    if ARMA.hasPermission(user_id, "nhs.menu") then
        TriggerClientEvent("ARMA:ReceiveNHSCalls", source, NHSCalls)
    end
end)

RegisterCommand("calladmin", function(source)
    local user_id = ARMA.getUserId(source)
    local user_source = ARMA.getUserSource(user_id)
    ARMA.prompt(user_source, "Please enter call reason: ", "", function(player, value)
        if value ~= "" then
            adminTickets[value] = {
                name = GetPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
            }
            for k, v in pairs(ARMA.getUsers({})) do
                if ARMA.hasPermission(k, "admin.tickets") then
                    ARMAclient.notify(v,{"~g~Admin ticket recieved!"})
                end
            end
            ARMAclient.notify(user_source,{"~g~Sent admin ticket."})
        else
            ARMAclient.notify(user_source,{"Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("999", function(source)
    local user_id = ARMA.getUserId(source)
    local user_source = ARMA.getUserSource(user_id)
    ARMA.prompt(user_source, "Please enter call reason: ", "", function(player, value)
        if value ~= "" then
            pdCalls[value] = {
                name = GetPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
                coords = GetEntityCoords(GetPlayerPed(user_source)),
            }
            for k, v in pairs(ARMA.getUsers({})) do
                if ARMA.hasPermission(k, "police.perms") then
                    ARMAclient.notify(v,{"~b~Police Call!"})
                end
            end
            ARMAclient.notify(user_source,{"~g~Sent Police Call."})
        else
            ARMAclient.notify(user_source,{"Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("111", function(source)
    local user_id = ARMA.getUserId(source)
    local user_source = ARMA.getUserSource(user_id)
    ARMA.prompt(user_source, "Please enter call reason: ", "", function(player, value)
        if value ~= "" then
            NHSCalls[value] = {
                name = GetPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
                coords = GetEntityCoords(GetPlayerPed(user_source)),
            }
            for k, v in pairs(ARMA.getUsers({})) do
                if ARMA.hasPermission(k, "nhs.menu") then
                    ARMAclient.notify(v,{"~g~NHS Call Received!"})
                end
            end
            ARMAclient.notify(user_source,{"~g~Sent NHS Call."})
        else
            ARMAclient.notify(user_source,{"Please enter a valid reason."})
        end
    end)
end)

RegisterNetEvent("ARMA:RemoveTicket")
AddEventHandler("ARMA:RemoveTicket", function(ticketID, a)
    if a == "Admin" then
        adminTickets[ticketID] = nil
    elseif a == "PD" then
        pdCalls[ticketID] = nil
    elseif a == "NHS" then
        NHSCalls[ticketID] = nil
    end
    for k, v in pairs(ARMA.getUsers({})) do
        if ARMA.hasPermission(k, "admin.tickets") then
            TriggerClientEvent("ARMA:RecieveTickets", v, adminTickets)
        end
        if ARMA.hasPermission(k, "police.perms") then
            TriggerClientEvent("ARMA:RecieveTickets", v, pdCalls)
        end
        if ARMA.hasPermission(k, "nhs.menu") then
            TriggerClientEvent("ARMA:RecieveTickets", v, NHSCalls)
        end
    end
end)

RegisterNetEvent("ARMA:TakeTicket")
AddEventHandler("ARMA:TakeTicket", function(ticketID, b)
    local user_id = ARMA.getUserId(source)
    local admin_source = ARMA.getUserSource(user_id)
    if ARMA.hasPermission(user_id, "admin.tickets") and b == 'Admin' then
        if adminTickets[ticketID] ~= nil then
            for k, v in pairs(adminTickets) do
                if ticketID == k then
                    if ARMA.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            local adminbucket = GetPlayerRoutingBucket(admin_source)
                            local playerbucket = GetPlayerRoutingBucket(v.tempID)
                            if adminbucket ~= playerbucket then
                                SetPlayerRoutingBucket(admin_source, playerbucket)
                                ARMAclient.notify(admin_source, {'~g~The person was in a different bucket, you have followed them there.'})
                            end
                            ARMAclient.getPosition(v.tempID, {}, function(x,y,z)
                                ARMAclient.staffMode(admin_source, {true})
                                TriggerClientEvent('ARMA:sendTicketInfo', admin_source, v.permID, v.name)
                                ARMA.giveBankMoney(user_id, 3000)
                                ARMAclient.notify(admin_source,{"~g~You have taken "..v.name.."'s ticket. You have earned £3,000 ❤️"})
                                ARMAclient.notify(v.tempID,{"~g~Your ticket has been taken!"})
                                ARMAclient.teleport(admin_source, {x,y,z})
                                TriggerEvent("ARMA:RemoveTicket", ticketID, b)
                            end)
                        else
                            ARMAclient.notify(admin_source,{"~r~You can't take your own ticket!"})
                        end
                    else
                        ARMAclient.notify(admin_source,{"~r~Player has left the game."})
                        TriggerEvent("ARMA:RemoveTicket", ticketID, b)
                    end
                end
            end
        else
            ARMAclient.notify(admin_source,{"~r~Ticket Already taken!"})
        end
    elseif ARMA.hasPermission(user_id, "police.perms") and b == 'PD' then
        if PDCalls[ticketID] ~= nil then
            for k, v in pairs(PDCalls) do
                if ticketID == k then
                    if ARMA.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            ARMAclient.getPosition(v.tempID, {}, function(x,y,z)
                                ARMAclient.notify(v.tempID,{"~g~Your police call has been accepted!"})
                                TriggerEvent("ARMA:RemoveTicket", ticketID, b)
                            end)
                        else
                            ARMAclient.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        ARMAclient.notify(admin_source,{"~r~Player has left the game."})
                        TriggerEvent("ARMA:RemoveTicket", ticketID, b)
                    end
                end
            end
        else
            ARMAclient.notify(admin_source,{"~r~Call Already accepted!"})
        end
    elseif ARMA.hasPermission(user_id, "nhs.menu") and b == 'NHS' then
        if NHSCalls[ticketID] ~= nil then
            for k, v in pairs(NHSCalls) do
                if ticketID == k then
                    if ARMA.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            ARMAclient.getPosition(v.tempID, {}, function(x,y,z)
                                ARMAclient.notify(v.tempID,{"~g~Your emergency call has been accepted!"})
                                TriggerEvent("ARMA:RemoveTicket", ticketID, b)
                            end)
                        else
                            ARMAclient.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        ARMAclient.notify(admin_source,{"~r~Player has left the game."})
                        TriggerEvent("ARMA:RemoveTicket", ticketID, b)
                    end
                end
            end
        else
            ARMAclient.notify(admin_source,{"~r~Call Already accepted!"})
        end
    end         
end)


RegisterNetEvent("ARMA:NHSComaCall")
AddEventHandler("ARMA:NHSComaCall", function()
    local user_id = ARMA.getUserId(source)
    local user_source = ARMA.getUserSource(user_id)
    NHSCalls['Immediate Attention'] = {
        name = GetPlayerName(user_source),
        permID = user_id,
        tempID = user_source,
        coords = GetEntityCoords(GetPlayerPed(user_source)),
    }
    for k, v in pairs(ARMA.getUsers({})) do
        if ARMA.hasPermission(k, "nhs.menu") then
            ARMAclient.notify(v,{"~g~NHS Call Received!"})
        end
    end
end)