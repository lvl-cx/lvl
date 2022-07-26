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