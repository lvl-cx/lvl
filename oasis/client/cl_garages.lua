DecorRegister("vRP_owner", 3)
DecorRegister("vRP_vmodel", 3)
DecorRegister("lootid", 3)
DecorRegister("lsAudioId", 3)
local cfg = module("oasis-vehicles", "garages")
local b = cfg.garages
local garage_type = ""
local selected_category = nil
local Hovered_Vehicles = nil
VehiclesFetchedTable = {}
local RentedVehiclesIn = {}
local RentedVehiclesOut = {}
local Table_Type = nil
local RentedVeh = false
local SelectedCar = {spawncode = nil, name = nil, plate = nil}
local veh = nil 
local cantload = {}
local vehname = nil 
local folders = {}
local SelectedfolderName = nil
local c = {}
local f = ""
local q = {}
local m = {}
local g = ""
local n = false
local k = 0
local x = {}
globalVehicleModelHashMapping = {}
globalVehicleOwnership = {}
globalOwnedPlayerVehicles = {}

local vehicleCannotBeSold = {
    --["demonhawkk"] = true,
}

local vehicleCannotBeRented = {
    --["demonhawkk"] = true,
}
local garageSettings = {}

RMenu.Add('OASISGarages', 'main', RageUI.CreateMenu("", "~b~OASIS Garages",tOASIS.getRageUIMenuWidth(), tOASIS.getRageUIMenuHeight(), "banners", "garage"))
RMenu.Add('OASISGarages', 'owned_vehicles', RageUI.CreateSubMenu(RMenu:Get("OASISGarages", "main")))
RMenu.Add('OASISGarages', 'rented_vehicles', RageUI.CreateSubMenu(RMenu:Get("OASISGarages", "main")))
RMenu.Add('OASISGarages', 'rented_vehicles_manage', RageUI.CreateSubMenu(RMenu:Get("OASISGarages", "rented_vehicles")))
RMenu.Add('OASISGarages', 'rented_vehicles_information', RageUI.CreateSubMenu(RMenu:Get("OASISGarages", "rented_vehicles_manage")))
RMenu.Add('OASISGarages', 'owned_vehicles_submenu', RageUI.CreateSubMenu(RMenu:Get("OASISGarages", "owned_vehicles")))
RMenu.Add('OASISGarages', 'owned_vehicles_submenu_manage', RageUI.CreateSubMenu(RMenu:Get("OASISGarages", "owned_vehicles_submenu")))
RMenu.Add('OASISGarages', 'scrap_vehicle_confirmation', RageUI.CreateSubMenu(RMenu:Get("OASISGarages", "owned_vehicles_submenu_manage")))
RMenu.Add('OASISGarages', 'rented_vehicles_out_manage', RageUI.CreateSubMenu(RMenu:Get("OASISGarages", "rented_vehicles")))
RMenu.Add('OASISGarages', 'rented_vehicles_out_information', RageUI.CreateSubMenu(RMenu:Get("OASISGarages", "rented_vehicles_out_manage")))
RMenu.Add('OASISGarages', 'customfolders', RageUI.CreateSubMenu(RMenu:Get("OASISGarages", "owned_vehicles")))
RMenu.Add('OASISGarages', 'customfoldersvehicles', RageUI.CreateSubMenu(RMenu:Get("OASISGarages", "customfolders")))
RMenu.Add('OASISGarages', 'settings', RageUI.CreateSubMenu(RMenu:Get("OASISGarages", "main")))
RMenu:Get('OASISGarages', 'owned_vehicles'):SetSubtitle("~b~Garage Mangement Menu")


function DeleteCar(veh)
    if veh then 
        if DoesEntityExist(veh) then 
            Hovered_Vehicles = nil
            vehname = nil
            DeleteEntity(veh)
            veh = nil
        end
    end
end

local function V(J)
    for k,v in pairs(c) do
        if v == J then
            return true
        end
    end
    return false
end

local function W(J)
    RageUI.ActuallyCloseAll()
    if V(J) then
        RageUI.Visible(RMenu:Get("OASISGarages", "main"), true)
    end
end
local function X(J)
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("OASISGarages", "main"), false)
end
CreateThread(function()
    local Y = {}
    local Z = {}
    for J, G in pairs(cfg.garages) do
        for L, M in pairs(G) do
            if L == "_config" then
                local _, a0, a1, a2, a3, type = M.blipid,M.blipcolor,M.markerid,M.markercolours,M.permissions,M.type
                for a4, a5 in pairs(cfg.garageInstances) do
                    local a6, a7, a8 = table.unpack(a5)
                    if J == a6 then
                        if a8 then
                            table.insert(Y, {position = a7, blipId = _, blipColor = a0, name = a6})
                        end
                        table.insert(Z, {position = a7, colour = a2, markerId = a1})
                    end
                end
            end
        end
    end
    local a9 = function(aa)
        PlaySound(-1, "Hit", "RESPAWN_SOUNDSET", 0, 0, 1)
        h = b[aa.garageType]["_config"].type
        W(aa.garageType)
        garage_type = aa.garageType
        selectedGarageVector = aa.position
    end
    local ab = function(aa)
        PlaySound(-1, "Hit", "RESPAWN_SOUNDSET", 0, 0, 1)
        X(aa.garageType)
    end
    local ac = function(aa)
    end
    for ad, ae in pairs(cfg.garageInstances) do
        tOASIS.createArea("garage_" .. ad,ae[2],1.5,6,a9,ab,ac,{garageType = ae[1], garageId = ad, position = ae[2]})
    end
    for _, af in pairs(Y) do
        tOASIS.addBlip(af.position.x, af.position.y, af.position.z, af.blipId, af.blipColor, af.name, 0.7, false)
    end
    for a1, ag in pairs(Z) do
        tOASIS.addMarker(ag.position.x,ag.position.y,ag.position.z,0.7,0.7,0.5,ag.colour[1],ag.colour[2],ag.colour[3],125,50,ag.markerId,true)
    end
end)


local ah = 0
local ai = 0.0
local function aj(E)
    DeleteVehicle(GetVehiclePedIsIn(tOASIS.getPlayerPed(), false))
    CreateThread(function()
        local ak = GetHashKey(E)
        RequestModel(ak)
        local al = 0
        while not HasModelLoaded(ak) and al < 200 do
            drawNativeText("~r~Downloading vehicle model")
            Wait(0)
            al = al + 1
        end
        if HasModelLoaded(ak) then
            local am = CreateVehicle(ak,selectedGarageVector.x,selectedGarageVector.y,selectedGarageVector.z,ai,false,false)
            DecorSetInt(am, "OASISACVeh", 955)
            SetEntityAsMissionEntity(am)
            FreezeEntityPosition(am, true)
            SetEntityInvincible(am, true)
            SetVehicleDoorsLocked(am, 4)
            SetModelAsNoLongerNeeded(ak)
            if ah ~= 0 then
                DestroyCam(ah, 0)
                ah = 0
            end
            SetEntityAlpha(tOASIS.getPlayerPed(), 0)
            FreezeEntityPosition(tOASIS.getPlayerPed(), true)
            SetEntityCollision(tOASIS.getPlayerPed(), false, false)
            SetEntityCollision(am, false, false)
            local an = GetEntityCoords(tOASIS.getPlayerPed())
            local ao = GetEntityRotation(tOASIS.getPlayerPed())
            local ap = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
            local aq = vector3(an.x, an.y, an.z + 2.0) - GetEntityForwardVector(tOASIS.getPlayerPed()) * 4.0
            SetCamActive(ap, true)
            RenderScriptCams(true, true, 500, 1, 0)
            SetCamCoord(ap, aq)
            SetCamRot(ap, -20.0, ao.y, ao.z)
            ah = ap
            Citizen.CreateThread(function()
                while DoesEntityExist(am) do
                    Citizen.Wait(25)
                    ai = (ai + 1) % 360
                    SetEntityHeading(am, ai)
                end
            end)
            t = false
            n = true
            k = am
        else
            tOASIS.notify("~r~Failed to load vehicle.")
            return -1
        end
    end)
