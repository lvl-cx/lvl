local lang = ATM.lang

RegisterServerEvent('ATM:OpenNHSMenu')
AddEventHandler('ATM:OpenNHSMenu', function()
    local source = source
    local user_id = ATM.getUserId(source)
    if user_id ~= nil and ATM.hasPermission(user_id, "nhs.menu") then
        TriggerClientEvent("ATM:NHSMenuOpened", source)
    elseif user_id ~= nil and ATM.hasPermission(user_id, "clockon.nhs") then
      ATMclient.notify(source,{"You are not on duty"})
    else
        print("You are not a part of the NHS")
    end
end)

local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

RegisterServerEvent('ATM:PerformCPR')
AddEventHandler('ATM:PerformCPR', function()
    player = source
    local user_id = ATM.getUserId(player)
    if user_id ~= nil and ATM.hasPermission(user_id, "nhs.revive") then
        ATMclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = ATM.getUserId(nplayer)
            if nuser_id ~= nil then
                ATMclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        ATMclient.playAnim(player, {false, revive_seq, false}) -- anim
                        SetTimeout(15000, function()
                          TriggerClientEvent('ATM:FixClient',nplayer)
                          ATMclient.varyHealth(nplayer, 50) -- heal 50
                          ATMclient.notify(nplayer,{"~g~You have been revived by an NHS Member, free of charge"})
                          ATMclient.notify(player,{"~g~You revived someone, as a reward, here is £10,000 into your bank"})
                          ATM.giveBankMoney(player,10000)
                        end)
                    else
                        ATMclient.notify(player, {"~r~Player is alive and healthy"})
                    end
                end)
            else
                ATMclient.notify(player, {"~r~There is no player nearby"})
            end
        end)
    end
end)

