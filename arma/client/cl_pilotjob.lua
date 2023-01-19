local a = module("cfg/cfg_pilotjob")
globalOnPilotDuty = false
local b = a.fuelStations
local c = {}
local d = false
local e
local f
local g
local h = false
local i = false
local j = false
local k = false
local l = false
local m
local n = false
local o
local p
local q = 0
local r = 0
local s = 0
local t = {x = 0.932, y = 0.77, width = 0.03, height = 0.4}
local u = {x = t.x, y = t.y, width = t.width, height = t.height}
local v = {x = t.x, y = t.y - t.height / 2, width = t.width, height = 0.002}
local w = {x = t.x, y = t.y + t.height / 2, width = t.width, height = v.height}
local x = {x = t.x - t.width / 2, y = t.y, width = v.height / 2, height = t.height + v.height}
local y = {x = t.x + t.width / 2, y = t.y, width = v.height / 2, height = t.height + v.height}
local z = {x = 0.965, y = 0.77, width = 0.03, height = 0.4}
local A = {x = z.x, y = 0, width = z.width, height = q / 150 * z.height}
A.y = z.y + z.height / 2 - A.height / 2
local B = {x = z.x, y = z.y - z.height / 2, width = z.width, height = 0.002}
local C = {x = z.x, y = z.y + z.height / 2, width = z.width, height = B.height}
local D = {x = z.x - z.width / 2, y = z.y, width = B.height / 2, height = z.height + B.height}
local E = {x = z.x + z.width / 2, y = z.y, width = B.height / 2, height = z.height + B.height}
RMenu.Add("ARMApilotjob","atcMenu",RageUI.CreateMenu("","Air Traffic Communications",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"arna_pilotjob","arna_pilotjob"))
AddEventHandler("ARMA:onClientSpawn",function(F, G)
    local H = a.startJobLocs
    if G then
        for I = 1, #H, 1 do
            tARMA.addMarker(H[I].coords.x,H[I].coords.y,H[I].coords.z,1.0,1.0,1.3,10,255,81,170,50,33,false,false,true,nil,nil,0.0,0.0,0.0)
        end
    end
end)
local function J(...)
    print("[Pilot Job]", ...)
end
Citizen.CreateThread(function()
    RequestStreamedTextureDict("pilotjob")
    while not HasStreamedTextureDictLoaded("pilotjob") do
        Wait(0)
    end
end)
RegisterNetEvent("ARMA:pilotJobCreatePlane",function(K, L, M)
    p = L
    o = M
    local N = a.planeSpawnLocs
    local O = a.tugSpawnLocs
    e = K
    globalOnPilotDuty = true
    tARMA.setCustomization({modelhash = "s_m_m_pilot_01"})
    Citizen.Wait(500)
    g = tARMA.spawnVehicle("airtug", O[M].coords.x, O[M].coords.y, O[M].coords.z, O[M].h, true, true, false)
    SetVehicleColours(g, 89, 0)
    SetNewWaypoint(N[L].coords.x, N[L].coords.y)
    drawPlaneScaleForm("~g~COLLECT PLANE", "Collect your plane from the waypoint on your map")
    while #(N[L].coords - tARMA.getPlayerCoords()) > 250 do
        Citizen.Wait(500)
    end
    f = tARMA.spawnVehicle(K.spawnName, N[L].coords.x, N[L].coords.y, N[L].coords.z, N[L].h, false, true, false)
    local P = GetOffsetFromEntityInWorldCoords(f, 0.0, 0.0, 6.0)
    tARMA.setNamedMarker("planeMarker",P.x,P.y,P.z,2.0,2.0,2.3,10,255,81,255,250,0,false,true,true,nil,nil,0.0,0.0,0.0)
    while not IsPedInVehicle(tARMA.getPlayerPed(), f, false) do
        if DoesEntityExist(f) then
            if GetVehicleEngineHealth(f) <= 0 then
                return
            end
        else
            return
        end
        Citizen.Wait(1000)
    end
    tARMA.removeNamedMarker("planeMarker")
    DeleteEntity(g)
    i = true
    q = 150
    TriggerEvent("ARMA:pilotCreateRepairStations")
    TriggerEvent("ARMA:pilotCreateFuelStations")
    Citizen.Wait(10000)
    TriggerServerEvent("ARMA:pilotTakenPlane", L)
    TriggerServerEvent("ARMA:pilotTakenTug", M)
end)

