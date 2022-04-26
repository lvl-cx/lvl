local user_id = 0

local foundMatch = false
local inSpectatorAdminMode = false
local players = {}
local searchPlayerGroups = {}
local selectedGroup
local Groups = {}
local povlist = false
local SelectedPerm = nil

admincfg = {}

admincfg.perm = "admin.tickets"
admincfg.IgnoreButtonPerms = false
admincfg.admins_cant_ban_admins = false


--[[ {enabled -- true or false}, permission required ]]
admincfg.buttonsEnabled = {


    --[[ admin Menu ]]
    ["adminMenu"] = {true, "admin.tickets"},
    ["warn"] = {true, "admin.warn"},      
    ["showwarn"] = {true, "admin.showwarn"},
    ["ban"] = {true, "admin.ban"},
    ["kick"] = {true, "admin.kick"},
    ["nof10kick"] = {true, "admin.nof10kick"},
    ["revive"] = {true, "admin.revive"},
    ["TP2"] = {true, "admin.tp2player"},
    ["TP2ME"] = {true, "admin.summon"},
    ["TPLoc"] = {true, "admin.teleport"},
    ["FREEZE"] = {true, "admin.freeze"},
    ["spectate"] = {true, "admin.spectate"}, 
    ["SS"] = {true, "admin.screenshot"},
    ["slap"] = {true, "admin.slap"},
    ["giveMoney"] = {true, "admin.givemoney"},
    ["addcar"] = {true, "admin.addcar"},

    --[[ Functions ]]
    ["tp2waypoint"] = {true, "admin.tp2waypoint"},
    ["tp2coords"] = {true, "admin.tp2coords"},
    ["removewarn"] = {true, "admin.removewarn"},
    ["spawnBmx"] = {true, "admin.spawnBmx"},
    ["spawnGun"] = {true, "admin.spawnGun"},

    --[[ Add Groups ]]
    ["getgroups"] = {true, "group.add"},
    ["staffGroups"] = {true, "admin.staffAddGroups"},
    ["mpdGroups"] = {true, "admin.mpdAddGroups"},
    ["povGroups"] = {true, "admin.povAddGroups"},
    ["licenseGroups"] = {true, "admin.licenseAddGroups"},
    ["donoGroups"] = {true, "admin.donoAddGroups"},
    ["nhsGroups"] = {true, "admin.nhsAddGroups"},

    --[[ Vehicle Functions ]]
    ["vehFunctions"] = {true, "admin.vehmenu"},
    ["noClip"] = {true, "admin.noclip"},

    -- [[ Developer Functions ]]
    ["devMenu"] = {true, "dev.menu"},
}



RMenu.Add('adminmenu', 'main', RageUI.CreateMenu("", "~g~ATM Admin Menu", 1300, 50, 'admin', 'admin'))
RMenu.Add("adminmenu", "players", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main")))
RMenu.Add("adminmenu", "searchoptions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main")))
RMenu.Add("adminmenu", "settings", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"),"","~g~ATM Admin Menu", 1300, 50,"admin","admin"))

--[[ Functions ]]
RMenu.Add("adminmenu", "functions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main")))
RMenu.Add("adminmenu", "generalfunctions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "functions")))
RMenu.Add("adminmenu", "entityfunctions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "functions")))
RMenu.Add("adminmenu", "vehiclefunctions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "functions")))
RMenu.Add("adminmenu", "devfunctions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "functions")))
--[[ End of Functions ]]

RMenu.Add("adminmenu", "submenu", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players")))

RMenu.Add("adminmenu", "control", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "submenu")))
RMenu.Add("adminmenu", "manage", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "submenu")))
RMenu.Add("adminmenu", "punishment", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "submenu")))


RMenu.Add("adminmenu", "searchname", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions")))
RMenu.Add("adminmenu", "searchtempid", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions")))
RMenu.Add("adminmenu", "searchpermid", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions")))
RMenu.Add("adminmenu", "teleportmenu", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "submenu")))
RMenu.Add("adminmenu", "warnsub", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "punishment")))
RMenu.Add("adminmenu", "bansub", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "punishment")))

--[[groups]]
RMenu.Add("adminmenu", "groups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "submenu")))
RMenu.Add("adminmenu", "staffGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups")))
RMenu.Add("adminmenu", "LicenseGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups")))
RMenu.Add("adminmenu", "UserGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups")))
RMenu.Add("adminmenu", "POVGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups")))
RMenu.Add("adminmenu", "PoliceGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups")))
RMenu.Add("adminmenu", "NHSGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups")))
RMenu.Add("adminmenu", "addgroup", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups")))
RMenu.Add("adminmenu", "removegroup", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups")))

RMenu:Get('adminmenu', 'main')

local getStaffGroupsGroupIds = {
	["founder"] = "Founder",
    ["donorsupport"] = "Donator Support",
    ["staffmanager"] = "Staff Manager",
    ["commanager"] = "Community Manager",
    ["headadmin"] = "Head Admin",
    ["senioradmin"] = "Senior Admin",
	["administrator"] = "Admin",
    ["dev"] = "Developer",
	["moderator"] = "Moderator",
    ["supportteam"] = "Support Team",
    ["trialstaff"] = "Trial Staff",
}
local getUserGroupsGroupIds = {
    ["VIP"] = "VIP",
}
local getUserLicenseGroups = {
    ["Scrap"] = "Scrap",
    ["Weed"] = "Weed",
    ["Cocaine"] = "Cocaine",
    ["Gold"] = "Gold",
    ["Diamond"] = "Diamond",
    ["Heroin"] = "Heroin",
    ["LSD"] = "LSD",
    ["Gang"] = "Gang",
    ["Rebel"] = "Rebel",
    --["largearms"] = "Large Arms License",
}
local getUserPOVGroups = {
    ["pov"] = "POV List",
}

local getUserPoliceGroups = {
    ["Commissioner"] = "Commissioner",
    ["Deputy Commissioner"] = "Deputy Commissioner",
    ["Assistant Commissioner"] = "Assistant Commissioner",
    ["Deputy Assistant Commissioner"] = "Deputy Assistant Commissioner",
    ["Commander"] = "Commander",
    ["Chief Superintendent"] = "Chief Superintendent",
    ["Superintendent"] = "Superintendent",
    ["Chief Inspector"] = "Chief Inspector",
    ["Inspector"] = "Inspector",
    ["Sergeant"] = "Sergeant",
    ["Special Police Constable"] = "Special Police Constable",
    ["Senior Police Constable"] = "Senior Police Constable",
    ["Police Constable"] = "Police Constable",
    ["PCSO"] = "PCSO",
    ["SCO-19"] = "SCO-19",
}

local getUserNHSGroups = {
    ["Head Chief Medical Officer"] = "Head Chief Medical Officer",
    ["Assistant Chief Medical Officer"] = "Assistant Chief Medical Officer",
    ["Deputy Chief Medical Officer"] = "Deputy Chief Medical Officer",
    ["Captain"] = "Captain",
    ["Consultant"] = "Consultant",
    ["Specialist"] = "Specialist",
    ["Senior Doctor"] = "Senior Doctor",
    ["Junior Doctor"] = "Junior Doctor",
    ["Critical Care Paramedic"] = "Critical Care Paramedic",
    ["Paramedic"] = "Paramedic",
    ["Trainee Paramedic"] = "Trainee Paramedic",
}

RegisterNetEvent('ATM:ReturnPOV')
AddEventHandler('ATM:ReturnPOV', function(pov)
    povlist = pov
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

        if admincfg.buttonsEnabled["adminMenu"][1] and buttons["adminMenu"] then
            RageUI.Button("All Players", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'players'))
        end

        if admincfg.buttonsEnabled["adminMenu"][1] and buttons["adminMenu"] then
            RageUI.Button("Search Functions", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'searchoptions'))
        end

        if admincfg.buttonsEnabled["adminMenu"][1] and buttons["adminMenu"] then
            RageUI.Button("Functions", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'functions'))
        end

        if admincfg.buttonsEnabled["adminMenu"][1] and buttons["adminMenu"] then
            RageUI.Button("Settings", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'settings'))
        end

    end)
