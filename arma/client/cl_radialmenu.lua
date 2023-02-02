local a = false
local b = nil
local c = nil
local d = false
local e = 0
local f = false
local g = false
local h = false
local i = false
local j = 0
local k = false
local l = 0
RegisterNetEvent("ARMA:showHUD")
AddEventHandler("ARMA:showHUD",function(m)
    i = not m
end)
function Crosshair(n)
    if i then
        SendNUIMessage({radialCrosshair = false})
    else
        if not d and n then
            d = true
            SendNUIMessage({radialCrosshair = n})
        elseif d and not n then
            d = false
            SendNUIMessage({radialCrosshair = n})
        end
    end
end
RegisterNUICallback("radialDisablenuifocus",function(o)
    a = o.nuifocus
    SetNuiFocusKeepInput(false)
    SetNuiFocus(o.nuifocus, o.nuifocus)
    k = false
end)
local p = math.rad
local q = math.cos
local r = math.sin
local s = math.abs
local function t(u)
    local v = p(u.x)
    local w = p(u.z)
    return vector3(-r(w) * s(q(v)), q(w) * s(q(v)), r(v))
end
local function x()
    local y = PlayerPedId()
    for z, A in pairs(GetActivePlayers()) do
        local B = GetPlayerPed(A)
        if GetEntityAttachedTo(B) == y then
            return B
        end
    end
    return 0
end
local function C()
    local D, z, z, z, E = GetShapeTestResult(e)
    if D ~= 1 then
        if D == 2 then
            if #(GetEntityCoords(PlayerPedId(), true) - GetEntityCoords(E, true)) <= 3.5 then
                b = E
                c = GetEntityType(E)
            else
                b = nil
                c = nil
            end
            j = x()
        end
        local F = GetGameplayCamRot()
        local G = GetGameplayCamCoord()
        local H = t(F)
        local I = vector3(G.x + H.x * 15.0, G.y + H.y * 15.0, G.z + H.z * 15.0)
        e = StartShapeTestLosProbe(G.x, G.y, G.z, I.x, I.y, I.z, -1, -1, 1)
    end
end
function playerIsAlive()
    return GetEntityHealth(PlayerPedId()) > 102
end
RegisterCommand("lootbag",function()
    l = GetFrameCount()
end,true)
RegisterKeyMapping("lootbag", "Open Lootbag", "KEYBOARD", "E")
local function J()
    local K = GetFrameCount()
    return l == K or l == K - 1
end
Citizen.CreateThread(function()
    while true do
        C()
        local B = PlayerPedId()
        local Q = GetVehiclePedIsIn(B, false)
        if a and Q ~= 0 and not k then
            a = false
            SendNUIMessage({closeRadialMenu = true})
        end
        if c then
            if playerIsAlive() and Q == 0 and GetRenderingCam() == -1 then
                if c == 1 and b ~= B and IsPedAPlayer(b) then
                    Crosshair(true)
                    if J() then
                        if a == false then
                            a = true
                            SetNuiFocus(true, true)
                            SendNUIMessage({openRadialMenu = true, type = "ped", police = f or h, entityId = b})
                        end
                    end
                elseif c == 2 and b ~= Q then
                    Crosshair(true)
                    if J() then
                        if a == false then
                            a = true
                            SetNuiFocus(true, true)
                            SendNUIMessage({openRadialMenu = true, type = "vehicle", police = f or h, entityId = b})
                        end
                    end
                elseif c == 3 then
                    local R = GetEntityModel(b)
                    if not g then
                        if GetHashKey("xs_prop_arena_bag_01") == R then
                            Crosshair(true)
                            if J() then
                                local LootBagID = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.5, GetHashKey('xs_prop_arena_bag_01'), false, false, false)
                                local LootBagIDNew = ObjToNet(LootBagID)
                                local LootBagCoords = GetEntityCoords(LootBagID)
                                TriggerServerEvent('ARMA:LootBag', LootBagIDNew)
                                TriggerEvent("ARMA:startCombatTimer", false)
                                Wait(1000)
                            end
                        elseif GetHashKey("prop_poly_bag_money") == R then
                            Crosshair(true)
                            if J() then
                                local MoneydropID = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.5, GetHashKey('prop_poly_bag_money'), false, false, false)
                                local MoneydropIDNew = ObjToNet(MoneydropID)
                                TriggerServerEvent('ARMA:Moneydrop', MoneydropIDNew)
                                TriggerEvent("ARMA:startCombatTimer", false)
                                Wait(1000)
                            end
                        elseif GetHashKey("prop_box_ammo03a") == R then
                            Crosshair(true)
                            if J() then
                                local S = DecorGetInt(b, "lootid")
                                TriggerEvent("ARMA:startCombatTimer", false)
                                M(function()
                                    TriggerServerEvent("ARMA:openCrate", S)
                                end)
                                Wait(1000)
                            end
                        elseif GetHashKey("xs_prop_arena_crate_01a") == R then
                            Crosshair(true)
                            if J() then
                                local id = DecorGetInt(Entity,"lootid")
                                TriggerEvent("ARMA:startCombatTimer", false)
                                TriggerServerEvent("ARMA:openCrate",id)
                                Wait(1000)
                            end
                        end
                    end
                else
                    Crosshair(false)
                end
            else
                Crosshair(false)
            end
        else
            Crosshair(false)
        end
        if not d and j ~= 0 and IsControlPressed(0, 19) and IsControlJustPressed(0, 38) then
            SetNuiFocus(true, true)
            SendNUIMessage({openRadialMenu = true, type = "ped", police = f or h, entityId = j})
        end
        Citizen.Wait(0)
    end
