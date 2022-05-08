-- [CFG]
knifestore = {}

knifestore.location = vector3(21.854759216309,-1107.3658447266,29.797010421753)

knifestore.marker = vector3(21.854759216309,-1107.3658447266,29.797010421753-0.98)

knifestore.name = 'Knife Store'

knifestore.banner = 'knife'

-- [Start of RageUI]

RMenu.Add('KnifeStoreMenu', 'main', RageUI.CreateMenu("", "~w~LVL " .. knifestore.name, 1300, 50, knifestore.banner, knifestore.banner))
RMenu.Add("KnifeStoreMenu", "confirm", RageUI.CreateSubMenu(RMenu:Get('KnifeStoreMenu', 'main',  1300, 50)))

knifestore.guns = {
    {name = "Baseball Bat", price = 1000, hash = "WEAPON_baseballbat"},
    {name = "Fireaxe", price = 1500, hash = "WEAPON_fireaxe"},
    {name = "Cleaver", price = 800, hash = "WEAPON_kitchenknife"},
    {name = "Rambo", price = 600, hash = "WEAPON_rambo"},
    {name = "shovel", price = 1200, hash = "WEAPON_shovel"},
}

-- [Actual Menu]

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('KnifeStoreMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        for i , p in pairs(knifestore.guns) do 
            RageUI.Button(p.name , nil, { RightLabel = '~w~£' .. tostring(getMoneyStringFormatted(p.price)) }, true, function(Hovered, Active, Selected)
                if Selected then

                    cPrice = p.price
                    cHash = p.hash
                    cName = p.name

                end
            end, RMenu:Get("KnifeStoreMenu", "confirm"))
        end
    end) 
end
end)
-- [Confirm Purchase]
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("KnifeStoreMenu", "confirm")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        RageUI.Separator("Weapon Name: ~w~" .. cName, function() end)
        RageUI.Separator("Weapon Price: ~w~£" .. getMoneyStringFormatted(cPrice), function() end)
        RageUI.Separator("Current Gunstore: ~w~" .. knifestore.name, function() end)
        RageUI.Button("Confirm" , nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then

                TriggerServerEvent('KnifeStore:BuyWeapon', cPrice, cHash)

            end
        end, RMenu:Get("KnifeStoreMenu", "main"))

        RageUI.Button("Decline" , nil, {RightLabel = ""}, true, function(Hovered, Active, Selected) end, RMenu:Get("KnifeStoreMenu", "main"))
       

    end) 
end
end)

KnifeStoreMenu = false
Citizen.CreateThread(function() 
    while true do
   
            local v1 = knifestore.location

            if isInArea(v1, 500.0) then 
                DrawMarker(27, knifestore.marker, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 255, 0, 0, 250, 0, 0, 2, true, 0, 0, false)
            end
        
            if isInArea(v1, 0.8) then 
            
                alert('Press ~INPUT_VEH_HORN~ to access ' .. knifestore.name)
                if IsControlJustPressed(0, 51) then
                    PlaySound(-1,"Hit","RESPAWN_SOUNDSET",0,0,1) 
                    RageUI.Visible(RMenu:Get("KnifeStoreMenu", "main"), true)
                    KnifeStoreMenu = true

                end
            end

            if isInArea(v1, 0.8) == false and KnifeStoreMenu then
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("KnifeStoreMenu", "main"), false)
                KnifeStoreMenu = false
            end
     
        Citizen.Wait(1)
    end
end)


-- [Blip]
Citizen.CreateThread(function()
    blip = AddBlipForCoord(knifestore.location)
    SetBlipSprite(blip, 154)
    SetBlipScale(blip, 0.7)
    SetBlipDisplay(blip, 2)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(knifestore.name)
    EndTextCommandSetBlipName(blip)
end)





