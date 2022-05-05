local cfg = module("lvlcore/cfg/cfg_housing")

local inHome = false
local isInMenu = false
local isInLeaveMenu = false
local isInWardrobeMenu = false
local currentHome = nil
local currentOutfit = nil
local currentHousePrice = 0
local wardrobe = {}

local playerName = '[Not Owned]'

RMenu.Add("JudHousing", "main", RageUI.CreateMenu("", "~g~LVL Housing", 1350, 50, 'housing', 'housing'))
RMenu.Add("JudHousing", "leave", RageUI.CreateMenu("", "~g~LVL Housing", 1350, 50, 'housing', 'housing'))
RMenu.Add("JudHousing", "wardrobe", RageUI.CreateMenu("", "~g~LVL Housing Wardrobe", 1350, 50, 'wardrobe', 'wardrobe'))
RMenu.Add("JudHousing", "wardrobesub", RageUI.CreateSubMenu(RMenu:Get("JudHousing", "wardrobe"), "", "~g~LVL Housing Wardrobe", 1350, 50))

RageUI.CreateWhile(1.0, true, function()

    --Enter Menu

    if RageUI.Visible(RMenu:Get("JudHousing", "main")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("Current House: ~g~" .. currentHome, function() end)
            RageUI.Separator("Current House Price: ~g~£" .. currentHousePrice, function() end)
            RageUI.Separator("House Owner ID: ~g~" .. playerName, function() end)
    
            RageUI.Button("Enter Home", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("JudHousing:Enter", currentHome)
                end
            end)

            RageUI.Button("Buy Home", nil, {RightLabel = "~g~£"..currentHousePrice}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("JudHousing:Buy", currentHome)
                end
            end)

            RageUI.Button("Sell Home", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("JudHousing:Sell", currentHome)
                end
            end)

        end)
    end

    --Leave Menu

    if RageUI.Visible(RMenu:Get("JudHousing", "leave")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("~g~Current House: " .. currentHome, function() end)
            RageUI.Separator("~g~Current House Price: £" .. currentHousePrice, function() end)
            RageUI.Button("Leave Home", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("JudHousing:Leave", currentHome)
                end
            end)

        end)
    end

    --Wardrobe Main Menu

    if RageUI.Visible(RMenu:Get("JudHousing", "wardrobe")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

            for k, v in pairs(wardrobe) do
                RageUI.Button(k, nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        currentOutfit = k
                    end
                end, RMenu:Get("JudHousing", "wardrobesub"))
            end

            RageUI.Button("[Save Current Outfit]", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    AddTextEntry("FMMC_MPM_NC", "Enter Outfit Name:")
                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                        Wait(0);
                    end
                    if (GetOnscreenKeyboardResult()) then
                        local result = GetOnscreenKeyboardResult()
                        if result then
                            TriggerServerEvent("JudHousing:SaveOutfit", result)
                        end
                    end
                end
            end)

        end)
    end

    --Wardrobe Sub Menu

    if RageUI.Visible(RMenu:Get("JudHousing", "wardrobesub")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

            RageUI.Button("Equip Outfit", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    for k, v in pairs(wardrobe) do
                        if k == currentOutfit then
                            tLVL.setCustomization(v)
                        end
                    end
                end
            end, RMenu:Get("JudHousing", "wardrobe"))

            RageUI.Button("Remove Outfit", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("JudHousing:RemoveOutfit", currentOutfit)
                end
            end, RMenu:Get("JudHousing", "wardrobe"))

        end)
    end
end)

