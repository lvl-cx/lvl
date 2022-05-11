local InRangeGather = false
local InRangeProcess = false
local InRangeSell = false
local CanSeeMarker = false


-- [Diamond Gather] --
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500)

    if IsPlayerNearCoords(vector3(Drugs.Diamond.Gather.x,Drugs.Diamond.Gather.y,Drugs.Diamond.Gather.z), Drugs.Diamond.Gather.radius) then
      SetTextEntry_2("STRING")
      AddTextComponentString("Press [E] to gather Diamond Crystals")
      EndTextCommandPrint(1000, 1)
      if not InRangeGather then
        InRangeGather = true
        Citizen.CreateThread(function()
          while InRangeGather do
            Citizen.Wait(0)
          
            if IsControlJustReleased(0, 51)  then
              if not pedinveh then
                Action = true
                local ped = PlayerPedId()
                Animation()

                TriggerServerEvent('LVL:GatherDiamond')
                
                exports.rprogress:Start("", 5000)
                ClearPedTasksImmediately(ped)
                Action = false
              else
                LVL.notify({"~r~You cant gather Diamond while Driving!"})
              end
            end
          end
        end)
      end
    else
      InRangeGather = false
    end


    -- [Diamond Process] --

    if IsPlayerNearCoords(vector3(Drugs.Diamond.Process.x,Drugs.Diamond.Process.y,Drugs.Diamond.Process.z), Drugs.Diamond.Process.radius) then
      SetTextEntry_2("STRING")
      AddTextComponentString("Press [E] to process Diamond.")
      EndTextCommandPrint(1000, 1)
      if not InRangeProcess then
        InRangeProcess = true
        Citizen.CreateThread(function()
          while InRangeProcess do
            Citizen.Wait(0)
      
            if IsControlJustReleased(0, 51)  then
              Action = true
              local ped = PlayerPedId()

              RequestAnimDict("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")
              while (not HasAnimDictLoaded("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")) do Citizen.Wait(0) end
              TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', false, true)

              TriggerServerEvent('LVL:ProcessDiamond')

              exports.rprogress:Start("", 5000)
              Action = false
   
              ClearPedTasksImmediately(ped, true)
            end
          end
        end)
      end
    else
      InRangeProcess = false
    end

    -- [Diamond Seller] --

    if IsPlayerNearCoords(vector3(1222.3013916016,-2995.5390625,5.8653602600098), 100.0) then
      if not CanSeeMarker then
        CanSeeMarker = true
        Citizen.CreateThread(function()
          while CanSeeMarker do
            Citizen.Wait(0)
            DrawMarker(2,  1222.3013916016,-2995.5390625,5.8653602600098+1 - 0.98, 0, 0, 0, 0, 0, 0, 0.6, 0.3, 0.3, 0, 214, 50, 150, true, true, 0, 0, 0, 0, 0)

          end
        end)
      end
    else
      CanSeeMarker = false
    end
  end
end)

local isInMenu = false
local currentAmmunition = nil
Citizen.CreateThread(function() 
    while true do

            local v1 = vector3(1222.3013916016,-2995.5390625,5.8653602600098)

            if isInMenu == false then

            if isInArea(v1, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to access Seller')
                if IsControlJustPressed(0, 51) then 
                    currentAmmunition = k
                    RageUI.Visible(RMenu:Get('SellerMenu', 'main'), true)
                    isInMenu = true
                    currentAmmunition = k 
                end
            end
            end
            if isInArea(v1, 1.4) == false and isInMenu and k == currentAmmunition then
              RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get('SellerMenu', 'main'), false)
                isInMenu = false
                currentAmmunition = nil
            end
        Citizen.Wait(0)
    end
end)

-- [RageUI Menu]
RMenu.Add('SellerMenu', 'main', RageUI.CreateMenu("", "LVL Seller",1300, 50, "seller", "seller"))

RageUI.CreateWhile(1.0, true, function()
  if RageUI.Visible(RMenu:Get('SellerMenu', 'main')) then
      RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
    
    RageUI.Button("Sell Gold" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
        if Selected then
 
            TriggerServerEvent('LVL:SellGold')
        end
    end)

    RageUI.Button("Sell Diamond" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
      if Selected then

          TriggerServerEvent('LVL:SellDiamond')
      end
  end)

  end) 
end
end)

-- [Blips]


Citizen.CreateThread(function()
  blip = AddBlipForCoord(Drugs.Diamond.Gather.x,Drugs.Diamond.Gather.y,Drugs.Diamond.Gather.z)
  SetBlipSprite(blip, 616)
  SetBlipScale(blip, 0.6)
  SetBlipDisplay(blip, 2)
  SetBlipColour(blip, 3)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Diamond Gather")
  EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
  blip = AddBlipForCoord(Drugs.Diamond.Process.x,Drugs.Diamond.Process.y,Drugs.Diamond.Process.z)
  SetBlipSprite(blip, 616)
  SetBlipScale(blip, 0.6)
  SetBlipDisplay(blip, 2)
  SetBlipColour(blip, 3)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Diamond Process")
  EndTextCommandSetBlipName(blip)
end)
-- [Functions]


function isInArea(v, dis) 
    
  if #(GetEntityCoords(PlayerPedId(-1)) - v) <= dis then  
      return true
  else 
      return false
  end
end