end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'players')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

        for k,v in pairs(players) do
            RageUI.Button("[" .. v[3] .. "] " .. v[1], nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    SelectedPlayer = players[k]
                    SelectedPerm = v[3]
                    TriggerServerEvent("ATM:CheckPOV",v[3])
                end
            end, RMenu:Get('adminmenu', 'submenu'))
        end
    end)
end
end)


RMenu.Add('SettingsMenu', 'MainMenu', RageUI.CreateMenu("", "~g~ATM Settings Menu", 1300, 50,"settings","settings")) 


local statusr = "~r~[Off]"
local hitsounds = false

local statusc = "~r~[Off]"
local compass = false

local statusT = "~r~[Off]"
local toggle = false

local df = {
    {"10%", 0.1},
    {"20%", 0.2},
    {"30%", 0.3},
    {"40%", 0.4},
    {"50%", 0.5},
    {"60%", 0.6},
    {"70%", 0.7},
    {"80%", 0.8},
    {"90%", 0.9},
    {"100%", 1.0},
    {"150%", 1.5},
    {"200%", 2.0},
    {"250%", 2.5},
    {"300%", 3.0},
    {"350%", 3.5},
    {"400%", 4.0},
    {"450%", 4.5},
    {"500%", 5.0},
    {"600%", 6.0},
    {"700%", 7.0},
    {"800%", 8.0},
    {"900%", 9.0},
    {"1000%", 10.0},
}

local d = {"10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%", "150%", "200%", "250%", "300%", "350%", "400%", "450%", "500%", "600%", "700%", "800%", "900%", "1000%"}
local dts = 9
local HitmarkerSounds = false
local Compass = false
local streetnames = false
local huddisplay = false

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('SettingsMenu', 'MainMenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.List("Modify Render Distance", d, dts, nil, {}, true, function(a,b,c,d)
                if c then
    
                end
    
                dts = d
            end)


            RageUI.Checkbox("Rust Hitsounds",nil, HitmarkerSounds, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Selected, Checked)
                if Selected then 
                    if not HitmarkerSounds then
                        TriggerEvent("ATM:Settings:Hitsounds", true)
                        HitmarkerSounds = true
                    else
                        TriggerEvent("ATM:Settings:Hitsounds", false)
                        HitmarkerSounds = false
                    end
                end
            end, ToggleHSTrue2, ToggleHSFalse2)
    

            RageUI.Checkbox("Compass",nil, Compass, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Selected, Checked)
                if Selected then 
                    if not Compass then
                        ExecuteCommand("compass")
                        Compass = true
                    else
                        ExecuteCommand("compass")
                        Compass = false
                    end
                end
            end, ToggleHSTrue2, ToggleHSFalse2)
    
            RageUI.Checkbox("Street Names", nil, streetnames, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                streetnames = Checked;
            end)

       end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'settings')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.List("Modify Render Distance", d, dts, nil, {}, true, function(a,b,c,d)
                if c then
    
                end
    
                dts = d
            end)

            
            RageUI.Checkbox("Rust Hitsounds",nil, HitmarkerSounds, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Selected, Checked)
                if Selected then 
                    if not HitmarkerSounds then
                        TriggerEvent("ATM:Settings:Hitsounds", true)
                        HitmarkerSounds = true
                    else
                        TriggerEvent("ATM:Settings:Hitsounds", false)
                        HitmarkerSounds = false
                    end
                end
            end, ToggleHSTrue2, ToggleHSFalse2)
    

            RageUI.Checkbox("Compass",nil, Compass, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Selected, Checked)
                if Selected then 
                    if not Compass then
                        ExecuteCommand("compass")
                        Compass = true
                    else
                        ExecuteCommand("compass")
                        Compass = false
                    end
                end
            end, ToggleHSTrue2, ToggleHSFalse2)

            RageUI.Checkbox("HUD Display",nil, huddisplay, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Selected, Checked)
                if Selected then 
                    if not huddisplay then
                        ExecuteCommand("toggleui")
                        huddisplay = true
                    else
                        ExecuteCommand("toggleui")
                        huddisplay = false
                    end
                end
            end, ToggleHSTrue2, ToggleHSFalse2)
    
            RageUI.Checkbox("Street Names", nil, streetnames, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                streetnames = Checked;
            end)

       end)
    end
end)

Citizen.CreateThread(function()
    while true do
        CheckPlayerPosition()
        Citizen.Wait(1000)
    end
end)


Citizen.CreateThread(function()
    while true do
        while streetnames do
            disableHud2()
            local UI = GetMinimapAnchor2()

            drawTxt2(UI.Left_x + 0.003 , UI.Bottom_y - 0.227 , 0.4, "~b~"..Zone.." / ~w~"..GetStreetNameFromHashKey(rua), 255, 255, 255, 255, 0) -- Street
            Citizen.Wait(1)
        end
        Citizen.Wait(1)
    end
end)

function CheckPlayerPosition()
    pos = GetEntityCoords(PlayerPedId())
    rua, cross = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    Zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))
end
 
function drawTxt2(x,y,scale,text,r,g,b,a,font)
    SetTextFont(font)
    SetTextScale(scale,scale)
    SetTextColour(r,g,b,a)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end
 
