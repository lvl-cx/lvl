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
Sentrybm = {}
Tunnel.bindInterface("Sentry_basic_menu",Sentrybm)
Sentryserver = Tunnel.getInterface("Sentry","Sentry_basic_menu")
HKserver = Tunnel.getInterface("sentry_hotkeys","Sentry_basic_menu")
BMserver = Tunnel.getInterface("Sentry_basic_menu","Sentry_basic_menu")
Sentry = Proxy.getInterface("Sentry")



function Sentrybm.getArmour()
  return GetPedArmour(GetPlayerPed(-1))
end



function Sentrybm.setArmour(armour,vest)
  
  local player = GetPlayerPed(-1)
  TaskPlayAnim(player, 'clothingtie', 'try_tie_negative_a', 3.0, 3.0, 2000, true, 0, false, false, false)
 -- PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  local n = math.floor(armour)
  SetPedArmour(player,n)

  if vest then
      if(GetEntityModel(player) == GetHashKey("mp_m_freemode_01")) then
        SetPedComponentVariation(player, 9, 4, 1, 2) 
      elseif (GetEntityModel(player) == GetHashKey("mp_f_freemode_01")) then
        SetPedComponentVariation(player, 9, 6, 1, 2)
      end
    end


end

Citizen.CreateThread(function()
  local player = GetPlayerPed(-1)
  while true do
    Citizen.Wait(1000)

	  if Sentrybm.getArmour() == 0 then
	   
	      SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 1, 2)
    else
      if(GetEntityModel(player) == GetHashKey("mp_m_freemode_01")) then
        SetPedComponentVariation(player, 9, 4, 1, 2) 
      elseif (GetEntityModel(player) == GetHashKey("mp_f_freemode_01")) then
        SetPedComponentVariation(player, 9, 6, 1, 2)
      end
    end
  end
end)

function Sentrybm.getHealth()
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


function Sentrybm.setHealth(armour,vest)
  
  local player = GetPlayerPed(-1)

  local n = math.floor(armour)
  SetEntityHealth(player,n)
end



