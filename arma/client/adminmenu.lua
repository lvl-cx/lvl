ARMAclient = Tunnel.getInterface("ARMA","ARMA")

local user_id = 0

local foundMatch = false
local inSpectatorAdminMode = false
local players = {}
local playersNearby = {}
local playersNearbyDistance = 250
local searchPlayerGroups = {}
local selectedGroup
local Groups = {}
local povlist = ''
local SelectedPerm = nil
local SelectedName = nil
local SelectedPlayerSource = nil
local hoveredPlayer = nil
local GlobalAdminLevel = 0
local punishmentreasons = nil


local f = nil
local g
local h = {}
local i = 1
local k = {}

bantarget = nil
bantargetname = nil
banduration = 0
banevidence = nil
banstable = {}
banreasons = ''

local acbannedplayers = 0
local acadminname = ''
local acbannedplayerstable = {}
local actypes = {}

admincfg = {}

admincfg.perm = "admin.tickets"
admincfg.IgnoreButtonPerms = false
admincfg.admins_cant_ban_admins = false

local tpLocationColour = '~b~'
local q = {tpLocationColour.."Legion", tpLocationColour.."Military Base", tpLocationColour.."Rebel Diner", tpLocationColour.."Heroin", tpLocationColour.."Casino"}
local r = {
    vector3(151.61740112305,-1035.05078125,29.339416503906),
    vector3(-2271.967, 3226.964, 32.81018),
    vector3(1582.8811035156,6450.40234375,25.189323425293),
    vector3(2985.07, 3489.944, 71.38177),
    vector3(923.24499511719,48.181098937988,81.106323242188),
}
local s = 1



--[[ {enabled -- true or false}, permission required ]]

menuColour = '~b~'

RMenu.Add('adminmenu', 'main', RageUI.CreateMenu("", "~b~Admin Menu", 1300,100, "admin","admin"))
RMenu.Add('SettingsMenu', 'MainMenu', RageUI.CreateMenu("", menuColour.."Settings Menu", 1300,100, "settings","settings")) 
RMenu.Add("SettingsMenu", "crosshairsettings", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu"), "", menuColour..'Crosshair Settings',1300,100,"settings","settings"))

RMenu.Add("adminmenu", "players", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Interaction Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "closeplayers", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Interaction Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "searchoptions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Search Menu',1300,100,"admin","admin"))

--[[ Functions ]]
RMenu.Add("adminmenu", "functions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Functions Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "devfunctions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Dev Functions Menu',1300,100,"admin","admin"))
--[[ End of Functions ]]

--[[ AntiCheat ]]
RMenu.Add("adminmenu", "anticheat", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "devfunctions"), "", menuColour..'AntiCheat Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "actypes", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "devfunctions"), "", menuColour..'AC Types',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "acbannedplayers", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "devfunctions"), "", menuColour..'AC Banned Players',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "acbanmenu", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "devfunctions"), "", menuColour..'AC Banned Player Submenu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "acmanualbanlist", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "devfunctions"), "", menuColour..'AC Manual Ban',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "acmanualban", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "devfunctions"), "", menuColour..'Choose an AC Type to ban for',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "confirmacban", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "devfunctions"), "", menuColour..'Confirm AC Ban',1300,100,"admin","admin"))

RMenu.Add("adminmenu", "submenu", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Admin Player Interaction Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "searchname", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "searchtempid", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "searchpermid", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "searchhistory", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "bansub", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Select Ban Reasons',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "durationsubmenu", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "bansub"), "", menuColour..'Ban Duration',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "confirmban", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "submenu"), "", menuColour..'Confirm Ban',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "notesub", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Player Notes',1300,100,"admin","admin"))

--[[groups]]
RMenu.Add("adminmenu", "groups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "submenu"), "", menuColour..'Admin Groups Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "staffGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "UserGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "POVGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "LicenseGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "MPDGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "NHSGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "addgroup", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"admin","admin"))
RMenu.Add("adminmenu", "removegroup", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"admin","admin"))
RMenu:Get('adminmenu', 'main')

local getStaffGroupsGroupIds = {
	["founder"] = "Founder",
    ["operationsmanager"] = "Operations Manager",
    ["staffmanager"] = "Staff Manager",
    ["commanager"] = "Community Manager",
    ["headadmin"] = "Head Admin",
    ["senioradmin"] = "Senior Admin",
	["administrator"] = "Admin",
    ["srmoderator"] = "Senior Moderator",
	["moderator"] = "Moderator",
    ["supportteam"] = "Support Team",
    ["trialstaff"] = "Trial Staff",
    ["cardev"] = "Car Developer",
}
local getUserGroupsGroupIds = {
    ["Supporter"] = "Supporter",
    ["Platinum"] = "Platinum",
    ["Godfather"] = "Godfather",
    ["Underboss"] = "Underboss",
}
local getUserPOVGroups = {
    ["pov"] = "POV List",
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
    ["highroller"] = "Highrollers",
}