function disableHud2()
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)   
    HideHudComponentThisFrame(8)   
    HideHudComponentThisFrame(9)
end
 
function GetMinimapAnchor2()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.Width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.Left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.Bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.Left_x + Minimap.Width
    Minimap.top_y = Minimap.Bottom_y - Minimap.height
    Minimap.x = Minimap.Left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end

RegisterNetEvent('ATM:OpenSettingsMenu')
AddEventHandler('ATM:OpenSettingsMenu', function(admin)
    if not admin then
        RageUI.Visible(RMenu:Get("adminmenu", "main"), false)
        RageUI.Visible(RMenu:Get("SettingsMenu", "MainMenu"), true)
    else
        --
    end
end)

RegisterCommand('opensettingsmenu',function()
    TriggerServerEvent('ATM:OpenSettings')
end)

RegisterKeyMapping('opensettingsmenu', 'Opens the Settings menu', 'keyboard', 'F2')

Citizen.CreateThread(function() 
    while true do
        Citizen.InvokeNative(0xA76359FC80B2438E, df[dts][2])      
                
        Citizen.Wait(0)
    end
end)





RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'searchoptions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        foundMatch = false
        RageUI.Button("Search by Name", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('adminmenu', 'searchname'))
        
        RageUI.Button("Search by Perm ID", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('adminmenu', 'searchpermid'))

        RageUI.Button("Search by Temp ID", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('adminmenu', 'searchtempid'))
    end)
end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'functions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

        RageUI.Button("General Functions", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('adminmenu', 'generalfunctions'))
        if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
            RageUI.Button("Entity Functions", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'entityfunctions'))
        end

        if admincfg.buttonsEnabled["vehFunctions"][1] and buttons["vehFunctions"] then
            RageUI.Button("Vehicle Functions", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'vehiclefunctions'))
        end

        if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
            RageUI.Button("Developer Functions", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'devfunctions'))
        end

    end)
end
end)

local noclip_speed = 0.3
local noclip = false
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'generalfunctions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

            if admincfg.buttonsEnabled["tp2waypoint"][1] and buttons["tp2waypoint"] then
                RageUI.Button("Teleport to Waypoint", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local WaypointHandle = GetFirstBlipInfoId(8)
                        if DoesBlipExist(WaypointHandle) then
                            local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
                            for height = 1, 1000 do
                                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                                local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
                                if foundGround then
                                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                                    break
                                end
                                Citizen.Wait(5)
                            end
                        else
                            notify("You do not have a waypoint set")
                        end
                    end
                end, RMenu:Get('adminmenu', 'generalfunctions'))
            end

            if admincfg.buttonsEnabled["spawnBmx"][1] and buttons["spawnBmx"] then
                RageUI.Button("Spawn BMX", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        SpawnVehicle('bmx')
                    end
                end, RMenu:Get('adminmenu', 'generalfunctions'))
            end
            if admincfg.buttonsEnabled["noClip"][1] and buttons["noClip"] then
                RageUI.Button("Noclip Toggle",nil,{RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then

                        local player = PlayerId()
                        local ped = PlayerPedId
                        
                        local msg = "disabled"
                        if(noclip == false)then
                            noclip_pos = GetEntityCoords(PlayerPedId(), false)
                        end
                    
                        noclip = not noclip
                    
                        if(noclip)then
                            msg = "enabled"
                        end
                    
            
                    
                        Citizen.CreateThread(function()
                            while true do
                                Citizen.Wait(0)
                                if(noclip)then
                                local ped = GetPlayerPed(-1)
                                local x,y,z = getPosition()
                                local dx,dy,dz = getCamDirection()
                                local speed = noclip_speed
                                SetEntityVisible(GetPlayerPed(-1), false, false)
                                SetEntityInvincible(GetPlayerPed(-1), true)
                        
                              -- reset velocity
                              SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)
                              if IsControlPressed(0, 21) then
                                  speed = speed + 3
                                  end
                              if IsControlPressed(0, 19) then
                                  speed = speed - 0.5
                              end
                              -- forward
                                     if IsControlPressed(0,32) then -- MOVE UP
                                      x = x+speed*dx
                                      y = y+speed*dy
                                      z = z+speed*dz
                                       end
                        
                              -- backward
                                       if IsControlPressed(0,269) then -- MOVE DOWN
                                      x = x-speed*dx
                                      y = y-speed*dy
                                      z = z-speed*dz
                                       end
                                SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
                                    else
                                    SetEntityVisible(GetPlayerPed(-1), true, false)
                                    SetEntityInvincible(GetPlayerPed(-1), false)
                        
                                 end
                            end
                        end)
                    end
                end, RMenu:Get('adminmenu', 'generalfunctions'))
            end
            if admincfg.buttonsEnabled["removewarn"][1] and buttons["removewarn"] then
                RageUI.Button("Remove Warning", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        AddTextEntry('FMMC_MPM_NC', "Enter the Warning ID")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0);
                            Wait(0);
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then 
                                TriggerServerEvent('ATM:RemoveWarning', uid, result)
                            end
                        end
                    end
                end, RMenu:Get('adminmenu', 'generalfunctions'))
            end

            if admincfg.buttonsEnabled["ban"][1] and buttons["ban"] then
                RageUI.Button("Unban Player",nil,{RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local permid = getPermId()
                        TriggerServerEvent("ATM:Unban", permid)
                    end
                end)
            end

            if admincfg.buttonsEnabled["ban"][1] and buttons["ban"] then
                RageUI.Button("Offline Ban",nil,{RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        local permid = getPermId()
                        local banReason = KeyboardInput("Reason:", "", 100)
                        local banTime = KeyboardInput("Hours:", "", 20)
                        TriggerServerEvent('ATM:BanPlayer', uid, permid, banReason, tonumber(banTime))
                    end
                end)
            end
        end)
    end
end)

