local a = false
local b = false
local c = nil
local d = false
local e = false
RegisterNetEvent("playRussianRoulette",function(f)
    local g = GetEntityCoords(tARMA.getPlayerPed())
    local h = #(g - f)
    if h <= 15 then
        SendNUIMessage({transactionType = "playRussianRoulette"})
    end
end)
RegisterNetEvent("playEmptyGun",function(f)
    local g = GetEntityCoords(tARMA.getPlayerPed())
    local h = #(g - f)
    if h <= 15 then
        SendNUIMessage({transactionType = "emptygun"})
    end
end)

function tARMA.putInNearestVehicleAsPassenger(i)
    local j = tARMA.getNearestVehicle(i)
    if IsEntityAVehicle(j) then
        for k = 1, math.max(GetVehicleMaxNumberOfPassengers(j), 3) do
            if IsVehicleSeatFree(j, k) then
                SetPedIntoVehicle(tARMA.getPlayerPed(), j, k)
                return true
            end
        end
    end
    return false
end
function tARMA.putInNetVehicleAsPassenger(l)
    local j = tARMA.getObjectId(l)
    if IsEntityAVehicle(j) then
        for k = 1, GetVehicleMaxNumberOfPassengers(j) do
            if IsVehicleSeatFree(j, k) then
                SetPedIntoVehicle(tARMA.getPlayerPed(), j, k)
                return true
            end
        end
    end
end
function tARMA.putInVehiclePositionAsPassenger(m, n, o)
    local j = tARMA.getVehicleAtPosition(m, n, o)
    if IsEntityAVehicle(j) then
        for k = 1, GetVehicleMaxNumberOfPassengers(j) do
            if IsVehicleSeatFree(j, k) then
                SetPedIntoVehicle(tARMA.getPlayerPed(), j, k)
                return true
            end
        end
    end
end
RegisterNetEvent("ARMA:knockOut",function()
    a = true
end)
RegisterNetEvent("ARMA:knockOutDisable",function()
    a = false
end)
RegisterNetEvent("ARMA:drag")
AddEventHandler("ARMA:drag",function(p)
    c = p
    d = not d
end)
RegisterNetEvent("ARMA:undrag")
AddEventHandler("ARMA:undrag",function(p)
    d = false
end)
RegisterNetEvent("ARMA:clearPoliceStuff",function()
    stopAutoClosingInventory = false
    SetTimeout(10000,function()
        stopAutoClosingInventory = true
    end)
    while not stopAutoClosingInventory do
        drawInventoryUI = false
        Wait(0)
    end
end)

