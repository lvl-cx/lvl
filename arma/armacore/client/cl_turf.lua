local inTurf = false
local secondsRemaining = 0

local TakenTurf = false

local c = {}
Citizen.CreateThread(
    function()
        local k = tARMA.addBlip(133.73462677002, -1305.0340576172, 29.268741607666, 403, 4, "Cocaine Trader")
        local l = tARMA.addBlip(103.47916412354, -1937.1091308594, 19.803705215454, 140, 2, "Weed Trader")
        local m = tARMA.addBlip(3569.8334960938, 3662.5893554688, 33.920593261718, 586, 1, "Heroin Trader")
        local n = tARMA.addBlip(-1118.4926757813, 4926.1889648438, 218.35691833496, 150, 1, "Large Arms Trader")
        local o = tARMA.addBlip(5065.6201171875, -4591.3857421875, 2.8652405738831, 150, 1, "Large Arms Trader")
        local q = tARMA.addBlip(2485.7429199219, -430.13989257813, 92.992835998535, 604, 8, "LSD South Trader", 1.0)
        local r = {
            {
                title = "Weed Trader",
                colour = 2,
                id = 1,
                position = vector3(103.47916412354, -1937.1091308594, 19.803705215454),
                blipsize = 50.0
            },
            {
                title = "Cocaine Trader",
                colour = 4,
                id = 1,
                position = vector3(133.54704284668, -1305.7708740234, 28.154886245728),
                blipsize = 50.0
            },
            {
                title = "Heroin Trader",
                colour = 1,
                id = 1,
                position = vector3(3545.048828125, 3724.0776367188, 36.64262008667),
                blipsize = 170.0
            },
            {
                title = "Large Arms Trader",
                colour = 1,
                id = 1,
                position = vector3(-1118.4926757813, 4926.1889648438, 218.35691833496),
                blipsize = 170.0
            },
            {
                title = "LSD South Trader",
                colour = 1,
                id = 1,
                position = vector3(2539.0964355469, -376.51586914063, 92.986785888672),
                blipsize = 120.0
            }
        }
        for s, t in pairs(r) do
            local u = AddBlipForRadius(t.position.x, t.position.y, t.position.z, t.blipsize)
            c[s] = u
            SetBlipColour(u, t.colour)
            SetBlipAlpha(u, 180)
        end
    end
)

function tARMA.isPlayerInTurf()
    return inTurf 
end

RegisterNetEvent('ARMA:TakenTurf')
AddEventHandler('ARMA:TakenTurf', function(isnTurf)
	
	inTurf = true
	turf = isnTurf
	secondsRemaining = 300
	TakenTurf = false

	TakeComission()
	TakeComissionWeed()
	TakeComissionCocaine()
	TakeComissionLSD()
	TakeComissionHeroin()

end)

RegisterNetEvent('ARMA:OutOfZone')
AddEventHandler('ARMA:OutOfZone', function(isnTurf)
	inTurf = false
	tARMA.notify("~r~The The turf cap was cancelled, you will receive nothing.")
	TakenTurf = false
	inZone = false
end)

RegisterNetEvent('ARMA:PlayerDied')
AddEventHandler('ARMA:PlayerDied', function(isnTurf)
	inTurf = false
	tARMA.notify("~r~The turf cap was cancelled, you died!")
	TakenTurf = false
	inTurfName = ""
	secondsRemaining = 0

	inZone = false
	
end)

RegisterNetEvent('ARMA:TurfComplete')
AddEventHandler('ARMA:TurfComplete', function(reward, name)
	inTurf = false
	secondsRemaining = 0
	if name == 'Weed' then
		TakenTurfWeed = true
	end

	if name == 'Cocaine' then
		TakenTurfCocaine = true
	end

	if name == 'LSD' then
		TakenTurfLSD = true
	end
	if name == 'Heroin' then
		TakenTurfHeroin = true
	end
	inZone = false
end)


function TakeComission()
	Citizen.CreateThread(function() 
		while true do
			if TakenTurf then
				local v1 = vector3(-86.27645111084,834.51782226562,235.92004394531)
				
					if inTurf == false then
						if isInArea(v1, 1.4) then 
							alert('Press ~INPUT_VEH_HORN~ to Change Commision')
							if IsControlJustPressed(0, 51) then 
								changeComision()
							end
						end
					end
				
			end
			Citizen.Wait(0)
		end
	end)
	
end

function TakeComissionWeed()
	Citizen.CreateThread(function() 
		while true do
			if TakenTurfWeed then
				local v1 = vector3(100.96116638184,-1958.7907714844,20.790607452393)
				
					if inTurf == false then
						if isInArea(v1, 1.4) then 
							alert('Press ~INPUT_VEH_HORN~ to Change Commision')
							if IsControlJustPressed(0, 51) then 
								changeComision2()
							end
						end
					end
				
			end
			Citizen.Wait(0)
		end
	end)
	
end

