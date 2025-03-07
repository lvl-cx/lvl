local a=false
local b={}
local c={}
local function d()
    for e,f in pairs(b)do 
        if DoesBlipExist(f)then 
            RemoveBlip(f)
        end 
    end
    b={}
end
local function g()
    for e,f in pairs(c)do 
        if DoesBlipExist(f)then 
            RemoveBlip(f)
        end 
    end
    c={}
end
local function h(i,j,k)
    if not DoesBlipExist(i)then 
        local l=AddBlipForEntity(j)
        table.insert(b, l)
        SetBlipSprite(l,1)
        SetBlipScale(i,0.85)
        SetBlipAlpha(i,255)
        SetBlipColour(i,k)
        ShowHeadingIndicatorOnBlip(i,true)
    else 
        if GetEntityHealth(j)>102 then 
            SetBlipSprite(i,1)
        else 
            SetBlipSprite(i,274)
        end
        SetBlipScale(i,0.85)
        SetBlipAlpha(i,255)
        SetBlipColour(i,k)
        ShowHeadingIndicatorOnBlip(i,true)
    end 
end

local function checkVisibleOrStaff(n, o)
    return IsEntityVisible(n) or not tOASIS.clientGetPlayerIsStaff(o)
end

local function m(n,o,k)
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
end

RegisterCommand("blipson",function()
    if tOASIS.globalOnPoliceDuty() or tOASIS.globalNHSOnDuty() then 
        tOASIS.notify('~g~Emergency blips enabled.')
        a=true 
    end 
end,false)

RegisterCommand("blipsoff",function()
    if tOASIS.globalOnPoliceDuty() or tOASIS.globalNHSOnDuty() then 
        tOASIS.notify('~r~Emergency blips disabled.')
        a=false
        d()
        g()
    end 
end,false)

RegisterNetEvent("OASIS:disableFactionBlips",function()
    a=false
    tOASIS.setPolice(false)
    tOASIS.setHMP(false)
    tOASIS.setNHS(false)
    d()
    g()
end)

function tOASIS.copBlips()
    return a
end
Citizen.CreateThread(function()
    while true do 
        if a or tOASIS.isInComa() then 
            local p=tOASIS.getPlayerPed()
            for e,f in ipairs(GetActivePlayers())do
                local j=GetPlayerPed(f)
                if j~=p then 
                    local i=GetBlipFromEntity(j)
                    local q=GetPlayerServerId(f)
                    if q~=-1 then 
                        local r=tOASIS.clientGetUserIdFromSource(q)
                        local s=tOASIS.getJobType(r)
                        if s~="" and r ~= tOASIS.getUserId() then 
                            if checkVisibleOrStaff(j, q) then
                                if a then
                                    if s=="metpd"then 
                                        h(i,j,3)
                                    elseif s=="cid"then 
                                        h(i,j,27)
                                    elseif s=="npas"then 
                                        h(i,j,5)
                                    elseif s=="hmp"then 
                                        h(i,j,29)
                                    elseif s=="lfb"then
                                        h(i,j,1)
                                    elseif s=="hems"then 
                                        h(i,j,44)
                                    elseif s=="nhs"then 
                                        h(i,j,2)
                                    end
                                elseif tOASIS.isInComa() then
                                    if s=="nhs"then 
                                        h(i,j,2)
                                    end
                                end
                            else
                                local w = GetBlipFromEntity(j)
                                if w ~= 0 then
                                    RemoveBlip(w)
                                end
                            end
                        end 
                    end 
                end 
            end 
        end
        Wait(100)
    end 
end)
local u=true
local v=GetPlayerServerId(PlayerId())
CreateThread(function()
    Wait(20000)
    u=false
end)
RegisterNetEvent("OASIS:sendFarBlips",function(w)
    if not u and a then
        g()
        for e,x in pairs(w)do 
            if x.source~=v and GetPlayerFromServerId(x.source)== -1 and x.bucket == tOASIS.getPlayerBucket() then 
                m(x.position,x.dead,x.colour)
            end 
        end 
    end 
end)

RegisterNetEvent("OASIS:Revive",function()
    if not a then
        Citizen.Wait(1000)
        d()
    end
end)