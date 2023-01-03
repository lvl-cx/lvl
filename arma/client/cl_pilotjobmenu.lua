local a = module("cfg/cfg_pilotjob")
local b = a.planeTiers
local c = a.previewPlaneLoc
local d = false
local e
local f = 0
local g = ""
local h
RMenu.Add("ARMApilotjob","mainMenu",RageUI.CreateMenu("","Pilot Menu",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"cmg_pilotjob","cmg_pilotjob"))
RegisterNetEvent("ARMA:updateClientPilotLevel",function(i)
    if i then
        f = i
    end
end)
AddEventHandler("ARMA:onClientSpawn",function(j, k)
    if k then
        local l = function()
            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ to Enter the Pilot Job Menu")
            EndTextCommandDisplayHelp(0, false, true, -1)
        end
        local m = function()
            g = nil
        end
        local n = function()
            if IsControlJustPressed(0, 51) and not RageUI.IsVisible(RMenu:Get("ARMApilotjob", "mainMenu")) then
                if globalOnPilotDuty then
                    RageUI.Visible(RMenu:Get("ARMApilotjob", "mainMenu"), true)
                    h = true
                    Citizen.CreateThread(function()
                        while h do
                            DisableControlAction(0, 75, true)
                            DisableControlAction(0, 121, true)
                            Wait(0)
                        end
                    end)
                else
                    tARMA.notify("~r~You are not signed up as a Pilot, head to the job centre to sign up!")
                end
            end
        end
        tARMA.createArea("pilotMenu", a.startJobLocs[1].coords, 10, 10, l, m, n)
    end
end)
RegisterNetEvent("ARMA:setOnPilotDuty",function(o)
    globalOnPilotDuty = o
end)
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('ARMApilotjob', 'mainMenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for p = 1, #b, 1 do
                local q
                local r
                if f >= b[p].level then
                    q = string.format("%s (Max. Capacity: %s)", b[p].planeName, b[p].maximumCapacity)
                    r = ""
                else
                    q = string.format("~m~%s (Max. Capacity: %s)", b[p].planeName, b[p].maximumCapacity)
                    r = "🔒"
                end
                RageUI.ButtonWithStyle(q,"Available at level: " .. b[p].level .. ", Your level: " .. f,{RightLabel = r},true,function(s, t, u)
                    local v = b[p]
                    if t then
                        if v ~= g then
                            if e ~= nil then
                                DeleteEntity(e)
                                Citizen.Wait(250)
                            end
                            e = tARMA.spawnVehicle(v.spawnName,c.coords.x,c.coords.y,c.coords.z,58.7,true,false,false)
                            BeginTextCommandPrint("STRING")
                            AddTextComponentSubstringPlayerName("~r~Loading Model")
                            EndTextCommandPrint(1000, 1)
                            FreezeEntityPosition(e, true)
                            SetEntityInvincible(e, true)
                            d = true
                            g = v
                        end
                        if IsControlJustPressed(0, 172) or IsControlJustPressed(0, 241) or IsControlJustPressed(0, 173) or IsControlJustPressed(0, 242) or IsControlJustPressed(0, 177) then
                            DeleteEntity(e)
                            d = false
                            h = false
                        end
                    end
                    if u then
                        if DoesEntityExist(e) then
                            DeleteEntity(e)
                            Citizen.Wait(500)
                            TriggerServerEvent("ARMA:startPilotJob", p)
                            d = false
                            RageUI.Visible(RMenu:Get("ARMApilotjob", "mainMenu"), false)
                            RageUI.ActuallyCloseAll()
                            h = false
                        end
                    end
                end,nil)
            end
            RageUI.Button("End Shift",nil,{},function(s, t, u)
                if t then
                    if DoesEntityExist(e) then
                        DeleteEntity(e)
                    end
                end
                if u then
                    TriggerServerEvent("ARMA:pilotJobReset")
                    tARMA.notify("~r~Ended Shift!")
                    RageUI.Visible(RMenu:Get("ARMApilotjob", "mainMenu"), false)
                    RageUI.ActuallyCloseAll()
                    DeleteEntity(e)
                    h = false
                end
            end)
        end)
    end
end)
