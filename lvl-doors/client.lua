local doors = {}
local LockHotkey = {0,38,true}

RegisterNetEvent('lvldoorsystem:load')
AddEventHandler('lvldoorsystem:load', function(list)
  doors = list
end)

RegisterNetEvent('lvldoorsystem:statusSend')
AddEventHandler('lvldoorsystem:statusSend', function(i, status)
  if doors[i] ~= nil then
    doors[i].locked = status
  else
    print("Door system not yet loaded.")
  end
end)


function searchIdDoor()
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
  for k,v in pairs(doors) do
    if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) <= 1.5 then
      return k
    end
  end
  return 0
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if IsControlJustReleased(table.unpack(LockHotkey)) then
      local id = searchIdDoor()
      if id ~= 0 then
        TriggerServerEvent("lvldoorsystem:open", id)
      end
    end
  end
end)


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    for k,v in pairs(doors) do
      if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) <= 1.5  then
          local door = GetClosestObjectOfType(v.x,v.y,v.z, 1.5, v.hash, false, false, false)
          if door ~= 0 then
            SetEntityCanBeDamaged(door, false)
            if v.locked == false then
              NetworkRequestControlOfEntity(door)
              FreezeEntityPosition(door, false)
              DrawText3D(v.x,v.y,v.z, '🔓', 0, 255, 0)
            else
              local locked, heading = GetStateOfClosestDoorOfType(v.hash, v.x,v.y,v.z, locked, heading)
              if heading > -0.02 and heading < 0.02 then
                NetworkRequestControlOfEntity(door)
                FreezeEntityPosition(door, true)
                DrawText3D(v.x,v.y,v.z, '🔒', 255, 0, 0)
              end
            end
          end
      end
    end
  end
end)

function DrawText3D(x,y,z, text, r,g,b)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  local dist = #(vector3(px,py,pz)-vector3(x,y,z))

  local scale = (1/dist)*1.6
  local fov = (1/GetGameplayCamFov())*100
  local scale = scale*fov

  if onScreen then
      if not useCustomScale then
          SetTextScale(0.0*scale, 0.55*scale)
      else
          SetTextScale(0.0*scale, customScale)
      end
      SetTextFont(0)
      SetTextProportional(1)
      SetTextColour(r, g, b, 255)
      SetTextDropshadow(0, 0, 0, 0, 255)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      DrawText(_x,_y)
  end
end
