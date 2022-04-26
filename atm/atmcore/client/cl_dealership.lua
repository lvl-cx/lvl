

dealership = {}

dealership.guns = {

    {spawncode = "Adder", vehname = "Adder", vehdesc = "", price = 0},
    {spawncode = "NineF", vehname = "NineF", vehdesc = "", price = 0},
    {spawncode = "Deluxo", vehname = "Deluxo", vehdesc = "", price = 0},
}

dealership.guns2 = {
    {spawncode = "apex3", vehname = "VW APEX 3", vehdesc = "", price = 1},
    {spawncode = "audia4marked", vehname = "Audi A4 Marked", vehdesc = "", price = 1},
    {spawncode = "audia4unmarked", vehname = "Audi A4 Unmarked", vehdesc = "", price = 1},
    {spawncode = "polf150", vehname = "Offroad F150", vehdesc = "", price = 1},
    {spawncode = "pddirtbike", vehname = "PD Dirtbike", vehdesc = "", price = 1},
    {spawncode = "pbmw540i", vehname = "BMW 540i", vehdesc = "", price = 1},
    {spawncode = "pdbmwm5", vehname = "BMW M5", vehdesc = "", price = 1},
    {spawncode = "pdjagsuv", vehname = "Jaguar SUV", vehdesc = "", price = 1},
    {spawncode = "pdjagxfr", vehname = "Jaguar XFR", vehdesc = "", price = 1},
    {spawncode = "pdmarkedfocus", vehname = "Ford Focus", vehdesc = "", price = 1},
    {spawncode = "pdnissangtr", vehname = "Nissan GTR Unmarked", vehdesc = "", price = 1},
    {spawncode = "pdprior", vehname = "Audi Prior Unmarked", vehdesc = "", price = 1},
    {spawncode = "wf20", vehname = "Armed Van", vehdesc = "", price = 1},
}

RMenu.Add('DealershipMenu', 'main', RageUI.CreateMenu("", "~g~ATM Dealership Menu", 1300, 50, 'garage', 'garage'))
RMenu.Add("DealershipMenu", "sim", RageUI.CreateSubMenu(RMenu:Get('DealershipMenu', 'main',  1300, 50)))
RMenu.Add("DealershipMenu", "police", RageUI.CreateSubMenu(RMenu:Get('DealershipMenu', 'main',  1300, 50)))
RMenu.Add("DealershipMenu", "confirm", RageUI.CreateSubMenu(RMenu:Get('DealershipMenu', 'sim',  1300, 50)))
RMenu.Add("DealershipMenu", "confirmA", RageUI.CreateSubMenu(RMenu:Get('DealershipMenu', 'police',  1300, 50)))