TriggerEvent("chat:addSuggestion","/s60","Authorise a new Section 60 order",{{name = "Radius", help = "In metres"}, {name = "Duration", help = "In Minutes"}})
local q = {}
RegisterNetEvent("ARMA:addS60",function(r, s, t)
    local u = AddBlipForCoord(r.x, r.y, r.z)
    local v = AddBlipForRadius(r.x, r.y, r.z, s + .0)
    local w = 61
    SetBlipSprite(u, 526)
    SetBlipColour(u, w)
    SetBlipScale(u, 1.0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Section 60")
    EndTextCommandSetBlipName(u)
    SetBlipAlpha(v, 80)
    SetBlipColour(v, w)
    q[t] = {v, u}
    local x = GetStreetNameAtCoord(r.x, r.y, r.z)
    local y = GetStreetNameFromHashKey(x)
    TriggerEvent("ARMA:showNotification",
    {
        text = "Metropolitan Police: <br/>A Section 60 has been authorised for the area of " .. y .. ".<br/><br/>This gives officers the power to search any person or vehicle in the area, without any grounds. <br/><br/>This has been authorised in line with legislation.",
        height = "auto",
        width = "auto",
        colour = "#FFF",
        background = "#3287cd",
        pos = "bottom-right",
        icon = "success"
    },
    100000)
end)

RegisterNetEvent("ARMA:removeS60",function(t)
    local z = q[t]
    local u = z[2]
    local s = z[1]
    RemoveBlip(u)
    RemoveBlip(s)
end)

Citizen.CreateThread(function()
    tARMA.loadAnimDict("mp_arresting")
    tARMA.loadAnimDict("random@arrests")
    tARMA.loadAnimDict("missminuteman_1ig_2")
    while true do
        if d and c ~= nil then
            DisableControlAction(0, 21, true)
            local A = GetPlayerPed(GetPlayerFromServerId(c))
            local B = tARMA.getPlayerPed()
            AttachEntityToEntity(B, A, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2)
            e = true
        else
            if e then
                DetachEntity(tARMA.getPlayerPed(), true, false)
                e = false
            end
        end
        if IsControlPressed(0, 323) or IsControlPressed(0, 27) and not IsUsingKeyboard(2) then
            if not globalSurrenderring and not tARMA.isInComa() and not tARMA.isHandcuffed() and tARMA.canAnim() then
                DisablePlayerFiring(tARMA.getPlayerPed(), true)
                DisableControlAction(0, 22, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 154, true)
                if not IsEntityDead(tARMA.getPlayerPed()) then
                    if not b and not GetIsTaskActive(tARMA.getPlayerPed(), 298) then
                        b = true
                        TaskPlayAnim(tARMA.getPlayerPed(),"missminuteman_1ig_2","handsup_enter",7.0,1.0,-1,50,0,false,false,false)
                    end
                end
            end
        end
        if (IsControlJustReleased(1, 323) or IsControlJustReleased(1, 27)) and not globalSurrenderring and b and not tARMA.isInComa() and not tARMA.isHandcuffed() and tARMA.canAnim() then
            b = false
            CreateThread(function()
                local C = false
                CreateThread(function()
                    Wait(1000)
                    C = true
                end)
                while not C do
                    DisablePlayerFiring(tARMA.getPlayerPed(), true)
                    Wait(1)
                end
            end)
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 137, true)
            ClearPedTasks(tARMA.getPlayerPed())
        end
        if a then
            SetPedToRagdoll(tARMA.getPlayerPed(), 1000, 1000, 0, 0, 0, 0)
            tARMA.notify("~r~You have been knocked out!")
        end
        Wait(0)
    end
end)
function tARMA.isBeingDragged()
    return d
end

