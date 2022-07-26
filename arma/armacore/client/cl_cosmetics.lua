data = {}

-- [Cosmetic Types]
-- - Watch
-- - Chain
-- - Vest

RMenu.Add("CosmeticMenu", "main",  RageUI.CreateMenu("", "~b~Cosmetic Menu", 1300, 50, "banners", "cosmetics"))
RMenu.Add("CosmeticMenu", "cosmetics", RageUI.CreateSubMenu(RMenu:Get("CosmeticMenu", "main",  1300, 50)))
RMenu.Add("CosmeticMenu", "buycosmetics", RageUI.CreateSubMenu(RMenu:Get("CosmeticMenu", "main",  1300, 50)))
RMenu.Add("CosmeticMenu", "limited", RageUI.CreateSubMenu(RMenu:Get("CosmeticMenu", "buycosmetics",  1300, 50)))
RMenu.Add("CosmeticMenu", "standard", RageUI.CreateSubMenu(RMenu:Get("CosmeticMenu", "buycosmetics",  1300, 50)))
RMenu.Add("CosmeticMenu", "buycosmeticsub", RageUI.CreateSubMenu(RMenu:Get("CosmeticMenu", "standard",  1300, 50))) 
RMenu.Add("CosmeticMenu", "buycosmeticsublimit", RageUI.CreateSubMenu(RMenu:Get("CosmeticMenu", "limited",  1300, 50)))
RMenu.Add("CosmeticMenu", "submenu", RageUI.CreateSubMenu(RMenu:Get("CosmeticMenu", "cosmetics",  1300, 50))) 
RMenu.Add("CosmeticMenu", "refundconfirm", RageUI.CreateSubMenu(RMenu:Get("CosmeticMenu", "submenu",  1300, 50))) 
RMenu.Add("CosmeticMenu", "marketplace", RageUI.CreateSubMenu(RMenu:Get("CosmeticMenu", "submenu",  1300, 50))) 



RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("CosmeticMenu", "main")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.ButtonWithStyle('Buy Cosmetics', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
            end, RMenu:Get("CosmeticMenu", "buycosmetics"))

            RageUI.ButtonWithStyle('Your Cosmetics', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                if Selected then 
                    TriggerServerEvent('ARMA:GetCosmetic')
                end
            end, RMenu:Get("CosmeticMenu", "cosmetics"))

    end) 
end
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("CosmeticMenu", "buycosmetics")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("Cosmetic Shop", function() end)
            RageUI.ButtonWithStyle('Standard Items', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
            end, RMenu:Get("CosmeticMenu", "standard"))

            RageUI.ButtonWithStyle('Limited Time Items', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
            end, RMenu:Get("CosmeticMenu", "limited"))

    end) 
end
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("CosmeticMenu", "limited")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("Cosmetic shop will reset: " .. 'Tommorow', function() end)
            for i,v in pairs(cosmetics.limitedshop) do 

                RageUI.ButtonWithStyle(v.item, nil, {RightLabel = "£" .. getMoneyStringFormatted(v.price)}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        CosmeticPrice = v.price
                        CosmeticItem = v.item 
                    end
                end, RMenu:Get("CosmeticMenu", "buycosmeticsublimit"))
            end

    end) 
end
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("CosmeticMenu", "standard")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("These items will always be in the cosmetic shop", function() end)
            for i,v in pairs(cosmetics.shop) do 

                RageUI.ButtonWithStyle(v.item , nil, {RightLabel = "£" .. getMoneyStringFormatted(v.price)}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        CosmeticPrice = v.price
                        CosmeticItem = v.item 
                    end
                end, RMenu:Get("CosmeticMenu", "buycosmeticsub"))
            end

    end) 
end
end)



RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("CosmeticMenu", "buycosmeticsub")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for i,v in pairs(cosmetics.shop) do 
                if CosmeticItem == v.item then
                    RageUI.Separator("Cosmetic Name: " .. v.item, function() end)
                    RageUI.Separator("Cosmetic Price: £" .. getMoneyStringFormatted(v.price), function() end)
                    RageUI.Separator("Are you sure you want to purchase this cosmetic?", function() end)

                    RageUI.ButtonWithStyle('Confirm', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                        if Selected then 
                            TriggerServerEvent('ARMA:BuyCosmetic', v.item)
                        end
                    end, RMenu:Get("CosmeticMenu", "standard"))

                    RageUI.ButtonWithStyle('Decline', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                        if Selected then 
                        
                        end
                    end, RMenu:Get("CosmeticMenu", "standard"))
                end
             
            end

    end) 
