local a=false
local b={}
local c={}
local currentComa = false
local function d()
    for e,f in pairs(b)do 
        if DoesBlipExist(f)then 
            RemoveBlip(f)
        end 
    end
    b={}
end
local function d2(A)
    for e,f in pairs(b)do
        if e == A then
            if DoesBlipExist(f)then 
                RemoveBlip(f)
            end
        end
    end
end
local function g()
    for e,f in pairs(c)do 
        if DoesBlipExist(f)then 
            RemoveBlip(f)
        end 
    end
    c={}
end
local function h(i,j,k,q)
    if not DoesBlipExist(i)then 
        local l=AddBlipForEntity(j)
        b[tostring(q)]=l
        SetBlipSprite(l,1)
        SetBlipScale(i,0.85)
        SetBlipAlpha(i,255)
        SetBlipColour(i,k)
        ShowHeadingIndicatorOnBlip(i,true)
    else 
        if GetEntityHealth(j)>102 then 
            SetBlipSprite(i,1)
            ShowHeadingIndicatorOnBlip(i,true)
        else 
            SetBlipSprite(i,274)
            ShowHeadingIndicatorOnBlip(i,false)
        end
        SetBlipScale(i,0.85)
        SetBlipAlpha(i,255)
        SetBlipColour(i,k)
    end 
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

RegisterNetEvent("ARMA:nhsBlipComa",function(coma)
    a=coma
    currentComa = coma
end)

RegisterCommand("blipson",function()
    if tARMA.globalOnPoliceDuty() or tARMA.globalNHSOnDuty() then 
        tARMA.notify('~g~Emergency blips enabled.')
        a=true 
    end 
end,false)

RegisterCommand("blipsoff",function()
    if tARMA.globalOnPoliceDuty() or tARMA.globalNHSOnDuty() then 
        tARMA.notify('~r~Emergency blips disabled.')
        a=false
        d()
        g()
    end 
end,false)

RegisterNetEvent("ARMA:disableFactionBlips",function()
    a=false
    tARMA.setPolice(false)
    tARMA.setHMP(false)
    tARMA.setNHS(false)
    d()
    g()
end)

Citizen.CreateThread(function()
    while true do 
        if a then 
            local p=tARMA.getPlayerPed()
            for e,f in ipairs(GetActivePlayers())do
                local j=GetPlayerPed(f)
                if j~=p then 
                    local i=GetBlipFromEntity(j)
                    local q=GetPlayerServerId(f)
                    if q~=-1 then 
                        local r=tARMA.getPermIdFromTemp(q)
                        local s=tARMA.getJobType(r)
                        if s~=""then 
                            if not currentComa then
                                if s=="metpd"then 
                                    h(i,j,3,q)
                                elseif s=="hmp"then 
                                    h(i,j,29,q)
                                elseif s=="lfb"then
                                    h(i,j,1,q)
                                elseif s=="nhs"then 
                                    h(i,j,2,q)
                                end
                            else
                                if s=="nhs"then 
                                    h(i,j,2,q)
                                end
                            end
                        elseif b[tostring(q)]~= nil then
                            d2(tostring(q))
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
RegisterNetEvent("ARMA:sendFarBlips",function(w)
    if not u then
        g()
        if a then
            for e,x in pairs(w)do 
                if x.source~=v and GetPlayerFromServerId(x.source)==-1 then 
                    m(x.position,x.dead,x.colour)
                end 
            end 
        end
    end 
end)