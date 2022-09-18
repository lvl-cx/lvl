-- [CFG]
licensecentre = module("armacore/cfg/cfg_licensecentre")


RMenu.Add('LicenseCentre', 'main', RageUI.CreateMenu("", "~b~" .. "Job Centre", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "banners", "groups"))
RMenu.Add("LicenseCentre", "dlicenses", RageUI.CreateSubMenu(RMenu:Get('LicenseCentre', 'main',  tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight())))
RMenu.Add("LicenseCentre", "licenses", RageUI.CreateSubMenu(RMenu:Get('LicenseCentre', 'main',  tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight())))
RMenu.Add("LicenseCentre", "confirm", RageUI.CreateSubMenu(RMenu:Get('LicenseCentre', 'licenses',  tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight())))
RMenu.Add("LicenseCentre", "dconfirm", RageUI.CreateSubMenu(RMenu:Get('LicenseCentre', 'dlicenses',  tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight())))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('LicenseCentre', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        RageUI.Button("Illegal Licenses" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) end, RMenu:Get("LicenseCentre", "dlicenses"))
        RageUI.Button("Legal Licenses" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) end, RMenu:Get("LicenseCentre", "licenses"))
    end) 
end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("LicenseCentre", "dlicenses")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        for i , p in pairs(licensecentre.dlicenses) do 
            RageUI.Button(p.name , nil, { RightLabel = '£' .. tostring(getMoneyStringFormatted(p.price)) }, true, function(Hovered, Active, Selected)
                if Selected then
                    cGroup = p.group
                    cName = p.name
                end
            end, RMenu:Get("LicenseCentre", "dconfirm"))
        end
    end) 
end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("LicenseCentre", "licenses")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        for i , p in pairs(licensecentre.licenses) do 
            RageUI.Button(p.name , nil, { RightLabel = '£' .. tostring(getMoneyStringFormatted(p.price)) }, true, function(Hovered, Active, Selected)
                if Selected then
                    cGroup = p.group
                    cName = p.name
                end
            end, RMenu:Get("LicenseCentre", "confirm"))
        end
    end) 
end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("LicenseCentre", "confirm")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RMenu:Get("LicenseCentre", "confirm"):SetSubtitle("Are you sure?")
            for k,v in pairs(licensecentre.licenses) do
                if v.group == cGroup then
                    RageUI.Separator(v.name.." Price: £"..getMoneyStringFormatted(v.price))
                    if v.type == 'grind' then
                        RageUI.Separator("Per Piece: £"..getMoneyStringFormatted(v.pieceprice))
                        RageUI.Separator("1 x 200KG Run: £"..getMoneyStringFormatted(v.pieceprice*50))
                        RageUI.Separator("1 x 300KG Run: £"..getMoneyStringFormatted(v.pieceprice*75))
                    else
                        for a,b in pairs(v.info) do
                            RageUI.Separator(b)
                        end
                    end
                end
            end
            RageUI.Button("Confirm" , nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('LicenseCentre:BuyGroup', cGroup, cName)
                end
            end, RMenu:Get("LicenseCentre", "main"))
            RageUI.Button("Decline" , nil, {RightLabel = ""}, true, function(Hovered, Active, Selected) end, RMenu:Get("LicenseCentre", "main"))
        end) 
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("LicenseCentre", "dconfirm")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RMenu:Get("LicenseCentre", "confirm"):SetSubtitle("Are you sure?")
            for k,v in pairs(licensecentre.dlicenses) do
                if v.group == cGroup then
                    RageUI.Separator(v.name.." Price: £"..getMoneyStringFormatted(v.price))
                    if v.type == 'grind' then
                        RageUI.Separator("Per Piece: £"..getMoneyStringFormatted(v.pieceprice))
                        RageUI.Separator("1 x 200KG Run: £"..getMoneyStringFormatted(v.pieceprice*50))
                        RageUI.Separator("1 x 300KG Run: £"..getMoneyStringFormatted(v.pieceprice*75))
                    else
                        for a,b in pairs(v.info) do
                            RageUI.Separator(b)
                        end
                    end
                end
            end
            RageUI.Button("Confirm" , nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('LicenseCentre:BuyGroup', cGroup, cName)
                end
            end, RMenu:Get("LicenseCentre", "main"))
            RageUI.Button("Decline" , nil, {RightLabel = ""}, true, function(Hovered, Active, Selected) end, RMenu:Get("LicenseCentre", "main"))
        end) 
    end
end)

LicenseCentreMenu = false
Citizen.CreateThread(function() 
    while true do
            local v1 = licensecentre.location
            if isInArea(v1, 500.0) then 
                DrawMarker(27, v1.x,v1.y,v1.z-0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 255, 255, 255, 250, 0, 0, 2, true, 0, 0, false)
            end
            if isInArea(v1, 0.8) then 
                alert('Press ~INPUT_VEH_HORN~ to access Job Centre')
                if IsControlJustPressed(0, 51) then
                    PlaySound(-1,"Hit","RESPAWN_SOUNDSET",0,0,1) 
                    RageUI.Visible(RMenu:Get("LicenseCentre", "main"), true)
                    LicenseCentreMenu = true
                end
            end
            if isInArea(v1, 0.8) == false and LicenseCentreMenu then
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("LicenseCentre", "main"), false)
                LicenseCentreMenu = false
            end
        Citizen.Wait(1)
    end
end)

AddEventHandler("ARMA:onClientSpawn",function(D, E)
    if E then
		local H = function(I)
        end
        local J = function(I)
        end
        local K = function(I)
        end
        local L = function(I)
        end
        tARMA.addBlip(licensecentre.location.x, licensecentre.location.y, licensecentre.location.z, 457, 2, "Job Centre", 0.6, true)
	end
end)