end
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("CosmeticMenu", "buycosmeticsublimit")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for i,v in pairs(cosmetics.limitedshop) do 
                if CosmeticItem == v.item then
                    RageUI.Separator("Cosmetic Name: " .. v.item, function() end)
                    RageUI.Separator("Cosmetic Price: £" .. v.price, function() end)
                    RageUI.Separator("Are you sure you want to purchase this cosmetic?", function() end)

                    RageUI.ButtonWithStyle('Confirm', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                        if Selected then 
                            TriggerServerEvent('ARMA:BuyCosmetic', v.item)
                        end
                    end, RMenu:Get("CosmeticMenu", "limited"))

                    RageUI.ButtonWithStyle('Decline', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                        if Selected then 
                        
                        end
                    end, RMenu:Get("CosmeticMenu", "limited"))
                end
             
            end

    end) 
end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("CosmeticMenu", "cosmetics")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for i,v in pairs(data) do 
                RageUI.ButtonWithStyle(i, nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        SelectedCosmetic = i;
                    end
                end, RMenu:Get("CosmeticMenu", "submenu"))
            end         
        end) 
    end
end)

local WatchEquip = false
local ChainEquip = false
local VestEquip = false


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("CosmeticMenu", "submenu")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for i,v in pairs(cosmetics.cfg) do
                if SelectedCosmetic == v.item then 
                    RageUI.Separator("Cosmetic Name: " .. v.item, function() end)
                    RageUI.Separator("Cosmetic Price: £" .. tostring(getMoneyStringFormatted(v.price)), function() end)
                    RageUI.Separator("Cosmetic Type: " .. v.type, function() end)
                    RageUI.Separator("Cosmetic Refund Price: £" .. tostring(getMoneyStringFormatted(v.price * 0.25)), function() end)
                    if v.type == 'Watch' then
                        if GetPedPropIndex(PlayerPedId(), 6) == v.clothingid then WatchEquip = true else WatchEquip = false end
                        RageUI.Checkbox('Equip ' .. v.item, nil, WatchEquip, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Selected, Checked)
                            if Selected then 
                                if not WatchEquip then
                                    SetPedPropIndex(PlayerPedId(), 6, v.clothingid, v.index, 0) 
                                    WatchEquip = true                              
                                else 
                                    ClearPedProp(PlayerPedId(), 6)
                                    WatchEquip = false
                                end        
                            end
                        end)
                    elseif v.type == 'Chain' then 
                        if GetPedDrawableVariation(PlayerPedId(), 7) == v.clothingid then ChainEquip = true else ChainEquip = false end
                        RageUI.Checkbox('Equip ' .. v.item, nil, ChainEquip, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Selected, Checked)
                            if Selected then 
                                if not ChainEquip then
                                    SetPedComponentVariation(PlayerPedId(), 7, v.clothingid, v.index, 0)
                                    ChainEquip = true                              
                                else 
                                    SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 0) 
                                    ChainEquip = false
                                end        
                            end
                        end)
                    elseif v.type == 'Vest' then 
                        if GetPedDrawableVariation(PlayerPedId(), 9) == v.clothingid then VestEquip = true else VestEquip = false end
                        RageUI.Checkbox('Equip ' .. v.item, nil, VestEquip, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Selected, Checked)
                            if Selected then 
                                if not VestEquip then
                                    if GetPedArmour(PlayerPedId()) ~= 0 then 
                                        SetPedComponentVariation(PlayerPedId(), 9, v.clothingid, v.index, 0)
                                        TriggerEvent('ARMA:ChangeArmour', v.clothingid, v.index)
                                        TriggerEvent('ARMA:ChangeArmour2', v.clothingid, v.index)
                                        VestEquip = true
                                    else
                                        tARMA.notify('~r~You need Armour to Equip a vest!')
                                    end                         
                                else 
                                    if GetPedArmour(PlayerPedId()) == 0 then 
                                        SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 0) 
                                        VestEquip = false
                                    else
                                        tARMA.notify('~r~You cant Un-equip a vest when you have armour!')
                                    end
                                end        
                            end
                        end)
                    end
                    RageUI.ButtonWithStyle('Sell Cosmetic to player', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                        if Selected then
                            TriggerServerEvent('ARMA:SellCosmeticToPlayer', v.item)
                        end
                    end)
                    RageUI.ButtonWithStyle('Refund Cosmetic [25% Back]', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    end, RMenu:Get("CosmeticMenu", "refundconfirm"))
                    RageUI.ButtonWithStyle('List on ARMA Market Place', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    end, RMenu:Get("CosmeticMenu", "marketplace"))
                    RageUI.Separator("discord.gg/armarp - #market-place", function() end)
                end
            end
        end)            
    end
