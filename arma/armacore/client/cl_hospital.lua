local a=GetGameTimer()-30000
local b={
    ["city"]=vector3(309.04260253906,-592.22509765625,42.284008026123),
    ["sandy"]=vector3(1833.0328369141,3682.8110351563,33.270057678223),
    ["paleto"]=vector3(-251.9546661377,6334.146484375,31.427177429199),
    ["london"]=vector3(355.45614624023,-1416.0190429688,32.510429382324),
    ["mountzenah"]=vector3(-436.04296875,-326.27416992188,33.910766601562)
}
Citizen.CreateThread(function()
    if true then 
        local e=function(f)
            tARMA.drawNativeNotification("Press ~INPUT_PICKUP~ to recieve medical attention.")
        end
        local g=function(f)
        end
        local h=function(f)
            if IsControlJustPressed(1,51)then 
                local i=tARMA.getPlayerPed()
                if not tARMA.isInComa()then 
                    if tARMA.getPlayerVehicle()==0 then 
                        if GetGameTimer()>a+30000 then 
                            SetEntityHealth(i,200)
                            tARMA.notify("~g~Healed, free of charge by the NHS.")
                            a=GetGameTimer()
                        else 
                            tARMA.notify("~r~Healing cooldown, come back later.")
                        end 
                    else 
                        tARMA.notify("~r~You can not heal whilst in a vehicle.")
                    end
                else tARMA.notify("~r~You are bleeding out, call a doctor ASAP!")
                end 
            end 
        end
        for j,k in pairs(b)do 
            tARMA.addMarker(k.x,k.y,k.z,1.0,1.0,1.0,0,0,255,100,50,27,false,false,true)
            tARMA.createArea(j.."_hospital",k,1.5,6,e,g,h,{})
        end 
    end 
end)

RegisterNetEvent('morphine')
AddEventHandler('morphine', function()
    while true do 
        Citizen.Wait(1000)
        SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 2)
        if GetEntityHealth(PlayerPedId()) == 200 then 
            notify('~r~The morphine effect has stopped!')
            break; 
        end
    end
end)

cpr_in_progress = false

RegisterNetEvent('ARMA:cprAnim')
AddEventHandler('ARMA:cprAnim', function(nplayer)
  if GetEntityHealth(GetPlayerPed(GetPlayerFromServerId(nplayer))) == 102 then
    if not cpr_in_progress then
      cpr_in_progress = true
      tARMA.notify("~g~CPR in progress.")
      math.randomseed(GetGameTimer())
      cprChance = math.random(1,8)
      local ad = "missheistfbi3b_ig8_2"
      local ad2 = "cpr_loop_paramedic"
      RequestAnimDict(ad)
      RequestAnimDict(ad2)
      TaskPlayAnim(PlayerPedId(), ad, ad2, 8.0, 1.0, -1, 12, 0, 0, 0, 0 )
      Wait(12000)
      if cprChance == 1 then
        TriggerServerEvent("ARMA:SendFixClient", nplayer)
        tARMA.notify("~g~You have saved this person's life.")
      else
        tARMA.notify("~r~You need to practice CPR more, please try again.")
      end
      Wait(2000)
      cpr_in_progress = false  
      ClearPedSecondaryTask(PlayerPedId())
    else
      tARMA.notify("~r~You are already performing CPR.")
    end
  else
    tARMA.notify("~r~You cannot perform CPR on this person.")
  end
end)