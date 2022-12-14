local cfg = module("cfg/cfg_gunstores")
local weapons = module("cfg/weapons")
local a=false
local b
local c
local d={name="",price="",model="",priceString="",ammoPrice="",weaponShop=""}
local e
local f
local g=""
local h=false
local i={}
RMenu.Add("ARMAGunstore","mainmenu",RageUI.CreateMenu("","",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "large"))
RMenu:Get("ARMAGunstore","mainmenu"):SetSubtitle("~b~GUNSTORE")
RMenu.Add("ARMAGunstore","type",RageUI.CreateSubMenu(RMenu:Get("ARMAGunstore","mainmenu"),"","~b~Purchase Weapon or Ammo",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "large"))
RMenu.Add("ARMAGunstore","confirm",RageUI.CreateSubMenu(RMenu:Get("ARMAGunstore","type"),"","~b~Purchase confirm your purchase",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "large"))
RMenu.Add("ARMAGunstore","vip",RageUI.CreateSubMenu(RMenu:Get("ARMAGunstore","mainmenu"),"","~b~Purchase Weapon or Ammo",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "large"))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("ARMAGunstore", "mainmenu")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            h=false
        if b~=nil and i~=nil then 
            if tARMA.isPlatClub() then 
                if b=="VIP"then 
                    RageUI.ButtonWithStyle("~y~[Platinum Large Arms]","",{RightLabel="→→→"},true,function(j,k,l)
                    end,RMenu:Get("ARMAGunstore","vip"))
                end 
            end
            for m,n in pairs(i)do 
                if b==m then 
                    for o,p in pairs(sortedKeys(n))do 
                        local q=n[p]
                        if p~="_config"then 
                            local r,s,t=table.unpack(q)
                            local x=false
                            local y
                            if p=="item|fillUpArmour"then 
                                local z=GetPedArmour(tARMA.getPlayerPed())
                                local A=100-z
                                y=A*1000
                                x=true 
                            end
                            local B=""
                            if x then 
                                B=tostring(getMoneyStringFormatted(y))
                            else 
                                B=tostring(getMoneyStringFormatted(s))
                            end
                            RageUI.ButtonWithStyle(r,"£"..B,{RightLabel="→→→"},true,function(j,k,l)
                                if j then 
                                end
                                if k then 
                                    e=p 
                                end
                                if l then 
                                    d.name=r
                                    d.priceString=B
                                    d.model=p
                                    d.price=s
                                    d.ammoPrice=t
                                    d.weaponShop=m 
                                end 
                            end,RMenu:Get("ARMAGunstore","type"))
                        end 
                    end 
                end 
            end 
        end 
        end) 
    end
    if RageUI.Visible(RMenu:Get("ARMAGunstore", "type")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.ButtonWithStyle("Purchase Weapon Body","£"..getMoneyStringFormatted(d.price),{RightLabel="→→→"},true,function(j,k,l)
                if l then 
                    g="body"
                end 
            end,RMenu:Get("ARMAGunstore","confirm"))
            if not weapons.weapons[d.model] or weapons.weapons[d.model].ammo ~= "modelammo" then 
                RageUI.ButtonWithStyle("Purchase Weapon Ammo (Max)","£"..getMoneyStringFormatted(math.floor(d.price/2)),{RightLabel="→→→"},true,function(j,k,l)
                    if l then 
                        g="ammo"
                    end 
                end,RMenu:Get("ARMAGunstore","confirm"))
            end
        end) 
    end
    if RageUI.Visible(RMenu:Get("ARMAGunstore", "confirm")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.ButtonWithStyle("Yes","",{RightLabel="→→→"},true,function(j,k,l)
            if l then 
                if string.sub(d.model,1,4)=="item"then 
                    TriggerServerEvent("ARMA:buyWeapon",d.model,d.price,d.name,d.weaponShop,"armour")
                else 
                    if g=="ammo"then 
                        if HasPedGotWeapon(tARMA.getPlayerPed(),GetHashKey(d.model),false)then 
                            TriggerServerEvent("ARMA:buyWeapon",d.model,d.price,d.name,d.weaponShop,"ammo")
                        else 
                            tARMA.notify("~r~You do not have the body of this weapon to purchase ammo.")
                        end 
                    else 
                        TriggerServerEvent("ARMA:buyWeapon",d.model,d.price,d.name,d.weaponShop,"weapon",h)
                    end 
                end 
            end 
            end,RMenu:Get("ARMAGunstore","confirm"))
            RageUI.ButtonWithStyle("No","",{RightLabel="→→→"},true,function(j,k,l)
            end,RMenu:Get("ARMAGunstore","mainmenu"))
        end) 
    end
    if RageUI.Visible(RMenu:Get("ARMAGunstore", "vip")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            local C=i["LargeArmsDealer"]
            for o,p in pairs(sortedKeys(C))do 
                h=true
                local q=C[p]
                if p~="_config"then 
                    local r,s,t=table.unpack(q)
                    local x=false
                    local y
                    if p=="item|fillUpArmour"then 
                        local z=GetPedArmour(tARMA.getPlayerPed())
                        local A=100-z
                        y=A*1000
                        x=true 
                    end
                    local B=""
                    if x then 
                        B=tostring(getMoneyStringFormatted(y))
                    else 
                        B=tostring(getMoneyStringFormatted(s))
                    end
                    RageUI.ButtonWithStyle(r,"£"..B,{RightLabel="→→→"},true,function(j,k,l)
                        if j then 
                        end
                        if k then 
                            e=p 
                        end
                        if l then 
                            d.name=r
                            d.priceString=B
                            d.model=p
                            d.price=s
                            d.ammoPrice=t
                            d.weaponShop="LargeArmsDealer"
                        end 
                    end,RMenu:Get("ARMAGunstore","type"))
                end 
            end 
        end) 
    end
