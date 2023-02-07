currentEvent = {
    players = {},
    isActive = false,
    data = {},
    eventId = 0,
    eventName = "",
    drawPlayersTimeBar = true,
    musicString = "",
    playMusic = false
}
local a = {}
local b = {start = {}, cleanup = {}}
local c = nil
local d = false
local e = 0
local f = false
isDoingSequence = false
RMenu.Add("armaevents","main",RageUI.CreateMenu("", "Event Menu", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "arma_events", "arma_events"))
RMenu.Add("armaevents","categoryInfo",RageUI.CreateSubMenu(RMenu:Get("armaevents", "main"),"","Category",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"arma_events","arma_events"))
RMenu.Add("armaevents","secondary",RageUI.CreateSubMenu(RMenu:Get("armaevents", "main"),"","Event Menu",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"arma_events","arma_events"))
RMenu.Add("armaevents","players",RageUI.CreateMenu("", "Players", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "arma_events", "arma_events"))
RMenu.Add("armaevents","players2",RageUI.CreateMenu("", "Players", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "arma_events", "arma_events"))
RMenu.Add("armaevents","client",RageUI.CreateMenu("", "ARMA Events", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "arma_events", "arma_events"))
local function g()
    return tARMA.isDev() or tARMA.getStaffLevel() >= 6
end
RegisterCommand("eventmenu",function()
    if g() then
        if currentEvent.isManager == true then
            RageUI.ActuallyCloseAll()
            RageUI.Visible(RMenu:Get("armaevents", "players"), true)
        else
            if RageUI.Visible(RMenu:Get("armaevents", "main")) then
                RageUI.ActuallyCloseAll()
            else
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("armaevents", "main"), true)
            end
        end
    end
end,false)
local function h(i)
    RageUI.ButtonWithStyle(i.name,nil,{RightLabel = "→→→"},true,function(j, k, l)
        if l then
            RMenu:Get("armaevents", "secondary").MetaData = i
        end
    end,RMenu:Get("armaevents", "secondary"))
end
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('armaevents', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GetGameTimer() - e > 1000 then
                TriggerServerEvent("ARMA:requestIsAnyEventActive")
                e = GetGameTimer()
            end
            if f then
                RageUI.Separator("~g~There is an event currently running.")
            else
                RageUI.Separator("~r~There are no events currently running.")
            end
            for m, n in pairs(a) do
                if table.count(n) > 1 then
                    RageUI.ButtonWithStyle(m,nil,{RightLabel = "→→→"},true,function(j, k, l)
                        if l then
                            c = m
                        end
                    end,RMenu:Get("armaevents", "categoryInfo"))
                else
                    for o, i in pairs(n) do
                        h(i)
                    end
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('armaevents', 'categoryInfo')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            local q = sortAlphabetically(a[c])
            for r = 1, #q do
                local i = q[r].value
                h(i)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('armaevents', 'secondary')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if type(p.menuitems) == "function" then
                p.menuitems()
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('armaevents', 'players')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Checkbox("Toggle Event Music","",currentEvent.playMusic,{Style = RageUI.CheckboxStyle.Car},function(j, l, k, s)
                currentEvent.playMusic = s
                if l then
                    if currentEvent.playMusic then
                        TriggerMusicEvent(currentEvent.musicString)
                    else
                        TriggerMusicEvent("BST_STOP")
                    end
                end
            end)
            RageUI.Separator("~y~Admin Options")
            RageUI.ButtonWithStyle("Start Event","This, well it'll start the event.",{RightLabel = "→→→"},true,function(j, k, l)
                if l then
                    TriggerServerEvent("ARMA:startEventFully", currentEvent.eventId)
                    RageUI.ActuallyCloseAll()
                end
            end)
            RageUI.ButtonWithStyle("Cancel Event",nil,{RightLabel = "→→→"},true,function(j, k, l)
                if l then
                    TriggerServerEvent("ARMA:cancelEvent", currentEvent.eventId)
                    RageUI.ActuallyCloseAll()
                end
            end)
            RageUI.Separator("~y~Players")
            for t, u in pairs(currentEvent.players) do
                RageUI.ButtonWithStyle(string.format("[%s] %s", u.source, u.name),string.format("Name: %s Temp ID: %s Perm ID: %s", u.name, u.source, u.user_id),{RightLabel = "→→→"},true,function(j, k, l)
                    if l then
                        RMenu:Get("armaevents", "players2").MetaData = u
                    end
                end,RMenu:Get("armaevents", "players2"))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('armaevents', 'players2')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Kick Player From Event",nil,{RightLabel = "→→→"},true,function(j, k, l)
                if l then
                    TriggerServerEvent("ARMA:kickPlayerFromEvent", p.source, currentEvent.eventId)
                end
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('armaevents', 'client')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Leave Event",nil,{RightLabel = "→→→"},true,function(j, k, l)
                if l then
                    ExecuteCommand("leaveevent")
                end
            end)
            RageUI.Checkbox("Toggle Event Music","",currentEvent.playMusic,{Style = RageUI.CheckboxStyle.Car},function(j, l, k, s)
                currentEvent.playMusic = s
                if l then
                    if currentEvent.playMusic then
                        TriggerMusicEvent(currentEvent.musicString)
                    else
                        TriggerMusicEvent("BST_STOP")
                    end
                end
            end)
            RageUI.Separator("~y~Players")
            for t, u in pairs(currentEvent.players) do
                RageUI.ButtonWithStyle(string.format("[%s] %s", u.source, u.name),string.format("Name: %s Temp ID: %s Perm ID: %s", u.name, u.source, u.user_id),{RightLabel = "→→→"},true,function()
                end)
            end
        end)
    end
end)


function tARMA.registerEventMenuItem(v, w, x)
    if not a[v] then
        a[v] = {}
    end
    a[v][w] = {name = w, menuitems = x}
