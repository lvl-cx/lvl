RMenu.Add('vipclubmenu','mainmenu',RageUI.CreateMenu("","~b~OASIS Club",tOASIS.getRageUIMenuWidth(), tOASIS.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu.Add('vipclubmenu','managesubscription',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","~b~OASIS Club",tOASIS.getRageUIMenuWidth(), tOASIS.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu.Add('vipclubmenu','manageusersubscription',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","~b~OASIS Club Manage",tOASIS.getRageUIMenuWidth(), tOASIS.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu.Add('vipclubmenu','manageperks',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","~b~OASIS Club Perks",tOASIS.getRageUIMenuWidth(), tOASIS.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu.Add('vipclubmenu','deathsounds',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','manageperks'),"","~b~Manage Death Sounds",tOASIS.getRageUIMenuWidth(), tOASIS.getRageUIMenuHeight(),"banners", "vipclub"))
RMenu.Add('vipclubmenu','vehicleextras',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','manageperks'),"","~b~Vehicle Extras",tOASIS.getRageUIMenuWidth(), tOASIS.getRageUIMenuHeight(),"banners", "vipclub"))
local a={hoursOfPlus=0,hoursOfPlatinum=0}
local z={}

function tOASIS.isPlusClub()
    if a.hoursOfPlus>0 then 
        return true 
    else 
        return false 
    end 
end

function tOASIS.isPlatClub()
    if a.hoursOfPlatinum>0 then 
        return true 
    else 
        return false 
    end 
end

RegisterCommand("oasisclub",function()
    TriggerServerEvent('OASIS:getPlayerSubscription')
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('vipclubmenu','mainmenu'),not RageUI.Visible(RMenu:Get('vipclubmenu','mainmenu')))
end)

local c = {
    ["Default"] = {checked = true, soundId = "playDead"},
    ["Fortnite"] = {checked = false, soundId = "fortnite_death"},
    ["Roblox"] = {checked = false, soundId = "roblox_death"},
    ["Minecraft"] = {checked = false, soundId = "minecraft_death"},
    ["Pac-Man"] = {checked = false, soundId = "pacman_death"},
    ["Mario"] = {checked = false, soundId = "mario_death"},
    ["CS:GO"] = {checked = false, soundId = "csgo_death"}
}
local d = false
Citizen.CreateThread(function()
    local e = GetResourceKvpString("oasis_codhitmarkersounds") or "false"
    if e == "false" then
        d = false
        TriggerEvent("OASIS:codHMSoundsOff")
    else
        d = true
        TriggerEvent("OASIS:codHMSoundsOn")
    end
end)

AddEventHandler("OASIS:onClientSpawn",function(f, g)
    if g then
        TriggerServerEvent('OASIS:getPlayerSubscription')
        Wait(5000)
        local i=tOASIS.getDeathSound()
        local j="playDead"
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


function tOASIS.setDeathSound(i)
    if tOASIS.isPlusClub() or tOASIS.isPlatClub() then 
        SetResourceKvp("OASIS_deathsound",i)
    else 
        tOASIS.notify("~r~Cannot change deathsound, not a valid OASIS Plus or Platinum subscriber.")
    end 
end
function tOASIS.getDeathSound()
    if tOASIS.isPlusClub() or tOASIS.isPlatClub() then 
        local k=GetResourceKvpString("OASIS_deathsound")
        if type(k) == "string" and k~="" then 
            return k 
        else 
            return "playDead"
        end 
    else 
        return "playDead"
    end 
end

local function m(h)
    SendNUIMessage({transactionType = h})
end

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tOASIS.isPlusClub() or tOASIS.isPlatClub() then
                RageUI.ButtonWithStyle("Manage Subscription","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("vipclubmenu","managesubscription"))
                RageUI.ButtonWithStyle("Manage Perks","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("vipclubmenu","manageperks"))
            else
                RageUI.ButtonWithStyle("Purchase Subscription","",{RightLabel="→→→"},true,function(o,p,q)
                    if q then
                        tOASIS.OpenUrl("https://store.oasisv.co.uk")
                        SendNUIMessage({act="openurl",url="https://store.oasisv.co.uk"})
                    end
                end)
            end
            if tOASIS.isDev() or tOASIS.getStaffLevel() >= 10 then
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
                    TriggerServerEvent("OASIS:beginSellSubscriptionToPlayer","Plus")
                end 
            end)
            RageUI.ButtonWithStyle("Sell Platinum Subscription days.","~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",{RightLabel="→→→"},true,function(o,p,q)
                if q then 
                    TriggerServerEvent("OASIS:beginSellSubscriptionToPlayer","Platinum")
                end 
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'manageusersubscription')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tOASIS.isDev() then
                if next(z) then
                    RageUI.Separator('Perm ID: '..z.userid)
                    colourCode = getColourCode(z.hoursOfPlus)
                    RageUI.Separator('Days of Plus Remaining: '..colourCode..math.floor(z.hoursOfPlus/24*100)/100)
                    colourCode = getColourCode(z.hoursOfPlatinum)
                    RageUI.Separator('Days of Platinum Remaining: '..colourCode..math.floor(z.hoursOfPlatinum/24*100)/100)
                    RageUI.ButtonWithStyle("Set Plus Days","",{RightLabel="→→→"},true,function(o,p,q)
                        if q then
                            TriggerServerEvent("OASIS:setPlayerSubscription", z.userid, "Plus")
                        end
                    end)
                    RageUI.ButtonWithStyle("Set Platinum Days","",{RightLabel="→→→"},true,function(o,p,q)
                        if q then
                            TriggerServerEvent("OASIS:setPlayerSubscription", z.userid, "Platinum")
                        end
                    end)    
                else
                    RageUI.Separator('Please select a Perm ID')
                end
                RageUI.ButtonWithStyle("Select Perm ID", nil, { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        permID = tOASIS.KeyboardInput("Enter Perm ID", "", 10)
                        if permID == nil then 
                            tOASIS.notify('~r~Invalid Perm ID')
                            return
                        end
                        TriggerServerEvent('OASIS:getPlayerSubscription', permID)
                    end
                end, RMenu:Get("vipclubmenu", 'manageusersubscription'))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'manageperks')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            local function q()
                TriggerEvent("OASIS:codHMSoundsOn")
                d = true
                tOASIS.setCODHitMarkerSetting(d)
                tOASIS.notify("~y~COD Hitmarkers now set to " .. tostring(d))
            end
            local function r()
                TriggerEvent("OASIS:codHMSoundsOff")
                d = false
                tOASIS.setCODHitMarkerSetting(d)
                tOASIS.notify("~y~COD Hitmarkers now set to " .. tostring(d))
            end
            RageUI.Checkbox("Enable COD Hitmarkers","~g~This adds 'hit marker' sound and image when shooting another player.",d,{RightBadge = RageUI.CheckboxStyle.Car},function(n, p, o, s)
            end,q,r)
            RageUI.ButtonWithStyle("Custom Death Sounds","",{RightLabel="→→→"},true,function(o,p,q)
            end,RMenu:Get("vipclubmenu","deathsounds"))
            RageUI.ButtonWithStyle("Vehicle Extras","",{RightLabel="→→→"},true,function(o,p,q)
            end,RMenu:Get("vipclubmenu","vehicleextras"))
            RageUI.ButtonWithStyle("Claim Weekly Kit","",{RightLabel="→→→"},true,function(o,p,q)
                if q then 
                    TriggerServerEvent("OASIS:claimWeeklyKit")
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
                    tOASIS.setDeathSound(k.soundId)
                end,function()end)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'vehicleextras')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            local w=tOASIS.getPlayerVehicle()
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

RegisterNetEvent("OASIS:setVIPClubData",function(y,z)
    a.hoursOfPlus=y
    a.hoursOfPlatinum=z 
end)

RegisterNetEvent("OASIS:getUsersSubscription",function(userid, plussub, platsub)
    z.userid = userid
    z.hoursOfPlus=plussub
    z.hoursOfPlatinum=platsub
    RMenu:Get("vipclubmenu", 'manageusersubscription')
end)

RegisterNetEvent("OASIS:userSubscriptionUpdated",function()
    TriggerServerEvent('OASIS:getPlayerSubscription', permID)
end)

Citizen.CreateThread(function()
    while true do 
        if tOASIS.isPlatClub()then 
            if not HasPedGotWeapon(PlayerPedId(),'GADGET_PARACHUTE',false) then 
                tOASIS.allowWeapon("GADGET_PARACHUTE")
                GiveWeaponToPed(PlayerPedId(),'GADGET_PARACHUTE')
                SetPlayerHasReserveParachute(PlayerId())
            end 
        end
        if tOASIS.isPlusClub() or tOASIS.isPlatClub()then 
            SetVehicleDirtLevel(tOASIS.getPlayerVehicle(),0.0)
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