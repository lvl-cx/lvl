local showMenu = false
local Entity = nil
local EntityType = nil
local crosshairStatus = false
local hideHud = false

RegisterNetEvent("ARMA:showHUD")
AddEventHandler("ARMA:showHUD",function(flag)
    hideHud = not flag
end)

function Crosshair(enable)
    if hideHud then
        SendNUIMessage({
            crosshair = false
        })
    else
        if not crosshairStatus and enable then
            crosshairStatus = true
            SendNUIMessage({
                crosshair = enable
            })
        elseif crosshairStatus and not enable then
            crosshairStatus = false
            SendNUIMessage({
                crosshair = enable
            })
        end
    end
end

RegisterNUICallback('disablenuifocus', function(data)
    showMenu = data.nuifocus
    SetNuiFocus(data.nuifocus, data.nuifocus)
end)

function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function RayCastGamePlayCamera(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, -1, 1))
	return b, c, e
end

function playerIsAlive()
    return GetEntityHealth(PlayerPedId()) > 102
end

Citizen.CreateThread(function()
    while true do
        hit, coords, Entity = RayCastGamePlayCamera(6.0)
        EntityType = GetEntityType(Entity)

        if EntityType then
            local playerPed = PlayerPedId()
            local playerVehicle = GetVehiclePedIsIn(playerPed,false)

            if playerIsAlive() and playerVehicle == 0 then
                if EntityType == 1 and Entity ~= playerPed and IsPedAPlayer(Entity) then
                    Crosshair(true)
                    if IsControlJustReleased(1, 38) then
                        if showMenu == false then
                            showMenu = true
                            SetNuiFocus(true, true)
                            SendNUIMessage({
                                openMenu = true,
                                type = "ped",
                                police = globalOnPoliceDuty or globalOnPrisonDuty,
                                entityId = Entity
                            })
                        end
                    end
                elseif EntityType == 2 and Entity ~= playerVehicle then
                    Crosshair(true)
                    if IsControlJustReleased(1, 38) then
                        if showMenu == false then
                            showMenu = true
                            SetNuiFocus(true, true)
                            -- SendNUIMessage({
                            --     menu = 'vehicle',
                            --     idEntity = Entity
                            -- })
                            SendNUIMessage({
                                openMenu = true,
                                type = "vehicle",
                                police = globalOnPoliceDuty or globalOnPrisonDuty,
                                entityId = Entity
                            })
                        end
                    end
                elseif EntityType == 3 then
                    local entityModel = GetEntityModel(Entity)
                    if `xs_prop_arena_bag_01` == entityModel then
                        Crosshair(true)
                        if IsControlJustReleased(1, 38) then
                            local id = DecorGetInt(Entity,"lootid")
                            TriggerServerEvent("ARMA:openLootbag",id)
                            Wait(1000)
                        end
                    elseif `prop_poly_bag_money` == entityModel then
                        Crosshair(true)
                        if IsControlJustReleased(1, 38) then
                            local id = DecorGetInt(Entity,"lootid")
                            TriggerServerEvent("ARMA:openLootbag2",id)
                            Wait(1000)
                        end
                    elseif `prop_box_ammo03a` == entityModel then
                        Crosshair(true)
                        if IsControlJustReleased(1, 38) then
                            local id = DecorGetInt(Entity,"lootid")
                            TriggerServerEvent("ARMA:openCrate",id)
                            Wait(1000)
                        end
                    elseif `xs_prop_arena_crate_01a` == entityModel then
                        Crosshair(true)
                        if IsControlJustReleased(1, 38) then
                            local id = DecorGetInt(Entity,"lootid")
                            TriggerServerEvent("ARMA:openCrate",id)
                            Wait(1000)
                        end
                    end
                else
                    Crosshair(false)
                end
            else
                Crosshair(false)
            end
        end
        Citizen.Wait(0)
	end
end)

function GetEntInFrontOfPlayer(Distance, Ped)
    local Ent = nil
    local CoA = GetEntityCoords(Ped, 1)
    local CoB = GetOffsetFromEntityInWorldCoords(Ped, 0.0, Distance, 0.0)
    local RayHandle = StartShapeTestRay(CoA.x, CoA.y, CoA.z, CoB.x, CoB.y, CoB.z, -1, Ped, 0)
    local A,B,C,D,Ent = GetRaycastResult(RayHandle)
    return Ent
end

-- Camera's coords
function GetCoordsFromCam(distance)
    local rot = GetGameplayCamRot(2)
    local coord = GetGameplayCamCoord()

    local tZ = rot.z * 0.0174532924
    local tX = rot.x * 0.0174532924
    local num = math.abs(math.cos(tX))

    newCoordX = coord.x + (-math.sin(tZ)) * (num + distance)
    newCoordY = coord.y + (math.cos(tZ)) * (num + distance)
    newCoordZ = coord.z + (math.sin(tX) * 8.0)
    return newCoordX, newCoordY, newCoordZ
