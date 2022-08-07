local InRangeGather = false
local InRangeProcess = false
local InRangeSell = false
local CanSeeMarker = false


-- [Heroin Gather] --
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500)

    if IsPlayerNearCoords(vector3(Drugs.Heroin.Gather.x,Drugs.Heroin.Gather.y,Drugs.Heroin.Gather.z), Drugs.Heroin.Gather.radius) then
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

                TriggerServerEvent('ARMA:GatherHeroin')
                
                exports.rprogress:Start("", 5000)
                ClearPedTasksImmediately(ped)
                Action = false
              else
                tARMA.notify({"~r~You cant gather Heroin while Driving!"})
              end
            end
          end
        end)
      end
    else
      InRangeGather = false
    end


    -- [Heroin Process] --

    if IsPlayerNearCoords(vector3(Drugs.Heroin.Process.x,Drugs.Heroin.Process.y,Drugs.Heroin.Process.z), Drugs.Heroin.Process.radius) then
      SetTextEntry_2("STRING")
      AddTextComponentString("Press [E] to process Heroin.")
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

              TriggerServerEvent('ARMA:ProcessHeroin')

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
  end
end)

local isInMenu = false
local currentAmmunition = nil
Citizen.CreateThread(function() 
    while true do

            local v1 = vector3(Drugs.Heroin.Sell.x,Drugs.Heroin.Sell.y,Drugs.Heroin.Sell.z)

            if isInMenu == false then

            if isInArea(v1, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to access Heroin Seller')
                if IsControlJustPressed(0, 51) then 
                    currentAmmunition = k
                    RageUI.Visible(RMenu:Get("HeroinMenu", "Heroin Seller"), true)
                    isInMenu = true
                    currentAmmunition = k 
                end
            end
            end
            if isInArea(v1, 1.4) == false and isInMenu and k == currentAmmunition then
              RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("HeroinMenu", "Heroin Seller"), false)
                isInMenu = false
                currentAmmunition = nil
            end
        Citizen.Wait(0)
    end
end)

-- [RageUI Menu]
RMenu.Add('HeroinMenu', 'Heroin Seller', RageUI.CreateMenu("", "~b~Heroin Seller",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "banners", "seller"))

RageUI.CreateWhile(1.0, true, function()
  if RageUI.Visible(RMenu:Get('HeroinMenu', 'Heroin Seller')) then
      RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
    
    RageUI.Button("Sell Heroin" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
        if Selected then
 
            TriggerServerEvent('ARMA:SellHeroin')
        end
    end)

  end) 
end
end)

function isInArea(v, dis) 
    
  if #(GetEntityCoords(PlayerPedId(-1)) - v) <= dis then  
      return true
  else 
      return false
  end
end
