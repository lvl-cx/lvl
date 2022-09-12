RMenu.Add('vipclubmenu','mainmenu',RageUI.CreateMenu("","~b~ARMA Club",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu.Add('vipclubmenu','managesubscription',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","~b~ARMA Club",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu.Add('vipclubmenu','manageusersubscription',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","~b~ARMA Club Manage",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu.Add('vipclubmenu','manageperks',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","~b~ARMA Club Perks",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu.Add('vipclubmenu','deathsounds',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','manageperks'),"","~b~Manage Death Sounds",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu.Add('vipclubmenu','vehicleextras',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','manageperks'),"","~b~Vehicle Extras",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "vipclub"))
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

local c = {
    ["Default"] = {checked = true, soundId = "dead"},
    ["Fortnite"] = {checked = false, soundId = "fortnite_death"},
    ["Roblox"] = {checked = false, soundId = "roblox_death"},
    ["Minecraft"] = {checked = false, soundId = "minecraft_death"},
    ["Pac-Man"] = {checked = false, soundId = "pacman_death"},
    ["Mario"] = {checked = false, soundId = "mario_death"},
    ["CS:GO"] = {checked = false, soundId = "csgo_death"}
}

local function m(h)
    SendNUIMessage({transactionType = h})
end

AddEventHandler("ARMA:onClientSpawn",function(f, g)
    if g then
        TriggerServerEvent('ARMA:getPlayerSubscription')
        Wait(5000)
        local i=tARMA.getDeathSound()
        local j="dead"
        for k,l in pairs(c)do 
            if l.soundId==i then 
                j=k 
            end 
        end
        for k,m in pairs(c)do 
            if j~=k then 
                m.checked=false 
            else 
                m.checked=true 
            end 
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
            if tARMA.isPlusClub() or tARMA.isPlatClub() then
                RageUI.ButtonWithStyle("Manage Subscription","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("vipclubmenu","managesubscription"))
                RageUI.ButtonWithStyle("Manage Perks","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("vipclubmenu","manageperks"))
            else
                RageUI.ButtonWithStyle("Purchase Subscription","",{RightLabel="→→→"},true,function(o,p,q)
                    if q then
                        SendNUIMessage({act="openurl",url="https://store.armarp.co.uk"})
                    end
                end)
            end
            if tARMA.isDev() or tARMA.getStaffLevel() >= 10 then
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
            if tARMA.isDev() or tARMA.getStaffLevel() >= 10 then
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
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'deathsounds')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for t, k in pairs(c) do
                RageUI.Checkbox(t,"",k.checked,{},function()end,function()
                    for u, l in pairs(c) do
                        l.checked = false
                    end
                    k.checked = true
                    m(k.soundId)
                    tARMA.setDeathSound(k.soundId)
                end,function()end)
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
            if not HasPedGotWeapon(PlayerPedId(),`GADGET_PARACHUTE`,false) then 
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