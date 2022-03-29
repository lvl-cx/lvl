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

local frozen = false
local unfrozen = false
function Sentrybm.loadFreeze(notify,god,ghost)
	if not frozen then
	  if notify then
	    Sentry.notify({"~r~You've been frozen."})
	  end
	  frozen = true
	  invincible = god
	  invisible = ghost
	  unfrozen = false
	else
	  if notify then
	    Sentry.notify({"~g~You've been unfrozen."})
	  end
	  unfrozen = true
	  invincible = false
	  invisible = false
	end
end

function Sentrybm.lockpickVehicle(wait,any)
	Citizen.CreateThread(function()
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
		local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
		if DoesEntityExist(vehicleHandle) then
		  if GetVehicleDoorsLockedForPlayer(vehicleHandle,PlayerId()) or any then
			local prevObj = GetClosestObjectOfType(pos.x, pos.y, pos.z, 10.0, GetHashKey("prop_weld_torch"), false, true, true)
			if(IsEntityAnObject(prevObj)) then
				SetEntityAsMissionEntity(prevObj)
				DeleteObject(prevObj)
			end
			StartVehicleAlarm(vehicleHandle)
			TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
			Citizen.Wait(wait*1000)
			SetVehicleDoorsLocked(vehicleHandle, 1)
			for i = 1,64 do 
				SetVehicleDoorsLockedForPlayer(vehicleHandle, GetPlayerFromServerId(i), false)
			end 
			ClearPedTasksImmediately(GetPlayerPed(-1))
			
			Sentry.notify({"~g~Vehicle unlocked."})
			
			-- ties to the hotkey lock system
			local plate = GetVehicleNumberPlateText(vehicleHandle)
			HKserver.lockSystemUpdate({1, plate})
			HKserver.playSoundWithinDistanceOfEntityForEveryone({vehicleHandle, 10, "unlock", 1.0})
		  else
			Sentry.notify({"~g~Vehicle already unlocked."})
		  end
		else
			Sentry.notify({"~r~Too far away from vehicle."})
		end
	end)
end

function Sentrybm.spawnVehicle(model) 
    -- load vehicle model
    local i = 0
    local mhash = GetHashKey(model)
    while not HasModelLoaded(mhash) and i < 1000 do
	  if math.fmod(i,100) == 0 then
	    Sentry.notify({"~b~Loading vehicle model."})
	  end
      RequestModel(mhash)
      Citizen.Wait(30)
	  i = i + 1
    end

    -- spawn car if model is loaded
    if HasModelLoaded(mhash) then
      local x,y,z = Sentry.getPosition({})
      local nveh = CreateVehicle(mhash, x,y,z+0.5, GetEntityHeading(GetPlayerPed(-1)), true, false) -- added player heading
      SetVehicleOnGroundProperly(nveh)
      SetEntityInvincible(nveh,false)
      SetPedIntoVehicle(GetPlayerPed(-1),nveh,-1) -- put player inside
      Citizen.InvokeNative(0xAD738C3085FE7E11, nveh, true, true) -- set as mission entity
      SetVehicleHasBeenOwnedByPlayer(nveh,true)
      SetModelAsNoLongerNeeded(mhash)
	  Sentry.notify({"~g~Vehicle spawned."})
	else
	  Sentry.notify({"~r~Vehicle model invalid."})
	end
end

function Sentrybm.getArmour()
  return GetPedArmour(GetPlayerPed(-1))
end

function Sentrybm.getVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end

function Sentrybm.getNearestVehicle(radius)
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  local ped = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ped) then
    return GetVehiclePedIsIn(ped, true)
  else
    -- flags used:
    --- 8192: boat
    --- 4096: helicos
    --- 4,2,1: cars (with police)

    local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+5.0001, 0, 8192+4096+4+2+1)  -- boats, helicos
    if not IsEntityAVehicle(veh) then veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+5.0001, 0, 4+2+1) end -- cars
    return veh
  end
end

function Sentrybm.deleteVehicleInFrontOrInside(offset)
  local ped = GetPlayerPed(-1)
  local veh = nil
  if (IsPedSittingInAnyVehicle(ped)) then 
    veh = GetVehiclePedIsIn(ped, false)
  else
    veh = Sentrybm.getVehicleInDirection(GetEntityCoords(ped, 1), GetOffsetFromEntityInWorldCoords(ped, 0.0, offset, 0.0))
  end
  
  if IsEntityAVehicle(veh) then
    SetVehicleHasBeenOwnedByPlayer(veh,false)
    Citizen.InvokeNative(0xAD738C3085FE7E11, veh, false, true) -- set not as mission entity
    SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(veh))
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
    Sentry.notify({"~g~Vehicle deleted."})
  else
    Sentry.notify({"~r~Too far away from vehicle."})
  end
end

function Sentrybm.deleteNearestVehicle(radius)
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  local veh = Sentrybm.getNearestVehicle(radius)
  
  if IsEntityAVehicle(veh) then
    SetVehicleHasBeenOwnedByPlayer(veh,false)
    Citizen.InvokeNative(0xAD738C3085FE7E11, veh, false, true) -- set not as mission entity
    SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(veh))
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
    Sentry.notify({"~g~Vehicle deleted."})
  else
    Sentry.notify({"~r~Too far away from vehicle."})
  end
end

function Sentrybm.setArmour(armour,vest)
  local player = GetPlayerPed(-1)
  local n = math.floor(armour)
  SetPedArmour(player,n)
end

local state_ready = false

AddEventHandler("playerSpawned",function() -- delay state recording
  state_ready = false
  
  Citizen.CreateThread(function()
    Citizen.Wait(30000)
    state_ready = true
  end)
end)