function getPosition()
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    return x,y,z
  end
  
  
  
  function getCamDirection()
    local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
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

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'entityfunctions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

            if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                RageUI.Button("Entity Cleanup", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ATM:PropCleanup')
                    end
                end, RMenu:Get('adminmenu', 'entityfunctions'))
            end

            if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                RageUI.Button("Deattach Entity Cleanup", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ATM:DeAttachEntity')
                    end
                end, RMenu:Get('adminmenu', 'entityfunctions'))
            end

            if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                RageUI.Button("Vehicle Cleanup", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ATM:VehCleanup')
                    end
                end, RMenu:Get('adminmenu', 'entityfunctions'))
            end

            if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                RageUI.Button("Ped Cleanup", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ATM:PedCleanup')
                    end
                end, RMenu:Get('adminmenu', 'entityfunctions'))
            end

            if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                RageUI.Button("All Cleanup", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ATM:CleanAll')
                    end
                end, RMenu:Get('adminmenu', 'entityfunctions'))
            end

        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'vehiclefunctions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

            if admincfg.buttonsEnabled["vehFunctions"][1] and buttons["vehFunctions"] then
                RageUI.Button("Spawn Vehicle", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        AddTextEntry('FMMC_MPM_NC', "Enter the car spawncode name")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0);
                            Wait(0);
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then 
                                local mhash = GetHashKey(result)
                                local i = 0
                                while not HasModelLoaded(mhash) do
                                    RequestModel(mhash)
                                    i = i + 1
                                    Citizen.Wait(10)
                                    if i > 30 then
                                        
    
                                        break 
                                    end
                                end
                                    
                                    local coords = GetEntityCoords(PlayerPedId())
                                    nveh = CreateVehicle(mhash, coords.x, coords.y, coords.z+0.5, 0.0, true, false)
                        
                                    SetVehicleOnGroundProperly(nveh)
                                    SetEntityInvincible(nveh,false)
                                    SetPedIntoVehicle(GetPlayerPed(-1),nveh,-1) -- put player inside
                                    SetVehicleNumberPlateText(nveh, "P "..tATM.getRegistrationNumber())
                                    --Citizen.InvokeNative(0xAD738C3085FE7E11, nveh, true, true) -- set as mission entity
                                    SetVehicleHasBeenOwnedByPlayer(nveh,true)
                                    nid = NetworkGetNetworkIdFromEntity(nveh)
                                    SetNetworkIdCanMigrate(nid,cfg.vehicle_migration)
                    
                                
                            end
                        end
                    end
                end, RMenu:Get('adminmenu', 'vehiclefunctions'))
            end

            if admincfg.buttonsEnabled["vehFunctions"][1] and buttons["vehFunctions"] then
                RageUI.Button("Fix Vehicle", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local playerPed = GetPlayerPed(-1)
                        if IsPedInAnyVehicle(playerPed, false) then
                            local vehicle = GetVehiclePedIsIn(playerPed, false)
                            SetVehicleEngineHealth(vehicle, 1000)
                            SetVehicleEngineOn( vehicle, true, true )
                            SetVehicleFixed(vehicle)
                            tATM.notify("~g~Your vehicle has been fixed!")
                        else
                            tATM.notify("~o~You're not in a vehicle! There is no vehicle to fix!")
                        end
                    end
                end, RMenu:Get('adminmenu', 'vehiclefunctions'))
            end


            if admincfg.buttonsEnabled["vehFunctions"][1] and buttons["vehFunctions"] then
                RageUI.Button("Clean Vehicle", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local playerPed = GetPlayerPed(-1)
                        if IsPedInAnyVehicle(playerPed, false) then
                            local vehicle = GetVehiclePedIsIn(playerPed, false)
                            SetVehicleDirtLevel(vehicle, 0)
                            tATM.notify("~b~Your vehicle has been cleaned!")
                        else
                            tATM.notify("~o~You're not in a vehicle! There is no vehicle to clean!")
                        end
                    end
                end, RMenu:Get('adminmenu', 'vehiclefunctions'))
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'devfunctions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

            if admincfg.buttonsEnabled["spawnGun"][1] and buttons["spawnGun"] then
                RageUI.Button("Spawn Weapon", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        AddTextEntry('FMMC_MPM_NC', "Enter the weapon hash!")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0);
                            Wait(0);
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then 
                              --  ATMclient.allowWeapon(result, "-1")
                                Wait(500)
                                GiveWeaponToPed(PlayerPedId(), result, 250, false, true)
                                if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(result) then 
                                    notify("~g~Successfuly spawned in weapon!")
                                else
    
                                    notify("~r~Failed to spawn in weapon!")
                                end
                            end
                        end
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end

            if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                RageUI.Button("Get Coords", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ATMDEV:GetCoords')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end

            if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                RageUI.Button("Teleport to Coords",nil,{RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ATM:Tp2Coords")
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end


            

        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'searchpermid')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

            if foundMatch == false then
                searchforPermID = KeyboardInput("Enter Perm ID", "", 10)
                if searchforPermID == nil then 
                    searchforPermID = ""
                end
            end

            for k, v in pairs(players) do
                foundMatch = true
                if string.find(v[3],searchforPermID) then
                    RageUI.Button("[" .. v[3] .. "] " .. v[1],nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SelectedPlayer = players[k]
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end
             end
            end)
        end
    end)

    RageUI.CreateWhile(1.0, true, function()
        if RageUI.Visible(RMenu:Get('adminmenu', 'searchtempid')) then
            RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

                if foundMatch == false then
                    searchid = KeyboardInput("Enter Temp ID", "", 10)
                    if searchid == nil then 
                        searchid = ""
                    end
                end
    
                for k, v in pairs(players) do
                    foundMatch = true
                    if string.find(v[2], searchid) then
                        RageUI.Button("[" .. v[3] .. "] " .. v[1], nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                SelectedPlayer = players[k]
                            end
                        end, RMenu:Get('adminmenu', 'submenu'))
                    end
                end
            end)
        end
    end)

        RageUI.CreateWhile(1.0, true, function()
            if RageUI.Visible(RMenu:Get('adminmenu', 'searchname')) then
                RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

                    if foundMatch == false then
                        SearchName = KeyboardInput("Enter Name", "", 10)
                    end

                    if SearchName == nil then 
                        SearchName = ""
                    end
            
                        for k, v in pairs(players) do
                            foundMatch = true
                            if string.match(v[1],SearchName) then
                                RageUI.Button("[" .. v[2] .. "] " .. v[1], nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        --RMenu:Get("adminmenu", "submenu"):SetSubtitle("Name: " .. v[1] .. " Perm ID: " .. v[3] .. " Temp ID: " .. v[2])
                                        SelectedPlayer = players[k]
                                    end
                                end, RMenu:Get('adminmenu', 'submenu'))
                            end
                         end
 
                    
                end)
            end
        end)

        RageUI.CreateWhile(1.0, true, function()
            if RageUI.Visible(RMenu:Get('adminmenu', 'submenu')) then
                RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
    
                  
                        RageUI.Button("Teleport Player", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)end, RMenu:Get('adminmenu', 'teleportmenu'))
                 
                        RageUI.Button("Control Player", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)end, RMenu:Get('adminmenu', 'control'))
                
                        RageUI.Button("Manage Player", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)end, RMenu:Get('adminmenu', 'manage'))
                   
                        RageUI.Button("Punish Player", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)end, RMenu:Get('adminmenu', 'punishment'))
                  
                    
                end)
            end
        end)

        RageUI.CreateWhile(1.0, true, function()
            if RageUI.Visible(RMenu:Get('adminmenu', 'control')) then
                RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
    
    
                    if admincfg.buttonsEnabled["FREEZE"][1] and buttons["FREEZE"] then
                        RageUI.Button("Freeze Player", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local uid = GetPlayerServerId(PlayerId())
                                isFrozen = not isFrozen
                                TriggerServerEvent('ATM:FreezeSV', uid, SelectedPlayer[2], isFrozen)
                            end
                        end)
                    end
    
                    if admincfg.buttonsEnabled["slap"][1] and buttons["slap"] then
                        RageUI.Button("Slap Player", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local uid = GetPlayerServerId(PlayerId())
                                TriggerServerEvent('ATM:SlapPlayer', uid, SelectedPlayer[2])
                            end
                        end)
                    end
                    
    
                    if admincfg.buttonsEnabled["revive"][1] and buttons["revive"] then
                        RageUI.Button("Revive Player", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local uid = GetPlayerServerId(PlayerId())
                                TriggerServerEvent('ATM:RevivePlayer', uid, SelectedPlayer[2])
                            end
                        end)
                    end
    
    
                    if admincfg.buttonsEnabled["spectate"][1] and buttons["spectate"] then
                        RageUI.Button("Spectate Player", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                --SetEntityCoords(PlayerPedId(), GetEntityCoords(SelectedPlayer[2]))
                                TriggerServerEvent('ATMAdmin:SpectatePlr', SelectedPlayer[3])
                            end
                        end)
                    end
    
                    
                end)
            end
        end)
        -- [Manage Player]
        RageUI.CreateWhile(1.0, true, function()
            if RageUI.Visible(RMenu:Get('adminmenu', 'manage')) then
                RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
    
    
    
                    
                    if admincfg.buttonsEnabled["addcar"][1] and buttons["addcar"] then
                        RageUI.Button("Add Import Car", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                AddTextEntry('FMMC_MPM_NC', "Enter the car spawncode")
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0);
                                    Wait(0);
                                end
                                if (GetOnscreenKeyboardResult()) then
                                    local result = GetOnscreenKeyboardResult()
                                    if result then 
                                        TriggerServerEvent('ATM:AddCar', SelectedPlayer[3], result)
                                    end
                                end
                            end
                        end, RMenu:Get('adminmenu', 'submenu'))
                    end
    
                    if admincfg.buttonsEnabled["getgroups"][1] and buttons["getgroups"] then
                        RageUI.Button("Get Groups",nil,{RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent("ATM:getGroups", SelectedPlayer[2], SelectedPlayer[3])
                            end
                        end,RMenu:Get("adminmenu", "groups"))
                    end
                    
                    if admincfg.buttonsEnabled["showwarn"][1] and buttons["showwarn"] then
                        RageUI.Button("Show Player Warnings", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                ExecuteCommand("showwarnings " .. SelectedPlayer[3])
                            end
                        end)
                    end
                    
                end)
            end
        end)
        -- [Punishment Sub Menu]
        RageUI.CreateWhile(1.0, true, function()
            if RageUI.Visible(RMenu:Get('adminmenu', 'punishment')) then
                RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
    
    
                    if admincfg.buttonsEnabled["ban"][1] and buttons["ban"] then
                            RageUI.Button("Ban Player", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                                if Selected then
    
                                end
                            end, RMenu:Get('adminmenu', 'bansub'))
                    end
                        
                    if admincfg.buttonsEnabled["kick"][1] and buttons["kick"] then
                        RageUI.Button("Kick Player", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local kickReason = KeyboardInput("Reason:", "", 100)
                                local uid = GetPlayerServerId(PlayerId())
                                TriggerServerEvent('ATM:KickPlayer', uid, SelectedPlayer[3], kickReason, SelectedPlayer[2])
                            end
                        end)
                    end
    
                    if admincfg.buttonsEnabled["nof10kick"][1] and buttons["nof10kick"] then
                        RageUI.Button("No F10 Kick", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local kickReason = KeyboardInput("Reason:", "", 100)
                                local uid = GetPlayerServerId(PlayerId())
                                TriggerServerEvent('ATM:KickPlayerNoF10', uid, SelectedPlayer[3], kickReason)
                            end
                        end)
                    end
    
                    if admincfg.buttonsEnabled["warn"][1] and buttons["warn"] then
                        RageUI.Button("Warn Player", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                            if Selected then
    
                            end
                        end, RMenu:Get('adminmenu', 'warnsub'))
                    end
    
    
                    
                end)
            end
        end)

