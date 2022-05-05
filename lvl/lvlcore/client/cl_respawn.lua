rebellicense = false

RMenu.Add("SpawnMenu", "main", RageUI.CreateMenu("", "~g~LVL Spawn Menu",1300, 50, 'spawn', 'spawn'))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('SpawnMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
			FreezeEntityPosition(PlayerPedId(), true)
			RageUI.Button("St Thomas Medical Center", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
				if Active then
					SetNewWaypoint(364.56402587891,-591.74749755859)
				end
				if Selected then
					TriggerServerEvent("LVLTP:StThomas")
				end
			end)
			RageUI.Button("Legion Gunstore", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
				if Active then
					SetNewWaypoint(281.16030883789,-992.70983886719,33.449813842773)
				end
				if Selected then
					TriggerServerEvent("LVLTP:Legion")
				end
			end)
			RageUI.Button("Paleto Bay Medical Center", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
				if Active then
					SetNewWaypoint(-246.71606445313,6330.7153320313)
				end
				if Selected then
					TriggerServerEvent("LVLTP:Paleto")
				end
			end)
			RageUI.Button("Sandy Shores Medical Center", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
				if Active then
					SetNewWaypoint(1841.5405273438,3668.8037109375)
				end
				if Selected then
					TriggerServerEvent("LVLTP:Sandy")
				end
			end)
			if policeenabled then
				RageUI.Button("Mission Row PD", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
					if Active then
						SetNewWaypoint(428.19479370117,-981.58215332031,30.710285186768)
					end
					if Selected then
						TriggerServerEvent("LVLTP:MissionRow")
					end
				end)
				RageUI.Button("Paleto PD", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
					if Active then
						SetNewWaypoint(-439.23,6020.6,31.49)
					end
					if Selected then
						TriggerServerEvent("LVLTP:PaletoPD")
					end
				end)
				RageUI.Button("Vespucci PD", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
					if Active then
						SetNewWaypoint(-1061.13,-827.26,19.21)
					end
					if Selected then
						TriggerServerEvent("LVLTP:Vespucci")
					end
				end)
			end
			if rebellicense then 
				RageUI.Button("Rebel Diner", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
					if Active then
						SetNewWaypoint(1582.0557861328,6450.7368164062,25.175634384155)
					end
					if Selected then
						TriggerServerEvent("LVLTP:Rebel")
					end
				end)
			end
			if houseName == nil then 

			else
				RageUI.Button(houseName, nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
					if Active then
						SetNewWaypoint(location)
					end
					if Selected then	
						SetEntityCoords(PlayerPedId(), location)
					end
				end)
			end
		end)
    end
end)

isRespawnMenuOpen = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local RespawnPlrCoords, isinRespawnMarker, RespawnZone, RespawnSleep = GetEntityCoords(PlayerPedId()), false, nil, true

		local respawndistance = #(RespawnPlrCoords - vector3(340.05987548828,-1388.4616699219,32.509250640869))
		if respawndistance < 120.0 then
			RespawnSleep = false
			if respawndistance < 1.5 then
				isinRespawnMarker, RespawnZone = true, k
			end
		end
		if (isinRespawnMarker and not hasAlreadyEnteredRespawnMarker) or (isinRespawnMarker and lastRespawnZone ~= RespawnZone) then
			hasAlreadyEnteredRespawnMarker, lastRespawnZone = true, RespawnZone
			TriggerServerEvent('LVL:RebelCheck')
			TriggerServerEvent('LVL:PoliceCheck')
			SetBigmapActive(true, true)
			isRespawnMenuOpen = true
		end

		if not isinRespawnMarker and hasAlreadyEnteredRespawnMarker then
			RageUI.ActuallyCloseAll()
			RageUI.Visible(RMenu:Get("SpawnMenu", "main"), false)
			SetBigmapActive(false, false)
			hasAlreadyEnteredRespawnMarker = false
			isRespawnMenuOpen = false
		end

		if RespawnSleep then
			Citizen.Wait(500)
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isRespawnMenuOpen then

			RageUI.Visible(RMenu:Get("SpawnMenu", "main"), true)

		end
	end
end)

RegisterNetEvent('LVL:RebelChecked')
AddEventHandler('LVL:RebelChecked', function(allowed)
    if allowed then
        rebellicense = true
    elseif not allowed then
        rebellicense = false
    end
end)

RegisterNetEvent('LVL:PoliceChecked')
AddEventHandler('LVL:PoliceChecked', function(policeallowed)
    if policeallowed then
        policeenabled = true
    elseif not policeallowed then
        policeenabled = false
    end
end)

RegisterNetEvent('HouseRespawn')
AddEventHandler('HouseRespawn', function(name,vector)
	location = vector3(vector)
	houseName = name
end)