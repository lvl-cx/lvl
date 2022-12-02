local lang = ARMA.lang

-- Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)



MySQL.createCommand("ARMA/money_init_user","INSERT IGNORE INTO arma_user_moneys(user_id,wallet,bank) VALUES(@user_id,@wallet,@bank)")
MySQL.createCommand("ARMA/get_money","SELECT wallet,bank FROM arma_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("ARMA/set_money","UPDATE arma_user_moneys SET wallet = @wallet, bank = @bank WHERE user_id = @user_id")


-- load config
local cfg = module("cfg/money")

-- API

-- get money
-- cbreturn nil if error
function ARMA.getMoney(user_id)
  local tmp = ARMA.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- set money
function ARMA.setMoney(user_id,value)
  local tmp = ARMA.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  -- update client display
  local source = ARMA.getUserSource(user_id)
  if source ~= nil then
    ARMAclient.setDivContent(source,{"money",lang.money.display({Comma(ARMA.getMoney(user_id))})})
    TriggerClientEvent('ARMA:initMoney', source, ARMA.getMoney(user_id), ARMA.getBankMoney(user_id))
  end
end

-- try a payment
-- return true or false (debited if true)
function ARMA.tryPayment(user_id,amount)
  local money = ARMA.getMoney(user_id)
  if amount >= 0 and money >= amount then
    ARMA.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

function ARMA.tryBankPayment(user_id,amount)
  local bank = ARMA.getBankMoney(user_id)
  if amount >= 0 and bank >= amount then
    ARMA.setBankMoney(user_id,bank-amount)
    return true
  else
    return false
  end
end

-- give money
function ARMA.giveMoney(user_id,amount)
  local money = ARMA.getMoney(user_id)
  ARMA.setMoney(user_id,money+amount)
end

-- get bank money
function ARMA.getBankMoney(user_id)
  local tmp = ARMA.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function ARMA.setBankMoney(user_id,value)
  local tmp = ARMA.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
  local source = ARMA.getUserSource(user_id)
  if source ~= nil then
    ARMAclient.setDivContent(source,{"bmoney",lang.money.bdisplay({Comma(ARMA.getBankMoney(user_id))})})
    TriggerClientEvent('ARMA:initMoney', source, ARMA.getMoney(user_id), ARMA.getBankMoney(user_id))
  end
end

-- give bank money
function ARMA.giveBankMoney(user_id,amount)
  if amount > 0 then
    local money = ARMA.getBankMoney(user_id)
    ARMA.setBankMoney(user_id,money+amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function ARMA.tryWithdraw(user_id,amount)
  local money = ARMA.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    ARMA.setBankMoney(user_id,money-amount)
    ARMA.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function ARMA.tryDeposit(user_id,amount)
  if amount > 0 and ARMA.tryPayment(user_id,amount) then
    ARMA.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function ARMA.tryFullPayment(user_id,amount)
  local money = ARMA.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return ARMA.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if ARMA.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return ARMA.tryPayment(user_id, amount)
    end
  end

  return false
end

-- events, init user account if doesn't exist at connection
AddEventHandler("ARMA:playerJoin",function(user_id,source,name,last_login)
  MySQL.query("ARMA/money_init_user", {user_id = user_id, wallet = cfg.open_wallet, bank = cfg.open_bank}, function(affected)
    local tmp = ARMA.getUserTmpTable(user_id)
    if tmp then
      MySQL.query("ARMA/get_money", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
          tmp.bank = rows[1].bank
          tmp.wallet = rows[1].wallet
        end
      end)
    end
  end)
end)

-- save money on leave
AddEventHandler("ARMA:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = ARMA.getUserTmpTable(user_id)
  if tmp and tmp.wallet ~= nil and tmp.bank ~= nil then
    MySQL.execute("ARMA/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank})
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("ARMA:save", function()
  for k,v in pairs(ARMA.user_tmp_tables) do
    if v.wallet ~= nil and v.bank ~= nil then
      MySQL.execute("ARMA/set_money", {user_id = k, wallet = v.wallet, bank = v.bank})
    end
  end
end)

RegisterNetEvent('ARMA:giveCashToPlayer')
AddEventHandler('ARMA:giveCashToPlayer', function()
  local source = source
  local user_id = ARMA.getUserId(source)
  if user_id ~= nil then
    ARMAclient.getNearestPlayer(source,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = ARMA.getUserId(nplayer)
        if nuser_id ~= nil then
          -- prompt number
          ARMA.prompt(source,lang.money.give.prompt(),"",function(source,amount)
            local amount = parseInt(amount)
            if amount > 0 and ARMA.tryPayment(user_id,amount) then
              ARMA.giveMoney(nuser_id,amount)
              ARMAclient.notify(source,{lang.money.given({amount})})
              ARMAclient.notify(nplayer,{lang.money.received({amount})})
            else
              ARMAclient.notify(source,{lang.money.not_enough()})
            end
          end)
        else
          ARMAclient.notify(source,{lang.common.no_player_near()})
        end
      else
        ARMAclient.notify(source,{lang.common.no_player_near()})
      end
    end)
  end
end)


function Comma(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

RegisterServerEvent("ARMA:takeAmount")
AddEventHandler("ARMA:takeAmount", function(amount)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.tryFullPayment(user_id,amount) then
      ARMAclient.notify(source,{'~g~Paid £'..getMoneyStringFormatted(amount)..'.'})
      return
    end
end)

RegisterServerEvent("ARMA:bankTransfer")
AddEventHandler("ARMA:bankTransfer", function(id, amount)
    local source = source
    local user_id = ARMA.getUserId(source)
    local id = tonumber(id)
    local amount = tonumber(amount)
    if ARMA.getUserSource(id) then
      if ARMA.tryFullPayment(user_id,amount) then
        ARMAclient.notify(source,{'~g~Transferred £'..getMoneyStringFormatted(amount)..' to ID: '..id})
        ARMAclient.notify(ARMA.getUserSource(id),{'~g~Received £'..getMoneyStringFormatted(amount)..' from ID: '..user_id})
        TriggerClientEvent("arma:PlaySound", source, "apple")
        TriggerClientEvent("arma:PlaySound", ARMA.getUserSource(id), "apple")
        ARMA.giveBankMoney(id, amount)
      else
        ARMAclient.notify(source,{'~r~You do not have enough money.'})
      end
    else
      ARMAclient.notify(source,{'~r~Player is not online'})
    end
end)