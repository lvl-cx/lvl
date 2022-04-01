

CallManagerServer = {}


adminTickets = {}
nhsCalls = {}
pdCalls = {}

function CallManagerServer.GetTickets()
    TriggerClientEvent('CallManager:Table', -1, adminTickets, nhsCalls, pdCalls)
end

function CallManagerServer.GetPermissions()
    adminPerm = false
    nhsPerm = false
    pdPerm = false
    local source = source
    local user_id = Sentry.getUserId(source)
    if Sentry.hasPermission(user_id, callmanager.AdminPerm) then
        adminPerm = true;
    end

    if Sentry.hasPermission(user_id, "cop.keycard") then
        pdPerm = true;
    end
    return adminPerm, pdPerm, nhsPerm
end


function CallManagerServer.RemoveTicket(index, Type)
    if Type == "admin" then
        adminTickets[index] = nil
    elseif Type == "nhs" then
        nhsCalls[index] = nil
    else
        pdCalls[index] = nil
    end
    TriggerClientEvent('CallManager:Table', -1, adminTickets, nhsCalls, pdCalls)
end

local AdminCooldown = {}

RegisterCommand("calladmin", function(source, args, rawCommand)
    
    Sentry.prompt(source, "Reason:", "", function(player, Reason)
        if Reason == "" then return end
        local index = #adminTickets + 1
        adminTickets[index] = {GetPlayerName(source), source, Reason}
        AdminCooldown[source] = os.time() + tonumber(30)
        TriggerClientEvent('CallManager:Table', -1, adminTickets, nhsCalls, pdCalls)
    end)
end)

RegisterCommand("999", function(source, args, rawCommand)
    Sentry.prompt(source, "Reason:", "", function(player, Reason)
        if Reason == "" then return end
        local index = #pdCalls + 1
        pdCalls[index] = {GetPlayerName(source), source, Reason}
        TriggerClientEvent('CallManager:Table', -1, adminTickets, nhsCalls, pdCalls)
    end)
end)


RegisterNetEvent('CallManager:AddNHSCalls')
AddEventHandler('CallManager:AddNHSCalls', function(Reason)
    local source = source
    local index = #nhsCalls + 1
    nhsCalls[index] = {GetPlayerName(source), source, Reason}
    TriggerClientEvent('CallManager:Table', -1, adminTickets, nhsCalls, pdCalls)
end)

function CallManagerServer.GetUpdatedCoords(target)
    local source = source
    local target = target
    return GetEntityCoords(GetPlayerPed(tonumber(target)))
end

RegisterNetEvent('Sentry:returnMe')
AddEventHandler('Sentry:returnMe', function(admin, ticket, reason)
    local source = source
    local name = GetPlayerName(source)
    userid = Sentry.getUserId(source)

    local name = GetPlayerName(source)
    local tuserid = Sentry.getUserId(ticket)
    local tname = GetPlayerName(ticket)

    --Sentry.giveBankMoney(userid, 3000)
    Sentryclient.notify(ticket,{'~g~An Admin has Taken your Ticket!'})
    TriggerClientEvent("TRP:OMioDioMode",source,true)



end)

RegisterCommand("staffon", function(source)
    user_id = Sentry.getUserId(source)
    if Sentry.hasPermission(user_id, "admin.tickets") then
        TriggerClientEvent("staffon", source)
        Sentryclient.notify(source,{"~g~You are now on Duty!"})
    else
        Sentryclient.notify(source,{"~r~You do not have permissions to do this!"})
    end
end)

RegisterCommand("staffoff", function(source)
    user_id = Sentry.getUserId(source)
    if Sentry.hasPermission(user_id, "admin.tickets") then
        TriggerClientEvent("staffoff", source)
        Sentryclient.notify(source,{"~r~You are now off Duty!"})
    else
        Sentryclient.notify(source,{"~r~You do not have permissions to do this!"})
    end
end)