RegisterNetEvent("ARMA:pilotJobPickupLoc",function(Q)
    print("triggering pickup")
    tARMA.removeArea("dropOffPassengers_")
    while not IsPedInVehicle(tARMA.getPlayerPed(), f, false) do
        if DoesEntityExist(f) then
            if GetVehicleEngineHealth(f) <= 0 then
                J("ARMA:pilotJobPickupLoc -> engine health (1)", f)
                return
            end
        end
        Citizen.Wait(500)
    end
    Citizen.Wait(2000)
    SetVehicleEngineOn(tARMA.getPlayerVehicle(), true, false, false)
    SetVehicleDoorsShut(tARMA.getPlayerVehicle(), false)
    FreezeEntityPosition(tARMA.getPlayerVehicle(), false)
    drawPlaneScaleForm("~g~COLLECT PASSENGERS", string.format("Collect Passengers from %s", Q.name))
    if q < 30 then
        tARMA.notify("~r~Remember to fuel your plane!")
    end
    if #(Q.coords - tARMA.getPlayerCoords()) > 1000 then
        if not aircraftTakeOffAtc(Q) then
            J("ARMA:pilotJobPickupLoc -> not aircraftTakeOffAtc", json.encode(Q))
            return
        end
    end
    SetNewWaypoint(Q.coords.x, Q.coords.y)
    if #(Q.coords - tARMA.getPlayerCoords()) > 1500 then
        while #(Q.coords - tARMA.getPlayerCoords()) > 1500 do
            if DoesEntityExist(f) then
                if GetVehicleEngineHealth(f) <= 0 then
                    J("ARMA:pilotJobPickupLoc -> engine health (2)", f)
                    return
                end
            else
                J("ARMA:pilotJobPickupLoc -> no vehicle", f)
                return
            end
            Citizen.Wait(500)
        end
        if not aircraftLandingAtc(Q) then
            J("ARMA:pilotJobPickupLoc -> not aircraftLandingAtc", json.encode(Q))
            return
        end
    end
    if not passengerCollectionAtc(Q) then
        J("passengerCollectionAtc -> not passengerCollectionAtc", json.encode(Q))
        return
    end
    local R = function()
        drawNativeNotification("Press ~INPUT_CONTEXT~ to Collect")
    end
    local S = function()
    end
    local T = function()
        if IsControlJustPressed(0, 51) and IsPedInVehicle(tARMA.getPlayerPed(), f, false) and not l then
            if GetEntitySpeed(tARMA.getPlayerVehicle()) * 2.236936 < 5 then
                l = true
                k = false
                for I = 1, #e.doorsToToggle, 1 do
                    SetVehicleDoorOpen(tARMA.getPlayerVehicle(), e.doorsToToggle[I], false, false)
                end
                TriggerServerEvent("ARMA:pilotPickupPassengers")
                FreezeEntityPosition(tARMA.getPlayerVehicle(), true)
                SetVehicleEngineOn(tARMA.getPlayerVehicle(), false, true, true)
                Citizen.CreateThread(function()
                    createPeds(true, Q)
                end)
                tARMA.notify("~g~Picking up passengers!")
            else
                tARMA.notify("~r~You are going too fast!")
            end
        elseif IsControlJustPressed(0, 51) and not IsPedInVehicle(tARMA.getPlayerPed(), f, false) and not l then
            tARMA.notify("~r~You are not in your plane!")
        end
    end
    tARMA.createArea("collectPassengers_", Q.coords, 80, 10, R, S, T)
end)
RegisterNetEvent("ARMA:pilotJobCollectedPassengers",function(U)
    print("triggering collected")
    tARMA.removeArea("collectPassengers_")
    drawPlaneScaleForm("~y~TRANSPORT PASSENGERS", string.format("Transport Passengers to %s", U.name))
    if q < 30 then
        tARMA.notify("~r~Remember to fuel your plane!")
    end
    if not aircraftTakeOffAtc(U) then
        J("ARMA:pilotJobCollectedPassengers -> not aircraftTakeOffAtc", json.encode(U))
        return
    end
    SetNewWaypoint(U.coords.x, U.coords.y)
    while #(U.coords - tARMA.getPlayerCoords()) > 1500 do
        if DoesEntityExist(f) then
            if GetVehicleEngineHealth(f) <= 0 then
                J("ARMA:pilotJobCollectedPassengers -> engine health", f)
                return
            end
        else
            J("ARMA:pilotJobCollectedPassengers -> no vehicle", f)
            return
        end
        Citizen.Wait(500)
    end
    if not aircraftLandingAtc(U) then
        J("ARMA:pilotJobCollectedPassengers -> not aircraftLandingAtc", json.encode(U))
        return
    end
    if not passengerCollectionAtc(U) then
        J("ARMA:pilotJobCollectedPassengers -> not passengerCollectionAtc", json.encode(U))
        return
    end
    local V = function()
        drawNativeNotification("Press ~INPUT_CONTEXT~ to Deliver")
    end
    local W = function()
    end
    local X = function()
        if IsControlJustPressed(0, 51) and IsPedInVehicle(tARMA.getPlayerPed(), f, false) and not k then
            k = true
            l = false
            for I = 1, #e.doorsToToggle, 1 do
                SetVehicleDoorOpen(tARMA.getPlayerVehicle(), e.doorsToToggle[I], false, false)
            end
            TriggerServerEvent("ARMA:dropoffPassengers")
            SetVehicleEngineOn(tARMA.getPlayerVehicle(), false, false, false)
            FreezeEntityPosition(tARMA.getPlayerVehicle(), true)
            Citizen.CreateThread(function()
                createPeds(false, U)
            end)
            tARMA.notify("~g~Dropping off passengers!")
        elseif IsControlJustPressed(0, 51) and not IsPedInVehicle(tARMA.getPlayerPed(), f, false) and not k then
            tARMA.notify("~r~You are not in your plane!")
        end
    end
    tARMA.createArea("dropOffPassengers_", U.coords, 80, 10, V, W, X)
end)
RegisterNetEvent("ARMA:pilotJobUpdatePlaneCapacity",function(Y, Z)
    r = Y
    s = Z
    if not createdBar then
        createdBar = true
        d = true
        Citizen.CreateThread(function()
            while d do
                if IsPedInVehicle(tARMA.getPlayerPed(), f, false) then
                    DrawRect(t.x, t.y, t.width, t.height, 0, 0, 0, 120)
                    DrawRect(u.x, u.y, u.width, u.height, 0, 200, 0, 255)
                    DrawRect(v.x, v.y, v.width, v.height, 0, 0, 0, 200)
                    DrawRect(w.x, w.y, w.width, w.height, 0, 0, 0, 200)
                    DrawRect(x.x, x.y, x.width, x.height, 0, 0, 0, 200)
                    DrawRect(y.x, y.y, y.width, y.height, 0, 0, 0, 200)
                    DrawSprite("pilotjob", "passengerSprite", t.x, t.y, 0.022, 0.045, 0.0, 255, 255, 255, 255)
                end
                Wait(0)
            end
        end)
    end
    if createdBar then
        local _ = u.height
        u.height = r / s * t.height
        u.y = u.y - (u.height - _) / 2
    end
end)
RegisterNetEvent("ARMA:pilotJobResetClient",function()
    i = false
    r = 0
    q = 0
    j = false
    k = false
    l = false
    DeleteCheckpoint(m)
    DeleteEntity(g)
    DeleteEntity(f)
    tARMA.removeArea("collectPassengers_")
    tARMA.removeArea("dropOffPassengers_")
    for I = 1, #c, 1 do
        DeleteCheckpoint(c[I])
        tARMA.removeArea("fuelPlane_" .. I)
    end
    TriggerServerEvent("ARMA:pilotTakenTug", o)
    TriggerServerEvent("ARMA:pilotTakenPlane", p)
end)
RegisterNetEvent("ARMA:pilotCreateFuelStations",function()
    local a0 = function()
        drawNativeNotification("Press ~INPUT_CONTEXT~ to Fuel Plane")
    end
    local a1 = function()
    end
    local a2 = function(a3)
        if GetEntitySpeed(tARMA.getPlayerVehicle()) < 5 then
            if IsControlJustPressed(0, 51) and not j and q < 145 then
                tARMA.notify("~g~Your plane will begin refuelling shortly")
                j = true
                Citizen.CreateThread(function()
                    deleteFuelCheckpoints()
                    fuelPlane(a3.currentStation)
                end)
            elseif IsControlJustPressed(0, 51) and j then
                tARMA.notify("~r~Your plane is currently being refuelled!")
            elseif IsControlJustPressed(0, 51) and q >= 145 then
                tARMA.notify("~r~Your plane is full of fuel!")
            end
        else
            tARMA.notify("~r~You are going too fast!")
        end
    end
    for I = 1, #b, 1 do
        tARMA.createArea("fuelPlane_" .. I, b[I].coords, 25, 10, a0, a1, a2, {currentStation = I})
        tARMA.addBlip(b[I].coords.x, b[I].coords.y, b[I].coords.z, 361, 46, "Fuel Plane")
    end
end)
RegisterNetEvent("ARMA:pilotCreateRepairStations",function()
    enter_pilotFixPlane = function()
        drawNativeNotification("Press ~INPUT_CONTEXT~ to repair your plane")
    end
    exit_pilotFixPlane = function()
    end
    ontick_pilotFixPlane = function()
        if IsControlJustPressed(0, 51) and globalOnPilotDuty and IsPedInVehicle(tARMA.getPlayerPed(), f, false) then
            if GetEntitySpeed(f) < 5.0 then
                tARMA.notify("~g~Your plane is being repaired!")
                FreezeEntityPosition(f, true)
                Citizen.Wait(15000)
                SetVehicleEngineHealth(f, 1000.0)
                SetVehicleBodyHealth(f, 1000.0)
                SetVehicleDeformationFixed(f)
                SetVehiclePetrolTankHealth(f, 1000.0)
                FreezeEntityPosition(f, false)
                tARMA.notify("~g~Your plane has been repaired!")
            else
                tARMA.notify("~r~You are going too fast!")
            end
        end
    end
    local a4 = a.planeRepairStations
    for I = 1, #a4, 1 do
        tARMA.createArea("pilotRepairStations_" .. I,a4[I].coords,25,10,enter_pilotFixPlane,exit_pilotFixPlane,ontick_pilotFixPlane)
        tARMA.addBlip(a4[I].coords.x, a4[I].coords.y, a4[I].coords.z, 446, 46, "Repair Plane")
        CreateCheckpoint(47,a4[I].coords.x,a4[I].coords.y,a4[I].coords.z - 6.5,a4[I].coords.x,a4[I].coords.y,a4[I].coords.z,25.0,255,215,0,255,0)
    end
end)
function createAtcDialogueMenu(a5)
    local a6 = true
    RageUI.Visible(RMenu:Get("ARMApilotjob", "atcMenu"), true)
    while a6 and IsPedInVehicle(tARMA.getPlayerPed(), f, false) do
        RageUI.CreateWhile(1.0, true, function()
            if RageUI.Visible(RMenu:Get('ARMApilotjob', 'mainMenu')) then
                RageUI.Button("> Communicate to ATC",a5,{},function(a7, a8, a9)
                    if a8 then
                        if IsControlJustPressed(0, 202) or IsControlJustPressed(0, 194) or IsControlJustPressed(0, 177) then
                            Citizen.Wait(1000)
                            RageUI.Visible(RMenu:Get("ARMApilotjob", "atcMenu"), true)
                        end
                    end
                    if a9 then
                        a6 = false
                    end
                end)
            end
        end)
        Wait(0)
    end
    RageUI.Visible(RMenu:Get("ARMApilotjob", "atcMenu"), false)
    RageUI.ActuallyCloseAll()
