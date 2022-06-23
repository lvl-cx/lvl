local lang = ARMA.lang

RegisterServerEvent('ARMA:OpenNHSMenu')
AddEventHandler('ARMA:OpenNHSMenu', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil and ARMA.hasPermission(user_id, "nhs.menu") then
        TriggerClientEvent("ARMA:NHSMenuOpened", source)
    elseif user_id ~= nil and ARMA.hasPermission(user_id, "clockon.nhs") then
    else
        print("You are not a part of the NHS")
    end
end)

local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

RegisterServerEvent('ARMA:PerformCPR')
AddEventHandler('ARMA:PerformCPR', function()
    player = source
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil and ARMA.hasPermission(user_id, "nhs.revive") then
        ARMAclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = ARMA.getUserId(nplayer)
            if nuser_id ~= nil then
                ARMAclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        ARMAclient.playAnim(player, {false, revive_seq, false}) -- anim
                        SetTimeout(15000, function()
                          TriggerClientEvent('ARMA:FixPlayer',nplayer)
                          ARMAclient.varyHealth(nplayer, 50) -- heal 50
                          ARMAclient.notify(nplayer,{"~g~You have been revived by an NHS Member, free of charge"})
                          ARMAclient.notify(player,{"~g~You revived someone, as a reward, here is £10,000 into your bank"})
                          ARMA.giveBankMoney(player,10000)
                        end)
                    else
                        ARMAclient.notify(player, {"~r~Player is alive and healthy"})
                    end
                end)
            else
                ARMAclient.notify(player, {"~r~There is no player nearby"})
            end
        end)
    end
end)

RegisterServerEvent('ARMA:HealPlayer')
AddEventHandler('ARMA:HealPlayer', function()
    player = source
    local user_id = ARMA.getUserId(player)
    if user_id ~= nil and ARMA.hasPermission(user_id, "nhs.revive") then
        ARMAclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = ARMA.getUserId(nplayer)
            if nuser_id ~= nil then
                ARMAclient.playAnim(player, {false, revive_seq, false}) -- anim
                SetTimeout(10000, function()
                    ARMAclient.varyHealth(nplayer, 100) -- heal 100
                    ARMAclient.notify(nplayer,{"~g~You have been healed by an NHS Member, free of charge"})
                    ARMAclient.notify(player,{"~g~You healed someone, as a reward, here is £5,000 into your bank"})
                    ARMA.giveBankMoney(player,5000)
                end)
            else
                ARMAclient.notify(player, {"~r~There is no player nearby"})
            end
        end)
    end
end)