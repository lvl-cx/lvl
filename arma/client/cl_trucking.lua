RMenu.Add("armatruckmenu","job",RageUI.CreateMenu("","~b~ARMA Trucking",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"arma_truckingjob","arma_truckingjob"))
local a = module("cfg/cfg_trucking")
local b = ""
local c = false
local d = {vehicle = nil, trailer = nil, checkpoint = nil}
local e = 1
local f = {}
local g = {}
local h = {}
local i = false
local j = false
globalIsDoingTruckRoute = false
globalCurrentJob = {}
globalJobOnPause = false
for k, l in pairs(a.jobs) do
    local m = l
    if m["config"] then
        local n = m["config"][1]
        local o = m["config"][2]
        tARMA.addBlip(n.x, n.y, n.z, 67, 5, o)
        tARMA.addMarker(n.x, n.y, n.z, 0.7, 0.7, 0.5, 0, 255, 125, 125, 50, 39, true, true)
    end
end
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('armatruckmenu', 'job')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if b ~= "" then
                if globalIsDoingTruckRoute == false then
                    RageUI.ButtonWithStyle("Start Job",nil,{RightLabel = "→→→"},true,function(p, q, r)
                        if r then
                            if GetResourceKvpInt("arma_trucking_done_cutscene") == 1 then
                                TriggerServerEvent("ARMA:startTruckerJob", b, false)
                            else
                                sequence()
                                TriggerServerEvent("ARMA:startTruckerJob", b, false)
                                SetResourceKvpInt("arma_trucking_done_cutscene", 1)
                            end
                        end
                    end)
                elseif globalIsDoingTruckRoute then
                    RageUI.Separator("~r~You are currently doing a job.\n")
                    RageUI.Separator("~r~ Please finish the current one to \nstart a new one!")
                    RageUI.Separator("")
                    RageUI.Separator("")
                    RageUI.ButtonWithStyle("End Job",nil,{RightLabel = "→→→"},true,function(p, q, r)
                        if r then
                            TriggerServerEvent("ARMA:endTruckerJob", "~r~You ended the job")
                        end
                    end)
                end
            end
        end)
    end
end)
AddEventHandler("ARMA:onClientSpawn",function(s, t)
    if t then
        local u = function(v)
            drawNativeNotification("Press ~INPUT_PICKUP~ to open the Trucking menu.")
        end
        local w = function(v)
            closeTruckerMenu()
        end
        local x = function(v)
            if IsControlJustReleased(1, 38) then
                if globalOnTruckJob then
                    openTruckerMenu(v.job)
                else
                    tARMA.notify("~r~You aren't clocked on as a Trucker, head to cityhall to sign up.")
                end
            end
        end
        for k, l in pairs(a.jobs) do
            local y = l["config"]
            local n = y[1]
            tARMA.createArea("trucking_" .. k, y[1], 1.15, 6, u, w, x, {job = k})
        end
    end
end)
function openTruckerMenu(z)
    b = z
    c = true
    RMenu:Get("armatruckmenu", "job"):SetSubtitle(a.jobs[z]["config"][2])
    RageUI.Visible(RMenu:Get("armatruckmenu", "job"), true)
end
function closeTruckerMenu()
    c = false
    RageUI.Visible(RMenu:Get("armatruckmenu", "job"), false)