RMenu.Add("policehandbook","main",RageUI.CreateMenu("Police Handbook", "~b~Officer Handbook", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight()))
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('policehandbook', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Button("Arrest",nil,{},true,function(D, E, F)
                if F then
                    TriggerEvent("ARMA:showNotification",
                    {
                        text = "The time now is ___. <br/>You are currently under arrest on suspision of ___. <br/>You do not have to say anything. But, it may harm your defence if you do not mention when questioned something which you later rely on in court. <br/>Anything you do say may be given in evidence. <br/>Do you understand?. <br/>The necessities for your arrest are to ___.",
                        height = "auto",
                        width = "auto",
                        colour = "#FFF",
                        background = "#3287cd",
                        pos = "bottom-right",
                        icon = "success"
                    },
                    100000)
                end
            end)
            RageUI.Button("Search - GOWISELY",nil,{},true,function(D, E, F)
                if F then
                    TriggerEvent("ARMA:showNotification",
                    {
                        text = "Before you stop and search someone you must remember GO-WISELY. <br/>You do not have to use this after arrest. <br/>Grounds: for the search. <br/>Object: of the search. <br/>Warrant card: If not in uniform. <br/>Identity: I am PC ___. <br/>Station: attached to ___ Police Station. <br/>Entitlement: Entitled to a copy of this search up to ___ months. <br/>Legal power: Searching under s1 PACE (1984) / s23 MODA (1971). <br/>You: You are currently detained for the purpose of a search.",
                        height = "auto",
                        width = "auto",
                        colour = "#FFF",
                        background = "#3287cd",
                        pos = "bottom-right",
                        icon = "success"
                    },
                    100000)
                end
            end)
            RageUI.Button("PACE - Key Legislation",nil,{},true,function(D, E, F)
                if F then
                    TriggerEvent("ARMA:showNotification",
                    {
                        text = "Police and Criminal Evidence Act 1984  - PACE.<br/> Section 1 - Stop and search (Stolen property, prohibited articles, weapons, articles used to commit an offence.<br/>Section 17 - Entry for the purpose of life and arrest<br/> Section 18 - Entry to search after an arrest <br/>Section 19 - Power of seizure<br/> Section 24 - Power of arrest <br/> Section 32 - Search after an arrest",
                        height = "auto",
                        width = "auto",
                        colour = "#FFF",
                        background = "#3287cd",
                        pos = "bottom-right",
                        icon = "success"
                    },
                    100000)
                end
            end)
            RageUI.Button("Identify Codes",nil,{},true,function(D, E, F)
                if F then
                    TriggerEvent("ARMA:showNotification",
                    {
                        text = "IC1:~s~ White - North European. <br/>IC2: White - South European. <br/>IC3: Black. <br/>IC4: Asian. <br/>IC5: Chinese, Japanese or other South East Asian. <br/>IC6: Arabic or North African. <br/>IC9: Unknown",
                        height = "auto",
                        width = "auto",
                        colour = "#FFF",
                        background = "#3287cd",
                        pos = "bottom-right",
                        icon = "success"
                    },
                    100000)
                end
            end)
            RageUI.Button("Traffic Offence Report",nil,{},true,function(D, E, F)
                if F then
                    TriggerEvent("ARMA:showNotification",
                    {
                        text = "I am reporting you for consideration of the question of prosecuting you for the offence(s) of ___. <br/><br/>You do not have to say anything but it may harm your defence if you do not mention NOW something which you may later rely on in court. Anything you do say may be given in evidence. <br/><br/>You are not under arrest - you are entitled to legal advice and you are not obliged to remain with me.",
                        height = "auto",
                        width = "auto",
                        colour = "#FFF",
                        background = "#3287cd",
                        pos = "bottom-right",
                        icon = "success"
                    },
                    100000)
                end
            end)
            RageUI.Button("Initial Phase Pursuit",nil,{},true,function(D, E, F)
                if F then
                    TriggerEvent("ARMA:showNotification",
                    {
                        text = "VEHICLE DESCRIPTION: MAKE/MODEL/VRM. <br/>LOCATION & DIRECTION: ___. <br/>SPEED: ___. <br/>VEHICLE DENSITY: LOW/MED/HIGH. <br/>PEDESTRIAN DENSITY: LOW/MED/HIGH. <br/>ROAD CONDITIONS: WET/DRY/DIRT. <br/>WEATHER: CLEAR/LIGHT/DARK. <br/>VISIBILITY: CLEAR/MED/LOW. <br/>DRIVER CLASSIFICATION: IPP/ADV/TPAC. <br/>POLICE VEHICLE: MARKED/UNMARKED",
                        height = "auto",
                        width = "auto",
                        colour = "#FFF",
                        background = "#3287cd",
                        pos = "bottom-right",
                        icon = "success"
                    },
                    100000)
                end
            end)
            RageUI.Button("Warning Markers",nil,{},true,function(D, E, F)
                if F then
                    TriggerEvent("ARMA:showNotification",
                    {
                        text = "FI: FIREARMS. <br/>WE: WEAPONS. <br/>XP: EXPLOSIVES. <br/>VI: VIOLENT. <br/>CO: CONTAGIOUS. <br/>ES: ESCAPER. <br/>AG: ALLEGES. <br/>AT: AILMENT. <br/>SU: SUICIDAL. <br/>MH: MENTAL HEALTH. <br/>DR: DRUGS. <br/>IM: MALE IMPERSONATOR. <br/>IF: FEMALE IMPERSONATOR",
                        height = "auto",
                        width = "auto",
                        colour = "#FFF",
                        background = "#3287cd",
                        pos = "bottom-right",
                        icon = "success"
                    },
                    100000)
                end
            end)
            RageUI.Button("s136 - Mental Healt Act",nil,{},true,function(D, E, F)
                if F then
                    TriggerEvent("ARMA:showNotification",
                    {
                        text = "A constable may take a person to (or keep at) a place of a safety. <br/>This can be done without a warrant if: The individual appears to have a mental disorder, and they are in any place other than a house, flat or room where a person is living, or garden or garage that only one household has access to, and they are in need of immediate care or control. <br/><br/>A registered medical practitioner/healthcare professional must be consulted if practicable to do so.",
                        height = "auto",
                        width = "auto",
                        colour = "#FFF",
                        background = "#3287cd",
                        pos = "bottom-right",
                        icon = "success"
                    },
                    100000)
                end
            end)
            RageUI.Button("Arrest Necessities",nil,{},true,function(D, E, F)
                if F then
                    TriggerEvent("ARMA:showNotification",
                    {
                        text = "You require at least two of the following necessities to arrest a suspect: <br/><br/>Investigation: conduct a prompt and effective. <br/>Disappearance: prevent the prosecution being hindered. <br/>Child or Vulnerable person: to protect a. <br/>Obstruction: of the highway unlawfully (preventing). <br/>Physical Injury: prevent to themselves or other person. <br/>Public Decency: prevent an offence being committed against. <br/>Loss or Damage: prevent to property. <br/>Address: enable to be ascertained (not readily available). <br/>Name: enable to be ascertained (not readily available).",
                        height = "auto",
                        width = "auto",
                        colour = "#FFF",
                        background = "#3287cd",
                        pos = "bottom-right",
                        icon = "success"
                    },
                    100000)
                end
            end)
        end)
    end
