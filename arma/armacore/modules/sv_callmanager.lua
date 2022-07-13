local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP")

local tickets = {}

RegisterNetEvent("Jud:RequestTickets")
AddEventHandler("Jud:RequestTickets", function()
    local user_id = vRP.getUserId({source})
    if vRP.hasPermission({user_id, "admin.tickets"}) then
        TriggerClientEvent("Jud:RecieveTickets", source, tickets)
    end
end)

RegisterCommand("calladmin", function(source)
    local user_id = vRP.getUserId({source})
    local user_source = vRP.getUserSource({user_id})
    vRP.prompt({user_source, "Please enter call reason: ", "", function(player, value)
        if value ~= "" then
            tickets[value] = {
                name = GetPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
            }
            for k, v in pairs(vRP.getUsers({})) do
                if vRP.hasPermission({k, "admin.tickets"}) then
                    vRPclient.notify(v,{"~g~Admin ticket recieved!"})
                end
            end
            vRPclient.notify(user_source,{"~g~Sent admin ticket."})
        else
            vRPclient.notify(user_source,{"Please enter a valid reason."})
        end
    end})
end)

RegisterNetEvent("Jud:RemoveTicket")
AddEventHandler("Jud:RemoveTicket", function(ticketID)
    tickets[ticketID] = nil
    for k, v in pairs(vRP.getUsers({})) do
        if vRP.hasPermission({k, "admin.tickets"}) then
            TriggerClientEvent("Jud:RecieveTickets", v, tickets)
        end
    end
end)

RegisterNetEvent("Jud:TakeTicket")
AddEventHandler("Jud:TakeTicket", function(ticketID)
    local user_id = vRP.getUserId({source})
    local admin_source = vRP.getUserSource({user_id})
    if vRP.hasPermission({user_id, "admin.tickets"}) then
        if tickets[ticketID] ~= nil then
            for k, v in pairs(tickets) do
                if ticketID == k then
                    if vRP.getUserSource({v.permID}) ~= nil then
                        if user_id ~= v.permID then
                            local adminbucket = GetPlayerRoutingBucket(admin_source)
                            local playerbucket = GetPlayerRoutingBucket(v.tempID)
                            if adminbucket ~= playerbucket then
                                SetPlayerRoutingBucket(admin_source, playerbucket)
                                vRPclient.notify(admin_source, {'~g~The person was in a different bucket, you have followed them there.'})
                            end
                            vRPclient.getPosition(v.tempID, {}, function(x,y,z)
                                vRPclient.staffMode(admin_source, {true})
                                TriggerClientEvent('Jud:sendTicketInfo', admin_source, v.permID, v.name)
                                vRP.giveBankMoney({user_id, 100})
                                vRPclient.notify(admin_source,{"~g~You have taken "..v.name.."'s ticket ["..v.permID.."]. Enjoy 100 Tokens ❤️"})
                                vRPclient.notify(v.tempID,{"~g~Your ticket has been taken!"})
                                vRPclient.teleport(admin_source, {x,y,z})
                                TriggerEvent("Jud:RemoveTicket", ticketID)
                            end)
                        else
                            vRPclient.notify(admin_source,{"~r~You can't take your own ticket!"})
                        end
                    else
                        vRPclient.notify(admin_source,{"~r~Player has left the game."})
                        TriggerEvent("Jud:RemoveTicket", ticketID)
                    end
                end
            end
        else
            vRPclient.notify(admin_source,{"~r~Ticket Already taken!"})
        end
    end         
end)
