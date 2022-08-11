local a = {}
a.weapons = {     --?Melee's
    [`WEAPON_BROOM`] = {bone = 24818, offset = vector3(-0.60, -0.15, 0.13), rotation = vector3(50.0, 90.0, 2.0), model = `w_me_broom`},
    [`WEAPON_SLEDGEHAMMER`] = {bone = 24818, offset = vector3(-0.35, -0.10, 0.13), rotation = vector3(190.0, 180.0, 105.0), model = `w_me_sledgehammer`},
    [`WEAPON_TRAFFICSIGN`] = {bone = 24818, offset = vector3(-0.45, -0.10, 0.13), rotation = vector3(190.0, 180.0, 105.0), model = `w_me_trafficsign`},
    [`WEAPON_SHOVEL`] = {bone = 24818, offset = vector3(0.32, -0.10, 0.10), rotation = vector3(5.0, 200.0, 80.0), model = `w_me_shovel`},
    [`WEAPON_GUITAR`] = {bone = 24818, offset = vector3(0.32, -0.15, 0.13), rotation = vector3(0.0, -90.0, 0.0), model = `w_me_guitar`},
    [`WEAPON_DILDO`] = {bone = 58271, offset = vector3(-0.01, 0.1, -0.07), rotation = vector3(-35.0, 0.10, -100.0), model = `w_me_dildo`},
    [`WEAPON_CRICKETBAT`] = {bone = 24818, offset = vector3(0.32, -0.15, 0.13), rotation = vector3(55.0, -90.0, 0.0), model = `w_me_cricketbat`},
    [`WEAPON_FIREAXE`] = {bone = 24818, offset = vector3(0.32, -0.15, 0.13), rotation = vector3(0.0, -90.0, 0.0), model = `w_me_fireaxe`},

    --?PD SMGs/Rifles
    [`WEAPON_PDM4A1`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_m4a1`},
    [`WEAPON_AR15`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_ar15`},
    [`WEAPON_MP5`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_sb_mp5`},
    [`WEAPON_SIGMCX`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_sigmcx`},
    [`WEAPON_G36`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_g36`},
    [`WEAPON_SPAR17`] = {bone = 24818, offset = vector3(0.0, 0.19, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_spar17`},
    [`WEAPON_STING`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_sb_sting`},
    [`WEAPON_MK18SOG`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_mk18sog`},
    [`WEAPON_PDTX15`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_tx15dml`},
    [`WEAPON_NIGHTSTICK`] = {bone = 51826, offset = vector3(-0.1, 0.1, 0.07), rotation = vector3(180.0, 140.0, 90.0), model = `w_me_nightstick`},

    --?CIV SMGs/Rifles/Shotguns
    [`WEAPON_EF88`] = {bone = 24818, offset = vector3(0.05, -0.12, -0.13), rotation = vector3(100.0, -3.0, 5.0), model = `w_ar_ef88`},
    [`WEAPON_SPAR16`] = {bone = 24818, offset = vector3(-0.02, -0.12, -0.13), rotation = vector3(100.0, -3.0, 5.0), model = `w_ar_spar16`},
    [`WEAPON_SPAZ12`] = {bone = 24818, offset = vector3(0.1, -0.12, -0.13), rotation = vector3(100.0, -3.0, 5.0), model = `w_ar_spaz12`},
    [`WEAPON_RPK16`] = {bone = 24818, offset = vector3(-0.05, -0.12, -0.13), rotation = vector3(100.0, -3.0, 5.0), model = `w_mg_rpk16`},

    --?Mosin/spec snipers
    [`WEAPON_MOSIN`] = {bone = 24818, offset = vector3(-0.12, -0.12, -0.13), rotation = vector3(100.0, -3.0, 5.0), model = `w_ar_mosin`},
    [`WEAPON_MANDO`] = {bone = 24818, offset = vector3(0.3, 0.22, -0.2), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_mando`},
    [`WEAPON_DILDET`] = {bone = 24818, offset = vector3(-0.35, -0.12, -0.13), rotation = vector3(100.0, 100.0, 5.0), model = `w_ar_dildet`}
}

