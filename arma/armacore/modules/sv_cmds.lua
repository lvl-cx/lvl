local ChatCooldown = 0
local lastmsg = nil

--Dispatch Message
RegisterCommand("anon", function(source, args, raw)
    if #args <= 0 then 
		return 
	end
	local source = source
	local name = GetPlayerName(source)
    local message = table.concat(args, " ")
	local user_id = ARMA.getUserId(source)
	local hours = math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0
	local command = {
		{
			["color"] = "16448403",
			["title"] = "ARMA Chat Logs",
			["description"] = "```"..message.."```",
			["text"] = "ARMA Server #1",
			["fields"] = {
				{
					["name"] = "Player Name",
					["value"] = GetPlayerName(source),
					["inline"] = true
				},
				{
					["name"] = "Player TempID",
					["value"] = source,
					["inline"] = true
				},
				{
					["name"] = "Player PermID",
					["value"] = user_id,
					["inline"] = true
				},
				{
					["name"] = "Player Hours",
					["value"] = hours,
					["inline"] = true
				},
				{
					["name"] = "Chat Type",
					["value"] = "Anon",
					["inline"] = true
				}
			}
		}
	}
	local webhook = "https://discord.com/api/webhooks/991455652524343416/S3vVK-a1pmRPVdYiF1fySi8JhL8wX-KY0OHNTEqsGV7OYeZrWmcN0V9lbQON5MMPPdnP"
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
	Wait(100)
	if ChatCooldown == 0 then 
		TriggerClientEvent('chatMessage', -1, "^4Twitter @^1Anonymous: ", { 255, 0, 0 }, message, "ooc")
		
		ChatCooldown = 3
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
	local hours = math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0
	lastmsg = message
	local command = {
		{
			["color"] = "16448403",
			["title"] = "ARMA Chat Logs",
			["description"] = "```"..lastmsg.."```",
			["text"] = "ARMA Server #1",
			["fields"] = {
				{
					["name"] = "Player Name",
					["value"] = GetPlayerName(source),
					["inline"] = true
				},
				{
					["name"] = "Player TempID",
					["value"] = source,
					["inline"] = true
				},
				{
					["name"] = "Player PermID",
					["value"] = user_id,
					["inline"] = true
				},
				{
					["name"] = "Player Hours",
					["value"] = hours,
					["inline"] = true
				},
				{
					["name"] = "Chat Type",
					["value"] = "OOC",
					["inline"] = true
				}
			}
		}
	}
	local webhook = "https://discord.com/api/webhooks/991455740776693761/AGLdsqRCe4vLSuWOhNHsmeYHBjmjZ-hS-Nf2caTPPwSdZ4mtgG6l0KBWRN7r-WdzWl6q"
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
	Wait(100)
	if lastmsg ~= nil then
		if ChatCooldown == 0 then 
			if ARMA.hasGroup(user_id, "founder") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^8 Founder ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 0
			elseif ARMA.hasGroup(user_id, "dev") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^1 Developer ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 0
			elseif ARMA.hasGroup(user_id, "commanager") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^6 Community Manager ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "staffmanager") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^9 Staff Manager ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "headadmin") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 Head Admin ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "senioradmin") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 Senior Admin ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "administrator") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^4 Administrator ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")		
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "moderator") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Moderator ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")				
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "support") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Support Team ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "trialstaff") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^5 Trial Staff ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "VIP") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^1 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "Recruit") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^ |^9 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "Soldier") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc") 
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "Warrior") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^6 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "Champion") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^5 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			else
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r | " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			end
		else
			TriggerClientEvent('chatMessage', source, "^1^[ARMA]", { 128, 128, 128 }, " Chat Spam | Retry in 3 Seconds", "alert")
			ChatCooldown = 3
		end
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
	local hours = math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0
	lastmsg = message
	local command = {
		{
			["color"] = "16448403",
			["title"] = "ARMA Chat Logs",
			["description"] = "```"..lastmsg.."```",
			["text"] = "ARMA Server #1",
			["fields"] = {
				{
					["name"] = "Player Name",
					["value"] = GetPlayerName(source),
					["inline"] = true
				},
				{
					["name"] = "Player TempID",
					["value"] = source,
					["inline"] = true
				},
				{
					["name"] = "Player PermID",
					["value"] = user_id,
					["inline"] = true
				},
				{
					["name"] = "Player Hours",
					["value"] = hours,
					["inline"] = true
				},
				{
					["name"] = "Chat Type",
					["value"] = "OOC",
					["inline"] = true
				}
			}
		}
	}
	local webhook = "https://discord.com/api/webhooks/991456257401683989/QXTyyOllOcMXwD8pu-aqQ6Jg6j0o1sQJ0R6wYItw1g7t8UiWtuQTdrtsNx4wc7swk_G7"
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
	Wait(100)
	if lastmsg ~= nil then
		if ChatCooldown == 0 then 
			if ARMA.hasGroup(user_id, "founder") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^8 Founder ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 0
			elseif ARMA.hasGroup(user_id, "dev") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^1 Developer ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 0
			elseif ARMA.hasGroup(user_id, "commanager") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^6 Community Manager ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "staffmanager") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^9 Staff Manager ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "headadmin") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 Head Admin ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "senioradmin") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 Senior Admin ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "administrator") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^4 Administrator ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")		
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "moderator") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Moderator ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")				
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "support") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Support Team ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "trialstaff") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^5 Trial Staff ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "VIP") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^1 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "Recruit") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^ |^9 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "Soldier") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc") 
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "Warrior") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^6 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			elseif ARMA.hasGroup(user_id, "Champion") then
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^5 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			else
				TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r | " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				ChatCooldown = 3
			end
		else
			TriggerClientEvent('chatMessage', source, "^1^[ARMA]", { 128, 128, 128 }, " Chat Spam | Retry in 3 Seconds", "alert")
			ChatCooldown = 3
		end
	end
end)



RegisterCommand('clear', function(source, args, rawCommand)
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'admin.ban') then
        TriggerClientEvent('chat:clear',-1)             
    else
        ARMAclient.notify(source,{"~r~You do not have permission to use this command."})
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

Citizen.CreateThread(function()
    while true do
        if ChatCooldown > 0 then
            ChatCooldown = ChatCooldown - 1
        end
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        if ChatCooldown > 0 then
            lastmsg = nil
        end
        Wait(1000)
    end
end)