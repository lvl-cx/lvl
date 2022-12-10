local a = module("cfg/cfg_store")
local b = {}
local c = {}
local d = nil
local e = nil
local f = nil
local g = nil
local h = nil
local i = nil
local function j()
    return {
        speedBuffer = {},
        speed = 0.0,
        speedDisplay = 0.0,
        accel = 0.0,
        accelDisplay = 0.0,
        decel = 0.0,
        decelDisplay = 0.0
    }
end
local k = false
local l = 0
local m = 0
local n = 0
local o = j()
local p = {"Speed", "Drift", "Handling", "City", "Airport"}
local q = {
    vector3(2370.8, 2856.58, 40.46),
    vector3(974.58, -3006.6, 5.9),
    vector3(1894.57, 3823.71, 31.98),
    vector3(-482.63, -664.24, 32.74),
    vector3(-1728.25, -2894.99, 13.94)
}
local r = {"Heathrow", "Sandy"}
local s = {vector3(-1617.911, -2980.999, 13.944), vector3(1584.309, 3218.135, 40.406)}
local t = {"Docks", "Sandy Lake"}
local u = {vector3(-330.306, -3366.949, 0.953), vector3(318.469, 3811.260, 29.219)}
local v = 1
local w = nil
local x = nil
local y = nil
RMenu.Add("store","mainmenu",RageUI.CreateMenu("","Inventory",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "store"))
RMenu.Add("store","info",RageUI.CreateSubMenu(RMenu:Get("store", "mainmenu"),"","Information",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight()))
RMenu.Add("store","redeem",RageUI.CreateSubMenu(RMenu:Get("store", "info"), "", "Redeem", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight()))
RMenu.Add("store","vehicleList",RageUI.CreateSubMenu(RMenu:Get("store", "redeem"),"","Vehicles",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight()))
RMenu.Add("store","vehicleListInner",RageUI.CreateSubMenu(RMenu:Get("store", "vehicleList"),"","Vehicles",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight()))
RMenu.Add("store","vehicleSelection",RageUI.CreateSubMenu(RMenu:Get("store", "vehicleList"),"","Vehicle Options",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight()))
local function z(A, B)
    tARMA.notify("~r~" .. A.name .. " " .. B)
end
local function C(A, D)
    local E = D or e[A.field]
    if not E then
        z(A, "must not be empty.")
        return false
    elseif A.minLength and #E < A.minLength then
        z(A, "must be " .. tostring(A.minLength) .. " characters or greater.")
        return false
    elseif A.maxLength and #E > A.maxLength then
        z(A, "must be " .. tostring(A.maxLength) .. " characters or less.")
        return false
    end
    return true
end
local function F(A)
    local G = e[A.field]
    if G then
        if A.items[G] then
            return A.items[G]
        else
            for H, E in pairs(A.items) do
                if type(E) == "table" then
                    if E[G] then
                        return E[G]
                    end
                end
            end
        end
    end
    return ""
end
local function I(J)
    if globalOwnedPlayerVehicles[J] then
        return false
    else
        for K, L in pairs(e) do
            if string.match(K, "vipCar") or string.match(K, "customCar") then
                if L == J then
                    return false
                end
            end
        end
        return true
    end
end
local function M(A)
    for N, O in pairs(A.items) do
        if type(O) == "table" then
            for P in pairs(O) do
                if I(P) then
                    return false
                end
            end
        elseif I(N) then
            return false
        end
    end
    return true
end
local function Q(A)
    if not A.allowEmpty and F(A) == "" then
        local R = A.allowEmptyIfError and M(A)
        if not R then
            z(A, "can not be empty.")
        end
        return R
    end
    return true
end
local function S(T)
    local U = true
    if T.args then
        for H, A in pairs(a.argsTemplate[T.args]) do
            if A.type == "string" and not C(A) then
                U = false
            elseif A.type == "vehicleList" and not Q(A) then
                U = false
            end
        end
    end
    return U
end
local function V(A)
    RageUI.ButtonWithStyle(A.name,A.description,{RightLabel = e[A.field]},true,function(W, X, Y)
        if Y then
            tARMA.clientPrompt(A.name,"",function(Z)
                if C(A, Z) then
                    e[A.field] = Z
                end
            end)
        end
    end,nil)
end
local function _(A)
    local a0 = F(A)
    if a0 == "" and A.emptyText then
        a0 = A.emptyText
    end
    RageUI.ButtonWithStyle(A.name,A.description,{RightLabel = a0},true,function(W, X, Y)
        if Y then
            f = A
        end
    end,RMenu:Get("store", "vehicleList"))
