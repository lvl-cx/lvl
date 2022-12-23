local a = false
local function c()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end
tARMA.createThreadOnTick(c)

Citizen.CreateThread(function()
    while true do
        if IsControlJustReleased(0, 20) then
            a = not a
            SetRadarBigmapEnabled(a, false)
        end
        Citizen.Wait(0)
    end
end)