end
function checkIfAboveGround()
    if GetEntityHeightAboveGround(f) > 10 then
        h = true
        drawPlaneScaleForm("~r~LAND YOUR PLANE", "You need clearance before taking off!")
        while GetEntityHeightAboveGround(f) > 10 do
            Citizen.Wait(500)
        end
        h = false
    end
end
function passengerCollectionAtc(aa)
    checkIfAboveGround()
    if r == 0 then
        FreezeEntityPosition(f, true)
    end
    createAtcDialogueMenu("Ground Control this is Charlie Mike Golf One Five Four Three Three requesting clearance for taxi to gate 1")
    Citizen.Wait(1500)
    SendNUIMessage({transactionType = "pilotJobLine6"})
    Citizen.Wait(6000)
    createAtcDialogueMenu("Taxi'ing to gate 1 Charlie Mike Golf One Five Four Three Three")
    FreezeEntityPosition(f, false)
    Citizen.Wait(1500)
    SetNewWaypoint(aa.coords.x, aa.coords.y)
    m = CreateCheckpoint(47,aa.coords.x,aa.coords.y,aa.coords.z - 6.5,aa.coords.x,aa.coords.y,aa.coords.z,100.0,255,215,0,255,0)
    drawPlaneScaleForm("~g~TAXI YOUR PLANE", "Taxi your plane to the correct gate marked on your GPS")
    while #(aa.coords - tARMA.getPlayerCoords()) > 50 do
        if DoesEntityExist(f) then
            if GetVehicleEngineHealth(f) <= 0 then
                return false
            end
        else
            return false
        end
        Citizen.Wait(500)
    end
    DeleteCheckpoint(m)
    if r > 0 then
        createAtcDialogueMenu("Ground Control Charlie Mike Golf One Five Four Three Three taxi to gate 1 complete, requesting passenger disembarkment")
    else
        createAtcDialogueMenu("Ground Control Charlie Mike Golf One Five Four Three Three taxi to gate 1 complete, requesting passenger boarding to commence")
    end
    Citizen.Wait(1500)
    Citizen.Wait(5000)
    createAtcDialogueMenu("Received, Charlie Mike Golf One Five Four Three Three")
    return true
