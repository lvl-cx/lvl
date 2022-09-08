local a = module("cfg/cfg_emotes")
RMenu.Add("emotesmenu","mainmenu",RageUI.CreateMenu("","Main Menu",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "emotes"))
RMenu.Add("emotesmenu","emotes",RageUI.CreateSubMenu(RMenu:Get("emotesmenu", "mainmenu"),"","Emotes",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "emotes"))
RMenu.Add("emotesmenu","danceemotes",RageUI.CreateSubMenu(RMenu:Get("emotesmenu", "emotes"),"","Dance Emotes",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "emotes"))
RMenu.Add("emotesmenu","customemotes",RageUI.CreateSubMenu(RMenu:Get("emotesmenu", "emotes"),"","Custom Emotes",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "emotes"))
RMenu.Add("emotesmenu","propemotes",RageUI.CreateSubMenu(RMenu:Get("emotesmenu", "emotes"),"","Prop Emotes",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "emotes"))
RMenu.Add("emotesmenu","sharedemotes",RageUI.CreateSubMenu(RMenu:Get("emotesmenu", "emotes"),"","Shared Emotes",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "emotes"))
RMenu.Add("emotesmenu","walkingstyles",RageUI.CreateSubMenu(RMenu:Get("emotesmenu", "emotes"),"","Walking Styles",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "emotes"))
RMenu.Add("emotesmenu","moods",RageUI.CreateSubMenu(RMenu:Get("emotesmenu", "emotes"),"","Moods",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners", "emotes"))
local b = false
local c = ""
local d = {}
local e = 0
local f = nil
local g = 0
local h = nil
local i = 0
local j = 0
local function k()
    for l, prop in pairs(d) do
        DeleteEntity(prop)
    end
    d = {}
end
local function m()
    if not b then
        return
    end
    if GetGameTimer() - e < 1500 then
        tARMA.notify("~r~Emotes are being rate limited.")
        return
    end
    b = false
    if c == "Scenario" or c == "MaleScenario" then
        ClearPedTasksImmediately(PlayerPedId())
    else
        ClearPedTasks(PlayerPedId())
        k()
    end
end
local function n(o, p, q, r, s, t, u, v)
    local w = PlayerPedId()
    local x = GetEntityCoords(w, true)
    tARMA.loadModel(o)
    prop = CreateObject(GetHashKey(o), x.x, x.y, x.z + 0.2, true, true, true)
    AttachEntityToEntity(prop, w, GetPedBoneIndex(w, p), q, r, s, t, u, v, true, true, false, true, 1, true)
    table.insert(d, prop)
    SetModelAsNoLongerNeeded(o)
end
local function y(z)
    SetFacialIdleAnimOverride(PlayerPedId(), z[2], nil)
    b = true
end
local function A(z)
    if tARMA.getPlayerVehicle() ~= 0 then
        tARMA.notify("~r~Can not use scenarios whilst in a vehicle.")
        return
    end
    local w = PlayerPedId()
    if z[1] == "Scenario" then
        ClearPedTasks(w)
        TaskStartScenarioInPlace(w, z[2], 0, true)
    elseif z[1] == "MaleScenario" then
        if tARMA.getModelGender() == "male" then
            ClearPedTasks(w)
            TaskStartScenarioInPlace(w, z[2], 0, true)
        else
            tARMA.notify("~r~This scenario is male only.")
        end
    elseif z[1] == "ScenarioObject" then
        local B = GetOffsetFromEntityInWorldCoords(w, 0.0, 0 - 0.5, -0.5)
        ClearPedTasks(w)
        TaskStartScenarioAtPosition(w, z[2], B.x, B.y, B.z, GetEntityHeading(w), 0, true, false)
    end
    b = true
end
local function C(z)
    local D = z.animationOptions
    if tARMA.getPlayerVehicle() ~= 0 then
        return 51
    elseif not D then
        return 0
    elseif D.emoteLoop then
        if D.emoteMoving then
            return 51
        else
            return 1
        end
    elseif D.emoteMoving then
        return 51
    elseif not D.emoteMoving then
        return 0
    elseif D.emoteMoving then
        return 50
    end
    return 0
end
local function E(z)
    if z.animationOptions then
        return z.animationOptions.emoteDuration or -1
    else
        return -1
    end
end
local function F(z)
    local D = z.animationOptions
    if not D then
        return
    end
    local G = D.prop
    if not G then
        return
    end
    local H = D.propBone
    local I, J, K, L, M, N = table.unpack(D.propPlacement)
    n(G, H, I, J, K, L, M, N)
    local O = D.secondProp
    if not O then
        return
    end
    local P = D.secondPropBone
    local Q, R, S, T, U, V = table.unpack(D.secondPropPlacement)
    n(O, P, Q, R, S, T, U, V)
end
local function W(z)
    local X, Y = table.unpack(z)
    local Z = C(z)
    local _ = E(z)
    tARMA.loadAnimDict(X)
    TaskPlayAnim(PlayerPedId(), X, Y, 2.0, 2.0, _, Z, 0, false, false, false)
    RemoveAnimDict(X)
    b = true
    F(z)
end
local function a0()
    local w = PlayerPedId()
    return IsPedReloading(w) or IsPlayerFreeAiming(w) or not tARMA.canAnim() or tARMA.isPlayerInRedZone() or GetEntityHealth(w) <= 102 -- add check for in isPlayerNearPrison()
end
local function a1(z)
    if a0() then
        tARMA.notify("~r~Can not use emotes at this time.")
        return
    end
    if GetGameTimer() - e < 1500 then
        tARMA.notify("~r~Emotes are being rate limited.")
        return
    end
    k()
    local type = z[1]
    c = type
    e = GetGameTimer()
    if type == "Expression" then
        y(z)
        return
    end
    if type == "Scenario" or type == "MaleScenario" or type == "ScenarioObject" then
        A(z)
        return
    end
    W(z)
end
local function a2()
    local a3 = PlayerId()
    local a4 = -1
    local a5 = 2.0
    local a6 = tARMA.getPlayerCoords()
    for l, a7 in pairs(GetActivePlayers()) do
        if a7 ~= a3 then
            local a8 = GetPlayerPed(a7)
            local a9 = #(GetEntityCoords(a8, true) - a6)
            if a9 < a5 then
                a4 = a7
                a5 = a9
            end
        end
    end
    if a4 == -1 then
        return 0
    else
        return GetPlayerServerId(a4)
    end
end
local function aa(ab)
    if a0() then
        tARMA.notify("~r~Can not use emotes at this time.")
        return
    end
    local ac = a2()
    if ac ~= 0 then
        f = ab
        g = ac
        TriggerServerEvent("ARMA:sendSharedEmoteRequest", ac, ab)
    else
        tARMA.notify("~r~No player is near by.")
    end
end
local function ad(z)
    Citizen.CreateThreadNow(
        function()
            local ae = z[1]
            tARMA.loadAnimDict(ae)
            SetPedMovementClipset(PlayerPedId(), ae, 0.2)
            RemoveAnimSet(ae)
        end
    )
end
local function af(ag, ah)
    local ai, aj = type(ag), type(ah)
    if ai ~= aj then
        return ai < aj
    else
        return ag < ah
    end
end
local function ak(al, am)
    local an = {}
    local ao = 1
    for ap in pairs(al) do
        an[ao] = ap
        ao = ao + 1
    end
    am = am or af
    table.sort(an, am)
    return an
end
local function aq(al, am)
    local an = ak(al, am)
    local ar = 0
    return function()
        ar = ar + 1
        local ap = an[ar]
        if ap ~= nil then
            return ap, al[ap]
        else
            return nil, nil
        end
    end
end


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('emotesmenu', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Emotes","",{RightLabel = ""},true,function()
            end,RMenu:Get("emotesmenu", "emotes"))
            RageUI.ButtonWithStyle("Cancel Emotes","",{RightLabel = ""},true,function(as, at, au)
                if au then
                    m()
                    e = GetGameTimer()
                end
            end)
            RageUI.ButtonWithStyle("Walking Styles","",{RightLabel = ""},true,function()
            end,RMenu:Get("emotesmenu", "walkingstyles"))
            RageUI.ButtonWithStyle("Moods","",{RightLabel = ""},true,function()
            end,RMenu:Get("emotesmenu", "moods"))
        end)
    end
    if RageUI.Visible(RMenu:Get('emotesmenu', 'emotes')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("🕺 Dance Emotes","",{RightLabel = ""},true,function()
            end,RMenu:Get("emotesmenu", "danceemotes"))
            -- don't have their .ycd atm for custom emotes :(
            -- RageUI.ButtonWithStyle("🛠️ Custom Emotes","",{RightLabel = ""},true,function()
            -- end,RMenu:Get("emotesmenu", "customemotes"))
            RageUI.ButtonWithStyle("📦 Prop Emotes","",{RightLabel = ""},true,function()
            end,RMenu:Get("emotesmenu", "propemotes"))
            RageUI.ButtonWithStyle("👫 Shared Emotes","",{RightLabel = ""},true,function()
            end,RMenu:Get("emotesmenu", "sharedemotes"))
            for av, z in aq(a.emotes) do
                RageUI.ButtonWithStyle(z[3],"/e (" .. av .. ")",{RightLabel = ""},true,function(as, at, au)
                    if au then
                        a1(z)
                    end
                end)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('emotesmenu', 'danceemotes')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for av, z in aq(a.dances) do
                RageUI.ButtonWithStyle(z[3],"/e (" .. av .. ")",{RightLabel = ""},true,function(as, at, au)
                    if au then
                        a1(z)
                    end
                end)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('emotesmenu', 'customemotes')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for av, z in aq(a.custom) do
                RageUI.ButtonWithStyle(z[3],"/e (" .. av .. ")",{RightLabel = ""},true,function(as, at, au)
                    if au then
                        a1(z)
                    end
                end)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('emotesmenu', 'propemotes')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for av, z in aq(a.props) do
                RageUI.ButtonWithStyle(z[3],"/e (" .. av .. ")",{RightLabel = ""},true,function(as, at, au)
                    if au then
                        a1(z)
                    end
                end)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('emotesmenu', 'sharedemotes')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for ab, z in aq(a.shared) do
                if not z.animationOptions or not z.animationOptions.invisible then
                    RageUI.ButtonWithStyle(z[3],"/nearby (~g~" .. ab .. "~w~)",{RightLabel = ""},true,function(as, at, au)
                        if au then
                            aa(ab)
                        end
                    end)
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('emotesmenu', 'walkingstyles')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Normal (Reset)","",{RightLabel = ""},true,function(as, at, au)
                if au then
                    ResetPedMovementClipset(PlayerPedId())
                end
            end)
            for ab, z in aq(a.walks) do
                RageUI.ButtonWithStyle(ab,"",{RightLabel = ""},true,function(as, at, au)
                    if au then
                        ad(z)
                    end
                end)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('emotesmenu', 'moods')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Normal (Reset)","",{RightLabel = ""},true,function(as, at, au)
                if au then
                    ClearFacialIdleAnimOverride(PlayerPedId())
                end
            end)
            for ab, z in aq(a.moods) do
                RageUI.ButtonWithStyle(ab,"",{RightLabel = ""},true,function(as, at, au)
                    if au then
                        a1(z)
                    end
                end)
            end
        end)
    end
