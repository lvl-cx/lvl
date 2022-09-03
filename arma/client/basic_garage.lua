local vehicles = {}


AllowMoreThenOneCar = true
function tARMA.spawnGarageVehicle(vtype, name, pos, vehiclename, vehicleplate) -- vtype is the vehicle type (one vehicle per type allowed at the same time)
    local vehicle = vehicles[GetHashKey(name)]
    if vehicle and not IsVehicleDriveable(vehicle[3]) then -- precheck if vehicle is undriveable
        -- despawn vehicle
        SetVehicleHasBeenOwnedByPlayer(vehicle[3], false)
        Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle[3], false, true) -- set not as mission entity
        SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle[3]))
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[3]))
        vehicles[GetHashKey(name)] = nil
    end

    vehicle = vehicles[GetHashKey(name)]
    if AllowMoreThenOneCar or vehicle == nil then
        -- load vehicle model
        local mhash = GetHashKey(name)

        local i = 0
        while not HasModelLoaded(mhash) and i < 10000 do
            RequestModel(mhash)
            Citizen.Wait(10)
            i = i + 1
        end

        -- spawn car
        if HasModelLoaded(mhash) then
            local x, y, z = tARMA.getPosition()
            if pos then
                x, y, z = table.unpack(pos)
            end

            local playerHeading = GetEntityHeading(PlayerPedId())
            local nveh = CreateVehicle(mhash, x, y, z + 0.5, 0.0, true, false)
            local as = nveh
            SetVehicleOnGroundProperly(nveh)
            SetEntityInvincible(nveh, false)
            SetPedIntoVehicle(GetPlayerPed(-1), nveh, -1) -- put player inside
            SetVehicleNumberPlateText(nveh, vehicleplate) -- gets individual plate for vehicle from parameter
            SetVehicleHasBeenOwnedByPlayer(nveh, true)
            SetEntityHeading(nveh, playerHeading)
            TriggerServerEvent("LSC:applyModifications", name, nveh)
            TriggerServerEvent("ARMA:PayVehicleTax")

            -- Network vehicle set to allow migration by default
            local nid = NetworkGetNetworkIdFromEntity(nveh)
            SetNetworkIdCanMigrate(nid, cfg.vehicle_migration)

            vehicles[vtype] = {vtype, name, nveh} -- set current vehicule
            print(name, nveh)

            Citizen.InvokeNative(0xAD738C3085FE7E11, as, true, true)
            SetVehicleHasBeenOwnedByPlayer(as, true)
            saveCarBlip = AddBlipForEntity(as)
            SetBlipSprite(saveCarBlip, 56)
            SetBlipDisplay(saveCarBlip, 4)
            SetBlipScale(saveCarBlip, 0.6)
            SetBlipColour(saveCarBlip, 2)
            SetBlipAsShortRange(saveCarBlip, true)

            CreateThread(function()
                local aJ = true;
                SetTimeout(5000, function()
                    aJ=false 
                end)
                while aJ do 
                    if DoesEntityExist(nveh) then 
                        Citizen.InvokeNative(0x5FFE9B4144F9712F,true)
                        SetNetworkVehicleAsGhost(nveh,true)
                        SetEntityAlpha(nveh,220)
                    end;
                Wait(0)
                end;
                    Citizen.InvokeNative(0x5FFE9B4144F9712F,false)
                    SetNetworkVehicleAsGhost(nveh,false)
                    SetEntityAlpha(nveh,255)
                    ResetEntityAlpha(nveh)
                end)
            SetModelAsNoLongerNeeded(mhash)
        end
    else
        tARMA.notify("~r~Vehicle " ..vehiclename.. " is already out.")
    end
end

function tARMA.despawnGarageVehicle(vtype, max_range)
    local vehicle = vehicles[vtype]
    if vehicle then
        local x, y, z = table.unpack(GetEntityCoords(vehicle[3], true))
        local px, py, pz = tARMA.getPosition()
        if GetDistanceBetweenCoords(x, y, z, px, py, pz, true) < max_range then -- check distance with the vehicule
            SetVehicleHasBeenOwnedByPlayer(vehicle[3], false)
            Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle[3], false, true) -- set not as mission entity
            SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle[3]))
            Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[3]))
            vehicles[vtype] = nil
            tARMA.notify("Vehicle stored.")
        else
            tARMA.notify("Too far away from the vehicle.")
        end
    end
end

