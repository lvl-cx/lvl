local Weapons = {}
local diagonalWeapons = false
local a=module("cfg/cfg_weaponsonback")
local b=module("cfg/weapons")
Citizen.CreateThread(function()
    for c,d in pairs(b.weapons)do 
		if not a.weapons[d.hash] then
			if d.class=="SMG"then 
				table.insert(a.weapons, {name=c,bone=58271,x=-0.01,y=0.1,z=-0.07,xRot=-55.0,yRot=0.10, zRot=0.0,category ='smg',class=d.class,model=GetHashKey(d.model)})
			elseif d.class=="AR"or d.class=="Heavy" or d.class=="LMG"then 
				table.insert(a.weapons, {name=c,bone=24818,x=-0.12,y=-0.12,z=-0.13,xRot=100.0,yRot=-3.0,zRot=5.0,category='assault',class=d.class,model=GetHashKey(d.model)})
			elseif d.class=="Melee"then 
				table.insert(a.weapons, {name=c,bone=24818,x=0.32,y=-0.15,z=0.13,xRot=0.0,yRot=-90.0,zRot=0.0,category='melee',class=d.class,model=GetHashKey(d.model)})
			elseif d.class=="Shotgun"then 
				table.insert(a.weapons, {name=c,bone=24818,x=-0.12,y=-0.12,z=-0.13,xRot=100.0,yRot=-3.0,zRot=5.0,category='shotgun',class=d.class,model=GetHashKey(d.model)})
			end 
		end
	end
end)
  
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
		for i=1, #a.weapons, 1 do
			local weaponHash = GetHashKey(a.weapons[i].name)
			if HasPedGotWeapon(PlayerPedId(), weaponHash, false) then
				local onPlayer = false
				for k, entity in pairs(Weapons) do
					if entity then
						if entity.weapon == a.weapons[i].name then
							onPlayer = true
							break
						end
					end
				end
				local policeInVehicleWithSniper = globalOnPoliceDuty and tARMA.getPlayerVehicle() ~= 0 and a.weapons[i].class == 'Heavy'
				if not onPlayer and weaponHash ~= GetSelectedPedWeapon(PlayerPedId()) and not isInGreenzone and not policeInVehicleWithSniper then
					SetGear(a.weapons[i].name)
				elseif (onPlayer and weaponHash == GetSelectedPedWeapon(PlayerPedId())) or isInGreenzone or policeInVehicleWithSniper then
					RemoveGear(a.weapons[i].name)
				end
			else
				RemoveGear(a.weapons[i].name)
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
	local playerPed  = PlayerPedId()
	local model      = nil
	 
	for i=1, #a.weapons, 1 do
		if a.weapons[i].name == weapon then
			if diagonalWeapons and vector3(a.weapons[i].x, a.weapons[i].y, a.weapons[i].z) == vector3(-0.12, -0.12, -0.13) then
				boneX = 0.0
				boneY = -0.2
				boneZ = 0.0
				boneXRot = 0.0
				boneYRot = 45.0
			else
				boneX    = a.weapons[i].x
				boneY    = a.weapons[i].y
				boneZ    = a.weapons[i].z
				boneXRot = a.weapons[i].xRot
				boneYRot = a.weapons[i].yRot
			end
			bone     = a.weapons[i].bone
			boneZRot = a.weapons[i].zRot
			model    = a.weapons[i].model
			break
		end
	end
 
	SpawnObject(model, {x = x, y = y, z = z}, function(obj)
		local playerPed = PlayerPedId()
		local boneIndex = GetPedBoneIndex(playerPed, bone)
		local bonePos 	= GetWorldPositionOfEntityBone(playerPed, boneIndex)
		AttachEntityToEntity(obj, playerPed, boneIndex, boneX, boneY, boneZ, boneXRot, boneYRot, boneZRot, false, false, false, false, 2, true)
		table.insert(Weapons,{weapon = weapon, obj = obj})
	end)
end

RegisterNetEvent("ARMA:setDiagonalWeapons",function(a)
	diagonalWeapons = a
end)
