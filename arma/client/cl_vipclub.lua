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
local z={userid=0,hoursOfPlus=0,hoursOfPlatinum=0}
a.hoursOfPlus = 500
a.hoursOfPlatinum = 1000
z.userid = 1
z.hoursOfPlus=500
z.hoursOfPlatinum=1000

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

local function b(c)
    RageUI.CloseAll()
    RageUI.Visible(RMenu:Get('vipclubmenu','mainmenu'),not RageUI.Visible(RMenu:Get('vipclubmenu','mainmenu')))
end

RegisterCommand("vipclub",function()
    TriggerServerEvent('ARMA:UpdateVIP', source)
    b(VIPClubMenu)
end)

local d={
    ["Default"]={checked=true,soundId="playDead"},
    ["Fortnite"]={checked=false,soundId="fortnite_death"},
    ["Roblox"]={checked=false,soundId="roblox_death"},
    ["Minecraft"]={checked=false,soundId="minecraft_death"},
    ["Pac-Man"]={checked=false,soundId="pacman_death"},
    ["Wasted"]={checked=false,soundId="gta_wasted"},
    ["Mario"]={checked=false,soundId="mario_death"},
    ["CS:GO"]={checked=false,soundId="csgo_death"}
}
local e=false
Citizen.CreateThread(function()
    local f=GetResourceKvpString("ARMA_codhitmarkersounds") or"false"
    if f=="false"then 
        e=false
        TriggerEvent("ARMA:codHMSoundsOff")
    else 
        e=true
        TriggerEvent("ARMA:codHMSoundsOn")
    end 
end)
local E=true
Citizen.CreateThread(function()
    local f=GetResourceKvpString("ARMA_pluschutes") or "true"
    if f=="true"then
        E=true
    else 
        E=true
    end 
end)
function tARMA.setparachutestting(f)
    SetResourceKvp("ARMA_pluschutes",tostring(f))
end

AddEventHandler("playerSpawned", function()
    if h then
        Wait(5000)
        local i=tARMA.getDeathSound()
        local j="playDead"
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
    end 
end)

function tARMA.setDeathSound(i)
    if tARMA.isPlusClub()or tARMA.isPlatClub()then 
        SetResourceKvp("ARMA_deathsound",i)
    else 
        tARMA.notify("~r~Cannot change deathsound, not a valid ARMA Plus or Platinum subscriber.")
    end 
end
function tARMA.getDeathSound()
    if tARMA.isPlusClub()or tARMA.isPlatClub()then 
        local k=GetResourceKvpString("ARMA_deathsound")
        if type(k)=="string"and k~=""then 
            return k 
        else 
            return"playDead"
        end 
    else 
        return"playDead"
    end 
end
local function n(i)
    SendNUIMessage({transactionType=i})
