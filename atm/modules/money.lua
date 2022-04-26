local lang = ATM.lang

-- Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)



MySQL.createCommand("ATM/money_init_user","INSERT IGNORE INTO atm_user_moneys(user_id,wallet,bank) VALUES(@user_id,@wallet,@bank)")
MySQL.createCommand("ATM/get_money","SELECT wallet,bank FROM atm_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("ATM/set_money","UPDATE atm_user_moneys SET wallet = @wallet, bank = @bank WHERE user_id = @user_id")


-- load config
local cfg = module("cfg/money")

-- API

-- get money
-- cbreturn nil if error
function ATM.getMoney(user_id)
  local tmp = ATM.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- set money
function ATM.setMoney(user_id,value)
  local tmp = ATM.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  -- update client display
  local source = ATM.getUserSource(user_id)
  if source ~= nil then
    ATMclient.setDivContent(source,{"money",lang.money.display({Comma(ATM.getMoney(user_id))})})
  end
end

-- try a payment
-- return true or false (debited if true)
function ATM.tryPayment(user_id,amount)
  local money = ATM.getMoney(user_id)
  if amount >= 0 and money >= amount then
    ATM.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

function ATM.tryBankPayment(user_id,amount)
  local bank = ATM.getBankMoney(user_id)
  if amount >= 0 and bank >= amount then
    ATM.setBankMoney(user_id,bank-amount)
    return true
  else
    return false
  end
end

-- give money
function ATM.giveMoney(user_id,amount)
  local money = ATM.getMoney(user_id)
  ATM.setMoney(user_id,money+amount)
end

-- get bank money
function ATM.getBankMoney(user_id)
  local tmp = ATM.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function ATM.setBankMoney(user_id,value)
  local tmp = ATM.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
  local source = ATM.getUserSource(user_id)
  if source ~= nil then
    ATMclient.setDivContent(source,{"bmoney",lang.money.bdisplay({Comma(ATM.getBankMoney(user_id))})})
  end
end

-- give bank money
function ATM.giveBankMoney(user_id,amount)
  if amount > 0 then
    local money = ATM.getBankMoney(user_id)
    ATM.setBankMoney(user_id,money+amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function ATM.tryWithdraw(user_id,amount)
  local money = ATM.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    ATM.setBankMoney(user_id,money-amount)
    ATM.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function ATM.tryDeposit(user_id,amount)
  if amount > 0 and ATM.tryPayment(user_id,amount) then
    ATM.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function ATM.tryFullPayment(user_id,amount)
  local money = ATM.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return ATM.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if ATM.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return ATM.tryPayment(user_id, amount)
    end
  end

  return false
end

-- events, init user account if doesn't exist at connection
AddEventHandler("ATM:playerJoin",function(user_id,source,name,last_login)
  MySQL.query("ATM/money_init_user", {user_id = user_id, wallet = cfg.open_wallet, bank = cfg.open_bank}, function(affected)
    local tmp = ATM.getUserTmpTable(user_id)
    if tmp then
      MySQL.query("ATM/get_money", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
          tmp.bank = rows[1].bank
          tmp.wallet = rows[1].wallet
        end
      end)
    end
  end)
end)

-- save money on leave
AddEventHandler("ATM:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = ATM.getUserTmpTable(user_id)
  if tmp and tmp.wallet ~= nil and tmp.bank ~= nil then
    MySQL.execute("ATM/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank})
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("ATM:save", function()
  for k,v in pairs(ATM.user_tmp_tables) do
    if v.wallet ~= nil and v.bank ~= nil then
      MySQL.execute("ATM/set_money", {user_id = k, wallet = v.wallet, bank = v.bank})
    end
  end
end)

local function ch_give(player,choice)
  -- get nearest player
  local user_id = ATM.getUserId(player)
  if user_id ~= nil then
    ATMclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = ATM.getUserId(nplayer)
        if nuser_id ~= nil then
          -- prompt number
          ATM.prompt(player,lang.money.give.prompt(),"",function(player,amount)
            local amount = parseInt(amount)
            if amount > 0 and ATM.tryPayment(user_id,amount) then
              ATM.giveMoney(nuser_id,amount)
              ATMclient.notify(player,{lang.money.given({amount})})
              ATMclient.notify(nplayer,{lang.money.received({amount})})
            else
              ATMclient.notify(player,{lang.money.not_enough()})
            end
          end)
        else
          ATMclient.notify(player,{lang.common.no_player_near()})
        end
      else
        ATMclient.notify(player,{lang.common.no_player_near()})
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