warningbankick = {
    {name = "Racism", desc = "Racism"},
    {name = "Toxicity", desc = "Toxicity"},
    {name = "Homophobia", desc = "Homophobia"},
    {name = "RDM", desc = "RDM"},
    {name = "Mass RDM", desc = "Mass RDM"},
    {name = "Cheating/ Modding", desc = "Cheating/ Modding"},
    {name = "Trolling", desc = "Trolling"},
    {name = "Meta Gaming", desc = "Meta Gaming"},
    {name = "Power Gaming", desc = "Power Gaming"},
    {name = "Fail RP", desc = "Fail RP"},
    {name = "NRTI", desc = "No Reason To Initiate"},
    {name = "VDM", desc = "VDM"},
    {name = "Mass VDM", desc = "Mass VDM"},
    {name = "Offensive Language", desc = "Offensive Language"},
    {name = "Severe Offensive Language", desc = "Severe Offensive Language"},
    {name = "Breaking Character", desc = "Breaking Character"},
    {name = "Combat Logging", desc = "Combat Logging"},
    {name = "Combat Storing", desc = "Combat Storing"},
    {name = "Exploiting", desc = "Exploiting"},
    {name = "Severe Exploiting", desc = "Severe Exploiting"},
    {name = "OOGT", desc = "Out of game transactions"},
    {name = "Spite Reporting", desc = "Spite Reporting"},
    {name = "Scamming", desc = "Scamming"},
    {name = "Wasting Admins Time", desc = "Wasting Admins Time"},
    {name = "FTVL", desc = "Failure to value life"},
    {name = "Sexual RP", desc = "Sexual RP"},
    {name = "Imperonation of a whitelisted faction", desc = "Imperonation of a whitelisted faction"},
    {name = "GTA Driving", desc = "Grand Theft Auto Driving"},
    {name = "NLR", desc = "New Life Rule"},
    {name = "NITRP", desc = "No Intention to roleplay"},
    {name = "Kidnapping", desc = "Kidnapping"},
    {name = "Whitelist Abuse", desc = "Whitelist Abuse"},
    {name = "Severe Whitelist Abuse", desc = "Severe Whitelist Abuse"},
    {name = "Cop Baiting", desc = "Cop Baiting"},
    --{name = "Police Kidnapping", desc = "Metropolitan Police Kidnapping"},

}

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'warnsub')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

            if admincfg.buttonsEnabled["warn"][1] and buttons["warn"] then
                for i , p in pairs(warningbankick) do 
                    RageUI.Button("Warn Player for "..p.name, nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        
                            TriggerServerEvent("atm:warnPlayer",SelectedPlayer[3],p.name)
                            notify(SelectedPlayer[3])
                            notify("~g~Warned Player for "..p.name)
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                 end
            end

        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'bansub')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

            
            if admincfg.buttonsEnabled["ban"][1] and buttons["ban"] then
                RageUI.Button("[Custom Ban Message]", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
            
                        local uid  GetPlayerServerId(PlayerId())
         
                        local reason2 = KeyboardInput("Reason:", "", 20)

                        if reason2 == nil then 
                            RageUI.CloseAll()
                        end
                        if banTime == nil then 
                            RageUI.CloseAll()
                        end
                        print(reason2)
                        
                        if reason2 then 
                            timeForBan = KeyboardInput("Hours:", "", 20)
                            TriggerServerEvent('ATM:BanPlayer', uid, SelectedPlayer[3], reason2, timeForBan)
                        end
                        
                    end
                end, RMenu:Get('adminmenu', 'submenu'))

                for i , p in pairs(warningbankick) do 
                    RageUI.Button("Ban Player for "..p.name, nil, { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            local banTime = KeyboardInput("Hours:", "", 20)
                            TriggerServerEvent('ATM:BanPlayer', uid, SelectedPlayer[3], p.name, tonumber(banTime))
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                 end

            end

                          


           

        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'teleportmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if admincfg.buttonsEnabled["TP2"][1] and buttons["TP2"] then
                RageUI.Button("Teleport to Player", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local newSource = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('ATM:TeleportToPlayer', newSource, SelectedPlayer[2])
                        notify('~g~Teleported to player.')
                    end
                end, RMenu:Get('adminmenu', 'teleportmenu'))
            end

            if admincfg.buttonsEnabled["TPLoc"][1] and buttons["TPLoc"] then
                RageUI.Button("Teleport Player To Me", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ATMAdmin:Bring', SelectedPlayer[3])
                        notify('~g~Teleported player to you.')
                    end
                end, RMenu:Get('adminmenu', 'teleportmenu'))
            end

            if admincfg.buttonsEnabled["TP2ME"][1] and buttons["TP2ME"] then
                RageUI.Button("Teleport Player To Admin Island", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ATM:Teleport2AdminIsland", SelectedPlayer[2])
                        notify('~g~Teleported player to Admin Island.')
                    end
                end, RMenu:Get('adminmenu', 'teleportmenu'))
            end

            if admincfg.buttonsEnabled["TP2ME"][1] and buttons["TP2ME"] then
                RageUI.Button("Return Player to Previous Location", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ATM:returnplayer", SelectedPlayer[2])
                        notify('~g~Returned Player.')
                    end
                end, RMenu:Get('adminmenu', 'teleportmenu'))
            end
                if admincfg.buttonsEnabled["TPLoc"][1] and buttons["TPLoc"] then -- TPLoc
                    RageUI.Button("", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                        
                        end
                    end, RMenu:Get('adminmenu', 'teleportmenu'))
                end

                if admincfg.buttonsEnabled["TPLoc"][1] and buttons["TPLoc"] then -- TPLoc
                    RageUI.Button("Teleport Player Legion Bank", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("ATM:Teleport", SelectedPlayer[2], vector3(151.61740112305,-1035.05078125,29.339416503906))
                            notify('~g~Teleported player to location.')
                        end
                    end, RMenu:Get('adminmenu', 'teleportmenu'))
                end

                if admincfg.buttonsEnabled["TPLoc"][1] and buttons["TPLoc"] then
                    RageUI.Button("Teleport Player To City License Centre", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("ATM:Teleport", SelectedPlayer[2], vector3(-537.10968017578,-217.92503356934,37.64965057373 ))
                            notify('~g~Teleported player to location.')
                        end
                    end, RMenu:Get('adminmenu', 'teleportmenu'))
                end

                if admincfg.buttonsEnabled["TPLoc"][1] and buttons["TPLoc"] then
                    RageUI.Button("Teleport Player To Sandy License Centre", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("ATM:Teleport", SelectedPlayer[2], vector3(1707.1434326172,3775.55078125,34.537727355957))
                            notify('~g~Teleported player to location.')
                        end
                    end, RMenu:Get('adminmenu', 'teleportmenu'))
                end
                
                if admincfg.buttonsEnabled["TPLoc"][1] and buttons["TPLoc"] then
                    RageUI.Button("Teleport Player Rebel Diner", nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("ATM:Teleport", SelectedPlayer[2], vector3(1581.6401367188,6445.6494140625,24.999206542969))
                            notify('~g~Teleported player to location.')
                        end
                    end, RMenu:Get('adminmenu', 'teleportmenu'))
                end
        
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'groups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if admincfg.buttonsEnabled["staffGroups"][1] and buttons["staffGroups"] then
                RageUI.Button("Staff Groups", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then
        
                    end
                    if (Active) then
        
                    end
                    if (Selected) then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("Staff Groups")
                    end
                end, RMenu:Get('adminmenu', 'staffGroups'))
            end
            if admincfg.buttonsEnabled["licenseGroups"][1] and buttons["licenseGroups"] then
                RageUI.Button("License Groups", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then
        
                    end
                    if (Active) then
        
                    end
                    if (Selected) then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("License Groups")
                    end
                end, RMenu:Get('adminmenu', 'LicenseGroups'))
            end
            if admincfg.buttonsEnabled["povGroups"][1] and buttons["povGroups"] then
                RageUI.Button("POV Groups", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then

                    end
                    if (Active) then

                    end
                    if (Selected) then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("POV Groups")
                    end
                end, RMenu:Get('adminmenu', 'POVGroups'))
            end
            if admincfg.buttonsEnabled["mpdGroups"][1] and buttons["mpdGroups"] then
                RageUI.Button("Police Groups", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then

                    end
                    if (Active) then

                    end
                    if (Selected) then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("POV Groups")
                    end
                end, RMenu:Get('adminmenu', 'PoliceGroups'))
            end
            if admincfg.buttonsEnabled["nhsGroups"][1] and buttons["nhsGroups"] then
                RageUI.Button("NHS Groups", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then

                    end
                    if (Active) then

                    end
                    if (Selected) then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("POV Groups")
                    end
                end, RMenu:Get('adminmenu', 'NHSGroups'))
            end
            if admincfg.buttonsEnabled["donoGroups"][1] and buttons["donoGroups"] then
                RageUI.Button("Donator Groups", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then
        
                    end
                    if (Active) then
        
                    end
                    if (Selected) then
                        
                    end
                end, RMenu:Get('adminmenu', 'UserGroups'))
            end
        end) 
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'staffGroups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for k,v in pairs(getStaffGroupsGroupIds) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "addgroup"):SetTitle("")
                            RMenu:Get("adminmenu", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'addgroup'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'PoliceGroups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for k,v in pairs(getUserPoliceGroups) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "addgroup"):SetTitle("")
                            RMenu:Get("adminmenu", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'addgroup'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'UserGroups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for k,v in pairs(getUserGroupsGroupIds) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "addgroup"):SetTitle("")
                            RMenu:Get("adminmenu", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'addgroup'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'LicenseGroups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for k,v in pairs(getUserLicenseGroups) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "addgroup"):SetTitle("")
                            RMenu:Get("adminmenu", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'addgroup'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'POVGroups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for k,v in pairs(getUserPOVGroups) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "addgroup"):SetTitle("")
                            RMenu:Get("adminmenu", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'addgroup'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'NHSGroups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for k,v in pairs(getUserNHSGroups) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "addgroup"):SetTitle("")
                            RMenu:Get("adminmenu", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'addgroup'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'addgroup')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

            RageUI.Button("Add this group to user", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    
                    TriggerServerEvent("ATM:addGroup",SelectedPerm,selectedGroup)
                end
            end, RMenu:Get('adminmenu', 'groups'))
            
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'removegroup')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

            RageUI.Button("Remove user from group", "", { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    TriggerServerEvent("ATM:removeGroup",SelectedPerm,selectedGroup)
                end
            end, RMenu:Get('adminmenu', 'groups'))
            
        end)
    end
end)

RegisterNetEvent('ATM:SlapPlayer')
AddEventHandler('ATM:SlapPlayer', function()
    SetEntityHealth(PlayerPedId(), 0)
end)

FrozenPlayer = false

RegisterNetEvent('ATM:Freeze')
AddEventHandler('ATM:Freeze', function(isForzen)
    FrozenPlayer = isForzen
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if FrozenPlayer then
            FreezeEntityPosition(PlayerPedId(), true)
        else
            FreezeEntityPosition(PlayerPedId(), false)
        end
    end
end)

RegisterNetEvent('ATM:Teleport')
AddEventHandler('ATM:Teleport', function(coords)
    print(coords)
    SetEntityCoords(PlayerPedId(), coords)
end)

RegisterNetEvent('ATM:Teleport2Me2')
AddEventHandler('ATM:Teleport2Me2', function(target2)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target2)))
    SetEntityCoords(PlayerPedId(), coords)
end)


RegisterNetEvent("ATM:SendPlayersInfo")
AddEventHandler("ATM:SendPlayersInfo",function(players_table, btns)
    players = players_table
    buttons = btns
    RageUI.Visible(RMenu:Get("adminmenu", "main"), not RageUI.Visible(RMenu:Get("adminmenu", "main")))
end)

local InSpectatorMode	= false
local TargetSpectate	= nil
local LastPosition		= nil
local polarAngleDeg		= 0;
local azimuthAngleDeg	= 90;
local radius			= -3.5;
local cam 				= nil
local PlayerDate		= {}
local ShowInfos			= false
local group

local function polar3DToWorld3D(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)

    local polarAngleRad   = polarAngleDeg   * math.pi / 180.0
	local azimuthAngleRad = azimuthAngleDeg * math.pi / 180.0

	local pos = {
		x = entityPosition.x + radius * (math.sin(azimuthAngleRad) * math.cos(polarAngleRad)),
		y = entityPosition.y - radius * (math.sin(azimuthAngleRad) * math.sin(polarAngleRad)),
		z = entityPosition.z - radius * math.cos(azimuthAngleRad)
	}

	return pos
end


RegisterNetEvent('ATM:SpectateClient')
AddEventHandler('ATM:SpectateClient', function(target)
    TargetSpectate = target
    SpectatePlayer()
end)


function StopSpectatePlayer()

    InSpectatorMode = false
    TargetSpectate  = nil
    local playerPed = PlayerPedId()
    SetCamActive(cam,  false)
    DestroyCam(cam, true)
    RenderScriptCams(false, false, 0, true, true)
    SetEntityVisible(playerPed, true)
    SetEntityCollision(playerPed, true, true)
    FreezeEntityPosition(playePed, false)
    if savedCoords ~= vec3(0,0,1) then SetEntityCoords(PlayerPedId(), savedCoords) else SetEntityCoords(PlayerPedId(), 3537.363, 3721.82, 36.467) end
end

function SpectatePlayer()
    savedCoords = GetEntityCoords(PlayerPedId())
    SetEntityCoords(PlayerPedId(), Coords)
    InSpectatorMode = true
    local playerPed = PlayerPedId()
    SetEntityCollision(playerPed, false, false)
    SetEntityVisible(playerPed, false)
    FreezeEntityPosition(playePed, true)
    Citizen.CreateThread(function()

        if not DoesCamExist(cam) then
            cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        end

        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)

    end, TargetSpectate)
    RequestCollisionAtCoord(NetworkGetPlayerCoords(GetPlayerFromServerId(tonumber(TargetSpectate))))
