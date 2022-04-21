local comaAnim = {}
local in_coma = false
local coma_left = 2
local secondsTilBleedout = 2
local playerCanRespawn = false 
local calledNHS = false
local deathString = ""
local deathPosition

local comaAnim = {}
local DeathAnim = 100

Citizen.CreateThread(function()
  while true do 
    if IsDisabledControlJustPressed(0,38) then
      if playerCanRespawn and in_coma and secondsTilBleedout < 2 then
        tSentry.respawnPlayer()
      end
      Wait(1000)
    end
    Wait(0)
  end
end)

function tSentry.setArmour(armour)
    SetPedArmour(PlayerPedId(), armour)
end


Citizen.CreateThread(function() -- coma thread
    Wait(500)
    exports.spawnmanager:setAutoSpawn(false)
    while true do
        Wait(0)
        local ped = GetPlayerPed(-1)
        local health = GetEntityHealth(ped)
        if IsEntityDead(GetPlayerPed(-1)) and not in_coma then --Wait for death check
            pbCounter = 100
            local plyCoords = GetEntityCoords(GetPlayerPed(-1),true)

            Sentryserver.StoreWeaponsDead()
            Sentryserver.Coma()
            TriggerEvent('Sentry:IsInMoneyComa', true)
            TriggerServerEvent('Sentry:InComa')
            Sentryserver.MoneyDrop()
            TriggerEvent('Sentry:3Seconds')

            --TriggerServerEvent("Server:SoundToRadius", source, 20.0f, "Untitled", 0.4f);
            TriggerServerEvent("Server:SoundToCoords", plyCoords.x, plyCoords.y, plyCoords.z, 60.0, "Untitled", 0.4);
            --TriggerServerEvent("playGlobalSound",plyCoords.x, plyCoords.y, plyCoords.z,"playDead")
            tSentry.ejectVehicle()
            in_coma = true
            deathPosition = plyCoords
            local x,y,z = table.unpack(deathPosition)
            Sentryserver.updatePos({x,y,z})
            Sentryserver.updateHealth({0})
            Wait(250) --Need wait, otherwise will autorevive in next check
        end

        if DeathAnim <= 0  then --Been 10 seconds, proceed to play anim check 
            DeathAnim = 100 
            local entityDead = GetEntityHealth(GetPlayerPed(-1))
            while entityDead <= 100 do
                Wait(0)
                local x,y,z = tSentry.getPosition()
                NetworkResurrectLocalPlayer(x, y, z, GetEntityHeading(GetPlayerPed(-1)), true, true, false)
                entityDead = GetEntityHealth(GetPlayerPed(-1))
            end
            SetEntityHealth(GetPlayerPed(-1), 102)
            SetEntityInvincible(GetPlayerPed(-1),true)
            comaAnim = getRandomComaAnimation()
            if not HasAnimDictLoaded(comaAnim.dict) then
                RequestAnimDict(comaAnim.dict)
                while not HasAnimDictLoaded(comaAnim.dict) do
                    Wait(0)
                end
            end
            TaskPlayAnim(GetPlayerPed(-1), comaAnim.dict, comaAnim.anim, 3.0, 1.0, -1, 1, 0, 0, 0, 0 )
        end

        if health > cfg.coma_threshold and in_coma then --Revive check
            if IsEntityDead(GetPlayerPed(-1)) then
                local x,y,z = tSentry.getPosition()
                NetworkResurrectLocalPlayer(x, y, z, GetEntityHeading(GetPlayerPed(-1)), true, true, false)
                Wait(0)
            end
        
            playerCanRespawn = false 
            DeathString = ""
            tSentry.disableComa()
            DeathAnim = 100 

            SetEntityInvincible(GetPlayerPed(-1),false)
            ClearPedSecondaryTask(GetPlayerPed(-1))
            Citizen.CreateThread(function()
                Wait(500)
                ClearPedSecondaryTask(GetPlayerPed(-1))
                ClearPedTasks(GetPlayerPed(-1))
            end)    
        end 

        local health = GetEntityHealth(GetPlayerPed(-1))
        if health <= cfg.coma_threshold and not in_coma then 
            SetEntityHealth(GetPlayerPed(-1),0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if in_coma then
            local playerPed = PlayerPedId()
            if not IsEntityDead(playerPed) then
                if comaAnim.dict == nil then
                    comaAnim = getRandomComaAnimation()
                end
                if not IsEntityPlayingAnim(playerPed,comaAnim.dict,comaAnim.anim,3)  then
                    if comaAnim.dict ~= nil then
                        if not HasAnimDictLoaded(comaAnim.dict) then
                            RequestAnimDict(comaAnim.dict)
                            while not HasAnimDictLoaded(comaAnim.dict) do
                                Wait(0)
                            end
                        end
                        TaskPlayAnim(playerPed, comaAnim.dict, comaAnim.anim, 3.0, 1.0, -1, 1, 0, 0, 0, 0 )
                    end
                end
            end
            if GetEntityHealth(playerPed) > cfg.coma_threshold then 
                tSentry.disableComa()
                if IsEntityDead(playerPed) then
                    local x,y,z = tSentry.getPosition()
                    NetworkResurrectLocalPlayer(x, y, z, GetEntityHeading(GetPlayerPed(-1)),true, true, false)
                    Wait(0)
                end
                tSentry.disableComa()
                DeathAnim = 100 
                DeathString = ""
                SetEntityInvincible(playerPed,false)
                ClearPedSecondaryTask(playerPed) 
            end
        end
        Wait(0)
    end
end)

function Initialize(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieFunctionParameterString(DeathString)
    PushScaleformMovieFunctionParameterString(" ")
    PopScaleformMovieFunctionVoid()
    return scaleform
end


Citizen.CreateThread(function()
    while true do 
        if in_coma then

            scaleform = Initialize("mp_big_message_freemode")
		    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
   
        
		  
            if secondsTilBleedout > 0 then
                DrawAdvancedTextOutline(0.605, 0.523, 0.005, 0.0028, 0.4, "Respawn available in ("..secondsTilBleedout.." seconds)", 255, 255, 255, 255, 7, 0)
                DrawAdvancedTextOutline(0.605, 0.554, 0.005, 0.0028, 0.37, "You are dying...", 255, 255, 255, 255, 6, 0)
            else
                playerCanRespawn = true
                DrawAdvancedTextOutline(0.605, 0.523, 0.005, 0.0028, 0.4, "Press [E] to respawn!", 255, 255, 255, 255, 7, 0)
            end
            DisableControlAction(0,323,true)
            DisableControlAction(0,182,true)
            DisableControlAction(0,37,true)
        end
        Wait(0)
    end 
end)

Citizen.CreateThread(function()
    while true do 
        if in_coma then
            secondsTilBleedout = secondsTilBleedout - 1
        end
        Wait(1000)
    end
end) 

Citizen.CreateThread(function()
    while DeathAnim <= 3 and DeathAnim >= 0 do
        Wait(1000)
        DeathAnim = DeathAnim - 1
    end
end) 

RegisterNetEvent("Sentry:3Seconds")
AddEventHandler("Sentry:3Seconds", function()
    DeathAnim = 3
    while DeathAnim <= 3 and DeathAnim >= 0 do
        Wait(1000)
        DeathAnim = DeathAnim - 1
    end
end)

function tSentry.respawnPlayer()
    
    exports.spawnmanager:spawnPlayer()
    playerCanRespawn = false 
    DeathString = ""
    secondsTilBleedout = 30
    
    local ped = GetPlayerPed(-1)
    tSentry.reviveComa()
end


function tSentry.disableComa()
    in_coma = false
end

function tSentry.isInComa()
    return in_coma
end

RegisterNetEvent("Sentry:FixClient")
AddEventHandler("Sentry:FixClient", function()
    local resurrectspamm = true
    Citizen.CreateThread(function()
        while true do 
            Wait(0)
            if resurrectspamm == true then
                DoScreenFadeOut(500)
                Citizen.Wait(500)
                local ped = PlayerPedId()
                local x,y,z = GetEntityCoords(ped)
                respawnedrecent = false 
                NetworkResurrectLocalPlayer(x, y, z, true, true, false)
                Citizen.Wait(0)
                calledNHS = false
                ClearPedTasksImmediately(PlayerPedId())
                resurrectspamm = false
                secondsTilBleedout = 60
                in_coma = false
                EnableControlAction(0, 73, true)
                tSentry.stopScreenEffect(cfg.coma_effect)
                DoScreenFadeIn(500)
                Citizen.Wait(500)
            end 
        end
    end)
end)

function tSentry.reviveComa()
    local ped = GetPlayerPed(-1)
    SetEntityInvincible(ped,false)
    tSentry.setRagdoll(false)
    tSentry.stopScreenEffect(cfg.coma_effect)
    SetEntityHealth(GetPlayerPed(-1), 200) 
end

-- kill the player if in coma
function tSentry.killComa()
    if in_coma then
        coma_left = 0
    end
end

Citizen.CreateThread(function() -- disable health regen, conflicts with coma system
    while true do
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        Wait(0)
    end
end)


Citizen.CreateThread(function()
    local DeathReason, Killer, DeathCauseHash, Weapon

    while true do
        Citizen.Wait(0)
        if IsEntityDead(PlayerPedId()) then
            Citizen.Wait(500)
            local PedKiller = GetPedSourceOfDeath(PlayerPedId())
            DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())
            Weapon = WeaponNames[tostring(DeathCauseHash)]

            if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
                Killer = NetworkGetPlayerIndexFromPed(PedKiller)
            elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
                Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
            end
            
            if (Killer == PlayerId()) then
                DeathReason = 'committed suicide'
            elseif (Killer == nil) then
                DeathReason = 'died'
            else
                if IsMelee(DeathCauseHash) then
                    DeathReason = 'murdered'
                elseif IsTorch(DeathCauseHash) then
                    DeathReason = 'torched'
                elseif IsKnife(DeathCauseHash) then
                    DeathReason = 'knifed'
                elseif IsPistol(DeathCauseHash) then
                    DeathReason = 'pistoled'
                elseif IsSub(DeathCauseHash) then
                    DeathReason = 'riddled'
                elseif IsRifle(DeathCauseHash) then
                    DeathReason = 'rifled'
                elseif IsLight(DeathCauseHash) then
                    DeathReason = 'machine gunned'
                elseif IsShotgun(DeathCauseHash) then
                    DeathReason = 'pulverized'
                elseif IsSniper(DeathCauseHash) then
                    DeathReason = 'sniped'
                elseif IsHeavy(DeathCauseHash) then
                    DeathReason = 'obliterated'
                elseif IsMinigun(DeathCauseHash) then
                    DeathReason = 'shredded'
                elseif IsBomb(DeathCauseHash) then
                    DeathReason = 'bombed'
                elseif IsVeh(DeathCauseHash) then
                    DeathReason = 'mowed over'
                elseif IsVK(DeathCauseHash) then
                    DeathReason = 'flattened'
                else
                    DeathReason = 'killed'
                end
            end
            
            if DeathReason == 'committed suicide' or DeathReason == 'died' then
                --TriggerServerEvent('DiscordBot:PlayerDied', GetPlayerName(PlayerId()) .. ' ' .. DeathReason .. '.', Weapon)
                DeathString = "~r~You committed suicide"
            else
                --TriggerServerEvent('DiscordBot:PlayerDied', GetPlayerName(Killer) .. ' ' .. DeathReason .. ' ' .. GetPlayerName(PlayerId()) .. '.', Weapon)
                DeathString = "~r~You were " .. DeathReason .. " by " .. GetPlayerName(Killer) .. " with a " .. tostring(Weapon)
            end
            Killer = nil
            DeathReason = nil
            DeathCauseHash = nil
            Weapon = nil
        end
        while IsEntityDead(PlayerPedId()) do
            Citizen.Wait(0)
        end
    end
end)

function IsMelee(Weapon)
    local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
    for i, CurrentWeapon in ipairs(Weapons) do
        if GetHashKey(CurrentWeapon) == Weapon then
            return true
        end
    end
    return false
end

function IsTorch(Weapon)
    local Weapons = {'WEAPON_MOLOTOV'}
    for i, CurrentWeapon in ipairs(Weapons) do
        if GetHashKey(CurrentWeapon) == Weapon then
            return true
        end
    end
    return false
end

function IsKnife(Weapon)
    local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
    for i, CurrentWeapon in ipairs(Weapons) do
        if GetHashKey(CurrentWeapon) == Weapon then
            return true
        end
    end
    return false
end

function IsPistol(Weapon)
    local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'}
    for i, CurrentWeapon in ipairs(Weapons) do
        if GetHashKey(CurrentWeapon) == Weapon then
            return true
        end
    end
    return false
end

function IsSub(Weapon)
    local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
    for i, CurrentWeapon in ipairs(Weapons) do
        if GetHashKey(CurrentWeapon) == Weapon then
            return true
        end
    end
    return false
end

function IsRifle(Weapon)
    local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
    for i, CurrentWeapon in ipairs(Weapons) do
        if GetHashKey(CurrentWeapon) == Weapon then
            return true
        end
    end
    return false
end

function IsLight(Weapon)
    local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
    for i, CurrentWeapon in ipairs(Weapons) do
        if GetHashKey(CurrentWeapon) == Weapon then
            return true
        end
    end
    return false
end

function IsShotgun(Weapon)
    local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
    for i, CurrentWeapon in ipairs(Weapons) do
        if GetHashKey(CurrentWeapon) == Weapon then
            return true
        end
    end
    return false
end

function IsSniper(Weapon)
    local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
    for i, CurrentWeapon in ipairs(Weapons) do
        if GetHashKey(CurrentWeapon) == Weapon then
            return true
        end
    end
    return false
end

function IsHeavy(Weapon)
    local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
    for i, CurrentWeapon in ipairs(Weapons) do
        if GetHashKey(CurrentWeapon) == Weapon then
            return true
        end
    end
    return false
end

function IsMinigun(Weapon)
    local Weapons = {'WEAPON_MINIGUN'}
    for i, CurrentWeapon in ipairs(Weapons) do
        if GetHashKey(CurrentWeapon) == Weapon then
            return true
        end
    end
    return false
end

function IsBomb(Weapon)
    local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB'}
    for i, CurrentWeapon in ipairs(Weapons) do
        if GetHashKey(CurrentWeapon) == Weapon then
            return true
        end
    end
    return false
end

function IsVeh(Weapon)
    local Weapons = {'VEHICLE_WEAPON_ROTORS'}
    for i, CurrentWeapon in ipairs(Weapons) do
        if GetHashKey(CurrentWeapon) == Weapon then
            return true
        end
    end
    return false
end

function IsVK(Weapon)
    local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
    for i, CurrentWeapon in ipairs(Weapons) do
        if GetHashKey(CurrentWeapon) == Weapon then
            return true
        end
    end
    return false
end


WeaponNames = {
    [tostring(GetHashKey('WEAPON_UNARMED'))] = 'Fists',
    [tostring(GetHashKey('WEAPON_KNIFE'))] = 'Knife',
    [tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Nightstick',
    [tostring(GetHashKey('WEAPON_HAMMER'))] = 'Hammer',
    [tostring(GetHashKey('WEAPON_BAT'))] = 'Baseball Bat',
    [tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'Golf Club',
    [tostring(GetHashKey('WEAPON_CROWBAR'))] = 'Crowbar',
    [tostring(GetHashKey('WEAPON_PISTOL'))] = 'Pistol',
    [tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Combat Pistol',
    [tostring(GetHashKey('WEAPON_APPISTOL'))] = 'AP Pistol',
    [tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistol .50',
    [tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Micro SMG',
    [tostring(GetHashKey('WEAPON_SMG'))] = 'SMG',
    [tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'Assault SMG',
    [tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'Assault Rifle',
    [tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'Carbine Rifle',
    [tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Advanced Rifle',
    [tostring(GetHashKey('WEAPON_MG'))] = 'MG',
    [tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Combat MG',
    [tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'Pump Shotgun',
    [tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Sawed-Off Shotgun',
    [tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'Assault Shotgun',
    [tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Bullpup Shotgun',
    [tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Sniper Rifle',
    [tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Heavy Sniper',
    [tostring(GetHashKey('WEAPON_REMOTESNIPER'))] = 'Remote Sniper',
    [tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Grenade Launcher',
    [tostring(GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'))] = 'Smoke Grenade Launcher',
    [tostring(GetHashKey('WEAPON_RPG'))] = 'RPG',
    [tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket',
    [tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Airstrike Rocket',
    [tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger [Vehicle]',
    [tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun',
    [tostring(GetHashKey('WEAPON_GRENADE'))] = 'Grenade',
    [tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Sticky Bomb',
    [tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Tear Gas',
    [tostring(GetHashKey('WEAPON_BZGAS'))] = 'BZ Gas',
    [tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov',
    [tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Fire Extinguisher',
    [tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Jerry Can',
    [tostring(GetHashKey('OBJECT'))] = 'Object',
    [tostring(GetHashKey('WEAPON_BALL'))] = 'Ball',
    [tostring(GetHashKey('WEAPON_FLARE'))] = 'Flare',
    [tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Tank Cannon',
    [tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Rockets',
    [tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Laser',
    [tostring(GetHashKey('AMMO_RPG'))] = 'Rocket',
    [tostring(GetHashKey('AMMO_TANK'))] = 'Tank',
    [tostring(GetHashKey('AMMO_SPACE_ROCKET'))] = 'Rocket',
    [tostring(GetHashKey('AMMO_PLAYER_LASER'))] = 'Laser',
    [tostring(GetHashKey('AMMO_ENEMY_LASER'))] = 'Laser',
    [tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Rammed by Car',
    [tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Bottle',
    [tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg Sweeper',
    [tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'SNS Pistol',
    [tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Vintage Pistol',
    [tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flare Gun',
    [tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Heavy Pistol',
    [tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'Special Carbine',
    [tostring(GetHashKey('WEAPON_MUSKET'))] = 'Musket',
    [tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Firework Launcher',
    [tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Marksman Rifle',
    [tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Heavy Shotgun',
    [tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Proximity Mine',
    [tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Homing Launcher',
    [tostring(GetHashKey('WEAPON_HATCHET'))] = 'Hatchet',
    [tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'Combat PDW',
    [tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Knuckle Duster',
    [tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Marksman Pistol',
    [tostring(GetHashKey('WEAPON_MACHETE'))] = 'Machete',
    [tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Machine Pistol',
    [tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Flashlight',
    [tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Double Barrel Shotgun',
    [tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'Compact Rifle',
    [tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switchblade',
    [tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Heavy Revolver',
    [tostring(GetHashKey('WEAPON_FIRE'))] = 'Fire',
    [tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Heli Crash',
    [tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'Run over by Car',
    [tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Hit by Water Cannon',
    [tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Exhaustion',
    [tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion',
    [tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence',
    [tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleeding',
    [tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Drowning in Vehicle',
    [tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowning',
    [tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire',
    [tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
    [tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Bullpup Rifle',
    [tostring(GetHashKey('WEAPON_ASSAULTSNIPER'))] = 'Assault Sniper',
    [tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',
    [tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',
    [tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
    [tostring(GetHashKey('WEAPON_AUTOSHOTGUN'))] = 'Automatic Shotgun',
    [tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'Battle Axe',
    [tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Compact Grenade Launcher',
    [tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',
    [tostring(GetHashKey('WEAPON_PIPEBOMB'))] = 'Pipebomb',
    [tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Poolcue',
    [tostring(GetHashKey('WEAPON_WRENCH'))] = 'Wrench',
    [tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Snowball',
    [tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal',
    [tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar',
    [tostring(GetHashKey("WEAPON_STUNGUN"))] = 'Tazer',
    [tostring(GetHashKey("WEAPON_FLASHLIGHT"))] = 'Flashligh',
    [tostring(GetHashKey("WEAPON_NIGHTSTICK"))] = 'Baton',
    [tostring(GetHashKey("WEAPON_MOLOTOV"))] = 'Molotov',
    [tostring(GetHashKey("WEAPON_FIREEXTINGUISHER"))] = 'Fire Extinguisher',
    [tostring(GetHashKey("WEAPON_PETROLCAN"))] = 'Petrol Can',
    [tostring(GetHashKey("WEAPON_CAPSHIELD"))] = 'Captain America Shield',
    [tostring(GetHashKey("WEAPON_BRIEFCASE"))] = 'Briefcase',
    [tostring(GetHashKey("WEAPON_BRIEFCASE_02"))] = 'Briefcase',
    -- ADDON

    --[[ Shank ]]
    [tostring(GetHashKey("WEAPON_KICKASS"))] = 'KICKASS',
    [tostring(GetHashKey("WEAPON_SHOVEL"))] = 'Shovel',
    [tostring(GetHashKey("WEAPON_DAGGER"))] = 'Dagger',
    [tostring(GetHashKey("WEAPON_BASEBALLBAT"))] = 'Baseball Bat',

    --[[ Small ]]
    [tostring(GetHashKey("WEAPON_P2011"))] = 'P20-11',
    [tostring(GetHashKey("WEAPON_EVO"))] = 'Evo',
    [tostring(GetHashKey("WEAPON_B23R"))] = 'B23R',

    --[[ Rebel ]]
    [tostring(GetHashKey("WEAPON_R5"))] = 'R5',
    [tostring(GetHashKey("WEAPON_GUNGNIR"))] = 'Gung-Nir',
    [tostring(GetHashKey("WEAPON_DEADPOOLSHOTTY"))] = 'Deadpool Shotty',
    [tostring(GetHashKey("WEAPON_AR18"))] = 'AR-18',
    [tostring(GetHashKey("WEAPON_AN94"))] = 'AN-94',

    --[[ Large Arms ]]
    [tostring(GetHashKey("WEAPON_GALIL"))] = 'GALIL',
    [tostring(GetHashKey("WEAPON_SCARL"))] = 'Scar-L',
    [tostring(GetHashKey("WEAPON_AKKAL"))] = 'AK-KAL',
    [tostring(GetHashKey("WEAPON_MOSIN"))] = 'Mosin Nagant',
    [tostring(GetHashKey("WEAPON_VECTOR"))] = 'Vector',
    [tostring(GetHashKey("WEAPON_WINCHESTER12"))] = 'Winchester 12',

    --[[ PD ]]
    [tostring(GetHashKey("WEAPON_SPAR16"))] = 'SPAR-16',
    [tostring(GetHashKey("WEAPON_MP5X"))] = 'MP5-X',
    [tostring(GetHashKey("WEAPON_G36"))] = 'G36',
    [tostring(GetHashKey("WEAPON_REMINGTON870"))] = 'Remington 870',
    [tostring(GetHashKey("WEAPON_GLOCK"))] = 'Glock',
    [tostring(GetHashKey("WEAPON_BATON"))] = 'Baton',
    [tostring(GetHashKey("WEAPON_TASER"))] = 'Taser',
    [tostring(GetHashKey("WEAPON_SIGMCX"))] = 'SIGMCX',
    
}


function tSentry.varyHealth(variation)
    local ped = GetPlayerPed(-1)

    local n = math.floor(GetEntityHealth(ped)+variation)
    SetEntityHealth(ped,n)
end

function tSentry.reviveHealth()
    local ped = GetPlayerPed(-1)
    if GetEntityHealth(ped) == 102 then
        SetEntityHealth(ped,200)
    end
end

function tSentry.getHealth()
    return GetEntityHealth(GetPlayerPed(-1))
end

function tSentry.getArmour()
    return GetPedArmour(GetPlayerPed(-1))
end

function tSentry.setHealth(health)
    local n = math.floor(health)
    SetEntityHealth(GetPlayerPed(-1),n)
end


function tSentry.setFriendlyFire(flag)
    NetworkSetFriendlyFireOption(flag)
    SetCanAttackFriendly(GetPlayerPed(-1), flag, flag)
end

function tSentry.setPolice(flag)
    local player = PlayerId()
    SetPoliceIgnorePlayer(player, not flag)
    SetDispatchCopsForPlayer(player, flag)
end

function getRandomComaAnimation()
-- --death emotes
    randomComaAnimations = {
        {"combat@damage@writheidle_a","writhe_idle_a"},
        {"combat@damage@writheidle_a","writhe_idle_b"},
        {"combat@damage@writheidle_a","writhe_idle_c"},
        {"combat@damage@writheidle_b","writhe_idle_d"},
        {"combat@damage@writheidle_b","writhe_idle_e"},
        {"combat@damage@writheidle_b","writhe_idle_f"},
        {"combat@damage@writheidle_c","writhe_idle_g"},
        {"combat@damage@rb_writhe","rb_writhe_loop"},
        {"combat@damage@writhe","writhe_loop"},
    }


    comaAnimation = {}
    
    math.randomseed(GetGameTimer())
    num = math.random(1,#randomComaAnimations)
    num = math.random(1,#randomComaAnimations)
    num = math.random(1,#randomComaAnimations)
    
    dict,anim = table.unpack(randomComaAnimations[num])
    comaAnimation["dict"] = dict
    comaAnimation["anim"] = anim
    print("GETTING CCOMA ANIM")
    --comaAnimation["dict"] = "combat@damage@writheidle_a"
    --comaAnimation["anim"] = "writhe_idle_a"
    --randomize this :)
    return comaAnimation
end

function DrawAdvancedTextOutline(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)

    SetTextEdge(1, 0, 0, 0, 255)

    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end