end)
function GetEntInFrontOfPlayer(T, U)
    local V = nil
    local W = GetEntityCoords(U, 1)
    local X = GetOffsetFromEntityInWorldCoords(U, 0.0, T, 0.0)
    local Y = StartExpensiveSynchronousShapeTestLosProbe(W.x, W.y, W.z, X.x, X.y, X.z, -1, U, 0)
    local Z, _, a0, a1, V = GetShapeTestResult(Y)
    return V
end
function GetCoordsFromCam(a2)
    local a3 = GetGameplayCamRot(2)
    local a4 = GetGameplayCamCoord()
    local a5 = a3.z * 0.0174532924
    local a6 = a3.x * 0.0174532924
    local a7 = math.abs(math.cos(a6))
    newCoordX = a4.x + -math.sin(a5) * (a7 + a2)
    newCoordY = a4.y + math.cos(a5) * (a7 + a2)
    newCoordZ = a4.z + math.sin(a6) * 8.0
    return newCoordX, newCoordY, newCoordZ
end
function Target(T, U)
    local b = nil
    local a8 = GetGameplayCamCoord()
    local a9, aa, ab = GetCoordsFromCam(T)
    local Y = StartExpensiveSynchronousShapeTestLosProbe(a8.x, a8.y, a8.z, a9, aa, ab, -1, U, 0)
    local Z, _, a0, a1, b = GetShapeTestResult(Y)
    return b, a9, aa, ab
end
local function ac(ad)
    TriggerEvent("ARMA:lockNearestVehicle")
end
local ae
local function af(ad)
    ae = ad
    SetVehicleDoorOpen(ad, 5, true)
    TriggerEvent("ARMA:clOpenTrunk")
    trunkStatus = true
    SendNUIMessage({closeRadialMenu = true})
    local ag = GetSoundId()
    PlaySoundFrontend(ag, "boot_pop", "dlc_vw_body_disposal_sounds", true)
    ReleaseSoundId(ag)
end
RegisterNetEvent("ARMA:clCloseTrunk")
AddEventHandler("ARMA:clCloseTrunk",function()
    if ae then
        SetVehicleDoorShut(ae, 5, true)
    end
end)
local function ah(ad)
    local B = PlayerPedId()
    if GetEntityHealth(B) > 102 and not IsEntityDead(B) then
        TaskStartScenarioInPlace(B, "world_human_maid_clean", 0, 1)
        Wait(10000)
        SetVehicleDirtLevel(ad, 0.0)
        SetVehicleUndriveable(ad, false)
        ClearPedSecondaryTask(B)
        ClearPedTasks(B)
    end
end
local function ai(ad)
    TriggerEvent("ARMA:verifyLockpick", ad)
end
local function aj(ad)
    TriggerServerEvent("ARMA:attemptRepairVehicle")
end
local ak = false
local function al(ad)
    if not ak then
        SetVehicleDoorOpen(ad, 4, false)
        ak = true
    else
        SetVehicleDoorShut(ad, 4, false)
        ak = false
    end
end
local function am(ad)
    if f then
        TriggerEvent("ARMA:searchClient", ad)
    end
