RMenu.Add('PoliceDutyMenu', 'main', RageUI.CreateMenu("", "~g~Sentry Clock On Menu", 1300, 50 ,'clockon', 'clockon'))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('PoliceDutyMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

            RageUI.Button("Commissioner" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOn', "Commissioner Clocked")
                    ExecuteCommand('blips')
                end
            end)
            
            RageUI.Button("Deputy Commissioner" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOn', "Deputy Commissioner Clocked")
                    ExecuteCommand('blips')
                end
            end)

            RageUI.Button("Assistant Commissioner" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOn', "Assistant Commissioner Clocked")
                    ExecuteCommand('blips')
                end
            end)

            RageUI.Button("Deputy Assistant Commissioner" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOn', "Deputy Assistant Commissioner Clocked")
                    ExecuteCommand('blips')
                end
            end)

            RageUI.Button("Commander" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOn', "Commander Clocked")
                    ExecuteCommand('blips')
                end
            end)

            RageUI.Button("Chief Superintendent" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOn', "Chief Superintendent Clocked")
                    ExecuteCommand('blips')
                end
            end)

            RageUI.Button("Superintendent" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOn', "Superintendent Clocked")
                    ExecuteCommand('blips')
                end
            end)

            RageUI.Button("Chief Inspector" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOn', "Chief Inspector Clocked")
                    ExecuteCommand('blips')
                end
            end)

            RageUI.Button("Inspector" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOn', "Inspector Clocked")
                    ExecuteCommand('blips')
                end
            end)

            RageUI.Button("Sergeant" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOn', "Sergeant Clocked")
                    ExecuteCommand('blips')
                end
            end)

            RageUI.Button("Special Police Constable" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOn', "Special Police Constable Clocked")
                    ExecuteCommand('blips')
                end
            end)

            RageUI.Button("Senior Police Constable" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOn', "Senior Police Constable Clocked")
                    ExecuteCommand('blips')
                end
            end)

            RageUI.Button("Police Constable" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOn', "Police Constable Clocked")
                    ExecuteCommand('blips')
                end
            end)

            RageUI.Button("Police Community Support Officer" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOn', "PCSO Clocked")
                    ExecuteCommand('blips')
                end
            end)

            RageUI.Button("[Clock Off]" , nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('PoliceMenu:ClockOff')
                    --[[ PD Armoury Weapons ]]--
                    RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLARE"))
                    RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLAREGUN"))
                    RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"))
                    RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_GLOCK"))
                    RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"))
                    RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_VINTAGEPISTOL"))
                    RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_REMINGTON870"))
                    RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"))
                    SetPedArmour(PlayerPedId(), 0)
                    ExecuteCommand('blips')

                end
            end)

            
        end) 
    end
end)

isInPoliceDutyMenu = false
currentPoliceDutyMenu = nil
Citizen.CreateThread(function() 
    while true do
            local x,y,z = 441.87026977539,-981.13433837891,30.689609527588
            local dutymenu = vector3(x,y,z)

            if isInArea(dutymenu, 100.0) then 
                DrawMarker(27, vector3(x,y,z-0.98), 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 0, 140, 255, 150, 0, 0, 0, true, 0, 0, 0)
            end
 
            if isInPoliceDutyMenu == false then
            if isInArea(dutymenu, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to open Police Duty Menu')
                if IsControlJustPressed(0, 51) then 
                    currentPoliceDutyMenu = k
                    TriggerServerEvent('PoliceMenu:CheckPermissions')
                    isInPoliceDutyMenu = true
                    currentPoliceDutyMenu = k 
                end
            end
            end
            if isInArea(dutymenu, 1.4) == false and isInPoliceDutyMenu and k == currentPoliceDutyMenu then
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("PoliceDutyMenu", "main"), false)
                isInPoliceDutyMenu = false
                currentPoliceDutyMenu = nil
            end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('PoliceDuty:Allowed')
AddEventHandler('PoliceDuty:Allowed', function(allowed)
    if allowed then
        RageUI.Visible(RMenu:Get("PoliceDutyMenu", "main"),true)
    elseif not allowed then
        RageUI.ActuallyCloseAll()
        RageUI.Visible(RMenu:Get("PoliceDutyMenu", "main"), false)
        notify("~r~You are not a part of the MET Police!")
    end
end)