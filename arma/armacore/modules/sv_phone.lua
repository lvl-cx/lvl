local cfg_inventory = module("cfg/inventory")
local lang = ARMA.lang

RegisterServerEvent("ARMA:AskID")
AddEventHandler("ARMA:AskID",function()
    local player = source

    ARMAclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = ARMA.getUserId(nplayer)
      if nuser_id ~= nil then
        ARMAclient.notify(player,{lang.police.menu.askid.asked()})
        ARMA.request(nplayer,lang.police.menu.askid.request(),15,function(nplayer,ok)
          if ok then
            ARMA.getUserIdentity(nuser_id, function(identity)
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
  
                    local content = lang.police.identity.info({name,firstname,age,registration,phone,'yo','[R',home,number})
                    ARMAclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                    -- request to hide div
                    ARMA.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                      ARMAclient.removeDiv(player,{"police_identity"})
                    end)
                
              end
            end)
          else
            ARMAclient.notify(player,{lang.common.request_refused()})
          end
        end)
      else
        ARMAclient.notify(player,{lang.common.no_player_near()})
      end
    end)
end)

RegisterServerEvent("ARMA:GiveMoney")
AddEventHandler("ARMA:GiveMoney",function()
    local player = source
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil then
      ARMAclient.getNearestPlayer(player,{10},function(nplayer)
        if nplayer ~= nil then
        local nuser_id = ARMA.getUserId(nplayer)
        local givemoney = {
          {
            ["color"] = "16448403",
            ["title"] = "ARMA Give Money Logs",
            ["description"] = "",
            ["text"] = "ARMA Server #1",
            ["fields"] = {
              {
                ["name"] = "Player Name",
                ["value"] = GetPlayerName(source),
                ["inline"] = true
              },
              {
                ["name"] = "Player TempID",
                ["value"] = source,
                ["inline"] = true
              },
              {
                ["name"] = "Player PermID",
                ["value"] = user_id,
                ["inline"] = true
              },
              {
                ["name"] = "Player Hours",
                ["value"] = "0 hours",
                ["inline"] = true
              },
              {
                ["name"] = "Target Name",
                ["value"] = GetPlayerName(nplayer),
                ["inline"] = true
              },
              {
                ["name"] = "Target TempID",
                ["value"] = nplayer,
                ["inline"] = true
              },
              {
                ["name"] = "Target PermID",
                ["value"] = ARMA.getUserId(nplayer),
                ["inline"] = true
              },
              {
                ["name"] = "Target Hours",
                ["value"] = "0 hours",
                ["inline"] = true
              }
            }
          }
        }
        local webhook = "https://discord.com/api/webhooks/991455014751064104/5YHDx5686AN82SjPXGNFjdhqwY6eE46x811zFDBCcTGaoCV4azBEVnpqRplJTF5M0ZwJ"
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = givemoney}), { ['Content-Type'] = 'application/json' })
        if nuser_id ~= nil then
            ARMA.prompt(player,lang.money.give.prompt(),"",function(player,amount)
            local amount = parseInt(amount)
            if amount > 0 and ARMA.tryPayment(user_id,amount) then
                ARMA.giveMoney(nuser_id,amount)
                ARMAclient.notify(player,{lang.money.given({amount})})
                ARMAclient.notify(nplayer,{lang.money.received({amount})})
            else
                ARMAclient.notify(player,{lang.money.not_enough()})
                end
            end)
            else
                ARMAclient.notify(player,{lang.common.no_player_near()})
            end
            else
                ARMAclient.notify(player,{lang.common.no_player_near()})
            end
        end)
    end
end)

RegisterNetEvent('ARMA:SearchPlr')
AddEventHandler("ARMA:SearchPlr", function()
  player = source
  ARMAclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = ARMA.getUserId(nplayer)
    if nuser_id ~= nil then
      ARMAclient.notify(nplayer,{lang.police.menu.check.checked()})
      ARMAclient.getWeapons(nplayer,{},function(weapons)
        -- prepare display data (money, items, weapons)
        local money = ARMA.getMoney(nuser_id)
        local items = ""
        local data = ARMA.getUserDataTable(nuser_id)
        local searchplr = {
          {
            ["color"] = "16448403",
            ["title"] = "ARMA Search Player Logs",
            ["description"] = "",
            ["text"] = "ARMA Server #1",
            ["fields"] = {
              {
                ["name"] = "Player Name",
                ["value"] = GetPlayerName(source),
                ["inline"] = true
              },
              {
                ["name"] = "Player TempID",
                ["value"] = source,
                ["inline"] = true
              },
              {
                ["name"] = "Player PermID",
                ["value"] = user_id,
                ["inline"] = true
              },
              {
                ["name"] = "Player Hours",
                ["value"] = "0 hours",
                ["inline"] = true
              },
              {
                ["name"] = "Target Name",
                ["value"] = GetPlayerName(nplayer),
                ["inline"] = true
              },
              {
                ["name"] = "Target TempID",
                ["value"] = nplayer,
                ["inline"] = true
              },
              {
                ["name"] = "Target PermID",
                ["value"] = ARMA.getUserId(nplayer),
                ["inline"] = true
              },
              {
                ["name"] = "Target Hours",
                ["value"] = "0 hours",
                ["inline"] = true
              }
            }
          }
        }
        local webhook = "https://discord.com/api/webhooks/991455014751064104/5YHDx5686AN82SjPXGNFjdhqwY6eE46x811zFDBCcTGaoCV4azBEVnpqRplJTF5M0ZwJ"
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = searchplr}), { ['Content-Type'] = 'application/json' })
        if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item_name = ARMA.getItemName(k)
            if item_name then
              items = items.."<br />"..item_name.." ("..v.amount..")"
            end
          end
        end

        local weapons_info = ""
        for k,v in pairs(weapons) do
          weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
        end

        ARMAclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
        -- request to hide div
        ARMA.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
          ARMAclient.removeDiv(player,{"police_check"})
        end)
      end)
    else
      ARMAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end)