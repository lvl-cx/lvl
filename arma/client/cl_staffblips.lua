d=false
local b={}
local c={}

RegisterNetEvent("ARMA:showBlipscl")
AddEventHandler("ARMA:showBlipscl",function(N)
    if tARMA.isDev() then 
        d=N
        if d then 
            tARMA.notify("~g~Blips enabled")
        else 
            tARMA.notify("~r~Blips disabled")
            for O,P in ipairs(GetActivePlayers())do 
                local Q=GetPlayerPed(P)
                if GetPlayerPed(P)~=tARMA.getPlayerPed()then 
                    Q=GetPlayerPed(P)
                    blip=GetBlipFromEntity(Q)
                    RemoveBlip(blip)
                end 
            end 
        end 
    end 
end)

Citizen.CreateThread(function()
    while true do 
        if d then 
            for O,P in ipairs(GetActivePlayers())do 
                local G=GetPlayerPed(P)
                if G~=GetPlayerPed(-1)then 
                    local blip=GetBlipFromEntity(G)
                    if not DoesBlipExist(blip) and not tARMA.isUserHidden(S)then 
                        blip=AddBlipForEntity(G)
                        if GetEntityHealth(G)>102 then 
                            SetBlipSprite(blip,1)
                        else 
                            SetBlipSprite(blip,274)
                        end
                        Citizen.InvokeNative(0x5FBCA48327B914DF,blip,true)
                        local R=GetVehiclePedIsIn(G,false)
                        if GetEntityHealth(G)>102 then 
                            SetBlipSprite(blip,1)
                        else 
                            SetBlipSprite(blip,274)
                        end
                        Citizen.InvokeNative(0x5FBCA48327B914DF,blip,true)
                        SetBlipRotation(blip,math.ceil(GetEntityHeading(R)))
                        SetBlipNameToPlayerName(blip,P)
                        SetBlipScale(blip,0.85)
                        SetBlipAlpha(blip,255)
                    end 
                end 
            end 
        end
        Wait(1000)
    end 
end)

function tARMA.hasStaffBlips()
    return d
end

local function g()
    for e,f in pairs(c)do 
        if DoesBlipExist(f)then 
            RemoveBlip(f)
        end 
    end
    c={}
end

local function m(n,o,k,info)
    local l=AddBlipForCoord(n.x,n.y,n.z)
    table.insert(c,l)
    if o==0 then
        SetBlipSprite(l,1)
    else 
        SetBlipSprite(l,274)
    end
    SetBlipScale(l,0.85)
    SetBlipAlpha(l,255)
    SetBlipColour(l,k)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(info)
    EndTextCommandSetBlipName(l)
end

local u=true
local v=GetPlayerServerId(PlayerId())
CreateThread(function()
    Wait(20000)
    u=false
end)
RegisterNetEvent("ARMA:sendFarblips",function(w)
    if not u then
        g()
        for e,x in pairs(w)do 
            if x.source~=v then 
                m(x.position,x.dead,x.colour,x.info)
            end 
        end 
    end 
end)

RegisterNetEvent("ARMA:disableDevBlips",function()
    g()
end)