local cfg = module("cfg/weapons")
local weapons = cfg.weapons
local inWeaponDev = false

RMenu.Add('armaweapondev','main',RageUI.CreateMenu("","~b~Weapon Development",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "gunstore"))
RMenu.Add('armaweapondev','weapons',RageUI.CreateSubMenu(RMenu:Get("armaweapondev","main"),"","~b~Weapon List",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "gunstore"))
TriggerEvent('chat:addSuggestion','/weapondev','Toggle the Weapon Development Menu')

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('armaweapondev', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if inWeaponDev then
                if inWeaponDev then
                    RageUI.ButtonWithStyle("Spawn Weapon", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            tARMA.clientPrompt("Spawncode:","",function(result)
                                if result~="" and (tARMA.getUserId() == 163 or tARMA.getUserId() == 1 or tARMA.getUserId() == 6) then 
                                    tARMA.allowWeapon(result)
                                    GiveWeaponToPed(PlayerPedId(), result, 250, false, true)
                                end 
                            end)
                        end
                    end)
                    RageUI.ButtonWithStyle("Weapon List", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end, RMenu:Get('armaweapondev', 'weapons'))
                    RageUI.Checkbox("Return to normal Universe", "~r~Leave Weapon Dev Mode", inWeaponDev, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            DoScreenFadeOut(1000)
                            NetworkFadeOutEntity(PlayerPedId(), true, false)
                            Wait(1000)
                            NetworkFadeInEntity(PlayerPedId(), 0)
                            DoScreenFadeIn(1000)
                            inWeaponDev=false
                            TriggerServerEvent("ARMA:setWeaponDev",inWeaponDev)
                            RemoveAllPedWeapons(PlayerPedId(), true)
                        end
                    end)
                else
                    RageUI.Checkbox("Teleport to Weapon Dev Universe", "~g~Enter Weapon Dev Mode", inWeaponDev, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            DoScreenFadeOut(1000)
                            NetworkFadeOutEntity(PlayerPedId(), true, false)
                            Wait(1000)
                            NetworkFadeInEntity(PlayerPedId(), 0)
                            DoScreenFadeIn(1000)
                            inWeaponDev=true
                            TriggerServerEvent("ARMA:setWeaponDev",inWeaponDev)
                        end
                    end)
                    RageUI.Separator("~g~Enter Weapon Dev Mode to see more options.")
                end
            else
                RageUI.Checkbox("Teleport to Weapon Dev Universe", "~g~Enter Weapon Dev Mode", inWeaponDev, {}, function(Hovered, Active, Selected, Checked)
                    if Selected then
                        DoScreenFadeOut(1000)
                        NetworkFadeOutEntity(PlayerPedId(), true, false)
                        Wait(1000)
                        NetworkFadeInEntity(PlayerPedId(), 0)
                        DoScreenFadeIn(1000)
                        inWeaponDev=true
                        TriggerServerEvent("ARMA:setWeaponDev",inWeaponDev)
                        RemoveAllPedWeapons(PlayerPedId(), true)
                    end
                end)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('armaweapondev', 'weapons')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if inWeaponDev then
                for k,v in pairs(weapons) do
                    RageUI.ButtonWithStyle(v.name,k,{RightLabel="→→→"},true,function(Hovered, Active, Selected) 
                        if Selected then
                            tARMA.allowWeapon(k)
                            GiveWeaponToPed(PlayerPedId(), k, 250, false, true)
                        end
                    end)
                end
            end
        end)
    end
end)

RegisterCommand('weapondev', function()
    if tARMA.getUserId() == 163 or tARMA.getUserId() == 1 or tARMA.getUserId() == 6 then
        RageUI.Visible(RMenu:Get('armaweapondev', 'main'), not RageUI.Visible(RMenu:Get('armaweapondev', 'main')))
    end
end)