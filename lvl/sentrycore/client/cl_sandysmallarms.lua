-- [CFG]
sandysmall = {}

sandysmall.location = vector3(2436.9794921875,4966.5571289062,42.347602844238)

sandysmall.marker = vector3(2436.9794921875,4966.5571289062,42.347602844238-0.99)

sandysmall.name = 'Sandy Small Arms'

sandysmall.banner = 'small'

-- [Start of RageUI]

RMenu.Add('SandySmallArms', 'main', RageUI.CreateMenu("", "~b~LVL " .. sandysmall.name, 1300, 50, sandysmall.banner, sandysmall.banner))
RMenu.Add("SandySmallArms", "confirm", RageUI.CreateSubMenu(RMenu:Get('SandySmallArms', 'main',  1300, 50)))
RMenu.Add("SandySmallArms", "confirma", RageUI.CreateSubMenu(RMenu:Get('SandySmallArms', 'main',  1300, 50)))

sandysmall.guns = {
    {name = "M1911", price = 60000, hash = "WEAPON_M1911"},
    {name = "FNP", price = 70000, hash = "WEAPON_FNP"},
    {name = "PDW", price = 150000, hash = "WEAPON_PDW"},
}

-- [Actual Menu]

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('SandySmallArms', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        for i , p in pairs(sandysmall.guns) do 
            RageUI.Button(p.name , nil, { RightLabel = '~b~£' .. tostring(getMoneyStringFormatted(p.price)) }, true, function(Hovered, Active, Selected)
                if Selected then

                    cPrice = p.price
                    cHash = p.hash
                    cName = p.name

                end
            end, RMenu:Get("SandySmallArms", "confirm"))
        end

        RageUI.Button("Level 1 Armour ~b~[25%]" , nil, {RightLabel = "~b~£25,000"}, true, function(Hovered, Active, Selected)
            if Selected then


            end
        end, RMenu:Get("SandySmallArms", "confirma"))
    end) 
end
end)

-- [Confirm Purchase]
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("SandySmallArms", "confirm")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("Weapon Name: ~b~" .. cName, function() end)
            RageUI.Separator("Weapon Price: ~b~£" .. getMoneyStringFormatted(cPrice), function() end)
            RageUI.Separator("Current Gunstore: ~b~" .. sandysmall.name, function() end)
        
        RageUI.Button("Confirm" , nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
            if Selected then

                TriggerServerEvent('SandySmall:BuyWeapon', cPrice, cHash)

            end
        end, RMenu:Get("SandySmallArms", "main"))

        RageUI.Button("Decline" , nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected) end, RMenu:Get("SandySmallArms", "main"))
       

    end) 
end
end)
-- [Armour Confirm Purchase]
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("SandySmallArms", "confirma")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("Armour Plate: ~b~" .. 'Level 1 [25%]', function() end)
            RageUI.Separator("Armour Plate Price: ~b~£" .. '25,000', function() end)
            RageUI.Separator("Current Gunstore: ~b~" .. sandysmall.name, function() end)
        
        RageUI.Button("Confirm" , nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
            if Selected then

                TriggerServerEvent('SandySmall:BuyArmour')

            end
        end, RMenu:Get("SandySmallArms", "main"))

        RageUI.Button("Decline" , nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected) end, RMenu:Get("SandySmallArms", "main"))
       

    end) 
end
end)

SandySmallMenu = false
Citizen.CreateThread(function() 
    while true do
   
            local v1 = sandysmall.location

            if isInArea(v1, 500.0) then 
                DrawMarker(27, sandysmall.marker, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 255, 0, 0, 250, 0, 0, 2, true, 0, 0, false)
            end
       
            if isInArea(v1, 0.8) then 
                alert('Press ~INPUT_VEH_HORN~ to access ' .. sandysmall.name)
                if IsControlJustPressed(0, 51) then
                    PlaySound(-1,"Hit","RESPAWN_SOUNDSET",0,0,1) 
                    RageUI.Visible(RMenu:Get("SandySmallArms", "main"), true)
                    SandySmallMenu = true

                end
            end
         
            if isInArea(v1, 0.8) == false and SandySmallMenu then
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("SandySmallArms", "main"), false)
                SandySmallMenu = false
            end
     
        Citizen.Wait(1)
    end
end)


-- [Blip]
Citizen.CreateThread(function()
    blip = AddBlipForCoord(sandysmall.location)
    SetBlipSprite(blip, 110)
    SetBlipScale(blip, 0.6)
    SetBlipDisplay(blip, 2)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(sandysmall.name)
    EndTextCommandSetBlipName(blip)
  end)


-- [Function]


RegisterNetEvent("LVL:PlaySound")
AddEventHandler("LVL:PlaySound", function(status)
    if status == 1 then 
        PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 0)
    end

    if status == 2 then 
        PlaySoundFrontend(-1, "Hack_Failed", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 0)
    end
end)

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

function isInArea(v, dis) 
    
    if #(GetEntityCoords(PlayerPedId(-1)) - v) <= dis then  
        return true
    else 
        return false
    end
end

local clothingID = 4
local index = 0
RegisterNetEvent('LVL:SetVest')
AddEventHandler('LVL:SetVest', function()
    player = GetPlayerPed(-1)
    SetPedComponentVariation(player, 9, clothingID, index, 0) 
end)


RegisterNetEvent('LVL:ChangeArmour2')
AddEventHandler('LVL:ChangeArmour2', function(id, indexz)
  clothingID = id
  index = indexz
end)

