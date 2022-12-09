RMenu.Add('SettingsMenu', 'MainMenu', RageUI.CreateMenu("", "~b~Settings Menu", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "banners","settings")) 
RMenu.Add("SettingsMenu", "crosshairsettings", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu"), "", '~b~Crosshair Settings',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners","settings"))
RMenu.Add("SettingsMenu", "graphicpresets", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu"), "", '~b~Graphics Presets',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners","settings"))
RMenu.Add("SettingsMenu", "killeffects", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu"), "", '~b~Kill Effects',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners","settings"))
RMenu.Add("SettingsMenu", "bloodeffects", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu"), "", '~b~Blood Effects',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners","settings"))



local a = module("cfg/cfg_settings")
local b = 0
local d = 0
local e = false
local l = {
    {"20%", 0.2},
    {"30%", 0.3},
    {"40%", 0.4},
    {"50%", 0.5},
    {"60%", 0.6},
    {"70%", 0.7},
    {"80%", 0.8},
    {"90%", 0.9},
    {"100%", 1.0},
    {"150%", 1.5},
    {"200%", 2.0},
    {"1000%", 10.0}
}
local m = {"20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%", "150%", "200%", "1000%"}
local n = 9
local u = {}
local function v(w, x)
    return u[w.name .. x.name]
end
local function y(w)
    local z = false
    for A, x in pairs(w.presets) do
        if u[w.name .. x.name] then
            z = true
            u[w.name .. x.name] = nil
        end
    end
    if z then
        for B, C in pairs(w.default) do
            SetVisualSettingFloat(B, C)
        end
    end
end
local function D(x)
    for B, C in pairs(x.values) do
        SetVisualSettingFloat(B, C)
    end
end
local function E(w, x, F)
    y(w)
    if F then
        u[w.name .. x.name] = true
        D(x)
    end
    local G = json.encode(u)
    SetResourceKvp("arma_graphic_presets", G)
end

