RMenu.Add('vipclubmenu','mainmenu',RageUI.CreateMenu("","",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu:Get('vipclubmenu','mainmenu'):SetSubtitle("~b~ARMA VIP Membership")
RMenu.Add('vipclubmenu','managesubscription',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu:Get('vipclubmenu','managesubscription'):SetSubtitle("~b~ARMA VIP Membership")
RMenu.Add('vipclubmenu','manageusersubscription',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu:Get('vipclubmenu','manageusersubscription'):SetSubtitle("~b~ARMA VIP Membership")
RMenu.Add('vipclubmenu','manageperks',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu:Get('vipclubmenu','manageperks'):SetSubtitle("~b~ARMA VIP Membership")
RMenu.Add('vipclubmenu','deathsounds',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','manageperks'),"","",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu:Get('vipclubmenu','deathsounds'):SetSubtitle("~b~ARMA VIP Membership")
RMenu.Add('vipclubmenu','vehicleextras',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','manageperks'),"","",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu:Get('vipclubmenu','vehicleextras'):SetSubtitle("~b~ARMA VIP Membership")
local a={hoursOfPlus=0,hoursOfPlatinum=0}
local z={}

function tARMA.isPlusClub()
    if a.hoursOfPlus>0 then 
        return true 
    else 
        return false 
    end 
end

function tARMA.isPlatClub()
    if a.hoursOfPlatinum>0 then 
        return true 
    else 
        return false 
    end 
end

RegisterCommand("vipclub",function()
    TriggerServerEvent('ARMA:getPlayerSubscription')
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('vipclubmenu','mainmenu'),not RageUI.Visible(RMenu:Get('vipclubmenu','mainmenu')))
end)

local d={
    ["Default"]={checked=true,soundId="dead"},
    ["Fortnite"]={checked=false,soundId="fortnite_death"},
    ["Roblox"]={checked=false,soundId="roblox_death"},
    ["Minecraft"]={checked=false,soundId="minecraft_death"},
    ["Pac-Man"]={checked=false,soundId="pacman_death"},
    ["Mario"]={checked=false,soundId="mario_death"},
    ["CS:GO"]={checked=false,soundId="csgo_death"}
}

local E=true
Citizen.CreateThread(function()
    local f=GetResourceKvpString("ARMA_vipParachute") or "true"
    if f=="true"then
        E=true
    else 
        E=true
    end 
end)
function tARMA.setParachuteSetting(f)
    SetResourceKvp("ARMA_vipParachute",tostring(f))
end

AddEventHandler("playerSpawned", function()
    TriggerServerEvent('ARMA:getPlayerSubscription')
    Wait(5000)
    local i=tARMA.getDeathSound()
    local j="dead"
    for k,l in pairs(d)do 
        if l.soundId==i then 
            j=k 
        end 
    end
    for k,m in pairs(d)do 
        if j~=k then 
            m.checked=false 
        else 
            m.checked=true 
        end 
    end 
end)

function tARMA.setDeathSound(i)
    if tARMA.isPlusClub() or tARMA.isPlatClub() then 
        SetResourceKvp("ARMA_deathsound",i)
    else 
        tARMA.notify("~r~Cannot change deathsound, not a valid ARMA Plus or Platinum subscriber.")
    end 
end
function tARMA.getDeathSound()
    if tARMA.isPlusClub() or tARMA.isPlatClub() then 
        local k=GetResourceKvpString("ARMA_deathsound")
        if type(k) == "string" and k~="" then 
            return k 
        else 
            return "dead"
        end 
    else 
        return "dead"
    end 
end
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Manage Subscription","",{RightLabel="→→→"},true,function(o,p,q)
            end,RMenu:Get("vipclubmenu","managesubscription"))
            if tARMA.isPlusClub() or tARMA.isPlatClub()then 
                RageUI.ButtonWithStyle("Manage Perks","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("vipclubmenu","manageperks"))
            end
            if tARMA.isDev() then
                RageUI.ButtonWithStyle("Manage User's Subscription","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("vipclubmenu","manageusersubscription"))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'managesubscription')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            colourCode = getColourCode(a.hoursOfPlus)
            RageUI.Separator("Days remaining of Plus Subscription: "..colourCode..math.floor(a.hoursOfPlus/24*100)/100 .." days.")
            colourCode = getColourCode(a.hoursOfPlatinum)
            RageUI.Separator("Days remaining of Platinum Subscription: "..colourCode..math.floor(a.hoursOfPlatinum/24*100)/100 .." days.")
            RageUI.Separator()
            RageUI.ButtonWithStyle("Sell Plus Subscription days.","~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",{RightLabel="→→→"},true,function(o,p,q)
                if q then 
                    TriggerServerEvent("ARMA:beginSellSubscriptionToPlayer","Plus")
                end 
            end)
            RageUI.ButtonWithStyle("Sell Platinum Subscription days.","~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",{RightLabel="→→→"},true,function(o,p,q)
                if q then 
                    TriggerServerEvent("ARMA:beginSellSubscriptionToPlayer","Platinum")
                end 
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'manageusersubscription')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tARMA.isDev() then
                if next(z) then
                    RageUI.Separator('Perm ID: '..z.userid)
                    colourCode = getColourCode(z.hoursOfPlus)
                    RageUI.Separator('Days of Plus Remaining: '..colourCode..math.floor(z.hoursOfPlus/24*100)/100)
                    colourCode = getColourCode(z.hoursOfPlatinum)
                    RageUI.Separator('Days of Platinum Remaining: '..colourCode..math.floor(z.hoursOfPlatinum/24*100)/100)
                    RageUI.ButtonWithStyle("Set Plus Days (in hours)","This has to be set in hours.",{RightLabel="→→→"},true,function(o,p,q)
                        if q then
                            TriggerServerEvent("ARMA:setPlayerSubscription", z.userid, "Plus")
                        end
                    end)
                    RageUI.ButtonWithStyle("Set Platinum Days (in hours)","This has to be set in hours.",{RightLabel="→→→"},true,function(o,p,q)
                        if q then
                            TriggerServerEvent("ARMA:setPlayerSubscription", z.userid, "Platinum")
                        end
                    end)    
                else
                    RageUI.Separator('Please select a Perm ID')
                end
                RageUI.ButtonWithStyle("Select Perm ID", nil, { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        permID = tARMA.KeyboardInput("Enter Perm ID", "", 10)
                        if permID == nil then 
                            tARMA.notify('~r~Invalid Perm ID')
                        end
                        TriggerServerEvent('ARMA:getPlayerSubscription', permID)
                    end
                end, RMenu:Get("vipclubmenu", 'manageusersubscription'))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'manageperks')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Custom Death Sounds","",{RightLabel="→→→"},true,function(o,p,q)
            end,RMenu:Get("vipclubmenu","deathsounds"))
            RageUI.ButtonWithStyle("Vehicle Extras","",{RightLabel="→→→"},true,function(o,p,q)
            end,RMenu:Get("vipclubmenu","vehicleextras"))
            RageUI.ButtonWithStyle("Claim Weekly Kit","",{RightLabel="→→→"},true,function(o,p,q)
                if q then 
                    TriggerServerEvent("ARMA:claimWeeklyKit")
                end 
            end)
            local function R()
                E=true
                tARMA.setParachuteSetting(E)
                tARMA.notify("~g~Parachute enabled.")
            end
            local function S()
                E=false
                tARMA.setParachuteSetting(E)
                tARMA.notify("~r~Parachute disabled.")
            end
            RageUI.Checkbox("Enable Parachute","~g~This gives you a primary and reserve parachute.",E,{Style=RageUI.CheckboxStyle.Car},function(o,q,p,t)
                if p then
                    if E then
                        S()
                    else
                        R()
                    end
                end
            end,R,S)
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'deathsounds')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for u,l in pairs(d) do 
                RageUI.Checkbox(u, "", l.checked, {Style = RageUI.CheckboxStyle.Tick}, function(Hovered, Selected, Active, Checked)
                    if Selected then
                        if l.checked then
                            for k,v in pairs(d)do 
                                if k~=u then 
                                    v.checked=false
                                end 
                            end
                            tARMA.setDeathSound(l.soundId)
                        end
                    end
                    l.checked = Checked
                end)
            end 
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'vehicleextras')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            local w=tARMA.getPlayerVehicle()
            SetVehicleAutoRepairDisabled(w,true)
            for x=1,99,1 do 
                if DoesExtraExist(w,x)then 
                    RageUI.Checkbox("Extra "..x,"",IsVehicleExtraTurnedOn(w,x),{},function()
                    end,function()
                        SetVehicleExtra(w,x,0)
                    end,function()
                        SetVehicleExtra(w,x,1)
                    end)
                end 
            end 
        end)
    end
end)

RegisterNetEvent("ARMA:setVIPClubData",function(y,z)
    a.hoursOfPlus=y
    a.hoursOfPlatinum=z 
end)

RegisterNetEvent("ARMA:reducePlusMembershipHour",function()
    a.hoursOfPlus=a.hoursOfPlus-1
    if a.hoursOfPlus<0 then 
        a.hoursOfPlus=0 
    end 
end)

RegisterNetEvent("ARMA:reducePlatMembershipHour",function()
    a.hoursOfPlatinum=a.hoursOfPlatinum-1
    if a.hoursOfPlatinum<0 then 
        a.hoursOfPlatinum=0 
    end 
end)

RegisterNetEvent("ARMA:getUsersSubscription",function(userid, plussub, platsub)
    z.userid = userid
    z.hoursOfPlus=plussub
    z.hoursOfPlatinum=platsub
    RMenu:Get("vipclubmenu", 'manageusersubscription')
end)

RegisterNetEvent("ARMA:userSubscriptionUpdated",function()
    TriggerServerEvent('ARMA:getPlayerSubscription', permID)
end)

Citizen.CreateThread(function()
    while true do 
        if tARMA.isPlatClub()then 
            if not HasPedGotWeapon(PlayerPedId(),`GADGET_PARACHUTE`,false) and E then 
                GiveWeaponToPed(PlayerPedId(),`GADGET_PARACHUTE`)
                SetPlayerHasReserveParachute(PlayerId())
            end 
        end
        if tARMA.isPlusClub() or tARMA.isPlatClub()then 
            SetVehicleDirtLevel(tARMA.getPlayerVehicle(),0.0)
        end
        Wait(500)
    end 
end)

function getColourCode(a)
    if a>=10 then 
        colourCode="~g~"
    elseif a<10 and a>3 then 
        colourCode="~y~"
    else 
        colourCode="~r~"
    end
    return colourCode
end