end
local function an(ad)
    if f then
        local ao = tonumber(DecorGetInt(ad, "vRP_owner"))
        if ao > 0 then
            tARMA.impoundVehicleOptions(ao, GetEntityModel(ad), VehToNet(ad), ad)
        else
            TriggerEvent("ARMA:Notify", "~r~Vehicle is not owned by anyone")
            if GetPedInVehicleSeat(ad, -1) == 0 and GetPedInVehicleSeat(ad, 0) == 0 and NetworkGetEntityIsNetworked(ad) then
                TriggerServerEvent("ARMA:impoundDeleteVehicle", NetworkGetNetworkIdFromEntity(ad))
            end
        end
    end
end
local function ap(ad)
    local aq = GetPlayerByEntityID(ad)
    local ar = GetPlayerServerId(aq)
    if ar > 0 then
        if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("WEAPON_UNARMED") then
            TriggerServerEvent("ARMA:robPlayer", ar)
        else
            TriggerEvent("ARMA:Notify", "~r~You need a weapon in your hands.")
        end
    end
end
local function as(ad)
    local at = GetPedInVehicleSeat(ad, -1)
    if at ~= 0 then
        local A = GetPlayerByEntityID(at)
        local ar = GetPlayerServerId(A)
        if ar > 0 then
            TriggerServerEvent("ARMA:askId", ar)
        end
    end
end
local function au(ad)
    local aq = GetPlayerByEntityID(ad)
    local ar = GetPlayerServerId(aq)
    if ar > 0 then
        TriggerServerEvent("ARMA:askId", ar)
    end
end
local function av(ad)
    local aq = GetPlayerByEntityID(ad)
    local ar = GetPlayerServerId(aq)
    if ar > 0 then
        TriggerServerEvent("ARMA:giveCashToPlayer", ar)
    end
end
local function aw(ad)
    if not tvRP.canAnim() then
        return
    end
    if GetEntityHealth(ad) <= 102 then
        TriggerEvent("ARMA:Notify", "~r~You can not search a player who is dead.")
        return
    end
    local aq = GetPlayerByEntityID(ad)
    if not f and not h then
        local ax = GetPlayerPed(aq)
        if ax ~= nil then
            if IsEntityPlayingAnim(ax, "missminuteman_1ig_2", "handsup_enter", 3) or IsEntityPlayingAnim(ax, "random@arrests", "idle_2_hands_up", 3) or IsEntityPlayingAnim(ax, "random@arrests@busted", "idle_a", 3) then
                local ar = GetPlayerServerId(aq)
                if ar > 0 then
                    TriggerServerEvent("ARMA:searchPlayer", ar)
                end
            else
                TriggerEvent("ARMA:Notify", "~r~Player must have their hands up or be on their knees!")
            end
        end
    else
        local ar = GetPlayerServerId(aq)
        if ar > 0 then
            TriggerServerEvent("ARMA:searchPlayer", ar)
        end
    end
end
local function ay(ad)
    local aq = GetPlayerByEntityID(ad)
    local ar = GetPlayerServerId(aq)
    if ar > 0 then
        if g then
            TriggerServerEvent("ARMA:nhsRevive", ar)
        else
            TriggerServerEvent("ARMA:attemptCPR", ar)
        end
    end
end
local function az(ad)
    if f or h then
        local aq = GetPlayerByEntityID(ad)
        local ar = GetPlayerServerId(aq)
        if ar > 0 then
            ExecuteCommand("cuff")
        end
    end
end
local function aA(ad)
    if f or h then
        local aq = GetPlayerByEntityID(ad)
        local ar = GetPlayerServerId(aq)
        if ar > 0 then
            TriggerServerEvent("ARMA:dragPlayer", ar)
        end
    end
end
local function aB(ad)
    if f or h then
        local aq = GetPlayerByEntityID(ad)
        local ar = GetPlayerServerId(aq)
        if ar > 0 then
            TriggerServerEvent("ARMA:putInVehicle", ar)
        end
    end
end
local function aC(ad)
    local aq = GetPlayerByEntityID(ad)
    local ar = GetPlayerServerId(aq)
    if ar > 0 then
        TriggerServerEvent("ARMA:gunshotTest", ar)
    end