local H = {
    "0%",
    "5%",
    "10%",
    "15%",
    "20%",
    "25%",
    "30%",
    "35%",
    "40%",
    "45%",
    "50%",
    "55%",
    "60%",
    "65%",
    "70%",
    "75%",
    "80%",
    "85%",
    "90%",
    "95%",
    "100%"
}
local I = {
    0.0,
    0.05,
    0.1,
    0.15,
    0.2,
    0.25,
    0.3,
    0.35,
    0.4,
    0.45,
    0.5,
    0.55,
    0.6,
    0.65,
    0.7,
    0.75,
    0.8,
    0.85,
    0.9,
    0.95,
    1.0
}
local J = {
    "25%",
    "50%",
    "75%",
    "100%",
    "125%",
    "150%",
    "175%",
    "200%",
    "250%",
    "300%",
    "350%",
    "400%",
    "450%",
    "500%",
    "750%",
    "1000%"
}
local K = {0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 7.5, 10.0}
local L = {
    "0.1s",
    "0.2s",
    "0.3s",
    "0.4s",
    "0.5s",
    "0.6s",
    "0.7s",
    "0.8s",
    "0.9s",
    "1s",
    "1.25s",
    "1.5s",
    "1.75s",
    "2.0s"
}
local M = {100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1250, 1500, 1750, 2000}
local N = {
    "Disabled",
    "Fireworks",
    "Celebration",
    "Firework Burst",
    "Water Explosion",
    "Ramp Explosion",
    "Gas Explosion",
    "Electrical Spark",
    "Electrical Explosion",
    "Concrete Impact",
    "EMP 1",
    "EMP 2",
    "EMP 3",
    "Spike Mine",
    "Kinetic Mine",
    "Tar Mine",
    "Short Burst",
    "Fog Sphere",
    "Glass Smash",
    "Glass Drop",
    "Falling Leaves",
    "Wood Smash",
    "Train Smoke",
    "Money"
}
local O = {
    {"DISABLED", "DISABLED", 1.0},
    {"scr_indep_fireworks", "scr_indep_firework_shotburst", 0.2},
    {"scr_xs_celebration", "scr_xs_confetti_burst", 1.2},
    {"scr_rcpaparazzo1", "scr_mich4_firework_burst_spawn", 1.0},
    {"particle cut_finale1", "cs_finale1_car_explosion_surge_spawn", 1.0},
    {"des_fib_floor", "ent_ray_fbi5a_ramp_explosion", 1.0},
    {"des_gas_station", "ent_ray_paleto_gas_explosion", 0.5},
    {"core", "ent_dst_electrical", 1.0},
    {"core", "ent_sht_electrical_box", 1.0},
    {"des_vaultdoor", "ent_ray_pro1_concrete_impacts", 1.0},
    {"scr_xs_dr", "scr_xs_dr_emp", 1.0},
    {"scr_xs_props", "scr_xs_exp_mine_sf", 1.0},
    {"veh_xs_vehicle_mods", "exp_xs_mine_emp", 1.0},
    {"veh_xs_vehicle_mods", "exp_xs_mine_spike", 1.0},
    {"veh_xs_vehicle_mods", "exp_xs_mine_kinetic", 1.0},
    {"veh_xs_vehicle_mods", "exp_xs_mine_tar", 1.0},
    {"scr_stunts", "scr_stunts_shotburst", 1.0},
    {"scr_tplaces", "scr_tplaces_team_swap", 1.0},
    {"des_fib_glass", "ent_ray_fbi2_window_break", 1.0},
    {"des_fib_glass", "ent_ray_fbi2_glass_drop", 2.5},
    {"des_stilthouse", "ent_ray_fam3_falling_leaves", 1.0},
    {"des_stilthouse", "ent_ray_fam3_wood_frags", 1.0},
    {"des_train_crash", "ent_ray_train_smoke", 1.0},
    {"core", "ent_brk_banknotes", 2.0}
}
local P = {
    "Disabled",
    "BikerFilter",
    "CAMERA_BW",
    "drug_drive_blend01",
    "glasses_blue",
    "glasses_brown",
    "glasses_Darkblue",
    "glasses_green",
    "glasses_purple",
    "glasses_red",
    "helicamfirst",
    "hud_def_Trevor",
    "Kifflom",
    "LectroDark",
    "MP_corona_tournament_DOF",
    "MP_heli_cam",
    "mugShot",
    "NG_filmic02",
    "REDMIST_blend",
    "trevorspliff",
    "ufo",
    "underwater",
    "WATER_LAB",
    "WATER_militaryPOOP",
    "WATER_river",
    "WATER_salton"
}
local Q = {
    lightning = false,
    pedFlash = false,
    pedFlashRGB = {11, 11, 11},
    pedFlashIntensity = 4,
    pedFlashTime = 1,
    screenFlash = false,
    screenFlashRGB = {11, 11, 11},
    screenFlashIntensity = 4,
    screenFlashTime = 1,
    particle = 1,
    timecycle = 1,
    timecycleTime = 1
}
local R = 0
local function S()
    local T = json.encode(Q)
    SetResourceKvp("arma_kill_effects", T)
end
local W = {head = 1, body = 1, arms = 1, legs = 1}
local function X()
    local Y = json.encode(W)
    SetResourceKvp("arma_blood_effects", Y)
end
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    local G = GetResourceKvpString("arma_graphic_presets")
    if G and G ~= "" then
        u = json.decode(G) or {}
    end
    for A, w in pairs(a.presets) do
        for A, x in pairs(w.presets) do
            if v(w, x) then
                D(x)
            end
        end
    end
    local T = GetResourceKvpString("arma_kill_effects")
    if T and T ~= "" then
        local U = json.decode(T)
        for V, F in pairs(U) do
            if Q[V] then
                Q[V] = F
            end
        end
    end
    local Y = GetResourceKvpString("arma_blood_effects")
    if Y and Y ~= "" then
        local Z = json.decode(Y)
        for _, H in pairs(Z) do
            if W[_] then
                W[_] = H
            end
        end
    end
end)

function tARMA.setHitMarkerSetting(i)
    SetResourceKvp("arma_hitmarkersounds", tostring(i))
end
function tARMA.setCODHitMarkerSetting(i)
    SetResourceKvp("arma_codhitmarkersounds", tostring(i))
end
function tARMA.setDiagonalWeaponSetting(f)
    SetResourceKvp("ARMA_diagonalweapons",tostring(f))
end

