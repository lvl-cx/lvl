CallManagerServer = {}
Tunnel.bindInterface("CallManager",CallManagerServer)
Proxy.addInterface("CallManager",CallManagerServer)
CallManagerClient = Tunnel.getInterface("CallManager", "CallManager")
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
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.tickets") then
        adminPerm = true;
    end

    if ARMA.hasPermission(user_id, "cop.keycard") then
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
    
    ARMA.prompt(source, "Reason:", "", function(player, Reason)
        if Reason == "" then return end
        local index = #adminTickets + 1
        adminTickets[index] = {GetPlayerName(source), source, Reason}
        AdminCooldown[source] = os.time() + tonumber(30)
        TriggerClientEvent('CallManager:Table', -1, adminTickets, nhsCalls, pdCalls)
    end)
end)

RegisterCommand("999", function(source, args, rawCommand)
    ARMA.prompt(source, "Reason:", "", function(player, Reason)
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

RegisterNetEvent('ARMA:returnMe')
AddEventHandler('ARMA:returnMe', function(admin, ticket, reason)
    local source = source
    local name = GetPlayerName(source)
    userid = ARMA.getUserId(source)

    local name = GetPlayerName(source)
    local tuserid = ARMA.getUserId(ticket)
    local tname = GetPlayerName(ticket)

    ARMAclient.notify(ticket,{'~g~An Admin has Taken your Ticket!'})
    TriggerClientEvent("ARMA:OMioDioMode",source,true)



end)

RegisterCommand("staffon", function(source)
    user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.tickets") then
        TriggerClientEvent("staffon", source)
        ARMAclient.notify(source,{"~g~You are now on Duty!"})
    else
        ARMAclient.notify(source,{"~r~You do not have permissions to do this!"})
    end
end)

RegisterCommand("staffoff", function(source)
    user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.tickets") then
        TriggerClientEvent("staffoff", source)
        ARMAclient.notify(source,{"~r~You are now off Duty!"})
    else
        ARMAclient.notify(source,{"~r~You do not have permissions to do this!"})
    end
end)

RegisterNetEvent('ARMA:getTempFromPerm')
AddEventHandler('ARMA:getTempFromPerm', function(tempid)
    local source = source
    permid = ARMA.getUserId(tempid)
    local name = GetPlayerName(source)
    TriggerClientEvent('ARMA:sendPermID', source, permid,name)
end)

RegisterNetEvent('ARMA:GiveTicketMoney')
AddEventHandler('ARMA:GiveTicketMoney', function(admin, ticket, reason, isInTicket)
    local source = source
    local name = GetPlayerName(source)
    local ticketcount = 0
    local ticketStatus = isInTicket
    local user_id = ARMA.getUserId(source)
    userid = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.tickets") then
    ARMA.giveBankMoney(user_id, 15000)
    ARMAclient.notify(ticket,{'~g~An Admin has Taken your Ticket! [Name: ' .. name .. ' | ID: ' .. userid .. ']'})
    TriggerClientEvent("staffon", source, ticketStatus)
    TriggerEvent('ARMA:AddTicketToLB', user_id)
	local name = GetPlayerName(source)

    
    local tsource = ARMA.getUsers(ticket)
    local tuserid = ARMA.getUserId(ticket)
    local tname = GetPlayerName(ticket)
    local ticketEmbed = {
        {
            ["color"] = "16777215",
            ["title"] = "Ticket Log",
            ["description"] = "**Admin Name:** "..name.."\n**Admin PermID:** "..user_id.."\n**User Name:** "..tname.."\n**User PermID:** "..tuserid.."\n**Reason:** " .. reason,
            --["description"] = "**Admin Name:** "..name.."\n**Admin PermID:** "..user_id.."\n**User Name:** "..tname.."\n**User PermID:** \n**Reason:** " .. reason,
            ["footer"] = {
              ["text"] = os.date("%X"),
              ["icon_url"] = "https://cdn.discordapp.com/attachments/848856393012346930/877183938420953118/TGRPLogo.png",
            }
        }
    }
    PerformHttpRequest("", function(err, text, headers) end, "POST", json.encode({username = "ARMA", embeds = ticketEmbed}), { ["Content-Type"] = "application/json" })

    end
end)