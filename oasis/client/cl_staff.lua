usingDelgun = false
local a = false
local c = function(d)
    local e = {}
    local f = GetGameTimer() / 200
    e.r = math.floor(math.sin(f * d + 0) * 127 + 128)
    e.g = math.floor(math.sin(f * d + 2) * 127 + 128)
    e.b = math.floor(math.sin(f * d + 4) * 127 + 128)
    return e
end
RegisterCommand("delgun",function()
    if tOASIS.getStaffLevel() > 0 then
        usingDelgun = not usingDelgun
        local g = tOASIS.getPlayerPed()
        local h = "WEAPON_STAFFGUN"
        if usingDelgun then
            a = HasPedGotWeapon(g, h, false)
            tOASIS.allowWeapon(h)
            GiveWeaponToPed(g, h, nil, false, true)
            Citizen.CreateThread(function()
                while usingDelgun do
                    Citizen.Wait(0)
                    drawNativeText("~b~Aim ~w~at an object and press ~b~Enter ~w~to delete it. ~r~Have fun!")
                end
            end)
            tOASIS.drawNativeNotification("Don't forget to use ~b~/delgun ~w~to disable the delete gun!")
        else
            if not a then
                RemoveWeaponFromPed(g, h)
            end
            a = false
        end
    end
end)

RegisterNetEvent("OASIS:returnObjectDeleted",function(i)
    drawNativeNotification(i)
end)

local j = 0
function func_staffDelGun(k)
    if usingDelgun then
        SetPlayerTargetingMode(2)
        j = j + 1
        if j > 1000 then
            j = 0
        end
        DisableControlAction(1, 18, true)
        DisablePlayerFiring(PlayerId(), true)
        if IsPlayerFreeAiming(PlayerId()) then
            local l, m = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if l then
                local n = GetEntityType(m)
                local o = true
                if o then
                    local p = GetEntityCoords(m)
                    local q = c(0.5)
                    DrawMarker(1,p.x,p.y,p.z - 1.02,0,0,0,0,0,0,0.7,0.7,1.5,q.r,q.g,q.b,200,0,0,2,0,0,0,0)
                    if IsDisabledControlJustPressed(1, 18) then
                        local r = NetworkGetNetworkIdFromEntity(m)
                        TriggerServerEvent("OASIS:delGunDelete", r)
                        if GetEntityType(m) == 2 then
                            SetEntityAsMissionEntity(m, false, true)
                            DeleteVehicle(m)
                        end
                    end
                end
            end
        end
    end
end
RegisterNetEvent("OASIS:deletePropClient",function(r)
    local s = tOASIS.getObjectId(r)
    if DoesEntityExist(s) then
        DeleteEntity(s)
    end
end)
tOASIS.createThreadOnTick(func_staffDelGun)
local t = {}
function tOASIS.isLocalPlayerHidden()
    if t[tOASIS.getUserId()] then
        return true
    else
        return false
    end
end
function tOASIS.isUserHidden(u)
    if t[u] and tOASIS.getUserId() ~= u then
        return true
    else
        return false
    end
end
RegisterNetEvent("OASIS:setHiddenUsers",function(v)
    t = v
end)