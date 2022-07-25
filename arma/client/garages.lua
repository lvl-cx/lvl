local cfg = module("arma-vehicles", "garages")
local vehcategories = cfg.garage_types
local garage_type = "car"
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

local vehicleCannotBeSold = {
    ["demonhawkk"] = true,
}

local vehicleCannotBeRented = {
    ["demonhawkk"] = true,
}

RMenu.Add('ARMAGarages', 'main', RageUI.CreateMenu("", "~b~Arma Garages",1350,10, "banners", "garages"))
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
            for i,v in pairs(VehiclesFetchedTable) do 
                if garage_type == VehiclesFetchedTable[i].config.vtype then 
                    RageUI.Button(i, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then 
                            selected_category = v.vehicles
                        end
                    end, RMenu:Get("ARMAGarages", "owned_vehicles_submenu"))
                end
            end
            RageUI.Button("[Custom Folders]", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then 
                    for i,v in pairs(VehiclesFetchedTable) do 
                        if garage_type == VehiclesFetchedTable[i].config.vtype then 
                            selected_category = v.vehicles
                        end
                    end
                end
            end, RMenu:Get("ARMAGarages", "customfolders"))
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
                        tARMA.spawnGarageVehicle(garage_type, SelectedCar.spawncode, GetEntityCoords(PlayerPedId()))
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
                                if result == 'CONFIRM' then
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
                        local folderName = KeyboardInput("Enter Folder Name", "", 25)
                        if folderName ~= nil then
                            if folders[folderName] ~= nil then
                                if not table.find(folders[folderName], SelectedCar.spawncode) then
                                    table.insert(folders[folderName], SelectedCar.spawncode)
                                    notify("~g~"..SelectedCar.name.." was added to "..folderName)
                                    TriggerServerEvent("ARMA:updateFolders", folders)
                                else
                                    notify("~r~This Car is already in "..folderName)
                                end
                            else
                                notify("~r~Folder "..folderName.." does not exist.")
                            end
                        end
                    end
                end)
                RageUI.Button('Remove from Custom Folder', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        local folderName = KeyboardInput("Enter Folder Name", "", 25)
                        if folderName ~= nil then
                            if folders[folderName] ~= nil then
                                if table.find(folders[folderName], SelectedCar.spawncode) then
                                    for i = 1, #folders[folderName] do
                                        if folders[folderName][i] == SelectedCar.spawncode then
                                            table.remove(folders[folderName], i)
                                            TriggerServerEvent("ARMA:updateFolders", folders)
                                            notify("~g~"..SelectedCar.name.." was removed from "..folderName)
                                        end
                                    end
                                else
                                    notify("~r~"..SelectedCar.name.." is not in "..folderName)
                                end
                            else
                                notify("~r~Folder "..folderName.." does not exist.")
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
                    local folderName = KeyboardInput("Enter Folder Name", "", 25)
                    if folderName ~= nil then
                        if folders[folderName] == nil then
                            folders[folderName] = {}
                            TriggerServerEvent("ARMA:updateFolders", folders)
                            notify("~g~Created custom folder "..folderName)
                        else
                            notify("~r~Folder already exists.")
                        end
                    else
                        notify("~r~Invalid folder name.")
                    end
                end
            end)
            RageUI.Button("[Delete Custom Folder]" , "Delete a custom folder", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local folderName = KeyboardInput("Enter Folder name", "", 25)
                    if folderName ~= nil then
                        if folders[folderName] ~= nil then
                            folders[folderName] = nil
                            notify("~g~Deleted custom folder "..folderName)
                            TriggerServerEvent("ARMA:updateFolders", folders)
                        else
                            notify("~r~Folder "..folderName.." does not exist.")
                        end
                    else
                        notify("~r~Invalid folder name.")
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


Citizen.CreateThread(function()
    while true do 
        Wait(0)
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        for i,v in pairs(cfg.garages) do 
            local x,y,z = v[2], v[3], v[4]
            if #(PlayerCoords - vec3(x,y,z)) <= 150 then 
                local type = v[1]
                if type == "Car" then 
                    DrawMarker(36, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 00, 255, 00, 50, false, true, 2, true, nil, nil, false)
                elseif type == "Rebel" then 
                    DrawMarker(36, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 00, 50, false, true, 2, true, nil, nil, false)
                elseif type == "VIP" then 
                    DrawMarker(36, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 00, 50, false, true, 2, true, nil, nil, false)
                elseif type == "MET Police" then 
                    DrawMarker(36, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 255, 50, false, true, 2, true, nil, nil, false)
                elseif type == "Boat" then 
                    DrawMarker(35, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 00, 255, 00, 50, false, true, 2, true, nil, nil, false)
                elseif type == "Heli" then 
                    DrawMarker(34, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 00, 255, 00, 50, false, true, 2, true, nil, nil, false)
                elseif type == "MET Police Heli" then 
                    DrawMarker(34, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 00, 0, 255, 50, false, true, 2, true, nil, nil, false)
                elseif type == "VIP Heli" then 
                    DrawMarker(34, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 50, false, true, 2, true, nil, nil, false)
                elseif type == "Aircraft" then 
                    DrawMarker(34, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 50, false, true, 2, true, nil, nil, false)
                elseif type == "VIP Aircraft" then 
                    DrawMarker(34, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 50, false, true, 2, true, nil, nil, false)
                elseif type == "MET Police Boats" then 
                    DrawMarker(35, x, y, z -1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 00, 0, 255, 50, false, true, 2, true, nil, nil, false)
                end
            end
        end
    
    end
end)

local MenuOpen = false 
local inMarker = false
Citizen.CreateThread(function()
    while true do 
        Wait(250)
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        inMarker = false
        for i,v in pairs(cfg.garages) do 
            local x,y,z = v[2], v[3], v[4]
            if #(PlayerCoords - vec3(x,y,z)) <= 3.0 then 
                inMarker = true 
                garage_type = v[1]
                break
            end
        end
        if not MenuOpen and inMarker then
            MenuOpen = true
            RageUI.Visible(RMenu:Get('ARMAGarages', 'main'), true)  
        end
        if not inMarker and MenuOpen then
            DeleteCar(veh)
            Table_Type = nil
            RageUI.ActuallyCloseAll()
            MenuOpen = false
        end
    end
end)

for i,v in pairs(cfg.garages) do 
    local x,y,z = v[2], v[3], v[4]
    local Blip = AddBlipForCoord(x, y, z)
    if v[1] == "Car" then 
        SetBlipSprite(Blip, 50)
        SetBlipColour(Blip, 2)
        AddTextEntry("MAPBLIP", v[1] .. ' Garage')
    elseif v[1] == "Rebel" then 
        SetBlipSprite(Blip, 50)
        SetBlipColour(Blip, 1)
        AddTextEntry("MAPBLIP", v[1] .. ' Garage')
    elseif v[1] == "Boat" then 
        SetBlipSprite(Blip, 427)
        SetBlipColour(Blip, 2)
        AddTextEntry("MAPBLIP", v[1] .. 's')
    elseif v[1] == "MET Police" then 
        SetBlipSprite(Blip, 225)
        SetBlipColour(Blip, 38)
        AddTextEntry("MAPBLIP", v[1] .. ' Garage')
    elseif v[1] == "Heli" then 
        SetBlipSprite(Blip, 43)
        SetBlipColour(Blip, 2)
        AddTextEntry("MAPBLIP", v[1] .. 'copters')
    elseif v[1] == "VIP" then 
        SetBlipSprite(Blip, 225)
        SetBlipColour(Blip, 5)
        AddTextEntry("MAPBLIP", v[1] .. ' Garage')
    elseif v[1] == "VIP Heli" then 
        SetBlipSprite(Blip, 43)
        SetBlipColour(Blip, 5)
        AddTextEntry("MAPBLIP", v[1] .. 'copters')
    elseif v[1] == "MET Police Heli" then 
        SetBlipSprite(Blip, 43)
        SetBlipColour(Blip, 38) 
        AddTextEntry("MAPBLIP", v[1] .. 'copters')
    elseif v[1] == "VIP Aircraft" then 
        SetBlipSprite(Blip, 43)
        SetBlipColour(Blip, 38) 
        AddTextEntry("MAPBLIP", v[1] .. 'copters')
    elseif v[1] == "Aircraft" then 
        SetBlipSprite(Blip, 43)
        SetBlipColour(Blip, 38) 
        AddTextEntry("MAPBLIP", v[1] .. '')
    elseif v[1] == "MET Police Boats" then 
        SetBlipSprite(Blip, 427)
        SetBlipColour(Blip, 38)
        AddTextEntry("MAPBLIP", v[1] .. '')    
    else
        AddTextEntry("MAPBLIP", v[1] .. ' Garage')
    end
    SetBlipScale(Blip, 0.55)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("MAPBLIP")
    EndTextCommandSetBlipName(Blip)
    SetBlipCategory(Blip, 1)
end

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