end)
TriggerEvent("chat:addSuggestion", "/handbook", "Toggle the Police Handbook")
RegisterNetEvent("ARMA:toggleHandbook",function()
    RageUI.Visible(RMenu:Get("policehandbook", "main"), true)
end)
RegisterNetEvent("playBreathalyserSound",function(r)
    Citizen.SetTimeout(10000,function()
        local g = tARMA.getPlayerCoords()
        local h = #(g - r)
        if h <= 15 then
            SendNUIMessage({transactionType = "breathalyser"})
        end
    end)
end)
TriggerEvent("chat:addSuggestion", "/breathalyse", "Breathalyse the nearest person")
RegisterNetEvent("ARMA:breathTestResult",function(G, H)
    local I = H
    RequestAnimDict("weapons@first_person@aim_rng@generic@projectile@shared@core")
    while not HasAnimDictLoaded("weapons@first_person@aim_rng@generic@projectile@shared@core") do
        Wait(0)
    end
    TaskPlayAnim(tARMA.getPlayerPed(),"weapons@first_person@aim_rng@generic@projectile@shared@core","idlerng_med",1.0,-1,10000,50,0,false,false,false)
    RageUI.Text({message = "~w~You are now ~b~breathalysing ~b~" .. I .. "~w~, please wait for the results."})
    Citizen.SetTimeout(10000,function()
        if G < 36 then
            RageUI.Text({message = "~w~The suspect has provided a legal breathalyser sample of ~b~" ..G .. " ~w~µg/100ml."})
        else
            RageUI.Text({message = "~w~The suspect has provided an illegal breathalyser sample of ~b~" ..G .. " ~w~µg/100ml."})
        end
    end)
end)
RegisterNetEvent("ARMA:beingBreathalysed",function()
    RageUI.Text({message = "~w~You are currently being ~b~breathalysed ~w~by a police officer."})
end)
RegisterNetEvent("ARMA:breathalyserCommand",function()
    local A = tARMA.getPlayerPed()
    if not IsPedInAnyVehicle(A, true) then
        local r = GetEntityCoords(A)
        local J = GetActivePlayers()
        for K, L in pairs(J) do
            if GetPlayerPed(L) ~= A then
                local M = GetEntityCoords(GetPlayerPed(L))
                local N = #(r - M)
                if N < 3.0 then
                    local O = GetPlayerServerId(L)
                    TriggerServerEvent("ARMA:breathalyserRequest", O)
                    break
                end
            end
        end
    end
end)
TriggerEvent("chat:addSuggestion", "/wc", "Flash your police warrant card.")
TriggerEvent("chat:addSuggestion", "/wca", "Flash your police warrant card.")
RegisterNetEvent("ARMA:flashWarrantCard",function()
    local A = PlayerPedId()
    local P = tARMA.loadModel("prop_fib_badge")
    local Q = CreateObject(P, 0, 0, 0, true, true, true)
    while not DoesEntityExist(Q) do
        Wait(0)
    end
    FreezeEntityPosition(Q)
    AttachEntityToEntity(Q,A,GetPedBoneIndex(A, 58866),0.03,-0.05,-0.044,0.0,90.0,25.0,true,true,false,true,1,true)
    Wait(3000)
    DeleteObject(Q)
end)
RMenu.Add("vehicleExtraMenu","main",RageUI.CreateMenu("Vehicle Extra Menu", "~b~Development", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight()))
RegisterCommand("extras",function(R, S)
    local T = R
    if tARMA.getStaffLevel() >= 11 then
        RageUI.Visible(RMenu:Get("vehicleExtraMenu", "main"), true)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('vehicleExtraMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            local V = tARMA.getPlayerVehicle()
            if V ~= 0 then
                RMenu:Get("vehicleExtraMenu", "main"):SetSubtitle("Vehicle Model: " .. GetDisplayNameFromVehicleModel(GetEntityModel(V)))
                for k = 1, 12 do
                    if DoesExtraExist(V, k) then
                        if IsVehicleExtraTurnedOn(V, k) then
                            RageUI.Button("Disable Extra " .. k,nil,{RightLabel = tostring(k)},true,function(D, E, F)
                                if F then
                                    SetVehicleExtra(V, k, true)
                                end
                            end)
                        else
                            RageUI.Button("Enable Extra " .. k,nil,{RightLabel = tostring(k)},true,function(D, E, F)
                                if F then
                                    SetVehicleExtra(V, k, false)
                                end
                            end)
                        end
                    end
                end
            end
        end)
    end
end)