end

Citizen.CreateThread(function()
    while (true) do
        Wait(0)
        if InSpectatorMode then
            DrawHelpMsg("Press ~INPUT_CONTEXT~ to Stop Spectating")
            if IsControlJustPressed(1, 51) then
                StopSpectatePlayer()
            end
        end
    end
end)

RegisterNetEvent("ATM:gotgroups")
AddEventHandler("ATM:gotgroups",function(gotGroups)
    searchPlayerGroups = gotGroups
end)

Citizen.CreateThread(function()
    while (true) do
        Wait(0)
        if InSpectatorMode then
        
			local targetPlayerId = GetPlayerFromServerId(tonumber(TargetSpectate))
			local playerPed	  = GetPlayerPed(-1)
			local targetPed	  = GetPlayerPed(targetPlayerId)
            local coords	 =  NetworkGetPlayerCoords(GetPlayerFromServerId(tonumber(TargetSpectate)))
            
            Draw2DText(0.22, 0.90, 'Health: ~g~' .. GetEntityHealth(targetPed) .. " / " .. GetEntityMaxHealth(targetPed), 0.65) 
            Draw2DText(0.22, 0.86, 'Armor: ~b~' .. GetPedArmour(targetPed) .. " / " .. GetPlayerMaxArmour(targetPlayerId), 0.65)
			for i=0, 32, 1 do
				if i ~= PlayerId() then
					local otherPlayerPed = GetPlayerPed(i)
					SetEntityNoCollisionEntity(playerPed,  otherPlayerPed,  true)
					SetEntityVisible(playerPed, false)
				end
			end

			if IsControlPressed(2, 241) then
				radius = radius + 2.0;
			end

			if IsControlPressed(2, 242) then
				radius = radius - 2.0;
			end

			if radius > -1 then
				radius = -1
			end

			local xMagnitude = GetDisabledControlNormal(0, 1);
			local yMagnitude = GetDisabledControlNormal(0, 2);

			polarAngleDeg = polarAngleDeg + xMagnitude * 10;

			if polarAngleDeg >= 360 then
				polarAngleDeg = 0
			end

			azimuthAngleDeg = azimuthAngleDeg + yMagnitude * 10;

			if azimuthAngleDeg >= 360 then
				azimuthAngleDeg = 0;
			end

			local nextCamLocation = polar3DToWorld3D(coords, radius, polarAngleDeg, azimuthAngleDeg)

            SetCamCoord(cam,  nextCamLocation.x,  nextCamLocation.y,  nextCamLocation.z)
            PointCamAtEntity(cam,  targetPed)
			SetEntityCoords(playerPed, coords.x, coords.y, coords.z + 10)
        end
    end
end)

