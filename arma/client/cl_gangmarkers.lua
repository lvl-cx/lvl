local function RotationToDirection(rotation)
	local adjustedRotation = { 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = {
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local function RayCastGamePlayCamera(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = { 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, -1, 1))
	return b, c, e
end



local blip = nil
local markerActive = false
local markersEnabled = true
local config = {
    markerShowDistance = 100.0, -- markers start showing over 100m
    markerDeleteDistance = 5.0, -- marker will delete when distance is under 5m
    showTime = 10000, -- 10 seconds default
    -- marker default colours
    r = 0,
    g = 255,
    b = 0,
}

local function createMarker()
    if markersEnabled then
        local _, coords, entity = RayCastGamePlayCamera(1000.0)

        if coords == vector3(0.0, 0.0, 0.0) then -- sometimes this happens
            return 
        end
        TriggerServerEvent('ARMA:sendGangMarker', coords)
    end
end


RegisterNetEvent("ARMA:drawGangMarker")
AddEventHandler("ARMA:drawGangMarker",function(coords)
    if markersEnabled then
        if markerActive == true then 
            markerActive = false 
            Wait(0)
        end

        local dist = #(GetEntityCoords(PlayerPedId()) - coords)
        if dist < config.markerDeleteDistance then -- check if the marker is too close, then delete
            return
        end

        RemoveBlip(blip)
        blip = AddBlipForCoord(coords) SetBlipSprite(blip, 148) SetBlipScale(blip, 0.25) SetBlipColour(blip, 1) 
        PlaySoundFrontend(-1, "10_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", true) -- beep sound
        markerActive = true
        local now = GetGameTimer()

        while (GetGameTimer() - now < config.showTime) and (markerActive == true) do 
            Wait(0)
            dist = #(GetEntityCoords(PlayerPedId()) - coords) -- distance from marker
            if dist < config.markerDeleteDistance then  -- if you walk too close to the marker it goes 
                markerActive = false  
            end 
            if dist > config.markerShowDistance then 
                DrawMarker(1, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 100.0, config.r, config.g, config.b, 75, false, true, 2, nil, nil, false)
            else
                UI.DrawSprite3d({
                    pos = coords + vector3(0.0, 0.0, dist/100), -- place the sprite slightly above the distance text
                    textureDict = 'markers',
                    textureName = 'genericBlip',
                    width = 0.06,
                    height = 0.1,
                    r = config.r,
                    g = config.g,
                    b = config.b,
                    a = 255
                })
            end
            UI.DrawText3D(coords, tostring(math.floor(dist))..'m')
            RemoveBlip(blip)
        end
    end
end)

UI = {}

function UI.DrawText3D(coords, text, colourData)
	colourData = colourData or {255, 255, 255, 255}
	local size = 1
	local font = 4
    local scale = 0.75
	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
	SetTextColour(colourData[1], colourData[2], colourData[3], colourData[4])
	-- SetTextDropshadow(255, 255, 255, 255, 255)
	SetTextDropShadow()
	SetTextCentre(true)
	SetTextProportional(1)
	SetDrawOrigin(coords, 0)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end


function UI.DrawSprite3d(data)
    local dist = #(GetGameplayCamCoords().xy - data.pos.xy)
    local fov = (1 / GetGameplayCamFov()) * 250
    local scale = 0.3
    SetDrawOrigin(data.pos.x, data.pos.y, data.pos.z, 0)
	if not HasStreamedTextureDictLoaded(data.textureDict) then
		local timer = 1000
		RequestStreamedTextureDict(data.textureDict, true)
		while not HasStreamedTextureDictLoaded(data.textureDict) and timer > 0 do
			timer = timer-1
			Citizen.Wait(100)
		end
	end
    DrawSprite(
        data.textureDict,
        data.textureName,
        (data.x or 0) * scale,
        (data.y or 0) * scale,
        data.width * scale,
        data.height * scale,
        data.heading or 0,
        data.r or 0,
        data.g or 0,
        data.b or 0,
        data.a or 255
    )
    ClearDrawOrigin()
end

RegisterKeyMapping("drawmarker", "Gang Marker", "MOUSE_BUTTON", "MOUSE_MIDDLE")
RegisterCommand('drawmarker', createMarker)

RMenu.Add('markercolour','main',RageUI.CreateMenu("","~b~ARMA Marker Customisation ",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners","gangmarker"))
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('markercolour', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator('Remember to do ~b~/markers ~w~to enable them.')
            RageUI.SliderProgress("Red ["..config.r.."]",config.r,255,"Press ~b~SPACE~w~ to enter RGB Red value",{ProgressBackgroundColor={R=186,G=58,B=48,A=255},ProgressColor={R=212,G=66,B=55,A=255}},true,function(c,e,d,f)
                if e then 
                    if IsControlJustPressed(0,22)then 
                        local r = getInput("Enter Red Value (0-255)",config.r)
                        if r ~= nil then 
                            saveMarkerColour("r",r)
                        end
                    else 
                        if f~=config.r then 
                            saveMarkerColour("r",f)
                        end 
                    end 
                end 
            end)
            RageUI.SliderProgress("Green ["..config.g.."]",config.g,255,"Press ~b~SPACE~w~ to enter RGB Green value",{ProgressBackgroundColor={R=48,G=186,B=108,A=255},ProgressColor={R=64,G=230,B=136,A=255}},true,function(c,e,d,f)
                if e then 
                    if IsControlJustPressed(0,22)then 
                        local g = getInput("Enter Green Value (0-255)",config.g)
                        if g ~= nil then 
                            saveMarkerColour("g",g)
                        end
                    else 
                        if f~=config.g then 
                            saveMarkerColour("g",f)
                        end 
                    end 
                end 
            end)
            RageUI.SliderProgress("Blue ["..config.b.."]",config.b,255,"Press ~b~SPACE~w~ to enter RGB Blue value",{ProgressBackgroundColor={R=48,G=69,B=186,A=255},ProgressColor={R=59,G=86,B=237,A=255}},true,function(c,e,d,f)
                if e then 
                    if IsControlJustPressed(0,22) then 
                        local b = getInput("Enter Blue Value (0-255)",config.b)
                        if b ~= nil then 
                            saveMarkerColour("b",b)
                        end
                    else 
                        if f~=config.b then 
                            saveMarkerColour("b",f)
                        end
                    end 
                end 
            end)
       end)
    end
end)

RegisterCommand("markercolour",function(h,i,j)
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('markercolour','main'),true)
end)

RegisterCommand("markers",function()
    markersEnabled = not markersEnabled
    tARMA.notify("Markers are now "..(markersEnabled and "~g~enabled" or "~r~disabled"))
    SetResourceKvpInt('ARMA_markers_enabled', markersEnabled)
end)

function getInput(k,l)
    AddTextEntry('FMMC_MPM_NA',k)
    DisplayOnscreenKeyboard(1,"FMMC_MPM_NA",k,"","","","",3)
    while UpdateOnscreenKeyboard()==0 do 
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult()then 
        local m=GetOnscreenKeyboardResult()
        local n=tonumber(m)
        if m then
            if m~=nil and m~=""and type(n)=="number"and n<=255 and n>=0 then 
                return n 
            else 
                return l 
            end 
        end
    end 
end

function saveMarkerColour(set, value)
    if set == "r" then
        config.r = value
        SetResourceKvpInt('ARMA_markercolour_r', tonumber(value))
    elseif set == "g" then
        config.g = value
        SetResourceKvpInt('ARMA_markercolour_g', tonumber(value))
    elseif set == "b" then
        config.b = value
        SetResourceKvpInt('ARMA_markercolour_b', tonumber(value))
    end
end

Citizen.CreateThread(function()
    config.r = GetResourceKvpInt("ARMA_markercolour_r") or 0
    config.g = GetResourceKvpInt("ARMA_markercolour_g") or 255
    config.b = GetResourceKvpInt("ARMA_markercolour_b") or 0
    if GetResourceKvpInt("ARMA_markers_enabled") == 0 then
        markersEnabled = false
    else
        markersEnabled = true
    end
end)