end)

local listingprice = '0'
local listingmessage = '[No Message]'
local cooldown = 0
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("CosmeticMenu", "marketplace")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for i,v in pairs(cosmetics.cfg) do 
                if SelectedCosmetic == v.item then
                    RageUI.Separator("Cosmetic Name: " .. v.item, function() end)
                    RageUI.Separator("Cosmetic Type: " .. v.type, function() end)
                    RageUI.Separator("Cosmetic Price: £" .. tostring(getMoneyStringFormatted(v.price)), function() end)
                    RageUI.ButtonWithStyle('Enter Listing Price - £' .. listingprice, nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                        if Selected then 
                            listingpriceresult = KeyboardInput("Enter Listing Price:", "", 10)
                            if listingpriceresult == tostring(tonumber(listingpriceresult)) then
                                if listingpriceresult == nil then 
                                    listingpriceresult = "0"
                                end
                                listingprice = listingpriceresult
                            else
                                tARMA.notify('~r~Please enter a valid value.')
                            end
                        end
                    end, RMenu:Get("CosmeticMenu", "cosmetics"))
                    RageUI.ButtonWithStyle('Enter Custom Message - ' .. listingmessage, nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                        if Selected then 
                            listingmessageresult = KeyboardInput("Enter Listing Price [Max 50 Words]:", "", 50)
                            if listingmessageresult == nil then 
                                listingmessageresult = "[No Message]"
                            end
                            listingmessage = listingmessageresult
                        end
                    end, RMenu:Get("CosmeticMenu", "cosmetics"))
                    RageUI.ButtonWithStyle('Confirm', 'Listing Price: £' .. listingprice .. '\nListing Message: ' .. listingmessage .. '\nItem Name: ' .. v.item, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                        if Selected then 
                            if cooldown <= 0 then 
                                TriggerServerEvent('ARMA:CosmeticMarketPlace', v.item, tonumber(listingprice), listingmessage)
                                TriggerServerEvent('ARMA:GetCosmetic')
                                cooldown = 300
                            else
                                tARMA.notify('~r~Listing cooldown ' .. tostring(cooldown) ..'s')
                            end
                        end
                    end, RMenu:Get("CosmeticMenu", "cosmetics"))
                end
            end       
        end) 
    end
end)

Citizen.CreateThread(function()
    while true do 
        if cooldown ~= 0 then 
            cooldown = cooldown - 1
        end
        Citizen.Wait(1000)
    end
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("CosmeticMenu", "refundconfirm")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for i,v in pairs(cosmetics.cfg) do 
                if SelectedCosmetic == v.item then
                    RageUI.Separator("Cosmetic Name: " .. v.item, function() end)
                    RageUI.Separator("Cosmetic Type: " .. v.type, function() end)
                    RageUI.Separator("Cosmetic Refund Price: £" .. tostring(getMoneyStringFormatted(v.price * 0.25)), function() end)
                    RageUI.Separator("Are you sure you want to refund this ?", function() end)
                    RageUI.ButtonWithStyle('Confirm', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                        if Selected then 
                            TriggerServerEvent('ARMA:RefundCosmetic', v.item)
                            TriggerServerEvent('ARMA:GetCosmetic')
                        end
                    end, RMenu:Get("CosmeticMenu", "cosmetics"))
                    RageUI.ButtonWithStyle('Decline', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                        if Selected then 
                        
                        end
                    end, RMenu:Get("CosmeticMenu", "cosmetics"))
                end
            end       
        end) 
    end
end)

RegisterCommand("cosmetics", function()
    RageUI.Visible(RMenu:Get("CosmeticMenu", "main"), true)
        TriggerServerEvent('ARMA:GetCosmetic')
end)
RegisterKeyMapping("cosmetics", "Opens Cosmetics Menu", "keyboard", "F7")

RegisterNetEvent('ARMA:ResetCosmetics')
AddEventHandler('ARMA:ResetCosmetics', function(type2)
    if type2 == 'Vest' then 
        SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 0) 
    elseif type2 == 'Chain' then 
        SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 0) 
    elseif type2 == 'Watch' then
        ClearPedProp(PlayerPedId(), 6)
    end
end)

RegisterNetEvent('ARMA:ReturnCosmetic')
AddEventHandler('ARMA:ReturnCosmetic', function(rdata)
    data = rdata
end)

function ConfirmRefund()
	AddTextEntry('FMMC_KEY_TIP8', "Type [Yes] to Confirm Refund.")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "Enter Amount (Blank to Cancel)", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
		if result then
			return result
		end
    end
	return false
end



