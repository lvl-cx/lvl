RMenu.Add('ARMAATM', 'main', RageUI.CreateMenu("", "~b~ATM",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), 'banners', 'atm'))
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('ARMAATM', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("Deposit", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) 
                if Selected then
                    local e = getAtmAmount()
                    if tonumber(e) then
                        if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
                            if a then
                                tARMA.playAnim(false, {{"amb@prop_human_atm@male@exit", "exit"}}, false)
                                TriggerServerEvent('ARMA:Deposit', tonumber(e))
                            else
                                tARMA.notify("~r~Not near ATM.")
                            end
                        else
                            tARMA.notify("~r~Get out your vehicle to use the ATM")
                        end
                    else
                        tARMA.notify("~r~Invalid amount.")
                    end
                end
            end)
            RageUI.Button("Withdraw", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) 
                if Selected then
                    local e = getAtmAmount()
                    if tonumber(e) then
                        if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
                            if a then
                                tARMA.playAnim(false, {{"amb@prop_human_atm@male@exit", "exit"}}, false)
                                TriggerServerEvent('ARMA:Withdraw', tonumber(e))
                            else
                                tARMA.notify("~r~Not near ATM.")
                            end
                        else
                            tARMA.notify("~r~Get out your vehicle to use the ATM")
                        end
                    else
                        tARMA.notify("~r~Invalid amount.")
                    end
                end
            end)
            RageUI.Button("Deposit All", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) 
                if Selected then
                    if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
                        if a then
                            tARMA.playAnim(false, {{"amb@prop_human_atm@male@exit", "exit"}}, false)
                            TriggerServerEvent('ARMA:DepositAll')
                        else
                            tARMA.notify("~r~Not near ATM.")
                        end
                    else
                        tARMA.notify("~r~Get out your vehicle to use the ATM")
                    end
                end
            end)
            RageUI.Button("Withdraw All", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) 
                if Selected then
                    if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
                        if a then
                            tARMA.playAnim(false, {{"amb@prop_human_atm@male@exit", "exit"}}, false)
                            TriggerServerEvent('ARMA:WithdrawAll')
                        else
                            tARMA.notify("~r~Not near ATM.")
                        end
                    else
                        tARMA.notify("~r~Get out your vehicle to use the ATM")
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

RegisterNetEvent("ARMA:setupAtms",function(h)
    local i = function(j)
        tARMA.setCanAnim(false)
        f()
        a = true
    end
    local k = function(j)
        g()
        tARMA.setCanAnim(true)
        a = false
    end
    local l = function(j)
    end
    for m, n in pairs(h) do
        tARMA.createArea("atm_" .. m, n, 1.5, 6, i, k, l, {atmId = m})
        tARMA.addBlip(n.x, n.y, n.z, 108, 4, "ATM", 0.8, true)
        tARMA.addMarker(n.x, n.y, n.z, 0.7, 0.7, 0.5, 0, 255, 125, 125, 50, 29, false, false, true)
    end
end)

function getAtmAmount()
    AddTextEntry("FMMC_MPM_NA", "Enter amount")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter amount", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local o = GetOnscreenKeyboardResult()
        if o then
            return o
        end
    end
    return false
end
local p = {}
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