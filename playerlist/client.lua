local isOpen = false
local helpShown = false

local playerCache = nil

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)
        
        if isOpen then
            if IsPauseMenuActive() then
                isOpen = false
                enableUI(false)
            else
                if IsControlJustReleased(1, 189, true) then -- left
                    SendNUIMessage({
                        show = true,
                        switch = false
                    })
                elseif IsControlJustReleased(1, 190, true) then -- right
                    SendNUIMessage({
                        show = true,
                        switch = true
                    })
                end

                DisableControlAction(0, 37, true)
                DisableControlAction(0, 45, true)
                DisableControlAction(0, 170, true)
                DisableControlAction(0, 192, true)
                DisableControlAction(0, 344, true)
                DisableControlAction(0, 36, true)
                DisableControlAction(0, 23, true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 182, true)
                DisablePlayerFiring(GetPlayerPed(-1), true)
                HideHudComponentThisFrame(14)
            end
        end
        
		if IsControlJustReleased(1, 212, true) then
            toggleMenu()
		end
	end
end)

function enableUI(enabled, data)
    SendNUIMessage({
        show = enabled,
        players = data
    })

    SetNuiFocus(true, enabled)
    SetNuiFocusKeepInput(true)

    -- help text
    if enabled and not helpShown then
        if IsHelpMessageBeingDisplayed() == false then -- low priority help message
            BeginTextCommandDisplayHelp("STRING");
            AddTextComponentString("Use ~INPUT_FRONTEND_LEFT~ ~INPUT_FRONTEND_RIGHT~ to switch between tabs.");
            EndTextCommandDisplayHelp(0, false, true, 5000);

            helpShown = true
        end
    end
end

function toggleMenu()
    isOpen = not isOpen
    enableUI(isOpen, playerCache)
end

RegisterNetEvent("playerlist:getdata")
AddEventHandler('playerlist:getdata', function(data)
    playerCache = data

    if isOpen then -- update list if open
        SendNUIMessage({
            show = true,
            players = data
        })
    end
end)

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
        return
    end

    TriggerServerEvent("playerlist:update")
end)