end
local function ar(as)
    local at = AddBlipForEntity(as)
    SetBlipSprite(at, 56)
    SetBlipDisplay(at, 4)
    SetBlipScale(at, 1.0)
    SetBlipColour(at, 2)
    SetBlipAsShortRange(at, true)
end

local fuelLevels = {}
RegisterNetEvent("OASIS:spawnPersonalVehicle",function(E, av, valetCalled, ax, plate, fuel)
    X()
    fuelLevels[E] = fuel
    if GetVehiclePedIsIn(tOASIS.getPlayerPed(), false) == d then
        DeleteEntity(d)
    end
    tOASIS.notify("~g~Loading vehicle, please wait.")
    local ay = globalVehicleOwnership[E]
    if ay == nil or not DoesEntityExist(ay[2]) then
        local ak = tOASIS.loadModel(E)
        if ak == nil then
            tOASIS.notify("~r~Vehicle does not exist, if you believe this is an error contact a Car Dev on discord.")
            return
        end
        globalVehicleModelHashMapping[ak] = E
        local as
        if valetCalled then
            local an = tOASIS.getPosition()
            local az, T, aA = GetNthClosestVehicleNode(an.x, an.y, an.z, nil, 8, 8, 8, 8)
            local T, aB, T = GetNthClosestVehicleNode(an.x, an.y, an.z, 15)
            local aC, T, aD = GetClosestVehicleNodeWithHeading(an.x, an.y, an.z, nil, 8, 8, 8, 8)
            local T, aE, T = GetPointOnRoadSide(an.x, an.y, an.z, 0.0)
            if tostring(aE) ~= "vector3(0, 0, 0)" and tostring(aB) ~= "vector3(0, 0, 0)" then
                as = tOASIS.spawnVehicle(ak, aB.x, aB.y, aB.z + 0.5, aA or 0.0, false, true, true)
                tOASIS.loadModel("s_m_y_xmech_01")
                SendNUIMessage({transactionType = "MPCT_AKAA_0" .. math.random(1, 5)})
                local aF = CreatePedInsideVehicle(as, "PED_TYPE_CIVMALE", "s_m_y_xmech_01", -1, false, false)
                TaskVehicleDriveToCoord(aF, as, aE.x, aE.y, aE.z, 15.0, 1.0, ak, 786603, 5.0)
                ar(as)
                SetTimeout(5000,function()
                    while GetEntitySpeed(as) > 5.0 do
                        Wait(500)
                    end
                    TaskLeaveVehicle(aF, as, 64)
                    TaskWanderStandard(aF, 10.0, 10)
                    Wait(10000)
                    DeletePed(aF)
                end)
                print("[OASIS] Spawned vehicle with spawncode: " .. tostring(E))
                DecorSetInt(as, "vRP_owner", tOASIS.getUserId())
                DecorSetInt(as, "vRP_vmodel", E)
                SetVehicleNumberPlateText(as, plate)
                globalVehicleOwnership[E] = {E, as}
                setVehicleFuel(as, fuelLevels[E])
                while tOASIS.getPlayerVehicle() ~= as do
                    Wait(100)
                end
                TriggerServerEvent("LSC:applyModifications", E, as)
                TriggerServerEvent("OASIS:spawnVehicleCallback", av, VehToNet(as))
                table.insert(m, as)
            end
        else
            local aG = ax or tOASIS.getPosition()
            as = tOASIS.spawnVehicle(ak, aG.x, aG.y, aG.z + 0.5, GetEntityHeading(PlayerPedId()), true, true, true)
            ar(as)
            print("[OASIS] Spawned vehicle with spawncode: " .. tostring(E))
            DecorSetInt(as, "vRP_owner", tOASIS.getUserId())
            DecorSetInt(as, "vRP_vmodel", E)
            SetVehicleNumberPlateText(as, plate)
            globalVehicleOwnership[E] = {E, as}
            setVehicleFuel(as, fuelLevels[E])
            TriggerServerEvent("LSC:applyModifications", E, as)
            TriggerServerEvent("OASIS:PayVehicleTax")
            TriggerServerEvent("OASIS:spawnVehicleCallback", av, VehToNet(as))
            table.insert(m, as)
            CreateThread(function()
                local aH = true
                SetTimeout(5000,function()
                    aH = false
                end)
                while aH do
                    if DoesEntityExist(as) then
                        Citizen.InvokeNative(0x5FFE9B4144F9712F, true)
                        SetNetworkVehicleAsGhost(as, true)
                        SetEntityAlpha(as, 220)
                    end
                    Wait(0)
                end
                Citizen.InvokeNative(0x5FFE9B4144F9712F, false)
                SetNetworkVehicleAsGhost(as, false)
                SetEntityAlpha(as, 255)
                ResetEntityAlpha(as)
            end)
        end
        SetModelAsNoLongerNeeded(ak)
        while DoesEntityExist(as) do
            local aI = GetFuel(as)
            if fuelLevels[E] ~= aI then
                TriggerServerEvent("OASIS:updateFuel", E, math.floor(aI * 1000) / 1000)
                fuelLevels[E] = aI
                SetEntityInvincible(as, false)
                SetEntityCanBeDamaged(as, true)
            end
            Wait(60000)
        end
    else
        tOASIS.notify("This vehicle is already out.")
    end
end)


function GetFuel(ay)
    return DecorGetFloat(ay, "_FUEL_LEVEL")
end

function func_previewGarageVehicle()
    if n then
        if IsControlJustPressed(0, 177) then
            DeleteVehicle(k)
            k = 0
            l = 0
            n = false
            DestroyCam(ah, 0)
            RenderScriptCams(0, 0, 1, 1, 1)
            ah = 0
            SetFocusEntity(GetPlayerPed(PlayerId()))
            SetEntityAlpha(tOASIS.getPlayerPed(), 255)
            FreezeEntityPosition(tOASIS.getPlayerPed(), false)
            SetEntityCollision(tOASIS.getPlayerPed(), true, true)
        end
    end
end
tOASIS.createThreadOnTick(func_previewGarageVehicle)

local function aK(E)
    for J, aL in pairs(b) do
        for aM in pairs(aL) do
            if aM ~= "_config" and aM == E then
                return V(J) and h == aL["_config"].type
            end
        end
    end
    return true
