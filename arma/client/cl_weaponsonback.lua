local a = {}
local Weapons = {}
a.weapons = {     --?Melee's
    -- {name = 'WEAPON_BROOM', bone = 24818, offset = vector3(-0.60, -0.15, 0.13), rotation = vector3(50.0, 90.0, 2.0), model = `w_me_broom`},
    -- {name = 'WEAPON_SLEDGEHAMMER', bone = 24818, offset = vector3(-0.35, -0.10, 0.13), rotation = vector3(190.0, 180.0, 105.0), model = `w_me_sledgehammer`},
    -- {name = 'WEAPON_TRAFFICSIGN', bone = 24818, offset = vector3(-0.45, -0.10, 0.13), rotation = vector3(190.0, 180.0, 105.0), model = `w_me_trafficsign`},
    -- {name = 'WEAPON_SHOVEL', bone = 24818, offset = vector3(0.32, -0.10, 0.10), rotation = vector3(5.0, 200.0, 80.0), model = `w_me_shovel`},
    -- [`WEAPON_GUITAR`] = {bone = 24818, offset = vector3(0.32, -0.15, 0.13), rotation = vector3(0.0, -90.0, 0.0), model = `w_me_guitar`},
    -- [`WEAPON_DILDO`] = {bone = 58271, offset = vector3(-0.01, 0.1, -0.07), rotation = vector3(-35.0, 0.10, -100.0), model = `w_me_dildo`},
    -- [`WEAPON_CRICKETBAT`] = {bone = 24818, offset = vector3(0.32, -0.15, 0.13), rotation = vector3(55.0, -90.0, 0.0), model = `w_me_cricketbat`},
    -- [`WEAPON_FIREAXE`] = {bone = 24818, offset = vector3(0.32, -0.15, 0.13), rotation = vector3(0.0, -90.0, 0.0), model = `w_me_fireaxe`},

    -- --?PD SMGs/Rifles
    -- [`WEAPON_PDM4A1`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_m4a1`},
    -- [`WEAPON_AR15`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_ar15`},
    -- [`WEAPON_MP5`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_sb_mp5`},
    -- [`WEAPON_SIGMCX`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_sigmcx`},
    -- [`WEAPON_G36`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_g36`},
    {name = 'WEAPON_SPAR17', bone = 24818, x=0.00,y=0.19,z=0.0, xRot=180.0,yRot=148.0, zRot=0.0, category = 'assault', model = `w_ar_spar17`},
    -- [`WEAPON_STING`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_sb_sting`},
    -- [`WEAPON_MK18SOG`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_mk18sog`},
    -- [`WEAPON_PDTX15`] = {bone = 24818, offset = vector3(0.0, 0.22, 0.0), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_tx15dml`},
    -- [`WEAPON_NIGHTSTICK`] = {bone = 51826, offset = vector3(-0.1, 0.1, 0.07), rotation = vector3(180.0, 140.0, 90.0), model = `w_me_nightstick`},

    -- --?CIV SMGs/Rifles/Shotguns
    -- [`WEAPON_EF88`] = {bone = 24818, offset = vector3(0.05, -0.12, -0.13), rotation = vector3(100.0, -3.0, 5.0), model = `w_ar_ef88`},
    -- [`WEAPON_SPAR16`] = {bone = 24818, offset = vector3(-0.02, -0.12, -0.13), rotation = vector3(100.0, -3.0, 5.0), model = `w_ar_spar16`},
    -- [`WEAPON_SPAZ12`] = {bone = 24818, offset = vector3(0.1, -0.12, -0.13), rotation = vector3(100.0, -3.0, 5.0), model = `w_ar_spaz12`},
    -- [`WEAPON_RPK16`] = {bone = 24818, offset = vector3(-0.05, -0.12, -0.13), rotation = vector3(100.0, -3.0, 5.0), model = `w_mg_rpk16`},

    -- --?Mosin/spec snipers
    -- [`WEAPON_MOSIN`] = {bone = 24818, offset = vector3(-0.12, -0.12, -0.13), rotation = vector3(100.0, -3.0, 5.0), model = `w_ar_mosin`},
    -- [`WEAPON_MANDO`] = {bone = 24818, offset = vector3(0.3, 0.22, -0.2), rotation = vector3(180.0, 148.0, 0.0), model = `w_ar_mando`},
    -- [`WEAPON_DILDET`] = {bone = 24818, offset = vector3(-0.35, -0.12, -0.13), rotation = vector3(100.0, 100.0, 5.0), model = `w_ar_dildet`}
}

local b=module("cfg/weapons")
Citizen.CreateThread(function()
    for c,d in pairs(b.weapons)do 
        for i=1, #a.weapons, 1 do
            if not a.weapons[i].name == d.hash then 
                if d.class=="SMG"then 
                    table.insert(a.weapons, {bone=58271,x=-0.01,y=0.1,z=-0.07,xRot=-55.0,yRot=0.10, zRot=0.0,category ='smg',model=GetHashKey(d.model)})
                elseif d.class=="AR"or d.class=="Heavy" or d.class=="LMG"then 
                    table.insert(a.weapons, {bone=24818,x=-0.12,y=-0.12,z=-0.13,xRot=100.0,yRot=-3.0,zRot=5.0,category='assault',model=GetHashKey(d.model)})
                elseif d.class=="Melee"then 
                    table.insert(a.weapons, {bone=24818,x=0.32,y=-0.15,z=0.13,xRot=0.0,yRot=-90.0,zRot=0.0,category='melee',model=GetHashKey(d.model)})
                elseif d.class=="Shotgun"then 
                    table.insert(a.weapons, {bone=24818,x=-0.12,y=-0.12,z=-0.13,xRot=100.0,yRot=-3.0,zRot=5.0,category='shotgun',model=GetHashKey(d.model)})
                end 
            end 
		end
		Wait(250)
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

			if HasPedGotWeapon(GetPlayerPed(-1), weaponHash, false) then
				local onPlayer = false

				for k, entity in pairs(Weapons) do
				if entity then
					if entity.weapon == a.weapons[i].name then
						onPlayer = true
						break
					end
				end
				end
				
				if not onPlayer and weaponHash ~= GetSelectedPedWeapon(GetPlayerPed(-1)) then
					SetGear(a.weapons[i].name)
				elseif onPlayer and weaponHash == GetSelectedPedWeapon(GetPlayerPed(-1)) then
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
	 
	for i=1, #a.weapons, 1 do
		if a.weapons[i].name == weapon then
			bone     = a.weapons[i].bone
			boneX    = a.weapons[i].x
			boneY    = a.weapons[i].y
			boneZ    = a.weapons[i].z
			boneXRot = a.weapons[i].xRot
			boneYRot = a.weapons[i].yRot
			boneZRot = a.weapons[i].zRot
			model    = a.weapons[i].model
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
	
	 
	for j=1, #a.weapons, 1 do	 
		bone     = a.weapons[j].bone
		boneX    = a.weapons[j].x
		boneY    = a.weapons[j].y
		boneZ    = a.weapons[j].z
		boneXRot = a.weapons[j].xRot
		boneYRot = a.weapons[j].yRot
		boneZRot = a.weapons[j].zRot
		model    = a.weapons[j].model
		weapon   = a.weapons[j].name 
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