end
function aircraftLandingAtc(aa)
    local ab
    local ac = 2200.0
    for I = 1, #a.takeOffLocs, 1 do
        local ad = #(a.takeOffLocs[I].coords - tARMA.getPlayerCoords())
        if ad <= ac then
            ab = a.takeOffLocs[I]
            ac = ad
            break
        end
    end
    if ab ~= nil then
        createAtcDialogueMenu("Tower Control this is Charlie Mike Golf One Five Four Three Three entering your airspace now, requesting clearance to land on runway 1")
        Citizen.Wait(1500)
        SendNUIMessage({transactionType = "pilotJobLine4"})
        Citizen.Wait(6000)
        m = CreateCheckpoint(47,ab.landingCoords.x,ab.landingCoords.y,ab.landingCoords.z,ab.checkpointHeading.x,ab.checkpointHeading.y,ab.checkpointHeading.z,100.0,255,215,0,255,0)
        while tARMA.getPlayerCoords().z > ab.landingCoords.z + e.landedZ do
            if DoesEntityExist(f) then
                if GetVehicleEngineHealth(f) <= 0 then
                    return false
                end
            else
                return false
            end
            Citizen.Wait(500)
        end
        while GetEntitySpeed(f) > 2.0 do
            if DoesEntityExist(f) then
                if GetVehicleEngineHealth(f) <= 0 then
                    return false
                end
            else
                return false
            end
            Citizen.Wait(500)
        end
        DeleteCheckpoint(m)
        createAtcDialogueMenu(string.format("Tower Control Charlie Mike Golf One Five Four Three Three has landed on runway one at %s:%s hours",GetClockHours(),GetClockMinutes()))
        Citizen.Wait(1500)
        SendNUIMessage({transactionType = "pilotJobLine5"})
        Citizen.Wait(5000)
        createAtcDialogueMenu("Received, contacting ground control Charlie Mike Golf One Five Four Three Three")
        return true
    end
    return false
