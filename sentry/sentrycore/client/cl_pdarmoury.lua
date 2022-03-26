-- [CFG]
armoury = {}

armoury.location = vector3(451.34454345703,-980.09381103516,30.689605712891)

armoury.marker = vector3(451.34454345703,-980.09381103516,30.689605712891-0.98)

armoury.name = 'Police Armoury'

armoury.banner = 'police'

-- [Start of RageUI]

RMenu.Add('PDArmoury', 'main', RageUI.CreateMenu("", "~g~Sentry " .. armoury.name, 1300, 50, armoury.banner, armoury.banner))
RMenu.Add("PDArmoury", "confirm", RageUI.CreateSubMenu(RMenu:Get('PDArmoury', 'main',  1300, 50)))
RMenu.Add("PDArmoury", "confirma", RageUI.CreateSubMenu(RMenu:Get('PDArmoury', 'main',  1300, 50)))

armoury.guns = {
    {name = "M1911", hash = "WEAPON_M1911"},
    {name = "FNP",  hash = "WEAPON_FNP"},
    {name = "PDW", hash = "WEAPON_PDW"},
}

-- [Actual Menu]

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('PDArmoury', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        for i , p in pairs(armoury.guns) do 
            RageUI.Button(p.name , nil, { RightLabel = '~g~→'}, true, function(Hovered, Active, Selected)
                if Selected then

                    cHash = p.hash

                end
            end, RMenu:Get("PDArmoury", "confirm"))
        end

        RageUI.Button("Level 4 Armour ~g~[100%]" , nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected) end, RMenu:Get("PDArmoury", "confirma"))
    end) 
end
end)
-- [ArmourConfirm Purchase]
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("PDArmoury", "confirma")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        RMenu:Get("PDArmoury", "confirm"):SetSubtitle("Are you sure?")
        
        RageUI.Button("Confirm" , nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then

                TriggerServerEvent('PD:BuyArmour')

            end
        end, RMenu:Get("PDArmoury", "main"))

        RageUI.Button("Decline" , nil, {RightLabel = ""}, true, function(Hovered, Active, Selected) end, RMenu:Get("PDArmoury", "main"))
       

    end) 
end
end)


-- [Confirm Purchase]
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("PDArmoury", "confirma")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        RMenu:Get("PDArmoury", "confirm"):SetSubtitle("Are you sure?")
        
        RageUI.Button("Confirm" , nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then

                TriggerServerEvent('PD:BuyWeapon', cHash)

            end
        end, RMenu:Get("PDArmoury", "main"))

        RageUI.Button("Decline" , nil, {RightLabel = ""}, true, function(Hovered, Active, Selected) end, RMenu:Get("PDArmoury", "main"))
       

    end) 
end
end)

PDArmoury = false
Citizen.CreateThread(function() 
    while true do
   
            local v1 = armoury.location

            if isInArea(v1, 500.0) then 
                DrawMarker(27, armoury.marker, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 0, 132, 255, 250, 0, 0, 2, true, 0, 0, false)
            end
        
            if isInArea(v1, 0.8) then 
            
                alert('Press ~INPUT_VEH_HORN~ to access ' .. armoury.name)
                if IsControlJustPressed(0, 51) then
                    PlaySound(-1,"Hit","RESPAWN_SOUNDSET",0,0,1) 
                    RageUI.Visible(RMenu:Get("PDArmoury", "main"), true)
                    PDArmoury = true

                end
            end

            if isInArea(v1, 0.8) == false and PDArmoury then
                RageUI.CloseAll()
                PDArmoury = false
            end
     
        Citizen.Wait(1)
    end
end)





