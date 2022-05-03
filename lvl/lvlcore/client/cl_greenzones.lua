local blips = {
	{title="[Sandy Hospital]", colour=2, id=1, pos=vector3(1832.4654541016,3678.6604003906,42.009292602539),dist=35,nonRP=false,setBit=false}, -- [Sandy Hospital]
    {title="[St Thomas]", colour=2, id=1, pos=vector3(333.91488647461,-597.16156005859,29.292747497559),dist=40,nonRP=false,setBit=false}, -- [St Thomas]
    {title="[Paleto Hospital]", colour=2, id=1, pos=vector3(-254.16650390625,6324.3740234375,39.203189849854),dist=30,nonRP=false,setBit=false}, -- [Paleto Hospital]
	{title="[License Centre]", colour=2, id=1, pos=vector3(-927.42938232422,-2041.2468261719,13.946600914001),dist=60,nonRP=false,setBit=false}, -- [License Centre]
	{title="[VIP Island]", colour=2, id=1, pos=vector3(-2170.4770507812,5179.0668945312,15.63862323761),dist=100,nonRP=false,setBit=false}, -- [VIP Island]
	{title="[Legion]", colour=2, id=1, pos=vector3(170.51364135742,-1021.3690795898,28.816247940063),dist=50,nonRP=false,setBit=false}, -- [Legion]
	{title="[Admin Island]", colour=2, id=1, pos=vector3(3492.4116210938,2579.2509765625,13.129757881165),dist=200,nonRP=false,setBit=false}, -- [Admin Island]
	{title="[Casino]", colour=2, id=1, pos=vector3(1134.6573486328,251.09861755371,-51.035732269287),dist=100,nonRP=false,setBit=false}, -- [Casino]
}
     
local PaletoHospital = AddBlipForRadius(-254.16650390625,6324.3740234375,39.203189849854, 30.0)
SetBlipColour(PaletoHospital, 2)
SetBlipAlpha(PaletoHospital, 150)

local CityHospital = AddBlipForRadius(333.91488647461,-597.16156005859,29.292747497559, 40.0)
SetBlipColour(CityHospital, 2)
SetBlipAlpha(CityHospital, 150)

local SandyHospital = AddBlipForRadius(1832.4654541016,3678.6604003906,42.009292602539, 35.0)
SetBlipColour(SandyHospital, 2)
SetBlipAlpha(SandyHospital, 150)

local LicenseCentre = AddBlipForRadius(-927.42938232422,-2041.2468261719,13.946600914001, 60.0)
SetBlipColour(LicenseCentre, 2)
SetBlipAlpha(LicenseCentre, 150)

local vipisland = AddBlipForRadius(-2170.4770507812,5179.0668945312,15.63862323761, 100.0)
SetBlipColour(vipisland, 2)
SetBlipAlpha(vipisland, 170)

local legion = AddBlipForRadius(170.51364135742,-1021.3690795898,28.816247940063, 50.0)
SetBlipColour(legion, 2)
SetBlipAlpha(legion, 170)

InsideSafeZone = false
setDrawGreenZoneUI = false
setDrawNonRpZoneUI = false
Citizen.CreateThread(function()
	while true do
		for index,info in pairs(blips) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			safeZoneDist = #(plyCoords-info.pos) 
			while safeZoneDist < info.dist do
				local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				safeZoneDist = #(plyCoords-info.pos)
				
				if info.nonRP then
					setDrawNonRpZoneUI = true
				else
					if not info.setBit then
						setDrawGreenZoneUI = true
						showEnterGreenzone = true
						showExitGreenzone = false
						greenzoneTimer = 1
						info.setBit = true
					end
					if info.interior then 
						setDrawGreenInterior = true
					end
				end
				Wait(100)
			end
			if info.setBit then
				showEnterGreenzone = false
				showExitGreenzone = true
				greenzoneTimer = 1
				info.setBit = false
			end
			setDrawNonRpZoneUI = false
			setDrawGreenZoneUI = false
			showEnterGreenzone = false
			setDrawGreenInterior = false
			SetEntityInvincible(GetPlayerPed(-1), false)
			SetPlayerInvincible(PlayerId(), false)
			ClearPedBloodDamage(GetPlayerPed(-1))
			ResetPedVisibleDamage(GetPlayerPed(-1))
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
			SetEntityCanBeDamaged(GetPlayerPed(-1), true)
			NetworkSetFriendlyFireOption(true)
		end
		Wait(100)
	end
end)

Citizen.CreateThread(function()
	while true do
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		cityZoneDist = #(plyCoords-vector3(171.07974243164,-1024.8974609375,29.3747520446784))
		if cityZoneDist < 500 then
			inCityZone = true 
		else 
			inCityZone = false 
		end
		Wait(1000)
	end
end)


Citizen.CreateThread(function()
	while true do
		if setDrawGreenZoneUI then
			DisableControlAction(2, 37, true)
			DisablePlayerFiring(GetPlayerPed(-1),true)
			DisableControlAction(0, 106, true)
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 170, true)
		end
		if setDrawGreenInterior then 
			DisableControlAction(0, 106, true)
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 170, true)
			DisableControlAction(0, 22, true)
		end
		Wait(0)
	end
end)



Citizen.CreateThread(function()
	while true do
		if setDrawGreenZoneUI or setDrawNonRpZoneUI then
			SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false),13.0)
			SetEntityInvincible(GetPlayerPed(-1), true)
			SetCurrentPedWeapon(GetPlayerPed(-1),GetHashKey("WEAPON_UNARMED"),true)
			SetPlayerInvincible(PlayerId(), true)
			ClearPedBloodDamage(GetPlayerPed(-1))
			ResetPedVisibleDamage(GetPlayerPed(-1))
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
			SetEntityCanBeDamaged(GetPlayerPed(-1), false)
		else
			if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
				if not inCityZone then
					if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1),true)) ~= 13 then
						SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false),111.5)
					else
						SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false),11001.5)
					end
				else 
					if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1),true)) ~= 13 then
						SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false),44.6)
					else
						SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false),11001.5)
					end
				end
			end
		end
		Wait(0)
	end
end)

showEnterGreenzone = false
showExitGreenzone = false
greenzoneTimer = 0

Citizen.CreateThread(function()
	while true do
		if showEnterGreenzone and greenzoneTimer > 0 then
			TriggerEvent("LVLNotify:Success",nil,"You have entered a Greenzone!","top-right",nil,true)
		end
		if showExitGreenzone and greenzoneTimer > 0 then
			TriggerEvent("LVLNotify:Negative",nil,"You have entered a exited a Greenzone!","top-right",nil,true)
		end
		Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		greenzoneTimer = greenzoneTimer - 1
		Wait(0)
	end
end)



















