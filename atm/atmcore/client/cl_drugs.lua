pedcoords = vector3(0,0,0)
pedinveh = false
Action = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(100)
    local ped = PlayerPedId()
    pedcoords = GetEntityCoords(ped)
    pedinveh = IsPedInAnyVehicle(ped, true)
  end
end)

function IsPlayerNearCoords(coords, radius)
  local distance = #(pedcoords - coords)
  if distance < (radius + 0.00001) then
    return true
  end
  return false
end

function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end


