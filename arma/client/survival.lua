local comaAnim = {}
local in_coma = false
local calledNHS = false
spawning = true

local e = 0
local f = 300
local g = false
local i = 100
local n = 102

WeaponNames={}
local o=module("cfg/weapons")
local T=module("armacore/cfg/cfg_respawn")
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
    local v = module("armacore/cfg/cfg_housing")
    for w, x in pairs(v.homes) do
        T.spawnLocations[w] = {
            name = w,
            coords = vector3(x.entry_point[1], x.entry_point[2], x.entry_point[3]),
            permission = {},
            image = x.image or "https://cdn.cmg.city/content/fivem/houses/citysmallhome.png",
            price = 5000
        }
    end
end)


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

Citizen.CreateThread(function()
    while true do 
      if IsDisabledControlJustPressed(0,38) then
        if g and in_coma then
          TriggerEvent("ARMA:respawnKeyPressed")
          tARMA.respawnPlayer()
          TriggerServerEvent('ARMA:SendSpawnMenu')
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
        if IsEntityDead(PlayerPedId()) and not in_coma and not changingPed and not spawning then --Wait for death check
            pbCounter = 100
            local plyCoords = GetEntityCoords(PlayerPedId(),true)
            tARMA.ejectVehicle()
            TriggerServerEvent("ARMA:getNumOfNHSOnline")
            TriggerServerEvent("Server:SoundToCoords", plyCoords.x, plyCoords.y, plyCoords.z, 60.0, "Untitled", 0.4);
            in_coma = true
            local x,y,z = table.unpack(plyCoords)
            ARMAserver.updatePos({x,y,z})
            ARMAserver.updateHealth({0})
            Wait(250)
        end

        if i <= 0  then --Been 10 seconds, proceed to play anim check 
            i = 100 
            local entityDead = GetEntityHealth(PlayerPedId())
            while entityDead <= 100 do
                Wait(0)
                local x,y,z = table.unpack(tARMA.getPosition())
                NetworkResurrectLocalPlayer(x, y, z, GetEntityHeading(PlayerPedId()), true, true, false)
                entityDead = GetEntityHealth(PlayerPedId())
            end
            SetEntityHealth(PlayerPedId(), 102)
            SetEntityInvincible(PlayerPedId(),true)
            comaAnim = getRandomComaAnimation()
            tARMA.loadAnimDict(comaAnim.dict)
            TaskPlayAnim(PlayerPedId(), comaAnim.dict, comaAnim.anim, 3.0, 1.0, -1, 1, 0, 0, 0, 0 )
            RemoveAnimDict(comaAnim.dict)
        end
        if health > n and in_coma then
            if IsEntityDead(GetPlayerPed(-1)) then
                local F = tARMA.getPosition()
                NetworkResurrectLocalPlayer(F.x, F.y, F.z, GetEntityHeading(GetPlayerPed(-1)), true, true)
                Wait(0)
            end
            TriggerEvent("ARMA:CLOSE_DEATH_SCREEN")
            d = 100000
            e = 0
            pbCounter = 100
            g = false
            tARMA.disableComa()
            i = 100
            SetEntityInvincible(GetPlayerPed(-1), false)
            ClearPedSecondaryTask(GetPlayerPed(-1))
            Citizen.CreateThread(function()
                Wait(500)
                ClearPedSecondaryTask(GetPlayerPed(-1))
                ClearPedTasks(GetPlayerPed(-1))
            end)
        end
        local C = GetEntityHealth(GetPlayerPed(-1))
        if C <= n and not in_coma then
            SetEntityHealth(GetPlayerPed(-1), 0)
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
                        tARMA.loadAnimDict(comaAnim.dict)
                        TaskPlayAnim(playerPed, comaAnim.dict, comaAnim.anim, 3.0, 1.0, -1, 1, 0, 0, 0, 0)
                        RemoveAnimDict(comaAnim.dict)
                    end
                end
            end
            if GetEntityHealth(playerPed) > 102 then 
                tARMA.disableComa()
                if IsEntityDead(playerPed) then
                    local x,y,z = table.unpack(tARMA.getPosition())
                    NetworkResurrectLocalPlayer(x, y, z, GetEntityHeading(PlayerPedId()),true, true, false)
                    Wait(0)
                end
                tARMA.disableComa()
                i = 100 
                SetEntityInvincible(playerPed,false)
                ClearPedSecondaryTask(playerPed) 
            end
        end
        Wait(0)
    end
end)

RegisterNetEvent("ARMA:getNumberOfDocsOnline",function(I)
    c = I
    TriggerEvent('ARMA:nhsBlipComa', true)
    if tARMA.isPlayerInRedZone() or tARMA.isPlayerInTurf() then
        bleedoutDuration = 50000
    elseif #c >= 1 and #c <= 3 and not globalNHSOnDuty then
        bleedoutDuration = 170000
    elseif #c >= 1 and not globalNHSOnDuty then
        bleedoutDuration = 290000
    else
        bleedoutDuration = 50000
    end
    e = bleedoutDuration + 10000
    f = e / 1000
    i = 10
    l = GetGameTimer()
    local J = false
    if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
        J = true
    else
        TriggerEvent('ARMA:IsInMoneyComa', true)
        ExecuteCommand('storeallweapons')
        if not tARMA.globalOnPoliceDuty() then
            TriggerServerEvent('ARMA:InComa')
        end
        ARMAserver.MoneyDrop()
    end
    CreateThread(function()
        local K = GetGameTimer()
        while tARMA.getKillerInfo().ready == nil do
            Wait(0)
        end
        local L = tARMA.getKillerInfo()
        local M = false
        if L.name == nil then
            M = true
        end
        g = false
        TriggerEvent("ARMA:SHOW_DEATH_SCREEN", f, L.name or "N/A", L.user_id or "N/A", L.weapon or "N/A", M)
    end)
    while i <= 10 and i >= 0 do
        Wait(1000)
        i = i - 1
    end
    if J then
        TriggerEvent('ARMA:IsInMoneyComa', true)
        ExecuteCommand('storeallweapons')
        if not tARMA.globalOnPoliceDuty() then
            TriggerServerEvent('ARMA:InComa')
        end
        ARMAserver.MoneyDrop()
    end
end)