end
function aircraftTakeOffAtc(aa)
    local ab
    local ae = a.takeOffLocs
    for I = 1, #ae, 1 do
        if #(ae[I].coords - tARMA.getPlayerCoords()) < 500 then
            ab = ae[I]
            break
        end
    end
    if ab ~= nil then
        checkIfAboveGround()
        FreezeEntityPosition(f, true)
        createAtcDialogueMenu("Ground Control this is Charlie Mike Golf One Five Four Three Three at gate 1 requesting clearance for taxi to runway one for departure")
        Citizen.Wait(1500)
        SendNUIMessage({transactionType = "pilotJobLine1"})
        Citizen.Wait(7000)
        createAtcDialogueMenu("Taxi'ing to runway one Charlie Mike Golf One Five Four Three Three")
        FreezeEntityPosition(f, false)
        Citizen.Wait(1500)
        SetNewWaypoint(ab.coords.x, ab.coords.y)
        m = CreateCheckpoint(1,ab.coords.x,ab.coords.y,ab.coords.z,ab.checkpointHeading.x,ab.checkpointHeading.y,ab.checkpointHeading.z,30.0,0,150,0,200,false)
        drawPlaneScaleForm("~g~TAXI YOUR PLANE", "Taxi your plane to the correct runway marked on your GPS")
        while #(ab.coords - tARMA.getPlayerCoords()) > 50 do
            if DoesEntityExist(f) then
                if GetVehicleEngineHealth(f) <= 0 then
                    return false
                end
            else
                return false
            end
            Citizen.Wait(500)
        end
        while GetEntityHeading(tARMA.getPlayerVehicle()) > ab.heading + 5 or
            GetEntityHeading(tARMA.getPlayerVehicle()) < ab.heading - 5 do
            Citizen.Wait(500)
        end
        DeleteCheckpoint(m)
        checkIfAboveGround()
        FreezeEntityPosition(f, true)
        createAtcDialogueMenu("Ground Control Charlie Mike Golf One Five Four Three Three, taxi to runway one complete")
        Citizen.Wait(1500)
        SendNUIMessage({transactionType = "pilotJobLine2"})
        Citizen.Wait(5000)
        createAtcDialogueMenu("Contacting tower control Charlie Mike Golf One Five Four Three Three")
        Citizen.Wait(1500)
        createAtcDialogueMenu("Tower Control Charlie Mike Golf One Five Four Three Three at runway 1 requesting clearance for take-off")
        Citizen.Wait(1500)
        SendNUIMessage({transactionType = "pilotSeatbelt"})
        Citizen.Wait(3000)
        SendNUIMessage({transactionType = "pilotJobLine3"})
        Citizen.Wait(4000)
        createAtcDialogueMenu("Received, preparing for take-off Charlie Mike Golf One Five Four Three")
        FreezeEntityPosition(f, false)
        Citizen.Wait(1500)
        return true
    end
    return false
