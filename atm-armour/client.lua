--[[
    FiveM Scripts
    Copyright C 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    at your option any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

--bind client tunnel interface
ATMbm = {}
Tunnel.bindInterface("ATM_basic_menu",ATMbm)
ATMserver = Tunnel.getInterface("ATM","ATM_basic_menu")
HKserver = Tunnel.getInterface("atm_hotkeys","ATM_basic_menu")
BMserver = Tunnel.getInterface("ATM_basic_menu","ATM_basic_menu")
ATM = Proxy.getInterface("ATM")



function ATMbm.getArmour()
  return GetPedArmour(GetPlayerPed(-1))
end


local clothingID = 4
local index = 0
function ATMbm.setArmour(armour,vest)
  local player = GetPlayerPed(-1)

 -- PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  local n = math.floor(armour)
  SetPedArmour(player,n)

  if vest then
        SetPedComponentVariation(player, 9, clothingID, index, 0) 
  end


end

Citizen.CreateThread(function()
  local player = GetPlayerPed(-1)
  while true do
    Citizen.Wait(1000)

	  if ATMbm.getArmour() == 0 then
	   
	      SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 0)
      
    else

      SetPedComponentVariation(player, 9, clothingID, index, 0) 

    end
  end
end)


RegisterNetEvent('ATM:ChangeArmour')
AddEventHandler('ATM:ChangeArmour', function(id, indexz)
  clothingID = id
  index = indexz
end)

function ATMbm.getHealth()
  return GetEntityHealth(GetPlayerPed(-1))
end

RegisterNetEvent('morphine')
AddEventHandler('morphine', function()
  while true do 
    SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 2)

    if GetEntityHealth(PlayerPedId()) == 200 then 
      notify('~r~The morphine effect has stopped!')
      break; 
    end
    Citizen.Wait(1000)
end
end)

function notify(string)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(string)
  DrawNotification(true, false)
end


function ATMbm.setHealth(armour,vest)
  
  local player = GetPlayerPed(-1)

  local n = math.floor(armour)
  SetEntityHealth(player,n)
end



