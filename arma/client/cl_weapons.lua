local a = module("cfg/weapons")
Citizen.CreateThread(function()
    for b,c in pairs(a.weapons)do 
        AddTextEntry(b,c.name)
    end 
end)
RegisterNetEvent("ARMA:GiveWap")
AddEventHandler("ARMA:GiveWap", function(Y)
    TriggerServerEvent('ARMA:banType44')
end)

function tARMA.setHealth(y)
    local X=math.floor(y)
    SetEntityHealth(PlayerPedId(),X)
end

function tARMA.giveWeapons(d,e)
    print(d,e)
    local f=PlayerPedId()
    if e then 
        RemoveAllPedWeapons(f,true)
    end
    for g,h in pairs(d)do
        local i=GetHashKey(g)
        local j=h.ammo or 0
        print('give weapons '..j)
        GiveWeaponToPed(f,i,j,false)
        local k=h.attachments or{}
        for l,m in pairs(k)do 
            GiveWeaponComponentToPed(f,g,m)
        end 
    end 
end
function tARMA.isPlayerArmed()
	local f = PlayerPedId()
	for b, c in pairs(a.weapons) do
		if HasPedGotWeapon(f, c.hash) then
			return true
		end
	end
	return false
end

function tARMA.getWeapons()
    local f=PlayerPedId()
    local n={}
    local d={}
    for b,c in pairs(a.weapons)do 
        if HasPedGotWeapon(f,c.hash)then
            local h={}
            local o=GetPedAmmoTypeFromWeapon(f,c.hash)
            if n[o]==nil then 
                n[o]=true
                h.ammo=GetAmmoInPedWeapon(f,c.hash)
            else 
                h.ammo=0 
            end
            h.attachments=tARMA.getAllWeaponAttachments(b)
            d[b]=h 
        end 
    end
    return d 
end
local p={}
local q={}
function tARMA.getCachedWeaponStore()
    return q 
end
RegisterNetEvent("ARMA:addWeaponStore")
AddEventHandler("ARMA:addWeaponStore",function(b,i)
    q[b]={weaponHash=i}
end)
RegisterNetEvent("ARMA:removeWeaponStore")
AddEventHandler("ARMA:removeWeaponStore",function(b)
    q[b]=nil 
end)
RegisterNetEvent("ARMA:clearWeaponStore",function()
    q={}
end)
Citizen.CreateThread(function()
    while true do 
        local r=tARMA.getCachedWeaponStore()
        local n={}
        for b,c in pairs(r)do 
            local o=GetPedAmmoTypeFromWeapon(PlayerPedId(),c.weaponHash)
            if n[o]==nil then 
                n[o]=true
                r[b].ammo=GetAmmoInPedWeapon(PlayerPedId(),c.weaponHash)
            else 
                r[b].ammo=0 
            end 
        end
        if not table.contentEquals(r,p)then 
            TriggerServerEvent("ARMA:updateAmmoStore",r)
        end
        p=table.copy(r)
        Wait(5000)
    end 
end)
function tARMA.removeAllWeapons()
    RemoveAllPedWeapons(tARMA.getPlayerPed())
end
local s=GetGameTimer()
RegisterCommand("storecurrentweapon",function()
    if s+3000<GetGameTimer()then 
        s=GetGameTimer()
        if HasPedGotWeapon(PlayerPedId(),`WEAPON_PISTOL50`)or HasPedGotWeapon(PlayerPedId(),`WEAPON_MACHINEPISTOL`)then 
        else 
            local l,i=GetCurrentPedWeapon(PlayerPedId())
            local g=a.weaponHashToModels[i]
            TriggerServerEvent("ARMA:forceStoreSingleWeapon",g)
        end 
    else 
        tARMA.notify("~r~Store weapons cooldown, please wait.")
    end 
end)
--[[ RegisterCommand("storeallweapons",function()
    if s+3000<GetGameTimer()then 
        s=GetGameTimer()
        if HasPedGotWeapon(PlayerPedId(),`WEAPON_PISTOL50`)or HasPedGotWeapon(PlayerPedId(),`WEAPON_MACHINEPISTOL`)then 
        else 
            TriggerServerEvent("ARMA:forceStoreWeapons",true)
        end 
    else 
        tARMA.notify("~r~Store weapons cooldown, please wait.")
    end 
end) ]]
AddEventHandler('onResourceStop',function(t)
    if t==GetCurrentResourceName()then 
        RemoveAllPedWeapons(PlayerPedId(),true)
    end 
end)