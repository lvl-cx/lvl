local cfg = module("cfg/atms")
RMenu.Add('SentryATM', 'main', RageUI.CreateMenu("", "~g~Sentry ATM",1300, 50, 'atm', 'atm'))
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('SentryATM', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("Deposit", nil, {}, true, function(Hovered, Active, Selected) 
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
                            TriggerServerEvent('Sentry:Deposit', result)
                            PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
                        end
                    end
                end
            end)
            RageUI.Button("Withdraw", nil, {}, true, function(Hovered, Active, Selected) 
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
                            TriggerServerEvent('Sentry:Withdraw', result)
                            PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
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
            RageUI.Visible(RMenu:Get('SentryATM', 'main'), true) 
        end
        if MenuOpen and not inMarker then 
            MenuOpen = false 
            PlaySound(-1,"Hit","RESPAWN_SOUNDSET",0,0,1)
            RageUI.ActuallyCloseAll()
            RageUI.Visible(RMenu:Get('SentryATM', 'main'), false) 
        end
    end
end)