--Thread

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if not HasStreamedTextureDictLoaded("clothing") then
            RequestStreamedTextureDict("clothing", true)
            while not HasStreamedTextureDictLoaded("clothing") do
                Wait(1)
            end
        end

        for k, v in pairs(cfg.homes) do
            --Enter Home

            if isInArea(v.entry_point, 100) then
                --DrawMarker(20, v.entry_point, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 255, 60, true, false, 2, true)
                DrawMarker(2,  v.entry_point, 0, 0, 0, 0, 0, 0, 0.6, 0.3, 0.3, 0, 209, 17, 150, true, true, 0, 0, 0, 0, 0)
            end

            if isInArea(v.entry_point, 0.8) and isInMenu == false then 
                TriggerServerEvent('GrabHouseInfo', currentHome)
                currentHome = k
                currentHousePrice = v.buy_price
                RMenu:Get("JudHousing", "main"):SetSubtitle("~g~LVL Housing")
                RageUI.Visible(RMenu:Get("JudHousing", "main"), true)
                isInMenu = true
            end

            if isInArea(v.entry_point, 0.8) == false and isInMenu and currentHome == k then
                RageUI.ActuallyCloseAll()
                isInMenu = false
            end

            if currentHome == k then

                --Chest

                if inHome then
        
                    --DrawMarker(2,  v.chest_point, 0, 0, 0, 0, 0, 0, 0.6, 0.3, 0.3, 0, 209, 17, 150, true, true, 0, 0, 0, 0, 0)
                    DrawMarker(2,  v.chest_point, 0, 0, 0, 0, 0, 0, 0.6, 0.3, 0.3, 46, 112, 255, 150, true, true, 0, 0, 0, 0, 0)
                end

                if isInArea(v.chest_point, 0.8) and inHome then
                    alert("Press ~INPUT_VEH_HORN~ To Open House Chest")
                    if IsControlJustPressed(0, 51) then
                        TriggerServerEvent("JudHousing:OpenChest", currentHome)
                    end
                end

                --Wardrobe

                if inHome then
                    DrawMarker(9, v.wardrobe_point, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, 0.6, 0.6, 0.6, 0, 191, 255, 1.0,false, false, 2, true, "clothing", "clothing", false)
                end

                if isInArea(v.wardrobe_point, 0.8) and isInWardrobeMenu == false and inHome then
                    TriggerServerEvent("JudHousing:LoadWardrobe")
                    Wait(200)
                    currentHome = k
                    RageUI.Visible(RMenu:Get("JudHousing", "wardrobe"), true)
                    isInWardrobeMenu = true
                end

                if isInArea(v.wardrobe_point, 0.8) == false and isInWardrobeMenu and currentHome == k and inHome then
                    RageUI.ActuallyCloseAll()
                    isInWardrobeMenu = false
                end

                --Leave Home

                if inHome then
                    DrawMarker(2,  v.leave_point, 0, 0, 0, 0, 0, 0, 0.6, 0.3, 0.3, 0, 209, 17, 150, true, true, 0, 0, 0, 0, 0)
                end

                if isInArea(v.leave_point, 0.8) and isInLeaveMenu == false and inHome then
                    currentHome = k
                    RMenu:Get("JudHousing", "leave"):SetSubtitle("~g~LVL Housing")
                    RageUI.Visible(RMenu:Get("JudHousing", "leave"), true)
                    isInLeaveMenu = true
                end

                if isInArea(v.leave_point, 0.8) == false and isInLeaveMenu and currentHome == k and inHome then
  
                    RageUI.ActuallyCloseAll()
                    isInLeaveMenu = false
                end
            end
        end
    end
end)

RegisterNetEvent('ReceiveHouseInfo')
AddEventHandler('ReceiveHouseInfo', function(name)
    playerName = name
end)

RegisterNetEvent("JudHousing:UpdateInHome")
AddEventHandler("JudHousing:UpdateInHome", function(inTheHome)
    inHome = inTheHome
end)

RegisterNetEvent("JudHousing:UpdateWardrobe")
AddEventHandler("JudHousing:UpdateWardrobe", function(newWardrobe)
    wardrobe = newWardrobe
end)

function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function isInArea(v, dis) 
    if #(GetEntityCoords(PlayerPedId()) - v) <= dis then  
        return true
    else 
        return false
    end
end