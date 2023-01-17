local loadouts = {}
local selectedLoadout = nil
local weapons = module("cfg/weapons")

RMenu.Add("policeloadouts","main",RageUI.CreateMenu("","Please Select Division",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"banners","gunstore"))
RMenu.Add("policeloadouts","confirm",RageUI.CreateSubMenu(RMenu:Get("policeloadouts", "main"),"","Confirm Selection",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight()))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('policeloadouts', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k,v in pairs(loadouts) do
                RageUI.Button(k, nil, {RightBadge = "→→→"}, v.hasPermission, function(Hovered, Active, Selected)
                    if Selected then
                        selectedLoadout = k
                    end
                end, RMenu:Get('policeloadouts', 'confirm'))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('policeloadouts', 'confirm')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator('~g~'..selectedLoadout)
            for k,v in pairs(loadouts[selectedLoadout].weapons) do
                RageUI.Separator(weapons.weapons[v].name)
            end
            RageUI.Button("Confirm", nil, {RightBadge = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('ARMA:selectLoadout', selectedLoadout)
                    RageUI.Visible(RMenu:Get("policeloadouts", "confirm"), false)
                    RageUI.ActuallyCloseAll()
                end
            end)
        end)
    end
end)

RegisterNetEvent('ARMA:gotLoadouts')
AddEventHandler('ARMA:gotLoadouts', function(loadoutsTable)
    loadouts = loadoutsTable
end)

AddEventHandler("ARMA:onClientSpawn",function(p, q)
    if q then
        local r = function(s)
        end
        local t = function(s)
            selectedLoadout = nil
            RageUI.Visible(RMenu:Get("policeloadouts", "main"), false)
            RageUI.Visible(RMenu:Get("policeloadouts", "confirm"), false)
            RageUI.ActuallyCloseAll()
        end
        local u = function(s)
            if IsControlJustPressed(1, 38) then
                TriggerServerEvent('ARMA:getPoliceLoadouts')
                RageUI.Visible(RMenu:Get("policeloadouts", "main"), not RageUI.Visible(RMenu:Get("policeloadouts", "main")))
            end
            local v, w, x = table.unpack(GetFinalRenderedCamCoord())
            DrawText3D(457.0222, -983.0001, 30.68948,"Press [E] to open Police Loadouts",v,w,x)
        end
        tARMA.createArea("police_loadouts", vector3(457.0222, -983.0001, 30.68948), 1.5, 6, r, t, u, {})
    end
end)