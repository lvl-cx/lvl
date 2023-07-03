local lang = OASIS.lang

-- Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)

MySQL.createCommand("OASIS/money_init_user","INSERT IGNORE INTO oasis_user_moneys(user_id,wallet,bank) VALUES(@user_id,@wallet,@bank)")
MySQL.createCommand("OASIS/get_money","SELECT wallet,bank FROM oasis_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("OASIS/set_money","UPDATE oasis_user_moneys SET wallet = @wallet, bank = @bank WHERE user_id = @user_id")

-- get money
-- cbreturn nil if error
function OASIS.getMoney(user_id)
  local tmp = OASIS.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- set money
function OASIS.setMoney(user_id,value)
  local tmp = OASIS.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  -- update client display
  local source = OASIS.getUserSource(user_id)
  if source ~= nil then
    OASISclient.setDivContent(source,{"money",lang.money.display({Comma(OASIS.getMoney(user_id))})})
    TriggerClientEvent('OASIS:initMoney', source, OASIS.getMoney(user_id), OASIS.getBankMoney(user_id))
  end
end

-- try a payment
-- return true or false (debited if true)
function OASIS.tryPayment(user_id,amount)
  local money = OASIS.getMoney(user_id)
  if amount >= 0 and money >= amount then
    OASIS.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

function OASIS.tryBankPayment(user_id,amount)
  local bank = OASIS.getBankMoney(user_id)
  if amount >= 0 and bank >= amount then
    OASIS.setBankMoney(user_id,bank-amount)
    return true
  else
    return false
  end
end

-- give money
function OASIS.giveMoney(user_id,amount)
  local money = OASIS.getMoney(user_id)
  OASIS.setMoney(user_id,money+amount)
end

-- get bank money
function OASIS.getBankMoney(user_id)
  local tmp = OASIS.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function OASIS.setBankMoney(user_id,value)
  local tmp = OASIS.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
  local source = OASIS.getUserSource(user_id)
  if source ~= nil then
    OASISclient.setDivContent(source,{"bmoney",lang.money.bdisplay({Comma(OASIS.getBankMoney(user_id))})})
    TriggerClientEvent('OASIS:initMoney', source, OASIS.getMoney(user_id), OASIS.getBankMoney(user_id))
  end
end

-- give bank money
function OASIS.giveBankMoney(user_id,amount)
  if amount > 0 then
    local money = OASIS.getBankMoney(user_id)
    OASIS.setBankMoney(user_id,money+amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function OASIS.tryWithdraw(user_id,amount)
  local money = OASIS.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    OASIS.setBankMoney(user_id,money-amount)
    OASIS.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function OASIS.tryDeposit(user_id,amount)
  if amount > 0 and OASIS.tryPayment(user_id,amount) then
    OASIS.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function OASIS.tryFullPayment(user_id,amount)
  local money = OASIS.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return OASIS.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if OASIS.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return OASIS.tryPayment(user_id, amount)
    end
  end

  return false
end

local startingCash = 50000
local startingBank = 100000000

-- events, init user account if doesn't exist at connection
AddEventHandler("OASIS:playerJoin",function(user_id,source,name,last_login)
  MySQL.query("OASIS/money_init_user", {user_id = user_id, wallet = startingCash, bank = startingBank}, function(affected)
    local tmp = OASIS.getUserTmpTable(user_id)
    if tmp then
      MySQL.query("OASIS/get_money", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
          tmp.bank = rows[1].bank
          tmp.wallet = rows[1].wallet
        end
      end)
    end
  end)
end)

-- save money on leave
AddEventHandler("OASIS:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = OASIS.getUserTmpTable(user_id)
  if tmp and tmp.wallet ~= nil and tmp.bank ~= nil then
    MySQL.execute("OASIS/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank})
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("OASIS:save", function()
  for k,v in pairs(OASIS.user_tmp_tables) do
    if v.wallet ~= nil and v.bank ~= nil then
      MySQL.execute("OASIS/set_money", {user_id = k, wallet = v.wallet, bank = v.bank})
    end
  end
end)

RegisterNetEvent('OASIS:giveCashToPlayer')
AddEventHandler('OASIS:giveCashToPlayer', function(nplayer)
  local source = source
  local user_id = OASIS.getUserId(source)
  if user_id ~= nil then
    if nplayer ~= nil then
      local nuser_id = OASIS.getUserId(nplayer)
      if nuser_id ~= nil then
        OASIS.prompt(source,lang.money.give.prompt(),"",function(source,amount)
          local amount = parseInt(amount)
          if amount > 0 and OASIS.tryPayment(user_id,amount) then
            OASIS.giveMoney(nuser_id,amount)
            OASISclient.notify(source,{lang.money.given({getMoneyStringFormatted(math.floor(amount))})})
            OASISclient.notify(nplayer,{lang.money.received({getMoneyStringFormatted(math.floor(amount))})})
            tOASIS.sendWebhook('give-cash', "OASIS Give Cash Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Target Name: **"..GetPlayerName(nplayer).."**\n> Target PermID: **"..nuser_id.."**\n> Amount: **£"..getMoneyStringFormatted(amount).."**")
          else
            OASISclient.notify(source,{lang.money.not_enough()})
          end
        end)
      else
        OASISclient.notify(source,{lang.common.no_player_near()})
      end
    else
      OASISclient.notify(source,{lang.common.no_player_near()})
    end
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

RegisterServerEvent("OASIS:takeAmount")
AddEventHandler("OASIS:takeAmount", function(amount)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.tryFullPayment(user_id,amount) then
      OASISclient.notify(source,{'~g~Paid £'..getMoneyStringFormatted(amount)..'.'})
      return
    end
end)

RegisterServerEvent("OASIS:bankTransfer")
AddEventHandler("OASIS:bankTransfer", function(id, amount)
    local source = source
    local user_id = OASIS.getUserId(source)
    local id = tonumber(id)
    local amount = tonumber(amount)
    if OASIS.getUserSource(id) then
      if OASIS.tryBankPayment(user_id,amount) then
        OASISclient.notify(source,{'~g~Transferred £'..getMoneyStringFormatted(amount)..' to ID: '..id})
        OASISclient.notify(OASIS.getUserSource(id),{'~g~Received £'..getMoneyStringFormatted(amount)..' from ID: '..user_id})
        TriggerClientEvent("oasis:PlaySound", source, "apple")
        TriggerClientEvent("oasis:PlaySound", OASIS.getUserSource(id), "apple")
        OASIS.giveBankMoney(id, amount)
        tOASIS.sendWebhook('bank-transfer', "OASIS Bank Transfer Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Target Name: **"..GetPlayerName(OASIS.getUserSource(id)).."**\n> Target PermID: **"..id.."**\n> Amount: **£"..amount.."**")
      else
        OASISclient.notify(source,{'~r~You do not have enough money.'})
      end
    else
      OASISclient.notify(source,{'~r~Player is not online'})
    end
end)

RegisterServerEvent('OASIS:requestPlayerBankBalance')
AddEventHandler('OASIS:requestPlayerBankBalance', function()
    local user_id = OASIS.getUserId(source)
    local bank = OASIS.getBankMoney(user_id)
    local wallet = OASIS.getMoney(user_id)
    TriggerClientEvent('OASIS:setDisplayMoney', source, wallet)
    TriggerClientEvent('OASIS:setDisplayBankMoney', source, bank)
    TriggerClientEvent('OASIS:initMoney', source, wallet, bank)
end)