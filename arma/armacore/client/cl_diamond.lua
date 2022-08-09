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

                TriggerServerEvent('ARMA:GatherDiamond')
                
                exports.rprogress:Start("", 5000)
                ClearPedTasksImmediately(ped)
                Action = false
              else
                tARMA.notify({"~r~You cant gather Diamond while Driving!"})
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

              TriggerServerEvent('ARMA:ProcessDiamond')

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

-- [RageUI Menu]
RMenu.Add('SellerMenu', 'main', RageUI.CreateMenu("", "~b~Seller",tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "banners", "seller"))
RageUI.CreateWhile(1.0, true, function()
  if RageUI.Visible(RMenu:Get('SellerMenu', 'main')) then
      RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        RageUI.Button("Sell Gold" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
    
                TriggerServerEvent('ARMA:SellGold')
            end
        end)

        RageUI.Button("Sell Diamond" , nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
          if Selected then

              TriggerServerEvent('ARMA:SellDiamond')
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
