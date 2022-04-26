local cfg = module("cfg/atms")
RMenu.Add('ATMATM', 'main', RageUI.CreateMenu("", "~g~ATM ATM",1300, 50, 'atm', 'atm'))
RMenu.Add("ATMATM", "submenuwithdraw", RageUI.CreateSubMenu(RMenu:Get('ATMATM', 'main',  1300, 50)))
RMenu.Add("ATMATM", "submenudeposit", RageUI.CreateSubMenu(RMenu:Get('ATMATM', 'main',  1300, 50)))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('ATMATM', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("Deposit", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                if Selected then 

                end
            end, RMenu:Get("ATMATM", "submenudeposit"))
      
            RageUI.Button("Withdraw", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                if Selected then 

                end
            end, RMenu:Get("ATMATM", "submenuwithdraw"))
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('ATMATM', 'submenuwithdraw')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("~g~Current Action: Withdrawing", function() end)
            RageUI.Button("Custom Amount", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                if Selected then 
                    AddTextEntry('FMMC_MPM_NC', "Enter Amount to Withdraw")
                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                        Wait(0);
                    end
                    if (GetOnscreenKeyboardResult()) then
                        local result = GetOnscreenKeyboardResult()
                        if result then 
                            result = tonumber(result)
                            TriggerServerEvent('ATM:Withdraw', result)
                            PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
                        end
                    end
                end
            end)

            RageUI.Button("Withdraw All", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                if Selected then 
                    AddTextEntry('FMMC_MPM_NC', "Type [Yes] to confirm withdrawal of full amount.")
                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                        Wait(0);
                    end
                    if (GetOnscreenKeyboardResult()) then
                        local result = GetOnscreenKeyboardResult()
                        if result then 
                            if string.upper(result) == 'YES' then
                                TriggerServerEvent('ATM:WithdrawAll')
                                PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
                            end
                        end
                    end
                end
            end)
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('ATMATM', 'submenudeposit')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("~g~Current Action: Depositing", function() end)
            RageUI.Button("Custom Amount", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                if Selected then 
                    AddTextEntry('FMMC_MPM_NC', "Enter Amount to Deposit")
                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                        Wait(0);
                    end
                    if (GetOnscreenKeyboardResult()) then
                        local result = GetOnscreenKeyboardResult()
                        if result then 
                            result = tonumber(result)
                            TriggerServerEvent('ATM:Deposit', result)
                            PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
                        end
                    end
                end
            end)

            RageUI.Button("Deposit All", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                if Selected then 
                    AddTextEntry('FMMC_MPM_NC', "Type [Yes] to confirm deposit of full amount.")
                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                        Wait(0);
                    end
                    if (GetOnscreenKeyboardResult()) then
                        local result = GetOnscreenKeyboardResult()
                        if result then 
                            if string.upper(result) == 'YES' then
                                TriggerServerEvent('ATM:DepositAll')
                                PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
                            end
                        end
                    end
                end
            end)

        end)
    end
end)



Citizen.CreateThread(function()
    for i,v in pairs(cfg.atms) do 
        local x,y,z = v[1], v[2], v[3]
        local Blip = AddBlipForCoord(x, y, z)
        SetBlipSprite(Blip, 272)
        SetBlipDisplay(Blip, 4)
        SetBlipScale(Blip, 0.5)
        SetBlipColour(Blip, 2)
        SetBlipAsShortRange(Blip, true)
        AddTextEntry("MAPBLIP", 'ATMs')
        BeginTextCommandSetBlipName("MAPBLIP")
        EndTextCommandSetBlipName(Blip)
        SetBlipCategory(Blip, 1)
    end
end)


Citizen.CreateThread(function()
    while true do 
        Wait(0)
        for i,v in pairs(cfg.atms) do 
            local x,y,z = v[1], v[2], v[3]
            DrawMarker(29, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.4, 00, 255, 00, 250, true, true, false, false, nil, nil, false)
        end 
    end
end)

local MenuOpen = false;
local inMarker = false;
Citizen.CreateThread(function()
    while true do 
        Wait(250)
        inMarker = false
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for i,v in pairs(cfg.atms) do 
            local x,y,z = v[1], v[2], v[3]
            if #(coords - vec3(x,y,z)) <= 1.0 then
                inMarker = true 
                break
            end    
        end
        if not MenuOpen and inMarker then 
            MenuOpen = true 
            PlaySound(-1,"Hit","RESPAWN_SOUNDSET",0,0,1)
            RageUI.Visible(RMenu:Get('ATMATM', 'main'), true) 
        end
        if MenuOpen and not inMarker then 
            MenuOpen = false 
            PlaySound(-1,"Hit","RESPAWN_SOUNDSET",0,0,1)
            RageUI.ActuallyCloseAll()
            RageUI.Visible(RMenu:Get('ATMATM', 'main'), false) 
        end
    end
end)