local hasPoliceRole = false
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('DealershipMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
      
            RageUI.Button('Dealership Vehicles', nil, { RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                if Selected then
 
        
                end
        
            end, RMenu:Get("DealershipMenu", "sim"))
            if hasPoliceRole then
                RageUI.Button('Police Vehicles', nil, { RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                    
                    
                    end
                
                end, RMenu:Get("DealershipMenu", "police"))
            end
  

        end) 
    end
    end)


    RageUI.CreateWhile(1.0, true, function()
        if RageUI.Visible(RMenu:Get("DealershipMenu", "sim")) then
            RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
                RageUI.Separator("Currently Viewing: ~g~" .. 'Dealership Vehicles', function() end)
        for i , p in pairs(dealership.guns) do 
            RageUI.Button(p.vehname, nil, { RightLabel = "~g~£" .. getMoneyStringFormatted(p.price) .. ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    
                    cPrice = p.price
                    cHash = p.spawncode
                    cName = p.vehname
        
                end
                if Active then 
                    TriggerEvent('returnHover', p.spawncode)
                end
            end, RMenu:Get("DealershipMenu", "confirm"))
        end

    end) 
end
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("DealershipMenu", "police")) then
        RageUI.Separator("Currently Viewing: ~g~" .. 'Police Vehicles', function() end)
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        for i , p in pairs(dealership.guns2) do 
            RageUI.Button(p.vehname, nil, { RightLabel = "£" .. getMoneyStringFormatted(p.price) .. ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    
                    cPrice = p.price
                    cHash = p.spawncode
        
                end
                if Active then 
                    TriggerEvent('returnHover', p.spawncode)
                end
            end, RMenu:Get("DealershipMenu", "confirm"))
        end

    end) 
end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("DealershipMenu", "confirm")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        RMenu:Get("DealershipMenu", "confirm"):SetSubtitle("~g~Are you sure?")
        RageUI.Separator("Currently Vehicle: ~g~" .. cName, function() end)
        RageUI.Separator("Vehicle Price: ~g~" .. cPrice, function() end)
        RageUI.Button("Purchase Vehicle" , nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
            if Selected then
                -- [Event Here]
                TriggerServerEvent('whoIs',cHash, cPrice)
            end
        end, RMenu:Get("DealershipMenu", "main"))
        
        RageUI.Button("Test Drive" , nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
            if Selected then   
                testdrivetimer = 30
                local mhash = GetHashKey(cHash)
                local i = 0
                while not HasModelLoaded(mhash) and i < 10000 do
                    RequestModel(mhash)
                    Citizen.Wait(10)
                    i = i+1
                    if i > 10000 then 
                        tATM.notify('~r~Model could not be loaded!')
                        break 
                    end
                end
                -- spawn car
                if HasModelLoaded(mhash) then
                    local nveh = CreateVehicle(mhash, -1047.984375,-3308.4685058594,13.944429397583+0.5, 0.0, true, false)
                    SetVehicleOnGroundProperly(nveh)
  
                    SetPedIntoVehicle(GetPlayerPed(-1),nveh,-1) -- put player inside

                    local nid = NetworkGetNetworkIdFromEntity(nveh)
            
                    testdriveenabled = true
                end
                if testdriveenabled then
                    if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
                        SetEntityCoords(PlayerPedId(), -32.98607635498,-1102.2288818359,26.42234992981)
                    end
                end
                Wait(30000)
                if testdriveenabled then
                    testdrivetimer = 0
                    testdriveenabled = false
                    DeleteCar3(nveh)
                    SetEntityCoords(PlayerPedId(), -54.503799438477,-1110.7507324219,26.435169219971)
                end
            end
        end, RMenu:Get("DealershipMenu", "main"))

    end) 
end
end)

RegisterNetEvent('returnPd2')
AddEventHandler('returnPd2', function(bool)
    if bool then 
        hasPoliceRole = true 
    else
        hasPoliceRole = false
    end
end)

isInDealership = false
currentAmmunition = nil
Citizen.CreateThread(function() 
    while true do

            local v1 = vector3(-49.388229370117,-1112.5594482422,26.435178756714)

            if isInArea(v1, 100.0) then 
                DrawMarker(36, -49.388229370117,-1112.5594482422,26.435178756714 +1 - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.5, 0.5, 255, 255, 255, 250, false, true, 2, false, nil, nil, false)
            end
            if isInDealership == false then
            if isInArea(v1, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to access Dealership')
                
                if IsControlJustPressed(0, 51) then 
                    TriggerServerEvent('sendPD')
                    currentAmmunition = k
                    RageUI.Visible(RMenu:Get("DealershipMenu", "main"), true)
                    isInDealership = true
                    currentAmmunition = k 
                end
            end
            end
            if isInArea(v1, 1.4) == false and isInDealership and k == currentAmmunition then
                TriggerEvent('returnHover', "shalean")
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("DealershipMenu", "main"), false)
                isInDealership = false
                currentAmmunition = nil
            end
       
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do 
        if IsControlPressed(1, 177) then
            TriggerEvent('returnHover', "shalean")
        end
        Citizen.Wait(1)
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
    blip = AddBlipForCoord(-50.406093597412,-1111.1015625,26.435157775879)
    SetBlipSprite(blip, 225)
    SetBlipScale(blip, 0.6)
    SetBlipDisplay(blip, 2)
    SetBlipColour(blip, 0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Dealership")
    EndTextCommandSetBlipName(blip)
  end)


  testdrivetimer = 0
  testdriveenabled = false
  
  Citizen.CreateThread(function()
      while true do 
          Wait(0)
          if testdriveenabled then
              DrawAdvancedTextOutline(0.605, 0.513, 0.005, 0.0028, 0.4, "Test Drive left: "..testdrivetimer.." seconds", 255, 255, 255, 255, 7, 0)
          end
      end 
  end)

  Citizen.CreateThread(function()
    while true do 
        if testdriveenabled then
            testdrivetimer = testdrivetimer - 1
        end
        Wait(1000)
    end
end) 

  
function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

function DrawAdvancedTextOutline(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

function DeleteCar3(veh)
    if veh then 
        if DoesEntityExist(veh) then 
            Hovered_Vehicles = nil
            vehname = nil
            DeleteEntity(veh)
            veh = nil
        end
    end
end

