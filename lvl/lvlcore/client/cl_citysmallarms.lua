-- [CFG]
citysmall = {}

citysmall.location = vector3(-1500.3103027344,-216.56127929688,47.889362335205)

citysmall.marker = vector3(-1500.1552734375,-216.73043823242,47.889362335205-0.98)

citysmall.name = 'City Small Arms'

citysmall.banner = 'small'

-- [Start of RageUI]

RMenu.Add('CitySmallArms', 'main', RageUI.CreateMenu("", "~g~LVL " .. citysmall.name, 1300, 50, citysmall.banner, citysmall.banner))
RMenu.Add("CitySmallArms", "confirm", RageUI.CreateSubMenu(RMenu:Get('CitySmallArms', 'main',  1300, 50)))
RMenu.Add("CitySmallArms", "confirma", RageUI.CreateSubMenu(RMenu:Get('CitySmallArms', 'main',  1300, 50)))

citysmall.guns = {
    {name = "M1911", price = 60000, hash = "WEAPON_M1911"},
    {name = "FNP", price = 70000, hash = "WEAPON_FNP"},
    {name = "PDW", price = 150000, hash = "WEAPON_PDW"},
}

-- [Actual Menu]

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('CitySmallArms', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        for i , p in pairs(citysmall.guns) do 
            RageUI.Button(p.name , nil, { RightLabel = '~g~£' .. tostring(getMoneyStringFormatted(p.price)) }, true, function(Hovered, Active, Selected)
                if Selected then

                    cPrice = p.price
                    cHash = p.hash
                    cName = p.name

                end
            end, RMenu:Get("CitySmallArms", "confirm"))
        end

        RageUI.Button("Level 1 Armour ~g~[25%]" , nil, {RightLabel = "~g~£25,000"}, true, function(Hovered, Active, Selected)
            if Selected then


            end
        end, RMenu:Get("CitySmallArms", "confirma"))

    end) 
end
end)

-- [Confirm Purchase]
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("CitySmallArms", "confirm")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        RageUI.Separator("Weapon Name: ~g~" .. cName, function() end)
        RageUI.Separator("Weapon Price: ~g~£" .. getMoneyStringFormatted(cPrice), function() end)
        RageUI.Separator("Current Gunstore: ~g~" .. citysmall.name, function() end)

        RageUI.Button("Confirm" , nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
            if Selected then

                TriggerServerEvent('CitySmall:BuyWeapon', cPrice, cHash)

            end
        end, RMenu:Get("CitySmallArms", "main"))

        RageUI.Button("Decline" , nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) end, RMenu:Get("CitySmallArms", "main"))
       

    end) 
end
end)

-- [Armour Confirm Purchase]
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("CitySmallArms", "confirma")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("Armour Plate: ~g~" .. 'Level 1 [25%]', function() end)
            RageUI.Separator("Armour Plate Price: ~g~£" .. '25,000', function() end)
            RageUI.Separator("Current Gunstore: ~g~" .. citysmall.name, function() end)
        RageUI.Button("Confirm" , nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
            if Selected then

                TriggerServerEvent('CitySmall:BuyArmour')

            end
        end, RMenu:Get("CitySmallArms", "main"))

        RageUI.Button("Decline" , nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) end, RMenu:Get("CitySmallArms", "main"))
       

    end) 
end
end)
CitySmallMenu = false
Citizen.CreateThread(function() 
    while true do
   
            local v1 = citysmall.location

            if isInArea(v1, 500.0) then 
                DrawMarker(27, citysmall.marker, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 255, 0, 0, 250, 0, 0, 2, true, 0, 0, false)
            end
        
            if isInArea(v1, 0.8) then 
            
                alert('Press ~INPUT_VEH_HORN~ to access ' .. citysmall.name)
                if IsControlJustPressed(0, 51) then
                    PlaySound(-1,"Hit","RESPAWN_SOUNDSET",0,0,1) 
                    RageUI.Visible(RMenu:Get("CitySmallArms", "main"), true)
                    CitySmallMenu = true

                end
            end

            if isInArea(v1, 0.8) == false and CitySmallMenu then
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("CitySmallArms", "main"), false)
                CitySmallMenu = false
            end
     
        Citizen.Wait(1)
    end
end)


-- [Blip]
Citizen.CreateThread(function()
    blip = AddBlipForCoord(citysmall.location)
    SetBlipSprite(blip, 110)
    SetBlipScale(blip, 0.6)
    SetBlipDisplay(blip, 2)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(citysmall.name)
    EndTextCommandSetBlipName(blip)
end)