-- (experimental) this function return the nearest vehicle
-- (don't work with all vehicles, but aim to)
function tARMA.getNearestVehicle(radius)
    local x, y, z = tARMA.getPosition()
    local ped = GetPlayerPed(-1)
    if IsPedSittingInAnyVehicle(ped) then
        return GetVehiclePedIsIn(ped, true)
    else
        -- flags used:
        --- 8192: boat
        --- 4096: helicos
        --- 4,2,1: cars (with police)

        local veh = GetClosestVehicle(x + 0.0001, y + 0.0001, z + 0.0001, radius + 0.0001, 0, 8192 + 4096 + 4 + 2 + 1) -- boats, helicos
        if not IsEntityAVehicle(veh) then
            veh = GetClosestVehicle(x + 0.0001, y + 0.0001, z + 0.0001, radius + 0.0001, 0, 4 + 2 + 1)
        end -- cars
        return veh
    end
end

function tARMA.fixeNearestVehicle(radius)
    local veh = tARMA.getNearestVehicle(radius)
    if IsEntityAVehicle(veh) then
        SetVehicleFixed(veh)
    end
end

function tARMA.replaceNearestVehicle(radius)
    local veh = tARMA.getNearestVehicle(radius)
    if IsEntityAVehicle(veh) then
        SetVehicleOnGroundProperly(veh)
    end
end

-- try to get a vehicle at a specific position (using raycast)
function tARMA.getVehicleAtPosition(x, y, z)
    x = x + 0.0001
    y = y + 0.0001
    z = z + 0.0001

    local ray = CastRayPointToPoint(x, y, z, x, y, z + 4, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, ent = GetRaycastResult(ray)
    return ent
end

-- return ok,vtype,name
function tARMA.getNearestOwnedVehicle(radius)
    local px, py, pz = tARMA.getPosition()
    for k, v in pairs(vehicles) do
        local x, y, z = table.unpack(GetEntityCoords(v[3], true))
        local dist = GetDistanceBetweenCoords(x, y, z, px, py, pz, true)
        -- {vtype,name,nveh} 
        if dist <= radius + 0.0001 then
            return true, v[1], v[2]
        end
    end

    return false, "", ""
end

-- return ok,x,y,z
function tARMA.getAnyOwnedVehiclePosition()
    for k, v in pairs(vehicles) do
        if IsEntityAVehicle(v[3]) then
            local x, y, z = table.unpack(GetEntityCoords(v[3], true))
            return true, x, y, z
        end
    end

    return false, 0, 0, 0
end

-- return x,y,z
function tARMA.getOwnedVehiclePosition(vtype)
    local vehicle = vehicles[vtype]
    local x, y, z = 0, 0, 0

    if vehicle then
        x, y, z = table.unpack(GetEntityCoords(vehicle[3], true))
    end

    return x, y, z
end

-- return ok, vehicule network id
function tARMA.getOwnedVehicleId(vtype)
    local vehicle = vehicles[vtype]
    if vehicle then
        return true, NetworkGetNetworkIdFromEntity(vehicle[3])
    else
        return false, 0
    end
end

-- eject the ped from the vehicle
function tARMA.ejectVehicle()
    local ped = GetPlayerPed(-1)
    if IsPedSittingInAnyVehicle(ped) then
        local veh = GetVehiclePedIsIn(ped, false)
        TaskLeaveVehicle(ped, veh, 4160)
    end
end

-- vehicle commands
function tARMA.vc_openDoor(vtype, door_index)
    local vehicle = vehicles[vtype]
    if vehicle then
        SetVehicleDoorOpen(vehicle[3], door_index, 0, false)
    end
end

function tARMA.vc_closeDoor(vtype, door_index)
    local vehicle = vehicles[vtype]
    if vehicle then
        SetVehicleDoorShut(vehicle[3], door_index)
    end
end

function tARMA.vc_detachTrailer(vtype)
    local vehicle = vehicles[vtype]
    if vehicle then
        DetachVehicleFromTrailer(vehicle[3])
    end
end

function tARMA.vc_detachTowTruck(vtype)
    local vehicle = vehicles[vtype]
    if vehicle then
        local ent = GetEntityAttachedToTowTruck(vehicle[3])
        if IsEntityAVehicle(ent) then
            DetachVehicleFromTowTruck(vehicle[3], ent)
        end
    end
end

function tARMA.vc_detachCargobob(vtype)
    local vehicle = vehicles[vtype]
    if vehicle then
        local ent = GetVehicleAttachedToCargobob(vehicle[3])
        if IsEntityAVehicle(ent) then
            DetachVehicleFromCargobob(vehicle[3], ent)
        end
    end
end

function tARMA.vc_toggleEngine(vtype)
    local vehicle = vehicles[vtype]
    if vehicle then
        local running = Citizen.InvokeNative(0xAE31E7DF9B5B132E, vehicle[3]) -- GetIsVehicleEngineRunning
        SetVehicleEngineOn(vehicle[3], not running, true, true)
        if running then
            SetVehicleUndriveable(vehicle[3], true)
        else
            SetVehicleUndriveable(vehicle[3], false)
        end
    end
end

function tARMA.vc_toggleLock(vtype)
    local vehicle = vehicles[vtype]
    if vehicle then
        local veh = vehicle[3]
        local locked = GetVehicleDoorLockStatus(veh) >= 2
        if locked then -- unlock
            SetVehicleDoorsLockedForAllPlayers(veh, false)
            SetVehicleDoorsLocked(veh, 1)
            SetVehicleDoorsLockedForPlayer(veh, PlayerId(), false)
            tARMA.notify("~r~Vehicle unlocked.")
        else -- lock
            SetVehicleDoorsLocked(veh, 2)
            SetVehicleDoorsLockedForAllPlayers(veh, true)
            tARMA.notify("~g~Vehicle locked.")
        end
    end
end

