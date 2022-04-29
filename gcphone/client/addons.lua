--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 17-12-2018
-- Time: 00:39
-- Made for CiviliansNetwork
--
ATM = Proxy.getInterface("ATM")

RegisterNetEvent('service:call')
AddEventHandler('service:call', function(data)
    local playerPed   = GetPlayerPed(-1)
    local coords      = GetEntityCoords(playerPed)
    local message     = data.message
    local number      = data.number
    if message == nil then
        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 200)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(0);
        end
        if (GetOnscreenKeyboardResult()) then
            message =  GetOnscreenKeyboardResult()
        end
    end
    if message ~= nil and message ~= "" then
        TriggerServerEvent('service:startCall', number, message, {
            x = coords.x,
            y = coords.y,
            z = coords.z
        })
    end
end)