end
function tARMA.registerEventFullStartHandler(y, z)
    b.start[y] = z
end
function tARMA.registerEventCleanupHandler(y, z)
    b.cleanup[y] = z
end
local function A(B)
    tARMA.removeBlipsForPlayer(B)
    tARMA.removePlayerFromLeaderboard(B.source)
end
RegisterNetEvent("ARMA:syncPlayers",function(C, D)
    for o, E in pairs(currentEvent.players) do
        local F = true
        for o, B in pairs(C) do
            if E.source == B.source then
                F = false
                break
            end
        end
        if F then
            A(E)
        end
    end
    currentEvent.players = C
    currentEvent.eventId = D
end)
RegisterNetEvent("ARMA:addEventPlayer",function(B)
    table.add(currentEvent.players, B)
end)
RegisterNetEvent("ARMA:removeEventPlayer",function(B)
    for G, H in pairs(currentEvent.players) do
        if H.source == B.source then
            A(B)
            table.remove(currentEvent.players, G)
        end
    end
end)
RegisterNetEvent("ARMA:startHostEventMenu",function()
    currentEvent.isManager = true
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("armaevents", "players"), true)
end)
local I = 0
local J = 0
local function K()
    if isDoingSequence then
        local L = tARMA.getPlayerPed()
        SetEntityVisible(L, false, false)
        SetFocusPosAndVel(vector3(-77.84175, -1104.633, 33.12158))
        I = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA",-77.84175,-1104.633,33.12158,0.0,0.0,0.0,65.0,false,2)
        PointCamAtCoord(I, -45.73187, -1097.881, 26.41541)
        SetCamActive(I, true)
        RenderScriptCams(true, true, 0, true, false)
        J = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA",-45.2044,-1128.317,33.12158,0.0,0.0,0.0,65.0,false,2)
        PointCamAtCoord(J, -45.73187, -1097.881, 26.41541)
        SetCamActiveWithInterp(J, I, 10000, 5, 5)
        Wait(10000)
        if isDoingSequence then
            ClearFocus()
            SetCamCoord(I, vector3(177.9429, -901.3582, 46.75317))
            SetCamCoord(J, vector3(178.9451, -991.0022, 47.74731))
            SetFocusPosAndVel(vector3(177.9429, -901.3582, 46.75317))
            PointCamAtCoord(I, 195.1253, -933.7582, 30.67834)
            PointCamAtCoord(J, 195.1253, -933.7582, 30.67834)
            SetCamActiveWithInterp(J, I, 25000, 5, 5)
            Wait(25000)
        end
        if isDoingSequence then
            ClearFocus()
            SetCamCoord(I, vector3(-3135.257, 1042.998, 30.15601))
            SetCamCoord(J, vector3(-3123.837, 1133.525, 30.15601))
            SetFocusPosAndVel(vector3(-3147.073, 1088.374, 20.6864))
            PointCamAtCoord(I, -3147.073, 1088.374, 20.6864)
            PointCamAtCoord(J, -3147.073, 1088.374, 20.6864)
            SetCamActiveWithInterp(J, I, 15000, 5, 5)
            Wait(15000)
        end
        if isDoingSequence then
            ClearFocus()
            SetCamCoord(I, vector3(598.4967, 1122.923, 364.2878))
            SetCamCoord(J, vector3(819.7582, 1057.543, 364.2878))
            SetFocusPosAndVel(vector3(732.5406, 1195.807, 326.359))
            PointCamAtCoord(I, 732.5406, 1195.807, 326.359)
            PointCamAtCoord(J, 732.5406, 1195.807, 326.359)
            SetCamActiveWithInterp(J, I, 35000, 5, 5)
            Wait(35000)
        end
        if isDoingSequence then
            ClearFocus()
            SetCamCoord(I, vector3(1658.914, 2526.369, 69.68567))
            SetCamCoord(J, vector3(1751.934, 2507.947, 69.68567))
            SetFocusPosAndVel(vector3(1708.629, 2547.943, 45.55676))
            PointCamAtCoord(I, 1708.629, 2547.943, 45.55676)
            PointCamAtCoord(J, 1708.629, 2547.943, 45.55676)
            SetCamActiveWithInterp(J, I, 35000, 5, 5)
            Wait(35000)
        end
        if isDoingSequence then
            ClearFocus()
            SetCamCoord(I, vector3(1545.191, 6444.29, 35.64905))
            SetCamCoord(J, vector3(1608.475, 6413.301, 35.64905))
            SetFocusPosAndVel(vector3(1588.536, 6456.923, 29.27991))
            PointCamAtCoord(I, 1588.536, 6456.923, 29.27991)
            PointCamAtCoord(J, 1588.536, 6456.923, 29.27991)
            SetCamActiveWithInterp(J, I, 20000, 5, 5)
            Wait(20000)
        end
        if isDoingSequence then
            ClearFocus()
            SetCamCoord(I, vector3(-134.1758, -834.0527, 321.186))
            SetCamCoord(J, vector3(-37.60879, -882.6725, 321.186))
            SetFocusPosAndVel(vector3(-73.8989, -817.5824, 319.4843))
            PointCamAtCoord(I, -73.8989, -817.5824, 319.4843)
            PointCamAtCoord(J, -73.8989, -817.5824, 319.4843)
            SetCamActiveWithInterp(J, I, 25000, 5, 5)
            Wait(25000)
        end
        K()
    end
end
function tARMA.stopEventSequence(M)
    RageUI.ActuallyCloseAll()
    isDoingSequence = false
    DestroyCam(I, false)
    DestroyCam(J, false)
    if M == nil or M == true then
        RenderScriptCams(false, true, 0, true, false)
    else
        RenderScriptCams(false, false, 0, true, false)
    end
    ClearFocus()
    FreezeEntityPosition(tARMA.getPlayerPed(), false)
    local L = tARMA.getPlayerPed()
    SetEntityVisible(L, true, true)
