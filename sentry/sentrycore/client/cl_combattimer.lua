local inRedZone = false
local timeLeft = 30
local currentRedZone = nil
local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

zones = {
    {name = "LSD", coords = vector3(2539.0031738281,-395.42044067383,92.74683380127), blipWidth = 140.0, blipColour = 1},
    {name = "Large Arms", coords = vector3(-1113.1085205078,4922.0400390625,217.8408203125), blipWidth = 110.0, blipColour = 1},
    {name = "Heroin", coords = vector3(3529.4702148438,3726.9321289062,36.473175048828), blipWidth = 220.0, blipColour = 1},
    {name = "Rebel", coords = vector3(1457.4250488281,6308.064453125,63.868026733398), blipWidth = 130.0, blipColour = 1},
    {name = "Weapon Trader", coords = vector3(-104.02886962891,899.93719482422,243.78176879883), blipWidth = 180.0, blipColour = 1},
}

Citizen.CreateThread(function()
    for k, v in pairs(zones) do
        local blip = AddBlipForRadius(v.coords, v.blipWidth)
        SetBlipHighDetail(blip, true)
        SetBlipColour(blip, v.blipColour)
        SetBlipAlpha(blip, 128)
    end

    while true do
        Citizen.Wait(0)
        for k, v in pairs(zones) do
            
            if isInArea(v.coords, v.blipWidth) and not inRedZone then
                timeLeft = 30
                inRedZone = true
                currentRedZone = k
            end

            if isInArea(v.coords, v.blipWidth) == false and inRedZone and currentRedZone == k then
                if timeLeft == 0 then
                    inRedZone = false
                else
                    TaskGoStraightToCoord(PlayerPedId(), v.coords, 2.0, 100.0, 307.0, 1.0)
                    if HasScaleformMovieLoaded(scaleform) then
                        PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
                        BeginTextComponent("STRING")
                        AddTextComponentString("~r~GET BACK IN THE REDZONE!")
                        EndTextComponent()
                        PopScaleformMovieFunctionVoid()
                        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                    end
                    SetTimeout(1000, function()
                        ClearPedTasks(PlayerPedId())
                    end)
                end
            end
        end

        if inRedZone then
            if IsPedShooting(PlayerPedId()) then
                timeLeft = 30
            end

            if timeLeft ~= 0 then
                drawTxt(1.1, 1.44, 1.0, 1.0, 0.7, timeLeft .. " seconds remaining", 255, 0, 0, 255)
            elseif timeLeft == 0 then
                drawTxt(1.1, 1.44, 1.0, 1.0, 0.7, "combat timer ended", 255, 0, 0, 255)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if inRedZone then
            if timeLeft > 0 then
                timeLeft = timeLeft - 1
            end
        end
    end
end)

function isInArea(v, dis) 
    if #(GetEntityCoords(PlayerPedId()) - v) <= dis then  
        return true
    else 
        return false
    end
end

function drawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(7)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(255, 0, 0, 0, 255)
    SetTextEdge(255, 0, 0, 0, 255)
    SetTextDropShadow()
    if outline then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end