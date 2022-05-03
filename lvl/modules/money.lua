local lang = LVL.lang

-- Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)



MySQL.createCommand("LVL/money_init_user","INSERT IGNORE INTO lvl_user_moneys(user_id,wallet,bank) VALUES(@user_id,@wallet,@bank)")
MySQL.createCommand("LVL/get_money","SELECT wallet,bank FROM lvl_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("LVL/set_money","UPDATE lvl_user_moneys SET wallet = @wallet, bank = @bank WHERE user_id = @user_id")


-- load config
local cfg = module("cfg/money")

-- API

-- get money
-- cbreturn nil if error
function LVL.getMoney(user_id)
  local tmp = LVL.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- set money
function LVL.setMoney(user_id,value)
  local tmp = LVL.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  -- update client display
  local source = LVL.getUserSource(user_id)
  if source ~= nil then
    LVLclient.setDivContent(source,{"money",lang.money.display({Comma(LVL.getMoney(user_id))})})
  end
end

-- try a payment
-- return true or false (debited if true)
function LVL.tryPayment(user_id,amount)
  local money = LVL.getMoney(user_id)
  if amount >= 0 and money >= amount then
    LVL.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

function LVL.tryBankPayment(user_id,amount)
  local bank = LVL.getBankMoney(user_id)
  if amount >= 0 and bank >= amount then
    LVL.setBankMoney(user_id,bank-amount)
    return true
  else
    return false
  end
end

-- give money
function LVL.giveMoney(user_id,amount)
  local money = LVL.getMoney(user_id)
  LVL.setMoney(user_id,money+amount)
end

-- get bank money
function LVL.getBankMoney(user_id)
  local tmp = LVL.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function LVL.setBankMoney(user_id,value)
  local tmp = LVL.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
  local source = LVL.getUserSource(user_id)
  if source ~= nil then
    LVLclient.setDivContent(source,{"bmoney",lang.money.bdisplay({Comma(LVL.getBankMoney(user_id))})})
  end
end

-- give bank money
function LVL.giveBankMoney(user_id,amount)
  if amount > 0 then
    local money = LVL.getBankMoney(user_id)
    LVL.setBankMoney(user_id,money+amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function LVL.tryWithdraw(user_id,amount)
  local money = LVL.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    LVL.setBankMoney(user_id,money-amount)
    LVL.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function LVL.tryDeposit(user_id,amount)
  if amount > 0 and LVL.tryPayment(user_id,amount) then
    LVL.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function LVL.tryFullPayment(user_id,amount)
  local money = LVL.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return LVL.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if LVL.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return LVL.tryPayment(user_id, amount)
    end
  end

  return false
end

-- events, init user account if doesn't exist at connection
AddEventHandler("LVL:playerJoin",function(user_id,source,name,last_login)
  MySQL.query("LVL/money_init_user", {user_id = user_id, wallet = cfg.open_wallet, bank = cfg.open_bank}, function(affected)
    local tmp = LVL.getUserTmpTable(user_id)
    if tmp then
      MySQL.query("LVL/get_money", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
          tmp.bank = rows[1].bank
          tmp.wallet = rows[1].wallet
        end
      end)
    end
  end)
end)

-- save money on leave
AddEventHandler("LVL:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = LVL.getUserTmpTable(user_id)
  if tmp and tmp.wallet ~= nil and tmp.bank ~= nil then
    MySQL.execute("LVL/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank})
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("LVL:save", function()
  for k,v in pairs(LVL.user_tmp_tables) do
    if v.wallet ~= nil and v.bank ~= nil then
      MySQL.execute("LVL/set_money", {user_id = k, wallet = v.wallet, bank = v.bank})
    end
  end
end)

local function ch_give(player,choice)
  -- get nearest player
  local user_id = LVL.getUserId(player)
  if user_id ~= nil then
    LVLclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = LVL.getUserId(nplayer)
        if nuser_id ~= nil then
          -- prompt number
          LVL.prompt(player,lang.money.give.prompt(),"",function(player,amount)
            local amount = parseInt(amount)
            if amount > 0 and LVL.tryPayment(user_id,amount) then
              LVL.giveMoney(nuser_id,amount)
              LVLclient.notify(player,{lang.money.given({amount})})
              LVLclient.notify(nplayer,{lang.money.received({amount})})
            else
              LVLclient.notify(player,{lang.money.not_enough()})
            end
          end)
        else
          LVLclient.notify(player,{lang.common.no_player_near()})
        end
      else
        LVLclient.notify(player,{lang.common.no_player_near()})
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
