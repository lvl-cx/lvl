local htmlEntities = module("lib/htmlEntities")

local cfg = module("cfg/identity")
local lang = ATM.lang

local sanitizes = module("cfg/sanitizes")

-- this module describe the identity system

-- init sql


MySQL.createCommand("ATM/get_user_identity","SELECT * FROM atm_user_identities WHERE user_id = @user_id")
MySQL.createCommand("ATM/init_user_identity","INSERT IGNORE INTO atm_user_identities(user_id,registration,phone,firstname,name,age) VALUES(@user_id,@registration,@phone,@firstname,@name,@age)")
MySQL.createCommand("ATM/update_user_identity","UPDATE atm_user_identities SET firstname = @firstname, name = @name, age = @age, registration = @registration, phone = @phone WHERE user_id = @user_id")
MySQL.createCommand("ATM/get_userbyreg","SELECT user_id FROM atm_user_identities WHERE registration = @registration")
MySQL.createCommand("ATM/get_userbyphone","SELECT user_id FROM atm_user_identities WHERE phone = @phone")



-- api

-- cbreturn user identity
function ATM.getUserIdentity(user_id, cbr)
    local task = Task(cbr)
    if cbr then 
        MySQL.query("ATM/get_user_identity", {user_id = user_id}, function(rows, affected)
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
function ATM.getUserByRegistration(registration, cbr)
  local task = Task(cbr)

  MySQL.query("ATM/get_userbyreg", {registration = registration or ""}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].user_id})
    else
      task()
    end
  end)
end

-- cbreturn user_id by phone or nil
function ATM.getUserByPhone(phone, cbr)
  local task = Task(cbr)

  MySQL.query("ATM/get_userbyphone", {phone = phone or ""}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].user_id})
    else
      task()
    end
  end)
end

function ATM.generateStringNumber(format) -- (ex: DDDLLL, D => digit, L => letter)
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
function ATM.generateRegistrationNumber(cbr)
  local task = Task(cbr)

  local function search()
    -- generate registration number
    local registration = ATM.generateStringNumber("DDDLLL")
    ATM.getUserByRegistration(registration, function(user_id)
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
function ATM.generatePhoneNumber(cbr)
  local task = Task(cbr)

  local function search()
    -- generate phone number
    local phone = ATM.generateStringNumber(cfg.phone_format)
    ATM.getUserByPhone(phone, function(user_id)
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
AddEventHandler("ATM:playerJoin",function(user_id,source,name,last_login)
  ATM.getUserIdentity(user_id, function(identity)
    if identity == nil then
      ATM.generateRegistrationNumber(function(registration)
        ATM.generatePhoneNumber(function(phone)
          MySQL.execute("ATM/init_user_identity", {
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
  local user_id = ATM.getUserId(player)
  if user_id ~= nil then
    ATM.prompt(player,lang.cityhall.identity.prompt_firstname(),"",function(player,firstname)
      if string.len(firstname) >= 2 and string.len(firstname) < 50 then
        firstname = sanitizeString(firstname, sanitizes.name[1], sanitizes.name[2])
        ATM.prompt(player,lang.cityhall.identity.prompt_name(),"",function(player,name)
          if string.len(name) >= 2 and string.len(name) < 50 then
            name = sanitizeString(name, sanitizes.name[1], sanitizes.name[2])
            ATM.prompt(player,lang.cityhall.identity.prompt_age(),"",function(player,age)
              age = parseInt(age)
              if age >= 16 and age <= 150 then
                if ATM.tryPayment(user_id,cfg.new_identity_cost) then
                  ATM.generateRegistrationNumber(function(registration)
                    ATM.generatePhoneNumber(function(phone)

                      MySQL.execute("ATM/update_user_identity", {
                        user_id = user_id,
                        firstname = firstname,
                        name = name,
                        age = age,
                        registration = registration,
                        phone = phone
                      })

                      -- update client registration
                      ATMclient.setRegistrationNumber(player,{registration})
                      ATMclient.notify(player,{lang.money.paid({cfg.new_identity_cost})})
                    end)
                  end)
                else
                  ATMclient.notify(player,{lang.money.not_enough()})
                end
              else
                ATMclient.notify(player,{lang.common.invalid_value()})
              end
            end)
          else
            ATMclient.notify(player,{lang.common.invalid_value()})
          end
        end)
      else
        ATMclient.notify(player,{lang.common.invalid_value()})
      end
    end)
  end
end




AddEventHandler("ATM:playerSpawn",function(user_id, source, first_spawn)
  -- send registration number to client at spawn
  ATM.getUserIdentity(user_id, function(identity)
    if identity then
      ATMclient.setRegistrationNumber(source,{identity.registration or "000AAA"})
    end
  end)


end)

-- player identity menu

-- add identity to main menu