function Draw2DText(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
  end

RegisterNetEvent('ATM:Notify')
AddEventHandler('ATM:Notify', function(string)
    notify('~g~' .. string)
end)

RegisterCommand('openadminmenu',function()
    TriggerServerEvent("ATM:GetPlayerData")
end)

RegisterKeyMapping('openadminmenu', 'Opens the Admin menu', 'keyboard', 'F2')

function DrawHelpMsg(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true 
    
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() 
		Citizen.Wait(500) 
		blockinput = false 
		return result 
	else
		Citizen.Wait(500)
		blockinput = false 
		return nil 
	end
end

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

function SpawnVehicle(VehicleName)
	local hash = GetHashKey(VehicleName)
	RequestModel(hash)
	local i = 0
	while not HasModelLoaded(hash) and i < 50 do
		Citizen.Wait(10)
		i = i + 1
	end
    if i >= 50 then
        return
	end
	local Ped = PlayerPedId()
	local Vehicle = CreateVehicle(hash, GetEntityCoords(Ped), GetEntityHeading(Ped), true, 0)
    i = 0
	while not DoesEntityExist(Vehicle) and i < 50 do
		Citizen.Wait(10)
		i = i + 1
	end
	if i >= 50 then
		return
	end
    SetPedIntoVehicle(Ped, Vehicle, -1)
    SetModelAsNoLongerNeeded(hash)
end

function getWarningUserID()
AddTextEntry('FMMC_MPM_NA', "Enter ID of the player you want to warn?")
DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter ID of the player you want to warn?", "1", "", "", "", 30)
while (UpdateOnscreenKeyboard() == 0) do
    DisableAllControlActions(0);
    Wait(0);
end
if (GetOnscreenKeyboardResult()) then
    local result = GetOnscreenKeyboardResult()
    if result then
        return result
    end
end
return false
end

function getWarningUserMsg()
AddTextEntry('FMMC_MPM_NA', "Enter warning message")
DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter warning message", "", "", "", "", 30)
while (UpdateOnscreenKeyboard() == 0) do
    DisableAllControlActions(0);
    Wait(0);
end
if (GetOnscreenKeyboardResult()) then
    local result = GetOnscreenKeyboardResult()
    if result then
        return result
    end
end
return false
end

RegisterNetEvent("ATM:TPCoords")
AddEventHandler("ATM:TPCoords", function(coords)
    SetEntityCoordsNoOffset(GetPlayerPed(-1), coords.x, coords.y, coords.z, false, false, false)
end)

function getPermId()
	AddTextEntry('FMMC_MPM_NA', "Enter Perm ID")
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter Perm ID", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
		if result then
			return result
		end
    end
	return false
end

RegisterNetEvent("ATM:EntityWipe")
AddEventHandler("ATM:EntityWipe", function(id)
    Citizen.CreateThread(function() 
        for k,v in pairs(GetAllEnumerators()) do 
            local enum = v
            for entity in enum() do 
                local owner = NetworkGetEntityOwner(entity)
                local playerID = GetPlayerServerId(owner)
                NetworkDelete(entity)
            end
        end
    end)
end)

local Spectating = false;
local LastCoords = nil;
RegisterNetEvent('ATMAdmin:Spectate')
AddEventHandler('ATMAdmin:Spectate', function(plr,tpcoords)
    local playerPed = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(plr))
    if not Spectating then
        LastCoords = GetEntityCoords(playerPed) 
        if tpcoords then 
            SetEntityCoords(playerPed, tpcoords - 10.0)
        end
        Wait(300)
        targetPed = GetPlayerPed(GetPlayerFromServerId(plr))
        if targetPed == playerPed then tATM.notify('~r~I mean you cannot spectate yourself...') return end
		NetworkSetInSpectatorMode(true, targetPed)
        SetEntityCollision(playerPed, false, false)
        SetEntityVisible(playerPed, false, 0)
		SetEveryoneIgnorePlayer(playerPed, true)	
		
        Spectating = true

        while Spectating do
            local targetSpeedMph = GetEntitySpeed(targetPed) * 2.236936

            DrawAdvancedText(0.322, 0.828, 0.025, 0.0048, 0.5, "Health: "..GetEntityHealth(targetPed), 255, 0, 0, 255, 6, 0)
            DrawAdvancedText(0.320, 0.850, 0.025, 0.0048, 0.5, "Armour: "..GetPedArmour(targetPed), 255, 0, 0, 255, 6, 0)
            if IsPedSittingInAnyVehicle(targetPed) then
                DrawAdvancedText(0.320, 0.872, 0.025, 0.0048, 0.5, "Speed: "..math.floor(targetSpeedMph), 255, 0, 0, 255, 6, 0)
            end
            Wait(0)
        end

        tATM.notify('~g~Spectating Player.')
    else 
        NetworkSetInSpectatorMode(false, targetPed)
        SetEntityVisible(playerPed, true, 0)
		SetEveryoneIgnorePlayer(playerPed, false)
		
		SetEntityCollision(playerPed, true, true)
        Spectating = false;
        SetEntityCoords(playerPed, LastCoords)
        tATM.notify('~r~Stopped Spectating Player.')
    end 
end)