end

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('OASISGarages', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            DeleteCar(veh)
            RageUI.ButtonWithStyle("Garages", f, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) 
                if Selected then
                    VehiclesFetchedTable = {}
                    TriggerServerEvent('OASIS:FetchCars', garage_type)
                    TriggerServerEvent('OASIS:getCustomFolders')
                    TriggerServerEvent("OASIS:getImpoundedVehicles")
                end
            end, RMenu:Get("OASISGarages", "owned_vehicles"))
            RageUI.ButtonWithStyle("Store Vehicle", f, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) 
                if Selected then 
                    local aR = GetVehiclePedIsIn(tOASIS.getPlayerPed(), false)
                    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(aR))
                    if DoesEntityExist(aR) then
                        DeleteEntity(aR)
                    end
                end
            end)
            RageUI.ButtonWithStyle("Rent Manager", f, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) 
                if Selected then
                    TriggerServerEvent('OASIS:FetchRented')
                end
            end, RMenu:Get("OASISGarages", "rented_vehicles"))
            RageUI.ButtonWithStyle("Settings", f, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get("OASISGarages", "settings"))
            RageUI.ButtonWithStyle("Spawn Last Vehicle", f, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) 
                if Selected then
                    local ay = globalVehicleOwnership[e]
                    if ay == nil or not DoesEntityExist(ay[2]) then
                        TriggerServerEvent("OASIS:spawnPersonalVehicle", e)
                    else
                        tOASIS.notify("~r~Vehicle is already out!")
                    end
                end
            end)
            RageUI.ButtonWithStyle("~y~Fuel all vehicles. (£25,000)", f, {RightLabel = "→→→"}, true,function(aO, aP, aQ)
                if aQ then
                    if tOASIS.isPlusClub() or tOASIS.isPlatClub() then
                        if not u then
                            TriggerServerEvent("OASIS:fuelAllVehicles")
                            u = true
                            SetTimeout(60000,function()
                                u = false
                            end)
                        else
                            tOASIS.notify("~r~You've done this too recently, try again later.")
                        end
                    else
                        tOASIS.notify("~y~You need to be a subscriber of OASIS Plus or OASIS Platinum to use this feature.")
                        tOASIS.notify("~y~Available @ store.oasisv.co.uk")
                    end
                end
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('OASISGarages', 'settings')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Checkbox('Hide custom folder vehicles', "This hides these vehicles from their original garage.", garageSettings.hideCustomFolderVehiclesFromOriginalGarages, { RightLabel = "" }, function(Hovered, Active, Selected, Checked)
                if Selected then
                    garageSettings.hideCustomFolderVehiclesFromOriginalGarages = not garageSettings.hideCustomFolderVehiclesFromOriginalGarages
                    if garageSettings.hideCustomFolderVehiclesFromOriginalGarages then
                        SetResourceKvpInt('hideCustomFolderVehiclesFromOriginalGarages', 1)
                    else
                        SetResourceKvpInt('hideCustomFolderVehiclesFromOriginalGarages', 0)
                    end
                end
            end)
            RageUI.Checkbox('Show Custom Folders In Garage Menu', "~y~This removes the [Custom Folders] menu item, and puts custom folders in the root garages menu.", garageSettings.displayCustomFoldersinOwned, { RightLabel = "" }, function(Hovered, Active, Selected, Checked)
                if Selected then
                    garageSettings.displayCustomFoldersinOwned = not garageSettings.displayCustomFoldersinOwned
                    if garageSettings.displayCustomFoldersinOwned then
                        SetResourceKvpInt('displayFoldersinOwned', 1)
                    else
                        SetResourceKvpInt('displayFoldersinOwned', 0)
                    end
                end
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('OASISGarages', 'owned_vehicles')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            DeleteCar(veh)
            RentedVeh = false
            if not garageSettings.displayCustomFoldersinOwned then
                RageUI.ButtonWithStyle("[Custom Folders]", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        for i,v in pairs(VehiclesFetchedTable) do 
                            if garage_type == i then 
                                selected_category = v.vehicles
                            end
                        end
                    end
                end, RMenu:Get("OASISGarages", "customfolders"))
            end
            if garageSettings.displayCustomFoldersinOwned then
                for h,b in pairs(folders) do
                    RageUI.ButtonWithStyle(h , nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SelectedfolderName = h
                            g = nil
                        end
                    end, RMenu:Get("OASISGarages", "customfoldersvehicles"))
                end
            end
            local aW = sortAlphabetically(VehiclesFetchedTable)
            for T, K in pairs(aW) do  
                local J = K.title
                local M = K["value"]["_config"]
                local _, a0, a1, a2, a3, aX = M.blipid,M.blipcolor,M.markerid,M.markercolours,M.permissions,M.type
                if V(J) and h == aX then
                    RageUI.ButtonWithStyle(J, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then 
                            selected_category = K["value"]["vehicles"]
                            g = J
                        end
                    end, RMenu:Get("OASISGarages", "owned_vehicles_submenu"))
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('OASISGarages', 'owned_vehicles_submenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for J,K in pairs(b) do
                if J == g then
                    selectedCustomFolder = nil
                    local aY = {}  
                    for E, P in pairs(K) do
                        table.insert(aY, {vehicleId = E, vehicleName = P[1] or "z"})
                    end
                    table.sort(aY,function(R, S)
                        return R.vehicleName < S.vehicleName
                    end)
                    for T, K in pairs(aY) do
                        local E = K.vehicleId
                        local aT = K.vehicleName
                        local aZ = false
                        if selected_category[E] then
                            aZ = true
                        end
                        if E ~= "_config" then
                            if aZ then
                                if garageSettings.hideCustomFolderVehiclesFromOriginalGarages and tOASIS.isVehicleInAnyCustomFolder(E) then
                                else
                                    local a_ = math.floor((q[E] or 0) * 1000) / 1000
                                    local b0 = ""
                                    if a_ <= 20 then
                                        b0 = "~r~"
                                    elseif a_ <= 50 then
                                        b0 = "~y~"
                                    elseif a_ <= 100 then
                                        b0 = "~g~"
                                    end
                                    if tOASIS.isVehicleImpounded(E) then
                                        aT = aT .. " ~r~(IMPOUNDED)~w~"
                                    end
                                    RageUI.ButtonWithStyle(aT, b0 .. "Fuel " .. tostring(a_) .. "%",{RightLabel = "→→→"},true,function(aO, aP, aQ)
                                        if aP then
                                            if (k == 0 or l ~= E) and not t then
                                                DeleteVehicle(k)
                                                t = true
                                                aj(E)
                                                l = E
                                            end
                                        end
                                        if aQ then
                                            e = E
                                            f = aT
                                            TriggerServerEvent("OASIS:getVehicleRarity", E)
                                            RMenu:Get('OASISGarages', 'owned_vehicles_submenu_manage'):SetSubtitle(aT)
                                        end
                                    end,RMenu:Get("OASISGarages", "owned_vehicles_submenu_manage"))
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('OASISGarages', 'owned_vehicles_submenu_manage')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            local a_ = f
            if x[e] then
                a_ = a_ .. " | " .. "Rarity (1:" .. tostring(x[e]) .. ")"
            end
            RageUI.ButtonWithStyle('Spawn Vehicle', a_, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then 
                    for F, G in pairs(m) do
                        if not DoesEntityExist(G) then
                            table.remove(m, F)
                        end
                    end
                    if #m <= 5 then
                        DeleteVehicle(k)
                        k = 0
                        l = 0
                        n = false
                        DestroyCam(ah, 0)
                        RenderScriptCams(0, 0, 1, 1, 1)
                        ah = 0
                        SetFocusEntity(GetPlayerPed(PlayerId()))
                        SetEntityAlpha(tOASIS.getPlayerPed(), 255)
                        FreezeEntityPosition(tOASIS.getPlayerPed(), false)
                        SetEntityCollision(tOASIS.getPlayerPed(), true, true)
                        local ay = globalVehicleOwnership[e]
                        if ay == nil or not DoesEntityExist(ay[2]) then
                            TriggerServerEvent("OASIS:spawnPersonalVehicle", e)
                        else
                            tOASIS.notify("~r~Vehicle is already out!")
                        end
                    else
                        tOASIS.notify("~r~You may only take out a maximum of 5 vehicles at a time.")
                    end
                    RageUI.ActuallyCloseAll()
                end
            end)
            if not RentedVeh then
                RageUI.ButtonWithStyle('Sell Vehicle to Player', a_, {RightLabel = "→→→"}, canVehicleBeSold(e), function(Hovered, Active, Selected)
                    if Selected and canVehicleBeSold(e) then 
                        TriggerServerEvent('OASIS:SellVehicle', e)
                    end
                end)
                RageUI.ButtonWithStyle('Rent Vehicle to Player', a_, {RightLabel = "→→→"}, canVehicleBeRented(e), function(Hovered, Active, Selected)
                    if Selected and canVehicleBeSold(e) then
                        TriggerServerEvent('OASIS:RentVehicle', e) 
                    end
                end)
                RageUI.ButtonWithStyle('Crush Vehicle', 'This will ~r~DELETE ~w~this vehicle from your garage.', {RightLabel = "→→→"}, canVehicleBeSold(e), function(Hovered, Active, Selected)
                    if Selected then
                        AddTextEntry("FMMC_MPM_NC", "Type 'CONFIRM' to crush vehicle")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then 
                                result = result
                                if string.upper(result) == 'CONFIRM' then
                                    TriggerServerEvent('OASIS:CrushVehicle', e) 
                                    Table_Type = nil
                                    RageUI.ActuallyCloseAll()
                                    RageUI.Visible(RMenu:Get('OASISGarages', 'main'), true)  
                                end
                            end
                        end
                    end
                end)
                RageUI.ButtonWithStyle('Add to Custom Folder', a_, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        local folderName = tOASIS.KeyboardInput("Enter Folder Name", "", 25)
                        if folderName ~= nil then
                            if folders[folderName] ~= nil then
                                if not table.find(folders[folderName], e) then
                                    table.insert(folders[folderName], e)
                                    tOASIS.notify("~g~Added vehicle to custom folder.")
                                    TriggerServerEvent("OASIS:updateFolders", folders)
                                else
                                    tOASIS.notify("~r~Failed to add vehicle from folder, vehicle already in folder.")
                                end
                            else
                                tOASIS.notify("~r~Failed to add vehicle to folder, folder does not exist?")
                            end
                        end
                    end
                end)
                RageUI.ButtonWithStyle('Remove from Custom Folder', a_, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        local folderName = tOASIS.KeyboardInput("Enter Folder Name", "", 25)
                        if folderName ~= nil then
                            if folders[folderName] ~= nil then
                                if table.find(folders[folderName], e) then
                                    for i = 1, #folders[folderName] do
                                        if folders[folderName][i] == e then
                                            table.remove(folders[folderName], i)
                                            TriggerServerEvent("OASIS:updateFolders", folders)
                                            tOASIS.notify("~g~Removed vehicle from custom folder.")
                                        end
                                    end
                                else
                                    tOASIS.notify("~r~Failed to remove vehicle from folder, vehicle not in folder.")
                                end
                            else
                                tOASIS.notify("~r~Failed to remove vehicle from folder, folder does not exist?")
                            end
                        end
                    end
                end)
                RageUI.ButtonWithStyle('View Remote Dashcam', a_, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        TriggerServerEvent("OASIS:viewRemoteDashcam", e)
                    end
                end)
                RageUI.ButtonWithStyle('Display Vehicle Blip', a_, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        TriggerServerEvent("OASIS:displayVehicleBlip", e)
                    end
                end)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('OASISGarages', 'customfolders')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.ButtonWithStyle("[Create Custom Folder]" , "Create a custom folder.", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local folderName = tOASIS.KeyboardInput("Enter Folder Name", "", 25)
                    if folderName ~= nil and folderName ~= '' then
                        if folders[folderName] == nil then
                            folders[folderName] = {}
                            TriggerServerEvent("OASIS:updateFolders", folders)
                            tOASIS.notify("~g~Created custom folder "..folderName)
                        else
                            tOASIS.notify("~r~Folder already exists.")
                        end
                    else
                        tOASIS.notify("~r~Invalid folder name.")
                    end
                end
            end)
            RageUI.ButtonWithStyle("[Delete Custom Folder]" , "Delete a custom folder", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local folderName = tOASIS.KeyboardInput("Enter Folder name", "", 25)
                    if folderName ~= nil then
                        if folders[folderName] ~= nil and folderName ~= '' then
                            folders[folderName] = nil
                            tOASIS.notify("~g~Deleted custom folder "..folderName)
                            TriggerServerEvent("OASIS:updateFolders", folders)
                        else
                            tOASIS.notify("~r~Folder "..folderName.." does not exist.")
                        end
                    else
                        tOASIS.notify("~r~Invalid folder name.")
                    end
                end
            end)
            for h,b in pairs(folders) do
                RageUI.ButtonWithStyle(h , nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        SelectedfolderName = h
                        g = nil
                    end
                end, RMenu:Get("OASISGarages", "customfoldersvehicles"))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('OASISGarages', 'customfoldersvehicles')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for k,v in pairs(folders) do
                if k == SelectedfolderName then
                    if #folders[SelectedfolderName] < 1 then; RageUI.Separator('This folder does not contain any vehicles'); end
                    for i = 1, #folders[SelectedfolderName] do
                        for a,b in pairs(VehiclesFetchedTable) do 
                            for c,d in pairs(b.vehicles) do
                                if c == v[i] then
                                    RageUI.ButtonWithStyle(d[1], "", {RightLabel = nil}, true, function(Hovered, Active, Selected)
                                        if Selected then
                                            e = v[i]
                                            f = d[1]
                                            TriggerServerEvent("OASIS:getVehicleRarity", e)
                                        end
                                        if Active then 
                                            Hovered_Vehicles = v[i]
                                        end
                                    end,RMenu:Get("OASISGarages", "owned_vehicles_submenu_manage")) 
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('OASISGarages', 'rented_vehicles')) then 
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            DeleteCar(veh)
            if next(RentedVehiclesOut) then
                RageUI.ButtonWithStyle('Rented Vehicles Out', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end,RMenu:Get("OASISGarages", "rented_vehicles_out_manage"))
            end
            if next(RentedVehiclesIn) then
                RageUI.ButtonWithStyle('Rented Vehicles In', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end,RMenu:Get("OASISGarages", "rented_vehicles_manage"))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('OASISGarages', 'rented_vehicles_out_manage')) then 
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            Hovered_Vehicles = nil 
            DeleteCar(veh)
            if next(RentedVehiclesOut) then
                for i,v in pairs(RentedVehiclesOut.vehicles) do
                    RageUI.ButtonWithStyle(v[1], nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RentedVehicle = i
                        end
                    end, RMenu:Get("OASISGarages", "rented_vehicles_out_information"))
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('OASISGarages', 'rented_vehicles_out_information')) then 
        RageUI.DrawContent({header = true, glare = false, instructionalButton = true}, function()
            if next(RentedVehiclesOut) then
                for i,v in pairs(RentedVehiclesOut.vehicles) do
                    if RentedVehicle == i then
                        RageUI.Separator("~g~Rent Info")
                        RageUI.Separator("Vehicle: " .. v[1])
                        RageUI.Separator("Spawncode: " .. i)
                        RageUI.Separator("Time Left: " .. v[2])
                        RageUI.Separator("Rented To ID: " .. v[3])
                        RageUI.ButtonWithStyle('Request Rent Cancellation', "~y~This will cancel the rent of " ..v[1], {}, true, function(Hovered, Active, Selected)
                            if Selected then 
                                TriggerServerEvent("OASIS:CancelRent", i, v[1], 'owner')
                            end
                        end)
                    end
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('OASISGarages', 'rented_vehicles_manage')) then 
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            Hovered_Vehicles = nil 
            DeleteCar(veh)
            if next(RentedVehiclesIn) then
                for i,v in pairs(RentedVehiclesIn.vehicles) do
                    RageUI.ButtonWithStyle(v[1], nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RentedVehicle = i
                        end
                    end, RMenu:Get("OASISGarages", "rented_vehicles_information"))
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('OASISGarages', 'rented_vehicles_information')) then 
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            Hovered_Vehicles = nil 
            DeleteCar(veh)
            if next(RentedVehiclesIn) then
                for i,v in pairs(RentedVehiclesIn.vehicles) do
                    if RentedVehicle == i then
                        RageUI.Separator("~g~Rent Info")
                        RageUI.Separator("Vehicle: " .. v[1])
                        RageUI.Separator("Spawncode: " .. i)
                        RageUI.Separator("Time Left: " .. v[2])
                        RageUI.Separator("Rented To ID: " .. v[3])
                        RageUI.ButtonWithStyle('Request Rent Cancellation', "~y~This will cancel the rent of " ..v[1], {}, true, function(Hovered, Active, Selected)
                            if Selected then 
                                TriggerServerEvent("OASIS:CancelRent", i, v[1], 'renter')
                            end
                        end)
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent("OASIS:updateOwnedVehicles",function(J)
    globalOwnedPlayerVehicles = {}
    globalOwnedPlayerVehicles = J
end)

