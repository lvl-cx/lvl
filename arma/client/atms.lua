local cfg = module("cfg/atms")
RMenu.Add('ARMAATM', 'main', RageUI.CreateMenu("", "~b~ATM",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), 'banners', 'atm'))
RMenu.Add("ARMAATM", "submenuwithdraw", RageUI.CreateSubMenu(RMenu:Get('ARMAATM', 'main',  tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight())))
RMenu.Add("ARMAATM", "submenudeposit", RageUI.CreateSubMenu(RMenu:Get('ARMAATM', 'main',  tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight())))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('ARMAATM', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("Deposit", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
            end, RMenu:Get("ARMAATM", "submenudeposit"))
            RageUI.Button("Withdraw", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
            end, RMenu:Get("ARMAATM", "submenuwithdraw"))
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('ARMAATM', 'submenuwithdraw')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("Current Action: Withdrawing", function() end)
            RageUI.Button("Custom Amount", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
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
                            TriggerServerEvent('ARMA:Withdraw', result)
                            PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
                        end
                    end
                end
            end)

            RageUI.Button("Withdraw All", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
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
                                TriggerServerEvent('ARMA:WithdrawAll')
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
    if RageUI.Visible(RMenu:Get('ARMAATM', 'submenudeposit')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("Current Action: Depositing", function() end)
            RageUI.Button("Custom Amount", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
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
                            TriggerServerEvent('ARMA:Deposit', result)
                            PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
                        end
                    end
                end
            end)

            RageUI.Button("Deposit All", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
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
                                TriggerServerEvent('ARMA:DepositAll')
                                PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
                            end
                        end
                    end
                end
            end)

        end)
    end
end)


local function f()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('ARMAATM', 'main'), true) 
end
local function g()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('ARMAATM', 'main'), false) 
end
local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		local i=function(j)
            tARMA.setCanAnim(false)
            f(j.atmId)
            a=true 
        end
        local k=function(j)
            g(j.atmId)
            tARMA.setCanAnim(true)
            a=false 
        end
        local l=function(j)
        end
        for m,n in pairs(cfg.atms) do
            tARMA.createArea("atm_"..m,n,1.5,6,i,k,l,{atmId=m})
            tARMA.addBlip(n.x,n.y,n.z,108,4,"ATM",0.8,true)
            tARMA.addMarker(n.x,n.y,n.z,0.7,0.7,0.5,0,255,125,125,50,29,false,false,true)
        end 
		firstspawn = 1
	end
end)

function tARMA.createAtm(q,r)
    local i=function()
        tARMA.setCanAnim(false)
        f()
        a=true 
    end
    local k=function()
        g()
        tARMA.setCanAnim(true)
        a=false 
    end
    local s=string.format("atm_%s",q)
    tARMA.createArea(s,r,1.5,6,i,k,function()
    end)
    local t=tARMA.addMarker(r.x,r.y,r.z,0.7,0.7,0.5,0,255,125,125,50,29,false,false,true)
    p[q]={area=s,marker=t}
end
function tARMA.deleteAtm(q)
    local u=p[q]
    if u then 
        tARMA.removeMarker(u.marker)
        tARMA.removeArea(u.area)
        p[q]=nil 
    end 
end