Citizen.CreateThread(function()
    local f = GetResourceKvpString("arma_diagonalweapons") or "false"
    if f == "false" then
        b = false
        TriggerEvent("ARMA:setDiagonalWeapons", b)
    else
        b = true
        TriggerEvent("ARMA:setDiagonalWeapons", b)
    end
    local h = GetResourceKvpString("arma_hitmarkersounds") or "false"
    if h == "false" then
        d = false
        TriggerEvent("ARMA:hsSoundsOff")
    else
        d = true
        TriggerEvent("ARMA:hsSoundsOn")
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('SettingsMenu', 'MainMenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.List("Render Distance Modifier",m,n,"~g~Lowering this will increase your FPS!",{},true,function(W, X, Y, Z)
                if Y then
                end
                n = Z
            end,function()end,nil)
            local function _()
                b = true
                TriggerEvent("ARMA:setDiagonalWeapons", b)
                tARMA.setDiagonalWeaponSetting(b)
            end
            local function a0()
                b = false
                TriggerEvent("ARMA:setDiagonalWeapons", b)
                tARMA.setDiagonalWeaponSetting(b)
            end
            RageUI.Checkbox("Enable Diagonal Weapons","~g~This changes the way weapons look on your back from vertical to diagonal.",b,{Style = RageUI.CheckboxStyle.Car},function(W, Y, X, a1)
            end,_,a0)
            local function _()
                d = true
                TriggerEvent("ARMA:hsSoundsOn")
                tARMA.setHitMarkerSetting(d)
                tARMA.notify("~y~Experimental Headshot sounds now set to " .. tostring(d))
            end
            local function a0()
                d = false
                TriggerEvent("ARMA:hsSoundsOff")
                tARMA.setHitMarkerSetting(d)
                tARMA.notify("~y~Experimental Headshot sounds now set to " .. tostring(d))
            end
            RageUI.Checkbox("Enable Experimental Hit Marker Sounds","~g~This adds 'hit marker' sounds when shooting another player, however it can be unreliable.",d,{Style = RageUI.CheckboxStyle.Car},function(W, Y, X, a1)
            end,_,a0)
            -- RageUI.ButtonWithStyle("Store Inventory","View your store inventory here.",{RightLabel = "→→→"},true,function()
            -- end,RMenu:Get("store", "mainmenu"))
            RageUI.Checkbox("Streetnames","",tARMA.isStreetnamesEnabled(),{Style = RageUI.CheckboxStyle.Car},function(W, Y, X, a1)
            end,function()tARMA.setStreetnamesEnabled(true)end,function()tARMA.setStreetnamesEnabled(false)end)
            RageUI.Checkbox("Toggle Compass", nil, compasschecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if Selected then
                    compasschecked = not compasschecked
                    ExecuteCommand("compass")
                end
            end)
            local function _()
                ExecuteCommand("hideui")
                hideUI = true
            end
            local function a0()
                ExecuteCommand("showui")
                hideUI = false
            end
            RageUI.Checkbox("Hide UI","",hideUI,{Style = RageUI.CheckboxStyle.Car},function(W, Y, X, a1)
            end,_,a0)
            local function _()
                tARMA.toggleBlackBars()
                e = true
                TriggerEvent('ARMAHUD:hide')
            end
            local function a0()
                tARMA.toggleBlackBars()
                e = false
                TriggerEvent('ARMAHUD:show')
            end
            RageUI.Checkbox("Cinematic Black Bars","",e,{Style = RageUI.CheckboxStyle.Car},function(W, Y, X, a1)
            end,_,a0)
            RageUI.ButtonWithStyle("Crosshair Settings", "Create a custom built-in crosshair here.", {RightLabel = "→→→"}, true, function(W, X, Y)
                if Y then
                    ExecuteCommand('crosshair')
                end
            end)
            RageUI.ButtonWithStyle("Scope Settings","Add a toggleable range finder when using sniper scopes.",{RightLabel = "→→→"},true,function(W, X, Y)
                if Y then
                    ExecuteCommand("scope")
                end
            end)
            RageUI.ButtonWithStyle("Graphic Presets","View a list of preconfigured graphic settings.",{RightLabel = "→→→"},true,function()
            end,RMenu:Get("SettingsMenu", "graphicpresets"))
            RageUI.ButtonWithStyle("Kill Effects","Toggle effects that occur on killing a player.",{RightLabel = "→→→"},true,function()
            end,RMenu:Get("SettingsMenu", "killeffects"))
            RageUI.ButtonWithStyle("Blood Effects","Toggle effects that occur when damaging a player.",{RightLabel = "→→→"},true,function()
            end,RMenu:Get("SettingsMenu", "bloodeffects"))
       end)
    end
    if RageUI.Visible(RMenu:Get('SettingsMenu', 'graphicpresets')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for A, w in pairs(a.presets) do
                RageUI.Separator(w.name)
                for A, x in pairs(w.presets) do
                    local a7 = v(w, x)
                    RageUI.Checkbox(x.name,nil,a7,{},function(W, Y, X, a1)
                        if a1 ~= a7 then
                            E(w, x, a1)
                        end
                    end,function()end,function()end)
                end
            end
       end)
    end
    if RageUI.Visible(RMenu:Get('SettingsMenu', 'killeffects')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Checkbox("Create Lightning","",Q.lightning,{},function(W, Y, X, a1)
                if Y then
                    Q.lightning = a1
                    S()
                end
            end)
            RageUI.Checkbox("Ped Flash","",Q.pedFlash,{},function(W, Y, X, a1)
                if Y then
                    Q.pedFlash = a1
                    S()
                end
            end)
            if Q.pedFlash then
                RageUI.List("Ped Flash Red",H,Q.pedFlashRGB[1],"",{},Q.pedFlash,function(W, X, Y, Z)
                    if X and Q.pedFlashRGB[1] ~= Z then
                        Q.pedFlashRGB[1] = Z
                        S()
                    end
                end,function()end)
                RageUI.List("Ped Flash Green",H,Q.pedFlashRGB[2],"",{},Q.pedFlash,function(W, X, Y, Z)
                    if X and Q.pedFlashRGB[2] ~= Z then
                        Q.pedFlashRGB[2] = Z
                        S()
                    end
                end,function()end)
                RageUI.List("Ped Flash Blue",H,Q.pedFlashRGB[3],"",{},Q.pedFlash,function(W, X, Y, Z)
                    if X and Q.pedFlashRGB[3] ~= Z then
                        Q.pedFlashRGB[3] = Z
                        S()
                    end
                end,function()end)
                RageUI.List("Ped Flash Intensity",J,Q.pedFlashIntensity,"",{},Q.pedFlash,function(W, X, Y, Z)
                    if X and Q.pedFlashIntensity ~= Z then
                        Q.pedFlashIntensity = Z
                        S()
                    end
                end,function()end)
                RageUI.List("Ped Flash Time",L,Q.pedFlashTime,"",{},Q.pedFlash,function(W, X, Y, Z)
                    if X and Q.pedFlashTime ~= Z then
                        Q.pedFlashTime = Z
                        S()
                    end
                end,function()end)
            end
            RageUI.Checkbox("Screen Flash","",Q.screenFlash,{},function(W, Y, X, a1)
                if Y then
                    Q.screenFlash = a1
                    S()
                end
            end)
            if Q.screenFlash then
                RageUI.List("Screen Flash Red",H,Q.screenFlashRGB[1],"",{},Q.screenFlash,function(W, X, Y, Z)
                    if X and Q.screenFlashRGB[1] ~= Z then
                        Q.screenFlashRGB[1] = Z
                        S()
                    end
                end,function()end)
                RageUI.List("Screen Flash Green",H,Q.screenFlashRGB[2],"",{},Q.screenFlash,function(W, X, Y, Z)
                    if X and Q.screenFlashRGB[2] ~= Z then
                        Q.screenFlashRGB[2] = Z
                        S()
                    end
                end,function()end)
                RageUI.List("Screen Flash Blue",H,Q.screenFlashRGB[3],"",{},Q.screenFlash,function(W, X, Y, Z)
                    if X and Q.screenFlashRGB[3] ~= Z then
                        Q.screenFlashRGB[3] = Z
                        S()
                    end
                end,function()end)
                RageUI.List("Screen Flash Intensity",J,Q.screenFlashIntensity,"",{},Q.screenFlash,function(W, X, Y, Z)
                    if X and Q.screenFlashIntensity ~= Z then
                        Q.screenFlashIntensity = Z
                        S()
                    end
                end,function()end)
                RageUI.List("Screen Flash Time",L,Q.screenFlashTime,"",{},Q.screenFlash,function(W, X, Y, Z)
                    if X and Q.screenFlashTime ~= Z then
                        Q.screenFlashTime = Z
                        S()
                    end
                end,function()end)
            end
            RageUI.List("Timecycle Flash",P,Q.timecycle,"",{},true,function(W, X, Y, Z)
                if X and Q.timecycle ~= Z then
                    Q.timecycle = Z
                    S()
                end
            end,function()end)
            if Q.timecycle ~= 1 then
                RageUI.List("Timecycle Flash Time",L,Q.timecycleTime,"",{},true,function(W, X, Y, Z)
                    if X and Q.timecycleTime ~= Z then
                        Q.timecycleTime = Z
                        S()
                    end
                end,function()end)
            end
            RageUI.List("~y~Particles~w~",N,Q.particle,"",{},true,function(W, X, Y, Z)
                if X and Q.particle ~= Z then
                    if not tARMA.isPlatClub() and not tARMA.isPlusClub() then
                        tARMA.notify("~y~You need to be a subscriber of ARMA Plus or ARMA Platinum to use this feature.")
                        tARMA.notify("~y~Available @ store.armarp.co.uk")
                    else
                        Q.particle = Z
                        S()
                    end
                end
            end,function()end)
            local a8 = 0
            if Q.lightning then
                a8 = math.max(a8, 1000)
            end
            if Q.pedFlash then
                a8 = math.max(a8, M[Q.pedFlashTime])
            end
            if Q.screenFlash then
                a8 = math.max(a8, M[Q.screenFlashTime])
            end
            if Q.timecycleTime ~= 1 then
                a8 = math.max(a8, I[Q.timecycleTime])
            end
            if Q.particle ~= 1 then
                a8 = math.max(a8, 1000)
            end
            if GetGameTimer() - R > a8 + 1000 then
                tARMA.addKillEffect(PlayerPedId(), true)
                R = GetGameTimer()
            end
            DrawAdvancedTextNoOutline(0.59, 0.9, 0.005, 0.0028, 1.5, "PREVIEW", 255, 0, 0, 255, 2, 0)
       end)
    end
    if RageUI.Visible(RMenu:Get('SettingsMenu', 'bloodeffects')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.List("~y~Head",P,W.head,"Effect that displays when you hit the head.",{},true,function(a0, a1, a2, a3)
                if W.head ~= a3 then
                    if not tARMA.isPlusClub() and not tARMA.isPlatClub() then
                        notify("~y~You need to be a subscriber of ARMA Plus or ARMA Platinum to use this feature.")
                        notify("~y~Available @ store.armarp.co.uk")
                    end
                    W.head = a3
                    X()
                end
                if a2 then
                    tARMA.addBloodEffect("head", 0x796E, PlayerPedId())
                end
            end)
            RageUI.List("~y~Body",P,W.body,"Effect that displays when you hit the body.",{},true,function(a0, a1, a2, a3)
                if W.body ~= a3 then
                    if not tARMA.isPlusClub() and not tARMA.isPlatClub() then
                        notify("~y~You need to be a subscriber of ARMA Plus or ARMA Platinum to use this feature.")
                        notify("~y~Available @ store.armarp.co.uk")
                    end
                    W.body = a3
                    X()
                end
                if a2 then
                    tARMA.addBloodEffect("body", 0x0, PlayerPedId())
                end
            end)
            RageUI.List("~y~Arms",P,W.arms,"Effect that displays when you hit the arms.",{},true,function(a0, a1, a2, a3)
                if W.arms ~= a3 then
                    if not tARMA.isPlusClub() and not tARMA.isPlatClub() then
                        notify("~y~You need to be a subscriber of ARMA Plus or ARMA Platinum to use this feature.")
                        notify("~y~Available @ store.armarp.co.uk")
                    end
                    W.arms = a3
                    X()
                end
                if a2 then
                    tARMA.addBloodEffect("arms", 0xBB0, PlayerPedId())
                    tARMA.addBloodEffect("arms", 0x58B7, PlayerPedId())
                end
            end)
            RageUI.List("~y~Legs",P,W.legs,"Effect that displays when you hit the legs.",{},true,function(a0, a1, a2, a3)
                if W.legs ~= a3 then
                    if not tARMA.isPlusClub() and not tARMA.isPlatClub() then
                        notify("~y~You need to be a subscriber of ARMA Plus or ARMA Platinum to use this feature.")
                        notify("~y~Available @ store.armarp.co.uk")
                    end
                    W.legs = a3
                    X()
                end
                if a2 then
                    tARMA.addBloodEffect("legs", 0x3FCF, PlayerPedId())
                    tARMA.addBloodEffect("legs", 0xB3FE, PlayerPedId())
                end
            end)
       end)
    end
