currentHours = 0
local dailyRewards = {}

RMenu.Add('DailyRewards', 'main', RageUI.CreateMenu("","~b~Rewards",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "banners", "rewards"))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('DailyRewards', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator('~g~You can claim multiple rewards')
            RageUI.Separator('~g~by simply playing the server.')
            RageUI.Separator('~g~Your current hours: ~b~'..currentHours)
            for k,v in pairs(dailyRewards) do
                RageUI.ButtonWithStyle("~g~"..k.." Hours", "~y~You will receive £"..getMoneyStringFormatted(k*10000), {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) 
                    if Selected then
                        TriggerServerEvent('ARMA:hoursReward', k)
                    end
                end) 
            end
        end)
    end
end)

RegisterNetEvent('ARMA:sendHoursReward')
AddEventHandler('ARMA:sendHoursReward', function(hours, rewards)
    currentHours = hours
    dailyRewards = rewards
end)

RegisterCommand('rewards', function()
    TriggerServerEvent('ARMA:getHoursReward')
    RageUI.Visible(RMenu:Get('DailyRewards', 'main'), not RageUI.Visible(RMenu:Get('DailyRewards', 'main')))
end)