local getUserMPDGroups = {
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



RageUI.CreateWhile(1.0, true, function()
    if GlobalAdminLevel > 0 then
        if RageUI.Visible(RMenu:Get('adminmenu', 'main')) then
            RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
                hoveredPlayer = nil
                RageUI.ButtonWithStyle("All Players", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'players'))
                RageUI.ButtonWithStyle("Nearby Players", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Jud:GetNearbyPlayers", 250)
                    end
                end, RMenu:Get('adminmenu', 'closeplayers'))
                RageUI.ButtonWithStyle("Search Players", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'searchoptions'))
                RageUI.ButtonWithStyle("Functions", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'functions'))
                RageUI.ButtonWithStyle("Settings", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('SettingsMenu', 'MainMenu'))
            end)
        end
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'players')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k, v in pairs(players) do
                RageUI.ButtonWithStyle(v[1] .." ["..v[2].."]", v[1] .. " ("..v[4].." hours) PermID: " .. v[3] .. " TempID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        SelectedPlayer = players[k]
                        SelectedPerm = v[3]
                        TriggerServerEvent("ARMA:CheckPov",v[3])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'closeplayers')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if next(playersNearby) then
                --RageUI.Separator("Nearby player distance: "..playersNearbyDistance.."m", function() end)
                for i, v in pairs(playersNearby) do
                    RageUI.ButtonWithStyle(v[1] .." ["..v[2].."]", v[1] .. " ("..v[4].." hours) PermID: " .. v[3] .. " TempID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then 
                            SelectedPlayer = playersNearby[i]
                            SelectedPerm = v[3]
                        end
                        if Active then 
                            hoveredPlayer = v[2]
                        end
                    end, RMenu:Get("adminmenu", "submenu"))
                end
                --[[ RageUI.Separator("Press [Space] to adjust distance", function() end)
                if IsControlJustPressed(1, 22) then
                    playersNearbyDistance = KeyboardInput("Enter Distance in m", "", 10)
                    if playersNearbyDistance ~= nil then
                        TriggerServerEvent("Jud:GetNearbyPlayers", tonumber(playersNearbyDistance))
                    else
                        notify('~r~You must input a distance.')
                    end
                end ]]
            else
                RageUI.Separator("No players nearby!")
            end
        end)
    end
end)

RegisterNetEvent("Jud:ReturnNearbyPlayers")
AddEventHandler("Jud:ReturnNearbyPlayers", function(table)
    playersNearby = table
end)


local df = {{"10%", 0.1},{"20%", 0.2},{"30%", 0.3},{"40%", 0.4},{"50%", 0.5},{"60%", 0.6},{"70%", 0.7},{"80%", 0.8},{"90%", 0.9},{"100%", 1.0},{"150%", 1.5},{"200%", 2.0},{"250%", 2.5},{"300%", 3.0},{"350%", 3.5},{"400%", 4.0},{"450%", 4.5},{"500%", 5.0},{"600%", 6.0},{"700%", 7.0},{"800%", 8.0},{"900%", 9.0},{"1000%", 10.0},}
local d = {"10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%", "150%", "200%", "250%", "300%", "350%", "400%", "450%", "500%", "600%", "700%", "800%", "900%", "1000%"}
local dts = 10


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('SettingsMenu', 'MainMenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.List("Modify Render Distance", d, dts, "~b~Change Render Distance", {}, true, function(a,b,c,d)
                if c then -- Locals...
                end
                dts = d -- Locals ...
            end)
            RageUI.Checkbox("Toggle Compass", nil, compasschecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if Selected then
                    compasschecked = not compasschecked
                    ExecuteCommand("compass")
                end
            end)
            RageUI.Checkbox("Disable Hitsounds", nil, hitsoundchecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if Selected then
                    hitsoundchecked = not hitsoundchecked
                    TriggerEvent("hs:triggerSounds")
                end
            end)
            RageUI.Checkbox("Toggle Hud", nil, hudchecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if Selected then
                    hudchecked = not hudchecked
                    if Checked then
                        ExecuteCommand('showhud')
                    else
                        ExecuteCommand('showhud')
                    end
                end
            end)
            RageUI.Checkbox("Toggle Killfeed", nil, killfeedchecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if Selected then
                    killfeedchecked = not killfeedchecked
                    if Checked then
                        ExecuteCommand('killfeed')
                    else
                        ExecuteCommand('killfeed')
                    end
                end
            end)
            RageUI.ButtonWithStyle("~b~Crosshair Settings", "~b~Change your crosshair settings", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('SettingsMenu', 'crosshairsettings'))
       end)
    end
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('SettingsMenu', 'crosshairsettings')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Checkbox("Enable Crosshair", nil, crosshairchecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if Selected then
                    crosshairchecked = not crosshairchecked
                    if Checked then
                        ExecuteCommand("cross")
                        notify("~g~Crosshair Enabled!")
                    else
                        ExecuteCommand("cross")
                        notify("~r~Crosshair Disabled!")
                    end
                end
            end)
            RageUI.ButtonWithStyle("Edit Crosshair", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ExecuteCommand("crosse")
                end
            end)
            RageUI.ButtonWithStyle("Reset Crosshair", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ExecuteCommand("crossr")
                end
            end)
        end)
    end
