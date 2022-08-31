RegisterNetEvent('KillFeed:Killed')
AddEventHandler('KillFeed:Killed', function(killer, weapon, killedCoords, killerCoords, inEvent, inWager)
    local distance = math.floor(#(killedCoords - killerCoords))
    local creditAmount = math.random(minCreds,maxCreds)
    local user_id = ARMA.getUserId(source)
    local killer_id = ARMA.getUserId(killer)

    killedGroup = "killed"
    killerGroup = "killer"

    TriggerClientEvent('KillFeed:AnnounceKill', -1, GetPlayerName(source), GetPlayerName(killer), weapon, distance, killedCoords, killerGroup, killedGroup)
end)

RegisterNetEvent('KillFeed:Died')
AddEventHandler('KillFeed:Died', function(coords)
    local user_id = ARMA.getUserId(source)
    killedGroup = "killed"
    TriggerClientEvent('KillFeed:AnnounceDeath', -1, GetPlayerName(source), coords, killedGroup)
end)

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

print("[ARMA] ^2Killfeed tables initialised.^0")
