RMenu.Add('ATMPDMenu', 'main', RageUI.CreateMenu("", "~g~ATM Police Menu", 1300, 50, 'police', 'police'))
RMenu.Add('ATMPDMenu', 'objectmenu',  RageUI.CreateSubMenu(RMenu:Get("ATMPDMenu", "main")))

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
    if RageUI.Visible(RMenu:Get('ATMPDMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
                RageUI.Button("Object Menu" , nil, { RightLabel = '~g~→'}, true, function(Hovered, Active, Selected) end, RMenu:Get('ATMPDMenu', 'objectmenu'))
                RageUI.Button("Cuff Nearest Player" , nil, { RightLabel = '~g~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('ATM:Handcuff')
                    end
                end)
                RageUI.Button("Drag Nearest Player" , nil, { RightLabel = '~g~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('ATM:Drag')
                    end
                end)
                RageUI.Button("Search Nearest Player" , nil, { RightLabel = '~g~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('ATM:SearchPlayer')
                    end
                end)
                RageUI.Button("Seize Items" , nil, { RightLabel = '~g~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('ATM:Seize')
                    end
                end)
                RageUI.Button("Put Player in Vehicle" , nil, { RightLabel = '~g~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('ATM:PutPlrInVeh')
                    end
                end)
                RageUI.Button("Remove Player From Vehicle" , nil, { RightLabel = '~g~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('ATM:TakeOutOfVehicle')
                    end
                end)
                RageUI.Button("Fine Player" , nil, { RightLabel = '~g~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('ATM:Fine')
                    end
                end)
                RageUI.Button("Jail Player" , nil, { RightLabel = '~g~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('ATM:JailPlayer')
                    end
                end)
                RageUI.Button("Unjail Player" , nil, { RightLabel = '~g~→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('ATM:UnJailPlayer')
                    end
                end)

            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('ATMPDMenu', 'objectmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
                RageUI.List("Spawn Object", listObjects, index.object, nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected, Index)
                    if (Selected) then
                        if IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
                        spawnObject(objects[Index][2])
                        end
                    end
                    if (Active) then 
                        index.object = Index;
                    end
                end)
                RageUI.Button("Delete Object" , nil, { RightLabel = '~g~→'}, true, function(Hovered, Active, Selected) 
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
    TriggerServerEvent('ATM:OpenPoliceMenu')
  end
end)

RegisterNetEvent("ATM:PoliceMenuOpened")
AddEventHandler("ATM:PoliceMenuOpened",function()
  RageUI.Visible(RMenu:Get('ATMPDMenu', 'main'), not RageUI.Visible(RMenu:Get('ATMPDMenu', 'main')))
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

RegisterNetEvent("ATM:DragPlayer")
AddEventHandler('ATM:DragPlayer', function(pl)
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
function tATM.loadFreeze(notify,god,ghost)
	if not frozen then
	  if notify then
	    ATM.notify({"~r~You've been frozen."})
	  end
	  frozen = true
	  invincible = god
	  invisible = ghost
	  unfrozen = false
	else
	  if notify then
	    ATM.notify({"~g~You've been unfrozen."})
	  end
	  unfrozen = true
	  invincible = false
	  invisible = false
	end
end

RegisterKeyMapping('pd', 'Opens the PD menu', 'keyboard', 'U')

RegisterNetEvent("ATM:arrestCriminal")
AddEventHandler("ATM:arrestCriminal",function(g)
        local h = PlayerPedId()
        ATM.setWeapon(h, "WEAPON_GLOCKATM", true)
        local i = GetEntityCoords(h)
        local j = GetPlayerPed(GetPlayerFromServerId(g))
        f = true
        ATM.loadAnimDict("mp_arrest_paired")
        AttachEntityToEntity(h, j, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
        TaskPlayAnim(h, "mp_arrest_paired", "crook_p2_back_left", 8.0, -8.0, 5500, 33, 0, false, false, false)
        Citizen.Wait(950)
        DetachEntity(h, true, false)
        f = false
end)

RegisterNetEvent("ATM:CuffAnim")
AddEventHandler("ATM:CuffAnim",function()
    ATM.loadAnimDict("mp_arrest_paired")
    tATM.playAnim(true, {{"mp_arrest_paired", "cop_p2_back_left", 1}}, true)
    Citizen.Wait(5000)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("ATM:UnCuffAnim")
AddEventHandler("ATM:UnCuffAnim",function()
    ATM.loadAnimDict("mp_arresting")
    tATM.playAnim(true, {{"mp_arresting", "a_uncuff", 1}}, true)
    Citizen.Wait(5000)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("ATM:ArrestAnim")
AddEventHandler("ATM:ArrestAnim",function()
    ATM.loadAnimDict("mp_arrest_paired")
    tATM.playAnim(true, {{"mp_arrest_paired", "crook_p2_back_left", 1}}, true)
    Citizen.Wait(5000)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("ATM:AttachPlayer")
AddEventHandler("ATM:AttachPlayer",function(g)
    local j = GetPlayerPed(GetPlayerFromServerId(g))
    local h = PlayerPedId()
    AttachEntityToEntity(h, j, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
    Citizen.Wait(5000)
    DetachEntity(h, true, false)
end)


