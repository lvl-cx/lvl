RMenu.Add('ATMNHSMenu', 'main', RageUI.CreateMenu("", "~g~ATM NHS Menu", 1300, 50))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('ATMNHSMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = true}, function()
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then

                RageUI.Button("Perform Cardiopulmonary Resuscitation (CPR)" , nil, { RightLabel = '~g~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('ATM:PerformCPR')
                    end
                end)
            end
        end)
    end
end)

RegisterCommand('nhs', function()
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
    TriggerServerEvent('ATM:OpenNHSMenu')
  end
end)

RegisterNetEvent("ATM:NHSMenuOpened")
AddEventHandler("ATM:NHSMenuOpened",function()
  RageUI.Visible(RMenu:Get('ATMNHSMenu', 'main'), not RageUI.Visible(RMenu:Get('ATMNHSMenu', 'main')))
end)

RegisterKeyMapping('nhs', 'Opens the NHS menu', 'keyboard', 'U')