RegisterNetEvent('OASIS:ReturnFetchedCars')
AddEventHandler('OASIS:ReturnFetchedCars', function(table, fuellevels)
    VehiclesFetchedTable = table
    q = fuellevels
end)

RegisterNetEvent('OASIS:ReturnedRentedCars')
AddEventHandler('OASIS:ReturnedRentedCars', function(rentedin, rentedout)
    RentedVehiclesIn = rentedin
    RentedVehiclesOut = rentedout
end)

RegisterNetEvent('OASIS:sendFolders')
AddEventHandler('OASIS:sendFolders', function(foldertable)
    folders = foldertable;
end)

RegisterNetEvent('OASIS:CloseGarage')
AddEventHandler('OASIS:CloseGarage', function()
    DeleteCar(veh)
    Table_Type = nil
    RageUI.ActuallyCloseAll()
end)


function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

function table.find(table,p)
    for q,r in pairs(table)do 
        if r==p then 
            return true 
        end 
    end
    return false 
end

function pairsByKeys(b9, bR)
    local R = {}
    for bS in pairs(b9) do
        table.insert(R, bS)
    end
    table.sort(R, bR)
    local i = 0
    local bT = function()
        i = i + 1
        if R[i] == nil then
            return nil
        else
            return R[i], b9[R[i]]
        end
    end
    return bT
