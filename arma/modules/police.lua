
-- this module define some police tools and functions
local lang = ARMA.lang
local cfg = module("cfg/police")

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

-- track vehicle
local function ch_trackveh(player,choice)
  ARMA.prompt(player,lang.police.pc.trackveh.prompt_reg(),"",function(player, reg) -- ask reg
    ARMA.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        ARMA.prompt(player,lang.police.pc.trackveh.prompt_note(),"",function(player, note) -- ask note
          -- begin veh tracking
          ARMAclient.notify(player,{lang.police.pc.trackveh.tracking()})
          local seconds = math.random(cfg.trackveh.min_time,cfg.trackveh.max_time)
          SetTimeout(seconds*1000,function()
            local tplayer = ARMA.getUserSource(user_id)
            if tplayer ~= nil then
              ARMAclient.getAnyOwnedVehiclePosition(tplayer,{},function(ok,x,y,z)
                if ok then -- track success
                  ARMA.sendServiceAlert(nil, cfg.trackveh.service,x,y,z,lang.police.pc.trackveh.tracked({reg,note}))
                else
                  ARMAclient.notify(player,{lang.police.pc.trackveh.track_failed({reg,note})}) -- failed
                end
              end)
            else
              ARMAclient.notify(player,{lang.police.pc.trackveh.track_failed({reg,note})}) -- failed
            end
          end)
        end)
      else
        ARMAclient.notify(player,{lang.common.not_found()})
      end
    end)
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

local choice_seize_items = {function(player, choice)
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    ARMAclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = ARMA.getUserId(nplayer)
      if nuser_id ~= nil and ARMA.hasPermission(nuser_id, "police.seizable") then
        ARMAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            for k,v in pairs(cfg.seizable_items) do -- transfer seizable items
              local amount = ARMA.getInventoryItemAmount(nuser_id,v)
              if amount > 0 then
                local item = ARMA.items[v]
                if item then -- do transfer
                  if ARMA.tryGetInventoryItem(nuser_id,v,amount,true) then
                    ARMA.giveInventoryItem(user_id,v,amount,false)
                    ARMAclient.notify(player,{lang.police.menu.seize.seized({item.name,amount})})
                  end
                end
              end
            end

            ARMAclient.notify(nplayer,{lang.police.menu.seize.items.seized()})
          else
            ARMAclient.notify(player,{lang.police.not_handcuffed()})
          end
        end)
      else
        ARMAclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize.items.description()}

-- toggle jail nearest player
local choice_jail = {function(player, choice)
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    ARMAclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = ARMA.getUserId(nplayer)
      if nuser_id ~= nil then
        ARMAclient.isJailed(nplayer, {}, function(jailed)
          if jailed then -- unjail
            ARMAclient.unjail(nplayer, {})
            ARMAclient.notify(nplayer,{lang.police.menu.jail.notify_unjailed()})
            ARMAclient.notify(player,{lang.police.menu.jail.unjailed()})
          else -- find the nearest jail
            ARMAclient.getPosition(nplayer,{},function(x,y,z)
              local d_min = 1000
              local v_min = nil
              for k,v in pairs(cfg.jails) do
                local dx,dy,dz = x-v[1],y-v[2],z-v[3]
                local dist = math.sqrt(dx*dx+dy*dy+dz*dz)

                if dist <= d_min and dist <= 15 then -- limit the research to 15 meters
                  d_min = dist
                  v_min = v
                end

                -- jail
                if v_min then
                  ARMAclient.jail(nplayer,{v_min[1],v_min[2],v_min[3],v_min[4]})
                  ARMAclient.notify(nplayer,{lang.police.menu.jail.notify_jailed()})
                  ARMAclient.notify(player,{lang.police.menu.jail.jailed()})
                else
                  ARMAclient.notify(player,{lang.police.menu.jail.not_found()})
                end
              end
            end)
          end
        end)
      else
        ARMAclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.jail.description()}

