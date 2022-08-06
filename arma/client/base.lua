cfg = module("cfg/client")

tARMA = {}
local players = {} -- keep track of connected players (server id)

-- bind client tunnel interface
Tunnel.bindInterface("ARMA",tARMA)

-- get server interface
ARMAserver = Tunnel.getInterface("ARMA","ARMA")

-- add client proxy interface (same as tunnel interface)
Proxy.addInterface("ARMA",tARMA)

-- functions


function tARMA.teleport(x,y,z)
  tARMA.unjail() -- force unjail before a teleportation
  SetEntityCoords(PlayerPedId(), x+0.0001, y+0.0001, z+0.0001, 1,0,0,1)
  ARMAserver.updatePos({x,y,z})
end

-- return x,y,z
function tARMA.getPosition()
  local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
  return x,y,z
end

--returns the distance between 2 coordinates (x,y,z) and (x2,y2,z2)
function tARMA.getDistanceBetweenCoords(x,y,z,x2,y2,z2)

local distance = GetDistanceBetweenCoords(x,y,z,x2,y2,z2, true)
  
  return distance
end

-- return false if in exterior, true if inside a building
function tARMA.isInside()
  local x,y,z = tARMA.getPosition()
  return not (GetInteriorAtCoords(x,y,z) == 0)
end

-- return vx,vy,vz
function tARMA.getSpeed()
  local vx,vy,vz = table.unpack(GetEntityVelocity(PlayerPedId()))
  return math.sqrt(vx*vx+vy*vy+vz*vz)
end

function tARMA.getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(PlayerPedId())
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  -- normalize
  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
end

function tARMA.getNearestPlayers(radius)
  local r = {}

  local ped = GetPlayerPed(i)
  local pid = PlayerId()
  local px,py,pz = tARMA.getPosition()

  for k,v in pairs(players) do
    local player = GetPlayerFromServerId(k)

    if v and player ~= pid and NetworkIsPlayerConnected(player) then
      local oped = GetPlayerPed(player)
      local x,y,z = table.unpack(GetEntityCoords(oped,true))
      local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
      if distance <= radius then
        r[GetPlayerServerId(player)] = distance
      end
    end
  end

  return r
end

function tARMA.getNearestPlayer(radius)
  local p = nil

  local players = tARMA.getNearestPlayers(radius)
  local min = radius+10.0
  for k,v in pairs(players) do
    if v < min then
      min = v
      p = k
    end
  end

  return p
end

function tARMA.notify(msg)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(msg)
  DrawNotification(true, false)
end

