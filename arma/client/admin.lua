noclipActive = false
local a = nil
local b = 1
local c = 0
local d = false
local e = false
local f = {
    controls = {
        openKey = 288,
        goUp = 85,
        goDown = 38,
        turnLeft = 34,
        turnRight = 35,
        goForward = 32,
        goBackward = 33,
        reduceSpeed = 19,
        increaseSpeed = 21
    },
    speeds = {
        {label = "Very Slow", speed = 0.1},
        {label = "Slow", speed = 0.5},
        {label = "Normal", speed = 2},
        {label = "Fast", speed = 4},
        {label = "Very Fast", speed = 6},
        {label = "Extremely Fast", speed = 10},
        {label = "Extremely Fast v2.0", speed = 20},
        {label = "Max Speed", speed = 25}
    },
    offsets = {y = 0.5, z = 0.2, h = 3},
    bgR = 0,
    bgG = 0,
    bgB = 0,
    bgA = 80
}
local function g(h)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentSubstringKeyboardDisplay(h)
    EndTextCommandScaleformString()
end
local function i(j)
    ScaleformMovieMethodAddParamPlayerNameString(j)
end
local function k(l)
    local l = RequestScaleformMovie(l)
    while not HasScaleformMovieLoaded(l) do
        Citizen.Wait(1)
    end
    BeginScaleformMovieMethod(l, "CLEAR_ALL")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "SET_CLEAR_SPACE")
    ScaleformMovieMethodAddParamInt(200)
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(1)
    i(GetControlInstructionalButton(1, f.controls.goBackward, true))
    i(GetControlInstructionalButton(1, f.controls.goForward, true))
    g("Go Forwards/Backwards")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(0)
    i(GetControlInstructionalButton(2, f.controls.reduceSpeed, true))
    i(GetControlInstructionalButton(2, f.controls.increaseSpeed, true))
    g("Increase/Decrease Speed (" .. f.speeds[b].label .. ")")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "SET_BACKGROUND_COLOUR")
    ScaleformMovieMethodAddParamInt(f.bgR)
    ScaleformMovieMethodAddParamInt(f.bgG)
    ScaleformMovieMethodAddParamInt(f.bgB)
    ScaleformMovieMethodAddParamInt(f.bgA)
    EndScaleformMovieMethod()
    return l
end
function tARMA.toggleNoclip()
    noclipActive = not noclipActive
    if IsPedInAnyVehicle(tARMA.getPlayerPed(), false) then
        c = GetVehiclePedIsIn(tARMA.getPlayerPed(), false)
    else
        c = tARMA.getPlayerPed()
    end
    SetEntityCollision(c, not noclipActive, not noclipActive)
    FreezeEntityPosition(c, noclipActive)
    SetEntityInvincible(c, noclipActive)
    SetVehicleRadioEnabled(c, not noclipActive)
    if noclipActive then
        SetEntityVisible(tARMA.getPlayerPed(), false, false)
    else
        SetEntityVisible(tARMA.getPlayerPed(), true, false)
    end
end
RegisterKeyMapping("noclip", "Staff Noclip", "keyboard", "F4")
RegisterCommand("noclip",function()
    if tARMA.getStaffLevel() >= 4 then
        TriggerServerEvent("ARMA:noClip")
    end
end)