end)


RegisterNetEvent('ARMA:OpenSettingsMenu')
AddEventHandler('ARMA:OpenSettingsMenu', function(admin)
    if not admin then
        RageUI.Visible(RMenu:Get("SettingsMenu", "MainMenu"), true)
    end
end)

RegisterCommand('opensettingsmenu',function()
    TriggerServerEvent('ARMA:OpenSettings')
end)

RegisterKeyMapping('opensettingsmenu', 'Opens the Settings menu', 'keyboard', 'F2')

Citizen.CreateThread(function()
    while true do
        OverrideLodscaleThisFrame(l[n][2])
        if not (tARMA.getStaffLevel() > 0) then
            if IsUsingKeyboard(2) and IsControlJustPressed(1, 289) then
                RageUI.Visible(RMenu:Get("SettingsMenu", "MainMenu"),not RageUI.Visible(RMenu:Get("SettingsMenu", "MainMenu")))
            end
        end
        Wait(0)
    end
end)

local function aa(ab)
    local ac = GetEntityCoords(ab, true)
    local ad = GetGameTimer()
    local ae = math.floor(I[Q.pedFlashRGB[1]] * 255)
    local af = math.floor(I[Q.pedFlashRGB[2]] * 255)
    local ag = math.floor(I[Q.pedFlashRGB[3]] * 255)
    local ah = K[Q.pedFlashIntensity]
    local ai = M[Q.pedFlashTime]
    while GetGameTimer() - ad < ai do
        local aj = (ai - (GetGameTimer() - ad)) / ai
        local ak = ah * 25.0 * aj
        DrawLightWithRange(ac.x, ac.y, ac.z + 1.0, ae, af, ag, 50.0, ak)
        Citizen.Wait(0)
    end