function tARMA.notifyPicture(icon, type, sender, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(icon, icon, true, type, sender, title, text)
    DrawNotification(false, true)
end

-- SCREEN

-- play a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
-- duration: in seconds, if -1, will play until stopScreenEffect is called
function tARMA.playScreenEffect(name, duration)
  if duration < 0 then -- loop
    StartScreenEffect(name, 0, true)
  else
    StartScreenEffect(name, 0, true)

    Citizen.CreateThread(function() -- force stop the screen effect after duration+1 seconds
      Citizen.Wait(math.floor((duration+1)*1000))
      StopScreenEffect(name)
    end)
  end
end

-- stop a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
function tARMA.stopScreenEffect(name)
  StopScreenEffect(name)
end

local Q={}
local R={}
function tARMA.createArea(l,W,T,U,X,Y,Z,_)
  local V={position=W,radius=T,height=U,enterArea=X,leaveArea=Y,onTickArea=Z,metaData=_}
  if V.height==nil then 
      V.height=6 
  end
  Q[l]=V
  R[l]=V 
end
function tARMA.doesAreaExist(l)
  if Q[l] then
      return true
  end
  return false
end
Citizen.CreateThread(function()
    while true do
        local M = tARMA.getPlayerCoords()
        for a0, a1 in pairs(R) do
            local a2 = #(a1.position - M)
            local a3 = a2 <= a1.radius and math.abs(M.z - a1.position.z) <= a1.height
            a1.distance = a2
            if a1.player_in and not a3 then
                if a1.leaveArea then
                    if a1.metaData == nil then
                        a1.metaData = {}
                    end
                    a1.leaveArea(a1.metaData)
                else
                    vRPserver.leaveArea({a0})
                end
            elseif not a1.player_in and a3 then
                if a1.enterArea then
                    if a1.metaData == nil then
                        a1.metaData = {}
                    end
                    a1.enterArea(a1.metaData)
                else
                    vRPserver.enterArea({a0})
                end
            end
            a1.player_in = a3
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        for a0, a1 in pairs(R) do
            if a1.player_in and a1.onTickArea then
                if a1.metaData == nil then
                    a1.metaData = {}
                end
                a1.metaData.distance = a1.distance
                a1.onTickArea(a1.metaData)
            end
        end
        Wait(0)
    end
end)

local a=0
local b=0
local c=0
local d=vector3(0,0,0)
local e=false
local f=PlayerPedId
function savePlayerInfo()
    a=f()
    b=GetVehiclePedIsIn(a,false)
    c=PlayerId()
    d=GetEntityCoords(a)
    local g=GetPedInVehicleSeat(b,-1)
    e=g==a 
end
_G["PlayerPedId"]=function()
    return a
end
function tARMA.getPlayerPed()
    return a
end
function tARMA.getPlayerVehicle()
    return b,e 
end
function tARMA.getPlayerId()
    return c 
end

function tARMA.getPlayerCoords()
    return d 
end

function tARMA.spawnVehicle(W,v,w,H,X,Y,Z,_)
  local a0=tARMA.LoadModel(W)
  local a1=CreateVehicle(a0,v,w,H,X,Z,_)
  SetEntityAsMissionEntity(a1)
  SetModelAsNoLongerNeeded(a0)
  if Y then 
      TaskWarpPedIntoVehicle(PlayerPedId(),a1,-1)
  end
  if GetResourceState("ARMAFuel")=="started"then 
      exports['ARMAFuel']:SetFuel(a1,100)
  end
  return a1 
end

local a2={}
Citizen.CreateThread(function()
    while true do 
        local b2={}
        b2.playerPed=tARMA.getPlayerPed()
        b2.playerCoords=tARMA.getPlayerCoords()
        b2.playerId=tARMA.getPlayerId()
        b2.vehicle=tARMA.getPlayerVehicle()
        b2.weapon=GetSelectedPedWeapon(b2.playerPed)
        for c2=1,#a2 do 
            local d2=a2[c2]
            d2(b2)
        end
        Wait(0)
    end 
end)
function tARMA.createThreadOnTick(d2)
    a2[#a2+1]=d2
end

Citizen.CreateThread(function()
  tARMA.createThreadOnTick(savePlayerInfo)
end)

-- ANIM

-- animations dict and names: http://docs.ragepluginhook.net/html/62951c37-a440-478c-b389-c471230ddfc5.htm

local anims = {}
local anim_ids = Tools.newIDGenerator()

-- play animation (new version)
-- upper: true, only upper body, false, full animation
-- seq: list of animations as {dict,anim_name,loops} (loops is the number of loops, default 1) or a task def (properties: task, play_exit)
-- looping: if true, will ARMAly loop the first element of the sequence until stopAnim is called
function tARMA.playAnim(upper, seq, looping)
  if seq.task ~= nil then -- is a task (cf https://github.com/ImagicTheCat/ARMA/pull/118)
    tARMA.stopAnim(true)

    local ped = PlayerPedId()
    if seq.task == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then -- special case, sit in a chair
      local x,y,z = tARMA.getPosition()
      TaskStartScenarioAtPosition(ped, seq.task, x, y, z-1, GetEntityHeading(ped), 0, 0, false)
    else
      TaskStartScenarioInPlace(ped, seq.task, 0, not seq.play_exit)
    end
  else -- a regular animation sequence
    tARMA.stopAnim(upper)

    local flags = 0
    if upper then flags = flags+48 end
    if looping then flags = flags+1 end

    Citizen.CreateThread(function()
      -- prepare unique id to stop sequence when needed
      local id = anim_ids:gen()
      anims[id] = true

      for k,v in pairs(seq) do
        local dict = v[1]
        local name = v[2]
        local loops = v[3] or 1

        for i=1,loops do
          if anims[id] then -- check animation working
            local first = (k == 1 and i == 1)
            local last = (k == #seq and i == loops)

            -- request anim dict
            RequestAnimDict(dict)
            local i = 0
            while not HasAnimDictLoaded(dict) and i < 1000 do -- max time, 10 seconds
              Citizen.Wait(10)
              RequestAnimDict(dict)
              i = i+1
            end

            -- play anim
            if HasAnimDictLoaded(dict) and anims[id] then
              local inspeed = 8.0001
              local outspeed = -8.0001
              if not first then inspeed = 2.0001 end
              if not last then outspeed = 2.0001 end

              TaskPlayAnim(PlayerPedId(),dict,name,inspeed,outspeed,-1,flags,0,0,0,0)
            end

            Citizen.Wait(0)
            while GetEntityAnimCurrentTime(PlayerPedId(),dict,name) <= 0.95 and IsEntityPlayingAnim(PlayerPedId(),dict,name,3) and anims[id] do
              Citizen.Wait(0)
            end
          end
        end
      end

      -- free id
      anim_ids:free(id)
      anims[id] = nil
    end)
  end
end

-- stop animation (new version)
-- upper: true, stop the upper animation, false, stop full animations
function tARMA.stopAnim(upper)
  anims = {} -- stop all sequences
  if upper then
    ClearPedSecondaryTask(PlayerPedId())
  else
    ClearPedTasks(PlayerPedId())
  end
end

-- RAGDOLL
local ragdoll = false

-- set player ragdoll flag (true or false)
function tARMA.setRagdoll(flag)
  ragdoll = flag
end

-- ragdoll thread
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
    if ragdoll then
      SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
    end
  end
end)

-- SOUND
-- some lists: 
-- pastebin.com/A8Ny8AHZ
-- https://wiki.gtanet.work/index.php?title=FrontEndSoundlist

-- play sound at a specific position
function tARMA.playSpatializedSound(dict,name,x,y,z,range)
  PlaySoundFromCoord(-1,name,x+0.0001,y+0.0001,z+0.0001,dict,0,range+0.0001,0)
end

-- play sound
function tARMA.playSound(dict,name)
  PlaySound(-1,name,dict,0,0,1)
end

function tARMA.playFrontendSound(dict, name)
  PlaySoundFrontend(-1, dict, name, 0)
end

function tARMA.loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(0)
	end
end

function tARMA.setWeapon(m, s, t)
  SetCurrentPedWeapon(m, s, t)
end

function tARMA.LoadModel(modelName)
  local modelHash
  if type(modelName) ~= "string" then
      modelHash = modelName
  else
      modelHash = GetHashKey(modelName)
  end
  if IsModelInCdimage(modelHash) then
      if not HasModelLoaded(modelHash) then
          RequestModel(modelHash)
          while not HasModelLoaded(modelHash) do
              Wait(0)
          end
      end
      return modelHash
  else
      return nil
  end
end

function tARMA.KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true 
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() 
		Citizen.Wait(1) 
		blockinput = false 
		return result 
	else
		Citizen.Wait(1)
		blockinput = false 
		return nil 
	end
end

function tARMA.drawTxt(L, M, N, D, E, O, P, Q, R, S)
  SetTextFont(M)
  SetTextProportional(0)
  SetTextScale(O, O)
  SetTextColour(P, Q, R, S)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(N)
  BeginTextCommandDisplayText("STRING")
  AddTextComponentSubstringPlayerName(L)
  EndTextCommandDisplayText(D, E)
end

function tARMA.announceClient(d)
    if d~=nil then 
        CreateThread(function()
            local e=GetGameTimer()
            local scaleform=RequestScaleformMovie('MIDSIZED_MESSAGE')
            while not HasScaleformMovieLoaded(scaleform)do 
                Wait(0)
            end
            PushScaleformMovieFunction(scaleform,"SHOW_SHARD_MIDSIZED_MESSAGE")
            PushScaleformMovieFunctionParameterString("~g~ARMA Announcement")
            PushScaleformMovieFunctionParameterString(d)
            PushScaleformMovieMethodParameterInt(5)
            PushScaleformMovieMethodParameterBool(true)
            PushScaleformMovieMethodParameterBool(false)
            EndScaleformMovieMethod()
            while e+6*1000>GetGameTimer()do 
                DrawScaleformMovieFullscreen(scaleform,255,255,255,255)
                Wait(0)
            end 
        end)
    end 
end

AddEventHandler("playerSpawned",function()
  TriggerServerEvent("ARMAcli:playerSpawned")
end)

AddEventHandler("onPlayerDied",function(player,reason)
  TriggerServerEvent("ARMAcli:playerDied")
end)

AddEventHandler("onPlayerKilled",function(player,killer,reason)
  TriggerServerEvent("ARMAcli:playerDied")
end)

-- voice proximity computation
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500)
    local ped = PlayerPedId()
    local proximity = 30.0

    if IsPedSittingInAnyVehicle(ped) then
      local veh = GetVehiclePedIsIn(ped,false)
      local hash = GetEntityModel(veh)
      -- make open vehicles (bike,etc) use the default proximity
      if IsThisModelACar(hash) or IsThisModelAHeli(hash) or IsThisModelAPlane(hash) then
        proximity = 5.0
      end
    elseif tARMA.isInside() then
      proximity = 9.0
    end

    NetworkSetTalkerProximity(proximity+0.0001)
  end
end)

TriggerServerEvent('ARMA:CheckID')

RegisterNetEvent('ARMA:CheckIdRegister')
AddEventHandler('ARMA:CheckIdRegister', function()
    TriggerEvent('playerSpawned', GetEntityCoords(PlayerPedId()))
end)

local isDev = false
local carDev = false
local user_id = nil
local stafflevel = 0
globalOnPoliceDuty = false
globalOnNHSDuty = false
function tARMA.setPolice()
  globalOnPoliceDuty = true
end
function tARMA.setNHS()
  globalOnNHSDuty = true
end
function tARMA.setDev()
    isDev = true
end
function tARMA.isDev()
    return isDev
end
function tARMA.setCarDev()
  carDev = true
end
function tARMA.isCarDev()
  return carDev
end
function tARMA.setUserID(a)
  user_id = a
end
function tARMA.userID(Z)
  if Z == nil then
    return user_id
  else
    return baseplayers[z]
  end
end
function tARMA.setStaffLevel(a)
  stafflevel = a
end
function tARMA.getStaffLevel()
  return stafflevel
end


function tARMA.getRageUIMenuWidth()
  local w, h = GetActiveScreenResolution()

  if w == 1920 then
      return 1300
  elseif w == 1280 and h == 540 then
      return 1000
  elseif w == 2560 and h == 1080 then
      return 1050
  elseif w == 3440 and h == 1440 then
      return 1050
  end
  return 1300
end

function tARMA.getRageUIMenuHeight()
  return 100
end

local baseplayers = {}

function tARMA.setBasePlayers(players)
  baseplayers = players
end

function tARMA.addPlayer(player, id)
  baseplayers[player] = id
end

function tARMA.removePlayer(player)
  baseplayers[player] = nil
end