Citizen.CreateThread(function()
    local m = k("instructional_buttons")
    local n = f.speeds[b].speed
    while true do
        if noclipActive then
            DrawScaleformMovieFullscreen(m)
            local o = 0.0
            local p = 0.0
            local r, s, t = tARMA.getPosition()
            local u, v, w = tARMA.getCamDirection()
            if IsDisabledControlJustPressed(1, f.controls.reduceSpeed) then
                if b ~= 1 then
                    b = b - 1
                    n = f.speeds[b].speed
                end
                k("instructional_buttons")
            end
            if IsDisabledControlJustPressed(1, f.controls.increaseSpeed) then
                if b ~= 8 then
                    b = b + 1
                    n = f.speeds[b].speed
                end
                k("instructional_buttons")
            end
            if IsControlPressed(0, f.controls.goForward) then
                r = r + n * u
                s = s + n * v
                t = t + n * w
            end
            if IsControlPressed(0, f.controls.goBackward) then
                r = r - n * u
                s = s - n * v
                t = t - n * w
            end
            if IsControlPressed(0, f.controls.goUp) then
                p = f.offsets.z
            end
            if IsControlPressed(0, f.controls.goDown) then
                p = -f.offsets.z
            end
            local x = GetEntityHeading(c)
            SetEntityVelocity(c, 0.0, 0.0, 0.0)
            SetEntityRotation(c, u, v, w, 0, false)
            SetEntityHeading(c, x)
            SetEntityCoordsNoOffset(c, r, s, t, noclipActive, noclipActive, noclipActive)
        end
        Wait(0)
    end
end)

local usingDelgun = false

local function NetworkDelete(entity)
    Citizen.CreateThread(function()
        if DoesEntityExist(entity) and not (IsEntityAPed(entity) and IsPedAPlayer(entity)) then
            NetworkRequestControlOfEntity(entity)
            local timeout = 5
            while timeout > 0 and not NetworkHasControlOfEntity(entity) do
                Citizen.Wait(1)
                timeout = timeout - 1
            end
            DetachEntity(entity, 0, false)
            SetEntityCollision(entity, false, false)
            SetEntityAlpha(entity, 0.0, true)
            SetEntityAsMissionEntity(entity, true, true)
            SetEntityAsNoLongerNeeded(entity)
            DeleteEntity(entity)
        end
    end)
end

Citizen.CreateThread(function()
    while true do 
        Wait(0)
        if usingDelgun then 
            drawNativeText("~b~Aim ~w~at an object and press ~b~Left Click ~w~to delete it.")
            drawNativeNotification("Don't forget to use ~b~/delgun ~w~to disable the delete gun!")
            local plr = PlayerId()
            if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_STAFFGUN') then
                if IsPlayerFreeAiming(plr) then 
                    local yes, entity = GetEntityPlayerIsFreeAimingAt(plr)
                    if yes then 
                        tARMA.notify('~g~Deleted Entity: ' .. GetEntityModel(entity))
                        NetworkDelete(entity)
                    end
                end 
            end 
        end
    end
end)

RegisterCommand("delgun",function()
    if tARMA.getStaffLevel() > 0 then
        usingDelgun = not usingDelgun
        local g = tARMA.getPlayerPed()
        local h = "WEAPON_STAFFGUN"
        if usingDelgun then
            a = HasPedGotWeapon(g, h, false)
            GiveWeaponToPed(g, h, nil, false, true)
        else
            if not a then
                RemoveWeaponFromPed(g, h)
            end
            a = false
        end
    end
end)

local function teleportToWaypoint()
    --Credits: https://gist.github.com/samyh89/32a780abcd1eea05ab32a61985857486
    --Just a better TP to waypoint and I cba to make one so here is one creds
    Citizen.CreateThread(function()
        local entity = PlayerPedId()
        if IsPedInAnyVehicle(entity, false) then
            entity = GetVehiclePedIsUsing(entity)
        end
        local success = false
        local blipFound = false
        local blipIterator = GetBlipInfoIdIterator()
        local blip = GetFirstBlipInfoId(8)

        while DoesBlipExist(blip) do
            if GetBlipInfoIdType(blip) == 4 then
                cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector())) --GetBlipInfoIdCoord(blip)
                blipFound = true
                break
            end
            blip = GetNextBlipInfoId(blipIterator)
        end

        if blipFound then
            DoScreenFadeOut(250)
            while IsScreenFadedOut() do
                Citizen.Wait(250)
                
            end
            local groundFound = false
            local yaw = GetEntityHeading(entity)
            
            for i = 0, 1000, 1 do
                SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
                SetEntityRotation(entity, 0, 0, 0, 0 ,0)
                SetEntityHeading(entity, yaw)
                SetGameplayCamRelativeHeading(0)
                Citizen.Wait(0)
                if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then --GetGroundZFor3dCoord(cx, cy, i, 0, 0) GetGroundZFor_3dCoord(cx, cy, i)
                    cz = ToFloat(i)
                    groundFound = true
                    break
                end
            end
            if not groundFound then
                cz = -300.0
            end
            success = true
        else
            tARMA.notify('~r~Blip not found.')
        end
        if success then
            SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
            SetGameplayCamRelativeHeading(0)
            if IsPedSittingInAnyVehicle(PlayerPedId()) then
                if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
                    SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
                end
            end
            DoScreenFadeIn(250)
            tARMA.notify('~g~Teleported success!')
        end
    end)