function TakeComissionCocaine()
	Citizen.CreateThread(function() 
		while true do
			if TakenTurfCocaine then
				local v1 = vector3(121.41984558105,-1307.7109375,29.23345375061)
				if inTurf == false then
					if isInArea(v1, 1.4) then 
						alert('Press ~INPUT_VEH_HORN~ to Change Commision')
						if IsControlJustPressed(0, 51) then 
							changeComision3()
						end
					end
				end
			end
			Citizen.Wait(0)
		end
	end)
end

function TakeComissionLSD()
	Citizen.CreateThread(function() 
		while true do
			if TakenTurfLSD then
				local v1 = vector3(2485.8977050781,-405.85736083984,93.73526763916)
				if inTurf == false then
					if isInArea(v1, 1.4) then 
						alert('Press ~INPUT_VEH_HORN~ to Change Commision')
						if IsControlJustPressed(0, 51) then 
							changeComision4()
						end
					end
				end
			end
			Citizen.Wait(0)
		end
	end)
end

function TakeComissionHeroin()
	Citizen.CreateThread(function() 
		while true do
			if TakenTurfHeroin then
				local v1 = vector3(3577.2836914062,3649.7709960938,33.888595581055)
				if inTurf == false then
					if isInArea(v1, 1.4) then 
						alert('Press ~INPUT_VEH_HORN~ to Change Commision')
						if IsControlJustPressed(0, 51) then 
							changeComision5()
						end
					end
				end
			end
			Citizen.Wait(0)
		end
	end)
end

RegisterNetEvent("ARMA:DontIt")
AddEventHandler("ARMA:DontIt", function(bool)
	TakenTurf = bool 
end)

RegisterNetEvent("ARMA:DontItWeed")
AddEventHandler("ARMA:DontItWeed", function(bool)
	TakenTurfWeed = bool 
end)

RegisterNetEvent("ARMA:DontItCocaine")
AddEventHandler("ARMA:DontItCocaine", function(bool)
	TakenTurfCocaine = bool 
end)


RegisterNetEvent("ARMA:DontItLSD")
AddEventHandler("ARMA:DontItLSD", function(bool)
	TakenTurfLSD = bool 
end)

RegisterNetEvent("ARMA:DontItHeroin")
AddEventHandler("ARMA:DontItHeroin", function(bool)
	TakenTurfHeroin = bool 
end)


function changeComision()
    
	AddTextEntry('FMMC_KEY_TIP8', "Enter the Commision to change.")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "Enter Amount (Blank to Cancel)", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local resultID = GetOnscreenKeyboardResult()
		if  resultID then
            TriggerServerEvent("ARMA:ChangeCommision", tonumber(resultID))
			
		end
    end
	return false

end

function changeComision2()
    
	AddTextEntry('FMMC_KEY_TIP8', "Enter the Commision to change.")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "Enter Amount (Blank to Cancel)", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local resultID = GetOnscreenKeyboardResult()
		if  resultID then
            TriggerServerEvent("ARMA:ChangeCommisionWeed", tonumber(resultID))
			
		end
    end
	return false

end

function changeComision3()
	AddTextEntry('FMMC_KEY_TIP8', "Enter the Commision to change.")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "Enter Amount (Blank to Cancel)", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local resultID = GetOnscreenKeyboardResult()
		if  resultID then
            TriggerServerEvent("ARMA:ChangeCommisionCocaine", tonumber(resultID))
			
		end
    end
	return false

end

function changeComision4()
    
	AddTextEntry('FMMC_KEY_TIP8', "Enter the Commision to change.")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "Enter Amount (Blank to Cancel)", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local resultID = GetOnscreenKeyboardResult()
		if  resultID then
            TriggerServerEvent("ARMA:ChangeCommisionLSD", tonumber(resultID))
			
		end
    end
	return false

end

function changeComision5()
    
	AddTextEntry('FMMC_KEY_TIP8', "Enter the Commision to change.")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "Enter Amount (Blank to Cancel)", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local resultID = GetOnscreenKeyboardResult()
		if  resultID then
            TriggerServerEvent("ARMA:ChangeCommisionHeroin", tonumber(resultID))
			
		end
    end
	return false

end



Citizen.CreateThread(function()
	while true do
		if inTurf then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end

		Citizen.Wait(0)
	end
end)