local b=module("cfg/weapons")
Citizen.CreateThread(function()
    for c,d in pairs(b.weapons)do 
        if not a.weapons[d.hash]then 
            if d.class=="SMG"then 
                a.weapons[d.hash]={bone=58271,offset=vector3(-0.01,0.1,-0.07),rotation=vector3(-55.0,0.10,0.0),model=GetHashKey(d.model)}
            elseif d.class=="AR"or d.class=="Heavy"then 
                a.weapons[d.hash]={bone=24818,offset=vector3(-0.12,-0.12,-0.13),rotation=vector3(100.0,-3.0,5.0),model=GetHashKey(d.model)}
            elseif d.class=="Melee"then 
                a.weapons[d.hash]={bone=24818,offset=vector3(0.32,-0.15,0.13),rotation=vector3(0.0,-90.0,0.0),model=GetHashKey(d.model)}
            elseif d.class=="Shotgun"then 
                a.weapons[d.hash]={bone=24818,offset=vector3(-0.12,-0.12,-0.13),rotation=vector3(100.0,-3.0,5.0),model=GetHashKey(d.model)}
            end 
        end 
    end 
end)
AddEventHandler("ARMA:setDiagonalWeapons",function()
    if not LocalPlayer.state.weaponsDiagonal then 
        LocalPlayer.state:set("weaponsDiagonal",true,true)
    end 
end)
AddEventHandler("ARMA:setVerticalWeapons",function()
    if LocalPlayer.state.weaponsDiagonal then 
        LocalPlayer.state:set("weaponsDiagonal",nil,true)
    end 
end)
local e={}
local f={}
local function g()
    local h=GetSelectedPedWeapon(PlayerPedId())
    local i=tARMA.getCachedWeaponStore()
    local j=false
    for k in pairs(i)do 
        local l=GetHashKey(k)
        if a.weapons[l]and not e[l]and l~=h then 
            e[l]=k
            j=true 
        end 
    end
    for l,k in pairs(e)do 
        if not i[k]or l==h then 
            e[l]=nil
            j=true 
        end 
    end
    if j then 
        local m={}
        for l in pairs(e)do 
            table.insert(m,l)
        end
        if#m>0 then 
            LocalPlayer.state:set("weapons",m,true)
        else 
            LocalPlayer.state:set("weapons",nil,true)
        end 
    end 
end
local function n(l,o)
    local d=a.weapons[l]
    if not d then 
        return 0 
    end
    local p=d.offset
    local q=d.rotation
    if o.diagonal and p==vector3(-0.12,-0.12,-0.13)then 
        p=vector3(0.0,-0.2,0.0)
        q=vector3(0.0,45.0,q.z)
    end
    if not HasModelLoaded(d.model)then 
        RequestModel(d.model)
        return 0 
    end
    local r=CreateObject(d.model,0.0,0.0,0.0,false,false,false)
    AttachEntityToEntity(r,o.ped,GetPedBoneIndex(o.ped,d.bone),p.x,p.y,p.z,q.x,q.y,q.z,false,false,false,false,2,true)
    SetModelAsNoLongerNeeded(d.model)
    return r 
end
local function s(o)
    for l,r in pairs(o.weapons)do 
        if r~=0 then 
            DeleteEntity(r)
            o.weapons[l]=0 
        end 
    end 
end
local function t(o)
    if o.ped==0 then 
        return 
    end
    if not IsEntityVisible(o.ped)then 
        s(o)
        return 
    end
    for l,r in pairs(o.weapons)do 
        if r==0 then 
            o.weapons[l]=n(l,o)
        end 
    end 
end
local function u()
    for c,o in pairs(f)do 
        for l,r in pairs(o.weapons)do 
            if r~=0 and not IsEntityAttached(r)then 
                DeleteEntity(r)
                o.weapons[l]=0
            end 
        end
        if o.ped==0 or not DoesEntityExist(o.ped)then 
            o.ped=GetPlayerPed(o.playerIndex)
        end
        t(o)
    end 
end
local v=0
Citizen.CreateThread(function()
    while true do 
        g()
        if v%3==0 then 
            u()
        end
        v=v+1
        Citizen.Wait(1000)
    end 
end)
RegisterNetEvent("onPlayerDropped",function(w)
    local o=f[w]
    if o then 
        s(o)
        f[w]=nil 
    end 
end)
AddStateBagChangeHandler("weapons",nil,function(x,c,y)
    local w=tonumber(stringsplit(x,":")[2])
    local o=f[w]
    if y==nil then 
        if o then 
            s(o)
            f[w]=nil 
        end
        return 
    end
    if o then 
        for l,r in pairs(o.weapons)do 
            if not table.has(y,l)then 
                if r~=0 then
                    DeleteEntity(r)
                end
                o.weapons[l]=nil 
            end 
        end
        for c,l in pairs(y)do 
            if not o.weapons[l]then 
                o.weapons[l]=0 
            end 
        end
        t(o)
    else 
        local z={}
        for c,l in pairs(y)do 
            z[l]=0 
        end
        f[w]={ped=0,playerIndex=GetPlayerFromServerId(w),weapons=z,diagonal=Player(w).state.weaponsDiagonal}
    end 
end)
AddStateBagChangeHandler("weaponsDiagonal",nil,function(x,c,A)
    local w=tonumber(stringsplit(x,":")[2])
    local o=f[w]
    if o and o.diagonal~=A then 
        o.diagonal=A
        s(o)
        t(o)
    end 
end)
AddEventHandler("onResourceStop",function(B)
    if GetCurrentResourceName()==B then 
        for c,o in pairs(f)do 
            s(o)
        end 
    end 
end)