end)


RegisterNetEvent('ARMA:OpenSettingsMenu')
AddEventHandler('ARMA:OpenSettingsMenu', function(admin)
    if not admin then
        RageUI.Visible(RMenu:Get("SettingsMenu", "MainMenu"), true)
    end
end)

RegisterCommand('opensettingsmenu',function()
    TriggerServerEvent('ARMA:OpenSettings')
end)

RegisterKeyMapping('opensettingsmenu', 'Opens the Settings menu', 'keyboard', 'F2')

Citizen.CreateThread(function() 
    while true do
        Citizen.InvokeNative(0xA76359FC80B2438E, df[dts][2])      
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if hoveredPlayer ~= nil then
            local hoveredPedCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(hoveredPlayer)))
            DrawMarker(2, hoveredPedCoords.x, hoveredPedCoords.y, hoveredPedCoords.z + 1.1,0.0,0.0,0.0,0.0,-180.0,0.0,0.4,0.4,0.4,255,255,0,125,false,true,2, false)
        end
    end
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'searchoptions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            foundMatch = false
            RageUI.ButtonWithStyle("Search by Name", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'searchname'))
            RageUI.ButtonWithStyle("Search by Perm ID", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'searchpermid'))
            RageUI.ButtonWithStyle("Search by Temp ID", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'searchtempid'))
            RageUI.ButtonWithStyle("Search History", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'searchhistory'))
        end)
    end
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'functions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Get Coords", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:GetCoords')
                    end
                end, RMenu:Get('adminmenu', 'functions'))
            end
            if GlobalAdminLevel >= 0 then                   
                RageUI.ButtonWithStyle("Kick (No F10)", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:noF10Kick')
                    end
                end, RMenu:Get('adminmenu', 'functions'))
            end
            if GlobalAdminLevel >= 5 then                   
                RageUI.List("Teleport to ",q,s,nil,{},true,function(x, y, z, N)
                    s = N
                    if z then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent("ARMA:Teleport", uid, vector3(r[s]))
                    end
                end,
                function()end)
            end
            if GlobalAdminLevel >= 5 then
                RageUI.ButtonWithStyle("TP To Coords","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ARMA:Tp2Coords")
                    end
                end, RMenu:Get('adminmenu', 'functions'))
            end
            if GlobalAdminLevel >= 2 then
                RageUI.ButtonWithStyle("Offline Ban","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('ARMA:offlineban', uid)
                    end
                end)
            end
            if GlobalAdminLevel >= 5 then
                RageUI.ButtonWithStyle("TP To Waypoint", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
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
                            notify("~r~You do not have a waypoint set")
                        end
                    end
                end, RMenu:Get('adminmenu', 'functions'))
            end
            if GlobalAdminLevel >= 5 then
                RageUI.ButtonWithStyle("Unban Player","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ARMA:Unban")
                    end
                end)
            end
            if GlobalAdminLevel >= 6 then
                RageUI.ButtonWithStyle("Remove Warning", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('ARMA:RemoveWarning', uid, result)
                    end
                end, RMenu:Get('adminmenu', 'functions'))
            end
            if GlobalAdminLevel >= 7 then
                RageUI.ButtonWithStyle("Toggle Blips", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:checkBlips')
                    end
                end, RMenu:Get('adminmenu', 'functions'))
            end
            if GlobalAdminLevel >= 11 then
                RageUI.ButtonWithStyle("~b~Developer Functions", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end
        end)
    end
end)



RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'devfunctions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel >= 11 then
                RageUI.ButtonWithStyle("Spawn Weapon", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:Giveweapon')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end
            if GlobalAdminLevel >= 11 then
                RageUI.ButtonWithStyle("Give Weapon", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:GiveWeaponToPlayer')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end
            if GlobalAdminLevel >= 11 then
                RageUI.ButtonWithStyle("Add Car", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:AddCar')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end
            if GlobalAdminLevel >= 11 then
                RageUI.ButtonWithStyle("Give Money","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ARMA:GiveMoneyMenu")
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end
            if GlobalAdminLevel >= 11 then
                RageUI.ButtonWithStyle("Give Crates","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ARMA:GiveCratesMenu")
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end
            if GlobalAdminLevel >= 11 then
                RageUI.ButtonWithStyle("AntiCheat","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ARMA:getAnticheatData")
                    end
                end, RMenu:Get('adminmenu', 'anticheat'))
            end          
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'searchpermid')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if foundMatch == false then
                searchforPermID = KeyboardInput("Enter Perm ID", "", 10)
                if searchforPermID == nil then 
                    searchforPermID = ""
                end
                g = searchforPermID
                h[i] = g
                i = i + 1
            end
            for k, v in pairs(players) do
                foundMatch = true
                if string.find(v[3],searchforPermID) then
                    RageUI.ButtonWithStyle("[" .. v[3] .. "] " .. v[1], "Name: " .. v[1] .. " Perm ID: " .. v[3] .. " Temp ID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
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
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if foundMatch == false then
                searchid = KeyboardInput("Enter Temp ID", "", 10)
                if searchid == nil then 
                    searchid = ""
                end
                g = searchid
                h[i] = g
                i = i + 1
            end
            for k, v in pairs(players) do
                foundMatch = true
                if string.find(v[2], searchid) then
                    RageUI.ButtonWithStyle("[" .. v[3] .. "] " .. v[1], "Name: " .. v[1] .. " Perm ID: " .. v[3] .. " Temp ID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
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
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if foundMatch == false then
                SearchName = KeyboardInput("Enter Name", "", 10)
                if SearchName == nil then 
                    SearchName = ""
                end
            end
            for k, v in pairs(players) do
                foundMatch = true
                if string.find(string.lower(v[1]), string.lower(SearchName)) then
                    RageUI.ButtonWithStyle("[" .. v[3] .. "] " .. v[1], "Name: " .. v[1] .. " Perm ID: " .. v[3] .. " Temp ID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
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
    if RageUI.Visible(RMenu:Get('adminmenu', 'searchhistory')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k, v in pairs(players) do
                if i > 1 then
                    for K = #h, #h - 10, -1 do
                        if h[K] then
                            if tonumber(h[K]) == v[3] then
                                RageUI.ButtonWithStyle("[" .. v[3] .. "] " .. v[1], "Name: " .. v[1] .. " Perm ID: " .. v[3] .. " Temp ID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        SelectedPlayer = players[k]
                                    end
                                end, RMenu:Get('adminmenu', 'submenu'))
                            end
                        end
                    end
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'submenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            hoveredPlayer = nil
            RageUI.Separator("~y~Player must provide POV on request: "..povlist)
            if GlobalAdminLevel > 1 then
                RageUI.ButtonWithStyle("Player Notes", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:getNotes', uid, SelectedPlayer[3])
                    end
                end, RMenu:Get('adminmenu', 'notesub'))
            end              
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Kick Player", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('ARMA:KickPlayer', uid, SelectedPlayer[3], kickReason, SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel >= 2 then
                RageUI.ButtonWithStyle("Ban Player", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                    end
                end, RMenu:Get('adminmenu', 'bansub'))
            end
            if GlobalAdminLevel >= 3 then
                RageUI.ButtonWithStyle("Spectate Player", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        inRedZone = false
                        TriggerServerEvent('ARMA:SpectatePlayer', SelectedPlayer[3])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel >= 3 then
                RageUI.ButtonWithStyle("Revive", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('ARMA:RevivePlayer', uid, SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end 
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Teleport to Player", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local newSource = GetPlayerServerId(PlayerId())
                        savedCoords1 = GetEntityCoords(PlayerPedId())
                        TriggerServerEvent('ARMA:TeleportToPlayer', newSource, SelectedPlayer[2])
                        inTP2P = true
                        inTP2P2 = true
                        
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Teleport Player to Me", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:BringPlayer', SelectedPlayer[3])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Teleport to Admin Zone", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        inRedZone = false
                        savedCoordsBeforeAdminZone = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(SelectedPlayer[2])))
                        TriggerServerEvent("ARMA:Teleport2AdminIsland", SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Teleport Back from Admin Zone", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ARMA:TeleportBackFromAdminZone", SelectedPlayer[2], savedCoordsBeforeAdminZone)
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Teleport to Legion", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ARMA:Teleport", SelectedPlayer[2], vector3(151.61740112305,-1035.05078125,29.339416503906))
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Freeze", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        isFrozen = not isFrozen
                        TriggerServerEvent('ARMA:FreezeSV', uid, SelectedPlayer[2], isFrozen)
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 3 then
                RageUI.ButtonWithStyle("Slap Player", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('ARMA:SlapPlayer', uid, SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 4 then
                RageUI.ButtonWithStyle("Force Clock Off", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:ForceClockOff', SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Open F10 Warning Log", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        ExecuteCommand("sw " .. SelectedPlayer[3])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Take Screenshot", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('ARMA:RequestScreenshot', uid , SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 6 then
                RageUI.ButtonWithStyle("See Groups", "Name: " .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ARMA:GetGroups", SelectedPlayer[2], SelectedPlayer[3])
                    end
                end,RMenu:Get("adminmenu", "groups"))
            end
        end)
    end
end)
    
RegisterNetEvent('ARMA:ReturnPov')
AddEventHandler('ARMA:ReturnPov', function(pov)
    if pov then 
        povlist = '~g~true' 
    else
        povlist = '~r~false'
    end
end)



RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'bansub')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel >= 2 then
            for i , p in pairs(punishmentreasons) do
                RageUI.ButtonWithStyle(p.name, p.desc, { RightLabel = "" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        selectedBan = p.name
                    end
                end, RMenu:Get("adminmenu", 'durationsubmenu'))
            end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get("adminmenu", 'durationsubmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel >= 2 then
               for k,v in pairs(punishmentreasons) do
                    if selectedBan == v.name then
                        for a,b in pairs(v.duration[1]) do
                            RageUI.ButtonWithStyle(v.duration[1][a], nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    if next(banstable) then
                                        banreasons = banreasons ..', '..selectedBan
                                    else 
                                        banreasons = banreasons ..selectedBan
                                    end
                                    banduration = banduration + v.duration[2][a]
                                    if a == 1 then
                                        selectedBan = v.name ..' ~y~| ~w~1st Offense'
                                    elseif a == 2 then
                                        selectedBan = v.name ..' ~y~| ~w~2nd Offense'
                                    elseif a == 3 then
                                        selectedBan = v.name ..' ~y~| ~w~3rd Offense'
                                    end
                                    banstable[selectedBan] = {selectedBan, v.duration[2][a]}
                                    bantargetname = SelectedPlayer[1]
                                    bantarget =  SelectedPlayer[3]
                                end
                            end, RMenu:Get("adminmenu", 'confirmban'))
                        end
                    end
                end
            end
        end)
    end

    if RageUI.Visible(RMenu:Get("adminmenu", 'confirmban')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel >= 2 then
                RageUI.Separator("~r~You are about to ban " ..bantargetname)
                RageUI.Separator("~w~For the following reason(s):")
                for k, v in pairs(banstable) do
                    RageUI.Separator(v[1]..' ~y~| ~w~'..v[2]..'hrs')
                end
                if banduration >= 9000 then
                    RageUI.Separator('Total Length: Permanent')
                else
                    RageUI.Separator('Total Length: '..banduration..' hours.')
                end
                RageUI.ButtonWithStyle("Add another Reason", nil, { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
                end, RMenu:Get("adminmenu", 'bansub')) 
                RageUI.ButtonWithStyle("Confirm Ban", nil, { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('ARMA:BanPlayerConfirm', uid, bantarget, bantargetname, banreasons, banduration)
                    end
                end)
                RageUI.ButtonWithStyle("Cancel Ban", nil, { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        banduration = 0
                        banstable = {}
                        banreasons = ''
                    end
                end, RMenu:Get("adminmenu", 'submenu'))
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'notesub')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if f == nil then
                RageUI.Separator("~b~Player notes: Loading...")
            elseif #f == 0 then
                RageUI.Separator("~b~There are no player notes to display.")
            else
                RageUI.Separator("~b~Player notes:")
                for K = 1, #f do
                    RageUI.Separator("~g~#"..f[K].note_id.." ~w~" .. f[K].text .. " - "..f[K].admin_name.. "("..f[K].admin_id..")")
                end
            end
            if GlobalAdminLevel > 1 then
                RageUI.ButtonWithStyle("Add To Notes:", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:addNote', uid, SelectedPlayer[2])
                    end
                end)
                RageUI.ButtonWithStyle("Remove Note", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('ARMA:removeNote', uid, SelectedPlayer[2])
                    end
                end)
            end
        end)
    end
end)

RegisterNetEvent("ARMA:sendNotes",function(a7)
    a7 = json.decode(a7)
    if a7 == nil then
        f = {}
    else
        f = a7
    end
end)

RegisterNetEvent('ARMA:sendNotes')
AddEventHandler('ARMA:sendNotes', function(text)
    notes = text
end)

RegisterNetEvent("ARMA:updateNotes",function(admin, player)
    TriggerServerEvent('ARMA:getNotes', admin, player)
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'anticheat')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel > 11 then
                RageUI.Separator("Anticheat Duration: Lifetime", function() end)
                RageUI.Separator("Banned Players: " .. acbannedplayers, function() end)
                RageUI.Separator("Your Name: " ..acadminname, function() end)
                RageUI.ButtonWithStyle("Banned Players","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'acbannedplayers'))
                RageUI.ButtonWithStyle("Ban Types","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'actypes'))
                RageUI.ButtonWithStyle("Manual Ban","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'acmanualbanlist'))
            end   
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'actypes')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel > 11 then
                RageUI.Separator("Anticheat Duration: Lifetime", function() end)
                RageUI.Separator("Banned Players: " .. acbannedplayers, function() end)
                RageUI.Separator("Your Name: " ..acadminname, function() end)
                for i, p in pairs(actypes) do
                    RageUI.ButtonWithStyle("Type #"..p.type, p.desc, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end, RMenu:Get('adminmenu', 'anticheat'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'acbannedplayers')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel > 11 then
                RageUI.Separator("Anticheat Duration: Lifetime", function() end)
                RageUI.Separator("Banned Players: " .. acbannedplayers, function() end)
                RageUI.Separator("Your Name: " ..acadminname, function() end)
                for k, v in pairs(acbannedplayerstable) do
                    RageUI.ButtonWithStyle("Ban ID: "..v[1].." Perm ID: "..v[2], "Username: "..v[3].." Reason: "..v[4], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SelectedPlayer = acbannedplayerstable[k]
                        end
                    end, RMenu:Get('adminmenu', 'acbanmenu'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'acmanualbanlist')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel > 11 then
                RageUI.Separator("Anticheat Duration: Lifetime", function() end)
                RageUI.Separator("Banned Players: " .. acbannedplayers, function() end)
                RageUI.Separator("Your Name: " ..acadminname, function() end)
                for k, v in pairs(players) do
                    RageUI.ButtonWithStyle(v[1] .." ["..v[2].."]", v[1] .. " ("..v[4].." hours) PermID: " .. v[3] .. " TempID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SelectedPlayer = players[k]
                            SelectedPerm = v[3]
                            SelectedName = v[1]
                            SelectedPlayerSource = v[2]
                        end
                    end, RMenu:Get('adminmenu', 'acmanualban'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'acmanualban')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel > 11 then
                RageUI.Separator("Anticheat Duration: Lifetime", function() end)
                RageUI.Separator("Banned Players: " .. acbannedplayers, function() end)
                RageUI.Separator("Your Name: " ..acadminname, function() end)
                for i, p in pairs(actypes) do
                    RageUI.ButtonWithStyle("Type #"..p.type, p.desc, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            acbanType = p.type
                        end
                    end, RMenu:Get('adminmenu', 'confirmacban'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'confirmacban')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("~r~You are about to ban " ..SelectedName)
            RageUI.Separator("~w~For the following reasons:")
            RageUI.Separator('Cheating Type #'..acbanType)
            RageUI.Separator('Duration: Permanent')
            RageUI.ButtonWithStyle("Confirm Ban", nil, { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("ARMA:acBan", SelectedPerm, 'Type #'..acbanType, SelectedName, SelectedPlayerSource)
                    notify('~g~AC Banned ID: '..SelectedPerm)
                end
            end, RMenu:Get('adminmenu', 'anticheat'))
            RageUI.ButtonWithStyle("Cancel Ban", nil, { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'anticheat'))
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'acbanmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel > 11 then
                RageUI.Separator("Anticheat Duration: Lifetime", function() end)
                RageUI.Separator("Banned Players: " .. acbannedplayers, function() end)
                RageUI.Separator("Your Name: " ..acadminname, function() end)
                RageUI.ButtonWithStyle("Unban Player","Unban Selected User",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        TriggerServerEvent('ARMA:acUnban', SelectedPlayer[2])
                    end
                end, RMenu:Get("anticheat", "acbannedplayers"))
                RageUI.ButtonWithStyle("Check Warnings","Show F10 Warning Log",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        ExecuteCommand("sw " .. SelectedPlayer[2])
                    end
                end)
            end
        end)
    end
end)

RegisterCommand("cleanup", function()
    TriggerServerEvent('ARMA:CleanAll')
end)
RegisterCommand("blips", function()
    TriggerServerEvent('ARMA:checkBlips')
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'groups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel > 7 then
                RageUI.ButtonWithStyle("Staff Groups", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("Staff Groups")
                    end
                end, RMenu:Get('adminmenu', 'staffGroups'))
            end
            if GlobalAdminLevel > 1 then
                RageUI.ButtonWithStyle("POV Groups", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("POV Groups")
                    end
                end, RMenu:Get('adminmenu', 'POVGroups'))
            end
            if GlobalAdminLevel > 7 then
                RageUI.ButtonWithStyle("License Groups", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("License Groups")
                    end
                end, RMenu:Get('adminmenu', 'LicenseGroups'))
            end
            if GlobalAdminLevel > 7 then
                RageUI.ButtonWithStyle("MPD Groups", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("MPD Groups")
                    end
                end, RMenu:Get('adminmenu', 'MPDGroups'))
            end
            if GlobalAdminLevel > 7 then
                RageUI.ButtonWithStyle("NHS Groups", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("NHS Groups")
                    end
                end, RMenu:Get('adminmenu', 'NHSGroups'))
            end
            if GlobalAdminLevel > 7 then
                RageUI.ButtonWithStyle("Donator Groups", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'UserGroups'))
            end
        end) 
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'staffGroups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k,v in pairs(getStaffGroupsGroupIds) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.ButtonWithStyle("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.ButtonWithStyle("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
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
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k,v in pairs(getUserGroupsGroupIds) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.ButtonWithStyle("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.ButtonWithStyle("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
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
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k,v in pairs(getUserPOVGroups) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.ButtonWithStyle("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.ButtonWithStyle("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
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
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k,v in pairs(getUserLicenseGroups) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.ButtonWithStyle("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.ButtonWithStyle("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
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
    if RageUI.Visible(RMenu:Get('adminmenu', 'MPDGroups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k,v in pairs(getUserMPDGroups) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.ButtonWithStyle("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.ButtonWithStyle("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
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
                    RageUI.ButtonWithStyle("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.ButtonWithStyle("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
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
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Add this group to user", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("ARMA:AddGroup",SelectedPerm,selectedGroup)
                end
            end, RMenu:Get('adminmenu', 'groups'))
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'removegroup')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Remove user from group", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("ARMA:RemoveGroup",SelectedPerm,selectedGroup)
                end
            end, RMenu:Get('adminmenu', 'groups')) 
        end)
    end
end)

RegisterNetEvent('ARMA:SlapPlayer')
AddEventHandler('ARMA:SlapPlayer', function()
    SetEntityHealth(PlayerPedId(), 0)
end)


FrozenPlayer = false
RegisterNetEvent('ARMA:Freeze')
AddEventHandler('ARMA:Freeze', function(isFrozen)
    FrozenPlayer = isFrozen
    TriggerEvent('godmodebypass', isFrozen)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if FrozenPlayer then
            FreezeEntityPosition(PlayerPedId(), true)
            DisableControlAction(0,24,true) -- disable attack
            DisableControlAction(0,25,true) -- disable aim
            DisableControlAction(0,47,true) -- disable weapon
            DisableControlAction(0,58,true) -- disable weapon
            DisableControlAction(0,263,true) -- disable melee
            DisableControlAction(0,264,true) -- disable melee
            DisableControlAction(0,257,true) -- disable melee
            DisableControlAction(0,140,true) -- disable melee
            DisableControlAction(0,141,true) -- disable melee
            DisableControlAction(0,142,true) -- disable melee
            DisableControlAction(0,143,true) -- disable melee
            SetPedCanRagdoll(PlayerPedId(), false)
            ClearPedBloodDamage(PlayerPedId())
            ResetPedVisibleDamage(PlayerPedId())
            ClearPedLastWeaponDamage(PlayerPedId())
            SetEntityProofs(PlayerPedId(), true, true, true, true, true, true, true, true)
            SetEntityCanBeDamaged(PlayerPedId(), false)			
        elseif not FrozenPlayer and not noclip and not Spectating and not staffMode then  
            SetEntityInvincible(PlayerPedId(), false)
            SetPlayerInvincible(PlayerPedId(), false)
            FreezeEntityPosition(PlayerPedId(), false)
            SetPedCanRagdoll(PlayerPedId(), true)
            ClearPedBloodDamage(PlayerPedId())
            ResetPedVisibleDamage(PlayerPedId())
            ClearPedLastWeaponDamage(PlayerPedId())
        end
    end
end)

RegisterNetEvent('ARMA:Teleport')
AddEventHandler('ARMA:Teleport', function(coords)
    DoScreenFadeOut(1000)
    NetworkFadeOutEntity(PlayerPedId(), true, false)
    Wait(1000)
    SetEntityCoords(PlayerPedId(), coords)
    NetworkFadeInEntity(PlayerPedId(), 0)
    DoScreenFadeIn(1000)
end)

RegisterNetEvent('ARMA:Teleport2Me2')
AddEventHandler('ARMA:Teleport2Me2', function(target2)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target2)))
    SetEntityCoords(PlayerPedId(), coords)
end)

RegisterNetEvent("ARMA:sendAnticheatData")
AddEventHandler("ARMA:sendAnticheatData", function(admin_name, players, table, types)
    acbannedplayerstable = table
    acbannedplayers = players
    acadminname = admin_name
    actypes = types
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



function StopSpectatePlayer()
    inRedZone = false
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

RegisterNetEvent("ARMA:GotGroups")
AddEventHandler("ARMA:GotGroups",function(gotGroups)
    searchPlayerGroups = gotGroups
end)

RegisterNetEvent("ARMA:getPlayersInfo")
AddEventHandler("ARMA:getPlayersInfo", function(BB, preasons)
    players = BB
    punishmentreasons = preasons
    RageUI.Visible(RMenu:Get("adminmenu", "main"), not RageUI.Visible(RMenu:Get("adminmenu", "main")))
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

RegisterNetEvent('ARMA:NotifyPlayer')
AddEventHandler('ARMA:NotifyPlayer', function(string)
    notify('~g~' .. string)
end)


RegisterCommand('openadminmenu',function()
    TriggerServerEvent('ARMA:GetPlayerData')
    TriggerServerEvent("ARMA:GetNearbyPlayerData")
    TriggerServerEvent("ARMA:getAdminLevel")
    GlobalAdminLevel = tARMA.getStaffLevel()
end)

RegisterKeyMapping('openadminmenu', 'Opens the Admin menu', 'keyboard', 'F2')

RegisterKeyMapping('noclip', 'Staff Noclip', 'keyboard', 'F4')       
RegisterCommand('noclip', function(source, args, RawCommand)
    TriggerServerEvent("ARMA:noClip")
end)

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
		Citizen.Wait(1) 
		blockinput = false 
		return result 
	else
		Citizen.Wait(1)
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

RegisterNetEvent("ARMA:TPCoords")
AddEventHandler("ARMA:TPCoords", function(coords)
    SetEntityCoordsNoOffset(GetPlayerPed(-1), coords.x, coords.y, coords.z, false, false, false)
end)

RegisterNetEvent("ARMA:EntityWipe")
AddEventHandler("ARMA:EntityWipe", function(id)
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

function bank_drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local Spectating = false;
local LastCoords = nil;
RegisterNetEvent('ARMA:Spectate')
AddEventHandler('ARMA:Spectate', function(plr,tpcoords)
    local playerPed = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(plr))
    if not Spectating then
        LastCoords = GetEntityCoords(playerPed) 
        if tpcoords then 
            SetEntityCoords(playerPed, tpcoords - 10.0)
        end
        Wait(300)
        targetPed = GetPlayerPed(GetPlayerFromServerId(plr))
        if targetPed == playerPed then tARMA.notify('~r~I mean you cannot spectate yourself...') return end
		NetworkSetInSpectatorMode(true, targetPed)
        SetEntityCollision(playerPed, false, false)
        SetEntityVisible(playerPed, false, 0)
		SetEveryoneIgnorePlayer(playerPed, true)	
        Spectating = true
        tARMA.notify('~g~Spectating Player.')
        TriggerServerEvent('ARMAAntiCheat:setType6', false)
        while Spectating do
            local targetArmour = GetPedArmour(targetPed)
            local targetHealth = GetEntityHealth(targetPed)
            local targetplayerName = GetPlayerName(GetPlayerFromServerId(plr))
            local targetSpeedMph = GetEntitySpeed(targetPed) * 2.236936
            local targetvehiclehealth = GetEntityHealth(GetVehiclePedIsIn(targetPed, false))
            local targetWeapon = GetSelectedPedWeapon(targetPed)
            local targetWeaponAmmoCount = GetAmmoInPedWeapon(targetPed, targetWeapon)
            DrawAdvancedText(0.320, 0.850, 0.025, 0.0048, 0.5, "Health: "..targetHealth, 51, 153, 255, 200, 6, 0)
            DrawAdvancedText(0.320, 0.828, 0.025, 0.0048, 0.5, "Armour: "..targetArmour, 51, 153, 255, 200, 6, 0)
            DrawAdvancedText(0.320, 0.806, 0.025, 0.0048, 0.5, "Vehicle Health: "..targetvehiclehealth, 51, 153, 255, 200, 6, 0)
            bank_drawTxt(0.90, 1.4, 1.0, 1.0, 0.4, "You are currently spectating "..targetplayerName, 51, 153, 255, 200)
            if IsPedSittingInAnyVehicle(targetPed) then
               DrawAdvancedText(0.320, 0.784, 0.025, 0.0048, 0.5, "Speed: "..math.floor(targetSpeedMph), 51, 153, 255, 200, 6, 0)
            end	
            Wait(0)
        end
    else 
        NetworkSetInSpectatorMode(false, targetPed)
        SetEntityVisible(playerPed, true, 0)
		SetEveryoneIgnorePlayer(playerPed, false)
		SetEntityCollision(playerPed, true, true)
        Spectating = false;
        SetEntityCoords(playerPed, LastCoords)
        tARMA.notify('~r~Stopped Spectating Player.')
        TriggerServerEvent('ARMAAntiCheat:setType6', true)
    end 
end)