inZone = false

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(PlayerPedId(), true)
		for k,v in pairs(turfs)do
			local pos2 = v.position
			local pos3 = v.capturf 
			if (Vdist(pos.x, pos.y, pos.z, pos3.x, pos3.y, pos3.z) < 1.4) then
				if not inTurf then
					if (Vdist(pos.x, pos.y, pos.z, pos3.x, pos3.y, pos3.z) < 1.4) then
						local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
						if HasScaleformMovieLoaded(scaleform) then
							PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
							BeginTextComponent("STRING")
							AddTextComponentString("Press [E] to take turf")
							EndTextComponent()
							PopScaleformMovieFunctionVoid()
							DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
						end
						
						inZone = true
						if (IsControlJustReleased(1, 51)) then
							TriggerServerEvent('ARMA:TakeTurf', k)
							istakingturf = v.nameofturf
						end
					elseif (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.4) then
						inZone = false
					end
				end
			end
		end

		if inTurf then		
			tARMA.drawTxt("Capping Turf: ~r~" .. secondsRemaining .. " seconds remaining", 7, 1, 0.8, 0.8, 0.6, 255, 255, 255, 255)
			local pos2 = turfs[turf].position
			local ped = PlayerPedId()
            if IsEntityDead(ped) then
			TriggerServerEvent('ARMA:PlayerDied', turf)
			elseif (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > turfs[turf].radius) then
				TriggerServerEvent('ARMA:TooFar', turf)
			end
		end
		Citizen.Wait(0)
	end
end)


RegisterNetEvent("ARMA:MakeTurfTrue")
AddEventHandler("ARMA:MakeTurfTrue", function(isit)
	if isit then
		inTurf = true
	else 
		inTurf = false 
	end
end)

-- [Zone Events]
RegisterNetEvent('HeroinZone')
AddEventHandler('HeroinZone', function(isnTurf)

	while true do
		if inTurf then
			DrawMarker(1, 3565.6037597656,3662.1218261719,33.951766967773-10, 0, 0, 0, 0, 0, 0, 60.001, 60.0001, 150.5001, 0, 255, 68, 80, 0, 0, 0, 0)
		end	

		Citizen.Wait(1) 
	end
end)

RegisterNetEvent('LSDZone')
AddEventHandler('LSDZone', function(isnTurf)
	while true do
		if inTurf then
			DrawMarker(1, 2479.939453125,-412.90567016602,93.735107421875-10, 0, 0, 0, 0, 0, 0, 80.001, 80.0001, 150.5001, 0, 255, 68, 80, 0, 0, 0, 0)
		end

		Citizen.Wait(1) 
	end
end)

RegisterNetEvent('WeedZone')
AddEventHandler('WeedZone', function(isnTurf)
	while true do
		if inTurf then 
			DrawMarker(1, 103.15713500977,-1938.5643310547,20.803695678711-10, 0, 0, 0, 0, 0, 0, 100.001, 100.0001, 150.5001, 0, 255, 68, 80, 0, 0, 0, 0)
		end

		Citizen.Wait(1) 
	end
end)

RegisterNetEvent('CocaineZone')
AddEventHandler('CocaineZone', function(isnTurf)
	while true do
		if inTurf then 
			DrawMarker(1, 134.72003173828,-1306.8198242188,29.04651260376-10, 0, 0, 0, 0, 0, 0, 100.001, 100.0001, 150.5001, 0, 255, 68, 80, 0, 0, 0, 0)
		end

		Citizen.Wait(1) 
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		-- [Turf Markers]
		DrawMarker(24, 3580.8835449219,3647.9147949219,33.888610839844+1 - 0.98, 0.9, 0.0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 255, 34, 0, 200, false, true, 0, 0, 0, 0, 0) -- [Heroin]
		DrawMarker(24, 2487.8530273438,-403.55877685547,93.735229492188+1 - 0.98, 0.9, 0.0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 255, 34, 0, 200, false, true, 0, 0, 0, 0, 0)  -- [LSD]
		DrawMarker(24, 103.01790618896,-1958.5435791016,20.781145095825+1 - 0.98, 0.9, 0.0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 255, 34, 0, 200, false, true, 0, 0, 0, 0, 0) -- [Weed]
		DrawMarker(24, 125.75616455078,-1304.6053466797,29.233455657959+1 - 0.98, 0.9, 0.0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 255, 34, 0, 200, false, true, 0, 0, 0, 0, 0) -- [Cocaine]
		if TakenTurfWeed then
			DrawMarker(30, 100.96116638184,-1958.7907714844,20.790607452393+1 - 0.98, 0.8, 0.8, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 34, 0, 200, true, true, 0, 0, 0, 0, 0) -- [Weds Trader]
		end		
		if TakenTurfCocaine then
			DrawMarker(30, 121.41984558105,-1307.7109375,29.23345375061+1 - 0.98, 0.8, 0.8, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 34, 0, 200, true, true, 0, 0, 0, 0, 0) -- [Cocaine Trader]
		end		
		if TakenTurfLSD then
			DrawMarker(30, 2485.8977050781,-405.85736083984,93.73526763916+1 - 0.98, 0.8, 0.8, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 34, 0, 200, true, true, 0, 0, 0, 0, 0) -- [LSD Trader]
		end	
		if TakenTurfHeroin then
			DrawMarker(30, 3577.2836914062,3649.7709960938,33.888595581055+1 - 0.98, 0.8, 0.8, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 34, 0, 200, true, true, 0, 0, 0, 0, 0) -- [Heroin Trader]
		end			
			
	end
end)

function alert(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
