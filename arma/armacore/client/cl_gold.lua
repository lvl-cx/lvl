local InRangeGather = false
local InRangeProcess = false
local InRangeSell = false
local CanSeeMarker = false
local impacts = 0


-- [Gold Gather] --
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500)

    if IsPlayerNearCoords(vector3(Drugs.Gold.Gather.x,Drugs.Gold.Gather.y,Drugs.Gold.Gather.z), Drugs.Gold.Gather.radius) then
      SetTextEntry_2("STRING")
      AddTextComponentString("Press [E] to gather Gold Dust")
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

                TriggerServerEvent('ARMA:GatherGold')
                
                exports.rprogress:Start("", 5000)
                --ClearPedTasksImmediately(ped)
                Action = false
              else
                tARMA.notify({"~r~You cant gather Gold while Driving!"})
              end
            end
          end
        end)
      end
    else
      InRangeGather = false
    end


    -- [Gold Process] --

    if IsPlayerNearCoords(vector3(Drugs.Gold.Process.x,Drugs.Gold.Process.y,Drugs.Gold.Process.z), Drugs.Gold.Process.radius) then
      SetTextEntry_2("STRING")
      AddTextComponentString("Press [E] to process Gold.")
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

              TriggerServerEvent('ARMA:ProcessGold')

              exports.rprogress:Start("", 5000)
              Action = false
   
            end
          end
        end)
      end
    else
      InRangeProcess = false
    end
  end
end)

function Animation()
  Citizen.CreateThread(function()
      while impacts < 5 do
          Citizen.Wait(1)
      local ped = PlayerPedId()    
              RequestAnimDict("melee@large_wpn@streamed_core")
              Citizen.Wait(100)
              TaskPlayAnim((ped), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 8.0, 8.0, -1, 80, 0, 0, 0, 0)
              SetEntityHeading(ped, 270.0)

              if impacts == 0 then
                  pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true) 
                  AttachEntityToEntity(pickaxe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.18, -0.02, -0.02, 350.0, 100.00, 140.0, true, true, false, true, 1, true)
              end  
              Citizen.Wait(1000)
              ClearPedTasks(ped)
              impacts = impacts+1
              if impacts == 5 then
                  DetachEntity(pickaxe, 1, true)
                  DeleteEntity(pickaxe)
                  DeleteObject(pickaxe)
                  mineActive = false
                  impacts = 0
                  break
              end        
      end
  end)
end

function isInArea(v, dis) 
    
  if #(GetEntityCoords(PlayerPedId(-1)) - v) <= dis then  
      return true
  else 
      return false
  end
end