end
local function al()
    local ad = GetGameTimer()
    local ae = math.floor(I[Q.screenFlashRGB[1]] * 255)
    local af = math.floor(I[Q.screenFlashRGB[2]] * 255)
    local ag = math.floor(I[Q.screenFlashRGB[3]] * 255)
    local ah = K[Q.screenFlashIntensity]
    local ai = M[Q.screenFlashTime]
    while GetGameTimer() - ad < ai do
        local aj = (ai - (GetGameTimer() - ad)) / ai
        local ak = math.floor(25.5 * ah * aj)
        DrawRect(0.0, 0.0, 2.0, 2.0, ae, af, ag, ak)
        Citizen.Wait(0)
    end
end
local function am(ab)
    local ac = GetEntityCoords(ab, true)
    local an = O[Q.particle]
    tARMA.loadPtfx(an[1])
    UseParticleFxAsset(an[1])
    StartParticleFxNonLoopedAtCoord(an[2], ac.x, ac.y, ac.z, 0.0, 0.0, 0.0, an[3], false, false, false)
    RemoveNamedPtfxAsset(an[1])
end
local function ao()
    local ad = GetGameTimer()
    local ai = M[Q.timecycleTime]
    SetTimecycleModifier(P[Q.timecycle])
    while GetGameTimer() - ad < ai do
        local aj = (ai - (GetGameTimer() - ad)) / ai
        SetTimecycleModifierStrength(1.0 * aj)
        Citizen.Wait(0)
    end
    ClearTimecycleModifier()
