
-- this module define some police tools and functions
local lang = ARMA.lang
local a = module("cfg/weapons")

-- police records

-- insert a police record for a specific user
--- line: text for one line (can be html)
function ARMA.insertPoliceRecord(user_id, line)
  if user_id ~= nil then
    ARMA.getUData(user_id, "ARMA:police_records", function(data)
      local records = data..line.."<br />"
      ARMA.setUData(user_id, "ARMA:police_records", records)
    end)
  end
end

-- Hotkey Open Police PC 1/2
function ARMA.openPolicePC(source)
  ARMA.buildMenu("police_pc", {player = source}, function(menudata)
    menudata.name = "Police PC"
    menudata.css = {top="75px",header_color="rgba(0,125,255,0.75)"}
    ARMA.openMenu(source,menudata)
  end)
end

-- Hotkey Open Police PC 2/2
function tARMA.openPolicePC()
  ARMA.openPolicePC(source)
end

-- Hotkey Open Police Menu 1/2
function ARMA.openPoliceMenu(source)
  ARMA.buildMenu("police", {player = source}, function(menudata)
    menudata.name = "Police"
    menudata.css = {top="75px",header_color="rgba(0,125,255,0.75)"}
    ARMA.openMenu(source,menudata)
  end)
end

-- Hotkey Open Police Menu 2/2
function tARMA.openPoliceMenu()
  ARMA.openPoliceMenu(source)
end

-- police PC

local menu_pc = {name=lang.police.pc.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

-- search identity by registration
local function ch_searchreg(player,choice)
  ARMA.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    ARMA.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        ARMA.getUserIdentity(user_id, function(identity)
          if identity then
            -- display identity and business
            local name = identity.name
            local firstname = identity.firstname
            local age = identity.age
            local phone = identity.phone
            local registration = identity.registration
            local bname = ""
            local bcapital = 0
            local home = ""
            local number = ""

            ARMA.getUserBusiness(user_id, function(business)
              if business then
                bname = business.name
                bcapital = business.capital
              end

              ARMA.getUserAddress(user_id, function(address)
                if address then
                  home = address.home
                  number = address.number
                end

                local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number})
                ARMAclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
              end)
            end)
          else
            ARMAclient.notify(player,{lang.common.not_found()})
          end
        end)
      else
        ARMAclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- show police records by registration
local function ch_show_police_records(player,choice)
  ARMA.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    ARMA.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        ARMA.getUData(user_id, "ARMA:police_records", function(content)
          ARMAclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
        end)
      else
        ARMAclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- delete police records by registration
local function ch_delete_police_records(player,choice)
  ARMA.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    ARMA.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        ARMA.setUData(user_id, "ARMA:police_records", "")
        ARMAclient.notify(player,{lang.police.pc.records.delete.deleted()})
      else
        ARMAclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- close business of an arrested owner
local function ch_closebusiness(player,choice)
  ARMAclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = ARMA.getUserId(nplayer)
    if nuser_id ~= nil then
      ARMA.getUserIdentity(nuser_id, function(identity)
        ARMA.getUserBusiness(nuser_id, function(business)
          if identity and business then
            ARMA.request(player,lang.police.pc.closebusiness.request({identity.name,identity.firstname,business.name}),15,function(player,ok)
              if ok then
                ARMA.closeBusiness(nuser_id)
                ARMAclient.notify(player,{lang.police.pc.closebusiness.closed()})
              end
            end)
          else
            ARMAclient.notify(player,{lang.common.no_player_near()})
          end
        end)
      end)
    else
      ARMAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end

menu_pc[lang.police.pc.searchreg.title()] = {ch_searchreg,lang.police.pc.searchreg.description()}
menu_pc[lang.police.pc.trackveh.title()] = {ch_trackveh,lang.police.pc.trackveh.description()}
menu_pc[lang.police.pc.records.show.title()] = {ch_show_police_records,lang.police.pc.records.show.description()}
menu_pc[lang.police.pc.records.delete.title()] = {ch_delete_police_records, lang.police.pc.records.delete.description()}
menu_pc[lang.police.pc.closebusiness.title()] = {ch_closebusiness,lang.police.pc.closebusiness.description()}

menu_pc.onclose = function(player) -- close pc gui
  ARMAclient.removeDiv(player,{"police_pc"})
end

local function pc_enter(source,area)
  local user_id = ARMA.getUserId(source)
  if user_id ~= nil and ARMA.hasPermission(user_id,"police.pc") then
    ARMA.openMenu(source,menu_pc)
  end
end

local function pc_leave(source,area)
  ARMA.closeMenu(source)
end

-- main menu choices

---- handcuff
local choice_handcuff = {function(player,choice)
  ARMAclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = ARMA.getUserId(nplayer)
    if nuser_id ~= nil then
      ARMAclient.toggleHandcuff(nplayer,{})
    else
      ARMAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.handcuff.description()}

