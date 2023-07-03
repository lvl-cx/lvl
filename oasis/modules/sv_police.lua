
-- this module define some police tools and functions
local lang = OASIS.lang
local a = module("oasis-weapons", "cfg/weapons")

local isStoring = {}
local choice_store_weapons = function(player, choice)
    local user_id = OASIS.getUserId(player)
    local data = OASIS.getUserDataTable(user_id)
    OASISclient.getWeapons(player,{},function(weapons)
      if not isStoring[player] then
        tOASIS.getSubscriptions(user_id, function(cb, plushours, plathours)
          if cb then
            local maxWeight = 30
            if plathours > 0 then
              maxWeight = 50
            elseif plushours > 0 then
              maxWeight = 40
            end
            if OASIS.getInventoryWeight(user_id) <= maxWeight then
              isStoring[player] = true
              OASISclient.giveWeapons(player,{{},true}, function(removedwep)
                for k,v in pairs(weapons) do
                  if k ~= 'GADGET_PARACHUTE' and k ~= 'WEAPON_STAFFGUN' and k~= 'WEAPON_SMOKEGRENADE' and k~= 'WEAPON_FLASHBANG' then
                    OASIS.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                    if v.ammo > 0 and k ~= 'WEAPON_STUNGUN' then
                      for i,c in pairs(a.weapons) do
                        if i == k and c.class ~= 'Melee' then
                          if v.ammo > 250 then
                            v.ammo = 250
                          end
                          OASIS.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                        end   
                      end
                    end
                  end
                end
                OASISclient.notify(player,{"~g~Weapons Stored"})
                TriggerEvent('OASIS:RefreshInventory', player)
                OASISclient.ClearWeapons(player,{})
                data.weapons = {}
                SetTimeout(3000,function()
                    isStoring[player] = nil 
                end)
              end)
            else
              OASISclient.notify(player,{'~r~You do not have enough Weight to store Weapons.'})
            end
          end
        end)
      end 
    end)
end

