local a = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [9] = true,
    [11] = true,
    [12] = true,
    [17] = true,
    [18] = true
}
local function b(vehicle)
    local c = GetActivePlayers()
    local d = tARMA.getPlayerCoords()
    for e, f in pairs(c) do
        local g = GetPlayerPed(f)
        local h = GetEntityCoords(g)
        local i = #(d - h)
        if i < 5 and IsEntityPlayingAnim(g, "timetable@floyd@cryingonbed@base", "base", 3) then
            return true
        end
    end
    return false
end
local j = false
function tARMA.isPlayerHidingInBoot()
    return j
end
Citizen.CreateThread(function()
    local k = 250
    while true do
        Citizen.Wait(k)
        local l = tARMA.getPlayerPed()
        local m = tARMA.getPlayerVehicle()
        local n = tARMA.getClosestVehicle(7.0)
        local o = GetVehicleClass(n)
        local p = GetVehicleDoorLockStatus(n)
        if m == 0 and a[o] and GetEntityHealth(tARMA.getPlayerPed()) > 102 and not noclipActive then
            if n and n ~= 0 then
                k = 0
                local q = GetEntityBoneIndexByName(n, "boot")
                local r = GetWorldPositionOfEntityBone(n, q)
                local s = #(r - tARMA.getPlayerCoords())
                if s < 2 then
                    DrawMarker(0,r.x,r.y,r.z,0.0,0.0,0.0,0.0,0.0,0.0,0.3,0.3,0.3,0,255,150,255,true)
                    drawNativeNotification("~s~~INPUT_VEH_PUSHBIKE_SPRINT~ to get inside the boot.")
                    if IsDisabledControlJustReleased(1, 137) and not tARMA.isHandcuffed() then
                        if not b(vehicle) then
                            if p <= 1 then
                                tARMA.setCanAnim(false)
                                tARMA.setWeapon(l, "WEAPON_UNARMED", true)
                                j = true
                                local t = GetEntityCoords(PlayerPedId())
                                local u = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                                SetCamCoord(u, t)
                                PointCamAtEntity(u, n)
                                SetCamActive(u, true)
                                RenderScriptCams(true, false, 0, true, true)
                                SetVehicleDoorOpen(n, 5, false, false)
                                RaiseConvertibleRoof(n, false)
                                AttachEntityToEntity(l,n,-1,0.0,-2.2,0.5,0.0,0.0,0.0,false,false,false,false,20,true)
                                ClearPedTasksImmediately(l)
                                Wait(100)
                                tARMA.loadAnimDict("timetable@floyd@cryingonbed@base")
                                TaskPlayAnim(l,"timetable@floyd@cryingonbed@base","base",1.0,-1,-1,1,0,0,0,0)
                                Wait(1000)
                                SetVehicleDoorShut(n, 5, false)
                                DestroyCam(u, 0)
                                RenderScriptCams(0, 0, 1, 1, 1)
                                AttachEntityToEntity(l,n,q,0.0,0.0,-0.5,0.0,0.0,0.0,false,false,false,false,20,true)
                                drawNativeNotification("~s~~INPUT_FRONTEND_RRIGHT~ To exit the boot.")
                                local v = true
                                local w = false
                                while v and j do
                                    DisableAllControlActions(0)
                                    DisableAllControlActions(1)
                                    DisableAllControlActions(2)
                                    EnableControlAction(0, 0, true)
                                    EnableControlAction(0, 249, true)
                                    EnableControlAction(2, 1, true)
                                    EnableControlAction(2, 2, true)
                                    EnableControlAction(0, 177, true)
                                    EnableControlAction(0, 200, true)
                                    if IsDisabledControlPressed(0, 177) then
                                        if GetVehicleDoorLockStatus(n) <= 1 then
                                            v = false
                                        else
                                            tARMA.notify("~r~Vehicle is locked, cannot get in boot.")
                                        end
                                    end
                                    if not DoesEntityExist(n) then
                                        v = false
                                    end
                                    if GetEntityHealth(l) <= 102 then
                                        v = false
                                    end
                                    if not IsEntityPlayingAnim(l, "timetable@floyd@cryingonbed@base", "base", 3) then
                                        TaskPlayAnim(l,"timetable@floyd@cryingonbed@base","base",1.0,-1,-1,1,0,0,0,0)
                                    end
                                    Wait(0)
                                end
                                j = false
                                DetachEntity(l, true, true)
                                SetEntityVisible(l, true, true)
                                ClearAllHelpMessages()
                                ClearPedTasks(PlayerPedId())
                                SetVehicleDoorOpen(n, 5, false, false)
                                tARMA.setCanAnim(true)
                                Wait(1000)
                                SetVehicleDoorShut(n, 5, false)
                            else
                                tARMA.notify("~r~Vehicle is locked, cannot get out of boot.")
                            end
                        else
                            tARMA.notify("~r~Someone is already in this boot.")
                        end
                    end
                else
                    ClearHelp(true)
                end
            else
                k = 250
            end
        end
    end
end)

RegisterNetEvent("CMG:removeHiddenInBoot",function()
    j = false
end)
