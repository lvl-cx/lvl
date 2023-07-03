RMenu.Add('oasispedsmenu','main',RageUI.CreateMenu("OASIS Peds", "OASIS Peds Menu", tOASIS.getRageUIMenuWidth(), tOASIS.getRageUIMenuHeight()))
local a=module("cfg/cfg_peds")
local b = a.pedMenus
local c = {}
local d = nil
local e = nil
local f = true
local g
local h = false
local j = {}
local k = {}
local l = 0
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('oasispedsmenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if d ~= nil or e ~= nil and tOASIS.getCustomization() ~= d then
                RageUI.Button("Reset",nil,{},true,function(m, n, o)
                    if o then
                        revertPedChange()
                    end
                end)
            end
            for i = 1, #c, 1 do
                RageUI.Button(c[i][2],nil,{},true,function(m, n, o)
                    if o then
                        if GetEntityHealth(tOASIS.getPlayerPed()) > 102 then
                            spawnPed(c[i][1])
                        else
                            tOASIS.notify("~r~You try to change ped, but then remember you are dead.")
                        end
                    end
                end)
            end
        end)
    end
end)

function showPedsMenu(p)
    RageUI.Visible(RMenu:Get("oasispedsmenu", "main"), p)
end
function spawnPed(q)
    local r = tOASIS.getPlayerPed()
    local s = GetEntityHeading(r)
    tOASIS.setCustomization({model = q})
    SetEntityHeading(tOASIS.getPlayerPed(), s)
    Wait(100)
    SetEntityMaxHealth(tOASIS.getPlayerPed(), 200)
    SetEntityHealth(tOASIS.getPlayerPed(), 200)
end
function revertPedChange()
    tOASIS.setCustomization(d)
end
RegisterNetEvent("OASIS:buildPedMenus",function(t)
    for i = 1, #j do
        tOASIS.removeArea(j[i])
        j[i] = nil
    end
    for i = 1, #k do
        tOASIS.removeMarker(k[i])
    end
    local u = function(v)
    end
    local w = function(x)
        c = a.peds[x.menu_id]
        g = i
        if f then
            d = tOASIS.getCustomization()
            l = GetEntityHealth(tOASIS.getPlayerPed())
        end
        h = true
        showPedsMenu(true)
        f = false
    end
    local y = function(v)
        showPedsMenu(false)
        f = true
        h = false
        SetEntityHealth(tOASIS.getPlayerPed(), l)
    end
    for i = 1, #t do
        local z = t[i]
        local A = z[1]
        local B = string.format("pedmenu_%s_%s", A, i)
        tOASIS.createArea(B, z[2], 1.25, 6, w, y, u, {menu_id = A})
        local C = tOASIS.addMarker(z[2].x, z[2].y, z[2].z - 1, 0.7, 0.7, 0.5, 0, 255, 125, 125, 50, 27, false, false)
        j[#j + 1] = B
        k[#k + 1] = C
    end
end)
function getPedMenuId(string)
    return stringsplit(string, "_")[2]
end