end)

RegisterCommand("emotemenu",function(aw, ax, ay)
    RageUI.Visible(RMenu:Get("emotesmenu", "mainmenu"), not RageUI.Visible(RMenu:Get("emotesmenu", "mainmenu")))
end,false)

RegisterKeyMapping("emotemenu", "Toggles the emote menu", "KEYBOARD", "F3")
local function az(aw, ax, ay)
    if #ax < 1 then
        tARMA.notify("~r~No emote name was specified.")
        return
    end
    local ab = string.lower(ax[1])
    if not ab then
        tARMA.notify("~r~No emote name was specified.")
        return
    elseif ab == "c" then
        m()
        return
    end
    if a.emotes[ab] then
        a1(a.emotes[ab])
    elseif a.dances[ab] then
        a1(a.dances[ab])
    elseif a.custom[ab] then
        a1(a.custom[ab])
    elseif a.props[ab] then
        a1(a.props[ab])
    else
        tARMA.notify("~r~Invalid emote name was specified.")
    end
end
RegisterCommand("e", az, false)
RegisterCommand("emote", az, false)
RegisterCommand("nearby",function(aw, ax, ay)
    if #ax < 1 then
        tARMA.notify("~r~No emote name was specified.")
        return
    end
    local ab = string.lower(ax[1])
    if not ab then
        tARMA.notify("~r~No emote name was specified.")
        return
    end
    if a.shared[ab] then
        aa(ab)
    else
        tARMA.notify("~r~Invalid emote name was specified.")
    end
end)
RegisterCommand("walk",function(aw, ax, ay)
    if #ax < 1 then
        tARMA.notify("~r~No walk name was specified.")
        return
    end
    local ab = ax[1]
    if not ab then
        tARMA.notify("~r~No walk name was specified.")
        return
    end
    if a.walks[ab] then
        ad(a.walks[ab])
    else
        tARMA.notify("~r~Invalid walk name was specified.")
    end
end)
RegisterNetEvent("ARMA:sendSharedEmoteRequest",function(aA, ab)
    if a.shared[ab] and not a0() then
        h = ab
        i = aA
        j = GetGameTimer()
        tARMA.notify("~y~Y~w~ to accept, ~r~L~w~ to refuse (~g~" .. a.shared[ab][3] .. "~w~)")
    end
end)
RegisterNetEvent("ARMA:receiveSharedEmoteRequest",function(ab)
    m()
    Citizen.Wait(300)
    a1(a.shared[ab])
end)

