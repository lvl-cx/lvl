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
local banreasons = {}
local selectedbans = {}
local Duration = 0
local BanMessage = "N/A"
local SeparatorMSG = {}
local BanPoints = 0
local banchecked = {}
local f = nil
local g
local h = {}
local i = 1
local k = {}
local a10
local acbannedplayers = 0
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

RMenu.Add('SettingsMenu', 'MainMenu', RageUI.CreateMenu("", menuColour.."Settings Menu", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "banners","settings")) 
RMenu.Add("SettingsMenu", "crosshairsettings", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu"), "", menuColour..'Crosshair Settings',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners","settings"))

RMenu.Add('adminmenu', 'main', RageUI.CreateMenu("", "~b~Admin Menu", tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(), "banners", "admin"))
RMenu.Add("adminmenu", "players", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Interaction Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners","admin"))
RMenu.Add("adminmenu", "closeplayers", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Interaction Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners","admin"))
RMenu.Add("adminmenu", "searchoptions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Search Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners","admin"))
RMenu.Add("adminmenu", "functions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Functions Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners","admin"))
RMenu.Add("adminmenu", "devfunctions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Dev Functions Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners","admin"))
RMenu.Add("adminmenu", "checkban", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "functions"), "", menuColour..'Check Ban',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "moneymenu", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "functions"), "", menuColour..'Money Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "anticheat", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "functions"), "", menuColour..'AC Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "actypes", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "anticheat"), "", menuColour..'AC Types',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "acvehwhitelist", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "anticheat"), "", menuColour..'AC Vehicle Whitelist',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "acbannedplayers", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "anticheat"), "", menuColour..'AC Banned Players',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "acsearchpermid", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "anticheat"), "", menuColour..'AC Search PermID',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "acbanmenu", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "acbannedplayers"), "", menuColour..'AC Banned Player Submenu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "submenu", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Admin Player Interaction Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "searchname", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "searchtempid", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "searchpermid", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "searchhistory", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "banselection", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Ban Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "generatedban", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "banselection"), "", menuColour..'Ban Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "notesub", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Player Notes',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "groups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "submenu"), "", menuColour..'Admin Groups Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "staffGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "UserGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "POVGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "LicenseGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "MPDGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "NHSGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "addgroup", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
RMenu.Add("adminmenu", "removegroup", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',tARMA.getRageUIMenuWidth(), tARMA.getRageUIMenuHeight(),"banners", "admin"))
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
    ["Scrap"] = "Scrap License",
    ["Weed"] = "Weed License",
    ["Cocaine"] = "Cocaine License",
    ["Gold"] = "Gold License",
    ["Diamond"] = "Diamond License",
    ["Heroin"] = "Heroin License",
    ["LSD"] = "LSD License",
    ["Gang"] = "Gang License",
    ["Rebel"] = "Rebel License",
    ["AdvancedRebel"] = "Advanced Rebel License",
    ["highroller"] = "Highrollers License",
    ["DJ"] = "DJ License",
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
    ["Special Constable"] = "Special Police Constable",
    ["Senior Constable"] = "Senior Police Constable",
    ["Police Constable"] = "Police Constable",
    ["PCSO"] = "PCSO",
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
                        TriggerServerEvent("ARMA:GetNearbyPlayers", 250)
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
            else
                RageUI.Separator("No players nearby!")
            end
        end)
    end
end)

RegisterNetEvent("ARMA:ReturnNearbyPlayers")
AddEventHandler("ARMA:ReturnNearbyPlayers", function(table)
    playersNearby = table
end)