end
local function a1(J)
    k = true
    TriggerServerEvent("ARMA:setInVehicleTestingBucket", true)
    y = tARMA.getPlayerCoords()
    v = 1
    local a2 = GetHashKey(J)
    if IsThisModelABoat(a2) then
        w = t
        x = u
    elseif IsThisModelAPlane(a2) or IsThisModelAHeli(a2) then
        w = r
        x = s
    else
        w = p
        x = q
    end
    local a3 = x[v]
    local a4 = GetEntityHeading(PlayerPedId())
    l = tARMA.spawnVehicle(J, a3.x, a3.y, a3.z, a4, true, false, false)
    m = GetGameTimer()
end
local function a5(a6)
    local a7 = {}
    for a8, a9 in pairs(a6) do
        table.insert(a7, {a.items[a9].name, a8})
    end
    table.sort(a7,function(aa, ab)
        return aa[1] < ab[1]
    end)
    local ac = 0
    return function()
        ac = ac + 1
        if a7[ac] then
            return a7[ac][1], a7[ac][2]
        else
            return nil, nil
        end
    end
end
local function ad(a6, ae)
    local a7 = {}
    for af, E in pairs(a6) do
        table.insert(a7, {af, E})
    end
    table.sort(a7,function(aa, ab)
        if ae then
            return aa[2] < ab[2]
        else
            return aa[1] < ab[1]
        end
    end)
    local ac = 0
    return function()
        ac = ac + 1
        if a7[ac] then
            return a7[ac][1], a7[ac][2]
        else
            return nil, nil
        end
    end
end

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('store', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tARMA.isDev() then
                if i then
                    RageUI.Separator("~g~Your rank is " .. i)
                end
                for K, a8 in a5(b) do
                    RageUI.ButtonWithStyle(K,"",{RightLabel = "→→→"},true,function(W, X, Y)
                        if Y then
                            if a8 ~= d then
                                e = {}
                            end
                            d = a8
                        end
                    end,RMenu:Get("store", "info"))
                end
            else
                RageUI.Separator('~g~Coming soon.')
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('store', 'info')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            local a9 = b[d]
            if not a9 then
                RageUI.ActuallyCloseAll()
                return
            end
            local T = a.items[a9]
            local ag = T.name .. "   |   " .. d
            RageUI.Separator(ag)
            if T.manuallyRedeemable then
                RageUI.ButtonWithStyle("Redeem Item",T.description,{RightLabel = "→→→"},true,function(W, X, Y)
                    if Y then
                        TriggerServerEvent("ARMA:getStoreLockedVehicleCategories")
                    end
                end,RMenu:Get("store", "redeem"))
            else
                RageUI.ButtonWithStyle("Redeem Item",T.description,{},false,function()
                end,nil)
            end
            if T.canTransfer then
                RageUI.ButtonWithStyle("Sell To Player","This will transfer the entire package, including any redeemable content, to the specified player.",{RightLabel = "→→→"},true,function(W, X, Y)
                    if Y then
                        if isInGreenzone then
                            TriggerServerEvent("ARMA:startSellStoreItem", d)
                        else
                            tARMA.notify("~r~You must be in a greenzone to sell.")
                        end
                    end
                end,nil)
            else
                RageUI.ButtonWithStyle("Sell To Player","",{},false,function()
                end,nil)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('store', 'redeem')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            local a9 = b[d]
            if not a9 then
                RageUI.ActuallyCloseAll()
                return
            end
            local T = a.items[a9]
            if T.args then
                for H, A in pairs(a.argsTemplate[T.args]) do
                    if A.type == "string" then
                        V(A)
                    elseif A.type == "vehicleList" then
                        _(A)
                    end
                end
            end
            RageUI.ButtonWithStyle("~g~Redeem " .. T.name,"",{RightLabel = "→→→"},true,function(W, X, Y)
                if Y then
                    if S(T) then
                        TriggerServerEvent("ARMA:redeemStoreItem", d, e)
                    else
                        tARMA.notify("~r~Unable to redeem, one or more argument is invalid.")
                    end
                end
            end,nil)
        end)
    end
    if RageUI.Visible(RMenu:Get('store', 'vehicleList')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for af, E in ad(f.items, false) do
                if type(E) == "table" then
                    local ah = not c[af]
                    local ai = ah and "" or "You do not have access to this garage."
                    RageUI.ButtonWithStyle(af,ai,{RightLabel = "→→→"},ah,function(W, X, Y)
                        if Y then
                            h = af
                        end
                    end,RMenu:Get("store", "vehicleListInner"))
                else
                    local ah = I(af)
                    local ai = ah and "" or "You can not own more than one of this vehicle."
                    RageUI.ButtonWithStyle(E,ai,{RightLabel = "→→→"},ah,function(W, X, Y)
                        if Y then
                            g = af
                        end
                    end,RMenu:Get("store", "vehicleSelection"))
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('store', 'vehicleListInner')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for af, E in ad(f.items[h], true) do
                local ah = I(af)
                local ai = ah and "" or "You can not own more than one of this vehicle."
                RageUI.ButtonWithStyle(E,ai,{RightLabel = "→→→"},ah,function(W, X, Y)
                    if Y then
                        g = af
                    end
                end,RMenu:Get("store", "vehicleSelection"))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('store', 'vehicleSelection')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Select Vehicle","",{RightLabel = "→→→"},true,function(W, X, Y)
                if Y then
                    e[f.field] = g
                end
            end,RMenu:Get("store", "redeem"))
            RageUI.ButtonWithStyle("Preview Vehicle","",{RightLabel = "→→→"},true,function(W, X, Y)
                if Y then
                    if tARMA.canAnim() and tARMA.getPlayerCombatTimer() == 0 and tARMA.getPlayerVehicle() == 0 and not tARMA.isPlayerInRedZone() and tARMA.getPlayerBucket() == 0 then
                        a1(g)
                    else
                        tARMA.notify("~r~You can not preview right now.")
                    end
                end
            end,nil)
        end)
    end
