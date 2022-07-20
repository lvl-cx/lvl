local holstered = true
local disableFiring = false
local equipedWeapon = nil
local weaponlist = {

}

 Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		if GetVehiclePedIsTryingToEnter(playerPed) ~= 0 then
			SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true)
		end
		if disableFiring then
			DisablePlayerFiring(playerPed,true)
		end
		Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped, true) then
			if GetIsTaskActive(ped, 56) then
				if GetSelectedPedWeapon(ped) ~= GetHashKey('WEAPON_UNARMED') then
					tARMA.loadAnimDict("reaction@intimidation@1h")
					TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 2.0, 1700, 48, 10, 0, 0, 0 )
					SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
					disableFiring = true
					Citizen.Wait(1300)
					SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
					Citizen.Wait(700)
					ClearPedTasks(ped)
					holstered = false
					disableFiring = false
					equipedWeapon = CurrentWeapon(ped)
				else
					tARMA.loadAnimDict("reaction@intimidation@1h")
					TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 2.0, 1700, 48, 10, 0, 0, 0 )
					disableFiring = true
					SetCurrentPedWeapon(ped, GetHashKey(equipedWeapon), true)
					Citizen.Wait(1300)
					SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)

					Citizen.Wait(700)
					ClearPedTasks(ped)
					holstered = true
					disableFiring = false
					equipedWeapon = nil
				end
			end
		end
		Wait(0)
	end
end)

function CurrentWeapon(ped)
	currentWeapon = GetSelectedPedWeapon(ped)
	for k,v in pairs(weaponlist) do
		if GetHashKey(v) == currentWeapon then
			return v
		end
	end
	return nil
end