end
function fuelPlane(af)
    SetVehicleEngineOn(tARMA.getPlayerVehicle(), false, true, true)
    SetEntityHeading(tARMA.getPlayerVehicle(), 149.0)
    FreezeEntityPosition(tARMA.getPlayerVehicle(), true)
    local ag = "s_m_y_airworker"
    local ah = tARMA.getPlayerCoords()
    local ai = GetEntityHeading(tARMA.getPlayerPed())
    while not HasModelLoaded(ag) do
        RequestModel(ag)
        Citizen.Wait(0)
    end
    local aj = tARMA.spawnVehicle("hauler", b[af].pedCoords.x, b[af].pedCoords.y, b[af].pedCoords.z, b[af].h, false, false)
    local ak = tARMA.spawnVehicle("armatankert",b[af].pedCoords.x - 3.5,b[af].pedCoords.y - 5.5,b[af].pedCoords.z,b[af].h,false,false)
    Citizen.Wait(500)
    SetEntityInvincible(aj, true)
    SetEntityInvincible(ak, true)
    AttachVehicleToTrailer(aj, ak, 10)
    local al = CreatePedInsideVehicle(aj, "PED_TYPE_CIVMALE", ag, -1, false, false)
    SetModelAsNoLongerNeeded(ag)
    Citizen.Wait(500)
    SetEntityInvincible(al, true)
    SetPedSteersAroundVehicles(al, true)
    SetPedSteersAroundObjects(al, true)
    local am = GetEntityModel(aj)
    TaskVehicleDriveToCoord(al,aj,ah.x + e.fuelOffsetX,ah.y + e.fuelOffsetY,ah.z + e.fuelOffsetZ,7.5,1.0,am,16777216,1.0,true)
    Citizen.Wait(2000)
    local an = 0
    while #(GetEntityCoords(aj) - tARMA.getPlayerCoords()) > 25 and an < 20 do
        Citizen.Wait(1000)
        an = an + 1
    end
    Citizen.Wait(5000)
    TaskLeaveVehicle(al, aj, 64)
    local ao = GetEntityCoords(al)
    Citizen.Wait(1000)
    TaskGoStraightToCoord(al, ah.x + 1.5, ah.y - 3, ah.z, 1.0, 786603, ai, 100)
    local an = 0
    while GetEntityCoords(al).x - (ah.x + 1.5) > 2.1 and an < 12 do
        Citizen.Wait(1000)
        an = an + 1
    end
    SetEntityCoords(al, ah.x + 1.5, ah.y, ah.z, false, false, false, false)
    while not HasAnimDictLoaded("weapon@w_sp_jerrycan") do
        RequestAnimDict("weapon@w_sp_jerrycan")
        Citizen.Wait(0)
    end
    Citizen.Wait(1000)
    TaskPlayAnim(al, "weapon@w_sp_jerrycan", "fire", 8.0, -8, -1, 49, 0, 0, 0, 0)
    RemoveAnimDict("weapon@w_sp_jerrycan")
    while q < 150 do
        q = q + 1
        Citizen.Wait(250)
    end
    ClearPedTasks(al)
    TaskGoStraightToCoord(al, ao.x, ao.y, ao.z, 1.0, -1, ai, 50)
    FreezeEntityPosition(tARMA.getPlayerVehicle(), false)
    SetVehicleEngineOn(tARMA.getPlayerVehicle(), true, true, true)
    SetVehicleDoorsShut(tARMA.getPlayerVehicle(), false)
    j = false
    local an = 0
    while ao.x - GetEntityCoords(al).x < 0.2 and an < 30 do
        Citizen.Wait(1000)
        an = an - 1
    end
    TaskEnterVehicle(al, aj, 1, -1, 1.0, 1, 0)
    TaskVehicleDriveToCoord(al,aj,b[af].pedCoords.x,b[af].pedCoords.y,b[af].pedCoords.z,7.5,1.0,am,16777216,1.0,true)
    Citizen.Wait(15000)
    DeleteEntity(aj)
    DeleteEntity(ak)
    DeleteEntity(al)
