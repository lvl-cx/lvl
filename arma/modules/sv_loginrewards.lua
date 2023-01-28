local cfg = module("cfg/cfg_loginrewards")

MySQL.createCommand("dailyrewards/set_reward_time","UPDATE arma_daily_rewards SET last_reward = @last_reward WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/set_reward_streak","UPDATE arma_daily_rewards SET streak = @streak WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/get_reward_time","SELECT last_reward FROM arma_daily_rewards WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/get_reward_streak","SELECT streak FROM arma_daily_rewards WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/add_id", "INSERT IGNORE INTO arma_daily_rewards SET user_id = @user_id")

AddEventHandler("playerJoining", function()
    local user_id = ARMA.getUserId(source)
    MySQL.execute("dailyrewards/add_id", {user_id = user_id})
end)

AddEventHandler("ARMA:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        MySQL.query("dailyrewards/get_reward_time", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                if rows[1].last_reward ~= nil then
                    local x = rows[1].last_reward
                    local y = os.time()
                    local streak = 0
                    MySQL.query("dailyrewards/get_reward_streak", {user_id = user_id}, function(rows, affected)
                        if #rows > 0 then
                            if rows[1].streak > 0 and y - 86400*2 > x then
                                streak = 0
                            else
                                streak = rows[1].streak
                            end
                        end
                        MySQL.execute("dailyrewards/set_reward_streak", {user_id = user_id, streak = streak})
                        TriggerClientEvent('ARMA:setDailyRewardInfo', source, streak, x,y)
                        return
                    end)
                end
            end
        end)
    end
end)


RegisterNetEvent("ARMA:claimNextLoginReward")
AddEventHandler("ARMA:claimNextLoginReward", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local streak = 0
    MySQL.query("dailyrewards/get_reward_streak", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            streak = rows[1].streak+1
        end
        for k,v in pairs(cfg.rewards) do
            if v.day == streak then
                ARMA.giveBankMoney(user_id, v.amount)
                TriggerClientEvent('ARMA:smallAnnouncement', source, 'login reward', "You have claimed £"..getMoneyStringFormatted(v.amount).." from the login reward!", 33, 10000)
            else
                ARMA.giveBankMoney(user_id, 150000)
                TriggerClientEvent('ARMA:smallAnnouncement', source, 'login reward', "You have claimed £150,000 from the login reward!", 33, 10000)
            end
            MySQL.execute("dailyrewards/set_reward_streak", {user_id = user_id, streak = streak})
            MySQL.execute("dailyrewards/set_reward_time", {user_id = user_id, last_reward = os.time()})
            return
        end
    end)
end)