end)


RegisterNetEvent("ARMA:sendStoreItems",function(aj)
    b = aj
end)
RMenu.Add("vehicletesting","mainmenu",RageUI.CreateMenu("","Main Menu",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "store"))
RMenu.Add("vehicletesting","extras",RageUI.CreateSubMenu(RMenu:Get("vehicletesting", "mainmenu"),"","Extras",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight()))
local function ak()
    local al = GetEntitySpeed(l)
    table.insert(o.speedBuffer, al)
    if #o.speedBuffer > 100 then
        table.remove(o.speedBuffer, 1)
    end
    local am = 0.0
    local an = 0.0
    local ao = 0
    local ap = 0
    for aq, ar in ipairs(o.speedBuffer) do
        if aq > 1 then
            local as = ar - o.speedBuffer[aq - 1]
            if as > 0.0 then
                am = am + as
                ao = ao + 1
            else
                an = am + as
                ap = ap + 1
            end
        end
    end
    am = am / ao
    an = an / ap
    o.speed = math.max(o.speed, al)
    o.speedDisplay = o.speed * 2.236936
    o.accel = math.max(o.accel, am)
    o.accelDisplay = o.accel * 60.0 * 2.236936
    o.decel = math.min(o.decel, an)
    o.decelDisplay = math.abs(o.decel) * 60.0 * 2.236936
end
local function at()
    SetVehicleEngineHealth(l, 9999)
    SetVehiclePetrolTankHealth(l, 9999)
    SetVehicleFixed(l)
end
local function au()
    local av = false
    for ac = 1, 12 do
        if DoesExtraExist(l, ac) then
            av = true
        end
    end
    return av
