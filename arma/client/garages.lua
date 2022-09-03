local cfg = module("arma-vehicles", "garages")
local b = cfg.garages
local garage_type = "Car"
local selected_category = nil
local Hovered_Vehicles = nil
local VehiclesFetchedTable = {}
local Table_Type = nil
local RentedVeh = false
local SelectedCar = {spawncode = nil, name = nil, plate = nil}
local veh = nil 
local cantload = {}
local vehname = nil 
local folders = {}
local SelectedfolderName = nil
local c = {}

local vehicleCannotBeSold = {
    ["demonhawkk"] = true,
}

local vehicleCannotBeRented = {
    ["demonhawkk"] = true,
}

RMenu.Add('ARMAGarages', 'main', RageUI.CreateMenu("", "~b~Arma Garages",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "banners", "garage"))
RMenu.Add('ARMAGarages', 'owned_vehicles',  RageUI.CreateSubMenu(RMenu:Get("ARMAGarages", "main")))
RMenu.Add('ARMAGarages', 'rented_vehicles',  RageUI.CreateSubMenu(RMenu:Get("ARMAGarages", "main")))
RMenu.Add('ARMAGarages', 'rented_vehicles_manage',  RageUI.CreateSubMenu(RMenu:Get("ARMAGarages", "rented_vehicles")))
RMenu.Add('ARMAGarages', 'owned_vehicles_submenu',  RageUI.CreateSubMenu(RMenu:Get("ARMAGarages", "owned_vehicles")))
RMenu.Add('ARMAGarages', 'owned_vehicles_submenu_manage',  RageUI.CreateSubMenu(RMenu:Get("ARMAGarages", "owned_vehicles_submenu")))
RMenu.Add('ARMAGarages', 'scrap_vehicle_confirmation',  RageUI.CreateSubMenu(RMenu:Get("ARMAGarages", "owned_vehicles_submenu_manage")))
RMenu.Add('ARMAGarages', 'rented_vehicles_out_manage',  RageUI.CreateSubMenu(RMenu:Get("ARMAGarages", "rented_vehicles")))
RMenu.Add('ARMAGarages', 'rented_vehicles_out_manage_submenu',  RageUI.CreateSubMenu(RMenu:Get("ARMAGarages", "rented_vehicles_out_manage")))
RMenu.Add('ARMAGarages', 'rented_vehicles_out_information',  RageUI.CreateSubMenu(RMenu:Get("ARMAGarages", "rented_vehicles_out_manage_submenu")))
RMenu.Add('ARMAGarages', 'customfolders',  RageUI.CreateSubMenu(RMenu:Get("ARMAGarages", "owned_vehicles")))
RMenu.Add('ARMAGarages', 'customfoldersvehicles',  RageUI.CreateSubMenu(RMenu:Get("ARMAGarages", "customfolders")))
RMenu.Add('ARMAGarages', 'settings',  RageUI.CreateSubMenu(RMenu:Get("ARMAGarages", "main")))
RMenu:Get('ARMAGarages', 'owned_vehicles'):SetSubtitle("~b~Garage Mangement Menu")


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
    if RageUI.Visible(RMenu:Get('ARMAGarages', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            DeleteCar(veh)
            RageUI.Button("Garages", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) 
                if Selected then
                    VehiclesFetchedTable = {}
                    Table_Type = true
                    TriggerServerEvent('ARMA:FetchCars', Table_Type, garage_type)
                    TriggerServerEvent('ARMA:getCustomFolders')
                end
            end, RMenu:Get("ARMAGarages", "owned_vehicles"))
            RageUI.Button("Store Vehicle", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) 
                if Selected then 
                    tARMA.despawnGarageVehicle(garage_type,250)
                end
            end)
            RageUI.Button("Rent Manager", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get("ARMAGarages", "rented_vehicles"))
            RageUI.Button("Settings", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get("ARMAGarages", "settings"))
        end)
    end
    if RageUI.Visible(RMenu:Get('ARMAGarages', 'settings')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Checkbox('Display Custom Folders in Owned Vehicles', nil, displayCustomFoldersinOwned, { RightLabel = "" }, function(Hovered, Active, Selected, Checked)
                if Selected then
                    displayCustomFoldersinOwned = not displayCustomFoldersinOwned
                    if displayCustomFoldersinOwned then
                        SetResourceKvpInt('displayFoldersinOwned', 1)
                    else
                        SetResourceKvpInt('displayFoldersinOwned', 0)
                    end
                end
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('ARMAGarages', 'owned_vehicles')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            DeleteCar(veh)
            RentedVeh = false
            RageUI.Button("[Custom Folders]", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then 
                    for i,v in pairs(VehiclesFetchedTable) do 
                        if garage_type == VehiclesFetchedTable[i].config.vtype then 
                            selected_category = v.vehicles
                        end
                    end
                end
            end, RMenu:Get("ARMAGarages", "customfolders"))
            if displayCustomFoldersinOwned then
                for h,b in pairs(folders) do
                    RageUI.Button(h , nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SelectedfolderName = h
                        end
                    end, RMenu:Get("ARMAGarages", "customfoldersvehicles"))
                end
            end
            for i,v in pairs(VehiclesFetchedTable) do 
                if garage_type == VehiclesFetchedTable[i].config.vtype then 
                    RageUI.Button(i, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then 
                            selected_category = v.vehicles
                        end
                    end, RMenu:Get("ARMAGarages", "owned_vehicles_submenu"))
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('ARMAGarages', 'owned_vehicles_submenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for i,v in pairs(selected_category) do
                if RentedVeh then 
                    RageUI.Separator("~g~Rent Manager")
                    RageUI.Button(v[1], "Click to manage", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then 
                            SelectedCar.spawncode = i 
                            SelectedCar.name = v[1]
                            SelectedCar.timeleft = v[2]
                            RMenu:Get('ARMAGarages', 'owned_vehicles_submenu_manage'):SetSubtitle("~r~" .. v[1])
                        end
                        if Active then 
                            Hovered_Vehicles = i
                        end
                    end,RMenu:Get("ARMAGarages", "owned_vehicles_submenu_manage"))
                else 
                    RageUI.Button(v[1], nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then 
                            SelectedCar.spawncode = i 
                            SelectedCar.name = v[1]
                            SelectedCar.plate = v[3] -- invdividual vehicle plate from db
                            RMenu:Get('ARMAGarages', 'owned_vehicles_submenu_manage'):SetSubtitle("~r~" .. v[1])
                        end
                        if Active then 
                            Hovered_Vehicles = i
                        end
                    end,RMenu:Get("ARMAGarages", "owned_vehicles_submenu_manage")) 
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('ARMAGarages', 'owned_vehicles_submenu_manage')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if RentedVeh then
                RageUI.Separator("~g~Rent Info")
                RageUI.Separator("Vehicle: " .. SelectedCar.name)
                RageUI.Separator("Spawncode: " .. SelectedCar.spawncode)
                RageUI.Separator("Time Left: " .. SelectedCar.timeleft)
                RageUI.Button('Request Rent Cancellation', "~y~This will cancel the rent of " ..SelectedCar.name, {}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        TriggerServerEvent("ARMA:CancelRent", SelectedCar.spawncode, SelectedCar.name, 'renter')
                    end
                end)
            end
                RageUI.Button('Spawn Vehicle', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        tARMA.spawnGarageVehicle(garage_type, SelectedCar.spawncode, GetEntityCoords(PlayerPedId()), SelectedCar.plate)
                        DeleteCar(veh)
                        RageUI.ActuallyCloseAll()
                    end
                end)
            if not RentedVeh then
                RageUI.Button('Crush Vehicle', 'This will ~r~DELETE ~w~this vehicle from your garage.', {RightLabel = "→→→"}, canVehicleBeSold(SelectedCar.spawncode), function(Hovered, Active, Selected)
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
                                    TriggerServerEvent('ARMA:ScrapVehicle', SelectedCar.spawncode) 
                                    Table_Type = nil
                                    RageUI.ActuallyCloseAll()
                                    RageUI.Visible(RMenu:Get('ARMAGarages', 'main'), true)  
                                end
                            end
                        end
                    end
                end)
                RageUI.Button('Rent Vehicle to Player', nil, {RightLabel = "→→→"}, canVehicleBeRented(SelectedCar.spawncode), function(Hovered, Active, Selected)
                    if Selected and canVehicleBeSold(SelectedCar.spawncode) then
                        TriggerServerEvent('ARMA:RentVehicle', SelectedCar.spawncode) 
                    end
                end)
                RageUI.Button('Sell Vehicle to Player', nil, {RightLabel = "→→→"}, canVehicleBeSold(SelectedCar.spawncode), function(Hovered, Active, Selected)
                    if Selected and canVehicleBeSold(SelectedCar.spawncode) then 
                        TriggerServerEvent('ARMA:SellVehicle', SelectedCar.spawncode)
                    end
                end)
                RageUI.Button('Add to Custom Folder', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        local folderName = tARMA.KeyboardInput("Enter Folder Name", "", 25)
                        if folderName ~= nil then
                            if folders[folderName] ~= nil then
                                if not table.find(folders[folderName], SelectedCar.spawncode) then
                                    table.insert(folders[folderName], SelectedCar.spawncode)
                                    tARMA.notify("~g~"..SelectedCar.name.." was added to "..folderName)
                                    TriggerServerEvent("ARMA:updateFolders", folders)
                                else
                                    tARMA.notify("~r~This Car is already in "..folderName)
                                end
                            else
                                tARMA.notify("~r~Folder "..folderName.." does not exist.")
                            end
                        end
                    end
                end)
                RageUI.Button('Remove from Custom Folder', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        local folderName = tARMA.KeyboardInput("Enter Folder Name", "", 25)
                        if folderName ~= nil then
                            if folders[folderName] ~= nil then
                                if table.find(folders[folderName], SelectedCar.spawncode) then
                                    for i = 1, #folders[folderName] do
                                        if folders[folderName][i] == SelectedCar.spawncode then
                                            table.remove(folders[folderName], i)
                                            TriggerServerEvent("ARMA:updateFolders", folders)
                                            tARMA.notify("~g~"..SelectedCar.name.." was removed from "..folderName)
                                        end
                                    end
                                else
                                    tARMA.notify("~r~"..SelectedCar.name.." is not in "..folderName)
                                end
                            else
                                tARMA.notify("~r~Folder "..folderName.." does not exist.")
                            end
                        end
                    end
                end)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('ARMAGarages', 'customfolders')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("[Create Custom Folder]" , "Create a custom folder.", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local folderName = tARMA.KeyboardInput("Enter Folder Name", "", 25)
                    if folderName ~= nil then
                        if folders[folderName] == nil then
                            folders[folderName] = {}
                            TriggerServerEvent("ARMA:updateFolders", folders)
                            tARMA.notify("~g~Created custom folder "..folderName)
                        else
                            tARMA.notify("~r~Folder already exists.")
                        end
                    else
                        tARMA.notify("~r~Invalid folder name.")
                    end
                end
            end)
            RageUI.Button("[Delete Custom Folder]" , "Delete a custom folder", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local folderName = tARMA.KeyboardInput("Enter Folder name", "", 25)
                    if folderName ~= nil then
                        if folders[folderName] ~= nil then
                            folders[folderName] = nil
                            tARMA.notify("~g~Deleted custom folder "..folderName)
                            TriggerServerEvent("ARMA:updateFolders", folders)
                        else
                            tARMA.notify("~r~Folder "..folderName.." does not exist.")
                        end
                    else
                        tARMA.notify("~r~Invalid folder name.")
                    end
                end
            end)
            for h,b in pairs(folders) do
                RageUI.Button(h , nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        SelectedfolderName = h
                    end
                end, RMenu:Get("ARMAGarages", "customfoldersvehicles"))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('ARMAGarages', 'customfoldersvehicles')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for k,v in pairs(folders) do
                if k == SelectedfolderName then
                    if #folders[SelectedfolderName] < 1 then; RageUI.Separator('This folder does not contain any vehicles'); end
                    for i = 1, #folders[SelectedfolderName] do
                        for a,b in pairs(VehiclesFetchedTable) do 
                            for c,d in pairs(b.vehicles) do
                                if c == v[i] then
                                    RageUI.Button(d[1], "", {RightLabel = nil}, true, function(Hovered, Active, Selected)
                                        if Selected then
                                            SelectedCar.spawncode = v[i]
                                            SelectedCar.name = d[1]
                                        end
                                        if Active then 
                                            Hovered_Vehicles = v[i]
                                        end
                                    end,RMenu:Get("ARMAGarages", "owned_vehicles_submenu_manage")) 
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('ARMAGarages', 'rented_vehicles')) then 
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            DeleteCar(veh)
            RageUI.Button('Rented Vehicles Out', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    Table_Type = nil
                    TriggerServerEvent('ARMA:FetchVehiclesOut')
                end
            end,RMenu:Get("ARMAGarages", "rented_vehicles_out_manage"))
            RageUI.Button('Rented Vehicles In', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    Table_Type = nil
                    RentedVeh = true
                    TriggerServerEvent('ARMA:FetchVehiclesIn')
                end
            end,RMenu:Get("ARMAGarages", "rented_vehicles_manage"))
        end)
    end
    if RageUI.Visible(RMenu:Get('ARMAGarages', 'rented_vehicles_out_manage')) then 
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            Hovered_Vehicles = nil 
            DeleteCar(veh)
            for i,v in pairs(VehiclesFetchedTable) do 
                if garage_type == VehiclesFetchedTable[i].config.vtype then 
                    RageUI.Button(i, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then 
                            RentedVeh = true
                            selected_category = v.vehicles
                        end
                    end, RMenu:Get("ARMAGarages", "rented_vehicles_out_manage_submenu"))
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('ARMAGarages', 'rented_vehicles_out_manage_submenu')) then 
        RageUI.DrawContent({header = true, glare = false, instructionalButton = true}, function()
            for i,v in pairs(selected_category) do 
                RageUI.Button(v[1], 'Click to view rental information', {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        SelectedCar.spawncode = v[4]
                        SelectedCar.name = v[1]
                        SelectedCar.timeleft = v[2]
                        SelectedCar.rentedto = v[3]
                    end
                end, RMenu:Get("ARMAGarages", "rented_vehicles_out_information"))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('ARMAGarages', 'rented_vehicles_out_information')) then 
        RageUI.DrawContent({header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("~g~Rent Info")
            RageUI.Separator("Vehicle: " .. SelectedCar.name)
            RageUI.Separator("Spawncode: " .. SelectedCar.spawncode)
            RageUI.Separator("Time Left: " .. SelectedCar.timeleft)
            RageUI.Separator("Rented To ID: " .. SelectedCar.rentedto)
            RageUI.Button('Request Rent Cancellation', "~y~This will cancel the rent of " ..SelectedCar.name, {}, true, function(Hovered, Active, Selected)
                if Selected then 
                    TriggerServerEvent("ARMA:CancelRent", SelectedCar.spawncode, SelectedCar.name, 'owner')
                end
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('ARMAGarages', 'rented_vehicles_manage')) then 
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            Hovered_Vehicles = nil 
            DeleteCar(veh)
            for i,v in pairs(VehiclesFetchedTable) do 
                if garage_type == VehiclesFetchedTable[i].config.vtype then 
                    RageUI.Button(i, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then 
                            RentedVeh = true
                            selected_category = v.vehicles
                        end
                    end, RMenu:Get("ARMAGarages", "owned_vehicles_submenu"))
                end
            end
        end)
    end
end)


Citizen.CreateThread(function()
    while true do 
        Wait(0)
        if Hovered_Vehicles then 
            if vehname and vehname ~= Hovered_Vehicles then 
                DeleteEntity(veh)
                vehname = Hovered_Vehicles
            end
            local hash = GetHashKey(Hovered_Vehicles)
            if not DoesEntityExist(veh) and not IsPedInAnyVehicle(PlayerPedId(), false) and not cantload[Hovered_Vehicles] and Hovered_Vehicles then
                local i = 0
                while not HasModelLoaded(hash) do
                    RequestModel(hash)
                    i = i + 1
                    Citizen.Wait(10)
                    if i > 30 then
                        tARMA.notify('~r~Model could not be loaded!') 
                        if vehname then 
                            cantload[vehname] = true
                        end
                        break 
                    end
                end
                local coords = GetEntityCoords(PlayerPedId())
                vehname = Hovered_Vehicles
                veh = CreateVehicle(hash,coords.x, coords.y, coords.z + 1, 0.0,false,false)
                FreezeEntityPosition(veh,true)
                SetEntityInvincible(veh,true)
                SetVehicleDoorsLocked(veh,4)
                SetModelAsNoLongerNeeded(hash)
                for i = 0,24 do
                    SetVehicleModKit(veh,0)
                    RemoveVehicleMod(veh,i)
                end
                SetEntityCollision(veh, false, false)
                Citizen.CreateThread(function()
                    while DoesEntityExist(veh) do
                        Citizen.Wait(25)
                        SetEntityHeading(veh, GetEntityHeading(veh)+1 %360)
                    end
                end)
            end
        end
    end
end)



RegisterNetEvent('ARMA:ReturnFetchedCars')
AddEventHandler('ARMA:ReturnFetchedCars', function(table)
    VehiclesFetchedTable = table
end)

RegisterNetEvent('ARMA:sendFolders')
AddEventHandler('ARMA:sendFolders', function(foldertable)
    folders = foldertable;
end)

RegisterNetEvent('ARMA:CloseGarage')
AddEventHandler('ARMA:CloseGarage', function()
    DeleteCar(veh)
    Table_Type = nil
    RageUI.ActuallyCloseAll()
end)

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
        RageUI.Visible(RMenu:Get("ARMAGarages", "main"), true)
    end
end
local function X(J)
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("ARMAGarages", "main"), false)
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
        selectedGarageVector = aa.position
    end
    local ab = function(aa)
        PlaySound(-1, "Hit", "RESPAWN_SOUNDSET", 0, 0, 1)
        X(aa.garageType)
    end
    local ac = function(aa)
    end
    for ad, ae in pairs(cfg.garageInstances) do
        tARMA.createArea("garage_" .. ad,ae[2],1.5,6,a9,ab,ac,{garageType = ae[1], garageId = ad, position = ae[2]})
    end
    for _, af in pairs(Y) do
        tARMA.addBlip(af.position.x, af.position.y, af.position.z, af.blipId, af.blipColor, af.name, 0.7, false)
    end
    for a1, ag in pairs(Z) do
        tARMA.addMarker(ag.position.x,ag.position.y,ag.position.z,0.7,0.7,0.5,ag.colour[1],ag.colour[2],ag.colour[3],125,50,ag.markerId,true)
    end
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

