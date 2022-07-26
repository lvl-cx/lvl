RMenu.Add('ARMANHSMenu', 'main', RageUI.CreateMenu("", "~b~NHS",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), 'nhs', 'nhs'))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('ARMANHSMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then

                RageUI.Button("Perform Cardiopulmonary Resuscitation (CPR)" , "Perform CPR on the nearest player in a coma", { RightLabel = '→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('ARMA:PerformCPR')
                    end
                end)
            end
        end)
    end
end)

RegisterCommand('nhs', function()
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
    TriggerServerEvent('ARMA:OpenNHSMenu')
  end
end)

RegisterNetEvent("ARMA:NHSMenuOpened")
AddEventHandler("ARMA:NHSMenuOpened",function()
  RageUI.Visible(RMenu:Get('ARMANHSMenu', 'main'), not RageUI.Visible(RMenu:Get('ARMANHSMenu', 'main')))
end)

RegisterKeyMapping('nhs', 'Opens the NHS menu', 'keyboard', 'U')