end
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('vehicletesting', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("Statistics")
            local aw = 0
            if n ~= 0 then
                aw = n - m
            else
                aw = GetGameTimer() - m
            end
            RageUI.ButtonWithStyle("Time Elapsed","",{RightLabel = string.format("%.1fs", aw / 1000.0)},true,function()
            end,nil)
            RageUI.ButtonWithStyle("Top Speed","",{RightLabel = string.format("%.1f MPH", o.speedDisplay)},true,function()
            end,nil)
            RageUI.ButtonWithStyle("Top Acceleration","",{RightLabel = string.format("%.1f MPH", o.accelDisplay)},true,function()
            end,nil)
            RageUI.ButtonWithStyle("Top Deacceleration","",{RightLabel = string.format("%.1f MPH", o.decelDisplay)},true,function()
            end,nil)
            RageUI.Separator("Vehicle Options")
            RageUI.List("Teleport Location",w,v,"",{},true,function(W, X, Y, ax)
                v = ax
                if Y then
                    local a3 = x[v]
                    SetEntityCoordsNoOffset(l, a3.x, a3.y, a3.z, true, false, false)
                end
            end,function()end,nil)
            RageUI.ButtonWithStyle("Repair Vehicle","",{},true,function(W, X, Y)
                if Y then
                    at()
                    if not IsVehicleOnAllWheels(l) then
                        local a3 = GetEntityCoords(l, true)
                        SetEntityCoordsNoOffset(l, a3.x, a3.y, a3.z, true, false, false)
                    end
                end
            end,nil)
            if au() then
                RageUI.ButtonWithStyle("Extras","",{RightLabel = "→→→"},true,function()
                end,RMenu:Get("vehicletesting", "extras"))
            end
            RageUI.ButtonWithStyle("~r~Stop Previewing","",{RightLabel = "→→→"},true,function(W, X, Y)
                if Y then
                    k = false
                    DeleteEntity(l)
                    SetEntityCoordsNoOffset(PlayerPedId(), y.x, y.y, y.z, false, false, false)
                    TriggerServerEvent("ARMA:setInVehicleTestingBucket", false)
                    RageUI.Visible(RMenu:Get("store", "vehicleSelection"), true)
                end
            end,nil)
        end)
    end
    if RageUI.Visible(RMenu:Get('vehicletesting', 'extras')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for ac = 1, 12 do
                if DoesExtraExist(l, ac) then
                    if IsVehicleExtraTurnedOn(vehicle, ac) then
                        RageUI.ButtonWithStyle("Disable Extra " .. ac,nil,{RightLabel = tostring(ac)},function(W, X, Y)
                            if Y then
                                SetVehicleExtra(vehicle, ac, true)
                            end
                        end,nil)
                    else
                        RageUI.ButtonWithStyle("Enable Extra " .. ac,nil,{RightLabel = tostring(ac)},function(W, X, Y)
                            if Y then
                                SetVehicleExtra(vehicle, ac, false)
                                at()
                            end
                        end,nil)
                    end
                end
            end
        end)
    end
end)

local function ay()
    if k then
        if not RageUI.Visible(RMenu:Get("vehicletesting", "mainmenu")) and not RageUI.Visible(RMenu:Get("vehicletesting", "extras")) then
            RageUI.Visible(RMenu:Get("vehicletesting", "mainmenu"), true)
        end
        DisableControlAction(0, 23, true)
        DisableControlAction(0, 75, true)
        local vehicle, az = tARMA.getPlayerVehicle()
        if (vehicle ~= l or not az) and DoesEntityExist(l) then
            SetPedIntoVehicle(PlayerPedId(), l, -1)
        end
        if n == 0 then
            subtitleText("~y~Press [E] to stop recording stats")
            ak()
            if IsControlJustPressed(0, 51) then
                n = GetGameTimer()
            end
        else
            subtitleText("~y~Press [E] to start recording stats")
            if IsControlJustPressed(0, 51) then
                o = j()
                m = GetGameTimer()
                n = 0
            end
        end
    end
end
tARMA.createThreadOnTick(ay)
function tARMA.isInStoreTesting()
    return k
end
RegisterNetEvent("ARMA:storeDrawEffects",function()
    tARMA.loadPtfx("scr_xs_celebration")
    tARMA.loadPtfx("scr_rcpaparazzo1")
    for H = 1, 4 do
        local a3 = tARMA.getPlayerCoords()
        UseParticleFxAsset("scr_xs_celebration")
        StartParticleFxNonLoopedAtCoord("scr_xs_confetti_burst",a3.x,a3.y,a3.z - 0.8,0.0,0.0,0.0,1.2,false,false,false)
        UseParticleFxAsset("scr_rcpaparazzo1")
        StartParticleFxNonLoopedAtCoord("scr_mich4_firework_burst_spawn",a3.x,a3.y,a3.z,0.0,0.0,0.0,1.0,false,false,false)
        Citizen.Wait(500)
    end
    RemoveNamedPtfxAsset("scr_xs_celebration")
    RemoveNamedPtfxAsset("scr_rcpaparazzo1")
end)
RegisterNetEvent("ARMA:setStoreLockedVehicleCategories",function(aA)
    c = aA
end)
RegisterCommand("store",function()
    RageUI.Visible(RMenu:Get("store", "mainmenu"), true)
end,false)
RegisterNetEvent("ARMA:setStoreRankName",function(aB)
    i = aB
end)
RegisterNetEvent("ARMA:storeCloseMenu",function()
    RageUI.Visible(RMenu:Get("store", "mainmenu"), false)
end)
