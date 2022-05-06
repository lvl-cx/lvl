local InRangeGather = false
local InRangeProcess = false
local InRangeSell = false
local CanSeeMarker = false


-- [Cocaine Gather] --
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500)

    if IsPlayerNearCoords(vector3(Drugs.Cocaine.Gather.x,Drugs.Cocaine.Gather.y,Drugs.Cocaine.Gather.z), Drugs.Cocaine.Gather.radius) then
      SetTextEntry_2("STRING")
      AddTextComponentString("Press [E] to gather Coca Leaf")
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
                RequestAnimDict("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")
                while (not HasAnimDictLoaded("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")) do Citizen.Wait(0) end
                TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_GARDENER_PLANT', false, true)

                TriggerServerEvent('LVL:GatherCocaine')
                
                exports.rprogress:Start("", 5000)
                ClearPedTasksImmediately(ped)
                Action = false
              else
                LVL.notify({"~r~You cant gather Cocaine while Driving!"})
              end
            end
          end
        end)
      end
    else
      InRangeGather = false
    end


    -- [Cocaine Process] --

    if IsPlayerNearCoords(vector3(Drugs.Cocaine.Process.x,Drugs.Cocaine.Process.y,Drugs.Cocaine.Process.z), Drugs.Cocaine.Process.radius) then
      SetTextEntry_2("STRING")
      AddTextComponentString("Press [E] to process Cocaine.")
      EndTextCommandPrint(1000, 1)
      if not InRangeProcess then
        InRangeProcess = true
        Citizen.CreateThread(function()
          while InRangeProcess do
            Citizen.Wait(0)
      
            if IsControlJustReleased(0, 51)  then
              Action = true
              local ped = PlayerPedId()

              TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_KNEEL', false, true)

              TriggerServerEvent('LVL:ProcessCocaine')

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

    -- [Cocaine Seller] --

    if IsPlayerNearCoords(vector3(Drugs.Cocaine.Sell.x,Drugs.Cocaine.Sell.y,Drugs.Cocaine.Sell.z), 100.0) then
      if not CanSeeMarker then
        CanSeeMarker = true
        Citizen.CreateThread(function()
          while CanSeeMarker do
            Citizen.Wait(0)
            DrawMarker(2,  Drugs.Cocaine.Sell.x,Drugs.Cocaine.Sell.y,Drugs.Cocaine.Sell.z+1 - 0.98, 0, 0, 0, 0, 0, 0, 0.6, 0.3, 0.3, 255, 255, 255, 150, true, true, 0, 0, 0, 0, 0)

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

            local v1 = vector3(Drugs.Cocaine.Sell.x,Drugs.Cocaine.Sell.y,Drugs.Cocaine.Sell.z)

            if isInMenu == false then

            if isInArea(v1, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to access Cocaine Seller')
                if IsControlJustPressed(0, 51) then 
                    currentAmmunition = k
                    RageUI.Visible(RMenu:Get("CocaineMenu", "Cocaine Seller"), true)
                    isInMenu = true
                    currentAmmunition = k 
                end
            end
            end
            if isInArea(v1, 1.4) == false and isInMenu and k == currentAmmunition then
              RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("CocaineMenu", "Cocaine Seller"), false)
                isInMenu = false
                currentAmmunition = nil
            end
        Citizen.Wait(0)
    end
end)

-- [RageUI Menu]
RMenu.Add('CocaineMenu', 'Cocaine Seller', RageUI.CreateMenu("", "~w~LVL Cocaine Seller",1300, 50, "cocaine", "cocaine"))

RageUI.CreateWhile(1.0, true, function()
  if RageUI.Visible(RMenu:Get('CocaineMenu', 'Cocaine Seller')) then
      RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
    
    RageUI.Button("Sell Cocaine" , nil, {RightLabel = "~w~→"}, true, function(Hovered, Active, Selected)
        if Selected then
 
            TriggerServerEvent('LVL:SellCocaine')
        end
    end)

  end) 
end
end)

-- [Blips]

Citizen.CreateThread(function()
  cocaine = AddBlipForCoord(Drugs.Cocaine.Sell.x,Drugs.Cocaine.Sell.y,Drugs.Cocaine.Sell.z)
  SetBlipSprite(cocaine, 403)
  SetBlipScale(cocaine, 0.6)
  SetBlipDisplay(cocaine, 2)
  SetBlipColour(cocaine, 0)
  SetBlipAsShortRange(cocaine, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Cocaine Seller")
  EndTextCommandSetBlipName(cocaine)
  end)

Citizen.CreateThread(function()
  blip = AddBlipForCoord(Drugs.Cocaine.Gather.x,Drugs.Cocaine.Gather.y,Drugs.Cocaine.Gather.z)
  SetBlipSprite(blip, 403)
  SetBlipScale(blip, 0.5)
  SetBlipDisplay(blip, 2)
  SetBlipColour(blip, 0)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Cocaine Gather")
  EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
  blip = AddBlipForCoord(Drugs.Cocaine.Process.x,Drugs.Cocaine.Process.y,Drugs.Cocaine.Process.z)
  SetBlipSprite(blip, 403)
  SetBlipScale(blip, 0.5)
  SetBlipDisplay(blip, 2)
  SetBlipColour(blip, 0)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Cocaine Process")
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
