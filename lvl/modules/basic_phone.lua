
-- basic phone module

local lang = LVL.lang
local cfg = module("cfg/phone")
local htmlEntities = module("lib/htmlEntities")
local services = cfg.services
local announces = cfg.announces

local sanitizes = module("cfg/sanitizes")

-- api

-- Send a service alert to all service listeners
--- sender: a player or nil (optional, if not nil, it is a call request alert)
--- service_name: service name
--- x,y,z: coordinates
--- msg: alert message
function LVL.sendServiceAlert(sender, service_name,x,y,z,msg)
  local service = services[service_name]
  local answered = false
  if service then
    local players = {}
    for k,v in pairs(LVL.rusers) do
      local player = LVL.getUserSource(tonumber(k))
      -- check user
      if LVL.hasPermission(k,service.alert_permission) and player ~= nil then
        table.insert(players,player)
      end
    end

    -- send notify and alert to all listening players
    for k,v in pairs(players) do
      LVLclient.notify(v,{service.alert_notify..msg})
      -- add position for service.time seconds
      LVLclient.addBlip(v,{x,y,z,service.blipid,service.blipcolor,"("..service_name..") "..msg}, function(bid)
        SetTimeout(service.alert_time*1000,function()
          LVLclient.removeBlip(v,{bid})
        end)
      end)

      -- call request
      if sender ~= nil then
        LVL.request(v,lang.phone.service.ask_call({service_name, htmlEntities.encode(msg)}), 30, function(v,ok)
          if ok then -- take the call
            if not answered then
              -- answer the call
              LVLclient.notify(sender,{service.answer_notify})
              LVLclient.setGPS(v,{x,y})
              answered = true
            else
              LVLclient.notify(v,{lang.phone.service.taken()})
            end
          end
        end)
      end
    end
  end
end

-- send an sms from an user to a phone number
-- cbreturn true on success
function LVL.sendSMS(user_id, phone, msg, cbr)
  local task = Task(cbr)

  if string.len(msg) > cfg.sms_size then -- clamp sms
    sms = string.sub(msg,1,cfg.sms_size)
  end

  LVL.getUserIdentity(user_id, function(identity)
    LVL.getUserByPhone(phone, function(dest_id)
      if identity and dest_id then
        local dest_src = LVL.getUserSource(dest_id)
        if dest_src then
          local phone_sms = LVL.getPhoneSMS(dest_id)

          if #phone_sms >= cfg.sms_history then -- remove last sms of the table
            table.remove(phone_sms)
          end

          local from = LVL.getPhoneDirectoryName(dest_id, identity.phone).." ("..identity.phone..")"

          LVLclient.notify(dest_src,{lang.phone.sms.notify({from, msg})})
          table.insert(phone_sms,1,{identity.phone,msg}) -- insert new sms at first position {phone,message}
          task({true})
        else
          task()
        end
      else
        task()
      end
    end)
  end)
end

-- send an smspos from an user to a phone number
-- cbreturn true on success
function LVL.sendSMSPos(user_id, phone, x,y,z, cbr)
  local task = Task(cbr)

  LVL.getUserIdentity(user_id, function(identity)
    LVL.getUserByPhone(phone, function(dest_id)
      if identity and dest_id then
        local dest_src = LVL.getUserSource(dest_id)
        if dest_src then
          local from = LVL.getPhoneDirectoryName(dest_id, identity.phone).." ("..identity.phone..")"
          LVLclient.notify(dest_src,{lang.phone.smspos.notify({from})}) -- notify
          -- add position for 5 minutes
          LVLclient.addBlip(dest_src,{x,y,z,162,37,from}, function(bid)
            SetTimeout(cfg.smspos_duration*1000,function()
              LVLclient.removeBlip(dest_src,{bid})
            end)
          end)

          task({true})
        else
          task()
        end
      else
        task()
      end
    end)
  end)
end