end

-- Get entity's ID and coords from where player sis targeting
function Target(Distance, Ped)
    local Entity = nil
    local camCoords = GetGameplayCamCoord()
    local farCoordsX, farCoordsY, farCoordsZ = GetCoordsFromCam(Distance)
    local RayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, farCoordsX, farCoordsY, farCoordsZ, -1, Ped, 0)
    --DrawLine(camCoords.x, camCoords.y, camCoords.z, farCoordsX, farCoordsY, farCoordsZ,255,0,0,255)
    local A,B,C,D,Entity = GetRaycastResult(RayHandle)
    return Entity, farCoordsX, farCoordsY, farCoordsZ
end

function loadAnimDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(0)
	end
end

function lockCar(entityId)
    TriggerEvent("ARMA:lockNearestVehicle")
end

local savedBoot

function openBoot(entityId)
    savedBoot = entityId
    SetVehicleDoorOpen(entityId, 5, true)
    ExecuteCommand("inventory")
    trunkStatus = true
    SendNUIMessage({
        closeMenu = true
    })
    local soundId = GetSoundId()
    PlaySoundFrontend(soundId,"boot_pop","dlc_vw_body_disposal_sounds",true)
    ReleaseSoundId(soundId)
end

RegisterNetEvent("ARMA:clCloseTrunk")
AddEventHandler("ARMA:clCloseTrunk",function()
    if savedBoot then
        SetVehicleDoorShut(savedBoot, 5, true)
    end
end)

function cleanCar(entityId)
    local playerPed = PlayerPedId()
    if GetEntityHealth(playerPed) > 102 and not IsEntityDead(playerPed) then
		TaskStartScenarioInPlace(playerPed, 'world_human_maid_clean', 0, 1)
		Wait(10000)
		SetVehicleDirtLevel(entityId, 0.0)
		SetVehicleUndriveable(entityId, false)
		ClearPedSecondaryTask(playerPed)
		ClearPedTasks(playerPed)
	end
end

function lockpick(entityId)
    TriggerEvent("ARMA:verifyLockpick",entityId)
end

function repairVehicle(entityId)
    TriggerServerEvent("ARMA:attemptRepairVehicle")
end

local hoodStatus = false

function openHood(entityId)
    if not hoodStatus then
        SetVehicleDoorOpen(entityId, 4, false)
        hoodStatus = true
    else
        SetVehicleDoorShut(entityId, 4, false)
        hoodStatus = false
    end
end

function searchVehicle(entityId)
    if globalOnPoliceDuty then
        TriggerEvent("ARMA:searchClient",entityId)
    end
end

function impoundVehicle(entityId)
    if globalOnPoliceDuty then
        local user_id = tonumber(DecorGetInt(entityId, "ARMA_owner"))
        if user_id > 0 then
            exports.ARMA:impound(user_id, GetEntityModel(entityId), VehToNet(entityId),entityId)
        else
            TriggerEvent("ARMA:Notify","~r~Vehicle is not owned by anyone")
        end
    end
end

function askId(entityId)
    local player = GetPlayerByEntityID(entityId)
    local playerSrc = GetPlayerServerId(player)
    if playerSrc > 0 then
        TriggerServerEvent('ARMA:AskID')
    end
end

function giveCash(entityId)
    local player = GetPlayerByEntityID(entityId)
    local playerSrc = GetPlayerServerId(player)
    if playerSrc > 0 then
        TriggerServerEvent('ARMA:GiveMoney')
    end
end

function searchPlayer(entityId)
    local player = GetPlayerByEntityID(entityId)
    if not globalOnPoliceDuty and not globalOnPrisonDuty then
        local ped = GetPlayerPed(player)
        if ped ~= nil then
            if IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 3) or IsEntityPlayingAnim(ped, "random@arrests", "idle_2_hands_up", 3) or IsEntityPlayingAnim(ped, "random@arrests@busted", "idle_a", 3) then
                local playerSrc = GetPlayerServerId(player)
                if playerSrc > 0 then
                    TriggerServerEvent('ARMA:SearchPlr')
                end
            else
                TriggerEvent("ARMA:Notify","~r~Player must have their hands up or be on their knees!")
            end
        end
    else
        local playerSrc = GetPlayerServerId(player)
        if playerSrc > 0 then
            TriggerServerEvent('ARMA:SearchPlr')
        end
    end
end

local cpr_in_progress = false