end
RegisterNetEvent("ARMA:startEventSequence",function()
    isDoingSequence = true
    K()
end)
RegisterNetEvent("ARMA:startEventFully",function(p)
    globalDisableVehicleFailure = true
    currentEvent.data = p
    currentEvent.isActive = true
    tARMA.setGreenzonesDisabled(true)
    RageUI.Visible(RMenu:Get("armaevents", "client"), false)
end)
local N = "..."
Citizen.CreateThread(function()
    while true do
        if isDoingSequence then
            drawNativeText("~g~Waiting for event to start" .. N)
            drawNativeNotification("The command /leaveevent can be used at any time to return back to the main world.")
            if not RageUI.Visible(RMenu:Get("armaevents", "client")) and not currentEvent.isManager then
                RageUI.Visible(RMenu:Get("armaevents", "client"), true)
            elseif not RageUI.Visible(RMenu:Get("armaevents", "players")) and currentEvent.isManager then
                RageUI.Visible(RMenu:Get("armaevents", "players"), true)
            end
        end
        if currentEvent.isActive and currentEvent.drawPlayersTimeBar then
            DrawGTATimerBar("~y~PLAYERS:", #currentEvent.players, 1)
            tARMA.setWeather("EXTRASUNNY")
        end
        Wait(0)
    end
end)
Citizen.CreateThread(function()
    while true do
        if isDoingSequence then
            if N == "..." then
                N = "."
            else
                N = N .. "."
            end
        end
        Wait(500)
    end
end)
RegisterNetEvent("ARMA:eventCleanup",function(D, O, P, Q)
    tARMA.stopEventSequence()
    RageUI.Visible(RMenu:Get("armaevents", "client"), false)
    if b.cleanup[O] then
        b.cleanup[O]()
    end
    globalDisableVehicleFailure = false
    tARMA.endVehicleSelection()
    tARMA.setEventSpectatorMode(false)
    tARMA.clearEventBounds()
    tARMA.enableEventPlayerBlips(false)
    tARMA.enableEventPlayerTags(false, false)
    tARMA.setGreenzonesDisabled(false)
    tARMA.setPlayerCanOpenLeaderboard(false)
    tARMA.clearLeaderboardData()
    if P and Q then
        tARMA.podiumLeaderboard(P, Q)
    elseif tARMA.isPodiumDrawing() then
        tARMA.callCancelPodium()
    end
    currentEvent = {
        players = {},
        isActive = false,
        data = {},
        eventId = 0,
        drawPlayersTimeBar = true,
        isManager = false,
        musicString = "",
        playMusic = false
    }
    d = true
    Citizen.Wait(5000)
    d = false
end)
function tARMA.setPlayerInvisible(R)
    local S = PlayerPedId()
    FreezeEntityPosition(S, R)
    SetEntityInvincible(S, R)
    SetEntityVisible(S, not R, not R)
end
RegisterNetEvent("ARMA:announceEventJoinable",function(O, T)
    if tARMA.getPlayerCombatTimer() == 0 and not tARMA.getHideEventAnnouncementFlag() and not tARMA.isInTutorial() then
        PlaySound(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", false, 0, true)
        tARMA.announceMpBigMsg("~b~" .. O .. " event has started!","/joinevent to enter, Win £500,000! - " .. tostring(T) .. " slots available.",15000)
    end
end)
function tARMA.announceMpBigMsg(U, V, W, X, Y)
    if X then
        local Z = GetSoundId()
        PlaySoundFrontend(Z, "Checkpoint_Teammate", "GTAO_Shepherd_Sounds", false)
        ReleaseSoundId(Z)
    end
    local _ = Scaleform("MP_BIG_MESSAGE_FREEMODE")
    _.RunFunction("SHOW_SHARD_WASTED_MP_MESSAGE", {U, V, 0, false, false})
    if Y then
        CreateThread(function()
            local a0 = false
            SetTimeout(W,function()
                a0 = true
            end)
            while not a0 do
                _.Render2D()
                Wait(0)
            end
        end)
    else
        local a0 = false
        SetTimeout(W,function()
            a0 = true
        end)
        while not a0 do
            _.Render2D()
            Wait(0)
        end
    end
end
RegisterNetEvent("ARMA:announceMpBigMsg", tARMA.announceMpBigMsg)
function tARMA.setEventMusic(a1)
    currentEvent.playMusic = true
    currentEvent.musicString = a1
    TriggerMusicEvent(a1)
end
function tARMA.getActiveEventPlayers()
    local a2 = {}
    for o, B in pairs(currentEvent.players) do
        if B.active then
            table.insert(a2, B)
        end
    end
    return a2
end
function tARMA.getEventLocalPlayer()
    local a3 = GetPlayerServerId(PlayerId())
    for o, a4 in pairs(currentEvent.players) do
        if a4.source == a3 then
            return a4
        end
    end
end
function tARMA.getEventPlayerFromSrc(a5)
    for o, a4 in pairs(currentEvent.players) do
        if a4.source == a5 then
            return a4
        end
    end
end
RegisterNetEvent("ARMA:updatePlayerActive",function(a6, a7)
    if currentEvent.players[a6] then
        currentEvent.players[a6].active = a7
    end
end)
function tARMA.showCountdownTimer(a8)
    showingscaleform = true
    local a9 = -1
    local aa = -1
    local a8 = a8
    local ab = a8 + 1
    local ac = 255
    local ad = 0
    Citizen.CreateThread(function()
        while showingscaleform do
            if ab ~= -1 then
                ab = ab - 1
            end
            if ab > 0 then
                PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
            end
            if ab == 0 then
                PlaySoundFrontend(-1, "GO", "HUD_MINI_GAME_SOUNDSET", 1)
            end
            Citizen.Wait(1000)
        end
    end)
    local ae = Scaleform("COUNTDOWN")
    Citizen.CreateThread(function()
        while showingscaleform do
            if ab ~= -1 then
                if ab == 0 then
                    ae.RunFunction("SET_MESSAGE", {"CNTDWN_GO", 0, 255, 0, true, false})
                elseif ab > 0 then
                    if ab >= a8 / 2 then
                        ad = math.floor(510 * (1 - a9 / aa))
                    elseif ab < a8 / 2 then
                        ac = math.floor(510 * a9 / aa)
                    end
                    ae.RunFunction("SET_MESSAGE", {tostring(ab), ac, ad, 0, true, false})
                end
                ae.Render2D()
            end
            Wait(0)
        end
    end)
    while ab ~= -1 do
        Citizen.Wait(1.0)
    end
    showingscaleform = false
end
function tARMA.setEventBounds(af)
    if af and table.count(af) ~= 0 then
        currentEvent.bounds = af
    end
end
function tARMA.clearEventBounds()
    currentEvent.bounds = nil
end
local function ag(ah)
    if currentEvent.bounds then
        for r, ai in ipairs(currentEvent.bounds) do
            if table.count(ai) == 2 then
                if not IsEntityInArea(ah, ai[1].x, ai[1].y, ai[1].z, ai[2].x, ai[2].y, ai[2].z, false, true, 0) then
                    return true
                end
            end
        end
    end
    return false
end
Citizen.CreateThread(function()
    while true do
        if currentEvent.bounds and tARMA.getEventLocalPlayer() and tARMA.getEventLocalPlayer().active and not tARMA.isSpectatingEvent() then
            if GetEntityHealth(PlayerPedId()) > 0 then
                if ag(PlayerPedId()) then
                    local aj = GetGameTimer()
                    local ak = 5
                    AnimpostfxPlay("MP_race_crash", 5000, false)
                    local Z = GetSoundId()
                    PlaySound(Z, "OOB_Timer_Dynamic", "GTAO_FM_Events_Soundset", false)
                    ReleaseSoundId(Z)
                    while ag(PlayerPedId()) and GetGameTimer() - aj < 5000 do
                        tARMA.announceMpBigMsg("~r~Out Of Bounds~w~","Return to the minigame within " .. ak .. " seconds or you will explode.",1000)
                        ak = ak - 1
                    end
                    AnimpostfxStopAll()
                    StopSound(Z)
                    if ag(PlayerPedId()) then
                        local al = GetEntityCoords(PlayerPedId(), true)
                        AddExplosion(al.x, al.y, al.z, 1, 1.0, true, false, 1.0)
                        SetEntityHealth(PlayerPedId(), 0)
                        Wait(10000)
                    else
                        Wait(200)
                        PlaySound(-1, "OOB_Cancel", "GTAO_FM_Events_Soundset", false)
                    end
                end
            end
        end
        Citizen.Wait(1000)
    end
end)
local function am(an)
    tARMA.loadPtfx("proj_indep_firework")
    tARMA.loadPtfx("proj_indep_firework_v2")
    UseParticleFxAsset("proj_indep_firework")
    UseParticleFxAsset("proj_indep_firework_v2")
    CreateThread(function()
        for r = 1, 5 do
            if r % 2 == 0 then
                UseParticleFxAsset("proj_indep_firework_v2")
                local ao = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb",an,0.0,0.0,0.0,1.0,false,false,false,false)
            else
                UseParticleFxAsset("proj_indep_firework")
                local ao = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst",an,0.0,0.0,0.0,1.0,false,false,false,false)
            end
            Wait(1000)
        end
    end)
    tARMA.loadPtfx("scr_indep_fireworks")
    UseParticleFxAsset("scr_indep_fireworks")
    CreateThread(function()
        for r = 1, 5 do
            UseParticleFxAsset("scr_indep_fireworks")
            local ao = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst",an,0.0,0.0,0.0,1.0,false,false,false,false)
            Wait(1000)
        end
    end)
end
local ap = {
    vector4(683.82855224609, 570.56701660156, 130.44616699219, 155.0),
    vector4(682.49670410156, 571.10766601562, 130.44616699219, 155.0),
    vector4(685.51647949219, 570.01318359375, 130.44616699219, 155.0),
    vector4(687.23077392578, 569.41979980469, 130.44616699219, 155.0),
    vector4(681.44177246094, 571.45056152344, 130.44616699219, 155.0),
    vector4(680.21539306641, 573.54724121094, 130.44616699219, 155.0),
    vector4(681.73187255859, 573.17803955078, 130.44616699219, 155.0),
    vector4(683.34063720703, 572.57141113281, 130.44616699219, 155.0),
    vector4(685.09448242188, 571.8857421875, 130.44616699219, 155.0),
    vector4(687.23077392578, 571.39782714844, 130.44616699219, 155.0),
    vector4(689.23516845703, 570.89672851562, 130.44616699219, 155.0),
    vector4(690.96264648438, 571.43737792969, 130.44616699219, 155.0),
    vector4(689.63079833984, 572.94067382812, 130.44616699219, 155.0),
    vector4(687.74505615234, 573.69232177734, 130.44616699219, 155.0),
    vector4(686.10986328125, 574.33843994141, 130.44616699219, 155.0),
    vector4(682.44396972656, 575.78900146484, 130.44616699219, 155.0),
    vector4(680.14947509766, 572.00439453125, 130.44616699219, 155.0),
    vector4(678.93627929688, 572.57141113281, 130.44616699219, 155.0),
    vector4(679.23956298828, 573.876953125, 130.44616699219, 155.0),
    vector4(686.22857666016, 571.75384521484, 130.44616699219, 155.0),
    vector4(688.29888916016, 571.06811523438, 130.44616699219, 155.0),
    vector4(688.57580566406, 568.95825195312, 130.44616699219, 155.0),
    vector4(690.54064941406, 570.19781494141, 130.44616699219, 155.0),
    vector4(689.61755371094, 571.80657958984, 130.44616699219, 155.0),
    vector4(688.41760253906, 572.34722900391, 130.44616699219, 155.0),
    vector4(687.38903808594, 572.71649169922, 130.44616699219, 155.0),
    vector4(686.20220947266, 573.05932617188, 130.44616699219, 155.0),
    vector4(684.96264648438, 573.37585449219, 130.44616699219, 155.0),
    vector4(683.96044921875, 573.86376953125, 130.44616699219, 155.0),
    vector4(682.86596679688, 574.23297119141, 130.44616699219, 155.0),
    vector4(681.876953125, 574.66815185547, 130.44616699219, 155.0),
    vector4(680.82196044922, 574.98461914062, 130.44616699219, 155.0),
    vector4(689.48571777344, 569.67034912109, 130.44616699219, 155.0),
    vector4(688.43078613281, 570.13189697266, 130.44616699219, 155.0),
    vector4(687.01977539062, 570.65936279297, 130.44616699219, 155.0),
    vector4(685.75384521484, 571.00219726562, 130.44616699219, 155.0),
    vector4(684.03955078125, 571.62200927734, 130.44616699219, 155.0),
    vector4(682.73406982422, 571.9384765625, 130.44616699219, 155.0),
    vector4(681.65277099609, 572.47912597656, 130.44616699219, 155.0),
    vector4(680.54504394531, 572.72967529297, 130.44616699219, 155.0),
    vector4(679.47692871094, 573.00659179688, 130.44616699219, 155.0),
    vector4(679.63519287109, 575.47253417969, 130.44616699219, 155.0),
    vector4(689.88134765625, 568.74725341797, 130.44616699219, 155.0),
    vector4(690.87036132812, 572.50549316406, 130.44616699219, 155.0),
    vector4(688.70770263672, 573.27032470703, 130.44616699219, 155.0),
    vector4(684.97583007812, 574.60217285156, 130.44616699219, 155.0),
    vector4(683.73626708984, 575.05053710938, 130.44616699219, 155.0),
    vector4(681.27032470703, 576.06591796875, 130.44616699219, 155.0),
    vector4(680.25494384766, 576.36926269531, 130.44616699219, 155.0),
    vector4(691.54284667969, 573.53405761719, 130.44616699219, 155.0),
    vector4(690.40881347656, 573.9560546875, 130.44616699219, 155.0),
    vector4(689.52526855469, 574.29888916016, 130.44616699219, 155.0),
    vector4(688.58898925781, 574.62860107422, 130.44616699219, 155.0),
    vector4(687.46813964844, 575.07690429688, 130.44616699219, 155.0),
    vector4(686.42639160156, 575.53845214844, 130.44616699219, 155.0),
    vector4(685.31866455078, 575.80218505859, 130.44616699219, 155.0),
    vector4(684.30328369141, 576.21099853516, 130.44616699219, 155.0),
    vector4(683.31427001953, 576.67254638672, 130.44616699219, 155.0),
    vector4(682.28570556641, 577.12091064453, 130.44616699219, 155.0),
    vector4(681.34942626953, 577.45056152344, 130.44616699219, 155.0),
    vector4(680.28131103516, 577.79339599609, 130.44616699219, 155.0),
    vector4(686.38684082031, 569.78900146484, 130.44616699219, 155.0),
    vector4(684.72528076172, 570.42199707031, 130.44616699219, 155.0),
    vector4(686.99340820312, 574.0615234375, 130.44616699219, 155.0)
}
local aq = {
    vector4(696.13189697266, 579.70550537109, 130.44616699219, 155.0),
    vector4(694.94506835938, 580.02197265625, 130.44616699219, 155.0),
    vector4(693.85052490234, 580.41760253906, 130.44616699219, 155.0),
    vector4(693.42858886719, 579.25714111328, 130.44616699219, 155.0),
    vector4(694.62860107422, 578.78240966797, 130.44616699219, 155.0),
    vector4(695.98681640625, 578.22857666016, 130.44616699219, 155.0),
    vector4(696.27691650391, 577.21319580078, 130.44616699219, 155.0),
    vector4(694.90551757812, 577.74066162109, 130.44616699219, 155.0),
    vector4(696.47473144531, 577.12091064453, 130.44616699219, 155.0),
    vector4(692.51867675781, 578.22857666016, 130.44616699219, 155.0),
    vector4(691.38464355469, 578.59777832031, 130.44616699219, 155.0),
    vector4(692.38684082031, 579.86376953125, 130.44616699219, 155.0),
    vector4(690.98901367188, 581.01098632812, 130.44616699219, 155.0),
    vector4(690.44836425781, 579.32305908203, 130.44616699219, 155.0),
    vector4(697.92529296875, 581.60437011719, 130.44616699219, 155.0),
    vector4(699.16485595703, 581.02416992188, 130.44616699219, 155.0),
    vector4(692.42639160156, 581.03735351562, 130.44616699219, 155.0),
    vector4(690.17144775391, 581.73626708984, 130.44616699219, 155.0),
    vector4(697.17364501953, 579.21759033203, 130.44616699219, 155.0),
    vector4(697.39782714844, 577.78021240234, 130.44616699219, 155.0),
    vector4(697.75384521484, 576.64617919922, 130.44616699219, 155.0),
    vector4(699.24395751953, 576.0263671875, 130.44616699219, 155.0),
    vector4(697.84613037109, 578.88793945312, 130.44616699219, 1155.0),
    vector4(698.92749023438, 578.58459472656, 130.44616699219, 155.0),
    vector4(697.79339599609, 577.71429443359, 130.44616699219, 155.0),
    vector4(699.16485595703, 577.16046142578, 130.44616699219, 155.0),
    vector4(693.66595458984, 577.89892578125, 130.44616699219, 155.0),
    vector4(691.00219726562, 580.23297119141, 130.44616699219, 155.0),
    vector4(689.85498046875, 580.76043701172, 130.44616699219, 155.0),
    vector4(689.47253417969, 579.66595458984, 130.44616699219, 155.0),
    vector4(700.0087890625, 579.38903808594, 130.44616699219, 155.0),
    vector4(698.78240966797, 579.78460693359, 130.44616699219, 155.0),
    vector4(697.912109375, 580.1142578125, 130.44616699219, 155.0),
    vector4(696.97583007812, 580.50988769531, 130.44616699219, 155.0),
    vector4(695.90771484375, 580.81317138672, 130.44616699219, 155.0),
    vector4(694.72088623047, 581.19561767578, 130.44616699219, 155.0),
    vector4(693.59997558594, 581.61755371094, 130.44616699219, 155.0),
    vector4(692.22857666016, 582.22418212891, 130.44616699219, 155.0),
    vector4(690.92309570312, 582.68572998047, 130.44616699219, 155.0),
    vector4(696.83074951172, 582.0, 130.44616699219, 155.0),
    vector4(695.76263427734, 582.38244628906, 130.44616699219, 155.0),
    vector4(694.70770263672, 582.54064941406, 130.44616699219, 155.0),
    vector4(693.30987548828, 583.01538085938, 130.44616699219, 155.0),
    vector4(692.18902587891, 583.58239746094, 130.44616699219, 155.0),
    vector4(690.96264648438, 583.9912109375, 130.44616699219, 155.0),
    vector4(691.41101074219, 581.78900146484, 130.44616699219, 155.0),
    vector4(699.876953125, 581.67034912109, 130.44616699219, 155.0),
    vector4(698.91430664062, 582.11865234375, 130.44616699219, 155.0),
    vector4(697.62200927734, 582.65936279297, 130.44616699219, 155.0),
    vector4(696.52746582031, 583.06811523438, 130.44616699219, 155.0),
    vector4(695.51208496094, 583.34503173828, 130.44616699219, 155.0),
    vector4(694.28570556641, 583.68792724609, 130.44616699219, 155.0),
    vector4(693.11206054688, 584.0966796875, 130.44616699219, 155.0),
    vector4(691.9384765625, 584.59777832031, 130.44616699219, 155.0),
    vector4(699.83734130859, 582.71209716797, 130.44616699219, 155.0),
    vector4(698.58459472656, 583.22637939453, 130.44616699219, 155.0),
    vector4(697.26593017578, 583.71429443359, 130.44616699219, 155.0),
    vector4(696.22418212891, 584.03076171875, 130.49670410156, 155.0),
    vector4(695.07690429688, 584.41320800781, 130.46301269531, 155.0),
    vector4(693.85052490234, 584.66375732422, 130.44616699219, 155.0),
    vector4(692.78240966797, 585.11206054688, 130.44616699219, 155.0),
    vector4(691.51647949219, 585.61315917969, 130.44616699219, 155.0),
    vector4(699.99560546875, 578.16265869141, 130.44616699219, 155.0),
    vector4(700.15386962891, 576.75164794922, 130.44616699219, 155.0)
}
local ar = false
function tARMA.isPodiumDrawing()
    return ar
end
local as = false
function tARMA.callCancelPodium()
    as = true
end
function tARMA.podiumLeaderboard(P, Q)
    ar = true
    tARMA.setTime(0, 0, 0)
    RequestIpl("stadium")
    while not IsIplActive("stadium") do
        print("Loading stadium IPL")
        Wait(0)
    end
    tARMA.hideUI()
    SendNUIMessage({transactionType = "celebration_music"})
    local at = {}
    local S = PlayerPedId()
    FreezeEntityPosition(S, true)
    ClearPedBloodDamage(S)
    for a6, B in pairs(P) do
        if B.source == GetPlayerServerId(PlayerId()) then
            local au = ap[a6]
            if not au then
                au = vector4(686.37365722656, 576.83074951172, 130.44616699219, 158.74015808105)
            end
            SetEntityCoords(S, au.x, au.y, au.z - 1)
            SetEntityHeading(S, au.w)
            CreateThread(function()
                local av = "anim@arena@celeb@flat@solo@no_props@"
                local aw = "flip_a_player_a"
                tARMA.loadAnimDict(av)
                while ar do
                    SetFocusPosAndVel(682.94506835938, 572.95385742188, 131.08642578125)
                    FreezeEntityPosition(PlayerPedId(), true)
                    if not IsEntityPlayingAnim(PlayerPedId(), av, aw, 3) then
                        TaskPlayAnim(PlayerPedId(), av, aw, 8.0, 8.0, -1, 1, 1.0)
                    end
                    Wait(0)
                end
            end)
        end
    end
    for a6, B in pairs(Q) do
        if B.source == GetPlayerServerId(PlayerId()) then
            local au = aq[a6]
            if not au then
                au = vector4(700.52307128906, 575.68353271484, 130.44616699219, 158.74015808105)
            end
            SetEntityCoords(S, au.x, au.y, au.z - 1)
            SetEntityHeading(S, au.w)
            CreateThread(function()
                local av = "anim_casino_a@amb@casino@games@arcadecabinet@femaleleft"
                local aw = "lose_big"
                tARMA.loadAnimDict(av)
                while ar do
                    SetFocusPosAndVel(682.94506835938, 572.95385742188, 131.08642578125)
                    FreezeEntityPosition(PlayerPedId(), true)
                    if not IsEntityPlayingAnim(PlayerPedId(), av, aw, 3) then
                        TaskPlayAnim(PlayerPedId(), av, aw, 8.0, 8.0, -1, 1, 1.0)
                    end
                    Wait(0)
                end
            end)
        end
    end
    local ax = vector3(683.83, 570.57, 130.46)
    local ay = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", 681.29, 563.62, 141.05, 0.0, 0.0, 0.0, 65.0, 0, 2)
    PointCamAtCoord(ay, ax.x, ax.y, ax.z + 10)
    SetCamActive(ay, true)
    RenderScriptCams(true, true, 0, 1, 0)
    local az = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", 681.29, 563.62, 131.05, 0.0, 0.0, 0.0, 65.0, 0, 2)
    PointCamAtCoord(az, ax)
    SetCamActiveWithInterp(az, ay, 10000, 5, 5)
    am(ax + vector3(0, 0, 5))
    am(vector3(681.34, 572.84, 130.46) + vector3(0, 0, 5))
    am(vector3(686.76, 570.71, 130.46) + vector3(0, 0, 5))
    local aA = GetGameTimer()
    while not as and GetGameTimer() - aA < 10000 do
        ThefeedHideThisFrame()
        Wait(0)
    end
    if not as then
        local aB = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA",696.13189697266,579.70550537109,130.44616699219,0.0,0.0,0.0,65.0,0,2)
        PointCamAtCoord(aB, vector3(695.947265625, 584.84832763672, 130.74951171875))
        SetCamActiveWithInterp(aB, az, 11000, 5, 5)
    end
    local aA = GetGameTimer()
    while not as and GetGameTimer() - aA < 4000 do
        ThefeedHideThisFrame()
        Wait(0)
    end
    if not as then
        DoScreenFadeOut(2000)
    end
    local aA = GetGameTimer()
    while not as and GetGameTimer() - aA < 3000 do
        Wait(0)
    end
    for o, aC in pairs(at) do
        tARMA.removeArea("3dtext_" .. aC)
    end
    ClearPedTasks(S)
    FreezeEntityPosition(S, false)
    RenderScriptCams(0, 0, 1, 1, 1)
    DestroyCam(ay, 0)
    DestroyCam(az, 0)
    DestroyAllCams(true)
    DoScreenFadeIn(1000)
    tARMA.setTime(12, 0, 0)
    ClearTimecycleModifier()
    ar = false
    tARMA.showUI()
    as = false
    ClearFocus()
end
RegisterNetEvent("ARMA:celebrationScreen",function(aD, aE)
    CreateThread(function()
        tARMA.activateSlowMo()
    end)
    local aF = {}
    aF[1] = Scaleform("MP_CELEBRATION")
    aF[2] = Scaleform("MP_CELEBRATION_BG")
    aF[3] = Scaleform("MP_CELEBRATION_FG")
    for o, _ in ipairs(aF) do
        _.RunFunction("CLEANUP", {"WINNER"})
        _.RunFunction("CREATE_STAT_WALL", {"WINNER", "HUD_COLOUR_BLACK", "70.0"})
        if aE then
            _.RunFunction("ADD_POSITION_TO_WALL", {"WINNER", aE, "1ST", false, false})
        end
        _.RunFunction("ADD_WINNER_TO_WALL", {"WINNER", "CELEB_WINNER", aD, "", 0, false, "", false})
        _.RunFunction("ADD_BACKGROUND_TO_WALL", {"WINNER", 75, 0})
        _.RunFunction("SHOW_STAT_WALL", {"WINNER"})
    end
    local aG = true
    SetTimeout(10000,function()
        aG = false
    end)
    tARMA.hideUI()
    while aG do
        DrawScaleformMovieFullscreenMasked(aF[2].Handle, aF[3].Handle, 255, 255, 255, 255)
        aF[1].Render2D()
        Citizen.Wait(0)
    end
    if not tARMA.isPodiumDrawing() then
        tARMA.showUI()
    end
end)
local aH = false
function tARMA.activateSlowMo()
    aH = true
    SetSpecialAbility(PlayerId(), 2)
    SpecialAbilityActivate(PlayerId())
    Wait(1000)
    aH = false
    SpecialAbilityDeplete(PlayerId())
    Citizen.InvokeNative(0xc204033758e4127f, PlayerId())
end
function tARMA.isInSlowMo()
    return aH
end
local function aI(aJ)
    local a6 = aJ % 6
    if a6 == 0 then
        return 3
    elseif a6 == 1 then
        return 5
    elseif a6 == 2 then
        return 17
    elseif a6 == 3 then
        return 11
    elseif a6 == 4 then
        return 14
    elseif a6 == 5 then
        return 8
    elseif a6 == 6 then
        return 1
    end
end
local aK
local aL
local aM = false
function tARMA.enableEventPlayerBlips(aN, aO, aP)
    aK = aO
    aL = aP or function()
            return true
        end
    aM = aN
    if not aN then
        for o, B in ipairs(currentEvent.players) do
            tARMA.removeBlipsForPlayer(B)
        end
    end
    DisplayPlayerNameTagsOnBlips(aN)
end
local aQ = {}
function tARMA.forceCleanupPlayerBlips()
    for o, aR in pairs(aQ) do
        for o, aS in pairs(aR) do
            if DoesBlipExist(aS) then
                RemoveBlip(aS)
            end
        end
    end
end
function tARMA.removeBlipsForPlayer(B)
    if B.blip then
        RemoveBlip(B.blip)
    end
    local aT = aQ[B.source]
    if aT then
        for o, aS in pairs(aT) do
            RemoveBlip(aS)
        end
    end
    local aU = GetPlayerFromServerId(B.source)
    if aU == -1 then
        return
    end
    local S = GetPlayerPed(aU)
    if S == 0 then
        return
    end
    local aV = GetBlipFromEntity(S)
    if DoesBlipExist(aV) then
        RemoveBlip(aV)
    end
end
CreateThread(function()
    while true do
        if aM then
            local a2 = GetActivePlayers()
            for r, a4 in ipairs(currentEvent.players) do
                local aW = GetPlayerFromServerId(a4.source)
                if aW ~= -1 and aW ~= PlayerId() and table.has(a2, aW) then
                    local S = GetPlayerPed(aW)
                    local aV = GetBlipFromEntity(S)
                    if IsEntityVisible(S) and a4.active and aL(a4.source) then
                        if not a4.blip or aV ~= a4.blip then
                            if a4.blip then
                                RemoveBlip(a4.blip)
                            end
                            if DoesBlipExist(aV) then
                                RemoveBlip(aV)
                            end
                            local aX = AddBlipForEntity(S)
                            if not aQ[a4.source] then
                                aQ[a4.source] = {}
                            end
                            table.insert(aQ[a4.source], aX)
                            SetBlipSprite(aX, 1)
                            SetBlipCategory(aX, 7)
                            if aK then
                                SetBlipColour(aX, aK(a4.source))
                            else
                                SetBlipColour(aX, aI(a4.source))
                            end
                            ShowHeadingIndicatorOnBlip(aX, true)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentSubstringPlayerName(tARMA.getPlayerName(aW))
                            EndTextCommandSetBlipName(aX)
                            a4.blip = aX
                        else
                            local aY = IsEntityDead(S) and 274 or 1
                            if GetBlipSprite(a4.blip) ~= aY then
                                SetBlipSprite(a4.blip, aY)
                                if aK then
                                    SetBlipColour(a4.blip, aK(a4.source))
                                else
                                    SetBlipColour(a4.blip, aI(a4.source))
                                end
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentSubstringPlayerName(tARMA.getPlayerName(aW))
                                EndTextCommandSetBlipName(a4.blip)
                            end
                        end
                    else
                        if a4.blip then
                            RemoveBlip(a4.blip)
                            a4.blip = nil
                        end
                        if DoesBlipExist(aV) then
                            RemoveBlip(aV)
                        end
                    end
                end
            end
        end
        Wait(100)
    end
end)
local function aZ(aJ)
    local a6 = aJ % 6
    if a6 == 0 then
        return 9
    elseif a6 == 1 then
        return 12
    elseif a6 == 2 then
        return 15
    elseif a6 == 3 then
        return 18
    elseif a6 == 4 then
        return 21
    elseif a6 == 5 then
        return 24
    elseif a6 == 6 then
        return 6
    end
end
local a_
local b0 = nil
local b1 = false
local b2 = false
function tARMA.enableEventPlayerTags(aN, b3, b4, b5)
    a_ = b4
    b0 = b5
    b2 = b3
    b1 = aN
    if not aN then
        for r, a4 in ipairs(currentEvent.players) do
            if a4.tag then
                RemoveMpGamerTag(a4.tag)
                a4.tag = nil
            end
        end
    end
end
function tARMA.isEventPlayerTagEnabled()
    return b1
end
CreateThread(function()
    while true do
        if b1 then
            local S = PlayerPedId()
            for r, a4 in ipairs(currentEvent.players) do
                local aW = GetPlayerFromServerId(a4.source)
                if aW ~= -1 and aW ~= PlayerId() then
                    local b6 = GetPlayerPed(aW)
                    local b7 = HasEntityClearLosToEntity(S, b6, 17) or tARMA.isSpectatingEvent()
                    if b7 and IsEntityVisible(b6) and a4.active then
                        if not a4.tag or not IsMpGamerTagActive(a4.tag) then
                            local b8 = nil
                            if b0 then
                                b8 = CreateFakeMpGamerTag(b6, b0(a4), false, false, "", 0)
                            else
                                b8 = CreateFakeMpGamerTag(b6, tARMA.getPlayerName(aW), false, false, "", 0)
                            end
                            if a_ then
                                SetMpGamerTagColour(b8, 0, a_(a4.source))
                            else
                                SetMpGamerTagColour(b8, 0, aZ(a4.source))
                            end
                            SetMpGamerTagColour(b8, 29, 6)
                            if b2 then
                                SetMpGamerTagHealthBarColour(b8, 18)
                                SetMpGamerTagAlpha(b8, 2, 255)
                                SetMpGamerTagVisibility(b8, 2, true)
                            end
                            a4.tag = b8
                        end
                    else
                        if a4.tag then
                            RemoveMpGamerTag(a4.tag)
                            a4.tag = nil
                        end
                    end
                end
            end
        end
        Wait(100)
    end
end)
function tARMA.setEventIntroMessage(b9, ba, bb, bc)
    EnableAllControlActions(0)
    local Z = GetSoundId()
    PlaySoundFrontend(Z, "Frontend_Beast_Freeze_Screen", "FM_Events_Sasquatch_Sounds", false)
    ReleaseSoundId(Z)
    if not HasStreamedTextureDictLoaded("armaui") then
        RequestStreamedTextureDict("armaui")
        while not HasStreamedTextureDictLoaded("armaui") do
            Wait(0)
        end
    end
    tARMA.hideUI()
    local bd = 0.0
    local be = 0.55
    local bf = true
    if bb == 0 then
    else
        SetTimeout(bb or 5000,function()
            bf = false
        end)
        while bf do
            Wait(0)
            if bd < be then
                bd = bd + 0.01
            end
            DrawAdvancedTextNoOutline(0.283,0.807 - be + bd,0.005,0.0028,1.25,b9,171,34,35,255,tARMA.getFontId("Akrobat-ExtraBold"),0)
            DrawAdvancedTextNoOutline(0.488, 0.883 - be + bd, 0.005, 0.0028, 1.03, ba, 255, 255, 255, 255, 1, 0)
            DrawSprite("armaui", "slanted_rect", 0.5, bd, 1.0, 1.0, 0.0, 255, 255, 255, 180)
        end
    end
    tARMA.showUI()
end
function tARMA.inEvent()
    return currentEvent.isActive or isDoingSequence or d
end
RegisterNetEvent("ARMA:setIsAnyEventActive",function(a7)
    f = a7
end)
