local lang = LVL.lang

RegisterServerEvent('Eclipse:OpenNHSMenu')
AddEventHandler('Eclipse:OpenNHSMenu', function()
    local source = source
    local user_id = LVL.getUserId(source)
    if user_id ~= nil and LVL.hasPermission(user_id, "nhs.menu") then
        TriggerClientEvent("Eclipse:NHSMenuOpened", source)
    elseif user_id ~= nil and LVL.hasPermission(user_id, "clockon.nhs") then
      LVLclient.notify(source,{"You are not on duty"})
    else
        print("You are not a part of the NHS")
    end
end)

local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

RegisterServerEvent('Eclipse:PerformCPR')
AddEventHandler('Eclipse:PerformCPR', function()
    player = source
    local user_id = LVL.getUserId(player)
    if user_id ~= nil and LVL.hasPermission(user_id, "nhs.revive") then
        LVLclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = LVL.getUserId(nplayer)
            if nuser_id ~= nil then
                LVLclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        LVLclient.playAnim(player, {false, revive_seq, false}) -- anim
                        SetTimeout(15000, function()
                          TriggerClientEvent('Eclipse:FixPlayer',nplayer)
                          LVLclient.varyHealth(nplayer, 50) -- heal 50
                          LVLclient.notify(nplayer,{"~g~You have been revived by an NHS Member, free of charge"})
                          LVLclient.notify(player,{"~g~You revived someone, as a reward, here is £10,000 into your bank"})
                          LVL.giveBankMoney(player,10000)
                        end)
                    else
                        LVLclient.notify(player, {"~r~Player is alive and healthy"})
                    end
                end)
            else
                LVLclient.notify(player, {"~r~There is no player nearby"})
            end
        end)
    end
end)

RegisterServerEvent('Eclipse:HealPlayer')
AddEventHandler('Eclipse:HealPlayer', function()
    player = source
    local user_id = LVL.getUserId(player)
    if user_id ~= nil and LVL.hasPermission(user_id, "nhs.revive") then
        LVLclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = LVL.getUserId(nplayer)
            if nuser_id ~= nil then
                LVLclient.playAnim(player, {false, revive_seq, false}) -- anim
                SetTimeout(10000, function()
                    LVLclient.varyHealth(nplayer, 100) -- heal 100
                    LVLclient.notify(nplayer,{"~g~You have been healed by an NHS Member, free of charge"})
                    LVLclient.notify(player,{"~g~You healed someone, as a reward, here is £5,000 into your bank"})
                    LVL.giveBankMoney(player,5000)
                end)
            else
                LVLclient.notify(player, {"~r~There is no player nearby"})
            end
        end)
    end
end)