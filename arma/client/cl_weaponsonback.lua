local Weapons = {}
  
function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
	   	return tostring(o)
	end
end

Citizen.CreateThread(function()
	while true do

		for i=1, #WeaponsOnBackConfig.RealWeapons, 1 do

			local weaponHash = GetHashKey(WeaponsOnBackConfig.RealWeapons[i].name)

			if HasPedGotWeapon(GetPlayerPed(-1), weaponHash, false) then
				local onPlayer = false

				for k, entity in pairs(Weapons) do
				if entity then
					if entity.weapon == WeaponsOnBackConfig.RealWeapons[i].name then
						onPlayer = true
						break
					end
				end
				end
				
				if not onPlayer and weaponHash ~= GetSelectedPedWeapon(GetPlayerPed(-1)) then
					SetGear(WeaponsOnBackConfig.RealWeapons[i].name)
				elseif onPlayer and weaponHash == GetSelectedPedWeapon(GetPlayerPed(-1)) then
					RemoveGear(WeaponsOnBackConfig.RealWeapons[i].name)
				end
			else
				RemoveGear(WeaponsOnBackConfig.RealWeapons[i].name)
			end
		end
		Wait(250)
	end
end)

 -- Remove only one weapon that's on the ped
function RemoveGear(weapon)
	local _Weapons = {}

	for i, entity in pairs(Weapons) do
		if entity.weapon ~= weapon then
			_Weapons[i] = entity
		else
			DeleteWeapon(entity.obj)
		end
	end

	Weapons = _Weapons
end

 -- Remove all weapons that are on the ped
function RemoveGears()
	for i, entity in pairs(Weapons) do
		DeleteWeapon(entity.obj)
	end
	Weapons = {}
end

function SpawnObject(model, coords, cb)
 
   	local model = (type(model) == 'number' and model or GetHashKey(model))
 
   	Citizen.CreateThread(function()

		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
	
		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, true, true)
	
		if cb ~= nil then
			cb(obj)
		end
   	end)
end
 
function DeleteWeapon(object)
	SetEntityAsMissionEntity(object,  false,  true)
	DeleteObject(object)
end

 -- Add one weapon on the ped
function SetGear(weapon)
	local bone       = nil
	local boneX      = 0.0
	local boneY      = 0.0
	local boneZ      = 0.0
	local boneXRot   = 0.0
	local boneYRot   = 0.0
	local boneZRot   = 0.0
	local playerPed  = GetPlayerPed(-1)
	local model      = nil
	 
	for i=1, #WeaponsOnBackConfig.RealWeapons, 1 do
		if WeaponsOnBackConfig.RealWeapons[i].name == weapon then
			bone     = WeaponsOnBackConfig.RealWeapons[i].bone
			boneX    = WeaponsOnBackConfig.RealWeapons[i].x
			boneY    = WeaponsOnBackConfig.RealWeapons[i].y
			boneZ    = WeaponsOnBackConfig.RealWeapons[i].z
			boneXRot = WeaponsOnBackConfig.RealWeapons[i].xRot
			boneYRot = WeaponsOnBackConfig.RealWeapons[i].yRot
			boneZRot = WeaponsOnBackConfig.RealWeapons[i].zRot
			model    = WeaponsOnBackConfig.RealWeapons[i].model
			break
		end
	end
 
	SpawnObject(model, {x = x, y = y, z = z}, function(obj)
		local playerPed = GetPlayerPed(-1)
		local boneIndex = GetPedBoneIndex(playerPed, bone)
		local bonePos 	= GetWorldPositionOfEntityBone(playerPed, boneIndex)
		AttachEntityToEntity(obj, playerPed, boneIndex, boneX, boneY, boneZ, boneXRot, boneYRot, boneZRot, false, false, false, false, 2, true)
		table.insert(Weapons,{weapon = weapon, obj = obj})
	end)
end
 
 -- Add all the weapons in the Player's loadout
function SetGears()
	local bone       = nil
	local boneX      = 0.0
	local boneY      = 0.0
	local boneZ      = 0.0
	local boneXRot   = 0.0
	local boneYRot   = 0.0
	local boneZRot   = 0.0
	local playerPed  = GetPlayerPed(-1)
	local model      = nil
	local weapon 	 = nil
	
	 
	for j=1, #WeaponsOnBackConfig.RealWeapons, 1 do	 
		bone     = WeaponsOnBackConfig.RealWeapons[j].bone
		boneX    = WeaponsOnBackConfig.RealWeapons[j].x
		boneY    = WeaponsOnBackConfig.RealWeapons[j].y
		boneZ    = WeaponsOnBackConfig.RealWeapons[j].z
		boneXRot = WeaponsOnBackConfig.RealWeapons[j].xRot
		boneYRot = WeaponsOnBackConfig.RealWeapons[j].yRot
		boneZRot = WeaponsOnBackConfig.RealWeapons[j].zRot
		model    = WeaponsOnBackConfig.RealWeapons[j].model
		weapon   = WeaponsOnBackConfig.RealWeapons[j].name 
		break
	end
 
	local _wait = true
 
	SpawnObject(model, {x = x, y = y, z = z}, function(obj)
		 
		local playerPed = GetPlayerPed(-1)
		local boneIndex = GetPedBoneIndex(playerPed, bone)
		local bonePos 	= GetWorldPositionOfEntityBone(playerPed, boneIndex)

		AttachEntityToEntity(obj, playerPed, boneIndex, boneX, boneY, boneZ, boneXRot, boneYRot, boneZRot, false, false, false, false, 2, true)						

		table.insert(Weapons,{weapon = weapon, obj = obj})

		_wait = false
 
	end)
 
	while _wait do
		Wait(0)
	end
end