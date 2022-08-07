-- [CFG]
licensecentre = {}
licensecentre.location = vector3(-926.37622070312,-2037.8065185547,9.4023275375366)
licensecentre.marker = vector3(-926.37622070312,-2037.8065185547,9.4023275375366-0.98)

licensecentre.dlicenses = {
    {name = "Weed License", group = "Weed", price = 200000},
    {name = "Gang License", group = "Gang", price = 500000},
    {name = "Cocaine License", group = "Cocaine", price = 500000},
    {name = "Heroin License", group = "Heroin", price = 10000000},
    {name = "LSD License", group = "LSD", price = 50000000},
    {name = "Rebel License", group = "Rebel", price = 30000000},
    {name = "Advanced Rebel License", group = "AdvancedRebel",price = 15000000},
}

licensecentre.licenses = {
    {name = "Scrap Job License", group = "Scrap", price = 100000},
    {name = "Gold License", group = "Gold", price = 1000000},
    {name = "Diamond License", group = "Diamond", price = 5000000},
    --{name = "Highrollers License", group = "highroller", price = 10000000},

}

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
            if cGroup == 'Diamond' then 
                RageUI.Separator("Diamond License Price: £5,000,000", function() end)
                RageUI.Separator("Per Piece: £10,000", function() end)
                RageUI.Separator("1 x 200KG Run: £500,000", function() end)
                RageUI.Separator("1 x 300KG Run: £750,000", function() end)
            elseif cGroup == 'Gold' then 
                RageUI.Separator("Gold License Price: £1,000,000", function() end)
                RageUI.Separator("Per Piece: £2,500", function() end)
                RageUI.Separator("1 x 200KG Run: £125,000", function() end)
                RageUI.Separator("1 x 300KG Run: £187,500", function() end)
            elseif cGroup == 'Scrap' then 
                RageUI.Separator("Scrap License Price: £100,000", function() end)
                RageUI.Separator("Per Piece: £250", function() end)
                RageUI.Separator("1 x 200KG Run: £12,500", function() end)
                RageUI.Separator("1 x 300KG Run: £18,750", function() end)
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
            if cGroup == 'LSD' then 
                RageUI.Separator("LSD License Price: £50,000,000", function() end)
                RageUI.Separator("Per Piece: £40,000", function() end)
                RageUI.Separator("1 x 200KG Run: £2,000,000", function() end)
                RageUI.Separator("1 x 300KG Run: £3,000,000", function() end)
            elseif cGroup == 'Heroin' then 
                RageUI.Separator("Heroin License Price: £10,000,000", function() end)
                RageUI.Separator("Per Piece: £20,000", function() end)
                RageUI.Separator("1 x 200KG Run: £1,000,000", function() end)
                RageUI.Separator("1 x 300KG Run: £1,500,000", function() end)
            elseif cGroup == 'Weed' then 
                RageUI.Separator("Weed License Price: £200,000", function() end)
                RageUI.Separator("Per Piece: £500", function() end)
                RageUI.Separator("1 x 200KG Run: £25,000", function() end)
                RageUI.Separator("1 x 300KG Run: £37,500", function() end)
            elseif cGroup == 'Cocaine' then 
                RageUI.Separator("Cocaine License Price: £500,000", function() end)
                RageUI.Separator("Per Piece: £1,250", function() end)
                RageUI.Separator("1 x 200KG Run: £62,500", function() end)
                RageUI.Separator("1 x 300KG Run: £93,750", function() end)
            elseif cGroup == 'Gang' then 
                RageUI.Separator("Gang License Price: £500,000", function() end)
                RageUI.Separator("Access to Large Arms", function() end)
                RageUI.Separator("Access to create gang using F5", function() end)
                RageUI.Separator("Access to take turfs & change commision", function() end)
            elseif cGroup == 'Rebel' then 
                RageUI.Separator("Rebel License Price: £30,000,000", function() end)
                RageUI.Separator("Access to Rebel Gunstore", function() end)
            elseif cGroup == 'AdvancedRebel' then 
                RageUI.Separator("Advanced Rebel License Price: £15,000,000", function() end)
                RageUI.Separator("Access to Advanced Rebel Gunstore", function() end)
        
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
                DrawMarker(27, licensecentre.marker, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 255, 255, 255, 250, 0, 0, 2, true, 0, 0, false)
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

Citizen.CreateThread(function()
    blip = AddBlipForCoord(licensecentre.location)
    SetBlipSprite(blip, 457)
    SetBlipScale(blip, 0.6)
    SetBlipDisplay(blip, 2)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Job Centre')
    EndTextCommandSetBlipName(blip)
  end)

