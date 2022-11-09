local currentStaff = {}
local selectedStaff = nil
local staffMenuDisplay = false
local title = 'ARMA Staff Menu'
local a=18
local b=82
local c=228
local d={}
local d2={}
local e=1
local e2=1
local f=1
local f2=1

RegisterNetEvent('ARMA:sendOnlineStaff')
AddEventHandler('ARMA:sendOnlineStaff', function(staff)
    currentStaff = staff
end)

function staffMenuDisplay()
    if showStaffMenu then 
        DrawRect(0.501,0.532,0.375,0.225,0,0,0,150)
        DrawRect(0.501,0.396,0.375,0.046,18,82,228,255)
        DrawAdvancedText(0.591,0.399,0.005,0.0028,0.51,title,255,255,255,255,7,0)
        DrawAdvancedText(0.585,0.475,0.005,0.0028,0.4,"There is currently ~g~"..#currentStaff.." ~w~staff online",255,255,255,255,7,0)
        DrawAdvancedText(0.590,0.534,0.005,0.0028,0.4,"View Online Staff",255,255,255,255,7,0)
        --[[ if CursorInArea(0.3333,0.3973,0.4981,0.5537)then 
            DrawRect(0.501,0.527,0.085,0.056,a,b,c,150)
            if IsControlJustPressed(1,329)or IsDisabledControlJustPressed(1,329)then 
                PlaySound(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",0,0,1)
                showStaffMenu=false
                showFundsGangUI=true 
            end 
        else 
            DrawRect(0.501,0.527,0.085,0.056,0,0,0,150)
        end ]]
        if CursorInArea(0.4244,0.4903,0.4981,0.5537)then 
            DrawRect(0.495,0.527,0.105,0.056,a,b,c,150)
            if IsControlJustPressed(1,329)or IsDisabledControlJustPressed(1,329)then 
                PlaySound(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",0,0,1)
                showStaffMenu=false
                showStaffMembers=true 
            end 
        else 
            DrawRect(0.495,0.527,0.105,0.056,0,0,0,150)
        end
    end 
    if showStaffMembers then 
        DrawRect(0.501,0.525,0.421,0.387,0,0,0,150)
        DrawRect(0.501,0.308,0.421,0.047,18,82,228,248)
        DrawAdvancedText(0.591,0.312,0.005,0.0028,0.48,title,255,255,255,255,7,0)
        DrawRect(0.398,0.52,0.195,0.291,0,0,0,150)
        DrawAdvancedText(0.420,0.359,0.005,0.0028,0.4,"Name",255,255,255,255,6,0)
        DrawAdvancedText(0.450,0.359,0.005,0.0028,0.4,"ID",255,255,255,255,6,0)
        DrawAdvancedText(0.480,0.359,0.005,0.0028,0.4,"Rank",255,255,255,255,6,0)
        DrawAdvancedText(0.510,0.359,0.005,0.0028,0.4,"Hours",255,255,255,255,6,0)
        DrawAdvancedText(0.540,0.359,0.005,0.0028,0.4,"Ping",255,255,255,255,6,0)
        DrawAdvancedText(0.570,0.359,0.005,0.0028,0.4,"Location",255,255,255,255,6,0)
        --DrawAdvancedText(0.600,0.359,0.005,0.0028,0.4,"Bucket",255,255,255,255,6,0)
        DrawAdvancedText(0.647,0.447,0.005,0.0028,0.4,"Kill",255,255,255,255,4,0)
        DrawAdvancedText(0.746,0.447,0.005,0.0028,0.4,"Manage Groups",255,255,255,255,4,0)
        DrawAdvancedText(0.647,0.573,0.005,0.0028,0.4,"Coming Soon",255,255,255,255,4,0)
        DrawAdvancedText(0.746,0.572,0.005,0.0028,0.4,"Coming Soon",255,255,255,255,4,0)
        DrawAdvancedText(0.445,0.695,0.005,0.0028,0.4,"Previous",255,255,255,255,4,0)
        DrawAdvancedText(0.531,0.695,0.005,0.0028,0.4,"Next",255,255,255,255,4,0)
        DrawAdvancedText(0.486,0.695,0.005,0.0028,0.4,tostring(e).."/"..tostring(f),255,255,255,255,4,0)
        DrawAdvancedText(0.775,0.693,0.005,0.0028,0.4,"Back",255,255,255,255,4,0)
        --print(json.encode(currentStaff))
        for p,r in pairs(currentStaff)do 
            DrawAdvancedText(0.420,0.361+0.0287*p,0.005,0.0028,0.4,r.name,255,255,255,255,6,0)
            DrawAdvancedText(0.450,0.361+0.0287*p,0.005,0.0028,0.4,r.id,255,255,255,255,6,0)
            DrawAdvancedText(0.480,0.361+0.0287*p,0.005,0.0028,0.4,r.staffRank,255,255,255,255,6,0)
            DrawAdvancedText(0.510,0.361+0.0287*p,0.005,0.0028,0.4,r.hours,255,255,255,255,6,0)
            DrawAdvancedText(0.540,0.361+0.0287*p,0.005,0.0028,0.4,r.ping,255,255,255,255,6,0)
            --DrawAdvancedText(0.570,0.361+0.0287*p,0.005,0.0028,0.4,r.location,255,255,255,255,6,0)
            --DrawAdvancedText(0.600,0.361+0.0287*p,0.005,0.0028,0.4,r.bucket,255,255,255,255,6,0)
            if CursorInArea(0.3000,0.4942,0.3731+0.0287*(p-1),0.4018+0.0287*(p-1))and selectedMember~=r.tempid then 
                DrawRect(0.398,0.388+0.0287*(p-1),0.195,0.027,a,b,c,150)
                if IsControlJustPressed(1,329)or IsDisabledControlJustPressed(1,329)then 
                    PlaySound(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",0,0,1)
                    selectedMember=r.tempid
                end 
            elseif selectedMember==r.tempid then 
                DrawRect(0.398,0.388+0.0287*(p-1),0.195,0.027,a,b,c,150)
            end 
        end
        if CursorInArea(0.5187,0.5828,0.4138,0.4694)then 
            DrawRect(0.552,0.443,0.065,0.056,a,b,c,150)
            if IsControlJustPressed(1,329)or IsDisabledControlJustPressed(1,329)then 
                PlaySound(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",0,0,1)
                if selectedMember~=nil then 
                    if tARMA.getStaffLevel() >=6 then 
                        TriggerServerEvent('ARMA:SlapPlayer', GetPlayerServerId(PlayerId()), tonumber(selectedMember))
                    else 
                        tARMA.notify("~r~You don't have permission to slap players!")
                    end 
                else 
                    tARMA.notify("~r~No staff member selected")
                end 
            end 
        else 
            DrawRect(0.552,0.443,0.065,0.056,0,0,0,150)
        end
        if CursorInArea(0.6182,0.6822,0.4138,0.4694)then 
            DrawRect(0.651,0.443,0.065,0.056,a,b,c,150)
            if IsControlJustPressed(1,329)or IsDisabledControlJustPressed(1,329)then 
                PlaySound(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",0,0,1)
                if selectedMember~=nil then 
                    if tARMA.getStaffLevel() >=6 then 
                        TriggerServerEvent('ARMA:groupManagement')
                    else 
                        tARMA.notify("~r~You don't have permission to manage groups!")
                    end 
                else 
                    tARMA.notify("~r~No staff member selected")
                end 
            end 
        else 
            DrawRect(0.651,0.443,0.065,0.056,0,0,0,150)
        end
        if CursorInArea(0.5187,0.5828,0.5407,0.5962)then 
            DrawRect(0.552,0.569,0.065,0.056,a,b,c,150)
            if IsControlJustPressed(1,329)or IsDisabledControlJustPressed(1,329)then 
                PlaySound(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",0,0,1)
                if selectedMember~=nil then 
                else 
                    tARMA.notify("~r~No staff member selected")
                end 
            end 
        else 
            DrawRect(0.552,0.569,0.065,0.056,0,0,0,150)
        end
        if CursorInArea(0.6182,0.6822,0.5407,0.5962)then 
            DrawRect(0.651,0.569,0.065,0.056,a,b,c,150)
            if IsControlJustPressed(1,329)or IsDisabledControlJustPressed(1,329)then 
                PlaySound(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",0,0,1)
                if selectedMember~=nil then 
                else 
                    tARMA.notify("~r~No staff member selected")
                end 
            end 
        else 
            DrawRect(0.651,0.569,0.065,0.056,0,0,0,150)
        end
        if CursorInArea(0.3281,0.3723,0.6768,0.7074)then 
            DrawRect(0.351,0.693,0.045,0.033,a,b,c,150)
            if IsControlJustPressed(1,329)or IsDisabledControlJustPressed(1,329)then 
                PlaySound(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",0,0,1)
                if e<=1 then 
                    tARMA.notify("~r~Lowest page reached")
                else 
                    e=e-1 
                end 
            end 
        else 
            DrawRect(0.351,0.693,0.045,0.033,0,0,0,150)
        end
        if CursorInArea(0.4130,0.4572,0.6712,0.7064)then 
            DrawRect(0.436,0.693,0.045,0.033,a,b,c,150)
            if IsControlJustPressed(1,329)or IsDisabledControlJustPressed(1,329)then 
                PlaySound(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",0,0,1)
                if e>=f then 
                    tARMA.notify("~r~Max page reached")
                else 
                    e=e+1 
                end 
            end 
        else 
            DrawRect(0.436,0.693,0.045,0.033,0,0,0,150)
        end
        if CursorInArea(0.6583,0.7056,0.6712,0.7064)then 
            DrawRect(0.681,0.689,0.045,0.036,a,b,c,150)
            if IsControlJustPressed(1,329)or IsDisabledControlJustPressed(1,329)then 
                PlaySound(-1,"SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET",0,0,1)
                showStaffMembers=false
                showStaffMenu=true 
            end 
        else 
            DrawRect(0.681,0.689,0.045,0.036,0,0,0,150)
        end 
    end
end
createThreadOnTick(staffMenuDisplay)
Citizen.CreateThread(function()
    while true do 
        if IsControlJustPressed(0,167)or IsDisabledControlJustPressed(0,167)then 
            TriggerServerEvent('ARMA:getOnlineStaff')
            if tARMA.getStaffLevel() > 0 then 
                showStaffMembers=false
                if showStaffMenu then 
                    showStaffMenu=false
                    setCursor(0)
                    inGUIARMA=false
                    selectedMember=nil 
                else 
                    showStaffMenu=true
                    setCursor(1)
                    inGUIARMA=true 
                end 
            end
            Wait(100)
        end
        Wait(0)
    end 
end)