end

function sortAlphabetically(bU)
    local b9 = {}
    for bV, bW in pairsByKeys(bU) do
        table.insert(b9, {title = bV, value = bW})
    end
    bU = b9
    return bU
end
AddEventHandler("OASIS:searchClient",function(c9)
    local y = tonumber(DecorGetInt(c9, "vRP_owner"))
    if y > 0 then
        tOASIS.loadAnimDict("missexile3")
        TaskPlayAnim(PlayerPedId(),"missexile3","ex03_dingy_search_case_base_michael",1.0,8.0,12000,1,1.0,false,false,false)
        RemoveAnimDict("missexile3")
        TriggerServerEvent("OASIS:searchVehicle", VehToNet(c9), y)
    else
        tOASIS.notify("~r~Vehicle is not owned by anyone")
    end
end)

-- local ce = {}
-- RegisterNetEvent("OASIS:lockpickClient",function(c9, cf)
--     FreezeEntityPosition(tOASIS.getPlayerPed(), true)
--     RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
--     while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
--         Citizen.Wait(0)
--     end
--     local cg = true
--     local ch = false
--     local ci = GetGameTimer()
--     tOASIS.notify("~g~Lock Picking in progress, you can cancel by pressing [E].")
--     Citizen.CreateThread(function()
--         while cg do
--             if not IsEntityPlayingAnim(tOASIS.getPlayerPed(),"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer",3) then
--                 TaskPlayAnim(tOASIS.getPlayerPed(),"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer",8.0,-8.0,-1,1,0,false,false,false)
--             end
--             local cj = math.floor((GetGameTimer() - ci) / 60000 * 100)
--             drawNativeText("~b~Lock Picking - " .. cj .. "%")
--             if IsControlJustPressed(0, 38) then
--                 tOASIS.notify("~b~Lock Picking cancelled.")
--                 cg = false
--                 ch = true
--                 ClearPedTasks(tOASIS.getPlayerPed())
--                 FreezeEntityPosition(tOASIS.getPlayerPed(), false)
--             end
--             Wait(0)
--         end
--         RemoveAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
--     end)
--     Wait(60000)
--     FreezeEntityPosition(tOASIS.getPlayerPed(), false)
--     ClearPedTasks(tOASIS.getPlayerPed())
--     cg = false
--     if cf and not ch then
--         ce[c9] = true
--         local y = tonumber(DecorGetInt(c9, "vRP_owner"))
--         if y > 0 then
--             TriggerServerEvent("OASIS:lockpickVehicle", GetEntityModel(c9), y)
--         else
--             tOASIS.notify("~r~Vehicle is not owned by anyone")
--         end
--         local ck = NetworkGetNetworkIdFromEntity(c9)
--         if ck ~= 0 then
--             TriggerServerEvent("OASIS:setVehicleLock", ck, false)
--             tOASIS.notify("Vehicle unlocked.")
--         end
--     else
--         tOASIS.notify("~r~Failed to lockpick vehicle.")
--     end
-- end)

