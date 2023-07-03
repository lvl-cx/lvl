local a = GetGameTimer()
RegisterNetEvent("OASIS:spawnNitroBMX",function()
    if not tOASIS.isInComa() and not tOASIS.isHandcuffed() and not insideDiamondCasino then --and not isPlayerNearPrison() then
        if GetTimeDifference(GetGameTimer(), a) > 10000 then
            a = GetGameTimer()
            tOASIS.notify("~g~Crafting a BMX")
            local b = tOASIS.getPlayerPed()
            TaskStartScenarioInPlace(b, "WORLD_HUMAN_HAMMERING", 0, true)
            Wait(5000)
            ClearPedTasksImmediately(b)
            local c = GetEntityCoords(b)
            tOASIS.spawnVehicle("bmx", c.x, c.y, c.z, GetEntityHeading(b), true, true, true)
        else
            tOASIS.notify("~r~Nitro BMX cooldown, please wait.")
        end
    else
        tOASIS.notify("~r~Cannot craft a BMX right now.")
    end
end)
RegisterNetEvent("OASIS:spawnMoped",function()
    if not tOASIS.isInComa() and not tOASIS.isHandcuffed() and not insideDiamondCasino then --and not isPlayerNearPrison() then
        if GetTimeDifference(GetGameTimer(), a) > 10000 then
            a = GetGameTimer()
            tOASIS.notify("~g~Crafting a Moped")
            local b = tOASIS.getPlayerPed()
            TaskStartScenarioInPlace(b, "WORLD_HUMAN_HAMMERING", 0, true)
            Wait(5000)
            ClearPedTasksImmediately(b)
            local c = GetEntityCoords(b)
            tOASIS.spawnVehicle("faggio", c.x, c.y, c.z, GetEntityHeading(b), true, true, true)
        else
            tOASIS.notify("~r~Nitro BMX cooldown, please wait.")
        end
    else
        tOASIS.notify("~r~Cannot craft a Moped right now.")
    end
end)
