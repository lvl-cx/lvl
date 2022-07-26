local markers = {
    {308.89663696289,-592.33825683594,43.28405380249}, -- St Thomas
    {1832.9697265625,3682.7734375,34.270053863525}, -- Sandy
    {-254.51573181152,6332.248046875,32.427242279053}, -- Paleto
}

cooldown = false

Citizen.CreateThread(function() 
    while true do 
        Citizen.Wait(0)
        for k, v in pairs(markers) do 
            local v1 = vector3(table.unpack(v))
            DrawMarker(25, v1.x,v1.y,v1.z -0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 200, 0, 150, 0, 0, 2, 0, 0, 0, false)
            if Vdist2(GetEntityCoords(PlayerPedId()), v1) <= 1.4 then 
                alert('Press ~INPUT_VEH_HORN~ to get medical help')
                if IsControlJustPressed(0, 51) then 
                    if not cooldown then 
                        cooldown = true
                        SetEntityHealth(PlayerPedId(), 200)
                        tARMA.notify("~g~You have been healed, free of charge by the NHS.")
                    elseif cooldown then
                        tARMA.notify("~r~You cannot get healed, try again later")
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
    Wait(15000)
      if cooldown == true then
        cooldown = false
      end
    end
  end)

-- [Blips]
Citizen.CreateThread(function()
    blip = AddBlipForCoord(1832.9547119141,3682.9191894531,34.270072937012)
    SetBlipSprite(blip, 80)
    SetBlipScale(blip, 0.4)
    SetBlipDisplay(blip, 2)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Sandy Hospital")
    EndTextCommandSetBlipName(blip)
  end)
  
  Citizen.CreateThread(function()
    blip = AddBlipForCoord(-254.43467712402,6332.3833007812,32.42724609375)
    SetBlipSprite(blip, 80)
    SetBlipScale(blip, 0.4)
    SetBlipDisplay(blip, 2)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Paleto Hospital")
    EndTextCommandSetBlipName(blip)
  end)
  
  Citizen.CreateThread(function()
    blip = AddBlipForCoord(308.84286499023,-592.34204101562,43.284061431885)
    SetBlipSprite(blip, 80)
    SetBlipScale(blip, 0.4)
    SetBlipDisplay(blip, 2)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("City Hospital")
    EndTextCommandSetBlipName(blip)
  end)
  