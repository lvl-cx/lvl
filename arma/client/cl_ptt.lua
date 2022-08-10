local a=false
function func_ptt()
    if tARMA.globalOnPoliceDuty() and tARMA.canAnim() and not globalSurrenderring then 
        local b=tARMA.getPlayerPed()
        local c=tARMA.getPlayerId()
        if IsControlJustReleased(0,19)and GetLastInputMethod(2)and tARMA.canAnim()and not IsPedReloading(b)then 
            TriggerEvent("arma:PlaySound", "radiooff")
            ClearPedTasks(b)
            SetEnableHandcuffs(b,false)
            a=false 
        else 
            if IsControlJustPressed(0,19)and not IsPlayerFreeAiming(c)and GetLastInputMethod(2)and tARMA.canAnim()and not IsPedReloading(b)then 
                TriggerEvent("arma:PlaySound", "radioon")
                tARMA.loadAnimDict("random@arrests")
                TaskPlayAnim(b,"random@arrests","generic_radio_enter",8.0,2.0,-1,50,2.0,0,0,0)
                if not IsPedSwimming(b)and not IsPedSwimmingUnderWater(b)then 
                    SetEnableHandcuffs(b,true)
                end
                a=true 
            elseif IsControlJustPressed(0,19)and IsPlayerFreeAiming(c)and GetLastInputMethod(2)and not IsPedReloading(b)then 
                TriggerEvent("arma:PlaySound", "radioon")
                tARMA.loadAnimDict("random@arrests")
                TaskPlayAnim(b,"random@arrests","radio_chatter",8.0,2.0,-1,50,2.0,0,0,0)
                if not IsPedSwimming(b)and not IsPedSwimmingUnderWater(b)then 
                    SetEnableHandcuffs(b,true)
                end
                a=true 
            end
            if a then 
                if IsEntityPlayingAnim(b,"random@arrests","generic_radio_enter",3)then 
                    DisableActions(b)
                elseif IsEntityPlayingAnim(b,"random@arrests","radio_chatter",3)then 
                    DisableActions(b)
                end 
            end 
        end 
    end 
end
tARMA.createThreadOnTick(func_ptt)
function DisableActions(b)
    DisableControlAction(1,140,true)
    DisableControlAction(1,141,true)
    DisableControlAction(1,142,true)
    DisableControlAction(1,37,true)
    DisablePlayerFiring(b,true)
end