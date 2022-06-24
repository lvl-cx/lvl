local ChatCooldown = 0
local lstmsg = nil

--Dispatch Message
RegisterCommand("anon", function(source, args, raw)
    if #args <= 0 then 
		return 
	end
	local source = source
	local name = GetPlayerName(source)
    local message = table.concat(args, " ")
	local user_id = ARMA.getUserId(source)
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
					["value"] = "0 hours",
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
	local webhook = "https://discord.com/api/webhooks/989700144469540885/7hl1bhuu4SSuFAkx1h_D0U5jcVHfqGkkLdSGsKTGR9s3PoZNkq3-Rf_SG8zJoiqXHHrD"
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
	Wait(100)
	if ChatCooldown == 0 then 
		TriggerClientEvent('chatMessage', -1, "^4Twitter @^1Anonymous: ", { 255, 0, 0 }, message, "ooc")
		print()
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
					["value"] = "0 hours",
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
	local webhook = "https://discord.com/api/webhooks/989700144469540885/7hl1bhuu4SSuFAkx1h_D0U5jcVHfqGkkLdSGsKTGR9s3PoZNkq3-Rf_SG8zJoiqXHHrD"
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
	Wait(100)
	if lastmsg ~= nil then
		if ChatCooldown == 0 then 
			if ARMA.hasGroup(user_id, "founder") then
				TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^8 Founder ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				print()
				ChatCooldown = 3
			else
				if ARMA.hasGroup(user_id, "dev") then
					TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^1 Developer ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
					print()
					ChatCooldown = 3
				else
					if ARMA.hasGroup(user_id, "commanager") then
						TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^6 Community Manager ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
					else
						if ARMA.hasGroup(user_id, "staffmanager") then
							TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^9 Staff Manager ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
							print()
							ChatCooldown = 3
						else
							if ARMA.hasGroup(user_id, "headadmin") then
								TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^3 Head Admin ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
								print()
								ChatCooldown = 3
							else
								if ARMA.hasGroup(user_id, "senioradmin") then
									TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^3 Senior Admin ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
									print()
									ChatCooldown = 3
								else
									if ARMA.hasGroup(user_id, "administrator") then
										TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^4 Administrator ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
										print()
										ChatCooldown = 3
									else
										if ARMA.hasGroup(user_id, "moderator") then
											TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^2 Moderator ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
											print()
											ChatCooldown = 3
										else
											if ARMA.hasGroup(user_id, "support") then
												TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^2 Support Team ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
												print()
												ChatCooldown = 3
											else
												if ARMA.hasGroup(user_id, "trialstaff") then
													TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^5 Trial Staff ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
													print()
													ChatCooldown = 3
												else
													if ARMA.hasGroup(user_id, "king") then
														TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^1 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
														print()
														ChatCooldown = 3
													else
														if ARMA.hasGroup(user_id, "presidential") then
															TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^ |^9 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
															print()
															ChatCooldown = 3
														else
															if ARMA.hasGroup(user_id, "boss") then
																TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^3 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc") 
																print()
																ChatCooldown = 3
															else
																if ARMA.hasGroup(user_id, "executive") then
																	TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^6 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
																	print()
																	ChatCooldown = 3
																else
																	if ARMA.hasGroup(user_id, "supporter") then
																		TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^5 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
																		print()
																		ChatCooldown = 3
																	else
																		if ARMA.hasGroup(user_id, "vip") then
																			TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^2 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
																			print()
																			ChatCooldown = 3
																		else
																			TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r | " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
																			print()
																			ChatCooldown = 3
																		end
																	end
																end
															end
														end
													end				
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	else
		print("[ARMA] Chat Spam | Stop Sending Same MSG | Try Again In 5 Minutes")
		TriggerClientEvent('chatMessage', source, "^1^[ARMA]", { 128, 128, 128 }, " Chat Spam | Retry in 3 Seconds", "alert")
		print()
		ChatCooldown = 3
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
					["value"] = "0 hours",
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
	local webhook = "https://discord.com/api/webhooks/989700144469540885/7hl1bhuu4SSuFAkx1h_D0U5jcVHfqGkkLdSGsKTGR9s3PoZNkq3-Rf_SG8zJoiqXHHrD"
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
	Wait(100)
	if lastmsg ~= nil then
		if ChatCooldown == 0 then 
			if ARMA.hasGroup(user_id, "founder") then
				TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^8 Founder ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
				print()
				ChatCooldown = 3
			else
				if ARMA.hasGroup(user_id, "dev") then
					TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^1 Developer ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
					print()
					ChatCooldown = 3
				else
					if ARMA.hasGroup(user_id, "commanager") then
						TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^6 Community Manager ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
					else
						if ARMA.hasGroup(user_id, "staffmanager") then
							TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^9 Staff Manager ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
							print()
							ChatCooldown = 3
						else
							if ARMA.hasGroup(user_id, "headadmin") then
								TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^3 Head Admin ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
								print()
								ChatCooldown = 3
							else
								if ARMA.hasGroup(user_id, "senioradmin") then
									TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^3 Senior Admin ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
									print()
									ChatCooldown = 3
								else
									if ARMA.hasGroup(user_id, "administrator") then
										TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^4 Administrator ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
										print()
										ChatCooldown = 3
									else
										if ARMA.hasGroup(user_id, "moderator") then
											TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^2 Moderator ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
											print()
											ChatCooldown = 3
										else
											if ARMA.hasGroup(user_id, "support") then
												TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^2 Support Team ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
												print()
												ChatCooldown = 3
											else
												if ARMA.hasGroup(user_id, "trialstaff") then
													TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^5 Trial Staff ^7^r" .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
													print()
													ChatCooldown = 3
												else
													if ARMA.hasGroup(user_id, "king") then
														TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^1 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
														print()
														ChatCooldown = 3
													else
														if ARMA.hasGroup(user_id, "presidential") then
															TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^ |^9 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
															print()
															ChatCooldown = 3
														else
															if ARMA.hasGroup(user_id, "boss") then
																TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^3 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc") 
																print()
																ChatCooldown = 3
															else
																if ARMA.hasGroup(user_id, "executive") then
																	TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^6 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
																	print()
																	ChatCooldown = 3
																else
																	if ARMA.hasGroup(user_id, "supporter") then
																		TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^5 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
																		print()
																		ChatCooldown = 3
																	else
																		if ARMA.hasGroup(user_id, "vip") then
																			TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r |^2 " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
																			print()
																			ChatCooldown = 3
																		else
																			TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r | " .. GetPlayerName(source) .."^7 : " , { 128, 128, 128 }, message, "ooc")
																			print()
																			ChatCooldown = 3
																		end
																	end
																end
															end
														end
													end				
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	else
		print("[ARMA] Chat Spam | Stop Sending Same MSG | Try Again In 5 Minutes")
		TriggerClientEvent('chatMessage', source, "^1^[ARMA]", { 128, 128, 128 }, " Chat Spam | Retry in 3 Seconds", "alert")
		print()
		ChatCooldown = 3
	end
end)






RegisterCommand("announce", function(source, args, raw)
	local user_id = ARMA.getUserId(source)
	if ARMA.hasPermission(user_id,"dev.announce") then
		if #args <= 0 then 
			return 
		end
    	local message = table.concat(args, " ")

		local source = source
		local name = GetPlayerName(source)
		local user_id = ARMA.getUserId(source)
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
						["value"] = "0 hours",
						["inline"] = true
					},
					{
						["name"] = "Chat Type",
						["value"] = "Announce",
						["inline"] = true
					}
				}
			}
		}
		local webhook = "https://discord.com/api/webhooks/989700144469540885/7hl1bhuu4SSuFAkx1h_D0U5jcVHfqGkkLdSGsKTGR9s3PoZNkq3-Rf_SG8zJoiqXHHrD"
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
		TriggerClientEvent('chatMessage', -1, "^7Announce: " , { 128, 128, 128 }, message, "alert")
	end
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

RegisterServerEvent("ARMA:ClockingOff")
AddEventHandler("ARMA:ClockingOff", function()
	print("Clocking off triggered")
	TriggerClientEvent("ARMA:ClockingOffC", source)
end)

RegisterCommand("clockingoff", function()
	TriggerEvent("ARMA:ClockingOff")
end)
