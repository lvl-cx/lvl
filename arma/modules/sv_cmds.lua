local chatCooldown = {}
local lastmsg = nil
local blockedWords = {
	"nigger", 
	"nigga", 
	"wog", 
	"coon", 
	"paki",
	"faggot",
	"anal",
	"kys",
	"homosexual",
	"lesbian",
	"suicide",
	"negro",
	"queef",
	"queer",
	"allahu akbar",
	"terrorist",
	"wanker",
	"n1gger",
	"f4ggot",
	"n0nce",
	"d1ck",
	"h0m0",
	"n1gg3r",
	"h0m0s3xual",
	"nazi",
	"hitler"}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		for k,v in pairs(chatCooldown) do
			chatCooldown[k] = nil
		end
	end
end)

--Dispatch Message
RegisterCommand("anon", function(source, args, raw)
    if #args <= 0 then 
		return 
	end
	local source = source
	local name = GetPlayerName(source)
    local message = table.concat(args, " ")
	local user_id = ARMA.getUserId(source)
	if not chatCooldown[source] then 
		for word in pairs(blockedWords) do
			if(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(message:lower(), "-", ""), ",", ""), "%.", ""), " ", ""), "*", ""), "+", ""):find(blockedWords[word])) then
				TriggerClientEvent('ARMA:chatFilterScaleform', source, 10, 'That word is not allowed.')
				CancelEvent()
				return
			end
		end
		tARMA.sendWebhook('anon', "ARMA Chat Logs", "```"..message.."```".."\n> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
		TriggerClientEvent('chatMessage', -1, "^4Twitter @^1Anonymous: ", { 128, 128, 128 }, message, "ooc")
		chatCooldown[source] = true
	end
end)

function tARMA.ooc(source, args, raw)
	if #args <= 0 then 
		return 
	end
	local source = source
	local name = GetPlayerName(source)
	local message = table.concat(args, " ")
	local user_id = ARMA.getUserId(source)
	if not chatCooldown[source] then 
		for word in pairs(blockedWords) do
			if(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(message:lower(), "-", ""), ",", ""), "%.", ""), " ", ""), "*", ""), "+", ""):find(blockedWords[word])) then
				TriggerClientEvent('ARMA:chatFilterScaleform', source, 10, 'That word is not allowed.')
				CancelEvent()
				return
			end
		end
		if ARMA.hasGroup(user_id, "Founder") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^8 Founder ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
		elseif ARMA.hasGroup(user_id, "Developer") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^1 Developer ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
		elseif ARMA.hasGroup(user_id, "Community Manager") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^6 Community Manager ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Staff Manager") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^9 Staff Manager ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Head Admin") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 Head Admin ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Senior Admin") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 Senior Admin ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Admin") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^4 Administrator ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")		
			chatCooldown[source] = true			
		elseif ARMA.hasGroup(user_id, "Senior Mod") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Senior Mod ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")				
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Moderator") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Moderator ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")				
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Support Team") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Support Team ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Trial Staff") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^5 Trial Staff ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Supporter") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^2" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Premium") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^6" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Supreme") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^5" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Kingpin") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^1" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Rainmaker") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^4" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Baller") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^3" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		else
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		end
		tARMA.sendWebhook('ooc', "ARMA Chat Logs", "```"..message.."```".."\n> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
	else
		TriggerClientEvent('chatMessage', source, "^1[ARMA]", { 128, 128, 128 }, " Chat Spam | Retry in 3 Seconds", "alert")
		chatCooldown[source] = true
	end
end

RegisterCommand("ooc", function(source, args, raw)
    tARMA.ooc(source, args, raw)
end)

RegisterCommand("/", function(source, args, raw)
    tARMA.ooc(source, args, raw)
end)



RegisterCommand('cc', function(source, args, rawCommand)
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.ban') then
        TriggerClientEvent('chat:clear',-1)             
    end
end, false)


--Function
function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end