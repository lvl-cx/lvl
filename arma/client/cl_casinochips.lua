local a=1000
local b=1000
local c=1000
local d="0"
local e=vector3(924.99627685547,47.006057739258,81.104507446289)
local f=vector3(1089.6083984375,206.60050964355,-48.999725341797)
local g=vector3(967.6533203125,63.682018280029,112.55312347412)
local inCasino = false
RMenu.Add('ARMAChips','cashier',RageUI.CreateMenu("","",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"shopui_title_casino","shopui_title_casino"))
RMenu:Get('ARMAChips','cashier'):SetSubtitle("~b~CHIPS")
RMenu.Add('casino_enter','casino',RageUI.CreateMenu("","",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"shopui_title_casino","shopui_title_casino"))
RMenu:Get('casino_enter','casino'):SetSubtitle("~b~ENTER")
RMenu.Add('casino_exit','casino',RageUI.CreateMenu("","",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"shopui_title_casino","shopui_title_casino"))
RMenu:Get('casino_exit','casino'):SetSubtitle("~b~EXIT")
RMenu.Add('casino_rooftop_exit','casino',RageUI.CreateMenu("","",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"shopui_title_casino","shopui_title_casino"))
RMenu:Get('casino_rooftop_exit','casino'):SetSubtitle("~b~EXIT")
local h={{model=`u_f_m_casinocash_01`,pedPosition=vector3(1117.671,218.7382,-49.4),pedHeading=100.0,entryPosition=vector3(1116.0776367188,218.04238891602,-50.435089111328)},{model=`u_f_m_casinocash_01`,pedPosition=vector3(20.152572631836,6705.5737304688,-105.85441589355),pedHeading=75.0,entryPosition=vector3(18.445615768433,6705.7485351563,-106.85442352295)}}
Citizen.CreateThread(function()
    local i="mini@strip_club@idles@bouncer@base"
    RequestAnimDict(i)
    while not HasAnimDictLoaded(i)do 
        RequestAnimDict(i)
        Wait(0)
    end
    for j,k in pairs(h)do 
        local l=tARMA.LoadModel(k.model)
        local m=CreatePed(26,l,k.pedPosition.x,k.pedPosition.y,k.pedPosition.z,100.0,false,true)
        SetModelAsNoLongerNeeded(l)
        SetEntityCanBeDamaged(m,0)
        SetPedAsEnemy(m,0)
        SetBlockingOfNonTemporaryEvents(m,1)
        SetPedResetFlag(m,249,1)
        SetPedConfigFlag(m,185,true)
        SetPedConfigFlag(m,108,true)
        SetPedCanEvasiveDive(m,0)
        SetPedCanRagdollFromPlayerImpact(m,0)
        SetPedConfigFlag(m,208,true)
        SetEntityCollision(m,false)
        SetEntityCoordsNoOffset(m,k.pedPosition.x,k.pedPosition.y,k.pedPosition.z,100.0,0,0,1)
        SetEntityHeading(m,k.pedHeading)
        FreezeEntityPosition(m,true)
        TaskPlayAnim(m,i,"base",8.0,0.0,-1,1,0,0,0,0)
    end
    RemoveAnimDict(i)
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('ARMAChips', 'cashier')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Buy chips","",{RightLabel="→→→"},true,function(n,o,p)
                if p then 
                    local q=getCasinoChips()
                    if tonumber(q)then 
                        q=tonumber(q)
                        if q>0 then 
                            TriggerServerEvent("ARMA:buyChips",q)
                        else 
                            ARMA.notify("~r~Negative amount.")
                        end 
                    else 
                        ARMA.notify("~r~Invalid amount.")
                    end 
                end 
            end)
            RageUI.ButtonWithStyle("Sell chips","",{RightLabel="→→→"},true,function(n,o,p)
                if p then 
                    local q=getCasinoChips()
                    if tonumber(q)then 
                        q=tonumber(q)
                        if q>0 then 
                            TriggerServerEvent("ARMA:sellChips",q)
                        else 
                            ARMA.notify("~r~Negative amount.")
                        end 
                    else ARMA.notify("~r~Invalid amount.")
                    end 
                end 
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('casino_exit', 'casino')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Exit Diamond Casino","",{RightLabel="→→→"},true,function(n,o,p)
                if p then 
                    TriggerServerEvent("ARMA:exitDiamondCasino")
                    tARMA.teleport(e.x,e.y,e.z)
                    if cardObjects then 
                        for r,s in pairs(cardObjects)do 
                            for j,t in pairs(s)do 
                                DeleteObject(t)
                            end 
                        end 
                    end 
                    inCasino = false
                end 
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('casino_enter', 'casino')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Enter Diamond Casino","",{RightLabel="→→→"},true,function(n,o,p)
                if p then 
                    TriggerServerEvent("ARMA:enterDiamondCasino")
                    tARMA.teleport(f.x,f.y,f.z)
                    inCasino = true
                end 
            end)
            RageUI.ButtonWithStyle("Diamond Casino Rooftop","",{RightLabel="→→→"},true,function(n,o,p)
                if p then 
                    tARMA.teleport(g.x,g.y,g.z)
                end 
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('casino_rooftop_exit', 'casino')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Exit Rooftop","",{RightLabel="→→→"},true,function(n,o,p)
                if p then 
                    tARMA.teleport(e.x,e.y,e.z)
                end 
            end)
        end)
    end
