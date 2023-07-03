local h = {
    ["demonhawkk"] = {1},
    ["rhys"] = {2},
}
local function i(j)
    DisableControlAction(0, 32, true)
    DisableControlAction(0, 33, true)
    DisableControlAction(0, 34, true)
    DisableControlAction(0, 35, true)
    DisableControlAction(0, 71, true)
    DisableControlAction(0, 72, true)
    DisableControlAction(0, 350, true)
    DisableControlAction(0, 351, true)
    SetVehicleRocketBoostPercentage(j, 0.0)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName("You have stalled the engine.")
    EndTextCommandThefeedPostTicker(false, false)
end
local function k()
    local j, l = tOASIS.getPlayerVehicle()
    local m = tOASIS.getUserId()
    if j ~= 0 and l and not tOASIS.isDev(m) then
        local e = GetEntityModel(j)
        for k,v in pairs(h) do
            if GetHashKey(k) == e then
                local o = false
                for f, p in pairs(v) do
                    if p == m then
                        o = true
                        break
                    end
                end
                if not o then
                    i(j)
                end
                return
            end
        end
    end
end
tOASIS.createThreadOnTick(k)