end

RegisterNetEvent("TpToWaypoint")
AddEventHandler("TpToWaypoint", teleportToWaypoint)

RegisterCommand('staffmode', function()
    if tARMA.getStaffLevel() > 0 then
        tARMA.staffMode(not staffMode)
    end
end)

staffMode = false
local isInTicket = false
function tARMA.staffMode(status)
    staffMode = status

    if staffMode then
        tARMA.notify('~g~Staff Powerz Activated.')
        if GetEntityHealth(PlayerPedId())<=102 then 
            tARMA.RevivePlayer()
        end
        if weapons == nil then
            weapons = tARMA.getWeapons()
        end

        if clothing == nil then
            clothing = tARMA.getCustomization()
        end

        if armour == nil then
            armour = GetPedArmour(PlayerPedId())
        end

        if location == nil then
            location = GetEntityCoords(PlayerPedId())
        end
        staffClothing = tARMA.getCustomization()
        staffClothing[3]={0,0}
        staffClothing[4]={152,2}
        staffClothing[6]={141,0}
        staffClothing[8]={15,0}
        staffClothing[11]={442,0}
        tARMA.setCustomization(staffClothing)
    else
        tARMA.notify('~g~Staff Powerz Deactivated.')
        tARMA.setCustomization(clothing)
        tARMA.giveWeapons(weapons, true)
        weapons = nil
        clothing = nil
        SetTimeout(50, function()
            SetPedArmour(PlayerPedId(), armour)
        end)
    end
end

RegisterCommand("return", function()
    if staffMode then
        if location ~= nil then
            SetEntityCoords(PlayerPedId(), location)
            location = nil
            tARMA.notify("~g~Returned to position.")
        else
            tARMA.notify("~r~Unable to find last location!")
        end
        tARMA.staffMode(source, {false, false})
        isInTicket = false
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        if staffMode then 
            if not isInTicket then
                drawNativeText("~r~Reminder: You are /staffon'd.", 255, 0, 0, 255, true)
            end
            SetEntityInvincible(PlayerPedId(), true)
        end
    end
end)

RegisterNetEvent('ARMA:sendTicketInfo')
AddEventHandler('ARMA:sendTicketInfo', function(permid, name)
    if permid ~= nil and name ~= nil then
        isInTicket = true
    end
    while isInTicket do
        Wait(0)
        if permid ~= nil and name ~= nil then
            drawNativeText("~y~You've taken the ticket of " ..name.. "("..permid..")", 255, 0, 0, 255, true)   
        end
    end
end)


function drawNativeText(V)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(V)
    EndTextCommandPrint(100, 1)
end


RegisterCommand("dv", function()
    if staffMode or tARMA.isDev() then
        TriggerEvent( "wk:deleteVehicle" )
    else
        TriggerServerEvent('other:deletevehicle')
    end
end)


RegisterCommand("fix", function()
    if staffMode or tARMA.getStaffLevel() >= 6 then
        TriggerServerEvent( "wk:fixVehicle")
    end
end)