---- putinveh
--[[
-- veh at position version
local choice_putinveh = {function(player,choice)
  ARMAclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = ARMA.getUserId(nplayer)
    if nuser_id ~= nil then
      ARMAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          ARMAclient.getNearestOwnedVehicle(player, {10}, function(ok,vtype,name) -- get nearest owned vehicle
            if ok then
              ARMAclient.getOwnedVehiclePosition(player, {vtype}, function(x,y,z)
                ARMAclient.putInVehiclePositionAsPassenger(nplayer,{x,y,z}) -- put player in vehicle
              end)
            else
              ARMAclient.notify(player,{lang.vehicle.no_owned_near()})
            end
          end)
        else
          ARMAclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      ARMAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.putinveh.description()}
--]]

local choice_putinveh = {function(player,choice)
  ARMAclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = ARMA.getUserId(nplayer)
    if nuser_id ~= nil then
      ARMAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          ARMAclient.putInNearestVehicleAsPassenger(nplayer, {5})
        else
          ARMAclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      ARMAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.putinveh.description()}

local choice_getoutveh = {function(player,choice)
  ARMAclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = ARMA.getUserId(nplayer)
    if nuser_id ~= nil then
      ARMAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          ARMAclient.ejectVehicle(nplayer, {})
        else
          ARMAclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      ARMAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.getoutveh.description()}

---- askid
local choice_askid = {function(player,choice)
  ARMAclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = ARMA.getUserId(nplayer)
    if nuser_id ~= nil then
      ARMAclient.notify(player,{lang.police.menu.askid.asked()})
      ARMA.request(nplayer,lang.police.menu.askid.request(),15,function(nplayer,ok)
        if ok then
          ARMA.getUserIdentity(nuser_id, function(identity)
            if identity then
              -- display identity and business
              local name = identity.name
              local firstname = identity.firstname
              local age = identity.age
              local phone = identity.phone
              local registration = identity.registration
              local bname = ""
              local bcapital = 0
              local home = ""
              local number = ""

              ARMA.getUserBusiness(nuser_id, function(business)
                if business then
                  bname = business.name
                  bcapital = business.capital
                end

                ARMA.getUserAddress(nuser_id, function(address)
                  if address then
                    home = address.home
                    number = address.number
                  end

                  local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number})
                  ARMAclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                  -- request to hide div
                  ARMA.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                    ARMAclient.removeDiv(player,{"police_identity"})
                  end)
                end)
              end)
            end
          end)
        else
          ARMAclient.notify(player,{lang.common.request_refused()})
        end
      end)
    else
      ARMAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, lang.police.menu.askid.description()}

---- police check
local choice_check = {function(player,choice)
  ARMAclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = ARMA.getUserId(nplayer)
    if nuser_id ~= nil then
      ARMAclient.notify(nplayer,{lang.police.menu.check.checked()})
      ARMAclient.getWeapons(nplayer,{},function(weapons)
        -- prepare display data (money, items, weapons)
        local money = ARMA.getMoney(nuser_id)
        local items = ""
        local data = ARMA.getUserDataTable(nuser_id)
        if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item = ARMA.items[k]
            if item then
              items = items.."<br />"..item.name.." ("..v.amount..")"
            end
          end
        end

        local weapons_info = ""
        for k,v in pairs(weapons) do
          weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
        end

        ARMAclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
        -- request to hide div
        ARMA.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
          ARMAclient.removeDiv(player,{"police_check"})
        end)
      end)
    else
      ARMAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, lang.police.menu.check.description()}

local choice_seize_weapons = {function(player, choice)
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    ARMAclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = ARMA.getUserId(nplayer)
      if nuser_id ~= nil and ARMA.hasPermission(nuser_id, "police.seizable") then
        ARMAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            ARMAclient.getWeapons(nplayer,{},function(weapons)
              for k,v in pairs(weapons) do -- display seized weapons
                -- ARMAclient.notify(player,{lang.police.menu.seize.seized({k,v.ammo})})
                -- convert weapons to parametric weapon items
                ARMA.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                if v.ammo > 0 then
                  ARMA.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
                end
              end

              -- clear all weapons
              ARMAclient.giveWeapons(nplayer,{{},true})
              ARMAclient.notify(nplayer,{lang.police.menu.seize.weapons.seized()})
            end)
          else
            ARMAclient.notify(player,{lang.police.not_handcuffed()})
          end
        end)
      else
        ARMAclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize.weapons.description()}

local isStoring = {}
local choice_store_weapons = function(player, choice)
    local user_id = ARMA.getUserId(player)
    ARMAclient.getWeapons(player,{},function(weapons)
      if not isStoring[player] then
          isStoring[player] = true
          if ARMA.getInventoryWeight(user_id) <= 25 then
            ARMAclient.giveWeapons(player,{{},true}, function(removedwep)
              for k,v in pairs(weapons) do
                if k ~= 'GADGET_PARACHUTE' and k ~= 'WEAPON_STAFFGUN' then
                  ARMA.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                  if v.ammo > 0 then
                    for i,c in pairs(a.weapons) do
                      if i == k then
                        ARMA.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                      end   
                    end
                  end
                end
              end
              ARMAclient.notify(player,{"~g~Weapons Stored"})
              TriggerEvent('ARMA:RefreshInventory', source)
              SetTimeout(3000,function()
                    isStoring[player] = nil 
              end)
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
            ARMA.giveInventoryItem(user_id, "wbody|"..k, 1, true)
            if v.ammo > 0 then
              for i,c in pairs(a.weapons) do
                if i == model then
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