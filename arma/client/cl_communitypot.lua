local a="0"
RMenu.Add("communitypot","mainmenu",RageUI.CreateMenu("Community Pot","",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),nil,nil))
RMenu:Get("communitypot","mainmenu"):SetSubtitle("~b~Community Pot")
local function b()
    AddTextEntry('FMMC_MPM_NA',"Enter amount")
    DisplayOnscreenKeyboard(1,"FMMC_MPM_NA","Enter amount","","","","",30)
    while UpdateOnscreenKeyboard()==0 do 
        DisableAllControlActions(0)
        Wait(0)
    end;
    if GetOnscreenKeyboardResult()then 
        local c=GetOnscreenKeyboardResult()
        if c then 
            return c 
        end 
    end;
    return false 
end;
RegisterNetEvent("ARMA:gotCommunityPotAmount",function(d)
    a=tostring(d)
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('communitypot', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("Community Pot Balance: ~g~£"..getMoneyStringFormatted(a))
            RageUI.ButtonWithStyle("Deposit","",{RightLabel="→→→"},true,function(e,f,g)
                if g then 
                    local d=b()
                    if tonumber(d)then 
                        TriggerServerEvent("ARMA:tryDepositCommunityPot",d)
                    else 
                        tARMA.notify("~r~Invalid amount.")
                    end 
                end 
            end)
            RageUI.ButtonWithStyle("Withdraw","",{RightLabel="→→→"},true,function(e,f,g)
                if g then 
                    local d=b()
                    if tonumber(d)then 
                        TriggerServerEvent("ARMA:tryWithdrawCommunityPot",d)
                    else 
                        tARMA.notify("~r~Invalid amount.")
                    end 
                end 
            end)
        end)
    end
end)