RegisterNetEvent("wk:fixVehicle")
AddEventHandler("wk:fixVehicle", function()
    local p = PlayerPedId()
    if IsPedInAnyVehicle(p) then
        local q = GetVehiclePedIsIn(p)
        SetVehicleEngineHealth(q, 9999)
        SetVehiclePetrolTankHealth(q, 9999)
        SetVehicleFixed(q)
        tARMA.notify('~g~Fixed Vehicle')
    end
end)

RegisterNetEvent("ARMA:showBlips")
AddEventHandler("ARMA:showBlips",function()
    blips = not blips
    if blips then
        tARMA.notify("~g~Blips enabled")
    else
        tARMA.notify("~r~Blips disabled")
        for k, v in ipairs(GetActivePlayers()) do
            local Q = GetPlayerPed(v)
            if GetPlayerPed(v) ~= PlayerPedId() then
                Q = GetPlayerPed(v)
                blip = GetBlipFromEntity(Q)
                RemoveBlip(blip)
            end
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        if blips then
            for k, v in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(v)
                if ped ~= PlayerPedId() then
                    local blip = GetBlipFromEntity(ped)
                    if not DoesBlipExist(blip) then
                        blip = AddBlipForEntity(ped)
                        SetBlipSprite(blip, 1)
                        Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true)
                        local R = GetVehiclePedIsIn(ped, false)
                        Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true)
                        SetBlipRotation(blip, math.ceil(GetEntityHeading(R)))
                        SetBlipNameToPlayerName(blip, P)
                        SetBlipScale(blip, 0.85)
                        SetBlipAlpha(blip, 255)
                    end
                end
            end
        end
        Wait(1000)
    end
end)


-- The distance to check in front of the player for a vehicle   
local distanceToCheck = 5.0

-- The number of times to retry deleting a vehicle if it fails the first time 
local numRetries = 5

-- Add an event handler for the deleteVehicle event. Gets called when a user types in /dv in chat
RegisterNetEvent("wk:deleteVehicle")
AddEventHandler("wk:deleteVehicle", function()
    local ped = GetPlayerPed( -1 )

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
        local pos = GetEntityCoords( ped )

        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then 
                DeleteGivenVehicle( vehicle, numRetries )
            else 
                tARMA.notify( "You must be in the driver's seat!" )
            end 
        else
            tARMA.notify( "You must be in a vehicle to delete it." )
        end 
    end 
end )

function DeleteGivenVehicle( veh, timeoutMax )
    local timeout = 0 

    SetEntityAsMissionEntity( veh, true, true )
    DeleteVehicle( veh )

    if ( DoesEntityExist( veh ) ) then
        tARMA.notify( "~r~Failed to delete vehicle, trying again..." )

        -- Fallback if the vehicle doesn't get deleted
        while ( DoesEntityExist( veh ) and timeout < timeoutMax ) do 
            DeleteVehicle( veh )

            -- The vehicle has been banished from the face of the Earth!
            if ( not DoesEntityExist( veh ) ) then 
                tARMA.notify( "~g~Vehicle deleted." )
            end 

            -- Increase the timeout counter and make the system wait
            timeout = timeout + 1 
            Citizen.Wait( 500 )

            -- We've timed out and the vehicle still hasn't been deleted. 
            if ( DoesEntityExist( veh ) and ( timeout == timeoutMax - 1 ) ) then
                tARMA.notify( "~r~Failed to delete vehicle after " .. timeoutMax .. " retries." )
            end 
        end 
    else 
        tARMA.notify( "~g~Vehicle deleted." )
    end 
end 

-- Gets a vehicle in a certain direction
-- Credit to Konijima
function GetVehicleInDirection( entFrom, coordFrom, coordTo )
	local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7 )
    local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
    
    if ( IsEntityAVehicle( vehicle ) ) then 
        return vehicle
    end 
end

function bank_drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end


