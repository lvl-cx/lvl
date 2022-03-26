local lang = Sentry.lang

-- Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)



MySQL.createCommand("Sentry/money_init_user","INSERT IGNORE INTO sentry_user_moneys(user_id,wallet,bank) VALUES(@user_id,@wallet,@bank)")
MySQL.createCommand("Sentry/get_money","SELECT wallet,bank FROM sentry_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("Sentry/set_money","UPDATE sentry_user_moneys SET wallet = @wallet, bank = @bank WHERE user_id = @user_id")


-- load config
local cfg = module("cfg/money")

-- API

-- get money
-- cbreturn nil if error
function Sentry.getMoney(user_id)
  local tmp = Sentry.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- set money
function Sentry.setMoney(user_id,value)
  local tmp = Sentry.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  -- update client display
  local source = Sentry.getUserSource(user_id)
  if source ~= nil then
    Sentryclient.setDivContent(source,{"money",lang.money.display({Comma(Sentry.getMoney(user_id))})})
  end
end

-- try a payment
-- return true or false (debited if true)
function Sentry.tryPayment(user_id,amount)
  local money = Sentry.getMoney(user_id)
  if amount >= 0 and money >= amount then
    Sentry.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

function Sentry.tryBankPayment(user_id,amount)
  local bank = Sentry.getBankMoney(user_id)
  if amount >= 0 and bank >= amount then
    Sentry.setBankMoney(user_id,bank-amount)
    return true
  else
    return false
  end
end

-- give money
function Sentry.giveMoney(user_id,amount)
  local money = Sentry.getMoney(user_id)
  Sentry.setMoney(user_id,money+amount)
end

-- get bank money
function Sentry.getBankMoney(user_id)
  local tmp = Sentry.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function Sentry.setBankMoney(user_id,value)
  local tmp = Sentry.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
  local source = Sentry.getUserSource(user_id)
  if source ~= nil then
    Sentryclient.setDivContent(source,{"bmoney",lang.money.bdisplay({Comma(Sentry.getBankMoney(user_id))})})
  end
end

-- give bank money
function Sentry.giveBankMoney(user_id,amount)
  if amount > 0 then
    local money = Sentry.getBankMoney(user_id)
    Sentry.setBankMoney(user_id,money+amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function Sentry.tryWithdraw(user_id,amount)
  local money = Sentry.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    Sentry.setBankMoney(user_id,money-amount)
    Sentry.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function Sentry.tryDeposit(user_id,amount)
  if amount > 0 and Sentry.tryPayment(user_id,amount) then
    Sentry.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function Sentry.tryFullPayment(user_id,amount)
  local money = Sentry.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return Sentry.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if Sentry.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return Sentry.tryPayment(user_id, amount)
    end
  end

  return false
end

-- events, init user account if doesn't exist at connection
AddEventHandler("Sentry:playerJoin",function(user_id,source,name,last_login)
  MySQL.query("Sentry/money_init_user", {user_id = user_id, wallet = cfg.open_wallet, bank = cfg.open_bank}, function(affected)
    local tmp = Sentry.getUserTmpTable(user_id)
    if tmp then
      MySQL.query("Sentry/get_money", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
          tmp.bank = rows[1].bank
          tmp.wallet = rows[1].wallet
        end
      end)
    end
  end)
end)

-- save money on leave
AddEventHandler("Sentry:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = Sentry.getUserTmpTable(user_id)
  if tmp and tmp.wallet ~= nil and tmp.bank ~= nil then
    MySQL.execute("Sentry/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank})
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("Sentry:save", function()
  for k,v in pairs(Sentry.user_tmp_tables) do
    if v.wallet ~= nil and v.bank ~= nil then
      MySQL.execute("Sentry/set_money", {user_id = k, wallet = v.wallet, bank = v.bank})
    end
  end
end)

local function ch_give(player,choice)
  -- get nearest player
  local user_id = Sentry.getUserId(player)
  if user_id ~= nil then
    Sentryclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = Sentry.getUserId(nplayer)
        if nuser_id ~= nil then
          -- prompt number
          Sentry.prompt(player,lang.money.give.prompt(),"",function(player,amount)
            local amount = parseInt(amount)
            if amount > 0 and Sentry.tryPayment(user_id,amount) then
              Sentry.giveMoney(nuser_id,amount)
              Sentryclient.notify(player,{lang.money.given({amount})})
              Sentryclient.notify(nplayer,{lang.money.received({amount})})
            else
              Sentryclient.notify(player,{lang.money.not_enough()})
            end
          end)
        else
          Sentryclient.notify(player,{lang.common.no_player_near()})
        end
      else
        Sentryclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end


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
