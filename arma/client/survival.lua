local comaAnim = {}
local in_coma = false
local coma_left = 90
local secondsTillBleedout = 90
local playerCanRespawn = false 
local calledNHS = false
local deathString = ""
local deathPosition

local comaAnim = {}
local DeathAnim = 100

WeaponNames={}
local o=module("cfg/weapons")
local p={}
local q={}
Citizen.CreateThread(function()
    q=o.nativeWeaponModelsToNames
    for r,s in pairs(o.weapons)do 
        q[r]=s.name 
    end
    for r,t in pairs(q)do 
        WeaponNames[GetHashKey(r)]=t
        p[GetHashKey(r)]=r 
    end 
end)

Citizen.CreateThread(function()
  while true do 
    if IsDisabledControlJustPressed(0,38) then
      if playerCanRespawn and in_coma and secondsTillBleedout < 1 then
        TriggerEvent("ARMA:respawnKeyPressed")
        tARMA.respawnPlayer()
      end
      Wait(1000)
    end
    Wait(0)
  end
end)

Citizen.CreateThread(function() -- coma thread
    Wait(500)
    exports.spawnmanager:setAutoSpawn(false)
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        if IsEntityDead(PlayerPedId()) and not in_coma then --Wait for death check
            pbCounter = 100
            local plyCoords = GetEntityCoords(PlayerPedId(),true)

            ARMAserver.StoreWeaponsDead()
            ARMAserver.Coma()
            TriggerEvent('ARMA:IsInMoneyComa', true)
            TriggerServerEvent('ARMA:InComa')
            ARMAserver.MoneyDrop()
            TriggerEvent('ARMA:3Seconds')
            TriggerServerEvent("Server:SoundToCoords", plyCoords.x, plyCoords.y, plyCoords.z, 60.0, "Untitled", 0.4);
            tARMA.ejectVehicle()
            in_coma = true
            deathPosition = plyCoords
            local x,y,z = table.unpack(deathPosition)
            ARMAserver.updatePos({x,y,z})
            ARMAserver.updateHealth({0})
            Wait(250) --Need wait, otherwise will autorevive in next check
        end

        if DeathAnim <= 0  then --Been 10 seconds, proceed to play anim check 
            DeathAnim = 100 
            local entityDead = GetEntityHealth(PlayerPedId())
            while entityDead <= 100 do
                Wait(0)
                local x,y,z = tARMA.getPosition()
                NetworkResurrectLocalPlayer(x, y, z, GetEntityHeading(PlayerPedId()), true, true, false)
                entityDead = GetEntityHealth(PlayerPedId())
            end
            SetEntityHealth(PlayerPedId(), 102)
            SetEntityInvincible(PlayerPedId(),true)
            comaAnim = getRandomComaAnimation()
            if not HasAnimDictLoaded(comaAnim.dict) then
                RequestAnimDict(comaAnim.dict)
                while not HasAnimDictLoaded(comaAnim.dict) do
                    Wait(0)
                end
            end
            TaskPlayAnim(PlayerPedId(), comaAnim.dict, comaAnim.anim, 3.0, 1.0, -1, 1, 0, 0, 0, 0 )
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
            if GetEntityHealth(playerPed) > 102 then 
                tARMA.disableComa()
                if IsEntityDead(playerPed) then
                    local x,y,z = tARMA.getPosition()
                    NetworkResurrectLocalPlayer(x, y, z, GetEntityHeading(PlayerPedId()),true, true, false)
                    Wait(0)
                end
                tARMA.disableComa()
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
			if not calledNHS then
				if IsControlJustPressed(1, 51) then
					calledNHS = true
					tARMA.notify('~g~NHS called to your approximate location')
					TriggerServerEvent('ARMA:NHSComaCall')
                    TriggerEvent("ARMA:DEATH_SCREEN_NHS_CALLED")
				end
			end
            DisableControlAction(0,323,true)
            DisableControlAction(0,182,true)
            DisableControlAction(0,37,true)
        end
        Wait(0)
    end 
end)