end
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Manage Subscription","",{RightLabel="→→→"},true,function(o,p,q)
            end,RMenu:Get("vipclubmenu","managesubscription"))
            if tARMA.isPlusClub()or tARMA.isPlatClub()then 
                RageUI.ButtonWithStyle("Manage Perks","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("vipclubmenu","manageperks"))
            end
            if tARMA.isDev() then
                RageUI.ButtonWithStyle("Manage User's Subscription","",{RightLabel="→→→"},true,function(o,p,q)
                    if o then
                        permID = tARMA.KeyboardInput("Enter Perm ID", "", 10)
                        if permID == nil then 
                            tARMA.notify('~r~Invalid Perm ID')
                        end
                        TriggerServerEvent('ARMA:manageUserSubscription', permID)
                        --RageUI.ActuallyCloseAll()
                    end
                --end)
                end,RMenu:Get("vipclubmenu","manageusersubscription"))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'managesubscription')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if a.hoursOfPlus>=10 then 
                colourCode="~g~"
            elseif a.hoursOfPlus<10 and a.hoursOfPlus>3 then 
                colourCode="~y~"
            else 
                colourCode="~r~"
            end
            RageUI.Separator("Days remaining of Plus Subscription: "..colourCode..math.floor(a.hoursOfPlus/24*100)/100 .." days.")
            if a.hoursOfPlatinum>=10 then 
                colourCode="~g~"
            elseif a.hoursOfPlatinum<10 and a.hoursOfPlatinum>3 then 
                colourCode="~y~"
            else 
                colourCode="~r~"
            end
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
                RageUI.Separator('Perm ID: '..z.userid)
                RageUI.Separator('Days of Plus Remaining: '..math.floor(z.hoursOfPlus/24*100)/100)
                RageUI.Separator('Days of Platinum Remaining: '..math.floor(z.hoursOfPlatinum/24*100)/100)
                RageUI.ButtonWithStyle("Add Plus Days","",{RightLabel="→→→"},true,function(o,p,q)
                end)
                RageUI.ButtonWithStyle("Remove Plus Days","",{RightLabel="→→→"},true,function(o,p,q)
                end)
                RageUI.ButtonWithStyle("Add Platinum Days","",{RightLabel="→→→"},true,function(o,p,q)
                end)
                RageUI.ButtonWithStyle("Remove Platinum Days","",{RightLabel="→→→"},true,function(o,p,q)
                end)
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
            local function r()
                TriggerEvent("ARMA:codHMSoundsOn")
                e=true
                tARMA.setCODHitMarkerSetting(e)
                tARMA.notify("~y~COD Hitmarkers now set to "..tostring(e))
            end
            local function s()
                TriggerEvent("ARMA:codHMSoundsOff")
                e=false
                tARMA.setCODHitMarkerSetting(e)
                tARMA.notify("~y~COD Hitmarkers now set to "..tostring(e))
            end
            RageUI.Checkbox("Enable COD Hitmarkers","~g~This adds 'hit marker' sound and image when shooting another player.",e,{Style=RageUI.CheckboxStyle.Car},function(o,q,p,t)
            end,r,s)
            local function R()
                E=true
                tARMA.setparachutestting(E)
                tARMA.notify("~y~Parachute enabled")
            end
            local function S()
                E=false
                tARMA.setparachutestting(E)
                tARMA.notify("~y~Parachute disabled")
            end
            RageUI.Checkbox("Enable Parachute","~g~This gives you primary and reserve parachute.",E,{Style=RageUI.CheckboxStyle.Car},function(o,q,p,t)
            end,R,S)
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'deathsounds')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for u,l in pairs(d)do 
                RageUI.Checkbox(u,"",l.checked,{},function()
                end,function()
                    for v,m in pairs(d)do 
                        m.checked=false 
                    end
                    l.checked=true
                    n(l.soundId)
                    tARMA.setDeathSound(l.soundId)
                end,function()
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
    RageUI.Visible(RMenu:Get('vipclubmenu', 'manageusersubscription'), true)
end)
Citizen.CreateThread(function()
    while true do 
        if tARMA.isPlatClub()then 
            if not HasPedGotWeapon(PlayerPedId(),`GADGET_PARACHUTE`,false) and E then 
                GiveWeaponToPed(PlayerPedId(),`GADGET_PARACHUTE`)
                SetPlayerHasReserveParachute(PlayerId())
            end 
        end
        if tARMA.isPlusClub()or tARMA.isPlatClub()then 
            SetVehicleDirtLevel(tARMA.getPlayerVehicle(),0.0)
        end
        Wait(500)
    end 
end)

globalIgnoreDeathSound=false
RegisterNetEvent("ARMA:deathSound")
AddEventHandler("ARMA:deathSound",function(C)
    local D=GetEntityCoords(tARMA.getPlayerPed())
    local E=#(D-C)
    if not globalIgnoreDeathSound and E<=15 then
        SendNUIMessage({transactionType=tARMA.getDeathSound()})
    end 
end) 
