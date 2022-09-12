RMenu.Add('SettingsMenu', 'MainMenu', RageUI.CreateMenu("", "~b~Settings Menu", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "banners","settings")) 
RMenu.Add("SettingsMenu", "crosshairsettings", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu"), "", '~b~Crosshair Settings',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners","settings"))
RMenu.Add("SettingsMenu", "graphicpresets", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu"), "", '~b~Graphics Presets',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners","settings"))
RMenu.Add("SettingsMenu", "killeffects", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu"), "", '~b~Kill Effects',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners","settings"))


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

function tARMA.setHitMarkerSetting(i)
    SetResourceKvp("arma_hitmarkersounds", tostring(i))
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
        TriggerEvent("ARMA:hsSounds", d)
    else
        d = true
        TriggerEvent("ARMA:hsSounds", d)
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
            RageUI.Checkbox("Toggle Compass", nil, compasschecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if Selected then
                    compasschecked = not compasschecked
                    ExecuteCommand("compass")
                end
            end)
--[[             local function _()
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
            end,_,a0) ]]
            RageUI.Checkbox("Streetnames","",tARMA.isStreetnamesEnabled(),{Style = RageUI.CheckboxStyle.Car},function(W, Y, X, a1)
            end,function()tARMA.setStreetnamesEnabled(true)end,function()tARMA.setStreetnamesEnabled(false)end)
            local function _()
                d = true
                TriggerEvent("ARMA:hsSounds", d)
                tARMA.setHitMarkerSetting(d)
                tARMA.notify("~y~Experimental Headshot sounds now set to " .. tostring(d))
            end
            local function a0()
                d = false
                TriggerEvent("ARMA:hsSounds", d)
                tARMA.setHitMarkerSetting(d)
                tARMA.notify("~y~Experimental Headshot sounds now set to " .. tostring(d))
            end
            RageUI.Checkbox("Enable Experimental Hit Marker Sounds","~g~This adds 'hit marker' sounds when shooting another player, however it can be unreliable.",d,{Style = RageUI.CheckboxStyle.Car},function(W, Y, X, a1)
            end,_,a0)
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
            end
            local function a0()
                tARMA.toggleBlackBars()
                e = false
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
            RageUI.ButtonWithStyle("Kill Effects","Toggle effects that occur on killing a player.",,{RightLabel = "→→→"},true,function()
            end,RMenu:Get("SettingsMenu", "killeffects"))
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