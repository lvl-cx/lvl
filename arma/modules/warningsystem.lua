--(Thanks to Rubbertoe98) (https://github.com/rubbertoe98/FiveM-Scripts/tree/master/arma_punishments) for the original script.
-- Edits by JamesUK#6793 (to support js ghmatti version)



RegisterCommand('sw', function(player, args)
    local user_id = ARMA.getUserId(player)
    local permID =  tonumber(args[1])
    if permID ~= nil then
        if ARMA.hasPermission(user_id,"admin.showwarn") then
            armawarningstables = getarmaWarnings(permID,player)
            TriggerClientEvent("arma:showWarningsOfUser",player,armawarningstables)
        end
    end
end)


	
function getarmaWarnings(user_id,source) 
	armawarningstables = exports['ghmattimysql']:executeSync("SELECT * FROM arma_warnings WHERE user_id = @uid", {uid = user_id})
	for warningID,warningTable in pairs(armawarningstables) do
		date = warningTable["warning_date"]
		newdate = tonumber(date) / 1000
		newdate = os.date('%Y-%m-%d', newdate)
		warningTable["warning_date"] = newdate
	end
	return armawarningstables
end

RegisterServerEvent("arma:refreshWarningSystem")
AddEventHandler("arma:refreshWarningSystem",function()
	local source = source
	local user_id = ARMA.getUserId(source)	
	armawarningstables = getarmaWarnings(user_id,source)
	TriggerClientEvent("arma:recievedRefreshedWarningData",source,armawarningstables)
end)

RegisterServerEvent("arma:warnPlayer")
AddEventHandler("arma:warnPlayer",function(target_id,warningReason)
	local source = source
	local user_id = ARMA.getUserId(source)
	local targetSource = ARMA.getUserSource(target_id)
    local adminName = GetPlayerName(source)
	if ARMA.hasPermission(user_id,"admin.warn") then
		warning = "Warning"
		warningDate = getCurrentDate()
		local command = {
			{
				["color"] = "16448403",
				["title"] = "ARMA Admin Logs",
				["description"] = "",
				["text"] = "ARMA Server #1",
				["fields"] = {
					{
						["name"] = "Admin Name",
						["value"] = GetPlayerName(source),
						["inline"] = true
					},
					{
						["name"] = "Admin TempID",
						["value"] = source,
						["inline"] = true
					},
					{
						["name"] = "Admin PermID",
						["value"] = user_id,
						["inline"] = true
					},
					{
						["name"] = "Player Name",
						["value"] = GetPlayerName(targetSource),
						["inline"] = true
					},
					{
						["name"] = "Player TempID",
						["value"] = targetSource,
						["inline"] = true
					},
					{
						["name"] = "Player PermID",
						["value"] = target_id,
						["inline"] = true
					},
					{
						["name"] = "Player Hours",
						["value"] = "0 hours",
						["inline"] = true
					},
					{
						["name"] = "Warn Reason",
						["value"] = warningReason,
						["inline"] = true
					}
				}
			}
		}
		local webhook = "https://discord.com/api/webhooks/991561080142831696/iF0P7cQJf3FPV1wr_gg9IeM2aQsBFBrD1EdM1NueaScLEN0DTipfAlTjb56l7k3IVS_n"
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
		f10Warn(target_id, adminName, warningReason)
		ARMAclient.notify(targetSource, {'~r~You have received a warning for '..warningReason})
	else
		ARMAclient.notify(source,{"~r~You do not have permissions to warn."})
	end
end)

function f10Warn(target_id,adminName,warningReason)
	warning = "Warning"
	warningDate = getCurrentDate()
	exports['ghmattimysql']:execute("INSERT INTO arma_warnings (`user_id`, `warning_type`, `admin`, `warning_date`, `reason`) VALUES (@user_id, @warning_type, @admin, @warning_date,@reason);", {user_id = target_id, warning_type = warning, admin = adminName, warning_date = warningDate, reason = warningReason}, function() end)
end

function f10Kick(target_id,adminName,warningReason)
	warning = "Kick"
	warningDate = getCurrentDate()
	exports['ghmattimysql']:execute("INSERT INTO arma_warnings (`user_id`, `warning_type`, `admin`, `warning_date`, `reason`) VALUES (@user_id, @warning_type, @admin, @warning_date,@reason);", {user_id = target_id, warning_type = warning, admin = adminName, warning_date = warningDate, reason = warningReason}, function() end)
end

function f10Ban(target_id,adminName,warningReason,warning_duration,warning_points)
	warning = "Ban"
	warningDate = getCurrentDate()
	exports['ghmattimysql']:execute("INSERT INTO arma_warnings (`user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`, `points`) VALUES (@user_id, @warning_type, @duration, @admin, @warning_date,@reason,@points);", {user_id = target_id, warning_type = warning, admin = adminName, duration = warning_duration, warning_date = warningDate, reason = warningReason, points=warning_points}, function() end)
end


function getCurrentDate()
	date = os.date("%Y/%m/%d")
	return date
end
