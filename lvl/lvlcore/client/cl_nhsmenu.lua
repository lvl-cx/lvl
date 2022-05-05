RMenu.Add('EclipseNHSMenu', 'main', RageUI.CreateMenu("Eclipse NHS", "~g~NHS Menu",1250,100))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('EclipseNHSMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = true}, function()
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then

                RageUI.Button("Perform Cardiopulmonary Resuscitation (CPR)" , "~g~Perform CPR on the nearest player in a coma", { RightLabel = '→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        eclipse_server_callback('Eclipse:PerformCPR')
                    end
                end)

                RageUI.Button("Heal Nearest Player", "~g~Heal the nearest player", { RightLabel = '→'}, true, function(Hovered, Active, Selected) 
                  if Selected then 
                      eclipse_server_callback('Eclipse:HealPlayer')
                  end
              end)
                

            end
        end)
    end
end)

RegisterCommand('nhs', function()
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
    eclipse_server_callback('Eclipse:OpenNHSMenu')
  end
end)

RegisterNetEvent("Eclipse:NHSMenuOpened")
AddEventHandler("Eclipse:NHSMenuOpened",function()
  RageUI.Visible(RMenu:Get('EclipseNHSMenu', 'main'), not RageUI.Visible(RMenu:Get('EclipseNHSMenu', 'main')))
end)

RegisterKeyMapping('nhs', 'Opens the NHS menu', 'keyboard', 'U')