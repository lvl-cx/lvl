local Groups = {}


RMenu.Add('GroupMenu', 'groups',  RageUI.CreateMenu("", "~b~License Menu", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "banners", "groups"))
RMenu.Add("GroupMenu", "sell", RageUI.CreateSubMenu(RMenu:Get('GroupMenu', 'groups',  tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight())))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('GroupMenu', 'groups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for i,v in pairs(Groups) do 
                RageUI.Button(v.name, nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        SelectedGroup = v.group
                        SelectedName = v.name
                    end
                end, RMenu:Get("GroupMenu", "sell"))
            end
        end) 
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("GroupMenu", "sell")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if SelectedGroup == 'Heroin' then 
                RageUI.Separator("License Name: " .. SelectedName, function() end)
                RageUI.Separator("Price of License: " .. '£10,000,000', function() end)
                RageUI.Separator("License Type: " .. 'Illegal License', function() end)
                RageUI.Button('Refund License - [£2,500,000]', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        if string.upper(Confirm()) == 'YES' then
                            TriggerServerEvent('ARMA:RefundLicense', SelectedGroup)
                        else
                            tARMA.notify('~r~Invalid Input.')
                        end
                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'LSD' then 
                RageUI.Separator("License Name: " .. SelectedName, function() end)
                RageUI.Separator("Price of License: " .. '£20,000,000', function() end)
                RageUI.Separator("License Type: " .. 'Illegal License', function() end)
                RageUI.Button('Refund License - [£5,000,000]', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        if string.upper(Confirm()) == 'YES' then
                            TriggerServerEvent('ARMA:RefundLicense', SelectedGroup)
                        else
                            tARMA.notify('~r~Invalid Input.')
                        end
                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'Cocaine' then 
                RageUI.Separator("License Name: " .. SelectedName, function() end)
                RageUI.Separator("Price of License: " .. '£500,000', function() end)
                RageUI.Separator("License Type: " .. 'Illegal License', function() end)
                RageUI.Button('Refund License - [£125,000]', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        if string.upper(Confirm()) == 'YES' then
                            TriggerServerEvent('ARMA:RefundLicense', SelectedGroup)
                        else
                            tARMA.notify('~r~Invalid Input.')
                        end
                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'Weed' then 
                RageUI.Separator("License Name: " .. SelectedName, function() end)
                RageUI.Separator("Price of License: " .. '£200,000', function() end)
                RageUI.Separator("License Type: " .. 'Illegal License', function() end)
                RageUI.Button('Refund License - [£50,000]', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        if string.upper(Confirm()) == 'YES' then
                            TriggerServerEvent('ARMA:RefundLicense', SelectedGroup)
                        else
                            tARMA.notify('~r~Invalid Input.')
                        end
                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'Rebel' then 
                RageUI.Separator("License Name: " .. SelectedName, function() end)
                RageUI.Separator("Price of License: " .. '£10,000,000', function() end)
                RageUI.Separator("License Type: " .. 'Illegal License', function() end)
                RageUI.Button('Refund License - [£2,500,000]', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        if string.upper(Confirm()) == 'YES' then
                            TriggerServerEvent('ARMA:RefundLicense', SelectedGroup)
                        else
                            tARMA.notify('~r~Invalid Input.')
                        end
                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'AdvancedRebel' then 
                RageUI.Separator("License Name: " .. SelectedName, function() end)
                RageUI.Separator("Price of License: " .. '£20,000,000', function() end)
                RageUI.Separator("License Type: " .. 'Illegal License', function() end)
                RageUI.Button('Refund License - [£5,000,000]', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        if string.upper(Confirm()) == 'YES' then
                            TriggerServerEvent('ARMA:RefundLicense', SelectedGroup)
                        else
                            tARMA.notify('~r~Invalid Input.')
                        end
                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'Gang' then 
                RageUI.Separator("License Name: " .. SelectedName, function() end)
                RageUI.Separator("Price of License: " .. '£500,000', function() end)
                RageUI.Separator("License Type: " .. 'Illegal License', function() end)
                RageUI.Button('Refund License - [£125,000]', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        if string.upper(Confirm()) == 'YES' then
                            TriggerServerEvent('ARMA:RefundLicense', SelectedGroup)
                        else
                            tARMA.notify('~r~Invalid Input.')
                        end
                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'Diamond' then 
                RageUI.Separator("License Name: " .. SelectedName, function() end)
                RageUI.Separator("Price of License: " .. '£5,000,000', function() end)
                RageUI.Separator("License Type: " .. 'Legal License', function() end)
                RageUI.Button('Refund License - [£1,250,000]', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        if string.upper(Confirm()) == 'YES' then
                            TriggerServerEvent('ARMA:RefundLicense', SelectedGroup)
                        else
                            tARMA.notify('~r~Invalid Input.')
                        end
                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'DJ' then 
                RageUI.Separator("License Name: " .. SelectedName, function() end)
                RageUI.Separator("Price of License: " .. '£50,000,000', function() end)
                RageUI.Separator("License Type: " .. 'Legal License', function() end)
                RageUI.Separator("~r~Abuse of this license will result in it being revoked.", function() end)
            elseif SelectedGroup == 'polblips' then 
                RageUI.Separator("License Name: " .. SelectedName, function() end)
                RageUI.Separator("Price of License: " .. '£5,000,000', function() end)
                RageUI.Separator("License Type: " .. 'Legal License', function() end)
            elseif SelectedGroup == 'PilotLicense' then 
                RageUI.Separator("License Name: " .. SelectedName, function() end)
                RageUI.Separator("Price of License: " .. '£1,500,000', function() end)
                RageUI.Separator("License Type: " .. 'Legal License', function() end)
            elseif SelectedGroup == 'Gold' then 
                RageUI.Separator("License Name: " .. SelectedName, function() end)
                RageUI.Separator("Price of License: " .. '£1,000,000', function() end)
                RageUI.Separator("License Type: " .. 'Legal License', function() end)
                RageUI.Button('Refund License - [£250,000]', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        if string.upper(Confirm()) == 'YES' then
                            TriggerServerEvent('ARMA:RefundLicense', SelectedGroup)
                        else
                            tARMA.notify('~r~Invalid Input.')
                        end
                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'Scrap' then 
                RageUI.Separator("License Name: " .. SelectedName, function() end)
                RageUI.Separator("Price of License: " .. '£100,000', function() end)
                RageUI.Separator("License Type: " .. 'Legal License', function() end)
                RageUI.Button('Refund License - [£' .. '25,000' ..']', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        if string.upper(Confirm()) == 'YES' then
                            TriggerServerEvent('ARMA:RefundLicense', SelectedGroup)
                        else
                            tARMA.notify('~r~Invalid Input.')
                        end
                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            end
            if SelectedGroup ~= 'polblips' and SelectedGroup ~= 'DJ' then
                RageUI.Button('Sell License to Nearest Player', nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                    TriggerServerEvent('ARMA:SellLicense', SelectedGroup)
                    end
                end)
            end
        end) 
    end
end)

Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, 167) then 
            RageUI.Visible(RMenu:Get("GroupMenu", "groups"), true)
            TriggerServerEvent('GroupMenu:Groups')
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent('GroupMenu:ReturnGroups')
AddEventHandler('GroupMenu:ReturnGroups', function(groups)
    Groups = groups
end)

function Confirm()
	AddTextEntry('FMMC_KEY_TIP8', "Type Yes to Confirm.")
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



