local htmlEntities = module("lib/htmlEntities")

local cfg = module("cfg/identity")
local lang = LVL.lang

local sanitizes = module("cfg/sanitizes")

-- this module describe the identity system

-- init sql


MySQL.createCommand("LVL/get_user_identity","SELECT * FROM lvl_user_identities WHERE user_id = @user_id")
MySQL.createCommand("LVL/init_user_identity","INSERT IGNORE INTO lvl_user_identities(user_id,registration,phone,firstname,name,age) VALUES(@user_id,@registration,@phone,@firstname,@name,@age)")
MySQL.createCommand("LVL/update_user_identity","UPDATE lvl_user_identities SET firstname = @firstname, name = @name, age = @age, registration = @registration, phone = @phone WHERE user_id = @user_id")
MySQL.createCommand("LVL/get_userbyreg","SELECT user_id FROM lvl_user_identities WHERE registration = @registration")
MySQL.createCommand("LVL/get_userbyphone","SELECT user_id FROM lvl_user_identities WHERE phone = @phone")



-- api

-- cbreturn user identity
function LVL.getUserIdentity(user_id, cbr)
    local task = Task(cbr)
    if cbr then 
        MySQL.query("LVL/get_user_identity", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then 
              task({rows[1]})
            else 
               task({})
            end
        end)
    else 
        print('Mis usage detected! CBR Does not exist')
    end
end

-- cbreturn user_id by registration or nil
function LVL.getUserByRegistration(registration, cbr)
  local task = Task(cbr)

  MySQL.query("LVL/get_userbyreg", {registration = registration or ""}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].user_id})
    else
      task()
    end
  end)
end

-- cbreturn user_id by phone or nil
function LVL.getUserByPhone(phone, cbr)
  local task = Task(cbr)

  MySQL.query("LVL/get_userbyphone", {phone = phone or ""}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].user_id})
    else
      task()
    end
  end)
end

function LVL.generateStringNumber(format) -- (ex: DDDLLL, D => digit, L => letter)
  local abyte = string.byte("A")
  local zbyte = string.byte("0")

  local number = ""
  for i=1,#format do
    local char = string.sub(format, i,i)
    if char == "D" then number = number..string.char(zbyte+math.random(0,9))
    elseif char == "L" then number = number..string.char(abyte+math.random(0,25))
    else number = number..char end
  end

  return number
end

-- cbreturn a unique registration number
function LVL.generateRegistrationNumber(cbr)
  local task = Task(cbr)

  local function search()
    -- generate registration number
    local registration = LVL.generateStringNumber("DDDLLL")
    LVL.getUserByRegistration(registration, function(user_id)
      if user_id ~= nil then
        search() -- continue generation
      else
        task({registration})
      end
    end)
  end

  search()
end

-- cbreturn a unique phone number (0DDDDD, D => digit)
function LVL.generatePhoneNumber(cbr)
  local task = Task(cbr)

  local function search()
    -- generate phone number
    local phone = LVL.generateStringNumber(cfg.phone_format)
    LVL.getUserByPhone(phone, function(user_id)
      if user_id ~= nil then
        search() -- continue generation
      else
        task({phone})
      end
    end)
  end

  search()
end

-- events, init user identity at connection
AddEventHandler("LVL:playerJoin",function(user_id,source,name,last_login)
  LVL.getUserIdentity(user_id, function(identity)
    if identity == nil then
      LVL.generateRegistrationNumber(function(registration)
        LVL.generatePhoneNumber(function(phone)
          MySQL.execute("LVL/init_user_identity", {
            user_id = user_id,
            registration = registration,
            phone = phone,
            firstname = cfg.random_first_names[math.random(1,#cfg.random_first_names)],
            name = cfg.random_last_names[math.random(1,#cfg.random_last_names)],
            age = math.random(25,40)
          })
        end)
      end)
    end
  end)
end)

-- city hall menu

local cityhall_menu = {name=lang.cityhall.title(),css={top="75px", header_color="rgba(0,125,255,0.75)"}}

local function ch_identity(player,choice)
  local user_id = LVL.getUserId(player)
  if user_id ~= nil then
    LVL.prompt(player,lang.cityhall.identity.prompt_firstname(),"",function(player,firstname)
      if string.len(firstname) >= 2 and string.len(firstname) < 50 then
        firstname = sanitizeString(firstname, sanitizes.name[1], sanitizes.name[2])
        LVL.prompt(player,lang.cityhall.identity.prompt_name(),"",function(player,name)
          if string.len(name) >= 2 and string.len(name) < 50 then
            name = sanitizeString(name, sanitizes.name[1], sanitizes.name[2])
            LVL.prompt(player,lang.cityhall.identity.prompt_age(),"",function(player,age)
              age = parseInt(age)
              if age >= 16 and age <= 150 then
                if LVL.tryPayment(user_id,cfg.new_identity_cost) then
                  LVL.generateRegistrationNumber(function(registration)
                    LVL.generatePhoneNumber(function(phone)

                      MySQL.execute("LVL/update_user_identity", {
                        user_id = user_id,
                        firstname = firstname,
                        name = name,
                        age = age,
                        registration = registration,
                        phone = phone
                      })

                      -- update client registration
                      LVLclient.setRegistrationNumber(player,{registration})
                      LVLclient.notify(player,{lang.money.paid({cfg.new_identity_cost})})
                    end)
                  end)
                else
                  LVLclient.notify(player,{lang.money.not_enough()})
                end
              else
                LVLclient.notify(player,{lang.common.invalid_value()})
              end
            end)
          else
            LVLclient.notify(player,{lang.common.invalid_value()})
          end
        end)
      else
        LVLclient.notify(player,{lang.common.invalid_value()})
      end
    end)
  end
end




AddEventHandler("LVL:playerSpawn",function(user_id, source, first_spawn)
  -- send registration number to client at spawn
  LVL.getUserIdentity(user_id, function(identity)
    if identity then
      LVLclient.setRegistrationNumber(source,{identity.registration or "000AAA"})
    end
  end)


end)

-- player identity menu

-- add identity to main menu