local choice_fine = {function(player, choice)
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    ARMAclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = ARMA.getUserId(nplayer)
      if nuser_id ~= nil then
        local money = ARMA.getMoney(nuser_id)+ARMA.getBankMoney(nuser_id)

        -- build fine menu
        local menu = {name=lang.police.menu.fine.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

        local choose = function(player,choice) -- fine action
          local amount = cfg.fines[choice]
          if amount ~= nil then
            if ARMA.tryFullPayment(nuser_id, amount) then
              ARMA.insertPoliceRecord(nuser_id, lang.police.menu.fine.record({choice,amount}))
              ARMAclient.notify(player,{lang.police.menu.fine.fined({choice,amount})})
              ARMAclient.notify(nplayer,{lang.police.menu.fine.notify_fined({choice,amount})})
              ARMA.closeMenu(player)
            else
              ARMAclient.notify(player,{lang.money.not_enough()})
            end
          end
        end

        for k,v in pairs(cfg.fines) do -- add fines in function of money available
          if v <= money then
            menu[k] = {choose,v}
          end
        end

        -- open menu
        ARMA.openMenu(player, menu)
      else
        ARMAclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.fine.description()}

local isStoring = {}
local choice_store_weapons = {function(player, choice)
    local user_id = ARMA.getUserId(player)
	ARMAclient.getWeapons(player,{},function(weapons)
        if not isStoring[player] then
            isStoring[player] = true
            ARMAclient.giveWeapons(player,{{},true}, function(removedwep)
                for k,v in pairs(weapons) do
                    ARMA.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                    if v.ammo > 0 then
                        ARMA.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
                    end
                end
                ARMAclient.notify(player,{"~g~Weapons Stored"})
                SetTimeout(10000,function()
                    isStoring[player] = nil 
                end)
            end)
        else
            ARMAclient.notify(player,{"~o~You are already storing the weapons"})
        end
	end)
end, lang.police.menu.store_weapons.description()}


-- WANTED SYNC

local wantedarma_players = {}

function ARMA.getUserWantedLevel(user_id)
  return wantedarma_players[user_id] or 0
end

-- receive wanted level
function tARMA.updateWantedLevel(level)
  local player = source
  local user_id = ARMA.getUserId(player)
  if user_id ~= nil then
    local was_wanted = (ARMA.getUserWantedLevel(user_id) > 0)
    wantedarma_players[user_id] = level
    local is_wanted = (level > 0)

    -- send wanted to listening service
    if not was_wanted and is_wanted then
      ARMAclient.getPosition(player, {}, function(x,y,z)
        ARMA.sendServiceAlert(nil, cfg.wanted.service,x,y,z,lang.police.wanted({level}))
      end)
    end

    if was_wanted and not is_wanted then
      ARMAclient.removeNamedBlip(-1, {"ARMA:wanted:"..user_id}) -- remove wanted blip (all to prevent phantom blip)
    end
  end
end

-- delete wanted entry on leave
AddEventHandler("ARMA:playerLeave", function(user_id, player)
  wantedarma_players[user_id] = nil
  ARMAclient.removeNamedBlip(-1, {"ARMA:wanted:"..user_id})  -- remove wanted blip (all to prevent phantom blip)
end)

-- display wanted positions
local function task_wanted_positions()
  local listeners = ARMA.getUsersByPermission("police.wanted")
  for k,v in pairs(wantedarma_players) do -- each wanted player
    local player = ARMA.getUserSource(tonumber(k))
    if player ~= nil and v ~= nil and v > 0 then
      ARMAclient.getPosition(player, {}, function(x,y,z)
        for l,w in pairs(listeners) do -- each listening player
          local lplayer = ARMA.getUserSource(w)
          if lplayer ~= nil then
            ARMAclient.setNamedBlip(lplayer, {"ARMA:wanted:"..k,x,y,z,cfg.wanted.blipid,cfg.wanted.blipcolor,lang.police.wanted({v})})
          end
        end
      end)
    end
  end

  SetTimeout(5000, task_wanted_positions)
end
task_wanted_positions()

local isStoring = {}
local choice_store_weapons = function(player, choice)
    local user_id = ARMA.getUserId(player)
    ARMAclient.getWeapons(player,{},function(weapons)
      if not isStoring[player] then
            isStoring[player] = true
            if ARMA.getInventoryWeight(user_id) <= 25 then
              ARMAclient.giveWeapons(player,{{},true}, function(removedwep)

                    for k,v in pairs(weapons) do
                        ARMA.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                        if v.ammo > 0 then
                          for i,c in pairs(ARMAAmmoTypes) do
                            for a,d in pairs(c) do
                                if d == k then  

                                    ARMA.giveInventoryItem(user_id, i, v.ammo, true)
                            
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

RegisterCommand('storeweapons', function(source)
  choice_store_weapons(source)
end)
