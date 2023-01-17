
-- this module define some police tools and functions
local lang = ARMA.lang
local a = module("cfg/weapons")

local isStoring = {}
local choice_store_weapons = function(player, choice)
    local user_id = ARMA.getUserId(player)
    local data = ARMA.getUserDataTable(user_id)
    ARMAclient.getWeapons(player,{},function(weapons)
      if not isStoring[player] then
          if ARMA.getInventoryWeight(user_id) <= 25 then
            isStoring[player] = true
            ARMAclient.giveWeapons(player,{{},true}, function(removedwep)
              for k,v in pairs(weapons) do
                if k ~= 'GADGET_PARACHUTE' and k ~= 'WEAPON_STAFFGUN' and k~= 'WEAPON_SMOKEGRENADE' and k~= 'WEAPON_FLASHBANG' then
                  ARMA.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                  if v.ammo > 0 and k ~= 'WEAPON_STUNGUN' then
                    for i,c in pairs(a.weapons) do
                      if i == k and c.class ~= 'Melee' then
                        if v.ammo > 250 then
                          v.ammo = 250
                        end
                        ARMA.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                      end   
                    end
                  end
                end
              end
              ARMAclient.notify(player,{"~g~Weapons Stored"})
              TriggerEvent('ARMA:RefreshInventory', player)
              SetTimeout(3000,function()
                  isStoring[player] = nil 
              end)
              ARMAclient.ClearWeapons(player,{})
            end)
          else
            ARMAclient.notify(player,{'~r~You do not have enough Weight to store Weapons.'})
          end
       end
    end)
end

RegisterServerEvent("ARMA:forceStoreSingleWeapon")
AddEventHandler("ARMA:forceStoreSingleWeapon",function(model)
    local source = source
    local user_id = ARMA.getUserId(source)
    if model ~= nil then
      ARMAclient.getWeapons(source,{},function(weapons)
        for k,v in pairs(weapons) do
          if k == model then
            RemoveWeaponFromPed(GetPlayerPed(source), k)
            ARMAclient.removeWeapon(source,{k})
            ARMA.giveInventoryItem(user_id, "wbody|"..k, 1, true)
            if v.ammo > 0 then
              for i,c in pairs(a.weapons) do
                if i == model and c.class ~= 'Melee' then
                  ARMA.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                end   
              end
            end
          end
        end
      end)
    end
end)

RegisterCommand('storeallweapons', function(source)
  choice_store_weapons(source)
end)


RegisterCommand('shield', function(source, args)
  local source = source
  local user_id = ARMA.getUserId(source)
  if ARMA.hasPermission(user_id, 'police.onduty.permission') then
    TriggerClientEvent('ARMA:toggleShieldMenu', source)
  end
end)

