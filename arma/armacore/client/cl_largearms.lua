-- [CFG]
largearms = {}

largearms.location = vector3(-1111.3123779297,4937.2846679688,218.3872833252)

largearms.marker = vector3(-1111.3123779297,4937.2846679688,218.3872833252-0.98)

largearms.name = 'Large Arms'

largearms.banner = 'large'

-- [Start of RageUI]

RMenu.Add('LargeArms', 'main', RageUI.CreateMenu("", "~b~" .. largearms.name, 1300, 50, largearms.banner, largearms.banner))
RMenu.Add("LargeArms", "confirm", RageUI.CreateSubMenu(RMenu:Get('LargeArms', 'main',  1300, 50)))
RMenu.Add("LargeArms", "confirma", RageUI.CreateSubMenu(RMenu:Get('LargeArms', 'main',  1300, 50)))

largearms.guns = {
    {name = "LR-300", price = 750000, hash = "WEAPON_LR300"},
    {name = "PPSH", price = 500000, hash = "WEAPON_PPSH"},
    {name = "UMP45", price = 400000, hash = "WEAPON_UMP45"},
    {name = "Itacha 37", price = 350000, hash = "WEAPON_ITACHA"},
}

-- [Actual Menu]

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('LargeArms', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        for i , p in pairs(largearms.guns) do 
            RageUI.Button(p.name , nil, { RightLabel = '~g~£' .. tostring(getMoneyStringFormatted(p.price)) }, true, function(Hovered, Active, Selected)
                if Selected then

                    cPrice = p.price
                    cHash = p.hash
                    cName = p.name

                end
            end, RMenu:Get("LargeArms", "confirm"))
        end

        RageUI.Button("Level 2 Armour ~b~[50%]" , nil, {RightLabel = "~g~£50,000"}, true, function(Hovered, Active, Selected)
            if Selected then


            end
        end, RMenu:Get("LargeArms", "confirma"))
    end) 
end
end)

-- [Confirm Purchase]
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("LargeArms", "confirm")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("Weapon Name: " .. cName, function() end)
            RageUI.Separator("Weapon Price: £" .. getMoneyStringFormatted(cPrice), function() end)
            RageUI.Separator("Current Gunstore: " .. largearms.name, function() end)
        
        RageUI.Button("~g~Confirm" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then

                TriggerServerEvent('LargeArms:BuyWeapon', cPrice, cHash)

            end
        end, RMenu:Get("LargeArms", "main"))

        RageUI.Button("~r~Decline" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) end, RMenu:Get("LargeArms", "main"))
       

    end) 
end
end)

-- [Armour Confirm Purchase]
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("LargeArms", "confirma")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("Armour Plate: " .. 'Level 2 ~b~[50%]', function() end)
            RageUI.Separator("Armour Plate Price: £" .. '50,000', function() end)
            RageUI.Separator("Current Gunstore: " .. largearms.name, function() end)
        
        RageUI.Button("~g~Confirm" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then

                TriggerServerEvent('LargeArms:BuyArmour')

            end
        end, RMenu:Get("LargeArms", "main"))

        RageUI.Button("~r~Decline" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected) end, RMenu:Get("LargeArms", "main"))
       

    end) 
end
end)

LargeArmsMenu = false
Citizen.CreateThread(function() 
    while true do
   
            local v1 = largearms.location

            if isInArea(v1, 500.0) then 
                DrawMarker(27, largearms.marker, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 255, 0, 0, 250, 0, 0, 2, true, 0, 0, false)
            end
        
            if isInArea(v1, 0.8) then 
            
                alert('Press ~INPUT_VEH_HORN~ to access ' .. largearms.name)
                if IsControlJustPressed(0, 51) then
                    PlaySound(-1,"Hit","RESPAWN_SOUNDSET",0,0,1) 
                    RageUI.Visible(RMenu:Get("LargeArms", "main"), true)
                    LargeArmsMenu = true

                end
            end

            if isInArea(v1, 0.8) == false and LargeArmsMenu then
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("LargeArms", "main"), false)
                LargeArmsMenu = false
            end
     
        Citizen.Wait(1)
    end
end)


-- [Blip]
Citizen.CreateThread(function()
    blip = AddBlipForCoord(largearms.location)
    SetBlipSprite(blip, 150)
    SetBlipScale(blip, 0.7)
    SetBlipDisplay(blip, 2)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(largearms.name)
    EndTextCommandSetBlipName(blip)
end)





