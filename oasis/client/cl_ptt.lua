local a = false
function func_ptt()
    if globalOnPoliceDuty and tOASIS.canAnim() and not noclipActive then
        local b = tOASIS.getPlayerPed()
        local c = tOASIS.getPlayerId()
        if a then
            if IsEntityPlayingAnim(b, "random@arrests", "generic_radio_enter", 3) then
                DisableActions(b)
            elseif IsEntityPlayingAnim(b, "random@arrests", "radio_chatter", 3) then
                DisableActions(b)
            end
            if not IsControlPressed(0, 19) and IsUsingKeyboard(2) and not IsPedReloading(b) then
                SendNUIMessage({transactionType = "radiooff"})
                ClearPedTasks(b)
                SetEnableHandcuffs(b, false)
                a = false
            end
        else
            if IsControlJustPressed(0, 19) and not IsPlayerFreeAiming(c) and IsUsingKeyboard(2) and not IsPedReloading(b) then
                SendNUIMessage({transactionType = "radioon"})
                tOASIS.loadAnimDict("random@arrests")
                TaskPlayAnim(b, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
                RemoveAnimDict("random@arrests")
                if not IsPedSwimming(b) and not IsPedSwimmingUnderWater(b) then
                    SetEnableHandcuffs(b, true)
                end
                a = true
            elseif
                IsControlJustPressed(0, 19) and IsPlayerFreeAiming(c) and IsUsingKeyboard(2) and not IsPedReloading(b)
             then
                SendNUIMessage({transactionType = "radioon"})
                tOASIS.loadAnimDict("random@arrests")
                TaskPlayAnim(b, "random@arrests", "radio_chatter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
                RemoveAnimDict("random@arrests")
                if not IsPedSwimming(b) and not IsPedSwimmingUnderWater(b) then
                    SetEnableHandcuffs(b, true)
                end
                a = true
            end
        end
    end
end
tOASIS.createThreadOnTick(func_ptt)
function DisableActions(b)
    DisableControlAction(1, 140, true)
    DisableControlAction(1, 141, true)
    DisableControlAction(1, 142, true)
    DisableControlAction(1, 37, true)
    DisablePlayerFiring(b, true)
end
local d = {[137473] = 2}
local e = false
local function f(g)
    local h = GetInteriorFromEntity(g.playerPed)
    local i = d[h]
    if i and not e then
        exports["pma-voice"]:setMaxProximityMode(i)
        e = true
    elseif not i and e then
        exports["pma-voice"]:cleOASISxProximityMode()
        e = false
    end
end
tOASIS.createThreadOnTick(f)
