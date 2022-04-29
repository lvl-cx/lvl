local Groups = {}


RMenu.Add('GroupMenu', 'groups',  RageUI.CreateMenu("", "~g~Sentry License Menu", 1300, 50, "groups", "groups"))
RMenu.Add("GroupMenu", "sell", RageUI.CreateSubMenu(RMenu:Get('GroupMenu', 'groups',  1300, 50)))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('GroupMenu', 'groups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()


        for i,v in pairs(Groups) do 
            RageUI.Button(i, nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                if Selected then 
                    SelectedGroup = i;
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
                -- [Illegal Licenses]
                RageUI.Separator("~g~License Name: " .. SelectedGroup, function() end)
                RageUI.Separator("~g~Price of License: " .. '£10,000,000', function() end)
                RageUI.Separator("~g~License Type: " .. 'Illegal License', function() end)

                RageUI.Button('Refund License - ~g~[£' .. '2,500,000' ..']', nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('Sentry:RefundLicense', SelectedGroup)

                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'LSD' then 
                RageUI.Separator("~g~License Name: " .. SelectedGroup, function() end)
                RageUI.Separator("~g~Price of License: " .. '£20,000,000', function() end)
                RageUI.Separator("~g~License Type: " .. 'Illegal License', function() end)

                RageUI.Button('Refund License - ~g~[£' .. '5,000,000' ..']', nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('Sentry:RefundLicense', SelectedGroup)

                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'Cocaine' then 
                RageUI.Separator("~g~License Name: " .. SelectedGroup, function() end)
                RageUI.Separator("~g~Price of License: " .. '£500,000', function() end)
                RageUI.Separator("~g~License Type: " .. 'Illegal License', function() end)

                RageUI.Button('Refund License - ~g~[£' .. '125,000' ..']', nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('Sentry:RefundLicense', SelectedGroup)

                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'Weed' then 
                RageUI.Separator("~g~License Name: " .. SelectedGroup, function() end)
                RageUI.Separator("~g~Price of License: " .. '£200,000', function() end)
                RageUI.Separator("~g~License Type: " .. 'Illegal License', function() end)
                
                RageUI.Button('Refund License - ~g~[£' .. '50,000' ..']', nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('Sentry:RefundLicense', SelectedGroup)

                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'Rebel' then 
                RageUI.Separator("~g~License Name: " .. SelectedGroup, function() end)
                RageUI.Separator("~g~Price of License: " .. '£10,000,000', function() end)
                RageUI.Separator("~g~License Type: " .. 'Illegal License', function() end)

                RageUI.Button('Refund License - ~g~[£' .. '2,500,000' ..']', nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('Sentry:RefundLicense', SelectedGroup)

                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'Gang' then 
                RageUI.Separator("~g~License Name: " .. SelectedGroup, function() end)
                RageUI.Separator("~g~Price of License: " .. '£500,000', function() end)
                RageUI.Separator("~g~License Type: " .. 'Illegal License', function() end)

                RageUI.Button('Refund License - ~g~[£' .. '125,000' ..']', nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('Sentry:RefundLicense', SelectedGroup)

                    end
                end, RMenu:Get('GroupMenu', 'groups'))
                -- [Legal Licenses]
            elseif SelectedGroup == 'Diamond' then 
                RageUI.Separator("~g~License Name: " .. SelectedGroup, function() end)
                RageUI.Separator("~g~Price of License: " .. '£5,000,000', function() end)
                RageUI.Separator("~g~License Type: " .. 'Legal License', function() end)

                RageUI.Button('Refund License - ~g~[£' .. '1,250,000' ..']', nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('Sentry:RefundLicense', SelectedGroup)

                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'Gold' then 
                RageUI.Separator("~g~License Name: " .. SelectedGroup, function() end)
                RageUI.Separator("~g~Price of License: " .. '£1,000,000', function() end)
                RageUI.Separator("~g~License Type: " .. 'Legal License', function() end)

                RageUI.Button('Refund License - ~g~[£' .. '250,000' ..']', nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        if string.upper(Confirm()) == 'YES' then
                            TriggerServerEvent('Sentry:RefundLicense', SelectedGroup)
                        else
                            notify('~g~Failed to type Yes.')
                        end

                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            elseif SelectedGroup == 'Scrap' then 
                RageUI.Separator("~g~License Name: " .. SelectedGroup, function() end)
                RageUI.Separator("~g~Price of License: " .. '£100,000', function() end)
                RageUI.Separator("~g~License Type: " .. 'Legal License', function() end)

                RageUI.Button('Refund License - ~g~[£' .. '25,000' ..']', nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('Sentry:RefundLicense', SelectedGroup)

                    end
                end, RMenu:Get('GroupMenu', 'groups'))
            end

            RageUI.Button('Sell License to Nearest Player', nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) 
                if Selected then 
                   TriggerServerEvent('Sentry:SellLicense', SelectedGroup)
                end
            end)
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

-- [Remove if this causes lag]
Citizen.CreateThread(function()
    while true do 
        TriggerServerEvent('GroupMenu:Groups')
        Citizen.Wait(1000)
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



