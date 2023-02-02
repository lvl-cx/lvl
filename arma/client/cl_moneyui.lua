local a = 0
local b = 0
local c = 0
local d = 2
proximityIdToString = {[1] = "Whisper", [2] = "Talking", [3] = "Shouting"}
local e, f = GetActiveScreenResolution()
RegisterNetEvent("ARMA:showHUD")
AddEventHandler("ARMA:showHUD",function(g)
    showhudUI(g)
end)
AddEventHandler("pma-voice:setTalkingMode",function(h)
    d = h
    local i = tARMA.getCachedMinimapAnchor()
    updateMoneyUI("£" .. a, "£" .. b, d, i.rightX * i.resX)
end)
function updateMoneyUI(j, k, m, i, n)
    SendNUIMessage(
        {
            updateMoney = true,
            cash = j,
            bank = k,
            proximity = proximityIdToString[m],
            topLeftAnchor = i,
            yAnchor = n
        }
    )
end
function showhudUI(g)
    SendNUIMessage({showMoney = g})
end
RegisterNetEvent("ARMA:setDisplayMoney")
RegisterNetEvent("ARMA:setDisplayMoney",function(o)
    local p = tostring(math.floor(o))
    a = getMoneyStringFormatted(p)
    local i = tARMA.getCachedMinimapAnchor()
    updateMoneyUI("£" .. a, "£" .. b, d, i.rightX * i.resX)
end)
RegisterNetEvent("ARMA:setDisplayRedMoney")
AddEventHandler("ARMA:setDisplayRedMoney",function(o)
    local p = tostring(math.floor(o))
    c = getMoneyStringFormatted(p)
    local i = tARMA.getCachedMinimapAnchor()
    updateMoneyUI("£" .. a, "£" .. b, d, i.rightX * i.resX)
end)
RegisterNetEvent("ARMA:initMoney")
AddEventHandler("ARMA:initMoney",function(j, k)
    local q = tostring(math.floor(j))
    a = getMoneyStringFormatted(q)
    local p = tostring(math.floor(k))
    b = getMoneyStringFormatted(p)
    local i = tARMA.getCachedMinimapAnchor()
    updateMoneyUI("£" .. a, "£" .. b, d, i.rightX * i.resX)
end)
Citizen.CreateThread(function()
    TriggerServerEvent("ARMA:requestPlayerBankBalance")
    local r = false
    while true do
        local s, t = GetActiveScreenResolution()
        if s ~= e or t ~= f then
            e, f = GetActiveScreenResolution()
            cachedMinimapAnchor = GetMinimapAnchor()
            updateMoneyUI("£" .. a, "£" .. b, d, cachedMinimapAnchor.rightX * cachedMinimapAnchor.resX)
        end
        if NetworkIsPlayerTalking(PlayerId()) then
            if not r then
                r = true
                SendNUIMessage({moneyTalking = true})
            end
        else
            if r then
                r = false
                SendNUIMessage({moneyTalking = false})
            end
        end
        Wait(0)
    end
end)
