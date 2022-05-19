 -- Love me plz lemme be dev, plz ill send newds

 WeaponsOnBackConfig = {}
 -- bone = 24818, x = -0.35,    y = -0.10, 	z = 0.13,     xRot = 190.0, yRot = 180.0, zRot = 105.0,
 -- 'bone' use bonetag https://pastebin.com/D7JMnX1g
 -- x,y,z are offsets
 WeaponsOnBackConfig.RealWeapons = {

-- shotgun --
     {name = 'WEAPON_MOSS', 		bone = 24818, x = 0.02,    y = -0.12,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'shotgun', 	model = 'w_sg_moss'},
	 {name = 'WEAPON_ITACHA', 		bone = 24818, x = 0.02,    y = -0.12,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'shotgun', 	model = 'w_sg_itacha'},


-- melees --
	 {name = 'WEAPON_CRUTCH', 			        bone = 24818, x = -0.35,    y = -0.15, 	z = 0.13,     xRot = 190.0, yRot = 180.0, zRot = 105.0, category = 'melee', 	model = 'w_me_crutch'},
	 {name = 'WEAPON_FIREAXE', 			        bone = 24818, x = -0.35,    y = -0.15, 	z = 0.13,     xRot = 190.0, yRot = 180.0, zRot = 105.0, category = 'melee', 	model = 'w_me_fireaxe'},
	 {name = 'WEAPON_SHOVEL', 			        bone = 24818, x = -0.35,    y = -0.15, 	z = 0.13,     xRot = 190.0, yRot = 180.0, zRot = 105.0, category = 'melee', 	model = 'w_me_shovel'},
	 {name = 'WEAPON_SLEDGE', 			        bone = 24818, x = -0.35,    y = -0.15, 	z = 0.13,     xRot = 190.0, yRot = 180.0, zRot = 105.0, category = 'melee', 	model = 'w_me_sledge'},
-- snipers --
	 {name = 'WEAPON_BORA', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_ar_bora'},
-- assault rifle --
	 {name = 'WEAPON_LR300', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_ar_lr300'},
	 {name = 'WEAPON_VANDALG', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_ar_vandalg'},
	 {name = 'WEAPON_ar15', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_ar_ar15'},
	 {name = 'WEAPON_M16A1', 			        bone = 24818, x = -0.12,    y = -0.14,     z = -0.13,     xRot = 100.0, yRot = -3.0, zRot = 5.0, category = 'assault', 	model = 'w_ar_M16A1'},


-- smg --
	 {name = 'WEAPON_MP5A5', 	        bone = 58271, x = -0.01, y = 0.1,  z = -0.07, xRot = -55.0,  yRot = 0.10, zRot = 0.0, category = 'smg', 	model = 'w_sb_mp5a5'},
	 {name = 'WEAPON_MAC11', 	        bone = 58271, x = -0.01, y = 0.1,  z = -0.07, xRot = -55.0,  yRot = 0.10, zRot = 0.0, category = 'smg', 	model = 'w_sb_mac11'},
	 {name = 'WEAPON_PPSH', 	        bone = 58271, x = -0.01, y = 0.1,  z = -0.07, xRot = -55.0,  yRot = 0.10, zRot = 0.0, category = 'smg', 	model = 'w_sb_ppsh'},
	 {name = 'WEAPON_UMP45', 	        bone = 58271, x = -0.01, y = 0.1,  z = -0.07, xRot = -55.0,  yRot = 0.10, zRot = 0.0, category = 'smg', 	model = 'w_sb_ump45'},


-- Police Weapons Front --
	 {name = 'WEAPON_M4A1', 			bone = 24818, x = -0.04,    y = 0.25,     z = 0.05,     xRot = -2.0, yRot = 324.50, zRot = 185.75, category = 'assault',     model = 'w_ar_genericm4a1'},
	 {name = 'WEAPON_SPAR17', 			bone = 24818, x = -0.04,    y = 0.25,     z = 0.05,     xRot = -2.0, yRot = 324.50, zRot = 185.75, category = 'assault',     model = 'w_ar_spar17'},
	 {name = 'WEAPON_MCX', 			bone = 24818, x = -0.04,    y = 0.25,     z = 0.05,     xRot = -2.0, yRot = 324.50, zRot = 185.75, category = 'assault',     model = 'w_ar_mcx'},

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