end)

RegisterNetEvent("ARMA:refreshGunStorePermissions",function()
    TriggerServerEvent("ARMA:requestNewGunshopData")
end)
RegisterNetEvent("ARMA:recieveFilteredGunStoreData")
AddEventHandler("ARMA:recieveFilteredGunStoreData",function(F)
    i=F 
end)
RegisterNetEvent("ARMA:recalculateLargeArms")
AddEventHandler("ARMA:recalculateLargeArms",function(G)
    for m,n in pairs(i)do 
        if m=="LargeArmsDealer"then 
            for r,H in pairs(n)do
                if r ~="_config"then 
                    local I=i[m][r][6]
                    i[m][r][2]=I*(1+G/100)
                end     
            end 
        end 
    end 
end)
local function J(m,K)
    b=m
    c=K
    if m=="Rebel"then 
        RMenu:Get('ARMAGunstore','mainmenu'):SetSpriteBanner("banners", "large")
    else 
        RMenu:Get('ARMAGunstore','mainmenu'):SetSpriteBanner("banners", "large")
    end
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('ARMAGunstore','mainmenu'),true)
end
local function L(m)
    b=nil
    c=nil
    e=nil
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('ARMAGunstore','mainmenu'),false)
end
Citizen.CreateThread(function()
    while true do 
        if e and f~=e then 
            f=e
            for m,n in pairs(i)do
                local H=n[f]
                if H then 
                    local v=H[5]
                    if v then 
                        local M=n._config[1][c]
                        if h then 
                            M=vector3(-2151.5739746094,5191.2548828125,14.718822479248)
                        end
                        local N=tARMA.loadModel(v)
                        if N ~= nil and M ~= nil and M ~= "null" then
                            local O=CreateObject(N,M.x,M.y,M.z+1,false,false,false)
                            while f==e and DoesEntityExist(O)do 
                                SetEntityHeading(O,GetEntityHeading(O)+1%360)
                                Wait(0)
                            end
                            DeleteEntity(O)
                        end
                        SetModelAsNoLongerNeeded(N)
                    end 
                end 
            end 
        end
        Wait(0)
    end 
end)
AddEventHandler("ARMA:onClientSpawn",function(D, E)
    if E then
        TriggerServerEvent("ARMA:requestNewGunshopData")
        for m,n in pairs(i)do 
            local P,Q,R,S,u,T=table.unpack(n["_config"])
            for K,U in pairs(P)do 
                if T then 
                    tARMA.addBlip(U.x,U.y,U.z,Q,R,S)
                end
                tARMA.addMarker(U.x,U.y,U.z,1.0,1.0,1.0,255,0,0,170,50,27)
                local V=function()
                    if GetVehiclePedIsIn(tARMA.getPlayerPed(),false)==0 then 
                        J(m,K)
                    else 
                        tARMA.notify("~r~Exit your vehicle to access the gun store.")
                    end 
                end
                local W=function()
                    L(m)
                end
                local X=function()
                end
                tARMA.createArea("gunstore_"..m.."_"..K,U,1.5,6,V,W,X,{})
            end 
        end 
    end
end)

local Y={}
function tARMA.createGunStore(Z,_,a0)
    local V=function()
        if GetVehiclePedIsIn(tARMA.getPlayerPed(),false)==0 then 
            J(_)
        else 
            tARMA.notify("~r~Exit your vehicle to access the gun store.")
        end 
    end
    local W=function()
        L(_)
    end
    local a1=string.format("gunstore_%s_%s",_,Z)
    tARMA.createArea(a1,a0,1.5,6,V,W,function()
    end)
    local a2=tARMA.addMarker(a0.x,a0.y,a0.z,1.0,1.0,1.0,255,0,0,170,50,27)
    Y[Z]={area=a1,marker=a2}
end
function tARMA.deleteGunStore(Z)
    local a3=Y[Z]
    if a3 then 
        tARMA.removeMarker(a3.marker)
        tARMA.removeArea(a3.area)
        Y[Z]=nil 
    end 
end