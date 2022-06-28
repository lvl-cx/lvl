CallManagerServer = {}
Tunnel.bindInterface("CallManager",CallManagerServer)
Proxy.addInterface("CallManager",CallManagerServer)
CallManagerClient = Tunnel.getInterface("CallManager", "CallManager")

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
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.tickets") then
        adminPerm = true;
    end
    if ARMA.hasPermission(user_id, "police.armoury") then
        pdPerm = true;
    end
    if ARMA.hasPermission(user_id, "nhs.call") then
        nhsPerm = true;
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



---- Admin tickets

RegisterCommand("calladmin", function(source, args, rawCommand)
    ARMA.prompt(source, "Reason:", "", function(player, Reason)
        if Reason == "" then return end
        if #Reason > 9 then 
            TriggerClientEvent('ARMA:AdminTicketCooldown', source, Reason)
        else
            ARMAclient.notify(source,{"~r~Reason must be 10 characters or longer."})
        end
    end)
end)

RegisterNetEvent('ARMA:sendAdminTicket')
AddEventHandler('ARMA:sendAdminTicket', function(Reason)
    local index = #adminTickets + 1
    adminTickets[index] = {GetPlayerName(source), source, Reason}
    for k, v in pairs(ARMA.getUsers({})) do 
        if ARMA.hasPermission(k, callmanager.AdminPerm) then
            ARMAclient.notify(v,{"~b~Admin Ticket Recieved!"})
        end
    end
    TriggerClientEvent('CallManager:Table', -1, adminTickets, nhsCalls, pdCalls, name)
end)




---- Police Calls

RegisterCommand("999", function(source, args, rawCommand)
    ARMA.prompt(source, "Reason:", "", function(player, Reason)
        if Reason == "" then return end
        TriggerClientEvent('ARMA:PDCallCooldown', source, Reason)
    end)
end)

RegisterNetEvent('ARMA:sendPDCall')
AddEventHandler('ARMA:sendPDCall', function(Reason)
    local index = #pdCalls + 1   
    pdCalls[index] = {GetPlayerName(source), source, Reason}
    for k, v in pairs(ARMA.getUsers({})) do 
        if ARMA.hasPermission(k, callmanager.PolicePerm) then
            ARMAclient.notify(v,{"~b~MET Police Call Recieved!"})
        end
    end
    TriggerClientEvent('CallManager:Table', -1, adminTickets, nhsCalls, pdCalls, source)
    ARMAclient.notify(source,{"~b~Police called!"})
end)



---- NHS Calls

RegisterCommand("111", function(source, args, rawCommand)
    ARMA.prompt(source, "Reason:", "", function(player, Reason)
        if Reason == "" then return end
        TriggerClientEvent('ARMA:NHSCallCooldown', source, Reason)
    end)
end)

RegisterNetEvent('ARMA:sendNHSCall')
AddEventHandler('ARMA:sendNHSCall', function(Reason)
    ARMAclient.notify(source,{"~g~NHS will be added at a later date!"})
    -- REMOVE this section below when NHS is added in future.
     local index = #nhsCalls + 1   
    nhsCalls[index] = {GetPlayerName(source), source, Reason}
    for k, v in pairs(ARMA.getUsers({})) do 
        if ARMA.hasPermission(k, callmanager.NHSPerm) then
            ARMAclient.notify(v,{"~g~NHS Call Recieved!"})
        end
    end
    TriggerClientEvent('CallManager:Table', -1, adminTickets, nhsCalls, pdCalls, source)
    ARMAclient.notify(source,{"~g~NHS called!"})
end)

RegisterNetEvent('ARMA:getTempFromPerm')
AddEventHandler('ARMA:getTempFromPerm', function(tempid)
    local source = source
    permid = ARMA.getUserId({tempid})
    TriggerClientEvent('ARMA:sendPermID', source, permid)
end)


function CallManagerServer.GetUpdatedCoords(target)
    local source = source
    local target = target
    return GetEntityCoords(GetPlayerPed(tonumber(target)))
end

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

    
    local tsource = ARMA.getUsers({ticket})
    local tuserid = ARMA.getUserId({ticket})
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
    PerformHttpRequest("https://discord.com/api/webhooks/984586081255190528/qz1R653gBFzf_wimFqiF5rs9X36AzGplguWumz2zUPtiW2bpzg3sD8hpe-mmgLn7b3qz", function(err, text, headers) end, "POST", json.encode({username = "ARMA", embeds = ticketEmbed}), { ["Content-Type"] = "application/json" })

    end
end)

RegisterNetEvent('ARMA:AddTicketToLB')
AddEventHandler('ARMA:AddTicketToLB', function(user_id)
    if ARMA.hasPermission(user_id, "admin.tickets") then
    exports['ghmattimysql']:execute("SELECT * FROM `staff_tickets` WHERE userid = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                if v.userid == user_id then
                    ticketcount = v.ticketcount + 1
                    exports['ghmattimysql']:execute("UPDATE staff_tickets SET ticketcount = @ticketcount WHERE userid = @user_id", {user_id = user_id, ticketcount = ticketcount}, function() end)
                    return
                end
            end
            exports['ghmattimysql']:execute("INSERT INTO staff_tickets (`userid`, `ticketcount`, `username`) VALUES (@user_id, @ticketcount, @username);", {user_id = user_id, ticketcount = 1, username = name}, function() end) 
        end
    end)
end
end)

staffonlist = {}


RegisterCommand("staffon", function(source)
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, "admin.tickets") then
        if staffonlist[tostring(user_id)] == true then
            ARMAclient.notify(source,{"~r~Already staffon'd"})
            return
        end
        isInTicket = false
        TriggerClientEvent("staffon", source, isInTicket)
        ARMAclient.notify(source,{"~g~You are now on Duty!"})
        staffonlist[tostring(user_id)] = true
    end
end)

RegisterCommand("staffoff", function(source)
    local user_id = ARMA.getUserId(source)
    level = GetPedArmour(GetPlayerPed(source))
    if ARMA.hasPermission(user_id, "admin.tickets") then
        if staffonlist[tostring(user_id)] == nil then
            ARMAclient.notify(source,{"~r~Not staffon'd"})
            return
        end
        isInTicket = false
        TriggerClientEvent("staffoff", source)
        ARMAclient.notify(source,{"~r~You are now off Duty!"})
        staffonlist[tostring(user_id)] = nil
    end
end)

function Notify( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end


Citizen.CreateThread(function()
    Wait(2500)
    exports['ghmattimysql']:execute([[
            CREATE TABLE IF NOT EXISTS `staff_tickets` (
                `userid` int(11) NOT NULL AUTO_INCREMENT,
                `ticketcount` int(11) NOT NULL,
                `username` VARCHAR(100) NOT NULL,
                PRIMARY KEY (`userid`)
              );
        ]])
    print("Staff Tickets initialised")
end)