end
function createPeds(ap, aq)
    while not HasModelLoaded(2120901815) do
        RequestModel(2120901815)
        Citizen.Wait(0)
    end
    Citizen.CreateThread(function()
        local ar = GetOffsetFromEntityInWorldCoords(f, -30.0, 30.0, -3.0)
        local as = GetEntityHeading(f) - 180
        if as < 0.0 then
            as = 360.0 + as
        end
        local g = tARMA.spawnVehicle("airtug", ar.x, ar.y, ar.z, as, false, false, false)
        SetEntityInvincible(g, true)
        SetVehicleColours(g, 89, 0)
        local at = GetOffsetFromEntityInWorldCoords(g, 0.0, -4.0, 0.0)
        local au = tARMA.spawnVehicle("armatugt", at.x, at.y, at.z, aq.tugCoords.w, false, false, false)
        local ag = "s_m_y_airworker"
        AttachVehicleToTrailer(g, au, 10)
        Wait(1000)
        while not HasModelLoaded(ag) do
            RequestModel(ag)
            Wait(0)
        end
        local av = CreatePedInsideVehicle(g, "PED_TYPE_CIVMALE", ag, -1, false, false)
        SetModelAsNoLongerNeeded(ag)
        local aw = GetOffsetFromEntityInWorldCoords(tARMA.getPlayerVehicle(), -12.0, -5.0, 0.0)
        local am = GetEntityModel(g)
        TaskVehicleDriveToCoord(av, g, aw.x, aw.y, aw.z, 5.0, 1.0, am, 16777216, 1.0, true)
        if ap then
            local an = 0
            while r < s do
                Wait(1000)
                an = an + 1
            end
        else
            local an = 0
            while r ~= 0 do
                Wait(1000)
                an = an + 1
            end
        end
        local ax = GetOffsetFromEntityInWorldCoords(tARMA.getPlayerVehicle(), -30.0, -30.0, 0.0)
        TaskVehicleDriveToCoord(av, g, ax.x, ax.y, ax.z, 5.0, 1.0, am, 16777216, 1.0, true)
        local an = 0
        while an < 30 do
            an = an + 1
            Wait(1000)
        end
        DeleteEntity(av)
        DeleteEntity(g)
        DeleteEntity(au)
    end)
    if ap then
        local ay = aq.pedCoords
        while r < s do
            Citizen.CreateThread(function()
                local ah = tARMA.getPlayerCoords()
                local az = CreatePed("PED_TYPE_CIVMALE", 2120901815, ay.x, ay.y, ay.z, 0.0, false, false)
                local an = 0
                TaskGoStraightToCoord(az, ah.x, ah.y, ah.z, 2.0, -1, 0.0, 0)
                Citizen.Wait(10000)
                while #(ah - GetEntityCoords(az)) > 10 and an <= 60 do
                    Citizen.Wait(1000)
                    an = an + 1
                end
                TaskEnterVehicle(az, tARMA.getPlayerVehicle(), 15000, 0, 2.0, 1, 0)
                Citizen.Wait(10000)
                DeletePed(az)
            end)
            Citizen.Wait(math.random(8000, 13000))
        end
    else
        while r ~= 0 do
            Citizen.CreateThread(function()
                local ah = GetOffsetFromEntityInWorldCoords(tARMA.getPlayerPed(), -15.0, 3.0, 0.0)
                local az = CreatePedInsideVehicle(tARMA.getPlayerVehicle(),"PED_TYPE_CIVMALE",2120901815,e.seatPedSitsIn,false,false)
                TaskLeaveVehicle(az, tARMA.getPlayerVehicle(), 256)
                Citizen.Wait(3000)
                TaskGoStraightToCoord(az, ah.x, ah.y, ah.z, 2.0, -1, 0.0, 0)
                local an = 0
                while #(ah - GetEntityCoords(az)) > 5 and an <= 30 do
                    Citizen.Wait(1000)
                    an = an + 1
                end
                DeletePed(az)
            end)
            Citizen.Wait(math.random(8000, 13000))
        end
    end
    FreezeEntityPosition(tARMA.getPlayerVehicle(), false)
    SetVehicleDoorsShut(tARMA.getPlayerVehicle(), false)
    SetVehicleEngineOn(tARMA.getPlayerVehicle(), true, false, false)
    SetModelAsNoLongerNeeded(2120901815)
end
function drawPlaneScaleForm(aA, aB, aC)
    local aD = true
    local aE = RequestScaleformMovie("mp_big_message_freemode")
    while not HasScaleformMovieLoaded(aE) do
        Wait(0)
    end
    if not aC then
        Citizen.CreateThread(function()
            while aD do
                Wait(0)
                BeginScaleformMovieMethod(aE, "SHOW_SHARD_WASTED_MP_MESSAGE")
                ScaleformMovieMethodAddParamTextureNameString(aA)
                ScaleformMovieMethodAddParamTextureNameString(aB)
                ScaleformMovieMethodAddParamInt(5)
                EndScaleformMovieMethod()
                DrawScaleformMovieFullscreen(aE, 255, 255, 255, 255)
            end
        end)
        Citizen.Wait(8000)
        aD = false
        h = false
    else
        Citizen.CreateThread(function()
            local an = aC
            Citizen.CreateThread(function()
                while an ~= 0 do
                    Wait(1000)
                    an = an - 1
                end
            end)
            while an ~= 0 do
                Wait(0)
                BeginScaleformMovieMethod(aE, "SHOW_SHARD_WASTED_MP_MESSAGE")
                ScaleformMovieMethodAddParamTextureNameString(aA)
                ScaleformMovieMethodAddParamTextureNameString(string.format("%s (Your plane will be deleted in %s seconds and your shift will end)", aB, an))
                ScaleformMovieMethodAddParamInt(5)
                EndScaleformMovieMethod()
                DrawScaleformMovieFullscreen(aE, 255, 255, 255, 255)
            end
            h = false
        end)
    end
end
function createFuelCheckpoints()
    for I = 1, #b, 1 do
        c[I] = CreateCheckpoint(1,b[I].coords.x,b[I].coords.y,b[I].coords.z - 3,b[I].coords.x,b[I].coords.y,b[I].coords.z,30.0,255,215,0,150,0)
    end
end
function deleteFuelCheckpoints()
    for I = 1, #c, 1 do
        DeleteCheckpoint(c[I])
    end
    n = false
