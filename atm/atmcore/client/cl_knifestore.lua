-- [CFG]
knifestore = {}

knifestore.location = vector3(-676.46417236328,-878.25500488281,24.473949432373)

knifestore.marker = vector3(-676.46417236328,-878.25500488281,24.473949432373-0.98)

knifestore.name = 'Knife Store'

knifestore.banner = 'knife'

-- [Start of RageUI]

RMenu.Add('KnifeStoreMenu', 'main', RageUI.CreateMenu("", "~g~ATM " .. knifestore.name, 1300, 50, knifestore.banner, knifestore.banner))
RMenu.Add("KnifeStoreMenu", "confirm", RageUI.CreateSubMenu(RMenu:Get('KnifeStoreMenu', 'main',  1300, 50)))

knifestore.guns = {
    {name = "M1911", price = 60000, hash = "WEAPON_M1911"},
    {name = "FNP", price = 70000, hash = "WEAPON_FNP"},
    {name = "PDW", price = 150000, hash = "WEAPON_PDW"},
}

-- [Actual Menu]

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('KnifeStoreMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        for i , p in pairs(knifestore.guns) do 
            RageUI.Button(p.name , nil, { RightLabel = '~g~£' .. tostring(getMoneyStringFormatted(p.price)) }, true, function(Hovered, Active, Selected)
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
        RageUI.Separator("Weapon Name: ~g~" .. cName, function() end)
        RageUI.Separator("Weapon Price: ~g~£" .. getMoneyStringFormatted(cPrice), function() end)
        RageUI.Separator("Current Gunstore: ~g~" .. knifestore.name, function() end)
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