function canVehicleBeSold(car)
    return not vehicleCannotBeSold[string.lower(car)]
end

function canVehicleBeRented(car)
    return not vehicleCannotBeRented[string.lower(car)]
end

RegisterNetEvent('ARMA:sendGarageSettings')
AddEventHandler('ARMA:sendGarageSettings', function()
    if GetResourceKvpInt('displayFoldersinOwned') == 1 then
        displayCustomFoldersinOwned = true
    else
        displayCustomFoldersinOwned = false
    end
end)

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		TriggerServerEvent("ARMA:refreshGaragePermissions")
		firstspawn = 1
	end
end)

RegisterNetEvent("ARMA:recieveRefreshedGaragePermissions",function(z)
    c = z
end)

-- function tARMA.getIsVip(j)
--     currentVIP = tARMA.getCurrentPlayerInfo('currentVIP')
--     if currentVIP then
--         for a,b in pairs(currentVIP) do
--             if b == j then
--                 return true
--             end
--         end
--         return false
--     end
-- end

-- function tARMA.getIsRebel(j)
--     currentRebel = tARMA.getCurrentPlayerInfo('currentRebel')
--     if currentRebel then
--         for a,b in pairs(currentRebel) do
--             if b == j then
--                 return true
--             end
--         end
--         return false
--     end
-- end