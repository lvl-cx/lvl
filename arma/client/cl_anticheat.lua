DecorRegister("ARMAACVeh", 3)

local function c(d, ...)
    for e, f in pairs(GetGamePool("CVehicle")) do
        d(f, ...)
        Wait(0)
    end
end
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		--if tARMA.isPlayerInBankHeistSetup and not tARMA.isPlayerInBankHeistSetup() then
			c(function(f)
				if DecorGetInt(f, "ARMAACVeh") ~= 955 then
					if NetworkHasControlOfEntity(f) then
						local g = GetEntityModel(f)
						if not IsThisModelATrain(g) then
							DeleteEntity(f)
						end
					end
				end
			end)
		--end
	end
end)

Citizen.CreateThread(function() 
    Wait(1000)
    local oldPos = GetEntityCoords(PlayerPedId())
    while true do
        local playerPed = PlayerPedId()
        local newPos = GetEntityCoords(playerPed)

        local dist = #(oldPos-newPos)
        oldPos = newPos
        if dist > 6 and not IsPedFalling(playerPed) and not IsPedInParachuteFreeFall(playerPed) and not IsPedRagdoll(playerPed) and not tARMA.isPlayerHidingInBoot() and not tARMA.isBeingDragged() then
            if not IsPedInAnyVehicle(playerPed, 1) then
                speedWarnings = speedWarnings + 1
                if speedWarnings > 18 then
                    TriggerServerEvent("ARMA:acType1")
					Wait(30000)
                    speedWarnings = 0
                end
            end
        end
        Wait(100)
    end
end)

AddEventHandler("playerSpawned", function()
    speedWarnings = 0
end)


Citizen.CreateThread(function()
    while true do
        speedWarnings = 0
        Wait(30000)
    end
end)
-- No-Clip

WeaponBL={
	"WEAPON_BAT",
	"WEAPON_MACHETE",
	--"WEAPON_SWITCHBLADE",
	"WEAPON_POOLCUE",
	"WEAPON_DAGGER",
	"WEAPON_CROWBAR",
	"WEAPON_KNIFE",
	"WEAPON_KNUCKLE", 
	"WEAPON_HAMMER", 
	"WEAPON_GOLFCLUB",
	"WEAPON_BOTTLE", 
	"WEAPON_HATCHET", 
	"WEAPON_PROXMINE", 
	"WEAPON_BZGAS", 
	--"WEAPON_SMOKEGRENADE", 
	"WEAPON_MOLOTOV", 
	"WEAPON_FIREEXTINGUISHER", 
	"WEAPON_HAZARDCAN", 
	--"WEAPON_SNOWBALL", 
	--"WEAPON_FLARE", 
	"WEAPON_BALL", 
	"WEAPON_REVOLVER", 
	"WEAPON_PIPEWRENCH",
	"WEAPON_PISTOL", 
	"WEAPON_PISTOL_MK2", 
	"WEAPON_COMBATPISTOL", 
	"WEAPON_APPISTOL",  
	"WEAPON_SNSPISTOL", 
	"WEAPON_HEAVYPISTOL", 
	"WEAPON_VINTAGEPISTOL", 
	--"WEAPON_FLAREGUN",
	"WEAPON_MARKSMANPISTOL", 
	"WEAPON_MICROSMG", 
	"WEAPON_MINISMG", 
	"WEAPON_SMG",
	"WEAPON_SMG_MK2", 
	"WEAPON_ASSAULTSMG", 
	"WEAPON_MG",
	"WEAPON_COMBATMG",
	"WEAPON_COMBATMG_MK2",
	"WEAPON_COMBATPDW",
	"WEAPON_GUSENBERG", 
	"WEAPON_MACHINEPISTOL",
	"WEAPON_ASSAULTRIFLE", 
	"WEAPON_ASSAULTRIFLE_MK2", 
	"WEAPON_CARBINERIFLE", 
	"WEAPON_CARBINERIFLE_MK2", 
	"WEAPON_ADVANCEDRIFLE", 
	"WEAPON_SPECIALCARBINE",
	"WEAPON_BULLPUPRIFLE", 
	"WEAPON_COMPACTRIFLE",
	"WEAPON_PUMPSHOTGUN", 
	"WEAPON_SWEEPERSHOTGUN",
	"WEAPON_SAWNOFFSHOTGUN", 
	"WEAPON_BULLPUPSHOTGUN", 
	"WEAPON_ASSAULTSHOTGUN",  
	"WEAPON_HEAVYSHOTGUN", 
	"WEAPON_DBSHOTGUN", 
	"WEAPON_SNIPERRIFLE", 
	"WEAPON_HEAVYSNIPER", 
	"WEAPON_HEAVYSNIPER_MK2", 
	"WEAPON_MARKSMANRIFLE", 
	"WEAPON_GRENADELAUNCHER", 
	"WEAPON_GRENADELAUNCHER_SMOKE", 
	"WEAPON_RPG", 
	"WEAPON_MINIGUN", 
	"WEAPON_FIREWORK", 
	"WEAPON_RAILGUN", 
	"WEAPON_HOMINGLAUNCHER", 
	"WEAPON_GRENADE", 
	"WEAPON_STICKYBOMB", 
	"WEAPON_COMPACTLAUNCHER", 
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_REVOLVER_MK2", 
	"WEAPON_DOUBLEACTION",
	"WEAPON_SPECIALCARBINE_MK2", 
	"WEAPON_BULLPUPRIFLE_MK2",
	"WEAPON_PUMPSHOTGUN_MK2",
	"WEAPON_MARKSMANRIFLE_MK2", 
	"WEAPON_RAYPISTOL", 
	"WEAPON_RAYCARBINE", 
	"WEAPON_RAYMINIGUN",
	"WEAPON_DIGISCANNER", 
	"WEAPON_NAVYREVOLVER", 
	"WEAPON_CERAMICPISTOL", 
	"WEAPON_STONE_HATCHET",
	"WEAPON_PIPEBOMB", 
	"WEAPON_PASSENGER_ROCKET",
	"WEAPON_MUSKET"
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		for _,theWeapon in ipairs(WeaponBL) do
			Wait(1)
			if HasPedGotWeapon(PlayerPedId(),GetHashKey(theWeapon),false) == 1 then
				RemoveAllPedWeapons(PlayerPedId(),false)
				TriggerServerEvent("ARMA:acType2", theWeapon)
				Wait(30000)
			end
		end
	end
end)