-- get phone directory data table
function LVL.getPhoneDirectory(user_id)
  local data = LVL.getUserDataTable(user_id)
  if data then
    if data.phone_directory == nil then
      data.phone_directory = {}
    end

    return data.phone_directory
  else
    return {}
  end
end

-- get directory name by number for a specific user
function LVL.getPhoneDirectoryName(user_id, phone)
  local directory = LVL.getPhoneDirectory(user_id)
  for k,v in pairs(directory) do
    if v == phone then
      return k
    end
  end

  return "unknown"
end
-- get phone sms tmp table
function LVL.getPhoneSMS(user_id)
  local data = LVL.getUserTmpTable(user_id)
  if data then
    if data.phone_sms == nil then
      data.phone_sms = {}
    end

    return data.phone_sms
  else
    return {}
  end
end

-- build phone menu
local phone_menu = {name=lang.phone.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

local function ch_directory(player,choice)
  local user_id = LVL.getUserId(player)
  if user_id ~= nil then
    local phone_directory = LVL.getPhoneDirectory(user_id)
    -- build directory menu
    local menu = {name=choice,css={top="75px",header_color="rgba(0,125,255,0.75)"}}

    local ch_add = function(player, choice) -- add to directory
      LVL.prompt(player,lang.phone.directory.add.prompt_number(),"",function(player,phone)
        LVL.prompt(player,lang.phone.directory.add.prompt_name(),"",function(player,name)
          name = sanitizeString(tostring(name),sanitizes.text[1],sanitizes.text[2])
          phone = sanitizeString(tostring(phone),sanitizes.text[1],sanitizes.text[2])
          if #name > 0 and #phone > 0 then
            phone_directory[name] = phone -- set entry
            LVLclient.notify(player, {lang.phone.directory.add.added()})
          else
            LVLclient.notify(player, {lang.common.invalid_value()})
          end
        end)
      end)
    end

    local ch_entry = function(player, choice) -- directory entry menu
      -- build entry menu
      local emenu = {name=choice,css={top="75px",header_color="rgba(0,125,255,0.75)"}}

      local name = choice
      local phone = phone_directory[name] or ""

      local ch_remove = function(player, choice) -- remove directory entry
        phone_directory[name] = nil
        LVL.closeMenu(player) -- close entry menu (removed)
      end

      local ch_sendsms = function(player, choice) -- send sms to directory entry
        LVL.prompt(player,lang.phone.directory.sendsms.prompt({cfg.sms_size}),"",function(player,msg)
          msg = sanitizeString(msg,sanitizes.text[1],sanitizes.text[2])
          LVL.sendSMS(user_id, phone, msg, function(ok)
            if ok then
              LVLclient.notify(player,{lang.phone.directory.sendsms.sent({phone})})
            else
              LVLclient.notify(player,{lang.phone.directory.sendsms.not_sent({phone})})
            end
          end)
        end)
      end

      local ch_sendpos = function(player, choice) -- send current position to directory entry
        LVLclient.getPosition(player,{},function(x,y,z)
          LVL.sendSMSPos(user_id, phone, x,y,z,function(ok)
            if ok then
              LVLclient.notify(player,{lang.phone.directory.sendsms.sent({phone})})
            else
              LVLclient.notify(player,{lang.phone.directory.sendsms.not_sent({phone})})
            end
          end)
        end)
      end

      emenu[lang.phone.directory.sendsms.title()] = {ch_sendsms}
      emenu[lang.phone.directory.sendpos.title()] = {ch_sendpos}
      emenu[lang.phone.directory.remove.title()] = {ch_remove}

      -- nest menu to directory
      emenu.onclose = function() ch_directory(player,lang.phone.directory.title()) end

      -- open mnu
      LVL.openMenu(player, emenu)
    end

    menu[lang.phone.directory.add.title()] = {ch_add}

    for k,v in pairs(phone_directory) do -- add directory entries (name -> number)
      menu[k] = {ch_entry,v}
    end

    -- nest directory menu to phone (can't for now)
    -- menu.onclose = function(player) LVL.openMenu(player, phone_menu) end

    -- open menu
    LVL.openMenu(player,menu)
  end
end

local function ch_sms(player, choice)
  local user_id = LVL.getUserId(player)
  if user_id ~= nil then
    local phone_sms = LVL.getPhoneSMS(user_id)

    -- build sms list
    local menu = {name=choice,css={top="75px",header_color="rgba(0,125,255,0.75)"}}

    -- add sms
    for k,v in pairs(phone_sms) do
      local from = LVL.getPhoneDirectoryName(user_id, v[1]).." ("..v[1]..")"
      local phone = v[1]
      menu["#"..k.." "..from] = {function(player,choice)
        -- answer to sms
        LVL.prompt(player,lang.phone.directory.sendsms.prompt({cfg.sms_size}),"",function(player,msg)
          msg = sanitizeString(msg,sanitizes.text[1],sanitizes.text[2])
          LVL.sendSMS(user_id, phone, msg, function(ok)
            if ok then
              LVLclient.notify(player,{lang.phone.directory.sendsms.sent({phone})})
            else
              LVLclient.notify(player,{lang.phone.directory.sendsms.not_sent({phone})})
            end
          end)
        end)
      end, lang.phone.sms.info({from,htmlEntities.encode(v[2])})}
    end

    -- nest menu
    menu.onclose = function(player) LVL.openMenu(player, phone_menu) end

    -- open menu
    LVL.openMenu(player,menu)
  end
end

-- build service menu
local service_menu = {name=lang.phone.service.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

-- nest menu
service_menu.onclose = function(player) LVL.openMenu(player, phone_menu) end

local function ch_service_alert(player,choice) -- alert a service
  local service = services[choice]
  if service then
    LVLclient.getPosition(player,{},function(x,y,z)
      LVL.prompt(player,lang.phone.service.prompt(),"",function(player, msg)
			  msg = sanitizeString(msg,sanitizes.text[1],sanitizes.text[2])
	  	  if msg ~= nil and msg ~= "" then
			    LVLclient.notify(player,{service.notify}) -- notify player
			    LVL.sendServiceAlert(player,choice,x,y,z,msg) -- send service alert (call request)
		    else
			    LVLclient.notify(player,{"Empty Message."})
	      end
      end)
    end)
  end
end

for k,v in pairs(services) do
  service_menu[k] = {ch_service_alert}
end

local function ch_service(player, choice)
  LVL.openMenu(player,service_menu)
end

-- build announce menu
local announce_menu = {name=lang.phone.announce.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

-- nest menu
announce_menu.onclose = function(player) LVL.openMenu(player, phone_menu) end

local function ch_announce_alert(player,choice) -- alert a announce
  local announce = announces[choice]
  local user_id = LVL.getUserId(player)
  if announce and user_id ~= nil then
    if announce.permission == nil or LVL.hasPermission(user_id,announce.permission) then
      LVL.prompt(player,lang.phone.announce.prompt(),"",function(player, msg)
        msg = sanitizeString(msg,sanitizes.text[1],sanitizes.text[2])
        if string.len(msg) > 10 and string.len(msg) < 1000 then
          if announce.price <= 0 or LVL.tryPayment(user_id, announce.price) then -- try to pay the announce
            LVLclient.notify(player, {lang.money.paid({announce.price})})

            msg = htmlEntities.encode(msg)
            msg = string.gsub(msg, "\n", "<br />") -- allow returns

            -- send announce to all
            local users = LVL.getUsers()
            for k,v in pairs(users) do
              LVLclient.announce(v,{announce.image,msg})
            end
          else
            LVLclient.notify(player, {lang.money.not_enough()})
          end
        else
          LVLclient.notify(player, {lang.common.invalid_value()})
        end
      end)
    else
      LVLclient.notify(player, {lang.common.not_allowed()})
    end
  end
end

for k,v in pairs(announces) do
  announce_menu[k] = {ch_announce_alert,lang.phone.announce.item_desc({v.price,v.description or ""})}
end





