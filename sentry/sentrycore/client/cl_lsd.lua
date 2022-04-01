local InRangeGather = false
local InRangeProcess = false
local InRangeSell = false
local CanSeeMarker = false


-- [LSD Gather] --
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500)

    if IsPlayerNearCoords(vector3(Drugs.LSD.Gather.x,Drugs.LSD.Gather.y,Drugs.LSD.Gather.z), Drugs.LSD.Gather.radius) then
      SetTextEntry_2("STRING")
      AddTextComponentString("Press [E] to gather Opium")
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

                TriggerServerEvent('Sentry:GatherLSD')
                
                exports.rprogress:Start("", 5000)
                ClearPedTasksImmediately(ped)
                Action = false
              else
                Sentry.notify({"~r~You cant gather LSD while Driving!"})
              end
            end
          end
        end)
      end
    else
      InRangeGather = false
    end


    -- [LSD Process] --

    if IsPlayerNearCoords(vector3(Drugs.LSD.Process.x,Drugs.LSD.Process.y,Drugs.LSD.Process.z), Drugs.LSD.Process.radius) then
      SetTextEntry_2("STRING")
      AddTextComponentString("Press [E] to process LSD.")
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

              TriggerServerEvent('Sentry:ProcessLSD')

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

    -- [LSD Seller] --

    if IsPlayerNearCoords(vector3(Drugs.LSD.Sell.x,Drugs.LSD.Sell.y,Drugs.LSD.Sell.z), 100.0) then
      if not CanSeeMarker then
        CanSeeMarker = true
        Citizen.CreateThread(function()
          while CanSeeMarker do
            Citizen.Wait(0)
            DrawMarker(2,  Drugs.LSD.Sell.x,Drugs.LSD.Sell.y,Drugs.LSD.Sell.z+1 - 0.98, 0, 0, 0, 0, 0, 0, 0.6, 0.3, 0.3, 198, 3, 252, 150, true, true, 0, 0, 0, 0, 0)

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

            local v1 = vector3(Drugs.LSD.Sell.x,Drugs.LSD.Sell.y,Drugs.LSD.Sell.z)

            if isInMenu == false then

            if isInArea(v1, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to access LSD Seller')
                if IsControlJustPressed(0, 51) then 
                    currentAmmunition = k
                    RageUI.Visible(RMenu:Get("LSDMenu", "LSD Seller"), true)
                    isInMenu = true
                    currentAmmunition = k 
                end
            end
            end
            if isInArea(v1, 1.4) == false and isInMenu and k == currentAmmunition then
              RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("LSDMenu", "LSD Seller"), false)
                isInMenu = false
                currentAmmunition = nil
            end
        Citizen.Wait(0)
    end
end)

-- [RageUI Menu]
RMenu.Add('LSDMenu', 'LSD Seller', RageUI.CreateMenu("", "~g~Sentry LSD Seller",1300, 50, "lsd", "lsd"))

RageUI.CreateWhile(1.0, true, function()
  if RageUI.Visible(RMenu:Get('LSDMenu', 'LSD Seller')) then
      RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
    
    RageUI.Button("Sell LSD" , nil, {}, true, function(Hovered, Active, Selected)
        if Selected then
 
            TriggerServerEvent('Sentry:SellLSD')
        end
    end)

  end) 
end
end)

-- [Blips]

Citizen.CreateThread(function()
  lsd = AddBlipForCoord(Drugs.LSD.Sell.x,Drugs.LSD.Sell.y,Drugs.LSD.Sell.z)
  SetBlipSprite(lsd, 403)
  SetBlipScale(lsd, 0.8)
  SetBlipDisplay(lsd, 2)
  SetBlipColour(lsd, 27)
  SetBlipAsShortRange(lsd, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("LSD Seller")
  EndTextCommandSetBlipName(lsd)
  end)

Citizen.CreateThread(function()
  blip = AddBlipForCoord(Drugs.LSD.Gather.x,Drugs.LSD.Gather.y,Drugs.LSD.Gather.z)
  SetBlipSprite(blip, 403)
  SetBlipScale(blip, 0.6)
  SetBlipDisplay(blip, 2)
  SetBlipColour(blip, 27)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("LSD Gather")
  EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
  blip = AddBlipForCoord(Drugs.LSD.Process.x,Drugs.LSD.Process.y,Drugs.LSD.Process.z)
  SetBlipSprite(blip, 403)
  SetBlipScale(blip, 0.6)
  SetBlipDisplay(blip, 2)
  SetBlipColour(blip, 27)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("LSD Process")
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