end)

function showCasinoChipsCashier(u)
    RageUI.Visible(RMenu:Get('ARMAChips','cashier'),u)
end
function showCasinoEnter(u)
    RageUI.Visible(RMenu:Get('casino_enter','casino'),u)
end
function showCasinoRooftopExit(u)
    RageUI.Visible(RMenu:Get('casino_rooftop_exit','casino'),u)
end
function showCasinoExit(u)
    RageUI.Visible(RMenu:Get('casino_exit','casino'),u)
end
Citizen.CreateThread(function()
    while true do 
        if a<1.5 then 
            showCasinoEnter(true)
        elseif a<2.5 then 
            showCasinoEnter(false)
        end
        if b<1.5 then 
            showCasinoExit(true)
        elseif b<2.5 then 
            showCasinoExit(false)
        end
        if c<1.5 then 
            showCasinoRooftopExit(true)
        elseif c<2.5 then 
            showCasinoRooftopExit(false)
        end
        Wait(0)
    end 
end)
Citizen.CreateThread(function()
    while true do 
        DrawMarker(27,e.x,e.y,e.z-1.0,0,0,0,0,0,0,1.001,1.0001,0.5001,255,255,255,200,0,0,0,0)
        DrawMarker(27,f.x,f.y,f.z-1.0,0,0,0,0,0,0,1.001,1.0001,0.5001,255,255,255,200,0,0,0,0)
        DrawMarker(27,g.x,g.y,g.z-1.0,0,0,0,0,0,0,1.001,1.0001,0.5001,255,255,255,200,0,0,0,0)
        Wait(0)
    end 
end)
Citizen.CreateThread(function()
    while true do 
        local v=GetEntityCoords(tARMA.getPlayerPed())
        a=#(v-e)
        b=#(v-f)
        c=#(v-g)
        Wait(100)
    end 
end)
function getCasinoChips()
    AddTextEntry('FMMC_MPM_NA',"Enter chips")
    DisplayOnscreenKeyboard(1,"FMMC_MPM_NA","Enter chips","","","","",30)
    while UpdateOnscreenKeyboard()==0 do 
        DisableAllControlActions(0)Wait(0)
    end
    if GetOnscreenKeyboardResult()then 
        local w=GetOnscreenKeyboardResult()
        if w then 
            return w 
        end 
    end
    return false 
end
RegisterNetEvent("ARMA:setDisplayChips")
AddEventHandler("ARMA:setDisplayChips",function(x)
    local y=tostring(x)
    d=getMoneyStringFormatted(y)
end)

RegisterNetEvent("ARMA:chipsUpdated",function()
    TriggerServerEvent('ARMA:getChips')
end)

local z={{position=vector3(1149.3828125,269.19174194336,-52.020873718262),radius=100},{position=vector3(54.053936004639,6742.1513671875,-107.354347229),radius=100},{position=vector3(-1896.8582763672,2069.3537597656,144.86274719238),radius=10},{position=vector3(774.75134277344,-552.91137695312,22.498882293701),radius=100},{position=vector3(-1137.8917236328,-184.71762084961,40.0803565979),radius=50},{position=vector3(422.06201171875,18.277492523193,91.935234069824),radius=25}}


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if inCasino then       
            if isInArea(vector3(1115.98046875,217.99314880371,-49.435111999512), 0.8) then 
                RageUI.Visible(RMenu:Get("ARMAChips", "cashier"), true)
                chipsMenu = true
            end
            if isInArea(vector3(1115.98046875,217.99314880371,-49.435111999512), 0.8) == false and chipsMenu then
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("ARMAChips", "cashier"), false)
                chipsMenu = false
            end
            for H,k in pairs(h)do 
                tARMA.addBlip(k.entryPosition.x,k.entryPosition.y,k.entryPosition.z,683,0,"Chips Cashier",0.7,true)
            end
            SetScriptGfxDrawOrder(7)
            DrawSprite("CommonMenu","shop_chips_b",0.89,0.078,0.025,0.030,0.0,255,255,255,255)
            SetScriptGfxDrawOrder(1)
            DrawRect(0.934,0.077,0.104,0.036,0,0,0,150)
            DrawAdvancedTextNoOutline(1.037,0.08,0.005,0.0028,0.52,d,255,255,255,255,7,0)
        end
    end 
end)

function DrawAdvancedTextNoOutline(v,w,x,y,z,A,B,C,D,E,F,G)
    SetTextFont(F)
    SetTextProportional(0)
    SetTextScale(z,z)
    N_0x4e096588b13ffeca(G)
    SetTextColour(B,C,D,E)
    SetTextDropShadow()
    SetTextEntry("STRING")
    AddTextComponentString(A)
    DrawText(v-0.1+x,w-0.02+y)
end

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end