RMenu.Add("incidentsupportunit","main",RageUI.CreateMenu("Incident Support Unit", "~b~Control Panel", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight()))
local W = {active = false, signUp = false, flashing = false, accidentSign = false, aheadSign = false}
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('incidentsupportunit', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            local V = tARMA.getPlayerVehicle()
            if GetEntityModel(V) == "incidentsupportunit" then
                W.active = true
                RageUI.Checkbox("Vehicle Sign Up","Toggle the vehicle sign on/off",W.signUp,{Style = RageUI.CheckboxStyle.Car},function(D, F, E, X)
                    if F then
                        if W.signUp then
                            RageUI.Text({message = string.format("~w~Sign is now ~g~~h~up")})
                            SetVehicleExtra(V, 12, false)
                            SetVehicleExtra(V, 11, true)
                            SetVehicleExtra(V, 5, true)
                            SetVehicleExtra(V, 6, true)
                        else
                            RageUI.Text({message = string.format("~w~Sign is now ~g~~h~down")})
                            SetVehicleExtra(V, 12, true)
                            SetVehicleExtra(V, 5, true)
                            SetVehicleExtra(V, 6, true)
                            SetVehicleExtra(V, 11, false)
                        end
                    end
                    W.signUp = X
                end)
                if W.signUp then
                    RageUI.Checkbox("Accident Message","Toggle the vehicle accident sign on/off",W.accidentSign,{Style = RageUI.CheckboxStyle.Car},function(D, F, E, X)
                        if F then
                            if W.accidentSign then
                                RageUI.Text({message = string.format("~w~Accident Message is now ~g~~h~on")})
                                SetVehicleExtra(V, 6, false)
                            else
                                RageUI.Text({message = string.format("~w~Accident Message now ~g~~h~off")})
                                SetVehicleExtra(V, 6, true)
                                W.flashing = false
                            end
                        end
                        W.accidentSign = X
                    end)
                    RageUI.Checkbox("Ahead Message","Toggle the vehicle ahead sign on/off",W.aheadSign,{Style = RageUI.CheckboxStyle.Car},function(D, F, E, X)
                        if F then
                            if W.aheadSign then
                                RageUI.Text({message = string.format("~w~Ahead Message is now ~g~~h~on")})
                                SetVehicleExtra(V, 5, false)
                            else
                                RageUI.Text({message = string.format("~w~Ahead Message now ~g~~h~off")})
                                SetVehicleExtra(V, 5, true)
                            end
                        end
                        W.aheadSign = X
                    end)
                    RageUI.Checkbox("Matrix Flash","Toggle the flashing of the matrix sign ahead sign on/off",W.flashing,{Style = RageUI.CheckboxStyle.Car},function(D, F, E, X)
                        if F then
                            if W.flashing then
                                RageUI.Text({message = string.format("~w~Flashing is now ~g~~h~enabled")})
                                W.flashing = true
                                W.active = true
                            else
                                RageUI.Text({message = string.format("~w~Flashing now ~g~~h~disabled")})
                            end
                        end
                        W.flashing = X
                    end)
                end
            end
        end)
    end
