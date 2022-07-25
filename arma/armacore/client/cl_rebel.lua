-- [CFG]
rebel = {}

rebel.location = vector3(1545.2042236328,6332.3295898438,24.078683853149)

rebel.marker = vector3(1545.2042236328,6332.3295898438,24.078683853149-0.98)

-- [Start of RageUI]

RMenu.Add('Rebel', 'main', RageUI.CreateMenu("", "~b~" .. "Rebel", 1300, 50, "banners", "rebel"))
RMenu.Add("Rebel", "confirma", RageUI.CreateSubMenu(RMenu:Get('Rebel', 'main',  1300, 50)))
RMenu.Add("Rebel", "confirm", RageUI.CreateSubMenu(RMenu:Get('Rebel', 'main',  1300, 50)))

rebel.guns = {
    {name = "Vandal Gold", price = 825000, hash = "WEAPON_VANDALG"},
    {name = "AR-15 Hotshot Welde", price = 750000, hash = "WEAPON_ar15"},
    {name = "Colt M16A1", price = 700000, hash = "WEAPON_M16A1"},
    {name = "Deagle", price = 500000, hash = "WEAPON_DEAGLE"},
}

-- [Actual Menu]

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('Rebel', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for i , p in pairs(rebel.guns) do 
                RageUI.Button(p.name , nil, { RightLabel = '~g~£' .. tostring(getMoneyStringFormatted(p.price)) }, true, function(Hovered, Active, Selected)
                    if Selected then

                        cPrice = p.price
                        cHash = p.hash
                        cName = p.name

                    end
                end, RMenu:Get("Rebel", "confirm"))
            end

            RageUI.Button("Level 4 Armour Plate ~b~[100%]" , nil, {RightLabel = "~g~£100,000"}, true, function(Hovered, Active, Selected)
                if Selected then


                end
            end, RMenu:Get("Rebel", "confirma"))
    end) 
end
end)


-- [Armour Confirm]
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("Rebel", "confirma")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("Armour Plate: " .. 'Level 4 ~b~[100%]', function() end)
            RageUI.Separator("Armour Plate Price: £" .. '100,000', function() end)
            RageUI.Separator("Current Gunstore: " .. rebel.name, function() end)
        
        RageUI.Button("~g~Confirm" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then

                TriggerServerEvent('Rebel:BuyArmour')

            end
        end, RMenu:Get("Rebel", "main"))

        RageUI.Button("~r~Decline" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) end, RMenu:Get("Rebel", "main"))
       

    end) 
end
end)

-- [Confirm Purchase]
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("Rebel", "confirm")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("Weapon Name: " .. cName, function() end)
            RageUI.Separator("Weapon Price: £" .. getMoneyStringFormatted(cPrice), function() end)
            RageUI.Separator("Current Gunstore: " .. rebel.name, function() end)
        
        RageUI.Button("~g~Confirm" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then

                TriggerServerEvent('Rebel:BuyWeapon', cPrice, cHash)

            end
        end, RMenu:Get("Rebel", "main"))

        RageUI.Button("~r~Decline" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) end, RMenu:Get("Rebel", "main"))
       

    end) 
end
end)

RebelMenu = false
Citizen.CreateThread(function() 
    while true do
   
            local v1 = rebel.location

            if isInArea(v1, 500.0) then 
                DrawMarker(27, rebel.marker, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 255, 0, 0, 250, 0, 0, 2, true, 0, 0, false)
            end
        
            if isInArea(v1, 0.8) then 
            
                alert('Press ~INPUT_VEH_HORN~ to access ' .. rebel.name)
                if IsControlJustPressed(0, 51) then
                    PlaySound(-1,"Hit","RESPAWN_SOUNDSET",0,0,1) 
                    RageUI.Visible(RMenu:Get("Rebel", "main"), true)
                    RebelMenu = true

                end
            end

            if isInArea(v1, 0.8) == false and RebelMenu then
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("Rebel", "main"), false)
                RebelMenu = false
            end
     
        Citizen.Wait(1)
    end
end)


-- [Blip]
Citizen.CreateThread(function()
    blip = AddBlipForCoord(rebel.location)
    SetBlipSprite(blip, 310)
    SetBlipScale(blip, 0.7)
    SetBlipDisplay(blip, 2)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(rebel.name)
    EndTextCommandSetBlipName(blip)
end)





