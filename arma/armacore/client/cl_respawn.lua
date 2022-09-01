--[[ local Housing = module("armacore/cfg/cfg_housing")

local hasPD = false
local inCam = false
local hasRebel = false
local hasVIP = false
local housetable = {}
spawn = {}
spawn.position = nil



RegisterNetEvent("ARMA:PolicePerms")
AddEventHandler("ARMA:PolicePerms",function(pd)
    hasPD = pd
end)
RegisterNetEvent("ARMA:RebelPerms")
AddEventHandler("ARMA:RebelPerms",function(rebel)
    hasRebel = rebel
end)
RegisterNetEvent("ARMA:VIPPerms")
AddEventHandler("ARMA:VIPPerms",function(vip)
    hasVIP = vip
end)

RMenu.Add('RespawnMenu', 'main', RageUI.CreateMenu("", "Respawn Menu", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "banners", "spawn"))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('RespawnMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        for a , b in pairs(respawn.hospitals) do 
            RageUI.Button(a, nil, "", true, function(Hovered, Active, Selected)
                if Selected then
                    spawn.position = b.location
                    TriggerEvent('spawn:teleport')
                end
            end)
        end
        if hasVIP then
            for c , d in pairs(respawn.vip) do 
            RageUI.Button(c, nil, "", true, function(Hovered, Active, Selected)
                if Selected then
                    spawn.position = d.location
                    TriggerEvent('spawn:teleport')
                end
             end)
          end
        end
        if hasRebel then
            for e,f in pairs(respawn.rebel) do
                RageUI.Button(e, nil, "", true,function(Hovered, Active, Selected)
                    if Selected then
                        spawn.position = f.location
                        TriggerEvent('spawn:teleport')
                    end
                end)
            end
        end
        if hasPD then
            for g,h in pairs(respawn.pd) do
                RageUI.Button(g, nil, "", true,function(Hovered, Active, Selected)
                    if Selected then
                        spawn.position = h.location
                        TriggerEvent('spawn:teleport')
                    end
                end)
            end
        end
        for i,j in pairs(Housing.homes) do
            if table.includes(housetable, i) then
                RageUI.Button(""..i, nil, "", true,function(Hovered, Active, Selected)
                    if Selected then
                        spawn.position = j.entry_point
                        Wait(100)
                        TriggerEvent('spawn:teleport')
                        Wait(100)
                        RageUI.ActuallyCloseAll()
                    end
                end)
            end
        end
    end, function()

    end)
end
end)


isInMenu = false
Citizen.CreateThread(function() 
    TriggerServerEvent("ARMA:PoliceCheck")
    TriggerServerEvent("ARMA:RebelCheck")
    TriggerServerEvent("ARMA:VIPCheck")
    TriggerServerEvent("ARMA:getHouses")
    while true do
        local v1 = respawn.coords 
        if not isInMenu then
            if isInArea(v1, 1.4) then 
                ped = GetPlayerPed(-1)
                RageUI.Visible(RMenu:Get("RespawnMenu", "main"), true)
                isInMenu = true
            end
        end
        if not isInArea(v1, 1.4) and isInMenu then
            RageUI.Visible(RMenu:Get("RespawnMenu", "main"), false)
            isInMenu = false
        end
        Citizen.Wait(0)
    end
end)

local function isInArea(v, dis) 
    if #(GetEntityCoords(PlayerPedId()) - v) <= dis then  
        return true
    else 
        return false
    end
end

RegisterNetEvent('spawn:teleport')
AddEventHandler('spawn:teleport', function()
	inMenu = false
    RageUI.ActuallyCloseAll()
    inRedZone = false
    local spawnCoords = spawn.position
	TriggerEvent("arma:PlaySound", "gtaloadin")
    SetEntityCoords(PlayerPedId(), spawnCoords)
    SetFocusPosAndVel(spawnCoords.x,spawnCoords.y,spawnCoords.z+1000)
    local spawnCam3 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", spawnCoords.x,spawnCoords.y,spawnCoords.z+1000, 0.0, 0.0, 0.0, 65.0, 0, 2)
    SetCamActive(spawnCam3, true)
    DestroyCam(spawnCam, 0)
    DestroyCam(spawnCam2, 0)
    RenderScriptCams(true, true, 0, 1, 0, 0)
    local spawnCam4 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", spawnCoords.x,spawnCoords.y,spawnCoords.z, 0.0, 0.0, 0.0, 65.0, 0, 2)
    SetCamActiveWithInterp(spawnCam4, spawnCam3, 5000, 0, 0)
    Wait(2500)
    ClearFocus()
    Wait(2000)
    FreezeEntityPosition(PlayerPedId(),false)
    DestroyCam(spawnCam3)
    DestroyCam(spawnCam4)
    RenderScriptCams(false, true, 2000, 0, 0)
    TriggerScreenblurFadeOut(2000.0)
    ExecuteCommand("showui")
end)

function table.includes(table,p)
    for q,r in pairs(table)do 
        if r==p then 
            return true 
        end 
    end
    return false 
end

RegisterNetEvent("ARMA:HousingTable")
AddEventHandler("ARMA:HousingTable",function(houses)
    housetable = houses
end)

RegisterCommand("testrespawn", function()
    RageUI.Visible(RMenu:Get("RespawnMenu", "main"), true)
end) ]]