end)

RegisterCommand("isu",function(R, S)
    if tARMA.globalOnPoliceDuty() or tARMA.globalOnPrisonDuty() or tARMA.globalNHSOnDuty() then
        RageUI.Visible(RMenu:Get("incidentsupportunit", "main"), true)
    end
end)

CreateThread(function()
    while true do
        if W.active and W.flashing then
            local V = tARMA.getPlayerVehicle()
            SetVehicleExtra(V, 5, true)
            SetVehicleExtra(V, 6, false)
            Wait(500)
            SetVehicleExtra(V, 6, true)
            SetVehicleExtra(V, 5, false)
            Wait(500)
        end
        Wait(0)
    end
end)
RegisterNetEvent("ARMA:startSearchingSuspect",function()
    tARMA.setCanAnim(false)
    tARMA.loadAnimDict("custom@police")
    TaskPlayAnim(PlayerPedId(), "custom@police", "police", 8.0, 8.0, -1, 0, 0.0, false, false, false)
    RemoveAnimDict("custom@police")
    local Y = GetGameTimer()
    while GetGameTimer() - Y < 10000 do
        if IsDisabledControlJustPressed(0, 73) then
            TriggerServerEvent("ARMA:cancelPlayerSearch")
            return
        end
        Citizen.Wait(0)
    end
    tARMA.setCanAnim(true)
end)
local Z = false
RegisterNetEvent("ARMA:startBeingSearching",function(_)
    local a0 = GetPlayerFromServerId(_)
    if a0 == -1 then
        return
    end
    local a1 = GetPlayerPed(a0)
    if a1 == 0 then
        return
    end
    Z = true
    tARMA.setCanAnim(false)
    tARMA.loadAnimDict("custom@suspect")
    local a2 = tARMA.getPlayerPed()
    AttachEntityToEntity(a2, a1, -1, -0.05, 0.5, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, false)
    TaskPlayAnim(a2, "custom@suspect", "suspect", 8.0, 8.0, -1, 2, 0.0, false, false, false)
    RemoveAnimDict("custom@suspect")
    local Y = GetGameTimer()
    while GetGameTimer() - Y < 10000 do
        if not Z then
            return
        end
        Citizen.Wait(0)
    end
    Z = false
    tARMA.setCanAnim(true)
    DetachEntity(a2)
    ClearPedTasks(a2)
end)
RegisterNetEvent("ARMA:cancelPlayerSearch",function()
    Z = false
    tARMA.setCanAnim(true)
    local a2 = tARMA.getPlayerPed()
    DetachEntity(a2)
    ClearPedTasks(a2)
end)
local a3 = ""
local a4 = ""
local a5 = ""
local a6 = false
local a7 = ""
local a8 = ""
local a9 = ""
local aa = false
RegisterNetEvent("ARMA:receivePoliceCallsign",function(ab, ac, ad)
    a3 = ac; a4 = ab; a5 = ad; a6 = true
    print("Your PD rank is: " .. a3 .. "\nYour callsign is: " .. a4)
end)
RegisterNetEvent("ARMA:receiveHmpCallsign",function(ab, ac, ad)
    a7 = ac; a8 = ab; a9 = ad; aa = true
    print("Your HMP rank is: " .. a9 .. "\nYour callsign is: " .. a8)
end)
function tARMA.getPoliceCallsign()
    return a4