RegisterServerEvent("OASIS:forceStoreSingleWeapon")
AddEventHandler("OASIS:forceStoreSingleWeapon",function(model)
    local source = source
    local user_id = OASIS.getUserId(source)
    if model ~= nil then
      OASISclient.getWeapons(source,{},function(weapons)
        for k,v in pairs(weapons) do
          if k == model then
            local new_weight = OASIS.getInventoryWeight(user_id)+OASIS.getItemWeight(model)
            if new_weight <= OASIS.getInventoryMaxWeight(user_id) then
              RemoveWeaponFromPed(GetPlayerPed(source), k)
              OASISclient.removeWeapon(source,{k})
              OASIS.giveInventoryItem(user_id, "wbody|"..k, 1, true)
              if v.ammo > 0 then
                for i,c in pairs(a.weapons) do
                  if i == model and c.class ~= 'Melee' then
                    OASIS.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                  end   
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
  local user_id = OASIS.getUserId(source)
  if OASIS.hasPermission(user_id, 'police.onduty.permission') then
    TriggerClientEvent('OASIS:toggleShieldMenu', source)
  end
end)

RegisterCommand('cuff', function(source, args)
  local source = source
  local user_id = OASIS.getUserId(source)
  OASISclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      OASISclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and OASIS.hasPermission(user_id, 'admin.tickets')) or OASIS.hasPermission(user_id, 'police.onduty.permission') then
          OASISclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = OASIS.getUserId(nplayer)
              if (not OASIS.hasPermission(nplayer_id, 'police.onduty.permission') or OASIS.hasPermission(nplayer_id, 'police.undercover')) then
                OASISclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('OASIS:uncuffAnim', source, nplayer, false)
                    TriggerClientEvent('OASIS:unHandcuff', source, false)
                  else
                    TriggerClientEvent('OASIS:arrestCriminal', nplayer, source)
                    TriggerClientEvent('OASIS:arrestFromPolice', source)
                  end
                  TriggerClientEvent('OASIS:toggleHandcuffs', nplayer, false)
                  TriggerClientEvent('OASIS:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              OASISclient.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

RegisterCommand('frontcuff', function(source, args)
  local source = source
  local user_id = OASIS.getUserId(source)
  OASISclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      OASISclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and OASIS.hasPermission(user_id, 'admin.tickets')) or OASIS.hasPermission(user_id, 'police.onduty.permission') then
          OASISclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = OASIS.getUserId(nplayer)
              if (not OASIS.hasPermission(nplayer_id, 'police.onduty.permission') or OASIS.hasPermission(nplayer_id, 'police.undercover')) then
                OASISclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('OASIS:uncuffAnim', source, nplayer, true)
                    TriggerClientEvent('OASIS:unHandcuff', source, true)
                  else
                    TriggerClientEvent('OASIS:arrestCriminal', nplayer, source)
                    TriggerClientEvent('OASIS:arrestFromPolice', source)
                  end
                  TriggerClientEvent('OASIS:toggleHandcuffs', nplayer, true)
                  TriggerClientEvent('OASIS:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              OASISclient.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

function OASIS.handcuffKeys(source)
  local source = source
  local user_id = OASIS.getUserId(source)
  if OASIS.getInventoryItemAmount(user_id, 'handcuffkeys') >= 1 then
    OASISclient.getNearestPlayer(source,{5},function(nplayer)
      if nplayer ~= nil then
        local nplayer_id = OASIS.getUserId(nplayer)
        OASISclient.isHandcuffed(nplayer,{},function(handcuffed)
          if handcuffed then
            OASIS.tryGetInventoryItem(user_id, 'handcuffkeys', 1)
            TriggerClientEvent('OASIS:uncuffAnim', source, nplayer, false)
            TriggerClientEvent('OASIS:unHandcuff', source, false)
            TriggerClientEvent('OASIS:toggleHandcuffs', nplayer, false)
            TriggerClientEvent('OASIS:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
          end
        end)
      else
        OASISclient.notify(source,{lang.common.no_player_near()})
      end
    end)
  end
end

local section60s = {}
RegisterCommand('s60', function(source, args)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.announce') then
        if args[1] ~= nil and args[2] ~= nil then
            local radius = tonumber(args[1])
            local duration = tonumber(args[2])*60
            local section60UUID = #section60s+1
            section60s[section60UUID] = {radius = radius, duration = duration, uuid = section60UUID}
            TriggerClientEvent("OASIS:addS60", -1, GetEntityCoords(GetPlayerPed(source)), radius, section60UUID)
        else
            OASISclient.notify(source,{'~r~Invalid Arguments.'})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(section60s) do
            if section60s[k].duration > 0 then
                section60s[k].duration = section60s[k].duration-1 
            else
                TriggerClientEvent('OASIS:removeS60', -1, section60s[k].uuid)
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterCommand('handbook', function(source, args)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') then
      TriggerClientEvent('OASIS:toggleHandbook', source)
    end
end)

local draggingPlayers = {}

RegisterServerEvent('OASIS:dragPlayer')
AddEventHandler('OASIS:dragPlayer', function(playersrc)
    local source = source
    local user_id = OASIS.getUserId(source)
    if user_id ~= nil and (OASIS.hasPermission(user_id, "police.onduty.permission") or OASIS.hasPermission(user_id, "prisonguard.onduty.permission")) then
      if playersrc ~= nil then
        local nuser_id = OASIS.getUserId(playersrc)
          if nuser_id ~= nil then
            OASISclient.isHandcuffed(playersrc,{},function(handcuffed)
                if handcuffed then
                    if draggingPlayers[user_id] then
                      TriggerClientEvent("OASIS:undrag", playersrc, source)
                      draggingPlayers[user_id] = nil
                    else
                      TriggerClientEvent("OASIS:drag", playersrc, source)
                      draggingPlayers[user_id] = playersrc
                    end
                else
                    OASISclient.notify(source,{"~r~Player is not handcuffed."})
                end
            end)
          else
              OASISclient.notify(source,{"~r~There is no player nearby"})
          end
      else
          OASISclient.notify(source,{"~r~There is no player nearby"})
      end
    end
end)

RegisterServerEvent('OASIS:putInVehicle')
AddEventHandler('OASIS:putInVehicle', function(playersrc)
    local source = source
    local user_id = OASIS.getUserId(source)
    if user_id ~= nil and OASIS.hasPermission(user_id, "police.onduty.permission") then
      if playersrc ~= nil then
        OASISclient.isHandcuffed(playersrc,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            OASISclient.putInNearestVehicleAsPassenger(playersrc, {10})
          else
            OASISclient.notify(source,{lang.police.not_handcuffed()})
          end
        end)
      end
    end
end)

RegisterServerEvent('OASIS:ejectFromVehicle')
AddEventHandler('OASIS:ejectFromVehicle', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if user_id ~= nil and OASIS.hasPermission(user_id, "police.onduty.permission") then
      OASISclient.getNearestPlayer(source,{10},function(nplayer)
        local nuser_id = OASIS.getUserId(nplayer)
        if nuser_id ~= nil then
          OASISclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
            if handcuffed then
              OASISclient.ejectVehicle(nplayer, {})
            else
              OASISclient.notify(source,{lang.police.not_handcuffed()})
            end
          end)
        else
          OASISclient.notify(source,{lang.common.no_player_near()})
        end
      end)
    end
end)


RegisterServerEvent("OASIS:Knockout")
AddEventHandler('OASIS:Knockout', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    OASISclient.getNearestPlayer(source, {2}, function(nplayer)
        local nuser_id = OASIS.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('OASIS:knockOut', nplayer)
            SetTimeout(30000, function()
                TriggerClientEvent('OASIS:knockOutDisable', nplayer)
            end)
        end
    end)
end)

RegisterServerEvent("OASIS:KnockoutNoAnim")
AddEventHandler('OASIS:KnockoutNoAnim', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasGroup(user_id, 'Founder') then
      OASISclient.getNearestPlayer(source, {2}, function(nplayer)
          local nuser_id = OASIS.getUserId(nplayer)
          if nuser_id ~= nil then
              TriggerClientEvent('OASIS:knockOut', nplayer)
              SetTimeout(30000, function()
                  TriggerClientEvent('OASIS:knockOutDisable', nplayer)
              end)
          end
      end)
    end
end)

RegisterServerEvent("OASIS:requestPlaceBagOnHead")
AddEventHandler('OASIS:requestPlaceBagOnHead', function()
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.getInventoryItemAmount(user_id, 'Headbag') >= 1 then
      OASISclient.getNearestPlayer(source, {10}, function(nplayer)
          local nuser_id = OASIS.getUserId(nplayer)
          if nuser_id ~= nil then
              OASIS.tryGetInventoryItem(user_id, 'Headbag', 1, true)
              TriggerClientEvent('OASIS:placeHeadBag', nplayer)
          end
      end)
    end
end)

RegisterServerEvent('OASIS:gunshotTest')
AddEventHandler('OASIS:gunshotTest', function(playersrc)
    local source = source
    local user_id = OASIS.getUserId(source)
    if user_id ~= nil and OASIS.hasPermission(user_id, "police.onduty.permission") then
      if playersrc ~= nil then
        OASISclient.hasRecentlyShotGun(playersrc,{}, function(shotagun)
          if shotagun then
            OASISclient.notify(source, {"~r~Player has recently shot a gun."})
          else
            OASISclient.notify(source, {"~r~Player has no gunshot residue on fingers."})
          end
        end)
      end
    end
end)

RegisterServerEvent('OASIS:tryTackle')
AddEventHandler('OASIS:tryTackle', function(id)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') or OASIS.hasPermission(user_id, 'prisonguard.onduty.permission') or OASIS.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent('OASIS:playTackle', source)
        TriggerClientEvent('OASIS:getTackled', id, source)
    end
end)

RegisterCommand('drone', function(source, args)
  local source = source
  local user_id = OASIS.getUserId(source)
  if OASIS.hasGroup(user_id, 'Drone Trained') then
      TriggerClientEvent('toggleDrone', source)
  end
end)

RegisterCommand('trafficmenu', function(source, args)
  local source = source
  local user_id = OASIS.getUserId(source)
  if OASIS.hasPermission(user_id, 'police.onduty.permission') or OASIS.hasPermission(user_id, 'prisonguard.onduty.permission') then
      TriggerClientEvent('OASIS:toggleTrafficMenu', source)
  end
end)

RegisterServerEvent('OASIS:startThrowSmokeGrenade')
AddEventHandler('OASIS:startThrowSmokeGrenade', function(name)
    local source = source
    TriggerClientEvent('OASIS:displaySmokeGrenade', -1, name, GetEntityCoords(GetPlayerPed(source)))
end)

RegisterCommand('breathalyse', function(source, args)
  local source = source
  local user_id = OASIS.getUserId(source)
  if OASIS.hasPermission(user_id, 'police.onduty.permission') then
      TriggerClientEvent('OASIS:breathalyserCommand', source)
  end
end)

RegisterServerEvent('OASIS:breathalyserRequest')
AddEventHandler('OASIS:breathalyserRequest', function(temp)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') then
      TriggerClientEvent('OASIS:beingBreathalysed', temp)
      TriggerClientEvent('OASIS:breathTestResult', source, math.random(0, 100), GetPlayerName(temp))
    end
end)

seizeBullets = {
  ['9mm Bullets'] = true,
  ['7.62mm Bullets'] = true,
  ['.357 Bullets'] = true,
  ['12 Gauge Bullets'] = true,
  ['.308 Sniper Rounds'] = true,
  ['5.56mm NATO'] = true,
}

RegisterServerEvent('OASIS:seizeWeapons')
AddEventHandler('OASIS:seizeWeapons', function(playerSrc)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') then
      OASISclient.isHandcuffed(playerSrc,{},function(handcuffed)
        if handcuffed then
          RemoveAllPedWeapons(GetPlayerPed(playerSrc), true)
          local player_id = OASIS.getUserId(playerSrc)
          local cdata = OASIS.getUserDataTable(player_id)
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
          TriggerEvent('OASIS:RefreshInventory', playerSrc)
          OASISclient.notify(source, {'~r~Seized weapons.'})
          OASISclient.notify(playerSrc, {'~r~Your weapons have been seized.'})
        end
      end)
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
RegisterServerEvent('OASIS:seizeIllegals')
AddEventHandler('OASIS:seizeIllegals', function(playerSrc)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') then
      local player_id = OASIS.getUserId(playerSrc)
      local cdata = OASIS.getUserDataTable(player_id)
      for a,b in pairs(cdata.inventory) do
          for c,d in pairs(seizeDrugs) do
              if a == c then
                cdata.inventory[a] = nil
              end
          end
      end
      TriggerEvent('OASIS:RefreshInventory', playerSrc)
      OASISclient.notify(source, {'~r~Seized illegals.'})
      OASISclient.notify(playerSrc, {'~r~Your illegals have been seized.'})
    end
end)

RegisterServerEvent("OASIS:newPanic")
AddEventHandler("OASIS:newPanic", function(a,b)
	local source = source
	local user_id = OASIS.getUserId(source)
    if OASIS.hasPermission(user_id, 'police.onduty.permission') or OASIS.hasPermission(user_id, 'prisonguard.onduty.permission') or OASIS.hasPermission(user_id, 'nhs.onduty.permission') or OASIS.hasPermission(user_id, 'lfb.onduty.permission') then
        TriggerClientEvent("OASIS:returnPanic", -1, nil, a, b)
        tOASIS.sendWebhook(getPlayerFaction(user_id)..'-panic', 'OASIS Panic Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Location: **"..a.Location.."**")
    end
end)

RegisterNetEvent("OASIS:flashbangThrown")
AddEventHandler("OASIS:flashbangThrown", function(coords)   
    TriggerClientEvent("OASIS:flashbangExplode", -1, coords)
end)

RegisterNetEvent("OASIS:updateSpotlight")
AddEventHandler("OASIS:updateSpotlight", function(a)  
  local source = source 
  TriggerClientEvent("OASIS:updateSpotlight", -1, source, a)
end)

RegisterCommand('wc', function(source, args)
  local source = source
  local user_id = OASIS.getUserId(source)
  if OASIS.hasPermission(user_id, 'police.onduty.permission') then
    OASISclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        OASISclient.getPoliceCallsign(source, {}, function(callsign)
          OASISclient.getPoliceRank(source, {}, function(rank)
            OASISclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            OASISclient.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank.."\n~b~Name: ~w~"..GetPlayerName(source),"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('OASIS:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)

RegisterCommand('wca', function(source, args)
  local source = source
  local user_id = OASIS.getUserId(source)
  if OASIS.hasPermission(user_id, 'police.onduty.permission') then
    OASISclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        OASISclient.getPoliceCallsign(source, {}, function(callsign)
          OASISclient.getPoliceRank(source, {}, function(rank)
            OASISclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            OASISclient.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank,"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('OASIS:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)
