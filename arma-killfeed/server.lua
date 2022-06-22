local Tunnel = module("arma", "lib/Tunnel")
local Proxy = module("arma", "lib/Proxy")
local ARMA = Proxy.getInterface("ARMA")
local ARMAclient = Tunnel.getInterface("ARMA","ARMA")

minCreds = 20
maxCreds = 60

-- Sync Deaths/Kills
RegisterNetEvent('KillFeed:Killed')
AddEventHandler('KillFeed:Killed', function(killer, weapon, killedCoords, killerCoords, inEvent, inWager)
    local distance = math.floor(#(killedCoords - killerCoords))
    local creditAmount = math.random(minCreds,maxCreds)
    local user_id = ARMA.getUserId({source})
    local killer_id = ARMA.getUserId({killer})

    killedGroup = "killed"
    killerGroup = "killer"

    TriggerClientEvent('KillFeed:AnnounceKill', -1, GetPlayerName(source), GetPlayerName(killer), weapon, distance, killedCoords, killerGroup, killedGroup)
    if inEvent then
        TriggerClientEvent('ARMA:eventKill', killer)
    elseif inWager then
        TriggerClientEvent('ARMA:wagerKill', killer, source)
    else 
        ARMA.giveBankMoney({killer_id, creditAmount})
        ARMAclient.notify(killer, {'~y~You have received '..getMoneyStringFormatted(creditAmount)..' credits for killing '..GetPlayerName(source)..'.'})
        TriggerClientEvent('ARMA:siphon', killer)
    end
    exports['ghmattimysql']:execute("SELECT * FROM `ARMA_leaderboard` WHERE user_id = @killer_id", {killer_id = killer_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                if v.user_id == killer_id then
                    kills = v.kills + 1
                    exports['ghmattimysql']:execute("UPDATE ARMA_leaderboard SET kills = @kills WHERE user_id = @killer_id", {killer_id = killer_id, kills = kills}, function() end)
                    return
                end
            end
            exports['ghmattimysql']:execute("INSERT INTO ARMA_leaderboard (`user_id`, `kills`) VALUES (@killer_id, @kills);", {killer_id = killer_id, kills = 1}, function() end) 
        end
    end)
    exports['ghmattimysql']:execute("SELECT * FROM `ARMA_leaderboard` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                if v.user_id == user_id then
                    deaths = v.deaths + 1
                    exports['ghmattimysql']:execute("UPDATE ARMA_leaderboard SET deaths = @deaths WHERE user_id = @user_id", {user_id = user_id, deaths = deaths}, function() end)
                    return
                end
            end
            exports['ghmattimysql']:execute("INSERT INTO ARMA_leaderboard (`user_id`, `deaths`) VALUES (@user_id, @deaths);", {user_id = user_id, deaths = 1}, function() end) 
        end
    end)
end)

RegisterNetEvent('KillFeed:Died')
AddEventHandler('KillFeed:Died', function(coords)
    local user_id = ARMA.getUserId({source})
    killedGroup = "killed"
    TriggerClientEvent('KillFeed:AnnounceDeath', -1, GetPlayerName(source), coords, killedGroup)
end)

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

print("[ARMA] - Killfeed initialised.")