local df = {{"10%", 0.1},{"20%", 0.2},{"30%", 0.3},{"40%", 0.4},{"50%", 0.5},{"60%", 0.6},{"70%", 0.7},{"80%", 0.8},{"90%", 0.9},{"100%", 1.0},{"150%", 1.5},{"200%", 2.0},{"250%", 2.5},{"300%", 3.0},{"350%", 3.5},{"400%", 4.0},{"450%", 4.5},{"500%", 5.0},{"600%", 6.0},{"700%", 7.0},{"800%", 8.0},{"900%", 9.0},{"1000%", 10.0},}
local d = {"10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%", "150%", "200%", "250%", "300%", "350%", "400%", "450%", "500%", "600%", "700%", "800%", "900%", "1000%"}
local dts = 10


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('SettingsMenu', 'MainMenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.List("Modify Render Distance", d, dts, "~b~Change Render Distance", {}, true, function(a,b,c,d)
                if c then end
                dts = d
            end)
            RageUI.Checkbox("Toggle Compass", nil, compasschecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if Selected then
                    compasschecked = not compasschecked
                    ExecuteCommand("compass")
                end
            end)
            RageUI.Checkbox("Toggle Hitsounds", nil, hitsoundchecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if Selected then
                    hitsoundchecked = not hitsoundchecked
                    if hitsoundchecked then
                        tARMA.notify("~g~Hitsounds Enabled!")
                        SetResourceKvpInt('hitsoundchecked', 1)
                    else
                        tARMA.notify("~r~Hitsounds Disabled!")
                        SetResourceKvpInt('hitsoundchecked', 0)
                    end
                    TriggerEvent("hs:triggerSounds", hitsoundchecked)
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
                        tARMA.notify("~g~Crosshair Enabled!")
                    else
                        ExecuteCommand("cross")
                        tARMA.notify("~r~Crosshair Disabled!")
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

RegisterNetEvent('ARMA:sendSettings')
AddEventHandler('ARMA:sendSettings', function()
    if GetResourceKvpInt('hitsoundchecked') == 1 then
        hitsoundchecked = true
        TriggerEvent("hs:triggerSounds", true)
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
                RageUI.ButtonWithStyle("Kick (No F10)", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:noF10Kick')
                    end
                end)
            end
            if GlobalAdminLevel >= 2 then
                RageUI.ButtonWithStyle("Offline Ban","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if foundMatch == false then
                            tARMA.clientPrompt("Perm ID:","",function(a)
                                banningPermID = a
                                banningName = 'ID: ' .. banningPermID
                            end)
                        end
                    end
                end, RMenu:Get('adminmenu', 'banselection'))
            end
            if GlobalAdminLevel >= 2 then
                RageUI.ButtonWithStyle("Check Ban","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'checkban'))
            end
            if GlobalAdminLevel >= 5 then
                RageUI.ButtonWithStyle("Unban Player","",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ARMA:Unban")
                    end
                end)
            end
            if GlobalAdminLevel >= 6 then
                RageUI.ButtonWithStyle("Remove Warning",nil,{RightLabel="→→→"},true,function(Hovered, Active, Selected)
                    if Selected then
                        AddTextEntry('FMMC_MPM_NC', "Enter the Warning ID")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0);
                            Wait(0);
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then 
                                TriggerServerEvent('ARMA:RemoveWarning', result)
                            end
                        end
                    end
                end)
            end 
            if GlobalAdminLevel >= 6 then
                RageUI.ButtonWithStyle("Spawn Taxi", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local mhash = GetHashKey('londontaxi')
                        local i = 0
                        while not HasModelLoaded(mhash) and i < 50 do
                            RequestModel(mhash)
                            Citizen.Wait(10)
                            i = i+1
                            if i > 50 then 
                                tARMA.notify('~r~Model could not be loaded!')
                                break 
                            end
                        end
                        if HasModelLoaded(mhash) then
                            local x,y,z = tARMA.getPosition()
                            if pos then
                                x,y,z = table.unpack(pos)
                            end
                            local nveh = CreateVehicle(mhash, x, y ,z + 0.5, GetEntityHeading(PlayerPedId()), true, false)
                            SetVehicleOnGroundProperly(nveh)
                            SetEntityInvincible(nveh,false)
                            SetPedIntoVehicle(PlayerPedId(),nveh,-1)
                            SetVehicleNumberPlateText(nveh, GetPlayerName(PlayerId()))
                            SetVehicleHasBeenOwnedByPlayer(nveh,true)
                            local nid = NetworkGetNetworkIdFromEntity(nveh)
                            SetNetworkIdCanMigrate(nid,true)
                        else
                            return
                        end
                    end
                end)
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Get Coords", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:GetCoords')
                    end
                end)
            end
            if GlobalAdminLevel >= 5 then                   
                RageUI.List("Teleport to ",q,s,"",{},true,function(x, y, z, N)
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
                            tARMA.notify("~r~You do not have a waypoint set")
                        end
                    end
                end)
            end
            if GlobalAdminLevel >= 7 then
                local P=""
                if tARMA.hasStaffBlips()then 
                    P="~r~Turn off blips"
                else 
                    P="~g~Turn on blips"
                end
                RageUI.ButtonWithStyle("Toggle Blips", P, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:checkBlips', not tARMA.hasStaffBlips())
                    end
                end)
                RageUI.ButtonWithStyle("RP Zones",nil,{RightLabel="→→→"},true,function(Hovered, Active, Selected)
                end,RMenu:Get("rpzones","mainmenu"))
            end
            if GlobalAdminLevel >= 9 then
                RageUI.ButtonWithStyle("Community Pot Menu",nil,{RightLabel="→→→"},true,function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ARMA:getCommunityPotAmount")
                    end
                end,RMenu:Get('communitypot','mainmenu'))
            end  
            if GlobalAdminLevel >= 10 then
                RageUI.ButtonWithStyle("Give Money",nil,{RightLabel="→→→"},true,function(Hovered, Active, Selected)
                end,RMenu:Get('adminmenu','moneymenu'))
                RageUI.ButtonWithStyle("Add Car", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:AddCar')
                    end
                end, RMenu:Get('adminmenu', 'functions'))
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'moneymenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if a10 ~= nil and sn ~= nil and sc ~= nil and sb ~= nil and sw ~= nil and sch ~= nil then
                RageUI.Separator("Name: ~b~"..sn)
                RageUI.Separator("PermID: ~b~"..a10)
                RageUI.Separator("TempID: ~b~"..sc)
                RageUI.Separator("Bank Balance: ~b~£"..sb)
                RageUI.Separator("Cash Balance: ~b~£"..sw)
                RageUI.Separator("Casino Chips: ~b~"..sch)
                RageUI.Separator("")
                RageUI.ButtonWithStyle("Bank Balance ~g~+",nil,{RightLabel="→→→"},true,function(w,x,y)
                    if y then
                        tARMA.clientPrompt("Amount:","",function(j)
                            if tonumber(j) then
                                TriggerServerEvent('ARMA:ManagePlayerBank',a10,j,"Increase")
                            else
                                tARMA.notify("~r~Invalid Amount")
                            end
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Bank Balance ~r~-",nil,{RightLabel="→→→"},true,function(w,x,y)
                    if y then
                        tARMA.clientPrompt("Amount:","",function(j)
                            if tonumber(j) then
                                TriggerServerEvent('ARMA:ManagePlayerBank',a10,j,"Decrease")
                            else
                                tARMA.notify("~r~Invalid Amount")
                            end
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Cash Balance ~g~+~w~",nil,{RightLabel="→→→"},true,function(w,x,y)
                    if y then
                        tARMA.clientPrompt("Amount:","",function(l)
                            if tonumber(l) then
                                TriggerServerEvent('ARMA:ManagePlayerCash',a10,l,"Increase")
                            else
                                tARMA.notify("~r~Invalid Amount")
                            end
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Cash Balance ~r~-",nil,{RightLabel="→→→"},true,function(w,x,y)
                    if y then
                        tARMA.clientPrompt("Amount:","",function(l)
                            if tonumber(l) then
                                TriggerServerEvent('ARMA:ManagePlayerCash',a10,l,"Decrease")
                            else
                                tARMA.notify("~r~Invalid Amount")
                            end
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Casino Chips ~g~+",nil,{RightLabel="→→→"},true,function(w,x,y)
                    if y then
                        tARMA.clientPrompt("Amount:","",function(l)
                            if tonumber(l) then
                                TriggerServerEvent('ARMA:ManagePlayerChips',a10,l,"Increase")
                            else
                                tARMA.notify("~r~Invalid Amount")
                            end
                        end)
                    end
                end)
                RageUI.ButtonWithStyle("Casino Chips ~r~-",nil,{RightLabel="→→→"},true,function(w,x,y)
                    if y then
                        tARMA.clientPrompt("Amount:","",function(l)
                            if tonumber(l) then
                                TriggerServerEvent('ARMA:ManagePlayerChips',a10,l,"Decrease")
                            else
                                tARMA.notify("~r~Invalid Amount")
                            end
                        end)
                    end
                end)
            end
            RageUI.ButtonWithStyle("Choose PermID",nil, { RightLabel = "→→→" }, true, function(w,x,y)
                if y then
                    tARMA.clientPrompt("PermID:","",function(j)
                        if tonumber(j) then
                            a10 = tonumber(j)
                            tARMA.notify("~g~PermID Set To "..j)
                            TriggerServerEvent('ARMA:getUserinformation',a10)
                        else
                            tARMA.notify("~r~Invalid PermID")
                            a10 = nil
                        end
                    end)
                end
            end, RMenu:Get('adminmenu', 'moneymenu'))
        end)
    end
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'devfunctions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tARMA.isDev() or GlobalAdminLevel >= 10 then
                RageUI.ButtonWithStyle("Spawn Weapon", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:Giveweapon')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
                RageUI.ButtonWithStyle("Give Weapon", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:GiveWeaponToPlayer')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
                RageUI.ButtonWithStyle("Spawn Vehicle", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
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
                                while not HasModelLoaded(mhash) and i < 50 do
                                    RequestModel(mhash)
                                    Citizen.Wait(10)
                                    i = i+1
                                    if i > 50 then 
                                        tARMA.notify('~r~Model could not be loaded!')
                                        break 
                                    end
                                end
                                if HasModelLoaded(mhash) then
                                    local x,y,z = tARMA.getPosition()
                                    if pos then
                                        x,y,z = table.unpack(pos)
                                    end
                                    local nveh = CreateVehicle(mhash, x, y ,z + 0.5, GetEntityHeading(PlayerPedId()), true, false)
                                    SetVehicleOnGroundProperly(nveh)
                                    SetEntityInvincible(nveh,false)
                                    SetPedIntoVehicle(PlayerPedId(),nveh,-1)
                                    SetVehicleNumberPlateText(nveh, GetPlayerName(PlayerId()))
                                    SetVehicleHasBeenOwnedByPlayer(nveh,true)
                                    local nid = NetworkGetNetworkIdFromEntity(nveh)
                                    SetNetworkIdCanMigrate(nid,true)
                                else
                                    return
                                end
                            end
                        end
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end        
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'searchpermid')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if foundMatch == false then
                searchforPermID = tARMA.KeyboardInput("Enter Perm ID", "", 10)
                if searchforPermID == nil then 
                    searchforPermID = ""
                end
            end
            for k, v in pairs(players) do
                foundMatch = true
                if string.find(v[3],searchforPermID) then
                    RageUI.ButtonWithStyle(v[1] .." ["..v[2].."]", v[1] .. " ("..v[4].." hours) PermID: " .. v[3] .. " TempID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SelectedPlayer = players[k]
                            TriggerServerEvent("ARMA:CheckPov",v[3])
                            g = v[3]
                            h[i] = g
                            i = i + 1
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
                searchid = tARMA.KeyboardInput("Enter Temp ID", "", 10)
                if searchid == nil then 
                    searchid = ""
                end
            end
            for k, v in pairs(players) do
                foundMatch = true
                if string.find(v[2], searchid) then
                    RageUI.ButtonWithStyle(v[1] .." ["..v[2].."]", v[1] .. " ("..v[4].." hours) PermID: " .. v[3] .. " TempID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SelectedPlayer = players[k]
                            TriggerServerEvent("ARMA:CheckPov",v[3])
                            g = v[2]
                            h[i] = g
                            i = i + 1
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
                SearchName = tARMA.KeyboardInput("Enter Name", "", 10)
                if SearchName == nil then 
                    SearchName = ""
                end
            end
            for k, v in pairs(players) do
                foundMatch = true
                if string.find(string.lower(v[1]), string.lower(SearchName)) then
                    RageUI.ButtonWithStyle(v[1] .." ["..v[2].."]", v[1] .. " ("..v[4].." hours) PermID: " .. v[3] .. " TempID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SelectedPlayer = players[k]
                            TriggerServerEvent("ARMA:CheckPov",v[3])
                            g = v[1]
                            h[i] = g
                            i = i + 1
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
                            if tonumber(h[K]) == v[3] or tonumber(h[K]) == v[2] or h[K] == v[1] then
                                RageUI.ButtonWithStyle("[" .. v[3] .. "] " .. v[1], v[1] .. " Perm ID: " .. v[3] .. " Temp ID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        SelectedPlayer = players[k]
                                        TriggerServerEvent("ARMA:CheckPov",v[3])
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
                RageUI.ButtonWithStyle("Player Notes", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:getNotes', uid, SelectedPlayer[3])
                    end
                end, RMenu:Get('adminmenu', 'notesub'))
            end              
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Kick Player", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('ARMA:KickPlayer', uid, SelectedPlayer[3], kickReason, SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel >= 2 then
                RageUI.ButtonWithStyle("Ban Player", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        banningPermID = SelectedPlayer[3]
                        banningName = SelectedPlayer[1]
                    end
                end, RMenu:Get('adminmenu', 'banselection'))
            end
            if GlobalAdminLevel >= 3 then
                RageUI.ButtonWithStyle("Spectate Player", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if tonumber(SelectedPlayer[2]) ~= GetPlayerServerId(PlayerId()) then
                            inRedZone = false
                            TriggerServerEvent("ARMA:spectatePlayer", SelectedPlayer[3])
                            inSpectatorAdminMode = true
                            RageUI.Text({message = string.format("~r~Press [E] to stop spectating.")})
                        else
                            tARMA.notify("~r~You cannot spectate yourself.")
                        end
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
                RageUI.ButtonWithStyle("Spectate Player [Anti-ESP]", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if tonumber(SelectedPlayer[2]) ~= GetPlayerServerId(PlayerId()) then
                            inRedZone = false
                            TriggerServerEvent("ARMA:spectatePlayerEsp", SelectedPlayer[3])
                            inSpectatorAdminMode = true
                            RageUI.Text({message = string.format("~r~Press [E] to stop spectating.")})
                        else
                            tARMA.notify("~r~You cannot spectate yourself.")
                        end
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
                RageUI.ButtonWithStyle("Revive", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('ARMA:RevivePlayer', uid, SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Teleport to Player", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
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
                RageUI.ButtonWithStyle("Teleport Player to Me", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:BringPlayer', SelectedPlayer[3])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Teleport to Admin Zone", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        inRedZone = false
                        savedCoordsBeforeAdminZone = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(SelectedPlayer[2])))
                        TriggerServerEvent("ARMA:Teleport2AdminIsland", SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Teleport Back from Admin Zone", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ARMA:TeleportBackFromAdminZone", SelectedPlayer[2], savedCoordsBeforeAdminZone)
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Teleport to Legion", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ARMA:Teleport", SelectedPlayer[2], vector3(151.61740112305,-1035.05078125,29.339416503906))
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Freeze", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        isFrozen = not isFrozen
                        TriggerServerEvent('ARMA:FreezeSV', uid, SelectedPlayer[2], isFrozen)
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 3 then
                RageUI.ButtonWithStyle("Slap Player", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('ARMA:SlapPlayer', uid, SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 4 then
                RageUI.ButtonWithStyle("Force Clock Off", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:ForceClockOff', SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Open F10 Warning Log", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        ExecuteCommand("sw " .. SelectedPlayer[3])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 0 then
                RageUI.ButtonWithStyle("Take Screenshot", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('ARMA:RequestScreenshot', uid , SelectedPlayer[2])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
            if GlobalAdminLevel > 6 then
                RageUI.ButtonWithStyle("Request Account Info", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ARMA:requestAccountInfosv", true, SelectedPlayer[3])
                    end
                end,RMenu:Get("adminmenu", "submenu"))
            end
            if GlobalAdminLevel > 6 then 
                RageUI.ButtonWithStyle("Copy To Players Clipboard", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        TriggerServerEvent("ARMA:CopyToClipBoard", SelectedPlayer[3])
                    end 
                end,RMenu:Get('adminmenu','submenu'))
            end
            if GlobalAdminLevel > 6 then
                RageUI.ButtonWithStyle("See Groups", SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
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
    if RageUI.Visible(RMenu:Get('adminmenu', 'banselection')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel >= 2 then
                for k, v in pairs(banreasons) do
                    local function SelectedTrue()
                        selectedbans[v.id] = true
                    end
                    local function SelectedFalse()
                        selectedbans[v.id] = nil
                    end
                    RageUI.Checkbox(v.name, v.bandescription, v.itemchecked, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                        if Selected then
                            if v.itemchecked then
                                SelectedTrue()
                            end
                            if not v.itemchecked then
                                SelectedFalse()
                            end
                        end
                        v.itemchecked = Checked
                    end)
                end
                RageUI.ButtonWithStyle("Generate Ban", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("ARMA:GenerateBan", banningPermID, selectedbans)
                    end
                end, RMenu:Get('adminmenu', 'generatedban'))
        
                RageUI.ButtonWithStyle("Cancel Ban", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        selectedbans = {}
                        for k, v in pairs(banreasons) do
                            v.itemchecked = false
                        end
                        RageUI.ActuallyCloseAll()
                    end
                end)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'generatedban')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel >= 2 then
                if next(selectedbans) then
                    if BanMessage == "N/A" then
                        RageUI.Separator("~g~Generating ban info, please wait...")
                    else
                        RageUI.Separator("~r~You are about to ban " ..banningName, function() end)
                        RageUI.Separator("For the following reason(s):", function() end)
                        for k,v in pairs(SeparatorMsg) do
                            RageUI.Separator(v, function() end)
                        end
                        local U=false
                        if Duration == -1 then
                            U=true
                        end
                        RageUI.Separator("~w~Total Length: "..(U and "Permanent" or Duration.." hrs").." ~y~|~w~ Total Points: "..(Duration/24 >= 1 and Duration/24 or 10))
                        RageUI.ButtonWithStyle("Cancel", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                selectedbans = {}
                                for k, v in pairs(banreasons) do
                                    v.itemchecked = false
                                end
                                RageUI.ActuallyCloseAll()
                            end
                        end)
                        RageUI.ButtonWithStyle("Confirm", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent("ARMA:BanPlayer", banningPermID, Duration, BanMessage, BanPoints)
                            end
                        end)
                    end
                else
                    RageUI.Separator("~r~You must select at least one ban reason.", function() end)
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'checkban')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if GlobalAdminLevel >= 2 then
                if next(banchecked) then
                    for a, b in pairs(banchecked) do
                        if b.banned then 
                            RageUI.Separator("~r~Player is banned")
                            RageUI.Separator("~g~Player Name: ~w~"..b.name)
                            RageUI.Separator("~g~Player PermID: ~w~"..b.id)
                            RageUI.Separator("~g~Ban Reason: ~w~"..b.banreason)
                            RageUI.Separator("~g~Ban Expires: ~w~"..b.banexpires)
                            RageUI.Separator("~g~Remaining Time: ~w~"..b.timeleft)
                            RageUI.Separator("~g~Ban Admin: ~w~"..b.banadmin)
                        else
                            RageUI.Separator("~g~Player is not banned")
                            RageUI.Separator("~g~Player Name: ~w~"..b.name)
                            RageUI.Separator("~g~Player PermID: ~w~"..b.id)
                        end
                    end
                else
                    RageUI.Separator('Please select a Perm ID')
                end
                RageUI.ButtonWithStyle("Select Perm ID", nil, { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        permID = tARMA.KeyboardInput("Enter Perm ID", "", 10)
                        if permID == nil then 
                            tARMA.notify('~r~Invalid Perm ID')
                        end
                        TriggerServerEvent('ARMA:checkBan', permID)
                    end
                end, RMenu:Get("adminmenu", 'checkban'))
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'notesub')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if noteslist == nil then
                RageUI.Separator("~b~Player notes: Loading...")
            elseif #noteslist == 0 then
                RageUI.Separator("~b~There are no player notes to display.")
            else
                RageUI.Separator("~b~Player notes:")
                for K = 1, #noteslist do
                    RageUI.Separator("~g~#"..noteslist[K].note_id.." ~w~" .. noteslist[K].text .. " - "..noteslist[K].admin_name.. "("..noteslist[K].admin_id..")")
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
        noteslist = {}
    else
        noteslist = a7
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
        TriggerServerEvent("ARMA:getAnticheatData")
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tARMA.isDev() then
                foundMatch = false
                RageUI.Separator("Anticheat Duration: Lifetime", function() end)
                RageUI.Separator("Banned Players: " .. acbannedplayers, function() end)
                RageUI.ButtonWithStyle("List Banned Players","",{RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'acbannedplayers'))
                RageUI.ButtonWithStyle("Search Perm ID","",{RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'acsearchpermid'))
                RageUI.ButtonWithStyle("Ban Meanings","",{RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'actypes'))
                RageUI.ButtonWithStyle("Manage Vehicle Whitelist","",{RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'acvehwhitelist'))
            end   
        end)
    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'acbannedplayers')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tARMA.isDev() then
                RageUI.Separator("Anticheat Duration: Lifetime", function() end)
                RageUI.Separator("Banned Players: " .. acbannedplayers, function() end)
                for k, v in pairs(acbannedplayerstable) do
                    RageUI.ButtonWithStyle("Ban ID: "..v[1].." Perm ID: "..v[2], "Username: "..v[3].." Reason: "..v[4], {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SelectedPlayer = acbannedplayerstable[k]
                        end
                    end, RMenu:Get('adminmenu', 'acbanmenu'))
                end
            end
        end)
    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'acsearchpermid')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if foundMatch == false then
                acsearchforPermID = tARMA.KeyboardInput("Enter Perm ID", "", 10)
                if acsearchforPermID == nil then 
                    acsearchforPermID = ""
                end
            end
            for k, v in pairs(acbannedplayerstable) do
                foundMatch = true
                if string.find(v[2],acsearchforPermID) then
                    if tARMA.isDev() then
                        RageUI.ButtonWithStyle("Ban ID: "..v[1].." Perm ID: "..v[2], "Username: "..v[3].." Reason: "..v[4], {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                SelectedPlayer = acbannedplayerstable[k]
                            end
                        end, RMenu:Get('adminmenu', 'acbanmenu'))
                    end
                end
             end
        end)
    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'acbanmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tARMA.isDev() then
                RageUI.Separator("~r~ Ban Info ", function() end)
                RageUI.Separator("Ban ID: " .. SelectedPlayer[1], function() end)
                RageUI.Separator("Perm ID: " .. SelectedPlayer[2], function() end)
                RageUI.Separator("Username: " .. SelectedPlayer[3], function() end)
                RageUI.Separator("Reason: " .. SelectedPlayer[4], function() end)
                RageUI.Separator("Extra: " .. SelectedPlayer[5], function() end)
                RageUI.ButtonWithStyle("Unban Player","Unban Selected User",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        TriggerServerEvent('ARMA:acUnban', SelectedPlayer[2])
                        TriggerServerEvent("ARMA:getAnticheatData")
                    end
                end, RMenu:Get('adminmenu', "anticheat"))
                RageUI.ButtonWithStyle("Check Warnings","Show F10 Warning Log",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        ExecuteCommand("sw " .. SelectedPlayer[2])
                    end
                end)
            end
        end)
    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'actypes')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tARMA.isDev() then
                RageUI.Separator("Anticheat Duration: Lifetime", function() end)
                RageUI.Separator("Banned Players: " .. acbannedplayers, function() end)
                for i, p in pairs(actypes) do
                    RageUI.ButtonWithStyle("Type #"..p.type, p.desc, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end)
                end
            end
        end)
    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'acvehwhitelist')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tARMA.isDev() then
                RageUI.Separator("Anticheat Duration: Lifetime", function() end)
                RageUI.Separator("Banned Players: " .. acbannedplayers, function() end)
                RageUI.ButtonWithStyle("Add to Vehicle Whitelist","",{RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:editACVehicleWhitelist', true)
                    end
                end)
                RageUI.ButtonWithStyle("Remove from Vehicle Whitelist","",{RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('ARMA:editACVehicleWhitelist', false)
                    end
                end)
            end
        end)
    end
end)

RegisterCommand("cleanup", function()
    TriggerServerEvent('ARMA:CleanAll')
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
        elseif not FrozenPlayer and not noclipActive and not inSpectatorAdminMode and not staffMode then  
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

RegisterNetEvent("ARMA:sendAnticheatData")
AddEventHandler("ARMA:sendAnticheatData", function(table, players, types)
    acbannedplayerstable = table
    acbannedplayers = players
    actypes = types
end)



RegisterNetEvent("ARMA:GotGroups")
AddEventHandler("ARMA:GotGroups",function(gotGroups)
    searchPlayerGroups = gotGroups
end)

RegisterNetEvent("ARMA:getPlayersInfo")
AddEventHandler("ARMA:getPlayersInfo", function(BB, preasons)
    players = BB
    banreasons = preasons
    RageUI.Visible(RMenu:Get("adminmenu", "main"), not RageUI.Visible(RMenu:Get("adminmenu", "main")))
end)

RegisterNetEvent("ARMA:RecieveBanPlayerData")
AddEventHandler("ARMA:RecieveBanPlayerData",function(BanDuration, CollectedBanMessage, SepMSG, points)
    Duration = BanDuration
    BanMessage = CollectedBanMessage
    SeparatorMsg = SepMSG
    BanPoints = points
    RageUI.Visible(RMenu:Get('adminmenu', 'generatedban'), true)
end)

RegisterNetEvent("ARMA:sendBanChecked")
AddEventHandler("ARMA:sendBanChecked",function(bancheckedtable)
    banchecked = bancheckedtable
end)

RegisterNetEvent("ARMA:receivedUserInformation")
AddEventHandler("ARMA:receivedUserInformation", function(us,un,ub,uw,uc)
    if us == nil or un == nil or ub == nil or uw == nil or uc == nil then
        a10 = nil
        tARMA.notify("Player does not exist.")
        return
    end
    sc=us
    sn=un
    sb=getMoneyStringFormatted(ub)
    sw=getMoneyStringFormatted(uw)
    sch=getMoneyStringFormatted(uc)
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

RegisterCommand('openadminmenu',function()
    TriggerServerEvent('ARMA:GetPlayerData')
    TriggerServerEvent("ARMA:GetNearbyPlayerData")
    TriggerServerEvent("ARMA:getAdminLevel")
    GlobalAdminLevel = tARMA.getStaffLevel()
end)

RegisterCommand('devmenu',function()
    if tARMA.isDev() then
        RageUI.Visible(RMenu:Get("adminmenu", "devfunctions"), not RageUI.Visible(RMenu:Get("adminmenu", "devfunctions")))
    end
end)

RegisterCommand('anticheat',function()
    if tARMA.isDev() then
        RageUI.Visible(RMenu:Get("adminmenu", "anticheat"), not RageUI.Visible(RMenu:Get("adminmenu", "anticheat")))
    end
end)

function DrawHelpMsg(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
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

function func_checkSpectatorMode()
    if inSpectatorAdminMode then
        if IsControlJustPressed(0, 51) then
            inSpectatorAdminMode = false
            TriggerServerEvent("ARMA:stopSpectatePlayer", TargetSpectate)
        end
    end
end
tARMA.createThreadOnTick(func_checkSpectatorMode)