end
local function aD(ad)
    if f or h then
        local aq = GetPlayerByEntityID(ad)
        local ar = GetPlayerServerId(aq)
        if ar > 0 then
            TriggerServerEvent("ARMA:seizeWeapons", ar)
            TriggerServerEvent("ARMA:jailPlayer", ar)
        end
    end
end
local function aE(ad)
    if f or h then
        local aq = GetPlayerByEntityID(ad)
        local ar = GetPlayerServerId(aq)
        if ar > 0 then
            TriggerServerEvent("ARMA:requestTransport", ar)
        end
    end
end
local function aF(ad)
    if f or h then
        local aq = GetPlayerByEntityID(ad)
        local ar = GetPlayerServerId(aq)
        if ar > 0 then
            TriggerServerEvent("ARMA:seizeWeapons", ar)
        end
    end
end
local function aG(ad)
    if f or h then
        local aq = GetPlayerByEntityID(ad)
        local ar = GetPlayerServerId(aq)
        if ar > 0 then
            TriggerServerEvent("ARMA:seizeIllegals", ar)
        end
    end
end
RegisterNUICallback("radialClick",function(o)
    local aH = o.itemid
    local ad = o.entity
    if IsPedInAnyVehicle(PlayerPedId(), true) and not k then
        return
    end
    if aH == "lock" then
        ac(ad)
    elseif aH == "openBoot" then
        af(ad)
    elseif aH == "cleanCar" then
        ah(ad)
    elseif aH == "lockpick" then
        ai(ad)
    elseif aH == "repair" then
        aj(ad)
    elseif aH == "openHood" then
        al(ad)
    elseif aH == "searchvehicle" then
        am(ad)
    elseif aH == "impoundVehicle" then
        an(ad)
    elseif aH == "askDriverId" then
        as(ad)
    elseif aH == "askId" then
        au(ad)
    elseif aH == "giveCash" then
        av(ad)
    elseif aH == "search" then
        aw(ad)
    elseif aH == "robPerson" then
        ap(ad)
    elseif aH == "revive" then
        ay(ad)
    elseif aH == "handcuff" then
        az(ad)
    elseif aH == "drag" then
        aA(ad)
    elseif aH == "putincar" then
        aB(ad)
    elseif aH == "gunshottest" then
        aC(ad)
    elseif aH == "jail" then
        aD(ad)
    elseif aH == "requesttransport" then
        aE(ad)
    elseif aH == "seizeweapons" then
        aF(ad)
    elseif aH == "seizeillegals" then
        aG(ad)
    elseif aH == "leaveRadio" then
        TriggerEvent("ARMA:clientLeaveRadioChannel")
    elseif aH == "toggleMute" then
        ExecuteCommand("toggleradiomute")
    elseif aH == "radioConfig" then
        TriggerEvent("ARMA:openRadioConfig")
    elseif string.match(aH, "radioChannel") then
        local aI = string.sub(aH, 13, #aH)
        TriggerEvent("ARMA:clientJoinRadioChannel", tonumber(aI))
    end
end)
RegisterNetEvent("ARMA:setPoliceOnDuty")
AddEventHandler("ARMA:setPoliceOnDuty",function(aJ)
    f = aJ
end)
RegisterNetEvent("ARMA:RecieveNHSOnDutyFlag")
AddEventHandler("ARMA:RecieveNHSOnDutyFlag",function(aJ)
    g = aJ
end)
RegisterNetEvent("ARMA:setPrisonGuardOnDuty",function(aK)
    h = aK
end)
function GetPlayerByEntityID(aL)
    for z, S in ipairs(GetActivePlayers()) do
        if aL == GetPlayerPed(S) then
            return S
        end
    end
    return nil
end
function tARMA.getSelectedEntity()
    return b, c
end
AddEventHandler("ARMAUI:showRadioWheel",function(aM)
    if k then
        return
    end
    a = true
    k = true
    SetNuiFocusKeepInput(true)
    SetNuiFocus(true, true)
    SendNUIMessage({openRadialMenu = true, type = "radios", wheelData = aM})
    while k do
        for aL = 0, 6 do
            DisableControlAction(0, aL, true)
        end
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 69, true)
        DisableControlAction(0, 79, true)
        DisableControlAction(0, 92, true)
        DisableControlAction(0, 114, true)
        DisableControlAction(0, 140, true)
        DisableControlAction(0, 141, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 257, true)
        DisableControlAction(0, 263, true)
        DisableControlAction(0, 264, true)
        Citizen.Wait(0)
    end
end)