end
RegisterNetEvent("ARMA:startTruckerJobCl",function(m, A)
    globalCurrentJob = m
    m = m[1]
    local B = getRandomTableKey(m.trailers)
    if not A then
        local C = getRandomTableKey(m.trailerSpawns["docks"])
        local n = m.trailerSpawns["docks"][e][2]
        if GetEntityModel(tARMA.getPlayerPed()) == "mp_m_freemode_01" then
            tARMA.loadCustomisationPreset("TruckerMale")
        elseif GetEntityModel(tARMA.getPlayerPed()) == "mp_f_freemode_01" then
            tARMA.loadCustomisationPreset("TruckerFemale")
        else
            tARMA.loadCustomisationPreset("TruckerMale")
        end
        d.trailer = spawnTrailer(m.trailers[B][1], n, m.trailerSpawns["docks"][e][1], m.trailers[B][2])
        f.trailer = AddBlipForCoord(GetEntityCoords(d.trailer))
        SetBlipSprite(f.trailer, 479)
        SetBlipRoute(f.trailer, true)
        g.trailer = CreateCheckpoint(45, n.x, n.y, n.z - 1.0, 0, 0, 0, 10.0, 0, 255, 0, 127, 0)
        SetCheckpointCylinderHeight(g.trailer, 50.0, 100.0, 25.0)
        Citizen.CreateThread(function()
            while GetVehiclePedIsIn(PlayerPedId(), false) == 0 and globalIsDoingTruckRoute do
                drawNativeText("~g~Rent or buy a truck outside then pickup your trailer to complete the job.")
                Wait(0)
            end
        end)
        CreateScaleform(2, "~y~Job Started!", "Pick up your trailer outside!")
    else
        local C = getRandomTableKey(m.trailerSpawns["pickup"])
        local n = m.trailerSpawns["pickup"][C][2]
        createDistanceCheckForSpawn(m.trailerSpawns["pickup"][C][2],m.trailers[B][1],m.trailerSpawns["pickup"][C][1])
        f.trailer = AddBlipForCoord(m.trailerSpawns["pickup"][C][2])
        SetBlipSprite(f.trailer, 479)
        SetBlipRoute(f.trailer, true)
        g.trailer = CreateCheckpoint(45, n.x, n.y, n.z - 1.0, 0, 0, 0, 10.0, 0, 255, 0, 127, 0)
        SetCheckpointCylinderHeight(g.trailer, 50.0, 100.0, 25.0)
        DeleteCheckpoint(d.checkpoint)
        j = false
        Citizen.CreateThread(function()
            while GetVehiclePedIsIn(PlayerPedId(), false) == 0 and globalIsDoingTruckRoute do
                drawNativeText("~g~Rent or buy a truck outside then pickup your trailer to complete the job.")
                Wait(0)
            end
        end)
        CreateScaleform(2, "~y~Job Started!", "Pick up your trailer at the blip on the map!")
    end
end)
RegisterNetEvent("ARMA:startNextJob",function()
    DeleteEntity(d.trailer)
    TriggerServerEvent("ARMA:startTruckerJob", b, true)
end)
Citizen.CreateThread(function()
    while true do
        local D = PlayerPedId()
        if IsPedInAnyVehicle(D, false) and not j then
            local E = GetVehiclePedIsIn(D, false)
            local F, G = GetVehicleTrailerVehicle(E)
            if IsVehicleAttachedToTrailer(E) and G == d.trailer then
                j = true
                i = true
                CreateScaleform(2, "~g~Trailer Attached!", "Continue to your destination")
                SetBlipRoute(f.trailer, false)
                RemoveBlip(f.trailer)
                startTruckingJob()
            end
        end
        Citizen.Wait(150)
    end
end)
function startTruckingJob()
    local m = globalCurrentJob
    local H = m[2]
    f.job = AddBlipForCoord(H)
    globalJobOnPause = false
    SetBlipSprite(f.job, m.blip)
    SetBlipRoute(f.job, true)
    local I = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(PlayerPedId(), false))
    TriggerServerEvent("ARMA:setTruck", I)
    DeleteCheckpoint(g.trailer)
    d.vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    d.checkpoint = CreateCheckpoint(45, H.x, H.y, H.z - 1.0, 0, 0, 0, 10.0, 0, 255, 0, 127, 0)
    globalIsDoingTruckRoute = true
    SetCheckpointCylinderHeight(d.checkpoint, 50.0, 100.0, 25.0)
end
function spawnTrailer(G, n, J, K)
    local E = tARMA.spawnVehicle(G, n.x, n.y, n.z, J, false, true, true)
    if K ~= nil then
        for L = 1, 9 do
            SetVehicleExtra(E, L, 1)
        end
        SetVehicleExtra(E, K, 0)
    end
    SetTrailerLegsLowered()
    return E