function tARMA.RevivePlayer()
    local x=PlayerPedId()
    if IsEntityDead(x)then 
        local x,y,z=tARMA.getPosition()
        NetworkResurrectLocalPlayer(x,y,z,GetEntityHeading(PlayerPedId()),true,true,false)
        Citizen.Wait(0)
    end
    local D=PlayerId()
    SetPlayerControl(D,true,false)
    if not IsEntityVisible(x)then 
        SetEntityVisible(x,true)
    end
    if not IsPedInAnyVehicle(x)then 
        SetEntityCollision(x,true)
    end
    FreezeEntityPosition(x,false)
    SetPlayerInvincible(D,false)
    SetEntityHealth(x,200)
    tARMA.disableComa()
    i=100
    local x=PlayerPedId()
    SetEntityInvincible(x,false)
    ClearPedSecondaryTask(PlayerPedId())
    Citizen.CreateThread(function()
        Wait(500)
        ClearPedSecondaryTask(PlayerPedId())
        ClearPedTasks(PlayerPedId())
    end)
    TriggerEvent("ARMA:CLOSE_DEATH_SCREEN")
end

AddEventHandler("ARMA:countdownEnded",function()
    secondsTillBleedout = 0
    playerCanRespawn = true
end)

Citizen.CreateThread(function()
    while DeathAnim <= 3 and DeathAnim >= 0 do
        Wait(1000)
        DeathAnim = DeathAnim - 1
    end
end) 

RegisterNetEvent("ARMA:3Seconds")
AddEventHandler("ARMA:3Seconds", function()
    DeathAnim = 3
    while DeathAnim <= 3 and DeathAnim >= 0 do
        Wait(1000)
        DeathAnim = DeathAnim - 1
    end
end)

function tARMA.respawnPlayer()
    
    exports.spawnmanager:spawnPlayer()
    playerCanRespawn = false 
    TriggerEvent("ARMA:CLOSE_DEATH_SCREEN")
    DeathString = ""
    secondsTillBleedout = 90
    
    local ped = PlayerPedId()
    tARMA.reviveComa()
end


function tARMA.disableComa()
    in_coma = false
end

function tARMA.isInComa()
    return in_coma
end

RegisterNetEvent("ARMA:FixClient")
AddEventHandler("ARMA:FixClient", function()
    local resurrectspamm = true
    Citizen.CreateThread(function()
        while true do 
            Wait(0)
            if resurrectspamm == true then
                TriggerEvent("ARMA:CLOSE_DEATH_SCREEN")
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
                secondsTillBleedout = 90
                in_coma = false
                EnableControlAction(0, 73, true)
                tARMA.stopScreenEffect(cfg.coma_effect)
                DoScreenFadeIn(500)
                Citizen.Wait(500)
            end 
        end
    end)
end)

function tARMA.reviveComa()
    local ped = PlayerPedId()
    SetEntityInvincible(ped,false)
    tARMA.setRagdoll(false)
    tARMA.stopScreenEffect(cfg.coma_effect)
    SetEntityHealth(PlayerPedId(), 200) 
end

-- kill the player if in coma
function tARMA.killComa()
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
    while true do
        Citizen.Wait(0)
        if IsEntityDead(PlayerPedId()) then
            Citizen.Wait(500)
            TriggerEvent("arma:PlaySound", tARMA.getDeathSound())
            local PedKiller = GetPedSourceOfDeath(PlayerPedId())
            Q=GetPedCauseOfDeath(PlayerPedId())
            R=WeaponNames[Q]
            if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
                Killer = NetworkGetPlayerIndexFromPed(PedKiller)
            elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
                Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
            end
            
            if (Killer == PlayerId()) or (Killer == nil) then
                TriggerEvent("ARMA:SHOW_DEATH_SCREEN",secondsTillBleedout,"N/A","N/A","N/A",true)
            else
                TriggerEvent("ARMA:SHOW_DEATH_SCREEN",secondsTillBleedout, GetPlayerName(Killer) or "N/A", tARMA.getUserId(Killer) or "N/A", tostring(R) or "N/A", false)
            end
        end
        while IsEntityDead(PlayerPedId()) do
            Citizen.Wait(0)
        end
    end
end)


function tARMA.varyHealth(X)
    local x=PlayerPedId()
    local Y=math.floor(GetEntityHealth(x)+X)SetEntityHealth(x,Y)
end
function tARMA.getHealth()
    return GetEntityHealth(PlayerPedId())
end
function tARMA.setHealth(y)
    local Y=math.floor(y)
    SetEntityHealth(PlayerPedId(),Y)
end
function tARMA.setFriendlyFire(Z)
    NetworkSetFriendlyFireOption(Z)
    SetCanAttackFriendly(GetPlayerPed(-1),Z,Z)
end
function tARMA.setPolice(Z)
    local D=PlayerId()
    SetPoliceIgnorePlayer(D,not Z)
    SetDispatchCopsForPlayer(D,Z)
end
Citizen.CreateThread(function()
    if true then 
        tARMA.setPolice(false)
        tARMA.setFriendlyFire(true)
    end 
end)

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