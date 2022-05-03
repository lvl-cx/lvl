 -- Love me plz lemme be dev, plz ill send newds

 WeaponsOnBackConfig = {}
 -- bone = 24818, x = -0.35,    y = -0.10, 	z = 0.13,     xRot = 190.0, yRot = 180.0, zRot = 105.0,
 -- 'bone' use bonetag https://pastebin.com/D7JMnX1g
 -- x,y,z are offsets
 WeaponsOnBackConfig.RealWeapons = {

     {name = 'WEAPON_REMINGTON870', 		bone = 24818, x = 0.02,    y = -0.12,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'shotgun', 	model = 'w_sg_remington870'}, -- ME
	 {name = 'WEAPON_WINCHESTER12', 			    bone = 24818, x = -0.22,    y = -0.15,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'shotgun', 	model = 'w_sg_winchester12'}, -- ME
	 {name = 'WEAPON_DEADPOOLSHOTTY', 			    bone = 24818, x = -0.22,    y = -0.15,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'shotgun', 	model = 'w_sg_deadpoolshotgun'}, -- ME
	 {name = 'WEAPON_VECTOR', 		        bone = 24818, x = 0.05,    y = -0.12,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'shotgun', 	model = 'w_sb_vector'}, -- ME
	 {name = 'WEAPON_MP5X', 		        bone = 24818, x = 0.05,    y = -0.12,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'shotgun', 	model = 'w_sb_mp5x'}, -- ME
	 {name = 'WEAPON_AKKAL', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_ar_akkal'}, -- ME
	 {name = 'WEAPON_GALIL', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_ar_galil'}, -- ME
	 {name = 'WEAPON_R5', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_ar_r5'}, -- ME
	 {name = 'WEAPON_AR18', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_ar_AR18'}, -- ME
	 {name = 'WEAPON_GUNGNIR', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_sr_GUNGNIR'}, -- ME
	 {name = 'WEAPON_AN94', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_ar_AN94'}, -- ME
	 {name = 'WEAPON_SPAR16', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_sr_SPAR16'}, -- ME
	 {name = 'WEAPON_G36', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_sr_G36'}, -- ME
	 {name = 'WEAPON_SIGMCX', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_ar_sigmcx'}, -- ME
	 {name = 'WEAPON_SCARL', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_ar_scarl'}, -- ME
	 {name = 'WEAPON_MOSIN', 				bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_ar_mosin'}, -- ME

 }
 
 
 -- Love me plz, gimme dev and ill send newds
 -- This is dank, just need to find a way to get a model for attachments :D JUST PUSH DIS ITS FINE!
 local Weapons = {}
 
 RegisterCommand("debugwep", function()
	 print(dump(Weapons))
 end,false)
 
 
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
 
 
 -----------------------------------------------------------
 -----------------------------------------------------------
 Citizen.CreateThread(function()
	 while true do
		 local playerPed = GetPlayerPed(-1)
 
		 for i=1, #WeaponsOnBackConfig.RealWeapons, 1 do
 
			 local weaponHash = GetHashKey(WeaponsOnBackConfig.RealWeapons[i].name)
 
			 if HasPedGotWeapon(playerPed, weaponHash, false) then
				 local onPlayer = false
 
				 for k, entity in pairs(Weapons) do
				   if entity then
					   if entity.weapon == WeaponsOnBackConfig.RealWeapons[i].name then
						   onPlayer = true
						   break
					   end
				   end
				   end
				   
				   if not onPlayer and weaponHash ~= GetSelectedPedWeapon(playerPed) then
					   SetGear(WeaponsOnBackConfig.RealWeapons[i].name)
				   elseif onPlayer and weaponHash == GetSelectedPedWeapon(playerPed) then
					   RemoveGear(WeaponsOnBackConfig.RealWeapons[i].name)
				   end
			 else
				 RemoveGear(WeaponsOnBackConfig.RealWeapons[i].name)
			 end
		   end
		 Wait(500)
	 end
 end)
 -----------------------------------------------------------
 -----------------------------------------------------------
 RegisterNetEvent('removeWeapon')
 AddEventHandler('removeWeapon', function(weaponName)
	 RemoveGear(weaponName)
 end)
 RegisterNetEvent('removeWeapons')
 AddEventHandler('removeWeapons', function()
	 RemoveGears()
 end)
 -----------------------------------------------------------
 -----------------------------------------------------------
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
 -----------------------------------------------------------
 -----------------------------------------------------------
 -- Remove all weapons that are on the ped
 function RemoveGears()
	 for i, entity in pairs(Weapons) do
		 DeleteWeapon(entity.obj)
	 end
	 Weapons = {}
 end
 -----------------------------------------------------------
 -----------------------------------------------------------
 function SpawnObject(model, coords, cb)
 
   local model = (type(model) == 'number' and model or GetHashKey(model))
 
   Citizen.CreateThread(function()
 
	 RequestModel(model)
 
	 while not HasModelLoaded(model) do
	   Citizen.Wait(0)
	 end
 
	 local obj = CreateObject(model, coords.x, coords.y, coords.z, true, true, true)
	 DecorSetInt(obj,"ACVeh",955)
 
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
	 local playerWeapons = getWeapons()
		 
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
 
	 SpawnObject(model, {
		 x = x,
		 y = y,
		 z = z
	 }, function(obj)
		 local playerPed = GetPlayerPed(-1)
		 local boneIndex = GetPedBoneIndex(playerPed, bone)
		 local bonePos 	= GetWorldPositionOfEntityBone(playerPed, boneIndex)
		 AttachEntityToEntity(obj, playerPed, boneIndex, boneX, boneY, boneZ, boneXRot, boneYRot, boneZRot, false, false, false, false, 2, true)
		 table.insert(Weapons,{weapon = weapon, obj = obj})
	 end)
 end
 
 local weapon_types = {
	"WEAPON_GALIL",
	"WEAPON_SCARL",
	"WEAPON_MOSIN",
	"WEAPON_AKKAL",
	"WEAPON_VECTOR",
	"WEAPON_WINCHESTER12",
	
	"WEAPON_R5",
	"WEAPON_GUNGNIR",
	"WEAPON_DEADPOOLSHOTTY",
	"WEAPON_AR18",
	"WEAPON_AN94",
	
	"WEAPON_SPAR16",
	"WEAPON_MP5X",
	"WEAPON_G36",
	"WEAPON_REMINGTON870",
	"WEAPON_SIGMCX",
 }
 
 function getWeapons()
   local player = GetPlayerPed(-1)
 
   local ammo_types = {} -- rem ammo type to not duplicate ammo amount
 
   local weapons = {}
   for k,v in pairs(weapon_types) do
	 local hash = GetHashKey(v)
	 if HasPedGotWeapon(player,hash) then
	   local weapon = {}
	   weapons[v] = weapon
 
	   local atype = Citizen.InvokeNative(0x7FEAD38B326B9F74, player, hash)
	   if ammo_types[atype] == nil then
		 ammo_types[atype] = true
		 weapon.ammo = GetAmmoInPedWeapon(player,hash)
	   else
		 weapon.ammo = 0
	   end
	 end
   end
 
   return weapons
 end
 
 
 -----------------------------------------------------------
 -----------------------------------------------------------
 -- Add all the weapons in the xPlayer's loadout
 -- on the ped
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
	 local playerWeapons = getWeapons()
	 local weapon 	 = nil
	 
	 for k,v in pairs(playerWeapons) do
		 
		 for j=1, #WeaponsOnBackConfig.RealWeapons, 1 do
			 if WeaponsOnBackConfig.RealWeapons[j].name == k then
				 
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
		 end
 
		 local _wait = true
 
		 SpawnObject(model, {
			 x = x,
			 y = y,
			 z = z
		 }, function(obj)
			 
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
 
 end