RegisterCommand('cuff', function(source, args)
  local source = source
  local user_id = ARMA.getUserId(source)
  ARMAclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      ARMAclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and ARMA.hasPermission(user_id, 'admin.tickets')) or ARMA.hasPermission(user_id, 'police.onduty.permission') then
          ARMAclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = ARMA.getUserId(nplayer)
              if (not ARMA.hasPermission(nplayer_id, 'police.onduty.permission') or ARMA.hasPermission(nplayer_id, 'police.undercover')) then
                ARMAclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('ARMA:uncuffAnim', source, nplayer, false)
                    TriggerClientEvent('ARMA:unHandcuff', source, false)
                  else
                    TriggerClientEvent('ARMA:arrestCriminal', nplayer, source)
                    TriggerClientEvent('ARMA:arrestFromPolice', source)
                  end
                  TriggerClientEvent('ARMA:toggleHandcuffs', nplayer, false)
                  TriggerClientEvent('ARMA:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              ARMAclient.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

RegisterCommand('frontcuff', function(source, args)
  local source = source
  local user_id = ARMA.getUserId(source)
  ARMAclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      ARMAclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and ARMA.hasPermission(user_id, 'admin.tickets')) or ARMA.hasPermission(user_id, 'police.onduty.permission') then
          ARMAclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = ARMA.getUserId(nplayer)
              if (not ARMA.hasPermission(nplayer_id, 'police.onduty.permission') or ARMA.hasPermission(nplayer_id, 'police.undercover')) then
                ARMAclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('ARMA:uncuffAnim', source, nplayer, true)
                    TriggerClientEvent('ARMA:unHandcuff', source, true)
                  else
                    TriggerClientEvent('ARMA:arrestCriminal', nplayer, source)
                    TriggerClientEvent('ARMA:arrestFromPolice', source)
                  end
                  TriggerClientEvent('ARMA:toggleHandcuffs', nplayer, true)
                  TriggerClientEvent('ARMA:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              ARMAclient.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

local section60s = {}
RegisterCommand('s60', function(source, args)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.announce') then
        if args[1] ~= nil and args[2] ~= nil then
            local radius = tonumber(args[1])
            local duration = tonumber(args[2])*60
            local section60UUID = #section60s+1
            section60s[section60UUID] = {radius = radius, duration = duration, uuid = section60UUID}
            TriggerClientEvent("ARMA:addS60", -1, GetEntityCoords(GetPlayerPed(source)), radius, section60UUID)
        else
            ARMAclient.notify(source,{'~r~Invalid Arguments.'})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(section60s) do
            if section60s[k].duration > 0 then
                section60s[k].duration = section60s[k].duration-1 
            else
                TriggerClientEvent('ARMA:removeS60', -1, section60s[k].uuid)
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterCommand('handbook', function(source, args)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
      TriggerClientEvent('ARMA:toggleHandbook', source)
    end
end)

local draggingPlayers = {}

RegisterServerEvent('ARMA:dragPlayer')
AddEventHandler('ARMA:dragPlayer', function(playersrc)
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil and (ARMA.hasPermission(user_id, "police.onduty.permission") or ARMA.hasPermission(user_id, "prisonguard.onduty.permission")) then
      if playersrc ~= nil then
        local nuser_id = ARMA.getUserId(playersrc)
          if nuser_id ~= nil then
            ARMAclient.isHandcuffed(playersrc,{},function(handcuffed)
                if handcuffed then
                    if draggingPlayers[user_id] then
                      TriggerClientEvent("ARMA:undrag", playersrc, source)
                      draggingPlayers[user_id] = nil
                    else
                      TriggerClientEvent("ARMA:drag", playersrc, source)
                      draggingPlayers[user_id] = playersrc
                    end
                else
                    ARMAclient.notify(source,{"~r~Player is not handcuffed."})
                end
            end)
          else
              ARMAclient.notify(source,{"~r~There is no player nearby"})
          end
      else
          ARMAclient.notify(source,{"~r~There is no player nearby"})
      end
    end
end)

RegisterServerEvent('ARMA:putInVehicle')
AddEventHandler('ARMA:putInVehicle', function(playersrc)
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil and ARMA.hasPermission(user_id, "police.onduty.permission") then
      if playersrc ~= nil then
        ARMAclient.isHandcuffed(playersrc,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            ARMAclient.putInNearestVehicleAsPassenger(playersrc, {10})
          else
            ARMAclient.notify(source,{lang.police.not_handcuffed()})
          end
        end)
      end
    end
end)

RegisterServerEvent('ARMA:ejectFromVehicle')
AddEventHandler('ARMA:ejectFromVehicle', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil and ARMA.hasPermission(user_id, "police.onduty.permission") then
      ARMAclient.getNearestPlayer(source,{10},function(nplayer)
        local nuser_id = ARMA.getUserId(nplayer)
        if nuser_id ~= nil then
          ARMAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
            if handcuffed then
              ARMAclient.ejectVehicle(nplayer, {})
            else
              ARMAclient.notify(source,{lang.police.not_handcuffed()})
            end
          end)
        else
          ARMAclient.notify(source,{lang.common.no_player_near()})
        end
      end)
    end
end)


RegisterServerEvent("ARMA:Knockout")
AddEventHandler('ARMA:Knockout', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    ARMAclient.getNearestPlayer(source, {2}, function(nplayer)
        local nuser_id = ARMA.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('ARMA:knockOut', nplayer)
            SetTimeout(30000, function()
                TriggerClientEvent('ARMA:knockOutDisable', nplayer)
            end)
        end
    end)
end)

RegisterServerEvent("ARMA:KnockoutNoAnim")
AddEventHandler('ARMA:KnockoutNoAnim', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'Founder') then
      ARMAclient.getNearestPlayer(source, {2}, function(nplayer)
          local nuser_id = ARMA.getUserId(nplayer)
          if nuser_id ~= nil then
              TriggerClientEvent('ARMA:knockOut', nplayer)
              SetTimeout(30000, function()
                  TriggerClientEvent('ARMA:knockOutDisable', nplayer)
              end)
          end
      end)
    end
end)

RegisterServerEvent("ARMA:requestPlaceBagOnHead")
AddEventHandler('ARMA:requestPlaceBagOnHead', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.getInventoryItemAmount(user_id, 'Headbag') >= 1 then
      ARMAclient.getNearestPlayer(source, {10}, function(nplayer)
          local nuser_id = ARMA.getUserId(nplayer)
          if nuser_id ~= nil then
              ARMA.tryGetInventoryItem(user_id, 'Headbag', 1, true)
              TriggerClientEvent('ARMA:placeHeadBag', nplayer)
          end
      end)
    end
end)

RegisterServerEvent('ARMA:gunshotTest')
AddEventHandler('ARMA:gunshotTest', function(playersrc)
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil and ARMA.hasPermission(user_id, "police.onduty.permission") then
      if playersrc ~= nil then
        ARMAclient.hasRecentlyShotGun(playersrc,{}, function(shotagun)
          if shotagun then
            ARMAclient.notify(source, {"~r~Player has recently shot a gun."})
          else
            ARMAclient.notify(source, {"~r~Player has no gunshot residue on fingers."})
          end
        end)
      end
    end
end)

RegisterServerEvent('ARMA:tryTackle')
AddEventHandler('ARMA:tryTackle', function(id)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') or ARMA.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent('ARMA:playTackle', source)
        TriggerClientEvent('ARMA:getTackled', id, source)
    end
end)

RegisterCommand('drone', function(source, args)
  local source = source
  local user_id = ARMA.getUserId(source)
  if ARMA.hasGroup(user_id, 'Drone Trained') then
      TriggerClientEvent('toggleDrone', source)
  end
end)

RegisterCommand('trafficmenu', function(source, args)
  local source = source
  local user_id = ARMA.getUserId(source)
  if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('ARMA:toggleTrafficMenu', source)
  end
end)

RegisterServerEvent('ARMA:startThrowSmokeGrenade')
AddEventHandler('ARMA:startThrowSmokeGrenade', function(name)
    local source = source
    TriggerClientEvent('ARMA:displaySmokeGrenade', -1, name, GetEntityCoords(GetPlayerPed(source)))
end)

RegisterCommand('breathalyse', function(source, args)
  local source = source
  local user_id = ARMA.getUserId(source)
  if ARMA.hasPermission(user_id, 'police.onduty.permission') then
      TriggerClientEvent('ARMA:breathalyserCommand', source)
  end
end)

RegisterServerEvent('ARMA:breathalyserRequest')
AddEventHandler('ARMA:breathalyserRequest', function(temp)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
      TriggerClientEvent('ARMA:beingBreathalysed', temp)
      TriggerClientEvent('ARMA:breathTestResult', source, math.random(0, 100), GetPlayerName(temp))
    end
end)

seizeBullets = {
  ['9mm Bullets'] = true,
  ['7.62mm Bullets'] = true,
  ['.357 Bullets'] = true,
  ['12 Gauge Bullets'] = true,
  ['.308 Sniper Rounds'] = true,
}
RegisterServerEvent('ARMA:seizeWeapons')
AddEventHandler('ARMA:seizeWeapons', function(playerSrc)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
      RemoveAllPedWeapons(GetPlayerPed(playerSrc), true)
      local player_id = ARMA.getUserId(playerSrc)
      local cdata = ARMA.getUserDataTable(player_id)
      for a,b in pairs(cdata.inventory) do
          if string.find(a, 'wbody|') then
              c = a:gsub('wbody|', '')
              cdata.inventory[c] = b
              cdata.inventory[a] = nil
          end
      end
      for k,v in pairs(a.weapons) do
          if cdata.inventory[k] ~= nil then
              if not v.policeWeapon then
                cdata.inventory[k] = nil
              end
          end
      end
      for c,d in pairs(cdata.inventory) do
          if seizeBullets[c] then
            cdata.inventory[c] = nil
          end
      end
      TriggerEvent('ARMA:RefreshInventory', playerSrc)
      ARMAclient.notify(source, {'~r~Seized weapons.'})
      ARMAclient.notify(playerSrc, {'~r~Your weapons have been seized.'})
    end
end)

seizeDrugs = {
  ['Weed leaf'] = true,
  ['Weed'] = true,
  ['Coca leaf'] = true,
  ['Cocaine'] = true,
  ['Opium Poppy'] = true,
  ['Heroin'] = true,
  ['Ephedra'] = true,
  ['Meth'] = true,
  ['Frogs legs'] = true,
  ['Lysergic Acid Amide'] = true,
  ['LSD'] = true,
}
RegisterServerEvent('ARMA:seizeIllegals')
AddEventHandler('ARMA:seizeIllegals', function(playerSrc)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
      local player_id = ARMA.getUserId(playerSrc)
      local cdata = ARMA.getUserDataTable(player_id)
      for a,b in pairs(cdata.inventory) do
          for c,d in pairs(seizeDrugs) do
              if a == c then
                cdata.inventory[a] = nil
              end
          end
      end
      TriggerEvent('ARMA:RefreshInventory', playerSrc)
      ARMAclient.notify(source, {'~r~Seized illegals.'})
      ARMAclient.notify(playerSrc, {'~r~Your illegals have been seized.'})
    end
end)

RegisterServerEvent("ARMA:newPanic")
AddEventHandler("ARMA:newPanic", function(a,b)
	local source = source
	local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') or ARMA.hasPermission(user_id, 'prisonguard.onduty.permission') or ARMA.hasPermission(user_id, 'nhs.onduty.permission') or ARMA.hasPermission(user_id, 'lfb.onduty.permission') then
        TriggerClientEvent("ARMA:returnPanic", -1, nil, a, b)
        tARMA.sendWebhook(getPlayerFaction(user_id)..'-panic', 'ARMA Panic Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Location: **"..a.Location.."**")
    end
end)

RegisterNetEvent("ARMA:flashbangThrown")
AddEventHandler("ARMA:flashbangThrown", function(coords)   
    TriggerClientEvent("ARMA:flashbangExplode", -1, coords)
end)

RegisterNetEvent("ARMA:updateSpotlight")
AddEventHandler("ARMA:updateSpotlight", function(a)  
  local source = source 
  TriggerClientEvent("ARMA:updateSpotlight", -1, source, a)
end)

RegisterCommand('wc', function(source, args)
  local source = source
  local user_id = ARMA.getUserId(source)
  if ARMA.hasPermission(user_id, 'police.onduty.permission') then
    ARMAclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        ARMAclient.getPoliceCallsign(source, {}, function(callsign)
          ARMAclient.getPoliceRank(source, {}, function(rank)
            ARMAclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            ARMAclient.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank.."\n~b~Name: ~w~"..GetPlayerName(source),"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('ARMA:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)

RegisterCommand('wca', function(source, args)
  local source = source
  local user_id = ARMA.getUserId(source)
  if ARMA.hasPermission(user_id, 'police.onduty.permission') then
    ARMAclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        ARMAclient.getPoliceCallsign(source, {}, function(callsign)
          ARMAclient.getPoliceRank(source, {}, function(rank)
            ARMAclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            ARMAclient.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank,"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('ARMA:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)
