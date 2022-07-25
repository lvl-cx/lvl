RMenu.Add('NHSDutyMenu', 'main', RageUI.CreateMenu("", "~b~Clock On", 1250,100,'banners', 'clockon'))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('NHSDutyMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

            RageUI.Button("Head Chief Medical Officer" , nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('NHSMenu:ClockOn', "Head Chief Medical Officer Clocked")
                end
            end)
            
            RageUI.Button("Assistant Chief Medical Officer" , nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('NHSMenu:ClockOn', "Assistant Chief Medical Officer Clocked")
                end
            end)

            RageUI.Button("Deputy Chief Medical Officer" , nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('NHSMenu:ClockOn', "Deputy Chief Medical Officer Clocked")
                end
            end)

            RageUI.Button("Captain" , nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('NHSMenu:ClockOn', "Captain Clocked")
                end
            end)

            RageUI.Button("Consultant" , nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('NHSMenu:ClockOn', "Consultant Clocked")
                end
            end)

            RageUI.Button("Specialist" , nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('NHSMenu:ClockOn', "Specialist Clocked")
                end
            end)

            RageUI.Button("Senior Doctor" , nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('NHSMenu:ClockOn', "Senior Doctor Clocked")
                end
            end)

            RageUI.Button("Junior Doctor" , nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('NHSMenu:ClockOn', "Junior Doctor Clocked")
                end
            end)

            RageUI.Button("Critical Care Paramedic" , nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('NHSMenu:ClockOn', "Critical Care Paramedic Clocked")
                end
            end)

            RageUI.Button("Paramedic" , nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('NHSMenu:ClockOn', "Paramedic Clocked")
                end
            end)

            RageUI.Button("Trainee Paramedic" , nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('NHSMenu:ClockOn', "Trainee Paramedic Clocked")
                end
            end)
            
            RageUI.Button("~b~Clock Off" , nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('NHSMenu:ClockOff')
                end
            end)

            
        end) 
    end
end)

isInNHSDutyMenu = false
currentNHSDutyMenu = nil
Citizen.CreateThread(function() 
    while true do
            local x,y,z = 311.38034057617,-594.16644287109,43.284099578857
            local dutymenu = vector3(x,y,z)

            if isInArea(dutymenu, 100.0) then 
                DrawMarker(27, vector3(x,y,z-0.9), 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 0, 200, 0, 150, 0, 0, 0, 0, 0, 0, 0)
            end
 
            if isInNHSDutyMenu == false then
            if isInArea(dutymenu, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to open NHS Duty Menu')
                if IsControlJustPressed(0, 51) then 
                    currentNHSDutyMenu = k
                    TriggerServerEvent('NHSMenu:CheckPermissions')
                    isInNHSDutyMenu = true
                    currentNHSDutyMenu = k 
                end
            end
            end
            if isInArea(dutymenu, 1.4) == false and isInNHSDutyMenu and k == currentNHSDutyMenu then
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("NHSDutyMenu", "main"), false)
                isInNHSDutyMenu = false
                currentNHSDutyMenu = nil
            end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('NHSDuty:Allowed')
AddEventHandler('NHSDuty:Allowed', function(allowed)
    if allowed then
        RageUI.Visible(RMenu:Get("NHSDutyMenu", "main"),true)
    elseif not allowed then
        RageUI.ActuallyCloseAll()
        RageUI.Visible(RMenu:Get("NHSDutyMenu", "main"), false)
    end
end)