local ChatCooldown = 0
local lstmsg = nil

--Dispatch Message
RegisterCommand("vpn", function(source, args, raw)
    if #args <= 0 then 
		return 
	end
	local source = source
	local name = GetPlayerName(source)
    local message = table.concat(args, " ")
	local user_id = ARMA.getUserId(source)
	local anonembeds = {
        {
            ["color"] = "270069",
            ["title"] = ""..name.." | VPN Chat Logs",
			["description"] = "**Name: **"..name.." \n**Perm ID: **"..user_id.."\n**Message: **"..message,
            ["footer"] = {
              ["text"] = "ARMA VPN Logs",
            }
        }
    }

	PerformHttpRequest("https://canary.discord.com/api/webhooks/852998905914720267/gOddyBcy-YYy0GcvvBxwOlmK66gxjWZVE4URzL2s8zdjarYbuoW_LmNxx4kWOKwUwZEz", function(err, text, headers) end, "POST", json.encode({username = "ARMA RP", embeds = anonembeds}), { ["Content-Type"] = "application/json" })
	Wait(100)
	if ChatCooldown == 0 then 
		TriggerClientEvent('chatMessage', -1, "VPN |", { 255, 0, 0 }, message, "vpn")
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
	local oocembeds = {
        {
            ["color"] = "270069",
            ["title"] = ""..name.." | OOC Chat Logs",
			["description"] = "**Name: **"..name.." \n**Perm ID: **"..user_id.."\n**Message: **"..message,
            ["footer"] = {
            ["text"] = "ARMA OOC Logs",
            }
        }
    }

	PerformHttpRequest("https://canary.discord.com/api/webhooks/852999162031112233/G3cFiB5pj6K2eAHTTbusrdFNHflSwaQGUEX0q1W3APDgqs5kOomNK1o5sHmRCsSpnKr6", function(err, text, headers) end, "POST", json.encode({username = "ARMA RP", embeds = oocembeds}), { ["Content-Type"] = "application/json" })
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
	local oocembeds = {
        {
            ["color"] = "270069",
            ["title"] = ""..name.." | OOC Chat Logs",
			["description"] = "**Name: **"..name.." \n**Perm ID: **"..user_id.."\n**Message: **"..message,
            ["footer"] = {
            ["text"] = "ARMA OOC Logs",
            }
        }
    }

	PerformHttpRequest("https://canary.discord.com/api/webhooks/852999162031112233/G3cFiB5pj6K2eAHTTbusrdFNHflSwaQGUEX0q1W3APDgqs5kOomNK1o5sHmRCsSpnKr6", function(err, text, headers) end, "POST", json.encode({username = "ARMA RP", embeds = oocembeds}), { ["Content-Type"] = "application/json" })
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
		local announceembed = {
			{
				["color"] = "270069",
				["title"] = ""..name.." | Announce Chat Logs",
				["description"] = "**Name: **"..name.." \n**Perm ID: **"..user_id.."\n**Message: **"..message,
				["footer"] = {
				["text"] = "ARMA OOC Logs",
				}
			}
		}
	
		PerformHttpRequest("https://canary.discord.com/api/webhooks/852999304694988830/fjhaX-HLKeS5PpKMswofPlbIUHbr-sY6ZFFtb0pQ2rPlffAeSG2N8QKsAsnXWOgIU_ET", function(err, text, headers) end, "POST", json.encode({username = "ARMA RP", embeds = announceembed}), { ["Content-Type"] = "application/json" })
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
