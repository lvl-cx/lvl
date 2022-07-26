function supporter(_, arg)
    print("^3User Has Bought Package! ^7")
	user_id = tonumber(arg[1])
    usource = ARMA.getUserSource(user_id)
    print(GetPlayerName(usource)..'['..user_id..'] has bought Supporter')
    ARMAclient.notify(usource, {"~g~You have purchased the Recruit Rank! ❤️"})
    ARMA.giveBankMoney(user_id, 1000000)
    ARMA.addUserGroup(user_id,"Supporter")    
end

function platinum(_, arg)
	user_id = tonumber(arg[1])
    usource = ARMA.getUserSource(user_id)
    print(GetPlayerName(usource)..'['..user_id..'] has bought Platinum')
    ARMAclient.notify(usource, {"~g~You have purchased the Platinum Rank! ❤️"})
    ARMA.giveBankMoney(user_id, 5000000)
    ARMA.addUserGroup(user_id,"Platinum")    
end

function godfather(_, arg)
	user_id = tonumber(arg[1])
    usource = ARMA.getUserSource(user_id)
    print(GetPlayerName(usource)..'['..user_id..'] has bought Godfather')
    ARMAclient.notify(usource, {"~g~You have purchased the Godfather Rank! ❤️"})
    ARMA.giveBankMoney(user_id, 10000000)
    ARMA.addUserGroup(user_id,"Godfather")
end

function underboss(_, arg)
	user_id = tonumber(arg[1])
    usource = ARMA.getUserSource(user_id)
    print(GetPlayerName(usource)..'['..user_id..'] has bought Underboss')
    ARMAclient.notify(usource, {"~g~You have purchased the Underboss Rank! ❤️"})
    ARMA.giveBankMoney(user_id, 20000000)
    ARMA.addUserGroup(user_id,"Underboss")
end

function moneybag(_, arg)
    user_id = tonumber(arg[1])
    usource = ARMA.getUserSource(user_id)
    print(GetPlayerName(usource)..'['..user_id..'] has bought a '..tostring(arg[2])..' Money Bag')
    ARMAclient.notify(usource, {"~g~You have purchased " .. tostring(arg[2]) .. " Money! ❤️"})
    ARMA.giveBankMoney(user_id, tonumber(arg[2]))
end


RegisterCommand("supporter", supporter, true)
RegisterCommand("platinum", platinum, true)
RegisterCommand("godfather", godfather, true)
RegisterCommand("underboss", underboss, true)
RegisterCommand("moneybag", moneybag, true)