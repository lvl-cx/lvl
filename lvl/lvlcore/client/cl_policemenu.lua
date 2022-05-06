RMenu.Add('LVLPDMenu', 'main', RageUI.CreateMenu("", "~w~LVL Police Menu", 1300, 50, 'police', 'police'))
RMenu.Add('LVLPDMenu', 'objectmenu',  RageUI.CreateSubMenu(RMenu:Get("LVLPDMenu", "main")))

local index = {
  object = 1,
  speedRad = 1,
  speed = 1
}

local objects = {
 {"Big Cone","prop_roadcone01a"},
 {"Small Cone","prop_roadcone02b"},
 {"Gazebo","prop_gazebo_02"},
 {"Worklight","prop_worklight_03b"},
 {"Police Slow","prop_barrier_work05"},
 {"Gate Barrier","ba_prop_battle_barrier_02a"},
 {"Concrete Barrier","prop_mp_barrier_01"},
 {"Concrete Barrier 2","prop_mp_barrier_01b"},
}

local listObjects = {}

for k, v in pairs(objects) do 
  listObjects[k] = v[1]
end

local cuffed = false

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('LVLPDMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
                RageUI.Button("Object Menu" , nil, { RightLabel = '~w~→'}, true, function(Hovered, Active, Selected) end, RMenu:Get('LVLPDMenu', 'objectmenu'))
                RageUI.Button("Cuff Nearest Player" , nil, { RightLabel = '~w~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('LVL:Handcuff')
                    end
                end)
                RageUI.Button("Drag Nearest Player" , nil, { RightLabel = '~w~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('LVL:Drag')
                    end
                end)
                RageUI.Button("Search Nearest Player" , nil, { RightLabel = '~w~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('LVL:SearchPlayer')
                    end
                end)
                RageUI.Button("Seize Items" , nil, { RightLabel = '~w~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('LVL:Seize')
                    end
                end)
                RageUI.Button("Put Player in Vehicle" , nil, { RightLabel = '~w~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('LVL:PutPlrInVeh')
                    end
                end)
                RageUI.Button("Remove Player From Vehicle" , nil, { RightLabel = '~w~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('LVL:TakeOutOfVehicle')
                    end
                end)
                RageUI.Button("Fine Player" , nil, { RightLabel = '~w~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('LVL:Fine')
                    end
                end)
                RageUI.Button("Jail Player" , nil, { RightLabel = '~w~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('LVL:JailPlayer')
                    end
                end)
                RageUI.Button("Unjail Player" , nil, { RightLabel = '~w~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('LVL:UnJailPlayer')
                    end
                end)

            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('LVLPDMenu', 'objectmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
                RageUI.List("Spawn Object", listObjects, index.object, nil, {RightLabel = "~w~→"}, true, function(Hovered, Active, Selected, Index)
                    if (Selected) then
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
                        spawnObject(objects[Index][2])
                        end
                    end
                    if (Active) then 
                        index.object = Index;
                    end
                end)
                RageUI.Button("Delete Object" , nil, { RightLabel = '~w~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
                        deleteObject()
                        end
                    end
                end)
            end
        end)
    end
end)

RegisterCommand('pd', function()
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
    TriggerServerEvent('LVL:OpenPoliceMenu')
  end
end)

RegisterNetEvent("LVL:PoliceMenuOpened")
AddEventHandler("LVL:PoliceMenuOpened",function()
  RageUI.Visible(RMenu:Get('LVLPDMenu', 'main'), not RageUI.Visible(RMenu:Get('LVLPDMenu', 'main')))
end)

function spawnObject(object) 
    print(object)
    local Player = PlayerPedId()
    local heading = GetEntityHeading(Player)
    local x, y, z = table.unpack(GetEntityCoords(Player))
    RequestModel(object)
    while not HasModelLoaded(object) do
      Citizen.Wait(1)
    end
    local obj = CreateObject(GetHashKey(object), x, y, z, true, false);
    PlaceObjectOnGroundProperly(obj)
    SetEntityHeading(obj, heading)
    SetModelAsNoLongerNeeded(GetHashKey(object))
end

function deleteObject() 
  for k, v in pairs(objects) do 
    local theobject1 = v[2]
    local object1 = GetHashKey(theobject1)
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    if DoesObjectOfTypeExistAtCoords(x, y, z, 2.0, object1, true) then
        local obj1 = GetClosestObjectOfType(x, y, z, 2.0, object1, false, false, false)
        DeleteObject(obj1)
    end
  end
end

other = nil
drag = false
playerStillDragged = false

RegisterNetEvent("LVL:DragPlayer")
AddEventHandler('LVL:DragPlayer', function(pl)
    other = pl
    drag = not drag
end)

Citizen.CreateThread(function()
    while true do
        if drag and other ~= nil then
            local ped = GetPlayerPed(GetPlayerFromServerId(other))
            local myped = GetPlayerPed(-1)
            AttachEntityToEntity(myped, ped, 4103, 11816, 0.54, 0.04, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            playerStillDragged = true
        else
            if(playerStillDragged) then
                DetachEntity(GetPlayerPed(-1), true, false)
                playerStillDragged = false
            end
        end
        Citizen.Wait(0)
    end
end)

local frozen = false
local unfrozen = false
function tLVL.loadFreeze(notify,god,ghost)
	if not frozen then
	  if notify then
	    LVL.notify({"~r~You've been frozen."})
	  end
	  frozen = true
	  invincible = god
	  invisible = ghost
	  unfrozen = false
	else
	  if notify then
	    LVL.notify({"~g~You've been unfrozen."})
	  end
	  unfrozen = true
	  invincible = false
	  invisible = false
	end
end

RegisterKeyMapping('pd', 'Opens the PD menu', 'keyboard', 'U')

RegisterNetEvent("LVL:arrestCriminal")
AddEventHandler("LVL:arrestCriminal",function(g)
        local h = PlayerPedId()
        LVL.setWeapon(h, "WEAPON_GLOCKLVL", true)
        local i = GetEntityCoords(h)
        local j = GetPlayerPed(GetPlayerFromServerId(g))
        f = true
        LVL.loadAnimDict("mp_arrest_paired")
        AttachEntityToEntity(h, j, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
        TaskPlayAnim(h, "mp_arrest_paired", "crook_p2_back_left", 8.0, -8.0, 5500, 33, 0, false, false, false)
        Citizen.Wait(950)
        DetachEntity(h, true, false)
        f = false
end)

RegisterNetEvent("LVL:CuffAnim")
AddEventHandler("LVL:CuffAnim",function()
    LVL.loadAnimDict("mp_arrest_paired")
    tLVL.playAnim(true, {{"mp_arrest_paired", "cop_p2_back_left", 1}}, true)
    Citizen.Wait(5000)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("LVL:UnCuffAnim")
AddEventHandler("LVL:UnCuffAnim",function()
    LVL.loadAnimDict("mp_arresting")
    tLVL.playAnim(true, {{"mp_arresting", "a_uncuff", 1}}, true)
    Citizen.Wait(5000)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("LVL:ArrestAnim")
AddEventHandler("LVL:ArrestAnim",function()
    LVL.loadAnimDict("mp_arrest_paired")
    tLVL.playAnim(true, {{"mp_arrest_paired", "crook_p2_back_left", 1}}, true)
    Citizen.Wait(5000)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("LVL:AttachPlayer")
AddEventHandler("LVL:AttachPlayer",function(g)
    local j = GetPlayerPed(GetPlayerFromServerId(g))
    local h = PlayerPedId()
    AttachEntityToEntity(h, j, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
    Citizen.Wait(5000)
    DetachEntity(h, true, false)
end)


