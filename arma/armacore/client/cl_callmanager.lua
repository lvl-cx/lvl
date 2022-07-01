CallManagerClient = {}
Tunnel.bindInterface("CallManager",CallManagerClient)
Proxy.addInterface("CallManager",CallManagerClient)
CallManagerServer = Tunnel.getInterface("CallManager","CallManager")
ARMA = Proxy.getInterface("ARMA")

local adminCalls = {}
local nhsCalls = {}
local pdCalls = {}

local savedCoords = true
local takenticket = false

local isPlayerNHS = false
local isPlayerPD = false

RMenu.Add('callmanager', 'main', RageUI.CreateMenu("", '~b~Call Manager', 1300, 50, 'manager', 'manager'))
RMenu.Add("callmanager", "admin", RageUI.CreateSubMenu(RMenu:Get("callmanager", "main",  1300, 50)))
RMenu.Add("callmanager", "police", RageUI.CreateSubMenu(RMenu:Get("callmanager", "main",  1300, 50)))
RMenu.Add("callmanager", "nhs", RageUI.CreateSubMenu(RMenu:Get("callmanager", "main",  1300, 50)))
RMenu:Get('callmanager', 'main')

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('callmanager', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        if isPlayerAdmin then
            RageUI.Button("Admin Tickets", nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if (Hovered) then

                end
                if (Active) then

                end
                if (Selected) then

                end
            end, RMenu:Get('callmanager', 'admin'))
        end

        if isPlayerPD then 
            RageUI.Button("Police Calls", nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if (Hovered) then

                end
                if (Active) then

                end
                if (Selected) then

                end
            end, RMenu:Get('callmanager', 'police'))
            
        end

        if isPlayerNHS then
            RageUI.Button("NHS Calls", nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if (Hovered) then

                end
                if (Active) then

                end
                if (Selected) then

                end
            end, RMenu:Get('callmanager', 'nhs'))
        end

    end) 
end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("callmanager", "admin")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if adminCalls ~= nil then
                for k,v in pairs(adminCalls) do
                    RageUI.Button(string.format("[%s] %s" .. "  :  " .. v[3], v[2], v[1]), nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            if not isInTicket then
                                TriggerServerEvent('ARMA:getTempFromPerm',v[2])
                                savedCoords = GetEntityCoords(PlayerPedId())
                        
                                CallManagerServer.GetUpdatedCoords({v[2]}, function(targetCoords)
                                    SetEntityCoords(PlayerPedId(), targetCoords)
                                    TriggerServerEvent("ARMA:returnMe", v[1], v[2], v[3])
                                    DoScreenFadeOut(1000)
                                    NetworkFadeOutEntity(PlayerPedId(), true, false)
                                    Wait(1000)
                                    SetEntityCoords(PlayerPedId(), targetCoords)
                                    NetworkFadeInEntity(PlayerPedId(), 0)
                                    DoScreenFadeIn(1000)
                                    notify("~g~You earned £15,000 for being cute!")
                                    TriggerServerEvent("ARMA:GiveTicketMoney", v[1], v[2], v[3], true)
                                
                                
                                    -- [Ticket Webhook]
                                    -- [Godmode & Clothing]
                                end)
                            
                                takenticket = true
                                isInTicket = true
                                CallManagerServer.RemoveTicket({k, "admin"})
                            end
                        end
                    end, RMenu:Get('callmanager', 'admin'))
                end
            end
        end) 
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("callmanager", "police")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        if pdCalls ~= nil then
            for k,v in pairs(pdCalls) do
                RageUI.Button(string.format("[ %s ] %s" .. "  :  " .. v[3], v[2], v[1]), "Press ~r~[ENTER] ~w~To accept  ~r~" .. v[1] .. "'s ~w~call!", {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                   
                            CallManagerServer.RemoveTicket({k, "pd"})
                            CallManagerServer.GetUpdatedCoords({v[2]}, function(targetCoords)
                                SetNewWaypoint(targetCoords.x, targetCoords.y)
                            end)
                        
                    end
                end, RMenu:Get('callmanager', 'police'))
            end
        end
    end) 
end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("callmanager", "nhs")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        if nhsCalls ~= nil then
            for k,v in pairs(nhsCalls) do
                RageUI.Button(string.format("[ %s ] %s" .. "  :  " .. v[3], v[2], v[1]), "Press ~r~[ENTER] ~w~To accept  ~r~" .. v[1] .. "'s ~w~call!", {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if v[2] == GetPlayerServerId(PlayerId()) then
                            notify("~r~You can't take your own Call!")
                        else
                            CallManagerServer.RemoveTicket({k, "nhs"})
                            CallManagerServer.GetUpdatedCoords({v[2]}, function(targetCoords)
                                SetNewWaypoint(targetCoords.x, targetCoords.y)
                            end)
                        end
                    end
                end, RMenu:Get('callmanager', 'nhs'))
            end
        end
    end) 
end
end)

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(0)
        if IsControlJustPressed(1, callmanager.Key) then
    
            CallManagerServer.GetPermissions({}, function(admin, pd, nhs)
                isPlayerAdmin = admin;
                isPlayerPD = pd;
                isPlayerNHS = nhs;
            end)

            CallManagerServer.GetTickets()
            RageUI.Visible(RMenu:Get('callmanager', 'main'), not RageUI.Visible(RMenu:Get('callmanager', 'main')))
        end
    end
end)

RegisterNetEvent('CallManager:Table')
AddEventHandler('CallManager:Table', function(call, call2, call3)
    adminCalls = call
    nhsCalls = call2
    pdCalls = call3
end)

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification( false, false)
end

RegisterCommand("return", function()
    if takenticket then
        if savedCoords == nil then return notify("~r~Couldn't get Last Position") end
        DoScreenFadeOut(1000)
        NetworkFadeOutEntity(PlayerPedId(), true, false)
        Wait(1000)
        SetEntityCoords(PlayerPedId(), targetCoords)
        NetworkFadeInEntity(PlayerPedId(), 0)
        DoScreenFadeIn(1000)
        SetEntityCoords(PlayerPedId(), savedCoords)
        notify("~g~Returned.")
        takenticket = false
        TriggerEvent('staffOn:false')
        TriggerEvent("ARMA:OMioDioMode",false)
        isInTicket = false
    else 
        notify('~r~You need to /return.')
    end
end)

RegisterNetEvent("staffon")
AddEventHandler("staffon", function()

    TriggerEvent("ARMA:OMioDioMode",true)
end)

RegisterNetEvent("staffoff")
AddEventHandler("staffoff", function()

    TriggerEvent("ARMA:OMioDioMode",false)
    isInTicket = false
end)

RegisterNetEvent('ARMA:sendPermID')
AddEventHandler('ARMA:sendPermID', function(permid,name)
    permid = permid
    while isInTicket do
        inRedzone = false
        Wait(0)
        if permid ~= nil then
            drawNativeText("~y~You've taken the ticket of " ..name.. "("..permid..")", 255, 0, 0, 255, true)   
        else
            notify('~r~This person has logged off.')
        end
    end
end)

function drawNativeText(V)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(V)
    EndTextCommandPrint(100, 1)
end

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end