local cfg_inventory = module("cfg/inventory")
local lang = ATM.lang

RegisterServerEvent("ATM:AskID")
AddEventHandler("ATM:AskID",function()
    local player = source

    ATMclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = ATM.getUserId(nplayer)
      if nuser_id ~= nil then
        ATMclient.notify(player,{lang.police.menu.askid.asked()})
        ATM.request(nplayer,lang.police.menu.askid.request(),15,function(nplayer,ok)
          if ok then
            ATM.getUserIdentity(nuser_id, function(identity)
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
  

  
                  ATM.getUserAddress(nuser_id, function(address)
                    if address then
                      home = address.home
                      number = address.number
                    end
  
                    local content = lang.police.identity.info({name,firstname,age,registration,phone,'yo','[R',home,number})
                    ATMclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                    -- request to hide div
                    ATM.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                      ATMclient.removeDiv(player,{"police_identity"})
                    end)
                  end)
                
              end
            end)
          else
            ATMclient.notify(player,{lang.common.request_refused()})
          end
        end)
      else
        ATMclient.notify(player,{lang.common.no_player_near()})
      end
    end)
end)

RegisterServerEvent("ATM:GiveMoney")
AddEventHandler("ATM:GiveMoney",function()
    local player = source
    local user_id = ATM.getUserId(player)
    if user_id ~= nil then
      ATMclient.getNearestPlayer(player,{10},function(nplayer)
        if nplayer ~= nil then
        local nuser_id = ATM.getUserId(nplayer)
        if nuser_id ~= nil then
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
end)

RegisterNetEvent('ATM:SearchPlr')
AddEventHandler("ATM:SearchPlr", function()
  player = source
  ATMclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = ATM.getUserId(nplayer)
    if nuser_id ~= nil then
      ATMclient.notify(nplayer,{lang.police.menu.check.checked()})
      ATMclient.getWeapons(nplayer,{},function(weapons)
        -- prepare display data (money, items, weapons)
        local money = ATM.getMoney(nuser_id)
        local items = ""
        local data = ATM.getUserDataTable(nuser_id)
        if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item_name = ATM.getItemName(k)
            if item_name then
              items = items.."<br />"..item_name.." ("..v.amount..")"
            end
          end
        end

        local weapons_info = ""
        for k,v in pairs(weapons) do
          weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
        end

        ATMclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
        -- request to hide div
        ATM.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
          ATMclient.removeDiv(player,{"police_check"})
        end)
      end)
    else
      ATMclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end)