Citizen.CreateThread(function()
	Wait(10000)
	local _ = 0
	while true do
		if _ >= 100 and not tARMA.isInComa() then
			TriggerServerEvent("ARMA:acType6")
			Wait(30000)
		end
		if not tARMA.isStaffedOn() then
			local j = PlayerId()
			local i = PlayerPedId()
			local a0 = GetEntityHealth(i)
			SetPlayerHealthRechargeMultiplier(j, 0.0)
			if i ~= 0 then
				SetEntityHealth(i, a0 - 2)
				Citizen.Wait(50)
				if GetEntityHealth(i) > a0 - 2 then
					_ = _ + 1
				elseif _ > 0 then
					_ = _ - 1
				end
				SetEntityHealth(i, GetEntityHealth(i) + 2)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000)
		local DetectableTextures = {
			{txd = "HydroMenu", txt = "HydroMenuHeader", name = "HydroMenu"},
			{txd = "John", txt = "John2", name = "SugarMenu"},
			{txd = "darkside", txt = "logo", name = "Darkside"},
			{txd = "ISMMENU", txt = "ISMMENUHeader", name = "ISMMENU"},
			{txd = "dopatest", txt = "duiTex", name = "Copypaste Menu"},
			{txd = "fm", txt = "menu_bg", name = "Fallout"},
			{txd = "wave", txt = "logo", name ="Wave"},
			{txd = "wave1", txt = "logo1", name = "Wave (alt.)"},
			{txd = "meow2", txt = "woof2", name ="Alokas66", x = 1000, y = 1000},
			{txd = "adb831a7fdd83d_Guest_d1e2a309ce7591dff86", txt = "adb831a7fdd83d_Guest_d1e2a309ce7591dff8Header6", name ="Guest Menu"},
			{txd = "hugev_gif_DSGUHSDGISDG", txt = "duiTex_DSIOGJSDG", name="HugeV Menu"},
			{txd = "MM", txt = "menu_bg", name="MetrixFallout"},
			{txd = "wm", txt = "wm2", name="WM Menu"}
		}
		for i, data in pairs(DetectableTextures) do
			if data.x and data.y then
				if GetTextureResolution(data.txd, data.txt).x == data.x and GetTextureResolution(data.txd, data.txt).y == data.y then
					TriggerServerEvent("ARMA:acType7", data.name..' Menu')
					Wait(30000)
				end
			else 
				if GetTextureResolution(data.txd, data.txt).x ~= 4.0 then
					TriggerServerEvent("ARMA:acType7", data.name..' Menu')
					Wait(30000)
				end
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local i = PlayerId()
		local j = GetVehiclePedIsIn(i)
		local y = GetPlayerWeaponDamageModifier(i)
		local z = GetPlayerWeaponDefenseModifier(i)
		local A = GetPlayerWeaponDefenseModifier_2(i)
		local B = GetPlayerVehicleDamageModifier(i)
		local C = GetPlayerVehicleDefenseModifier(i)
		local D = GetPlayerMeleeWeaponDefenseModifier(i)
		if j ~= 0 then
			local E = GetVehicleTopSpeedModifier(j)
			if E > 1.0 then
				TriggerServerEvent("ARMA:acType8", "GetVehicleTopSpeedModifier "..D)
			end
		end
		local F = GetWeaponDamageModifier(GetCurrentPedWeapon(i))
		local G = GetPlayerMeleeWeaponDamageModifier()
		if y > 1.0 then
			TriggerServerEvent("ARMA:acType8", "PlayerWeaponDamageModifier "..y)
			Wait(30000)
		end
		if z > 1.0 then
			TriggerServerEvent("ARMA:acType8", "PlayerWeaponDefenseModifier "..z)
			Wait(30000)
		end
		if A > 1.0 then
			TriggerServerEvent("ARMA:acType8", "PlayerWeaponDefenseModifier_2 "..A)
			Wait(30000)
		end
		if B > 1.0 then
			TriggerServerEvent("ARMA:acType8", "PlayerVehicleDamageModifier "..B)
			Wait(30000)
		end
		if C > 1.0 then
			TriggerServerEvent("ARMA:acType8", "PlayerVehicleDefenseModifier "..C)
			Wait(30000)
		end
		if F > 1.0 then
			TriggerServerEvent("ARMA:acType8", "GetWeaponDamageModifier "..D)
			Wait(30000)
		end
		if G > 1.0 then
			TriggerServerEvent("ARMA:acType8", "GetPlayerMeleeWeaponDamageModifier "..D)
			Wait(30000)
		end
		RemoveAllPickupsOfType("PICKUP_HEALTH_SNACK")
		RemoveAllPickupsOfType("PICKUP_HEALTH_STANDARD")
	end