end
function tARMA.addKillEffect(ap, aq)
    if Q.lightning then
        ForceLightningFlash()
    end
    if Q.pedFlash then
        Citizen.CreateThreadNow(function()
            aa(ap)
        end)
    end
    if Q.screenFlash then
        Citizen.CreateThreadNow(function()
            al()
        end)
    end
    if Q.particle ~= 1 and (tARMA.isPlatClub() or aq) then
        Citizen.CreateThreadNow(function()
            am(ap)
        end)
    end
    if Q.timecycle ~= 1 then
        Citizen.CreateThreadNow(function()
            ao()
        end)
    end
end
function tARMA.addBloodEffect(aw, ax, ag)
    local ay = W[aw]
    if ay > 1 then
        local as = Q[ay]
        tARMA.loadPtfx(as[1])
        UseParticleFxAsset(as[1])
        StartParticleFxNonLoopedOnPedBone(as[2], ag, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ax, as[3], false, false, false)
        RemoveNamedPtfxAsset(as[1])
    end
end
RegisterNetEvent("ARMA:onPlayerKilledPed")
AddEventHandler("ARMA:onPlayerKilledPed",function(ar)
    tARMA.addKillEffect(ar, false)
end)

local aA = {
    [0x0] = "body",
    [0x2E28] = "body",
    [0xE39F] = "legs",
    [0xF9BB] = "legs",
    [0x3779] = "legs",
    [0x83C] = "legs",
    [0xCA72] = "legs",
    [0x9000] = "legs",
    [0xCC4D] = "legs",
    [0x512D] = "legs",
    [0xE0FD] = "body",
    [0x5C01] = "body",
    [0x60F0] = "body",
    [0x60F1] = "body",
    [0x60F2] = "body",
    [0xFCD9] = "body",
    [0xB1C5] = "arms",
    [0xEEEB] = "arms",
    [0x49D9] = "arms",
    [0x67F2] = "arms",
    [0xFF9] = "arms",
    [0xFFA] = "arms",
    [0x67F3] = "arms",
    [0x1049] = "arms",
    [0x104A] = "arms",
    [0x67F4] = "arms",
    [0x1059] = "arms",
    [0x105A] = "arms",
    [0x67F5] = "arms",
    [0x1029] = "arms",
    [0x102A] = "arms",
    [0x67F6] = "arms",
    [0x1039] = "arms",
    [0x103A] = "arms",
    [0x29D2] = "arms",
    [0x9D4D] = "arms",
    [0x6E5C] = "arms",
    [0xDEAD] = "arms",
    [0xE5F2] = "arms",
    [0xFA10] = "arms",
    [0xFA11] = "arms",
    [0xE5F3] = "arms",
    [0xFA60] = "arms",
    [0xFA61] = "arms",
    [0xE5F4] = "arms",
    [0xFA70] = "arms",
    [0xFA71] = "arms",
    [0xE5F5] = "arms",
    [0xFA40] = "arms",
    [0xFA41] = "arms",
    [0xE5F6] = "arms",
    [0xFA50] = "arms",
    [0xFA51] = "arms",
    [0x9995] = "head",
    [0x796E] = "head",
    [0x5FD4] = "head",
    [0xD003] = "body",
    [0x45FC] = "body",
    [0x1D6B] = "legs",
    [0xB23F] = "legs"
}
AddEventHandler("ARMA:onPlayerDamagePed",function(az)
    if not tARMA.isPlusClub() and not tARMA.isPlatClub() then
        return
    end
    local aB, ax = GetPedLastDamageBone(az, 0)
    if aB then
        local aC = GetPedBoneIndex(az, ax)
        local aD = GetWorldPositionOfEntityBone(az, aC)
        local aE = aA[ax]
        if not aE then
            local aF = GetWorldPositionOfEntityBone(az, GetPedBoneIndex(az, 0x9995))
            local aG = GetWorldPositionOfEntityBone(az, GetPedBoneIndex(az, 0x2E28))
            if aD.z >= aF.z - 0.01 then
                aE = "head"
            elseif aD.z < aG.z then
                aE = "legs"
            else
                local aH = GetEntityCoords(az, true)
                local aI = #(aH.xy - aD.xy)
                if aI > 0.075 then
                    aE = "arms"
                else
                    aE = "body"
                end
            end
        end
        tARMA.addBloodEffect(aE, ax, az)
    end
end)