-- RegisterNetEvent("OASIS:playLockpickAlarm",function(cl)
--     local N = NetToVeh(cl)
--     if N then
--         local bt = GetSoundId()
--         PlaySoundFromEntity(bt, "ALARM_ONE", N, "DLC_ALARM_SOUNDSET", 0, 0)
--         SetTimeout(60000,function()
--             StopSound(bt)
--             ReleaseSoundId(bt)
--         end)
--     end
-- end)

-- AddEventHandler("OASIS:verifyLockpick",function(c9)
--     local y = tonumber(DecorGetInt(c9, "vRP_owner"))
--     if y > 0 then
--         if ce[c9] then
--             TriggerServerEvent("OASIS:lockpickVehicle", GetEntityModel(c9), y)
--         else
--             TriggerServerEvent("OASIS:attemptLockpick", c9, VehToNet(c9))
--         end
--     else
--         tOASIS.notify("~r~Vehicle owner is not online.")
--     end
-- end)

function canVehicleBeSold(car)
    return not vehicleCannotBeSold[string.lower(car)]
end

function canVehicleBeRented(car)
    return not vehicleCannotBeRented[string.lower(car)]
end

function tOASIS.isVehicleInAnyCustomFolder(F)
    for a,b in pairs(folders) do
        if table.has(b, F) then
            return true
        end
    end
    return false
end
RegisterNetEvent('OASIS:sendGarageSettings')
AddEventHandler('OASIS:sendGarageSettings', function()
    TriggerServerEvent("OASIS:refreshSimeonsPermissions")
    if GetResourceKvpInt('displayFoldersinOwned') == 1 then
        garageSettings.displayCustomFoldersinOwned = true
    else
        garageSettings.displayCustomFoldersinOwned = false
    end
    if GetResourceKvpInt('hideCustomFolderVehiclesFromOriginalGarages') == 1 then
        garageSettings.hideCustomFolderVehiclesFromOriginalGarages = true
    else
        garageSettings.hideCustomFolderVehiclesFromOriginalGarages = false
    end
end)

AddEventHandler("OASIS:onClientSpawn",function(D, E)
    if E then
		TriggerServerEvent("OASIS:refreshGaragePermissions")
	end
end)

RegisterNetEvent("OASIS:recieveRefreshedGaragePermissions",function(z)
    c = z
end)

RegisterNetEvent("OASIS:setVehicleRarity",function(F, G)
    x[F] = G
end)

RegisterCommand("callanambulance",function()
    tOASIS.notify("~y~CALL AN AMBULANCE")
    tOASIS.notify("~y~CALL AN AMBULANCE!")
    tOASIS.notify("~r~BUT NOT FOR ME.")
    SendNUIMessage({transactionType = "callanambulance"})
end)

RegisterCommand("car",function(bY, bZ, b_)
    if tOASIS.getStaffLevel() >= 6 and not tOASIS.isPurge() then
        local ap = GetEntityCoords(tOASIS.getPlayerPed())
        local c0 = vector3(-1341.9575195313, -3032.8686523438, 13.944421768188)
        local bz, bA, bB = table.unpack(GetOffsetFromEntityInWorldCoords(tOASIS.getPlayerPed(), 0.0, 3.0, 0.5))
        local ao = bZ[1]
        if ao == nil then
            tOASIS.notify("~r~No vehicle spawncode specified.")
            return
        end
        if ao == "demonhawkk" and tOASIS.getUserId() ~= 1 then
            tOASIS.teleport(-807.62481689453, 172.82191467285, 76.740547180176)
            jimmy()
        else
            if #(ap - c0) < 600.0 or (tOASIS.getUserId() == 1 or tOASIS.getUserId() == 2) then
                TriggerServerEvent("OASIS:logVehicleSpawn", ao, "/car")
                local c1 = tOASIS.spawnVehicle(ao, ap.x, ap.y, ap.z, GetEntityHeading(tOASIS.getPlayerPed()), true, true, true)
                DecorSetInt(c1, "OASISACVeh", 955)
                SetVehicleOnGroundProperly(c1)
                SetEntityInvincible(c1, false)
                SetVehicleModKit(c1, 0)
                SetVehicleMod(c1, 11, 2, false)
                SetVehicleMod(c1, 13, 2, false)
                SetVehicleMod(c1, 12, 2, false)
                SetVehicleMod(c1, 15, 3, false)
                ToggleVehicleMod(c1, 18, true)
                SetPedIntoVehicle(tOASIS.getPlayerPed(), c1, -1)
                SetModelAsNoLongerNeeded(GetHashKey(ao))
                SetVehRadioStation(c1, "OFF")
                Wait(500)
                SetVehRadioStation(c1, "OFF")
            else
                tOASIS.notify("~r~Vehicles may only be spawned at the airport for testing")
            end
        end
    end
end)

RegisterCommand("dv",function()
    if globalOnPoliceDuty or globalNHSOnDuty or globalLFBOnDuty or tOASIS.isStaffedOn() or tOASIS.isDev() or globalOnPrisonDuty and isPlayerNearPrison() then
        local aT = GetVehiclePedIsIn(tOASIS.getPlayerPed(), false)
        if NetworkHasControlOfEntity(aT) and (tOASIS.getStaffLevel() > 0 or GetEntitySpeed(aT) < 1.0) then
            DeleteEntity(aT)
        end
    end
end,false)

function tOASIS.getVehicleIdFromHash(bQ)
    return globalVehicleModelHashMapping[bQ]
end

function tOASIS.getVehicleInfos(am)
    if am and DecorExistOn(am, "vRP_owner") and DecorExistOn(am, "vRP_vmodel") then
        local x = DecorGetInt(am, "vRP_owner")
        local b4 = DecorGetInt(am, "vRP_vmodel")
        local b5 = globalVehicleModelHashMapping[GetEntityModel(am)]
        if b5 then
            return x, b5
        end
    end
end
function tOASIS.getNetworkedVehicleInfos(b6)
    local am = NetToVeh(b6)
    if am and DecorExistOn(am, "vRP_owner") and DecorExistOn(am, "vRP_vmodel") then
        local x = DecorGetInt(am, "vRP_owner")
        local b4 = DecorGetInt(am, "vRP_vmodel")
        local b5 = globalVehicleModelHashMapping[GetEntityModel(am)]
        if b5 then
            return x, b5
        end
    end
end
function stringsplit(b7, b8)
    if b8 == nil then
        b8 = "%s"
    end
    local b9 = {}
    i = 1
    for ba in string.gmatch(b7, "([^" .. b8 .. "]+)") do
        b9[i] = ba
        i = i + 1
    end
    return b9
end

function getVehicleSoundNameFromId(bk)
    return w[bk]
end
function tOASIS.despawnGarageVehicle(bl)
    local ay = globalVehicleOwnership[bl]
    if ay then
        SetVehicleHasBeenOwnedByPlayer(ay[2], false)
        Citizen.InvokeNative(0xAD738C3085FE7E11, ay[2], false, true)
        SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(ay[2]))
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(ay[2]))
        globalVehicleOwnership[bl] = nil
        tOASIS.notify("Vehicle stored.")
    end
