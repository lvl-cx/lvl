local cfg_inventory = module("cfg/inventory")
local lang = Sentry.lang

RegisterServerEvent("Sentry:AskID")
AddEventHandler("Sentry:AskID",function()
    local player = source

    Sentryclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = Sentry.getUserId(nplayer)
      if nuser_id ~= nil then
        Sentryclient.notify(player,{lang.police.menu.askid.asked()})
        Sentry.request(nplayer,lang.police.menu.askid.request(),15,function(nplayer,ok)
          if ok then
            Sentry.getUserIdentity(nuser_id, function(identity)
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
  

  
                  Sentry.getUserAddress(nuser_id, function(address)
                    if address then
                      home = address.home
                      number = address.number
                    end
  
                    local content = lang.police.identity.info({name,firstname,age,registration,phone,'yo','[R',home,number})
                    Sentryclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                    -- request to hide div
                    Sentry.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                      Sentryclient.removeDiv(player,{"police_identity"})
                    end)
                  end)
                
              end
            end)
          else
            Sentryclient.notify(player,{lang.common.request_refused()})
          end
        end)
      else
        Sentryclient.notify(player,{lang.common.no_player_near()})
      end
    end)
end)

RegisterServerEvent("Sentry:GiveMoney")
AddEventHandler("Sentry:GiveMoney",function()
    local player = source
    local user_id = Sentry.getUserId(player)
    if user_id ~= nil then
      Sentryclient.getNearestPlayer(player,{10},function(nplayer)
        if nplayer ~= nil then
        local nuser_id = Sentry.getUserId(nplayer)
        if nuser_id ~= nil then
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
end)

RegisterNetEvent('Sentry:SearchPlr')
AddEventHandler("Sentry:SearchPlr", function()
  player = source
  Sentryclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = Sentry.getUserId(nplayer)
    if nuser_id ~= nil then
      Sentryclient.notify(nplayer,{lang.police.menu.check.checked()})
      Sentryclient.getWeapons(nplayer,{},function(weapons)
        -- prepare display data (money, items, weapons)
        local money = Sentry.getMoney(nuser_id)
        local items = ""
        local data = Sentry.getUserDataTable(nuser_id)
        if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item_name = Sentry.getItemName(k)
            if item_name then
              items = items.."<br />"..item_name.." ("..v.amount..")"
            end
          end
        end

        local weapons_info = ""
        for k,v in pairs(weapons) do
          weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
        end

        Sentryclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
        -- request to hide div
        Sentry.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
          Sentryclient.removeDiv(player,{"police_check"})
        end)
      end)
    else
      Sentryclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end)
