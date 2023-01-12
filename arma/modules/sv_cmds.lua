local chatCooldown = {}
local lastmsg = nil

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
	local hours = math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60)
	if hours == nil then
		hours = 1
	end
	tARMA.sendWebhook('anon', "ARMA Chat Logs", "```"..message.."```".."\n> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
	Wait(100)
	if not chatCooldown[source] then 
		TriggerClientEvent('chatMessage', -1, "^4Twitter @^1Anonymous: ", { 128, 128, 128 }, message, "ooc")
		chatCooldown[source] = true
	end
end)

--OOC Message
RegisterCommand("ooc", function(source, args, raw)
    if #args <= 0 then 
		return 
	end
	local source = source
	local name = GetPlayerName(source)
    local message = table.concat(args, " ")
	local user_id = ARMA.getUserId(source)
	local hours = math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60)
	if hours == nil then
		hours = 1
	end
	tARMA.sendWebhook('ooc', "ARMA Chat Logs", "```"..message.."```".."\n> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
	Wait(100)
	if not chatCooldown[source] then 
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
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^ |^9 ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Platinum") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc") 
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Godfather") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^6 ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Underboss") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^5 ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		else
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r | ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		end
	else
		TriggerClientEvent('chatMessage', source, "^1[ARMA]", { 128, 128, 128 }, " Chat Spam | Retry in 3 Seconds", "alert")
		chatCooldown[source] = true
	end
end)

RegisterCommand("/", function(source, args, raw)
    if #args <= 0 then 
		return 
	end
	local source = source
	local name = GetPlayerName(source)
    local message = table.concat(args, " ")
	local user_id = ARMA.getUserId(source)
	local hours = math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60)
	if hours == nil then
		hours = 1
	end
	tARMA.sendWebhook('ooc', "ARMA Chat Logs", "```"..message.."```".."\n> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
	Wait(100)
	if not chatCooldown[source] then  
		if ARMA.hasGroup(user_id, "Founder") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^8 Founder ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			ChatCooldown = 0
		elseif ARMA.hasGroup(user_id, "Developer") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^1 Developer ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			ChatCooldown = 0
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
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^ |^9 ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Platinum") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc") 
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Godfather") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^6 ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		elseif ARMA.hasGroup(user_id, "Underboss") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^5 ^7" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		else
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r | " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
			chatCooldown[source] = true
		end
	else
		TriggerClientEvent('chatMessage', source, "^1[ARMA]", { 128, 128, 128 }, " Chat Spam | Retry in 3 Seconds", "alert")
		chatCooldown[source] = true
	end
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