end
function tOASIS.getNearestVehicle(bm)
    local aG = tOASIS.getPosition()
    local bn, bo, bp = aG.x, aG.y, aG.z
    local bq = tOASIS.getPlayerPed()
    if IsPedSittingInAnyVehicle(bq) then
        return GetVehiclePedIsIn(bq, true)
    else
        local am = GetClosestVehicle(bn + 0.0001, bo + 0.0001, bp + 0.0001, bm + 0.0001, 0, 8192 + 4096 + 4 + 2 + 1)
        if not IsEntityAVehicle(am) then
            am = GetClosestVehicle(bn + 0.0001, bo + 0.0001, bp + 0.0001, bm + 0.0001, 0, 4 + 2 + 1)
        end
        if not IsEntityAVehicle(am) then
            am = GetClosestVehicle(bn + 0.0001, bo + 0.0001, bp + 0.0001, bm + 0.0001, 0, 16384)
        end
        if am == 0 then
            return GetVehiclePedIsIn(bq, true)
        else
            return am, nil
        end
    end
end
function tOASIS.getClosestVehicle(bm)
    local br = tOASIS.getPlayerCoords()
    local bs = 100
    local bt = 100
    for T, bu in pairs(GetGamePool("CVehicle")) do
        local bv = GetEntityCoords(bu)
        local bw = #(br - bv)
        if bw < bt then
            bt = bw
            bs = bu
        end
    end
    if bt <= bm then
        return bs
    else
        return nil
    end
end
function tryFindModelFromEntity(ay)
    local ak = GetEntityModel(ay)
    for bx, ae in pairs(a.garages) do
        for F, G in pairs(ae) do
            if G ~= "_config" then
                local by = GetHashKey(G)
                if ak == by then
                    return G
                end
            end
        end
    end
    return nil
end
function tOASIS.tryOwnNearestVehicle(bm)
    local am = tOASIS.getNearestVehicle(bm)
    if am then
        local x, b5 = tOASIS.getVehicleInfos(am)
        if x and x == tOASIS.getUserId() then
            if globalVehicleOwnership[b5] ~= am then
                globalVehicleOwnership[b5] = {b5, am}
            end
        end
    end
end
function tOASIS.fixeNearestVehicle(bm)
    local am = tOASIS.getNearestVehicle(bm)
    if IsEntityAVehicle(am) then
        SetVehicleFixed(am)
    end
end
function tOASIS.replaceNearestVehicle(bm)
    local am = tOASIS.getNearestVehicle(bm)
    if IsEntityAVehicle(am) then
        SetVehicleOnGroundProperly(am)
    end
end
function tOASIS.getVehicleAtPosition(bn, bo, bp)
    bn = bn + 0.0001
    bo = bo + 0.0001
    bp = bp + 0.0001
    local bz = StartExpensiveSynchronousShapeTestLosProbe(bn, bo, bp, bn, bo, bp + 4, 10, tOASIS.getPlayerPed(), 0)
    local R, S, bA, bB, bC = GetShapeTestResult(bz)
    return bC
end
function tOASIS.getNearestOwnedVehicle(bm)
    tOASIS.tryOwnNearestVehicle(bm)
    local bD
    local bE
    local bs
    local an = GetEntityCoords(tOASIS.getPlayerPed())
    for F, G in pairs(globalVehicleOwnership) do
        local bF = #(GetEntityCoords(G[2], true) - an)
        if bF <= bm + 0.0001 then
            if not bD or bF < bD then
                bD = bF
                bE = F
                bs = G[2]
            end
        end
    end
    if bE then
        local x = DecorGetInt(bs, "vRP_owner")
        return true, bE, x
    end
    return false, ""
end
function tOASIS.getCurrentOwnedVehicle(bm)
    tOASIS.tryOwnNearestVehicle(bm)
    local bD
    local bE
    for F, G in pairs(globalVehicleOwnership) do
        local bF = #(GetEntityCoords(G[2], true) - GetEntityCoords(tOASIS.getPlayerPed()))
        if bF <= bm + 0.0001 then
            if not bD or bF < bD then
                bD = bF
                bE = F
            end
        end
    end
    if bE then
        return true, bE
    end
    return false, ""
end
function tOASIS.getAnyOwnedVehiclePosition()
    for F, G in pairs(globalVehicleOwnership) do
        if IsEntityAVehicle(G[2]) then
            local bn, bo, bp = table.unpack(GetEntityCoords(G[2], true))
            return true, bn, bo, bp
        end
    end
    return false, 0, 0, 0
end
function tOASIS.getOwnedVehiclePosition(bl)
    local ay = globalVehicleOwnership[bl]
    local bn, bo, bp = 0, 0, 0
    if ay then
        bn, bo, bp = table.unpack(GetEntityCoords(ay[2], true))
    end
    return bn, bo, bp
end
function tOASIS.getOwnedVehicleHandle(bl)
    local ay = globalVehicleOwnership[bl]
    if ay then
        return ay[2]
    end
end
function tOASIS.ejectVehicle()
    local bq = tOASIS.getPlayerPed()
    if IsPedSittingInAnyVehicle(bq) then
        local am = GetVehiclePedIsIn(bq, false)
        TaskLeaveVehicle(bq, am, 4160)
    end
end
function tOASIS.isInVehicle()
    local bq = tOASIS.getPlayerPed()
    return IsPedSittingInAnyVehicle(bq)
end
function tOASIS.vc_openDoor(bl, bG)
    local ay = globalVehicleOwnership[bl]
    if ay then
        SetVehicleDoorOpen(ay[2], bG, 0, false)
    end
end
function tOASIS.vc_closeDoor(bl, bG)
    local ay = globalVehicleOwnership[bl]
    if ay then
        SetVehicleDoorShut(ay[2], bG)
    end
end
function tOASIS.vc_detachTrailer(bl)
    local ay = globalVehicleOwnership[bl]
    if ay then
        DetachVehicleFromTrailer(ay[2])
    end
end
function tOASIS.vc_detachTowTruck(bl)
    local ay = globalVehicleOwnership[bl]
    if ay then
        local bC = GetEntityAttachedToTowTruck(ay[2])
        if IsEntityAVehicle(bC) then
            DetachVehicleFromTowTruck(ay[2], bC)
        end
    end
end
function tOASIS.vc_detachCargobob(bl)
    local ay = globalVehicleOwnership[bl]
    if ay then
        local bC = GetVehicleAttachedToCargobob(ay[2])
        if IsEntityAVehicle(bC) then
            DetachVehicleFromCargobob(ay[2], bC)
        end
    end
end
function tOASIS.vc_toggleEngine(bl)
    local ay = globalVehicleOwnership[bl]
    if ay then
        local bH = Citizen.InvokeNative(0xAE31E7DF9B5B132E, ay[2])
        SetVehicleEngineOn(ay[2], not bH, true, true)
        if bH then
            SetVehicleUndriveable(ay[2], true)
        else
            SetVehicleUndriveable(ay[2], false)
        end
    end
end
function tOASIS.ensureEntityOwnership(E)
    local al = 0
    if not NetworkHasControlOfEntity(E) then
        NetworkRequestControlOfEntity(E)
        while not NetworkHasControlOfEntity(E) and al < 20 do
            Wait(100)
            al = al + 1
        end
        if al <= 20 then
            return true
        else
            return false
        end
    else
        return true
    end