end
function func_drawFuelLevel()
    if globalOnPilotDuty then
        if IsPedInVehicle(tARMA.getPlayerPed(), f, false) then
            if q > 0 and GetIsVehicleEngineRunning(tARMA.getPlayerVehicle()) then
                local _ = A.height
                A.y = t.y + t.height / 2 - A.height / 2
            end
            DrawRect(z.x, z.y, z.width, t.height, 0, 0, 0, 120)
            DrawRect(A.x, A.y, A.width, A.height, math.floor(200 - 200 / 150 * q), math.floor(200 / 150 * q), 0, 255)
            DrawRect(B.x, B.y, B.width, B.height, 0, 0, 0, 200)
            DrawRect(C.x, C.y, C.width, C.height, 0, 0, 0, 200)
            DrawRect(D.x, D.y, D.width, D.height, 0, 0, 0, 200)
            DrawRect(E.x, E.y, E.width, E.height, 0, 0, 0, 200)
            DrawSprite("pilotjob", "gasCanSprite", z.x, z.y, 0.022, 0.045, 0.0, 255, 255, 255, 255)
        end
    end
end
tARMA.createThreadOnTick(func_drawFuelLevel)
function func_checkIfInPlane()
    if globalOnPilotDuty then
        if DoesEntityExist(f) then
            if tARMA.getPlayerVehicle() == f then
                if GetEntityHeightAboveGround(tARMA.getPlayerVehicle()) > 60 then
                    if GetVehicleEngineHealth(f) < 0 and not h then
                        h = true
                        i = false
                        Citizen.CreateThread(function()
                            drawPlaneScaleForm("~r~MISSION FAILED", "You crashed your plane, go get a new one!")
                            TriggerServerEvent("ARMA:pilotJobReset")
                        end)
                    end
                else
                    if not h then
                        h = true
                        Citizen.CreateThread(function()
                            local aF = false
                            for I = 1, #a.takeOffLocs, 1 do
                                if #(a.takeOffLocs[I].coords - tARMA.getPlayerCoords()) < 1500 then
                                    aF = true
                                end
                            end
                            if not aF then
                                SendNUIMessage({transactionType = "pilotPullUpAlarm"})
                                drawPlaneScaleForm("~r~ LOW ALTITUDE", "Low altitude warning, Pull up!")
                            end
                            h = false
                        end)
                    end
                end
            else
                if i then
                    if not h then
                        h = true
                        Citizen.CreateThread(function()
                            drawPlaneScaleForm("~r~WARNING!", "Get back in your plane", 10)
                            Wait(10000)
                            if tARMA.getPlayerVehicle() ~= f then
                                DeleteEntity(f)
                                i = false
                                TriggerServerEvent("ARMA:pilotJobReset")
                            end
                        end)
                    end
                end
            end
        end
    end
end
tARMA.createThreadOnTick(func_checkIfInPlane)
Citizen.CreateThread(function()
    while true do
        if globalOnPilotDuty then
            if IsPedInVehicle(tARMA.getPlayerPed(), f, false) and q > 0 and GetIsVehicleEngineRunning(tARMA.getPlayerVehicle()) then
                Wait(math.random(6000, 10000))
                q = q - 1
            elseif IsPedInVehicle(tARMA.getPlayerPed(), f, false) and q == 0 and GetIsVehicleEngineRunning(tARMA.getPlayerVehicle()) then
                SetVehicleEngineOn(tARMA.getPlayerVehicle(), false, true, true)
            end
            if IsPedInVehicle(tARMA.getPlayerPed(), f, false) and q <= 30 and not n and not j then
                n = true
                createFuelCheckpoints()
            end
            A.height = q / 150 * t.height
            A.y = t.y + t.height / 2 - A.height / 2
        end
        Wait(0)
    end
end)
Citizen.CreateThread(function()
    while true do
        if globalOnPilotDuty then
            if IsPedInVehicle(tARMA.getPlayerPed(), f, false) then
                local aG = tARMA.getPlayerPed()
                local aH = tARMA.getPlayerVehicle()
                local aI = tARMA.getPlayerId()
                local aJ = GetActivePlayers()
                for aK, aL in pairs(GetGamePool("CVehicle")) do
                    SetEntityNoCollisionEntity(aG, aL, true)
                    SetEntityNoCollisionEntity(aL, aG, true)
                    SetEntityNoCollisionEntity(aH, aL, true)
                    SetEntityNoCollisionEntity(aL, aH, true)
                end
                for aM, aN in pairs(aJ) do
                    local aO = GetPlayerPed(aN)
                    local aL = GetVehiclePedIsIn(aO, true)
                    if aL and aO ~= PlayerPedId() then
                        SetEntityNoCollisionEntity(aG, aL, true)
                        SetEntityNoCollisionEntity(aL, aG, true)
                        SetEntityNoCollisionEntity(aH, aL, true)
                        SetEntityNoCollisionEntity(aL, aH, true)
                    end
                    SetEntityNoCollisionEntity(aO, aH, true)
                    SetEntityNoCollisionEntity(aH, aO, true)
                end
            end
        end
        Wait(0)
    end
end)
