local cfg = module("cfg/cfg_loginrewards")

MySQL.createCommand("dailyrewards/set_reward_time","UPDATE oasis_daily_rewards SET last_reward = @last_reward WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/set_reward_streak","UPDATE oasis_daily_rewards SET streak = @streak WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/get_reward_time","SELECT last_reward FROM oasis_daily_rewards WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/get_reward_streak","SELECT streak FROM oasis_daily_rewards WHERE user_id = @user_id")
MySQL.createCommand("dailyrewards/add_id", "INSERT IGNORE INTO oasis_daily_rewards SET user_id = @user_id")

AddEventHandler("playerJoining", function()
    local user_id = OASIS.getUserId(source)
    MySQL.execute("dailyrewards/add_id", {user_id = user_id})
end)

AddEventHandler("OASIS:playerSpawn", function(user_id, source, first_spawn)
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
                        TriggerClientEvent('OASIS:setDailyRewardInfo', source, streak, x,y)
                        return
                    end)
                end
            end
        end)
    end
end)


RegisterNetEvent("OASIS:claimNextLoginReward")
AddEventHandler("OASIS:claimNextLoginReward", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    local streak = 0
    MySQL.query("dailyrewards/get_reward_streak", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            streak = rows[1].streak+1
        end
        for k,v in pairs(cfg.rewards) do
            if v.day == streak then
                OASIS.giveBankMoney(user_id, v.amount)
                TriggerClientEvent('OASIS:smallAnnouncement', source, 'login reward', "You have claimed £"..getMoneyStringFormatted(v.amount).." from the login reward!", 33, 10000)
                MySQL.execute("dailyrewards/set_reward_streak", {user_id = user_id, streak = streak})
                MySQL.execute("dailyrewards/set_reward_time", {user_id = user_id, last_reward = os.time()})
                return
            end
        end
        OASIS.giveBankMoney(user_id, 150000)
        TriggerClientEvent('OASIS:smallAnnouncement', source, 'login reward', "You have claimed £150,000 from the login reward!", 33, 10000)
        MySQL.execute("dailyrewards/set_reward_streak", {user_id = user_id, streak = streak})
        MySQL.execute("dailyrewards/set_reward_time", {user_id = user_id, last_reward = os.time()})
    end)
end)
