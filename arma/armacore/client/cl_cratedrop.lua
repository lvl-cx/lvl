local models = {"p_cargo_chute_s", "sm_prop_smug_crate_s_narc", "titan", "s_m_m_pilot_02"}
local activeCrate = nil
local activeParachute = nil
local crateBlip, radiusBlip = nil

RegisterNetEvent("crateDrop")
AddEventHandler("crateDrop", function(c)
    TriggerEvent("removeCrate")
    for k,v in pairs(models) do
        tARMA.loadModel(v)
     end
    RequestWeaponAsset("weapon_flare")
    while not HasWeaponAssetLoaded("weapon_flare") do
        Wait(0)
    end

    local Coords = vector3(c.x, c.y, c.z)
    local area = math.random(0, 360) + 0.0
    local height = 1500.0
    local radius = area / 180.0 * 3.14
    local startToEnd = vector3(c.x, c.y, c.z) - vector3(math.cos(radius) * height, math.sin(radius) * height, -500.0)
    local n = c.x - startToEnd.x
    local o = c.y - startToEnd.y
    local heading = GetHeadingFromVector_2d(n, o)
    local aircraft = CreateVehicle("titan", startToEnd.x, startToEnd.y, startToEnd.z, heading, false, true)
    DecorSetInt(aircraft, "ARMAACVeh", 955)
    SetEntityHeading(aircraft, heading)
    SetVehicleDoorsLocked(aircraft, 2)
    SetEntityDynamic(aircraft, true)
    ActivatePhysics(aircraft)
    SetVehicleForwardSpeed(aircraft, 60.0)
    SetHeliBladesFullSpeed(aircraft)
    SetVehicleEngineOn(aircraft, true, true, false)
    ControlLandingGear(aircraft, 3)
    OpenBombBayDoors(aircraft)
    SetEntityProofs(aircraft, true, false, true, false, false, false, false, false)
    local pilotPed = CreatePedInsideVehicle(aircraft, 1, "s_m_m_pilot_02", -1, false, true)
    SetBlockingOfNonTemporaryEvents(pilotPed, true)
    SetPedRandomComponentVariation(pilotPed, false)
    SetPedKeepTask(pilotPed, true)
    SetTaskVehicleGotoPlaneMinHeightAboveTerrain(aircraft, 50)
    TaskVehicleDriveToCoord(pilotPed,aircraft,vector3(c.x, c.y, c.z) + vector3(0.0, 0.0, 500.0),60.0,0,"titan",262144,15.0,-1.0)
    local planeBlip = AddBlipForEntity(aircraft)
    SetBlipSprite(planeBlip, 307)
    SetBlipColour(planeBlip, 3)
    local s = vector2(c.x, c.y)
    local t = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
    while #(t - s) > 5.0 do
        Wait(100)
        t = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
    end
    TaskVehicleDriveToCoord(pilotPed, aircraft, 0.0, 0.0, 500.0, 60.0, 0, "titan", 262144, -1.0, -1.0)
    SetTimeout(30000,function()
        DeleteEntity(aircraft)
        DeleteEntity(pilotPed)
        RemoveBlip(planeBlip)
    end)

    activeCrate = CreateObject(GetHashKey(models[2]), Coords, false, true, true)

    SetEntityLodDist(activeCrate, 10000)
    ActivatePhysics(activeCrate)
    SetDamping(activeCrate, 2, 0.1)
    SetEntityVelocity(activeCrate, 0.0, 0.0, -0.3)

    activeParachute = CreateObject(GetHashKey(models[1]), Coords, false, true, true)
    SetEntityLodDist(activeParachute, 10000)
    SetEntityVelocity(activeParachute, 0.0, 0.0, -0.3)
    ActivatePhysics(activeCrate)
    AttachEntityToEntity(activeParachute, activeCrate, 0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    radiusBlip = AddBlipForRadius(Coords, 200.0)
    SetBlipColour(radiusBlip, 1)
    SetBlipAlpha(radiusBlip, 180)

    crateBlip = AddBlipForEntity(activeCrate)
    SetBlipSprite(crateBlip, 501)
    SetBlipColour(crateBlip, 2)

    while GetEntityHeightAboveGround(activeCrate) > 2 do
        Wait(100)
    end

 
    DetachEntity(activeParachute, true, true)
    DeleteEntity(activeParachute)
    ShootSingleBulletBetweenCoords(GetEntityCoords(activeCrate),GetEntityCoords(activeCrate) - vector3(0.0001, 0.0001, 0.0001),0,false,"weapon_flare",0,true,false,-1.0)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            local boxCoords = GetEntityCoords(activeCrate)
            local playerCoords = GetEntityCoords(PlayerPedId())

            if #(boxCoords - playerCoords) < 2.0 then
                if (IsControlJustPressed(1, 51)) then
                    if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
                        tARMA.loadAnimDict('amb@medic@standing@kneel@base')
                        tARMA.loadAnimDict('anim@gangops@facility@servers@bodysearch@')
                        TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
                        TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
                        tARMA.notify("~g~Looting Crate Drop...")
                        CreateThread(function()
                            tARMA.startCircularProgressBar("",15000,nil,function()end)
                        end)
                        ClearPedTasksImmediately(PlayerPedId())
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
                            if IsPedDeadOrDying(PlayerPedId(), true) == false then
                                TriggerServerEvent('openLootCrate', boxCoords, playerCoords)
                            else
                                tARMA.notify("~r~You are Dead!")
                            end
                        else
                        tARMA.notify("~r~You cannot loot while in a Vehicle!")
                        end
                    else

                        tARMA.notify("~r~You cannot loot while in a Vehicle!")
                    end

                end
            end
        end
    end)
end)

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

RegisterNetEvent("removeCrate")
AddEventHandler("removeCrate", function()
    if activeCrate then
        if DoesEntityExist(activeCrate) then
            DeleteEntity(activeCrate)
        end
        if DoesEntityExist(activeParachute) then
            DeleteEntity(activeParachute)
        end
        RemoveBlip(radiusBlip)
        RemoveBlip(crateBlip)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        DeleteEntity(activeCrate)
        DeleteEntity(activeParachute)
        RemoveBlip(crateBlip)
        RemoveBlip(radiusBlip)
    end
end)