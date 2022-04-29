function chatlogs(source, msg, type)
	local source = source
	local player_id = ATM.getUserId(source)
	local player_name = GetPlayerName(source)
	local logs = "https://discord.com/api/webhooks/790968758088499220/R7G6CkcRJXpWAf1NXRj4eaLNdyUzVn339cn3-_aZ7fiCRrOfmlY2BxpWz0r7H2DSKCM0"
	local communtiylogo = "https://media.discordapp.net/attachments/772609930825957421/787302041194201098/oll.png" --Must end with .png or .jpg
	local curdate = os.time()
	local timestamp = os.date("%c", curdate)
	local communityname = "ATM Wrld Chat Logs | "..timestamp
	local command = {
		{
			["color"] = "8663711",
			["title"] = type,
			["description"] = "**Player Name - **"..player_name.."\n**Perm ID - **"..player_id.."\n**Message - **"..msg,
			["footer"] = {
			["text"] = communityname,
			["icon_url"] = communtiylogo,
			},
		}
	}
	PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "ATM Wrld Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
end



--Dispatch Message
RegisterCommand("anon", function(source, args, raw)
    if #args <= 0 then return end
    local message = table.concat(args, " ")
	TriggerClientEvent('chatMessage', -1, "^8^*Anonymous:^r", { 255, 0, 0 }, message)
	chatlogs(source, message, "Annon")
end)

--OOC Message
RegisterCommand("ooc", function(source, args, raw)
    if #args <= 0 then return end
    local message = table.concat(args, " ")
	TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r | " .. GetPlayerName(source) .." : " , { 128, 128, 128 }, message, "ooc")
	chatlogs(source, message, "OOC")
end)

RegisterCommand("/", function(source, args, raw)
    if #args <= 0 then return end
    local message = table.concat(args, " ")
	TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r | " .. GetPlayerName(source) .." : " , { 128, 128, 128 }, message, "ooc")
	chatlogs(source, message, "OOC")
end)

RegisterCommand("announce", function(source, args, raw)
	local source = source
	local user_id = ATM.getUserId(source)
	if ATM.hasPermission(user_id,"admin.menu") then
		if #args <= 0 then return end
    	local message = table.concat(args, " ")
		TriggerClientEvent('chatMessage', -1, "^7Announce: " , { 128, 128, 128 }, message, "alert")
		chatlogs(source, message, "Announce")
	end
end)


--Chat Proximity
AddEventHandler('chatMessage', function(source, name, message)
    if string.sub(message, 1, string.len("/")) ~= "/" then
        local name = GetPlayerName(source)
	TriggerClientEvent("sendProxMsg", -1, source, name, message)
    end
    CancelEvent()
end)

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
