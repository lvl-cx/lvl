RMenu.Add('SettingsMenu', 'MainMenu', RageUI.CreateMenu("", menuColour.."Settings Menu", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "banners","settings")) 
RMenu.Add("SettingsMenu", "crosshairsettings", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu"), "", menuColour..'Crosshair Settings',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners","settings"))

local df = {{"10%", 0.1},{"20%", 0.2},{"30%", 0.3},{"40%", 0.4},{"50%", 0.5},{"60%", 0.6},{"70%", 0.7},{"80%", 0.8},{"90%", 0.9},{"100%", 1.0},{"150%", 1.5},{"200%", 2.0},{"250%", 2.5},{"300%", 3.0},{"350%", 3.5},{"400%", 4.0},{"450%", 4.5},{"500%", 5.0},{"600%", 6.0},{"700%", 7.0},{"800%", 8.0},{"900%", 9.0},{"1000%", 10.0},}
local d = {"10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%", "150%", "200%", "250%", "300%", "350%", "400%", "450%", "500%", "600%", "700%", "800%", "900%", "1000%"}
local dts = 10

local a=0
local b=0
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('SettingsMenu', 'MainMenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.List("Modify Render Distance", d, dts, "~b~Change Render Distance", {}, true, function(a,b,c,d)
                if c then end
                dts = d
            end)
            RageUI.Checkbox("Toggle Compass", nil, compasschecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if Selected then
                    compasschecked = not compasschecked
                    ExecuteCommand("compass")
                end
            end)
            RageUI.Checkbox("Enable Diagonal Weapons","~g~This changes the way weapons look on your back from vertical to diagonal.",a,{Style=RageUI.CheckboxStyle.Car},function(Hovered, Active, Selected, Checked)
                if Selected then
                    if a then
                        TriggerEvent("ARMA:setVerticalWeapons")
                        a=false
                        tARMA.setDiagonalWeaponSetting(a)
                    else
                        TriggerEvent("ARMA:setDiagonalWeapons")
                        a=true
                        tARMA.setDiagonalWeaponSetting(a)
                    end
                end
            end)
            RageUI.Checkbox("Enable Experimental Hit Marker Sounds","~g~This adds 'hit marker' sounds when shooting another player, however it can be unreliable.",b,{Style=RageUI.CheckboxStyle.Car},function(Hovered, Active, Selected, Checked)
                if Selected then
                    if b then
                        TriggerEvent("hs:triggerSounds", false)
                        b=false
                        tARMA.setHitMarkerSetting(b)
                        tARMA.notify("~y~Experimental Headshot sounds now set to "..tostring(b))
                    else
                        TriggerEvent("hs:triggerSounds", true)
                        b=true
                        tARMA.setHitMarkerSetting(b)
                        tARMA.notify("~y~Experimental Headshot sounds now set to "..tostring(b))
                    end
                end
            end)
            RageUI.Checkbox("Toggle Hud", nil, hudchecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if Selected then
                    hudchecked = not hudchecked
                    if Checked then
                        ExecuteCommand('showhud')
                    else
                        ExecuteCommand('showhud')
                    end
                end
            end)
            RageUI.Checkbox("Toggle Killfeed", nil, killfeedchecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if Selected then
                    killfeedchecked = not killfeedchecked
                    if Checked then
                        ExecuteCommand('killfeed')
                    else
                        ExecuteCommand('killfeed')
                    end
                end
            end)
            RageUI.ButtonWithStyle("Crosshair Settings", "Create a custom built-in crosshair here.", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ExecuteCommand('crosshair')
                end
            end)
       end)
    end
end)


RegisterNetEvent('ARMA:sendSettings')
AddEventHandler('ARMA:sendSettings', function()
    if GetResourceKvpInt('hitsoundchecked') == 1 then
        hitsoundchecked = true
        TriggerEvent("hs:triggerSounds", true)
    end
end)

RegisterNetEvent('ARMA:OpenSettingsMenu')
AddEventHandler('ARMA:OpenSettingsMenu', function(admin)
    if not admin then
        RageUI.Visible(RMenu:Get("SettingsMenu", "MainMenu"), true)
    end
end)

RegisterCommand('opensettingsmenu',function()
    TriggerServerEvent('ARMA:OpenSettings')
end)

RegisterKeyMapping('opensettingsmenu', 'Opens the Settings menu', 'keyboard', 'F2')

Citizen.CreateThread(function() 
    while true do
        Citizen.InvokeNative(0xA76359FC80B2438E, df[dts][2])      
        Citizen.Wait(0)
    end
end)
