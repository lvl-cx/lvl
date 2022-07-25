currentHours = 0

RMenu.Add('DailyRewards', 'main', RageUI.CreateMenu("","~b~Rewards",10,50, "banners", "rewards"))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('DailyRewards', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator('~g~You can claim multiple rewards')
            RageUI.Separator('~g~by simply playing the server.')
            RageUI.Separator('~g~Your current hours: ~b~'..currentHours)
            RageUI.ButtonWithStyle("~g~10 Hours","~y~You will receive £100,000.",{RightLabel = "→→→"},true,function(Hovered, Active, Selected) 
                if Selected then
                    TriggerServerEvent('ARMA:hoursReward', 10)
                end
            end) 
            RageUI.ButtonWithStyle("~g~25 Hours","~y~You will receive £250,000.",{RightLabel = "→→→"},true,function(Hovered, Active, Selected) 
                if Selected then
                    TriggerServerEvent('ARMA:hoursReward', 25)
                end
            end) 
            RageUI.ButtonWithStyle("~g~50 Hours","~y~You will receive £500,000.",{RightLabel = "→→→"},true,function(Hovered, Active, Selected) 
                if Selected then
                    TriggerServerEvent('ARMA:hoursReward', 50)
                end
            end) 
        end)
    end
end)

RegisterNetEvent('ARMA:sendHoursReward')
AddEventHandler('ARMA:sendHoursReward', function(hours)
    currentHours = hours
end)




RegisterCommand('rewards', function()
    TriggerServerEvent('ARMA:getHoursReward')
    RageUI.Visible(RMenu:Get('DailyRewards', 'main'), not RageUI.Visible(RMenu:Get('DailyRewards', 'main')))
end)