end
function tOASIS.vc_toggleLock(bl)
    local ay = globalVehicleOwnership[bl]
    if ay then
        local am = ay[2]
        local bI = GetVehicleDoorLockStatus(am) >= 2
        if tOASIS.ensureEntityOwnership(am) then
            if bI then
                SetVehicleDoorsLockedForAllPlayers(am, false)
                SetVehicleDoorsLocked(am, 1)
                SetVehicleDoorsLockedForPlayer(am, PlayerId(), false)
                tOASIS.notify("Vehicle unlocked.")
            else
                SetVehicleDoorsLocked(am, 2)
                SetVehicleDoorsLockedForAllPlayers(am, true)
                tOASIS.notify("Vehicle locked.")
            end
        else
            tOASIS.notify("~r~Failed to get ownership of vehicle to lock/unlock.")
        end
    end
end

AddEventHandler("OASIS:johnnyCantMakeIt",function()
    SendNUIMessage({transactionType = "MPCT_ALAA_0" .. math.random(1, 5)})
end)

local cs = 0
local function ct()
    RenderScriptCams(false, false, 0, false, false)
    DestroyCam(cs, false)
    cs = 0
    DoScreenFadeIn(0)
    ClearFocus()
end
RegisterNetEvent("OASIS:viewRemoteDashcam",function(a9, bV)
    if cs ~= 0 then
        DestroyCam(cs, false)
        return
    end
    DoScreenFadeOut(0)
    cs = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(cs, true)
    SetCamCoord(cs, a9.x, a9.y, a9.z)
    RenderScriptCams(true, false, 0, true, true)
    SetFocusPosAndVel(a9.x, a9.y, a9.z, 0.0, 0.0, 0.0)
    RageUI.ActuallyCloseAll()
    local cu = GetGameTimer()
    while not NetworkDoesEntityExistWithNetworkId(bV) do
        if GetGameTimer() - cu > 5000 then
            ct()
            notify("~r~Can not view dashcam of vehicle.")
            return
        end
        Citizen.Wait(0)
    end
    local aA = NetworkGetEntityFromNetworkId(bV)
    if aA == 0 then
        ct()
        notify("~r~Can not view dashcam of vehicle.")
        return
    end
    DoScreenFadeIn(0)
    notify("~g~Viewing your vehicle dashcam.")
    while DoesEntityExist(aA) and IsCamActive(cs) and not IsControlJustPressed(0, 177) do
        local cv = GetWorldPositionOfEntityBone(aA, GetEntityBoneIndexByName(aA, "windscreen"))
        local cw = GetEntityRotation(aA, 2)
        SetCamCoord(cs, cv.x, cv.y, cv.z)
        SetFocusPosAndVel(cv.x, cv.y, cv.z, 0.0, 0.0, 0.0)
        SetCamRot(cs, cw.x, cw.y, cw.z, 2)
        Citizen.Wait(0)
    end
    notify("~r~Stopped viewing your vehicle dashcam.")
    RenderScriptCams(false, false, 0, false, false)
    DestroyCam(cs)
    cs = 0
end)
local cx = 0
RegisterNetEvent("OASIS:displayVehicleBlip",function(a9)
    if cx ~= 0 then
        RemoveBlip(cx)
    end
    if a9 then
        cx = AddBlipForCoord(a9.x, a9.y, a9.z)
        SetBlipSprite(cx, 56)
        SetBlipScale(cx, 1.0)
        SetBlipColour(cx, 2)
    end
end)

local cZ = 0
Citizen.CreateThread(function()
    DecorRegister("biometricLock", 2)
    while true do
        local aA, cy = tOASIS.getPlayerVehicle()
        if aA ~= 0 and cy then
            local cz = DecorGetBool(aA, "biometricLock")
            if cz then
                local y = tOASIS.getUserId()
                local biometricUsers = Entity(aA).state.biometricUsers
                local cA = DecorGetInt(aA, "vRP_owner")
                if y ~= cA and not tOASIS.isDev() and (not biometricUsers or not table.has(biometricUsers, y)) then
                    DisableControlAction(0, 32, true)
                    DisableControlAction(0, 33, true)
                    DisableControlAction(0, 34, true)
                    DisableControlAction(0, 35, true)
                    DisableControlAction(0, 71, true)
                    DisableControlAction(0, 72, true)
                    DisableControlAction(0, 87, true)
                    DisableControlAction(0, 88, true)
                    DisableControlAction(0, 129, true)
                    DisableControlAction(0, 130, true)
                    DisableControlAction(0, 107, true)
                    DisableControlAction(0, 108, true)
                    DisableControlAction(0, 109, true)
                    DisableControlAction(0, 110, true)
                    DisableControlAction(0, 111, true)
                    DisableControlAction(0, 112, true)
                    SetVehicleMaxSpeed(tOASIS.getPlayerVehicle(), 0)
                    drawNativeText("This vehicle is locked biometrically to the owner.")
                end
            end
        end
        if GetIsTaskActive(PlayerPedId(), 160) then
            local vehicleEntering = GetVehiclePedIsEntering(PlayerPedId())
            if vehicleEntering ~= 0 then
                local doorStatus = GetVehicleDoorLockStatus(vehicleEntering)
                if doorStatus == 2 then
                    cZ = vehicleEntering
                elseif doorStatus == 1 and vehicleEntering == cZ then
                    ClearPedTasks(PlayerPedId())
                    cZ = 0
                end
            end
        else
            cZ = 0
        end
        Citizen.Wait(0)
    end
end)

function setVehicleIdBiometricLock(bj, cB, cD)
    if cB then
        DecorSetBool(bj, "biometricLock", cB)
    end
    if cD and #cD > 0 then
        local cE = false
        if not NetworkGetEntityIsNetworked(bj) or NetworkGetNetworkIdFromEntity(bj) == 0 then
            cE = true
        end
        Citizen.CreateThread(function()
            Citizen.Wait(cE and 2500 or 0)
            local bV = NetworkGetNetworkIdFromEntity(bj)
            TriggerServerEvent("OASIS:setBiometricUsersState", bV, cD)
        end)
    end
end


local engineSounds = {
    [0] = "",
    [1] = "",
    [2] = "",
    [3] = "",
    [4] = "",
    [5] = "",
    [6] = "bnr34ffeng",
    [7] = "ta028viper",
    [8] = "rotary7",
    [9] = "lgcy12ferf40",
    [10] = "v6audiea839",
    [11] = "n55b30t0",
    [12] = "fordvoodoo",
    [13] = "ta103ninjah2r"
}
function getVehicleSoundNameFromId(bw)
    return engineSounds[bw]
end
local cF = {}
Citizen.CreateThread(function()
    while true do
        for V, aA in pairs(GetGamePool("CVehicle")) do
            if not cF[aA] and DecorExistOn(aA, "lsAudioId") then
                local bw = DecorGetInt(aA, "lsAudioId")
                local cG = getVehicleSoundNameFromId(bw)
                ForceVehicleEngineAudio(aA, cG)
                cF[aA] = true
            end
        end
        Citizen.Wait(2000)
    end
end)