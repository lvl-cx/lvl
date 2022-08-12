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
        else 
            SetBlipSprite(i,274)
        end
        SetBlipScale(i,0.85)
        SetBlipAlpha(i,255)
        SetBlipColour(i,k)
        ShowHeadingIndicatorOnBlip(i,true)
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
    end 
end,false)

Citizen.CreateThread(function()
    while a do
      if a then
        TriggerServerEvent("ARMA:ENABLEBLIPS")
        Citizen.Wait(10000)
      end
    end
  end)

RegisterNetEvent("ARMA:BLIPS")
AddEventHandler("ARMA:BLIPS", function(clockedon)
  local LocalServerID = GetPlayerServerId(PlayerId())
  for PermID, Player in pairs(clockedon) do
    if Player~=""then 
        if Player=="metpd"then 
            h(i,j,3,q)
        elseif Player=="nhs"then 
            h(i,j,2,q)
        end
    elseif b[tostring(q)]~= nil then
        d2(tostring(q))
    end 
  end
end)