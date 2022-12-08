RegisterCommand("piggy",function()
    if tARMA.getUserId() == 1 then
        local a = tARMA.getPlayerPed()
        if not IsPedInAnyPoliceVehicle(a) then
            local b = tARMA.loadModel("a_c_pig")
            local c = GetOffsetFromEntityInWorldCoords(a, 0.0, 1.0, 0.0)
            local d = GetEntityHeading(a)
            local e = CreatePed(28, b, c.x, c.y, c.z, d, true, true)
            SetModelAsNoLongerNeeded(b)
            Wait(2000)
            if DoesEntityExist(e) then
                SetBlockingOfNonTemporaryEvents(e, true)
                SetPedMoveRateOverride(e, 38.0)
                GiveWeaponToPed(e, GetHashKey("WEAPON_ANIMAL"), 200, true, true)
                local f = {0, 3, 5, 46}
                for g, h in pairs(f) do
                    SetPedFleeAttributes(e, h, true)
                end
                local i = AddBlipForEntity(e)
                local j = 61
                SetBlipSprite(i, 526)
                SetBlipColour(i, j)
                SetBlipScale(i, 1.0)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName("Piggy")
                EndTextCommandSetBlipName(i)
                SetBlipAsFriendly(i, true)
                SetBlipBright(i, true)
                TaskFollowToOffsetOfEntity(e, tARMA.getPlayerPed(), 0.0, 0.0, 0.0, 7.0, -1, 10.0, true)
            end
        end
    end
end)
RegisterCommand("rat",function()
    if tARMA.getUserId() == 1 then
        local a = tARMA.getPlayerPed()
        if not IsPedInAnyPoliceVehicle(a) then
            local b = tARMA.loadModel("a_c_rat")
            local c = GetOffsetFromEntityInWorldCoords(a, 0.0, 1.0, 0.0)
            local d = GetEntityHeading(a)
            local e = CreatePed(28, b, c.x, c.y, c.z, d, true, true)
            SetModelAsNoLongerNeeded(b)
            Wait(2000)
            if DoesEntityExist(e) then
                SetBlockingOfNonTemporaryEvents(e, true)
                SetPedMoveRateOverride(e, 38.0)
                GiveWeaponToPed(e, GetHashKey("WEAPON_ANIMAL"), 200, true, true)
                local f = {0, 3, 5, 46}
                for g, h in pairs(f) do
                    SetPedFleeAttributes(e, h, true)
                end
                local i = AddBlipForEntity(e)
                local j = 61
                SetBlipSprite(i, 526)
                SetBlipColour(i, j)
                SetBlipScale(i, 1.0)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName("Rat")
                EndTextCommandSetBlipName(i)
                SetBlipAsFriendly(i, true)
                SetBlipBright(i, true)
                TaskFollowToOffsetOfEntity(e, tARMA.getPlayerPed(), 0.0, 0.0, 0.0, 7.0, -1, 10.0, true)
            end
        end
    end
end)
