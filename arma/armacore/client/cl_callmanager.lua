local adminTickets = {}
local pdCalls = {}
local NHSCalls = {}
local isInTicket = false

RMenu.Add('callmanager', 'main', RageUI.CreateMenu("", '~b~Call Manager', 1300, 50, 'manager', 'manager'))
RMenu.Add("callmanager", "admin", RageUI.CreateSubMenu(RMenu:Get("callmanager", "main",  1300, 50)))
RMenu.Add("callmanager", "police", RageUI.CreateSubMenu(RMenu:Get("callmanager", "main",  1300, 50)))
RMenu.Add("callmanager", "nhs", RageUI.CreateSubMenu(RMenu:Get("callmanager", "main",  1300, 50)))
RMenu:Get('callmanager', 'main')

RageUI.CreateWhile(1.0, RMenu:Get("callmanager", "main"), nil, function()
    RageUI.IsVisible(RMenu:Get("callmanager", "main"), true, false, true, function()
        if next(adminTickets) then
            RageUI.Button("Admin Tickets", "", {}, true, function(Hovered, Active, Selected)
                if Selected then
                    RMenu.Visible(RMenu:Get("callmanager", "admin"), true)
                end
            end)
        end
        if next(PDCalls) then
            RageUI.Button("POlice Calls", "", {}, true, function(Hovered, Active, Selected)
                if Selected then
                    RMenu.Visible(RMenu:Get("callmanager", "police"), true)
                end
            end)
        end
        if next(NHSCalls) then
            RageUI.Button("NHS Calls", "", {}, true, function(Hovered, Active, Selected)
                if Selected then
                    RMenu.Visible(RMenu:Get("callmanager", "nhs"), true)
                end
            end)
        end
        end, function()
    end)
    RageUI.IsVisible(RMenu:Get("callmanager", "admin"), true, false, true, function()
        for k, v in pairs(adminTickets) do
            RageUI.Button("["..v.permID.."] "..v.name.." : "..k, nil, "", true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("Jud:TakeTicket", k, 'Admin')
                end
            end)
        end
        end, function()
    end)
    RageUI.IsVisible(RMenu:Get("callmanager", "police"), true, false, true, function()
        for k, v in pairs(pdCalls) do
            RageUI.Button("["..v.permID.."] "..v.name.." : "..k, nil, "", true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("Jud:TakeTicket", k, 'PD')
                    SetNewWaypoint(v.coords.x, v.coords.y)
                end
            end)
        end
        end, function()
    end)
    RageUI.IsVisible(RMenu:Get("callmanager", "nhs"), true, false, true, function()
        for k, v in pairs(NHSCalls) do
            RageUI.Button("["..v.permID.."] "..v.name.." : "..k, nil, "", true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("Jud:TakeTicket", k, 'NHS')
                    SetNewWaypoint(v.coords.x, v.coords.y)
                end
            end)
        end
        end, function()
    end)
end)

RegisterNetEvent("Jud:RecieveTickets")
AddEventHandler("Jud:RecieveTickets", function(a, b, c)
    adminTickets = a
    pdCalls = b
    NHSCalls = c
end)

RegisterCommand("callmanager", function(source)
    TriggerServerEvent("Jud:RequestTickets")
    RageUI.Visible(RMenu:Get("callmanager", "main"), true)
end)

RegisterNetEvent('Jud:sendTicketInfo')
AddEventHandler('Jud:sendTicketInfo', function(permid, name)
    if permid ~= nil and name ~= nil then
        isInTicket = true
    else
        isInTicket = false
    end
    while isInTicket do
        Wait(0)
        if permid ~= nil and name ~= nil then
            drawNativeText("~y~You've taken the ticket of " ..name.. "("..permid..")", 255, 0, 0, 255, true)   
        end
    end
end)

RegisterKeyMapping("callmanager", "Opens Callmanager Menu", "keyboard", "m")

function drawNativeText(V)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(V)
    EndTextCommandPrint(100, 1)
end