end
function tARMA.getPoliceRank()
    return a3
end
function tARMA.getPoliceName()
    return a5
end
function tARMA.hasPoliceCallsign()
    return a6
end
function tARMA.getHmpCallsign()
    return a8
end
function tARMA.getHmpRank()
    return a7
end
function tARMA.getHmpName()
    return a9
end
function tARMA.hasHmpCallsign()
    return aa
end
function func_drawCallsign()
    if a4 ~= "" and globalOnPoliceDuty then
        DrawAdvancedText(1.064, 0.972, 0.005, 0.0028, 0.4, a4, 255, 255, 255, 255, 0, 0)
    end
    if a8 ~= "" and globalOnPrisonDuty then
        DrawAdvancedText(1.064, 0.972, 0.005, 0.0028, 0.4, a8, 255, 255, 255, 255, 0, 0)
    end
    DrawAdvancedText(1.064, 0.95, 0.005, 0.0028, 0.4, 'ARMA', 255, 255, 255, 255, 0, 0)
end
tARMA.createThreadOnTick(func_drawCallsign)
local ae = 0
local function af()
    local a2 = tARMA.getPlayerPed()
    if IsPedShooting(a2) then
        local ag = GetSelectedPedWeapon(a2)
        local ah, ai = GetMaxAmmo(a2, ag)
        local aj = GetWeapontypeGroup(ag)
        if ai >= 1 and aj ~= "GROUP_MELEE" and aj ~= "GROUP_THROWN" then
            ae = GetGameTimer()
        end
    elseif GetEntityHealth(a2) <= 102 and ae ~= 0 then
        ae = 0
    end
end
tARMA.createThreadOnTick(af)
function tARMA.hasRecentlyShotGun()
    return ae ~= 0 and GetGameTimer() - ae < 600000
end

AddEventHandler("ARMA:onClientSpawn",function()
    aj = 0
end)

RMenu.Add("trainingWorlds","mainmenu",RageUI.CreateMenu("Training Worlds", "Main Menu", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight()))
local ap = {}
local aq = false
RegisterNetEvent("ARMA:trainingWorldOpen",function(ar)
    aq = ar
    RageUI.Visible(RMenu:Get("trainingWorlds", "mainmenu"), true)
end)
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('trainingWorlds', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            local as = false
            for x, at in pairs(ap) do
                local au = string.format("Created by %s (%s) - Bucket %s", at.ownerName, at.ownerUserId, at.bucket)
                local av = at.bucket == tARMA.getPlayerBucket()
                local aw = av and {RightLabel = "(Joined)"} or {}
                RageUI.ButtonWithStyle(at.name,au,aw,true,function(J, K, L)
                    if K and aq then
                        drawNativeNotification("Press ~INPUT_FRONTEND_DELETE~ to delete this world")
                        if IsControlJustPressed(0, 214) then
                            TriggerServerEvent("ARMA:trainingWorldRemove", x)
                        end
                    end
                    if L then
                        TriggerServerEvent("ARMA:trainingWorldJoin", x)
                    end
                end)
                if av then
                    as = av
                end
            end
            if as then
                RageUI.ButtonWithStyle("~r~Leave Training World",nil,{},true,function(J, K, L)
                    if L then
                        TriggerServerEvent("ARMA:trainingWorldLeave")
                    end
                end)
            end
            if aq then
                RageUI.ButtonWithStyle("~b~Create Training World",nil,{},true,function(J, K, L)
                    if L then
                        TriggerServerEvent("ARMA:trainingWorldCreate")
                    end
                end)
            end
        end)
    end
end)

RegisterNetEvent("ARMA:trainingWorldSend",function(x, ax)
    ap[x] = ax
end)
RegisterNetEvent("ARMA:trainingWorldSendAll",function(ax)
    ap = ax
end)
RegisterNetEvent("ARMA:trainingWorldRemove",function(x)
    ap[x] = nil
end)
