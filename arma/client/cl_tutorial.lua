local a = false
local b = false
local c = vector3(-1037.3941650391,-2737.4182128906,13.780251502991)
local d = ""
local e = nil
local f = 0
local g = "prop_amb_phone"
local h = 0
local i = "out"
local j = nil
local k = nil
local l = false
local m={['cellphone@']={['out']={['text']='cellphone_text_in',['call']='cellphone_call_listen_base'},['text']={['out']='cellphone_text_out',['text']='cellphone_text_in',['call']='cellphone_text_to_call'},['call']={['out']='cellphone_call_out',['text']='cellphone_call_to_text',['call']='cellphone_text_to_call'}},['anim@cellphone@in_car@ps']={['out']={['text']='cellphone_text_in',['call']='cellphone_call_in'},['text']={['out']='cellphone_text_out',['text']='cellphone_text_in',['call']='cellphone_text_to_call'},['call']={['out']='cellphone_horizontal_exit',['text']='cellphone_call_to_text',['call']='cellphone_text_to_call'}}}
local function n()
    if f ~= 0 then
        Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(f))
        f = 0
    end
end
local function o()
    n()
    tARMA.loadModel(g)
    f = CreateObject(g, 1.0, 1.0, 1.0, 1, 1, 0)
    local p = GetPedBoneIndex(PlayerPedId(), 28422)
    AttachEntityToEntity(f, PlayerPedId(), p, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
end
local function q(r, s, t)
    if i == r and t ~= true then
        return
    end
    e = PlayerPedId()
    local s = s or false
    local u = "cellphone@"
    if IsPedInAnyVehicle(e, false) then
        u = "anim@cellphone@in_car@ps"
    end
    tARMA.loadAnimDict(u)
    local v = m[u][i][r]
    if i ~= "out" then
        StopAnimTask(e, j, k, 1.0)
    end
    local w = 50
    if s == true then
        w = 14
    end
    TaskPlayAnim(e, u, v, 3.0, -1, -1, w, 0, false, false, false)
    if r ~= "out" and i == "out" then
        Citizen.Wait(380)
        o()
    end
    j = u
    k = v
    l = s
    i = r
    if r == "out" then
        Citizen.Wait(180)
        n()
        StopAnimTask(e, j, k, 1.0)
    end
end

RegisterCommand("tutorial",function()
    initializeTutorial()
end)

Citizen.CreateThread(function()
    if true then 
        Wait(10000)
        TriggerServerEvent("ARMA:checkTutorial")
    end 
end)

RegisterNetEvent("ARMA:startTutorial")
AddEventHandler("ARMA:startTutorial",function()
    h = 1
    DoScreenFadeOut(500)
    NetworkFadeOutEntity(PlayerPedId(), true, false)
    Wait(5000)
    SetEntityCoords(PlayerPedId(), -1035.9837646484,-2733.5810546875,13.756638526917)
    SetEntityHeading(PlayerPedId(), 146.0)
    NetworkFadeInEntity(PlayerPedId(), 0)
    DoScreenFadeIn(3000)
    initializeTutorial()
end)

function initializeTutorial()
    local z = tARMA.addMarker(c.x, c.y, c.z, 1.0, 1.0, 1.0, 50, 205, 50, 150, 50, 32, false, false, true)
    local A = GetEntityCoords(PlayerPedId())
    local B = #(c - A)
    while B > 5.0 do
        B = #(c - GetEntityCoords(PlayerPedId()))
        Wait(100)
    end
    a = true
    initializeTutorialScaleform()
    while not b do
        B = #(c - GetEntityCoords(PlayerPedId()))
        if B < 3.0 then
            a = true
        else
            a = false
        end
        Wait(100)
    end
end

Citizen.CreateThread(function()
    while true do
        if a then
            if IsControlJustPressed(0, 38) then
                a = false
                b = true
                beginTutorial()
            end
        end
        if h == 1 then
            local C = PlayerPedId()
            tARMA.setWeapon(C, "WEAPON_UNARMED", true)
        end
        Wait(0)
    end
end)
Citizen.CreateThread(function()
    while true do
        if b then
            tARMA.drawTxt(d, 7, 1, 0.5, 0.8, 0.6, 50, 205, 50, 205)
        end
        Citizen.Wait(0)
    end
end)

function initializeTutorialScaleform()
    Citizen.CreateThread(function()
        function Initialize(scaleform)
            local scaleform = RequestScaleformMovie(scaleform)
            while not HasScaleformMovieLoaded(scaleform) do
                Citizen.Wait(0)
            end
            BeginScaleformMovieMethod(scaleform, "SET_MISSION_INFO")
            ScaleformMovieMethodAddParamTextureNameString("ARMA Tutorial")
            ScaleformMovieMethodAddParamTextureNameString("~g~Welcome to ARMA Roleplay")
            ScaleformMovieMethodAddParamTextureNameString("")
            ScaleformMovieMethodAddParamTextureNameString("")
            ScaleformMovieMethodAddParamTextureNameString("")
            ScaleformMovieMethodAddParamTextureNameString("")
            ScaleformMovieMethodAddParamTextureNameString("")
            ScaleformMovieMethodAddParamTextureNameString("")
            ScaleformMovieMethodAddParamTextureNameString("")
            ScaleformMovieMethodAddParamTextureNameString("~g~Press [E] begin!")
            EndScaleformMovieMethod()
            return scaleform
        end
        scaleform = Initialize("mp_mission_name_freemode")
        while true do
            if not b and a then
                local D = 0.5
                local E = 0.35
                local F = 0.3
                local G = F / 0.65
                DrawScaleformMovie(scaleform, D, E, F, G)
            end
            Wait(0)
        end
    end)
end

function initializeEndTutorial()
    Citizen.CreateThread(function()
        function Initialize(scaleform)
            local scaleform=RequestScaleformMovie(scaleform)
            while not HasScaleformMovieLoaded(scaleform)do 
                Citizen.Wait(0)
            end
            PushScaleformMovieFunction(scaleform,"SET_MISSION_INFO")
            PushScaleformMovieFunctionParameterString("Press F1 for a quick starter guide and the rules to our server!")
            PushScaleformMovieFunctionParameterString("~g~Tutorial Complete")
            PushScaleformMovieFunctionParameterString("")
            PushScaleformMovieFunctionParameterString("")
            PushScaleformMovieFunctionParameterString("")
            PushScaleformMovieFunctionParameterString("")
            PushScaleformMovieFunctionParameterString("")
            PushScaleformMovieFunctionParameterString("")
            PushScaleformMovieFunctionParameterString("")
            PushScaleformMovieFunctionParameterString("")
            PopScaleformMovieFunctionVoid()
            return scaleform 
        end
        scaleform=Initialize("mp_mission_name_freemode")
        while b do 
            local D=0.5
            local E=0.35
            local F=0.3
            local G=F/0.65
            DrawScaleformMovie(scaleform,D,E,F,G)
            Wait(0)
        end 
    end)
end

function beginTutorial()
    TriggerEvent("arma:PlaySound", "ring")
    Wait(2000)
    q("text")
    Wait(6000)
    q("call")
    TriggerEvent("arma:PlaySound", "herewegoagain")
    Wait(7000)
    q("out")
    tARMA.announceClient("Please follow the blue markers!")
    cc1 = CreateCheckpoint(1,-1040.8200683594,-2742.2243652344,12.5,-1054.2639160156,-2766.0249023438,3.0,2.0,1,167,204,100,0)
    d = "Yo welcome brother Im CJ and Im gonna help you settle in"
    local H = 20
    while H >= 3 do
        plyCoords = GetEntityCoords(PlayerPedId(), false)
        H = #(plyCoords - vector3(-1040.8200683594, -2742.2243652344, 12.5))
        Wait(100)
    end
    DeleteCheckpoint(cc1)
    cc2 = CreateCheckpoint(1,-1054.2639160156,-2766.0249023438,3.0,-1032.3704833984,-2773.8217773438,3.0,2.0,1,167,204,100,0)
    d = "You are at Heathrow Airport make your way to the tube station and get on the damn tube"
    H = 20
    while H >= 3 do
        plyCoords = GetEntityCoords(PlayerPedId(), false)
        H = #(plyCoords - vector3(-1054.2639160156, -2766.0249023438, 3.0))
        Wait(100)
    end
    DeleteCheckpoint(cc2)
    cc3 = CreateCheckpoint(1,-1032.3704833984,-2773.8217773438,3.0,-1014.4043579102,-2752.3588867188,-0.5,2.0,1,167,204,100,0)
    d = "You can get your phone up by pressing [K] and close it with [BACKSPACE]"
    H = 20
    while H >= 3 do
        plyCoords = GetEntityCoords(PlayerPedId(), false)
        H = #(plyCoords - vector3(-1032.3704833984, -2773.8217773438, 3.0))
        Wait(100)
    end
    DeleteCheckpoint(cc3)
    cc4 = CreateCheckpoint(1,-1014.4043579102,-2752.3588867188,-0.5,-1061.8685302734,-2717.7609863282,-0.5,2.0,1,167,204,100,0)
    d = "You can open your Inventory with [L] and close it with [L]"
    H = 20
    while H >= 3 do
        plyCoords = GetEntityCoords(PlayerPedId(), false)
        H = #(plyCoords - vector3(-1014.4043579102, -2752.3588867188, -0.5))
        Wait(100)
    end
    DeleteCheckpoint(cc4)
    cc5 = CreateCheckpoint(1,-1061.8685302734,-2717.7609863282,-0.5,-1075.8397216796,-2728.1538085938,-0.5,2.0,1,167,204,100,0)
    d = "Follow the markers to get on the damn tube!"
    H = 20
    while H >= 3 do
        plyCoords = GetEntityCoords(PlayerPedId(), false)
        H = #(plyCoords - vector3(-1061.8685302734, -2717.7609863282, -0.5))
        Wait(100)
    end
    DeleteCheckpoint(cc5)
    cc6 = CreateCheckpoint(1,-1075.8397216796,-2728.1538085938,-0.5,-1080.8995361328,-2715.8703613282,-0.5,2.0,1,167,204,100,0)
    d = ""
    TriggerEvent("arma:PlaySound", "tubearriving")
    H = 20
    while H >= 3 do
        plyCoords = GetEntityCoords(PlayerPedId(), false)
        H = #(plyCoords - vector3(-1075.8397216796, -2728.1538085938, -0.5))
        Wait(100)
    end
    DeleteCheckpoint(cc6)
    cc7 = CreateCheckpoint(1,-1080.8995361328,-2715.8703613282,-0.5,-1063.7435302734,-2699.1303710938,-9.4100732803344,2.0,1,167,204,100,0)
    d = "Hurry up fool!"
    H = 20
    while H >= 3 do
        plyCoords = GetEntityCoords(PlayerPedId(), false)
        H = #(plyCoords - vector3(-1080.8995361328, -2715.8703613282, -0.5))
        Wait(100)
    end
    DeleteCheckpoint(cc7)
    cc8 = CreateCheckpoint(45,-1063.7435302734,-2699.1303710938,-8.4100732803344,-1063.7435302734,-2699.1303710938,-8.4100732803344,2.0,1,167,204,100,0)
    d = ""
    H = 20
    while H >= 3 do
        plyCoords = GetEntityCoords(PlayerPedId(), false)
        H = #(plyCoords - vector3(-1063.7435302734, -2699.1303710938, -9.4100732803344))
        Wait(100)
    end
    DeleteCheckpoint(cc8)
    TriggerEvent("arma:PlaySound", "tubeleaving")
    DoScreenFadeOut(2000)
    NetworkFadeOutEntity(PlayerPedId(), true, false)
    Wait(5000)
    SetEntityCoords(PlayerPedId(), 99.8304977417, -1711.280883789, 30.113786697388)
    SetEntityHeading(PlayerPedId(), 200.0)
    NetworkFadeInEntity(PlayerPedId(), 0)
    TriggerEvent("arma:PlaySound", "tubearriving")
    DoScreenFadeIn(3000)
    d = "I called a taxi for you"
    Wait(2000)
    local I = tARMA.loadModel("taxi")
    d = "Oh shit looks like he had to run It should be parked pretty close"
    Wait(5000)
    d = "Get in the taxi and make your way to the Job Centre a waypoint has been set on your GPS"
    SetTimeout(5000,function()
        d = ""
    end)
    math.randomseed(GetGameTimer())
    math.random()
    math.random()
    math.random()
    local J = math.random(1, 7)
    if J == 1 then
        tempTaxi = CreateVehicle(I, 95.41603088379, -1727.3582763672, 28.85818862915, 50, 1, 0)
        cc7 = CreateCheckpoint(1,95.41603088379,-1727.3582763672,28.85818862915,-515.47406005859,-264.78549194336,34.403575897217,2.0,1,167,204,100,0)
    elseif J == 2 then
        tempTaxi = CreateVehicle(I, 94.067138671875, -1740.6694335938, 29.305875778198, 320, 1, 0)
        cc7 = CreateCheckpoint(1,94.067138671875,-1740.6694335938,28.305875778198,-515.47406005859,-264.78549194336,34.403575897217,2.0,1,167,204,100,0)
    elseif J == 3 then
        tempTaxi = CreateVehicle(I, 96.752075195312, -1745.4302978516, 29.315612792968, 320, 1, 0)
        cc7 = CreateCheckpoint(1,96.752075195312,-1745.4302978516,28.315612792968,-515.47406005859,-264.78549194336,34.403575897217,2.0,1,167,204,100,0)
    elseif J == 4 then
        tempTaxi = CreateVehicle(I, 103.90421295166, -1751.818359375, 29.321237564086, 320, 1, 0)
        cc7 = CreateCheckpoint(1,103.90421295166,-1751.818359375,28.321237564086,-515.47406005859,-264.78549194336,34.403575897217,2.0,1,167,204,100,0)
    elseif J == 5 then
        tempTaxi = CreateVehicle(I, 108.07794952392, -1756.5098876954, 29.360332489014, 320, 1, 0)
        cc7 = CreateCheckpoint(1,108.07794952392,-1756.5098876954,28.360332489014,-515.47406005859,-264.78549194336,34.403575897217,2.0,1,167,204,100,0)
    elseif J == 6 then
        tempTaxi = CreateVehicle(I, 111.3772354126, -1740.8269042968, 28.854513168334, 50, 1, 0)
        cc7 = CreateCheckpoint(1,111.3772354126,-1740.8269042968,28.854513168334,-515.47406005859,-264.78549194336,34.403575897217,2.0,1,167,204,100,0)
    elseif J == 7 then
        tempTaxi = CreateVehicle(I, 97.749137878418, -1728.8994140625, 28.873386383056, 50, 1, 0)
        cc7 = CreateCheckpoint(1,97.749137878418,-1728.8994140625,28.873386383056,-515.47406005859,-264.78549194336,34.403575897217,2.0,1,167,204,100,0)
    end
    SetModelAsNoLongerNeeded(I)
    while GetVehiclePedIsIn(PlayerPedId()) ~= tempTaxi do
        Wait(100)
    end
    DeleteCheckpoint(cc7)
    BLIP_1 = AddBlipForCoord(-515.47406005859, -264.78549194336, 35.403575897217)
    SetBlipSprite(BLIP_1, 50)
    SetBlipAlpha(BLIP_1, 0)
    SetBlipRoute(BLIP_1, true)
    cc9 = CreateCheckpoint(45,-515.47406005859,-264.78549194336,34.403575897217,-542.36938476563,-207.75384521484,36.649753570557,2.0,1,167,204,100,0)
    d = "Make your way inside the City Hall and explore!"
    H = 20
    while H >= 5 do
        plyCoords = GetEntityCoords(PlayerPedId(), false)
        H = #(plyCoords - vector3(-515.47406005859, -264.78549194336, 35.403575897217))
        Wait(100)
    end
    DeleteCheckpoint(cc9)
    DeleteVehicle(GetVehiclePedIsIn(tARMA.getPlayerPed(), false))
    cc10 = CreateCheckpoint(45,-542.36938476563,-207.75384521484,36.649753570557,-542.36938476563,-207.75384521484,36.649753570557,2.0,1,167,204,100,0)
    d = "Aite got some ballas to kill see you around"
    H = 20
    while H >= 5 do
        plyCoords = GetEntityCoords(PlayerPedId(), false)
        H = #(plyCoords - vector3(-542.36938476563, -207.75384521484, 36.649753570557))
        Wait(100)
    end
    DeleteCheckpoint(cc10)
    SetBlipRoute(BLIP_1, false)
    Citizen.CreateThread(function()
        Wait(5000)
        TriggerEvent("arma:PlaySound", "questcomplete")
        d = ""
        for K = 1, 700 do
            Wait(0)
            tARMA.drawTxt("Tutorial Complete", 2, 1, 0.5, 0.8, 2.5, 255, 255, 0, 255)
        end
        initializeEndTutorial()
        Wait(7000)
        b = false
    end)
    TriggerServerEvent("ARMA:setCompletedTutorial")
    h = 2
end

function HelpText(L)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(L)
    EndTextCommandDisplayHelp(100, 0, 0, -1)
end