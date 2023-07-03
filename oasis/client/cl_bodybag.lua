RegisterCommand("bodybag",function()
    local a = tOASIS.getNearestPlayer(3)
    if a then
        TriggerServerEvent("OASIS:requestBodyBag", a)
    else
        tOASIS.notify("No one dead nearby")
    end
end)

RegisterNetEvent("OASIS:removeIfOwned",function(b)
    local c = tOASIS.getObjectId(b, "bodybag_removeIfOwned")
    if c then
        if DoesEntityExist(c) then
            if NetworkHasControlOfEntity(c) then
                DeleteEntity(c)
            end
        end
    end
end)

RegisterNetEvent("OASIS:placeBodyBag",function()
    local d = tOASIS.getPlayerPed()
    local e = GetEntityCoords(d)
    local f = GetEntityHeading(d)
    SetEntityVisible(d, false, 0)
    local g = tOASIS.loadModel("xm_prop_body_bag")
    local h = CreateObject(g, e.x, e.y, e.z, true, true, true)
    DecorSetInt(h, "OASISACVeh", 955)
    PlaceObjectOnGroundProperly(h)
    SetModelAsNoLongerNeeded(g)
    local b = ObjToNet(h)
    TriggerServerEvent("OASIS:removeBodybag", b)
    while GetEntityHealth(tOASIS.getPlayerPed()) <= 102 do
        Wait(0)
    end
    DeleteEntity(h)
    SetEntityVisible(d, true, 0)
end)
