-- Tebex functions need redoing to match
-- Supporter, Premium, Supreme, Kingpin, Rainmaker, Baller

function rank(_, arg)
	local user_id = tonumber(arg[1])
    local usource = ARMA.getUserSource(user_id)
    local rank = arg[2]
    print(user_id.." has bought "..rank.."! ^7")
    print(GetPlayerName(usource)..'['..user_id..'] has bought '..rank)
    ARMAclient.notify(usource, {"~g~You have purchased the "..rank.." Rank! ❤️"})
    ARMA.addUserGroup(user_id,rank)    
end

function moneybag(_, arg)
    user_id = tonumber(arg[1])
    usource = ARMA.getUserSource(user_id)
    print(GetPlayerName(usource)..'['..user_id..'] has bought a '..getMoneyStringFormatted(arg[2])..' Money Bag')
    ARMAclient.notify(usource, {"~g~You have purchased " .. getMoneyStringFormatted(arg[2]) .. " Money! ❤️"})
    ARMA.giveBankMoney(user_id, tonumber(arg[2]))
end

RegisterCommand("rank", rank, true)
RegisterCommand("moneybag", moneybag, true)