RegisterNetEvent("ARMA:receiveSharedEmoteRequestSource",function()
    local aB = GetPlayerFromServerId(g)
    if aB == -1 then
        return
    end
    local aC = GetPlayerPed(aB)
    if aC == 0 then
        return
    end
    local aD = GetEntityHeading(aC)
    local x = GetOffsetFromEntityInWorldCoords(aC, 0.0, 1.0, 0.0)
    local z = a.shared[f]
    if z.animationOptions and z.animationOptions.syncOffsetFront then
        x = GetOffsetFromEntityInWorldCoords(aC, 0.0, z.animationOptions.syncOffsetFront, 0.0)
    end
    local w = PlayerPedId()
    SetEntityHeading(w, aD - 180.1)
    SetEntityCoordsNoOffset(w, x.x, x.y, x.z, 0)
    m()
    Citizen.Wait(300)
    a1(z)
end)
local function aE()
    h = nil
    i = 0
    j = 0
end
Citizen.CreateThread(function()
    TriggerEvent("chat:addSuggestion","/e","Play an emote",{{name = "emotename", help = "dance, camera, sit or any valid emote."}})
    TriggerEvent("chat:addSuggestion","/emote","Play an emote",{{name = "emotename", help = "dance, camera, sit or any valid emote."}})
    TriggerEvent("chat:addSuggestion", "/emotemenu", "Open emotes menu (F3) by default.")
    TriggerEvent("chat:addSuggestion","/walk","Set your walkingstyle.",{{name = "style", help = "/walks for a list of valid styles"}})
    while true do
        if h then
            if GetGameTimer() - j > 5000 then
                aE()
            elseif IsControlJustPressed(1, 246) then
                if a0() then
                    tARMA.notify("~r~You can not use emotes at this time.")
                else
                    TriggerServerEvent("ARMA:receiveSharedEmoteRequest", i, a.shared[h][4])
                end
                aE()
            end
        end
        Citizen.Wait(0)
    end
end)
