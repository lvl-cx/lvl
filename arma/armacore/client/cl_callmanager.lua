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
            RageUI.Button("Admin Tickets", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Hovered) then

                end
                if (Active) then

                end
                if (Selected) then

                end
            end, RMenu:Get('callmanager', 'admin'))
        end

        if isPlayerPD then 
            RageUI.Button("Police Calls", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Hovered) then

                end
                if (Active) then

                end
                if (Selected) then

                end
            end, RMenu:Get('callmanager', 'police'))
            
        end

        if isPlayerNHS then
            RageUI.Button("NHS Calls", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
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
                RageUI.Button(string.format("[%s] %s" .. "  :  " .. v[3], v[2], v[1]), nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if v[2] == GetPlayerServerId(PlayerId()) then
                            notify("~r~You can't take your own Call!")
                        else
                            if not isInTicket then
                                    savedCoords = GetEntityCoords(PlayerPedId())
                                
                                        TriggerServerEvent('GetUpdatedCoords', v[2])
                                        Wait(100)
                                        SetEntityCoords(PlayerPedId(), targetCoords)
                                        TriggerServerEvent("ARMA:returnMe", v[1], v[2], v[3])
                                    
                                    
                                    
                                        -- [Ticket Webhook]
                                        -- [Godmode & Clothing]
    
                                
                                    takenticket = true
                                    isInTicket = true
                                    TriggerServerEvent('RemoveTicket', k, "admin")
                            end
                        end
                    end
                end, RMenu:Get('callmanager', 'admin'))
            end
        end
    end) 
end
end)

RegisterNetEvent('rGetUpdatedCoords')
AddEventHandler('rGetUpdatedCoords', function(coords)
    targetCoords = coords
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("callmanager", "police")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        if pdCalls ~= nil then
            for k,v in pairs(pdCalls) do
                RageUI.Button(string.format("[ %s ] %s" .. "  :  " .. v[3], v[2], v[1]),nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                   
        
                            TriggerServerEvent('RemoveTicket', k, "pd")
                            TriggerServerEvent('GetUpdatedCoords', v[2])
                            Wait(100)
                                SetNewWaypoint(targetCoords.x, targetCoords.y)
                 
                        
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
                RageUI.Button(string.format("[ %s ] %s" .. "  :  " .. v[3], v[2], v[1]), "Press ~r~[ENTER] To accept  ~r~" .. v[1] .. "'s call!", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if v[2] == GetPlayerServerId(PlayerId()) then
                            notify("~r~You can't take your own Call!")
                        else
    
                            TriggerServerEvent('RemoveTicket', k, "nhs")
                            TriggerServerEvent('GetUpdatedCoords', v[2])
                            Wait(100)
                                SetNewWaypoint(targetCoords.x, targetCoords.y)
                     
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
    
            TriggerServerEvent('GetPermission')

            TriggerServerEvent('GetTickets')
            RageUI.Visible(RMenu:Get('callmanager', 'main'), not RageUI.Visible(RMenu:Get('callmanager', 'main')))
        end
    end
end)

RegisterNetEvent('RecievePerms')
AddEventHandler('RecievePerms', function(admin, pd, nhs)
    isPlayerAdmin = admin;
    isPlayerPD = pd;
    isPlayerNHS = nhs;
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

    TriggerEvent("ARMA:playerStaffonMode",true,false)
    isInTicket = true
end)

RegisterNetEvent("staffoff")
AddEventHandler("staffoff", function()

    TriggerEvent("ARMA:playerStaffonMode",false,false)
    isInTicket = false
end)

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

