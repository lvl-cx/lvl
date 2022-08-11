local b={vector3(-552.35083007813,-191.59149169922,38.21964263916)}
local c=false
local d=""
local j="N/A"
local k="N/A"
local i=0
local U=false
RMenu.Add("identity","main",RageUI.CreateMenu("","~b~City Hall",0,100,'banners', 'identity'))
RMenu.Add('identity','confirm',RageUI.CreateSubMenu(RMenu:Get('identity','main'),"","Confirm Identity"))
Citizen.CreateThread(function()
    if true then 
        local g=function()
            drawNativeNotification("Press ~INPUT_PICKUP~ to access the City Hall.")
            PlaySound(-1,"SELECT","HUD_MINI_GAME_SOUNDSET",0,0,1)
        end
        local h=function()
            RageUI.ActuallyCloseAll()
            RageUI.Visible(RMenu:Get("identity","main"),false)
        end
        local i=function()
            if IsControlJustPressed(1,51)then 
                TriggerServerEvent('ARMA:getIdentity')
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("identity","main"),not RageUI.Visible(RMenu:Get("identity","main")))
            end 
        end
        for j,k in pairs(b)do 
            tARMA.createArea("identity_"..j,k,1.5,6,g,h,i)
            tARMA.addMarker(k.x,k.y,k.z-0.2,0.5,0.5,0.5,0,50,255,170,50,20,false,false,true)
        end 
    end 
end)

RegisterNetEvent("ARMA:gotCurrentIdentity")
AddEventHandler("ARMA:gotCurrentIdentity", function(firstname,lastname,age)
    j=firstname
    k=lastname
    i=age
end)

RegisterNetEvent("ARMA:gotNewIdentity")
AddEventHandler("ARMA:gotNewIdentity", function(firstname,lastname,age)
    newfirstname=firstname
    newlastname=lastname
    newage=age
    RageUI.Visible(RMenu:Get('identity', 'confirm'), true)
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('identity', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if j ~= "N/A" then
                RageUI.Separator("~b~Your current identity")
                RageUI.Separator("Firstname ~y~|~w~ "..j.."")
                RageUI.Separator("Lastname ~y~|~w~ "..k.."")
                RageUI.Separator("Age ~y~|~w~ "..i.."")
                RageUI.ButtonWithStyle("Change your Identity","£5000",{RightLabel="→→→"},true,function(l,m,n)
                    if n then 
                        RageUI.ActuallyCloseAll()
                        TriggerServerEvent('ARMA:getNewIdentity')
                    end 
                end)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('identity', 'confirm')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("~b~Your new identity")
            RageUI.Separator("Firstname ~y~|~w~ "..newfirstname.."")
            RageUI.Separator("Lastname ~y~|~w~ "..newlastname.."")
            RageUI.Separator("Age ~y~|~w~ "..newage.."")
            RageUI.ButtonWithStyle("Yes","",{RightLabel="→→→"},true,function(j,k,l)
                if l then 
                    TriggerServerEvent("ARMA:ChangeIdentity", newfirstname, newlastname, tonumber(newage))
                end 
            end,RMenu:Get("identity","confirm"))
            RageUI.ButtonWithStyle("No","",{RightLabel="→→→"},true,function(j,k,l)
            end,RMenu:Get("identity","main"))
        end)
    end
end)