function isInArea(v, dis) 
    return #(GetEntityCoords(PlayerPedId()) - v) <= dis 
end

local SoundEffects = {
	["info"]    = {'CHALLENGE_UNLOCKED', 'HUD_AWARDS'},
	["success"] = {'BASE_JUMP_PASSED', 'HUD_AWARDS'},
	["warning"] = {'CHECKPOINT_MISSED', 'HUD_AWARDS'},
	["error"]   = {'Bed', 'WastedSounds'},
}

RegisterNetEvent('MpGameMessage:send')
AddEventHandler('MpGameMessage:send', function(message, subtitle, ms, sound, top)

	if ms == nil then
		ms = 3500
	end
	
	if sound == nil then
		sound = 'info'
	end
	
	if top == true then
		MethodName = "SHOW_PLANE_MESSAGE"
	else
		MethodName = "SHOW_SHARD_WASTED_MP_MESSAGE"
	end
	
	Citizen.CreateThread(function()
		
		local scaleform = RequestScaleformMovie("mp_big_message_freemode")
		
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		
		if sound ~= false then
			PlaySoundFrontend(-1, SoundEffects[sound][1], SoundEffects[sound][2], true)
		end
		
		BeginScaleformMovieMethod(scaleform, MethodName)
		PushScaleformMovieMethodParameterString(message)
		PushScaleformMovieMethodParameterString(subtitle)
		PushScaleformMovieMethodParameterInt(0)
		EndScaleformMovieMethod()

		local time = GetGameTimer() + ms
        
        while(GetGameTimer() < time) do
			Citizen.Wait(0)
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		end
		
		SetScaleformMovieAsNoLongerNeeded(scaleform)
	end)
	
end)

RegisterNetEvent('MpGameMessage:warning')
AddEventHandler('MpGameMessage:warning', function(message, subtitle, bottom, ms, sound)

	if ms == nil then
		ms = 3500
	end
	
	if sound == nil then
		sound = 'info'
	end
	
	Citizen.CreateThread(function()
		
		local scaleform = RequestScaleformMovie("POPUP_WARNING")
		
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		
		if sound ~= false then
			PlaySoundFrontend(-1, SoundEffects[sound][1], SoundEffects[sound][2], true)
		end
		
		BeginScaleformMovieMethod(scaleform, "SHOW_POPUP_WARNING")
		PushScaleformMovieMethodParameterFloat(500.0)
		PushScaleformMovieMethodParameterString(message)
		PushScaleformMovieMethodParameterString(subtitle)
		PushScaleformMovieMethodParameterString(bottom)
		PushScaleformMovieMethodParameterBool(true)
		EndScaleformMovieMethod()

		local time = GetGameTimer() + ms
        
        while(GetGameTimer() < time) do
			Citizen.Wait(0)
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		end
		
		SetScaleformMovieAsNoLongerNeeded(scaleform)
	end)
	
end)

function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

function Draw3DText(coords, text)
    local x,y,z = table.unpack(coords)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end

function drawNativeNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function GetClosestPlayer(radius)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _,playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(targetCoords-playerCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end
	if closestDistance ~= -1 and closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end        
    end
    return animDict
end

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

function DrawAdvancedTextOutline(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

function drawStyledText(str, x, y, style)
    if style == nil then
        style = {}
    end

    SetTextFont((style.font ~= nil) and style.font or 0)
    SetTextScale(0.0, (style.size ~= nil) and style.size or 1.0)
    SetTextProportional(1)

    if style.colour ~= nil then
        SetTextColour(style.colour.r ~= nil and style.colour.r or 255, style.colour.g ~= nil and style.colour.g or 255, style.colour.b ~= nil and style.colour.b or 255, style.colour.a ~= nil and style.colour.a or 255)
    else
        SetTextColour(255, 255, 255, 255)
    end

    if style.shadow ~= nil then
        SetTextDropShadow(style.shadow.distance ~= nil and style.shadow.distance or 0, style.shadow.r ~= nil and style.shadow.r or 0, style.shadow.g ~= nil and style.shadow.g or 0, style.shadow.b ~= nil and style.shadow.b or 0, style.shadow.a ~= nil and style.shadow.a or 255)
    else
        SetTextDropShadow(0, 0, 0, 0, 255)
    end

    if style.border ~= nil then
        SetTextEdge(style.border.size ~= nil and style.border.size or 1, style.border.r ~= nil and style.border.r or 0, style.border.g ~= nil and style.border.g or 0, style.border.b ~= nil and style.border.b or 0, style.border.a ~= nil and style.shadow.a or 255)
    end

    if style.centered ~= nil and style.centered == true then
        SetTextCentre(true)
    end

    if style.outline ~= nil and style.outline == true then
        SetTextOutline()
    end

    SetTextEntry("STRING")
    AddTextComponentString(str)

    DrawText(x, y)
end

-- Converts degrees to (inter)cardinal directions.
-- @param1	float	Degrees. Expects EAST to be 90° and WEST to be 270°.
-- 					In GTA, WEST is usually 90°, EAST is usually 270°. To convert, subtract that value from 360.
--
-- @return			The converted (inter)cardinal direction.
function degreesToIntercardinalDirection( dgr )
    dgr = dgr % 360.0

    if (dgr >= 0.0 and dgr < 22.5) or dgr >= 337.5 then
        return "N "
    elseif dgr >= 22.5 and dgr < 67.5 then
        return "NE"
    elseif dgr >= 67.5 and dgr < 112.5 then
        return "E"
    elseif dgr >= 112.5 and dgr < 157.5 then
        return "SE"
    elseif dgr >= 157.5 and dgr < 202.5 then
        return "S"
    elseif dgr >= 202.5 and dgr < 247.5 then
        return "SW"
    elseif dgr >= 247.5 and dgr < 292.5 then
        return "W"
    elseif dgr >= 292.5 and dgr < 337.5 then
        return "NW"
    end
end

-- Rounds a number to the closest integer
-- @param1 number to be rounded
-- @param2 decimal places to round
--
-- @return rounded number
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num + 0.5 * mult)
end

function GetMoneyString(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

eclipse_server_callback = function(eventname, args, args2, args3, args4, args5)
    TriggerServerEvent(eventname, args, args2, args3, args4, args5)
end