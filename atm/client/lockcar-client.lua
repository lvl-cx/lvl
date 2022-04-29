RegisterNetEvent("ATMVeh:lockcar")
AddEventHandler("ATMVeh:lockcar", function()
  local veh, name, nveh = tATM.getNearestOwnedVehicle(5)
  if veh then 
      tATM.vc_toggleLock(name)
      tATM.playSound("HUD_MINI_GAME_SOUNDSET", "5_SEC_WARNING")
  end
end)

Citizen.CreateThread(function() 
  while true do
    Citizen.Wait(0)
    if IsControlJustPressed(1, 82) then
      local veh, name, nveh = tATM.getNearestOwnedVehicle(5)
      if veh then 
        tATM.vc_toggleLock(name)
        tATM.playSound("HUD_MINI_GAME_SOUNDSET", "5_SEC_WARNING")
      end
    end
  end
end)