local L = {}
function tARMA.getKillerInfo()
    return L
end


function tARMA.RevivePlayer()
    local x=PlayerPedId()
    if IsEntityDead(x)then 
        local x,y,z=table.unpack(tARMA.getPosition())
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
    calledNHS = false
end

AddEventHandler("ARMA:countdownEnded",function()
    g = true
end)

function tARMA.respawnPlayer()
    exports.spawnmanager:spawnPlayer()
    g = false 
    TriggerEvent("ARMA:CLOSE_DEATH_SCREEN")
    calledNHS = false
    local ped = PlayerPedId()
    tARMA.reviveComa()
    e = 0
end


function tARMA.disableComa()
    in_coma = false
end

function tARMA.isInComa()
    return in_coma
end

function tARMA.reviveComa()
    local ped = PlayerPedId()
    SetEntityInvincible(ped,false)
    tARMA.setRagdoll(false)
    tARMA.stopScreenEffect(cfg.coma_effect)
    SetEntityHealth(PlayerPedId(), 200) 
    TriggerEvent('ARMA:nhsBlipComa', false)
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
            local s
            TriggerEvent("arma:PlaySound", tARMA.getDeathSound())
            local PedKiller = GetPedSourceOfDeath(PlayerPedId())
            Q=GetPedCauseOfDeath(PlayerPedId())
            R=WeaponNames[Q]
            if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
                Killer = NetworkGetPlayerIndexFromPed(PedKiller)
            elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
                Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
            end
            local distance = 0
            local a6 = false
            local az = tARMA.getPedServerId(PedKiller)
            if (Killer == PlayerId()) or (Killer == nil) then
                a6 = true
            else
                L.name = GetPlayerName(Killer)
                distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(PedKiller))
            end
            L.source = az
            L.user_id = tARMA.getUserId(tARMA.getPedServerId(PedKiller))
            L.weapon = tostring(R)
            L.ready = true
            if not g and in_coma and IsEntityPlayingAnim(playerPed,comaAnim.dict,comaAnim.anim,3)then
                TriggerServerEvent("ARMA:onPlayerKilled", "finished off", tARMA.getPedServerId(PedKiller), s)
            else
                TriggerServerEvent("ARMA:onPlayerKilled", "killed", tARMA.getPedServerId(PedKiller), R, a6, distance)
            end
            Killer = nil
            PedKiller = nil
            R = nil
        end
        while IsEntityDead(PlayerPedId()) do
            Citizen.Wait(0)
        end
        L = {}
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

Citizen.CreateThread(function()
    if true then 
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

local N = 0
RegisterNetEvent("ARMA:OpenSpawnMenu",function(O)
    DoScreenFadeIn(1000)
    TriggerScreenblurFadeIn(100.0)
    ExecuteCommand("hideui")
    SetPlayerControl(PlayerId(), false, 0)
    local G = PlayerPedId()
    local P = tARMA.getPlayerCoords()
    FreezeEntityPosition(G, true)
    SetEntityCoordsNoOffset(G, P.x, P.y, -100.0, false, false, false)
    SetEntityVisible(G, false, 0)
    N = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA",675.57568359375,1107.1724853516,375.29666137695,0.0,0.0,0.0,65.0,0,2)
    SetCamActive(N, true)
    RenderScriptCams(true, true, 0, true, false)
    SetCamParams(N, -1024.6506347656, -2712.0234375, 79.889106750488, 0.0, 0.0, 0.0, 65.0, 250000, 0, 0, 2)
    local QQ = {}
    for I, w in pairs(O) do
        if T.spawnLocations[w] then
            table.insert(QQ, T.spawnLocations[w])
        end
    end
    TriggerEvent("ARMADEATHUI:openSpawnMenu", QQ)
end)

AddEventHandler("ARMA:respawnButtonClicked",function(S, Z)
    if Z and Z > 0 then
        TriggerServerEvent("ARMA:takeAmount", Z)
    end
    local U = T.spawnLocations[S].coords
    TriggerEvent("arma:PlaySound", "gtaloadin")
    SetEntityCoords(PlayerPedId(), U)
    SetEntityVisible(PlayerPedId(), true, 0)
    SetPlayerControl(PlayerId(), true, 0)
    SetFocusPosAndVel(U.x, U.y, U.z + 1000)
    DestroyCam(N)
    local V = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", U.x, U.y, U.z + 1000.0, 0.0, 0.0, 0.0, 65.0, 0, 2)
    SetCamActive(V, true)
    RenderScriptCams(true, true, 0, true, false)
    SetCamParams(V, U.x, U.y, U.z, 0.0, 0.0, 0.0, 65.0, 5000, 0, 0, 2)
    Wait(2500)
    ClearFocus()
    Wait(2000)
    FreezeEntityPosition(PlayerPedId(), false)
    DestroyCam(V)
    RenderScriptCams(false, true, 2000, false, false)
    TriggerScreenblurFadeOut(2000.0)
    ExecuteCommand("showui")
    ClearFocus()
end)