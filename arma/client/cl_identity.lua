RMenu.Add('identitymenu', 'main', RageUI.CreateMenu("", "~b~Identity Menu", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), 'banners', 'identity'))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('identitymenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = true}, function()
            RageUI.Button("New Identity" , nil, {RightLabel = "~g~£100"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('Identity')
                end
            end)
        end)
    end
end)

isInMenu = false
Citizen.CreateThread(function() 
    while true do
            local v1 = vector3(-911.130859375,-2022.8002929688,12.833104133606)
            if isInArea(v1, 100.0) then 
                DrawMarker(32, -911.130859375,-2022.8002929688,12.833104133606, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.4, 14, 212, 0, 250, true, true, false, false, nil, nil, false)
            end
            if isInArea(v1, 1.4) and not isInMenu then 
                alert('Press ~INPUT_VEH_HORN~ to enter identity menu')
                if IsControlJustPressed(0, 51) then 
                    RageUI.Visible(RMenu:Get("identitymenu", "main"), true)
                    isInMenu = true
                end
            end
            if isInArea(v1, 1.4) == false and isInMenu then
                RageUI.Visible(RMenu:Get("identitymenu", "main"), false)
                isInMenu = false
            end
        Citizen.Wait(0)
    end
end)

function isInArea(v, dis) 
    if #(GetEntityCoords(PlayerPedId(-1)) - v) <= dis then  
        return true
    else 
        return false
    end
end

function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

Citizen.CreateThread(function()
    blip = AddBlipForCoord(-911.130859375,-2022.8002929688,12.833104133606)
    SetBlipSprite(blip, 498)
    SetBlipScale(blip, 0.5)
    SetBlipDisplay(blip, 2)
    SetBlipColour(blip, 0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Identity Shop")
    EndTextCommandSetBlipName(blip)
  end)