function revive(entityId)
    local player = GetPlayerByEntityID(entityId)
    local playerSrc = GetPlayerServerId(player)
    if playerSrc > 0 then
        if globalOnNHSDuty then
            TriggerClientEvent('ARMA:cprAnim', player, nplayer)
        else
            if not cpr_in_progress then
                TriggerServerEvent("ARMA:attemptCPR",playerSrc)
                local ad = "missheistfbi3b_ig8_2"
                local ad2 = "cpr_loop_paramedic"
                RequestAnimDict(ad)
                RequestAnimDict(ad2)
                TaskPlayAnim(PlayerPedId(), ad, ad2, 8.0, 1.0, -1, 12, 0, 0, 0, 0 )
                cpr_in_progress = true
                Wait(15000)
                ClearPedSecondaryTask(PlayerPedId())
                cpr_in_progress = false
            else
                TriggerEvent("ARMA:Notify","~r~CPR in progress")
            end
        end
    end
end

function handcuff(entityId)
    if globalOnPoliceDuty or globalOnPrisonDuty then
        local player = GetPlayerByEntityID(entityId)
        local playerSrc = GetPlayerServerId(player)
        if playerSrc > 0 then
            ExecuteCommand("cuff")
        end
    end
end

function drag(entityId)
    if globalOnPoliceDuty or globalOnPrisonDuty then
        local player = GetPlayerByEntityID(entityId)
        local playerSrc = GetPlayerServerId(player)
        if playerSrc > 0 then
            TriggerServerEvent("ARMA:Drag",playerSrc)
        end
    end
end

function putInCar(entityId)
    if globalOnPoliceDuty or globalOnPrisonDuty then
        local player = GetPlayerByEntityID(entityId)
        local playerSrc = GetPlayerServerId(player)
        if playerSrc > 0 then
            TriggerServerEvent("ARMA:PutPlrInVeh",playerSrc)
        end
    end
end

function putOutOfCar(entityId)
    TriggerServerEvent("ARMA:TakeOutOfVehicle",playerSrc)
end

function jail(entityId)
    if globalOnPoliceDuty or globalOnPrisonDuty then
        local player = GetPlayerByEntityID(entityId)
        local playerSrc = GetPlayerServerId(player)
        if playerSrc > 0 then
            TriggerServerEvent("ARMA:Seize",playerSrc)
            TriggerServerEvent("ARMA:JailPlayer",playerSrc)
        end
    end
end

function seizeWeapons(entityId)
    if globalOnPoliceDuty or globalOnPrisonDuty then
        local player = GetPlayerByEntityID(entityId)
        local playerSrc = GetPlayerServerId(player)
        if playerSrc > 0 then
            TriggerServerEvent("ARMA:Seize",playerSrc)
        end
    end
end

function seizeillegals(entityId)
    if globalOnPoliceDuty or globalOnPrisonDuty then
        local player = GetPlayerByEntityID(entityId)
        local playerSrc = GetPlayerServerId(player)
        if playerSrc > 0 then
            TriggerServerEvent("ARMA:Seize",playerSrc)
        end
    end
end

RegisterNUICallback("radialClick", function(data)
    local menu = data.itemid
    local entityId = data.entity

    if menu == "lock" then
        lockCar(entityId)
    elseif menu == "openBoot" then
        openBoot(entityId)
    elseif menu == "cleanCar" then
        cleanCar(entityId)
    elseif menu == "lockpick" then
        lockpick(entityId)
    elseif menu == "repair" then
        repairVehicle(entityId)
    elseif menu == "openHood" then
        openHood(entityId)
    elseif menu == "searchvehicle" then
        searchVehicle(entityId)
    elseif menu == "impoundVehicle" then
        impoundVehicle(entityId)
    elseif menu == "askId" then
        askId(entityId)
    elseif menu == "giveCash" then
        giveCash(entityId)
    elseif menu == "search" then
        searchPlayer(entityId)
    elseif menu == "revive" then
        revive(entityId)
    elseif menu == "handcuff" then
        handcuff(entityId)
    elseif menu == "drag" then
        drag(entityId)
    elseif menu == "putincar" then
        putInCar(entityId)
    elseif menu == "getoutofcar" then
        putOutOfCar(entityId)
    elseif menu == "jail" then
        jail(entityId)
    elseif menu == "seizeweapons" then
        seizeWeapons(entityId)
    elseif menu == "seizeillegals" then
        seizeillegals(entityId)
    end
end)

function GetPlayerByEntityID(i)
	for _, id in ipairs(GetActivePlayers()) do
        if i == GetPlayerPed(id) then
            return id
        end
	end
	return nil
end

-- RegisterCommand("vehpara",function()
--     local vehicle = GetVehiclePedIsIn(PlayerPedId())
--     SetVehicleParachuteModel(vehicle,GetEntityModel(vehicle))
--     SetVehicleParachuteActive(vehicle,true)
--     print("DoesVehicleHaveParachute",DoesVehicleHaveParachute(vehicle))
-- end)