end)

local X = {["WEAPON_UNARMED"] = true, ["WEAPON_PETROLCAN"] = true, ["WEAPON_SNOWBALL"] = true}
CreateThread(function()
	while true do
		local h = tARMA.getPlayerPed()
		local k = GetSelectedPedWeapon(h)
		for a,b in pairs(X) do
			if GetHashKey(a) == k then
				return
			end
		end
		if IsPedShooting(h) then
			local Y, Z = GetAmmoInClip(h, k)
			if Z == GetMaxAmmoInClip(h, k) then
				TriggerServerEvent("ARMA:acType8", "Infinite Ammo")
				Wait(60000)
			end
		end
		Wait(0)
	end
end)


local b = {
    "demonhawkk",
    "priors63przemo",
}

Citizen.CreateThread(function()
	while true do
		local f = tARMA.getPlayerVehicle()
		local c = {}
		for k,v in pairs(b) do
			table.insert(c, GetHashKey(v))
		end
		if GetVehicleHasParachute(f) then
			local be = GetEntityModel(f)
			if not table.has(c, be) then
				TriggerServerEvent("ARMA:acType12", globalVehicleModelHashMapping[be])
			end
		end
		Wait(1000)
	end
end)

local h = false
Citizen.CreateThread(function()
	Wait(15000)
	while true do
		local i = tARMA.getPlayerPed()
		local j = tARMA.getPlayerId()
		local k = tARMA.getPlayerVehicle()
		if k == 0 then
			SetWeaponDamageModifier(GetHashKey("WEAPON_RUN_OVER_BY_CAR"), 0.0)
			SetWeaponDamageModifier(GetHashKey("WEAPON_RAMMED_BY_CAR"), 0.0)
			SetWeaponDamageModifier(GetHashKey("VEHICLE_WEAPON_ROTORS"), 0.0)
			SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 0.5)
			SetWeaponDamageModifier(GetHashKey("WEAPON_SNOWBALL"), 0.0)
			local l = GetSelectedPedWeapon(i)
			if l == GetHashKey("WEAPON_SNOWBALL") then
				SetPlayerWeaponDamageModifier(j, 0.0)
			else
				SetPlayerWeaponDamageModifier(j, 1.0)
				SetWeaponDamageModifier(l, 1.0)
			end
			-- if not h and GetUsingseethrough() and not tARMA.isPlayerInPoliceHeli() and not tARMA.isPlayerInDrone() and not tARMA.isPlayerUsingRobot() and not tARMA.isUsingPoliceRobot() then
			-- 	TriggerServerEvent("ARMA:acType13")
			-- 	h = true
			-- end
		end
		SetPedInfiniteAmmoClip(i, false)
		SetEntityInvincible(k, false)
		ToggleUsePickupsForPlayer(j, "PICKUP_HEALTH_SNACK", false)
		ToggleUsePickupsForPlayer(j, "PICKUP_HEALTH_STANDARD", false)
		ToggleUsePickupsForPlayer(j, "PICKUP_WEAPON_PISTOL", false)
		ToggleUsePickupsForPlayer(j, "PICKUP_AMMO_BULLET_MP", false)
		SetPlayerHealthRechargeMultiplier(j, 0.0)
		Wait(0)
	end
end)

Citizen.CreateThread(function()
	Wait(60000)
	local min,max = GetModelDimensions(GetEntityModel(PlayerPedId()))
	if min.y < -0.29 or max.z > 0.98 then
		TriggerServerEvent("ARMA:acType14")
	end
end)

Citizen.CreateThread(function()
	Wait(10000)
	while true do
		if GetPlayerInvincible(PlayerId()) and not isInGreenzone and not tARMA.isInsideLsCustoms() and not tARMA.isStaffedOn() and not noclipActive then
			TriggerServerEvent("ARMA:acType15")
			Citizen.Wait(60000)
		end
		Citizen.Wait(1000)
	end
end)

print('[ARMA] - Anti-Cheat initialised (Credits: c)')