end
function CreateScaleform(M, N, O)
    local P = true
    local Q = Scaleform("MIDSIZED_MESSAGE")
    Q.RunFunction("SHOW_SHARD_MIDSIZED_MESSAGE", {N, O})
    Citizen.CreateThread(function()
        while P do
            Q.Render2D()
            Citizen.Wait(0)
        end
    end)
    SetTimeout(M * 1000,function()
        P = false
    end)
    return Q
end
function getRandomTableKey(table)
    math.randomseed(GetGameTimer())
    num = math.random(1, #table)
    num = math.random(1, #table)
    num = math.random(1, #table)
    return num
end
function createDistanceCheckForSpawn(H, G, J)
    tARMA.removeArea("trucking_spawn")
    local R = #h + 1
    h[R] = true
    local S = function()
        if h[R] then
            d.trailer = spawnTrailer(G, H, J)
            h[R] = false
        end
    end
    local T = function()
    end
    local U = function()
    end
    tARMA.createArea("trucking_spawn", H, 106, 6, S, T, U, {})
    return R
end
Citizen.CreateThread(function()
    while true do
        local D = PlayerPedId()
        if IsPedInAnyVehicle(D, false) then
            local V = GetEntityCoords(d.trailer)
            local E = GetVehiclePedIsIn(D, false)
            if #(V - GetEntityCoords(E)) <= 9.75 and not IsControlPressed(0, 74) and not IsVehicleAttachedToTrailer(E) and not i then
                AttachVehicleToTrailer(E, d.trailer, 1.0)
            end
        end
        Wait(1000)
    end
end)
Citizen.CreateThread(function()
    while true do
        local D = PlayerPedId()
        if IsPedInAnyVehicle(D, false) then
            local E = GetVehiclePedIsIn(D, false)
            if not IsVehicleAttachedToTrailer(E) and i then
                i = false
            end
        end
        Wait(1500)
    end
end)
function tARMA.isTrailerAttached(W)
    local X = tARMA.getObjectId(W)
    return IsVehicleAttachedToTrailer(X)
end
Citizen.CreateThread(function()
    while true do
        if globalIsDoingTruckRoute then
            if GetVehicleEngineHealth(d.vehicle) < 0.0 or not DoesEntityExist(d.vehicle) then
                TriggerServerEvent("ARMA:endTruckerJob", "Truck was destroyed!")
            end
        end
        Wait(1000)
    end
end)
RegisterNetEvent("ARMA:endTruckerJobCl",function(Y)
    if globalOnTruckJob then
        DeleteEntity(d.trailer)
        DeleteCheckpoint(g.trailer)
        globalIsDoingTruckRoute = false
        globalCurrentJob = {}
        globalJobOnPause = true
        i = false
        j = false
        for L = 1, #h do
            h[L] = false
        end
        CreateScaleform(2, "~r~JOB ENDED!", Y)
        SetBlipRoute(f.job, false)
        RemoveBlip(f.job)
        RemoveBlip(f.trailer)
    end
end)
RegisterNetEvent("ARMA:setTruckJobOnPause",function(Z)
    globalJobOnPause = Z
end)
Citizen.CreateThread(function()
    while not globalJobOnPause do
        if IsEntityAVehicle(d.trailer) then
            local D = PlayerPedId()
            local n = GetEntityCoords(D)
            local V = GetEntityCoords(d.trailer)
            if #(n - V) > 450.0 then
                TriggerServerEvent("ARMA:endTruckerJob", "You left the trailer behind")
            end
        end
        Citizen.Wait(1000)
    end
end)
RegisterNetEvent("ARMA:setParkingSpace",function(_)
    e = _
end)
function payout()
    TriggerServerEvent("ARMA:truckerJobPayout")
end
function salary()
    TriggerServerEvent("ARMA:truckerJobSalary")
end
function startOnTruckerJob()
    TriggerServerEvent("ARMA:giveTruckerGroup")
end
function sequence()
    TriggerServerEvent("ARMA:truckingSequence")
    ExecuteCommand('hideui')
    local a0 = GetRenderingCam()
    local D = tARMA.getPlayerPed()
    local a1 = tARMA.getPlayerCoords()
    SetEntityCoords(D, vector3(856.022, -3188.11, 4.05127))
    SetFocusPosAndVel(862.5825, -3195.493, 6.002151)
    local a2 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", 866.1363, -3191.314, 7.14502, 0.0, 0.0, 0.0, 65.0, 0, 2)
    PointCamAtCoord(a2, 862.5825, -3195.493, 6.002151)
    SetCamActive(a2, true)
    RenderScriptCams(true, true, 0, 1, 0)
    local a3 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", 862.5231, -3190.259, 7.14502, 0.0, 0.0, 0.0, 65.0, 0, 2)
    PointCamAtCoord(a3, 862.5825, -3195.493, 6.002151)
    SetCamActiveWithInterp(a3, a2, 10000, 5, 5)
    drawNativeNotification("This is where you will start your trucking job. You can also come here to end the shift.")
    Wait(10000)
    PointCamAtCoord(a2, vector3(901.9878, -3185.827, 5.898679))
    PointCamAtCoord(a3, vector3(901.9878, -3185.827, 5.898679))
    SetCamCoord(a2, vector3(897.033, -3189.376, 5.892334))
    SetCamCoord(a3, vector3(904.6154, -3189.428, 5.892334))
    SetCamActiveWithInterp(a3, a2, 10000, 5, 5)
    drawNativeNotification("Come here to rent or buy yourself a brand new truck to complete the trucking job with.")
    Wait(10000)
    local a4 = createTrailers()
    PointCamAtCoord(a2, vector3(934.8527, -3154.536, 5.892334))
    PointCamAtCoord(a3, vector3(934.8527, -3154.536, 5.892334))
    SetCamCoord(a2, vector3(886.589, -3165.547, 9.892334))
    SetCamCoord(a3, vector3(975.2308, -3166.602, 9.892334))
    SetCamActiveWithInterp(a3, a2, 25000, 5, 5)
    drawNativeNotification("You will be driving a wide selection of trailers around the city of ARMA!")
    Wait(25000)
    for L = 1, #a4 do
        DeleteEntity(a4[L])
    end
    DestroyCam(a2, 0)
    DestroyCam(a3, 0)
    RenderScriptCams(false, true, 3000, 1, 0)
    ClearFocus()
    FreezeEntityPosition(D, false)
    TriggerServerEvent("ARMA:truckingSequence")
    SetEntityCoords(D, a1)
    ExecuteCommand('showui')
end
local a5 = {
    "trailers",
    "trflat",
    "heli1",
    "tr4",
    "tr3",
    "docktrailer",
    "bvttanker",
    "tanker",
    "tanker2",
    "trailers3",
    "trailers2",
    "ArmyTrailer2",
    "TrailerLogs",
    "militaire1",
    "ArmyTanker",
    "docktrailer",
    "tr3",
    "tr4",
    "bvttanker"
}
function getRandomNum(a6, a7)
    math.randomseed(GetGameTimer())
    return math.random(a6, a7)
end
function createTrailers()
    local a8 = 0
    local a4 = {}
    for L = 1, 19 do
        local X = tARMA.spawnVehicle(a5[L], 896.7 + a8, -3153.494, 5.892334, 177.1, false, false, false)
        FreezeEntityPosition(X, true)
        table.add(a4, X)
        a8 = a8 + 4
    end
    return a4
end
local function a9(n)
    local D = tARMA.getPlayerPed()
    FreezeEntityPosition(D, true)
    cam = CreateCam("DEFAULT_SPLINE_CAMERA", true)
    SetCamCoord(cam, n)
    PointCamAtCoord(cam, n)
    SetCamActive(cam, true)
    RenderScriptCams(1, 0, cam, 0, 0)
end
RegisterCommand("setdonecutscene",function(aa, ab)
    if tARMA.getUserId() == 1 then
        SetResourceKvpInt("arma_trucking_done_cutscene", tonumber(ab[1]))
        print("set arma_trucking_done_cutscene to " .. ab[1])
    end
end)