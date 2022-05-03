local function Bool(num) 
    return num == 1 or num == true
end

local headBones = {
    [31086] = true --Head
}

local bodyBones = {
    [40269] = true, --Right Shoulder
    [28252] = true, --Right Arm
    [24818] = true, --Right Arm
    [45509] = true, --Left Shoulder
    [61163] = true, --Left Arm
    [10706] = true, --Left Arm
    [65245] = true, --Foot
    [63931] = true, --Leg
    [57597] = true, --Leg
    [58271] = true, --Leg
    [51826] = true, --Leg
    [36864] = true, --Leg
    [24816] = true, --Chest
    [24817] = true, --Chest
    [24819] = true, --Chest
    [14201] = true, --Foot
    [52301] = true, --Foot
    [18905] = true, --Hand
    [57005] = true, --Hand
    [39317] = true, --Neck
    [64729] = true, --Neck
}

local playHeadshotSounds = false

RegisterCommand("hs", function()
    playHeadshotSounds = not playHeadshotSounds
    if playHeadshotSounds then
        LVLNotify("~y~Experimental Hitmarkers Are Now ~b~Enabled")
    else
        LVLNotify("~y~Experimental Hitmarkers Are Now ~r~Disabled")
    end
end)



RegisterNetEvent("LVL:Settings:Hitsounds")
AddEventHandler("LVL:Settings:Hitsounds", function(bool)
    playHeadshotSounds = bool
    if playHeadshotSounds then
        LVLNotify("~y~Experimental Hitmarkers Are Now ~b~Enabled")
    else
        LVLNotify("~y~Experimental Hitmarkers Are Now ~r~Disabled")
    end
end)


RegisterNetEvent("LVL:ComingSoon")
AddEventHandler("LVL:ComingSoon", function()
    LVLNotify("~r~Error: ~w~This Feature Is Coming Soon")
end)

RegisterNetEvent("LVLCli:Notify")
AddEventHandler("LVLCli:Notify", function(txt)
    LVLNotify(txt)
end)





local ped = GetPlayerPed(-1)
Citizen.CreateThread(function ()
    while true do
        if playHeadshotSounds then
            local targeted, entity = GetEntityPlayerIsFreeAimingAt(GetPlayerIndex(), 0)
            if targeted then
                if IsPedShooting(PlayerPedId()) then
                    local hit, bone = GetPedLastDamageBone(entity)
                    hit = Bool(hit)
                    if hit then
                        if headBones[bone] then
                            SendNUIMessage({
                                transactionType = "headshot",
                            })
                            --if GetSelectedPedWeapon(ped) == GetHashKey("weapon_stungun") then
                                --TriggerEvent("LVL:PDSideTazer")
                            --end
                        elseif bodyBones[bone] then
                            SendNUIMessage({
                                transactionType = "bodyshot",
                            })
                            --if GetSelectedPedWeapon(ped) == GetHashKey("weapon_stungun") then
                                --TriggerEvent("LVL:PDSideTazer")
                           --end
                        end
                        Wait(100)
                    end
                end
            end
        end
		Wait(0)
	end
end)


RegisterNetEvent("LVL:PlaySound")
AddEventHandler("LVL:PlaySound", function(soundname)

    SendNUIMessage({
        transactionType = soundname,
    })
    
end)



function LVLNotify(u)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(u)
    DrawNotification(false, false)
end