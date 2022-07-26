UnallowlistedVehicles = {
    -- ["SPAWNCODE"] = PERMID,

    -- [CALLUM CARS]
    ["sanchez"] = 1,
    ["tkmansory"] = 1,
    -- [OHASIS CARS]
    ["rs3d"] = 2,
    ["regaliad"] = 2,
    -- [MANAGEMENT CARS]
    ["tonkat"] = 3,
    ["takioman"] = 7,
    ["aivisman"] = 175,
    -- [PAID LOCKS]
    ["R8C"] = 5,
    ["urustc"] = 5,
    ["venatus"] = 16,
}

local userid = 0
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        for k,v in pairs(UnallowlistedVehicles) do
            if IsInVehicle() then
                if IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), GetHashKey(k)) then
                    if v ~= tARMA.userID() then
                        if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == 0 then
                            SetEntityCoords(GetPlayerPed(-1), GetEntityCoords(GetPlayerPed(-1)))
                            tARMA.notify("~r~You are not allowed in this vehicle.")
                        end
                    end
                end
            end
        end
    end
end)

function IsInVehicle()
    local ply = GetPlayerPed(-1)
    if IsPedSittingInAnyVehicle(ply) then
        return true
    else
        return false
    end
end

