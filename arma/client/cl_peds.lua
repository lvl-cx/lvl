RMenu.Add('ARMAPeds','main',RageUI.CreateMenu("","Change Ped",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(), "banners","cstore"))
local a=module("cfg/cfg_peds")
local b=a.pedMenus
local c={}
local d=nil
local LE=nil
local e=nil
local f=true
local g
local h=false
local j={}
local k={}
local l=0
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('ARMAPeds', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Button("Reset Ped",nil,{},true,function(m,n,o)
                if o then 
                    if LE ~= nil then
                        local ABABA={modelhash=LE}
                        tARMA.setCustomization(ABABA)
                    else
                        local BABABA={modelhash=1885233650}
                        tARMA.setCustomization(BABABA)
                    end
                end 
            end)
            if d~=nil or e~=nil and tARMA.getCustomization()~=d then 
                RageUI.Button("Reset",nil,{},true,function(m,n,o)
                    if o then 
                        revertPedChange()
                    end 
                end)
            end
            for i=1,#c,1 do 
                RageUI.Button(c[i][2],nil,{},true,function(m,n,o)
                    if o then 
                        if GetEntityHealth(tARMA.getPlayerPed())>102 then 
                            spawnPed(c[i][1])
                        else 
                            tARMA.notify("~r~You try to change ped, but then remember you are dead.")
                        end 
                    end 
                end)
            end 
        end)
    end
end)
function showPedsMenu(p)
    RageUI.Visible(RMenu:Get('ARMAPeds','main'),p)
end
function showPedsDevMenu(DA)
    c=a.peds["admin"]
    if d == nil then
        d=tARMA.getCustomization()
    end
    local p=tARMA.getCustomization()
    if p["modelhash"] == 1885233650 then
        LE = 1885233650
    elseif p["modelhash"] == 1667301416 then
        LE = 1667301416
    end
    l=GetEntityHealth(tARMA.getPlayerPed())
    RageUI.Visible(RMenu:Get('ARMAPeds','main'),DA)
end
function spawnPed(q)
    local r=tARMA.getPlayerPed()
    local s=GetEntityHeading(r)
    tARMA.setCustomization({model=q})
    SetEntityHeading(tARMA.getPlayerPed(),s)
    Wait(100)
    SetEntityMaxHealth(tARMA.getPlayerPed(),200)
    SetEntityHealth(tARMA.getPlayerPed(),200)
end
function revertPedChange()
    tARMA.setCustomization(d)
end


Citizen.CreateThread(function()
    local t = a.pedMenus
    for i=1,#j do
        tARMA.removeArea(j[i])j[i]=nil 
    end
    for i=1,#k do 
        tARMA.removeMarker(k[i])
    end
    local u=function(v)
    end
    local w=function(x)
        c=a.peds[x.menu_id]
        g=i
        if f then
            if d == nil then
                d=tARMA.getCustomization()
            end
            local p=tARMA.getCustomization()
            if p["modelhash"] == 1885233650 then
                LE = 1885233650
            elseif p["modelhash"] == 1667301416 then
                LE = 1667301416
            end
            l=GetEntityHealth(tARMA.getPlayerPed())
        end
        if x.menu_id == "admin" then
            if tARMA.isDev() then
                h=true
                showPedsMenu(true)
                f=false
            else
                tARMA.notify("~r~This is for developers only")
            end
        else
            h=true
            showPedsMenu(true)
            f=false
        end
    end
    local y=function(v)
        showPedsMenu(false)
        f=true
        h=false
        SetEntityHealth(tARMA.getPlayerPed(),l)
    end
    for i=1,#t do
        local z=t[i]
        local A=z[1]
        local B=string.format("pedmenu_%s_%s",A,i)
        tARMA.createArea(B,z[2],1.25,6,w,y,u,{menu_id=A})
        local C=tARMA.addMarker(z[2].x,z[2].y,z[2].z-1,0.7,0.7,0.5,0,255,125,125,50,27,false,false)
        j[#j+1]=B
        k[#k+1]=C 
    end 
end)
function getPedMenuId(string)
    return stringsplit(string,"_")[2]
end
function Goku()
    TriggerServerEvent("BW:turnIntoGoku")
end